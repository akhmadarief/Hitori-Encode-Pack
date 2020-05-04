import vapoursynth as vs
import havsfunc as haf
import mvsfunc as mvs

__no_chroma = (0,)

### MASK HELPERS ###
__square = (1, 1, 1, 1, 1, 1, 1, 1)
__horizontal = (0, 0, 0, 1, 1, 0, 0, 0)
__vertical = (0, 1, 0, 0, 0, 0, 1, 0)
__both = (0, 1, 0, 1, 1, 0, 1, 0)

RECTANGLE = 0
ELLIPSE = 1
LOSANGE = 2

def default(value, default_value):
    if value is None:
        return default_value
    return value

def _mk_coordinates_list(sw, sh, mode=RECTANGLE):
    assert sw >= 0 and sh >= 0, "sw, sh: must be > 0"
    assert 0 <= mode <= 2, "mode: 0 - rectangle, 1 - ellipse, 2 - losange"
    
    clist = []
    while sw > 0 or sh > 0:
        if sw > 0 and sh > 0:
            if mode == 2 or (mode == 1 and (sw % 3) != 1):
                coordinates = __both
            else:
                coordinates = __square
        elif sw > 0:
            coordinates = __horizontal
        elif sh > 0:
            coordinates = __vertical
        sw -= 1
        sh -= 1
        clist.append(coordinates)
    return clist

# mode: 0 to inpand, 1 to expand
def _xxpand(clip, xxpand_mode, sw=1, sh=None, thr=255, mode=RECTANGLE, planes=(0,1,2)):
    core = vs.get_core()
    
    sh = default(sh, sw)  # sh == sw if sh is not explicitly set
    
    assert xxpand_mode in (0, 1), "mode: 0 to inpand, 1 to expand"
    assert 0 <= thr <= 255, "thr: must be 0-255"
    assert sw >= 0, "sw: must be positive int"
    assert sh >= 0, "sh: must be positive int"

    thr = haf.scale(thr, clip.format.bits_per_sample)
    func = core.std.Minimum if xxpand_mode == 0 else core.std.Maximum

    out = clip
    for coordinates in _mk_coordinates_list(sw, sh, mode=mode):
        out = func(out, planes=planes, threshold=thr, coordinates=coordinates)
    return out
    
def inpand(clip, *args, **kwargs):
    return _xxpand(clip, 0, *args, **kwargs)
    
def expand(clip, *args, **kwargs):
    return _xxpand(clip, 1, *args, **kwargs)

def fine_dehalo(clip, rx=2.0, ry=None, thmi=80, thma=128, thlimi=50, thlima=100, darkstr=1.0, brightstr=1.0, lowsens=50, highsens=50, ss=1.25, showmask=0, contra=False, excl=True, edgeproc=0.0):
    core = vs.get_core()
    
    bits = clip.format.bits_per_sample
    smax = haf.scale(255, bits)

    thmi = haf.scale(thmi, bits)    
    thma = haf.scale(thma, bits)
    thlimi = haf.scale(thlimi, bits)
    thlima = haf.scale(thlima, bits)
        
    ry = default(ry, rx)
    rx_i = int(round(rx))
    ry_i = int(round(ry))
    
    dehaloed = haf.DeHalo_alpha(clip, rx=rx, ry=ry, darkstr=darkstr, brightstr=brightstr, lowsens=lowsens, highsens=highsens, ss=ss)
    # Contrasharpening
    if contra:
        dehaloed = haf.ContraSharpening(dehaloed, clip)
    
    ### Main edges ###
    
    # Basic edge detection, thresholding will be applied later.

    edges = core.std.Prewitt(clip, planes=__no_chroma)
    # Keeps only the sharpest edges (line edges)
    _strong_expr = "x {thmi} - {thmdiff} / {smax} *".format(thmi=thmi, thmdiff=(thma-thmi), smax=smax)
    strong = core.std.Expr([edges], expr=(_strong_expr, "", ""))
    
    # Extends them to include the potential halos
    large = expand(strong, rx_i, ry_i, planes=__no_chroma)
    
    ### Exclusion zones ###
    
    # When two edges are close from each other (both edges of a single
    # line or multiple parallel color bands), the halo removal
    # oversmoothes them or makes seriously bleed the bands, producing
    # annoying artifacts. Therefore we have to produce a mask to exclude
    # these zones from the halo removal.
    
    # Includes more edges than previously, but ignores simple details
    _light_expr = "x {thlimi} - {thlimdiff} / {smax} *".format(thlimi=thlimi, thlimdiff=(thlima-thlimi), smax=smax)
    light = core.std.Expr([edges], expr=(_light_expr, "", ""))
    
    # To build the exclusion zone, we make grow the edge mask, then shrink
    # it to its original shape. During the growing stage, close adjacent
    # edge masks will join and merge, forming a solid area, which will
    # remain solid even after the shrinking stage.
    # Mask growing
    shrink = expand(light, sw=rx_i, sh=ry_i, mode=ELLIPSE, planes=__no_chroma)
    
    # At this point, because the mask was made of a shades of grey, we may
    # end up with large areas of dark grey after shrinking. To avoid this,
    # we amplify and saturate the mask here (actually we could even
    # binarize it).
    
    shrink = core.std.Expr([shrink], expr=("x 4 *", "", ""))
    shrink = inpand(shrink, sw=rx_i, sh=rx_i, mode=ELLIPSE, planes=__no_chroma)
    
    # This mask is almost binary, which will produce distinct
    # discontinuities once applied. Then we have to smooth it.
    shrink = core.rgvs.RemoveGrain(shrink, mode=(20, 0))
    shrink = core.rgvs.RemoveGrain(shrink, mode=(20, 0))
    
    ### Final mask building ###

    # Previous mask may be a bit weak on the pure edge side, so we ensure
    # that the main edges are really excluded. We do not want them to be
    # smoothed by the halo removal.
    if excl:
        shr_med = core.std.Expr([strong, shrink], expr=("x y max", "", ""))
    else:
        shr_med = strong

    # Substracts masks and amplifies the difference to be sure we get 255
    # on the areas to be processed.     
    mask = core.std.Expr([large, shr_med], expr=("x y - 2 *", "", ""))
    
    # If edge processing is required, adds the edgemask
    if edgeproc > 0:
        _eproc_expr = "x y {eproc} * +".format(eproc=(edgeproc * 0.66))
        mask = core.std.Expr([mask, strong], expr=(_eproc_expr, "", ""))
        
    # Smooth again and amplify to grow the mask a bit, otherwise the halo
    # parts sticking to the edges could be missed.
    mask = core.rgvs.RemoveGrain(mask, (20, 0))
    mask = core.std.Expr([mask], expr=("x 2 *", "", ""))
    
    ### Masking ###
    if showmask == 1:
        return mvs.GrayScale(mask)
    elif showmask == 2:
        return mvs.GrayScale(shrink)
    elif showmask == 3:
        return mvs.GrayScale(edges)
    elif showmask == 4:
        return mvs.GrayScale(strong)
    elif showmask == 5:
        return mvs.GrayScale(light)
    elif showmask == 6:
        return mvs.GrayScale(large)
    elif showmask == 7:
        return mvs.GrayScale(shr_med)
    return core.std.MaskedMerge(clip, dehaloed, mask, planes=__no_chroma, first_plane=True)