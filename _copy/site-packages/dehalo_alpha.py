# dehalo_alpha.py (2012-12-03)
# Dependencies: mt_masktools.dll (avs)
#		RemoveGrain.dll (avs)
#		RemoveGrainHD.dll (avs)
#		Repair.dll (avs)
#		fmtconv.dll (vs)

import vapoursynth as vs

def clamp(minimum, x, maximum):
	return int(max(minimum, min(round(x), maximum)))

def m4(x):
	exp = lambda x: 16 if x < 16 else int(round(x / 4.0) * 4)
	return exp(x)

class InvalidArgument(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)

class DeHalo_alpha(object):
	def __init__(self, core):
		self.std       = core.std
		self.repair    = core.avs.Repair
		self.rgrain    = core.avs.RemoveGrain
		self.quantile  = core.avs.Quantile
		self.expand    = core.avs.mt_expand
		self.inpand    = core.avs.mt_inpand
		self.defalte   = core.avs.mt_deflate
		self.inflate   = core.avs.mt_inflate
		self.awarp2    = core.avs.aWarpSharp2
		self.resample  = core.fmtc.resample
		self.bitdepth  = core.fmtc.bitdepth
		self.lut_range = None
		self.max       = 0
		self.mid       = 0
	
	def mt_lutxy(self, c1, c2, expr, planes=0):
		lut = []
		for y in self.lut_range:
			for x in self.lut_range:
				lut.append(clamp(0, expr(x, y), self.max))
		return self.std.Lut2([c1, c2], lut, planes)
	
	def mt_logic(self, c1, c2, mode, th1=0, th2=0, planes=0):
		if mode == 'min':
			expr = lambda x, y: min(x + th1, y + th2)
		elif mode == 'max':
			expr = lambda x, y: max(x + th1, y + th2)
		else:
			raise InvalidArgument('%s is not a valid mode for mt_logic' % mode)
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def mt_makediff(self, c1, c2, planes=0):
		expr = lambda x, y: x - y + self.mid
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def minblur(self, clp, r=1, planes=0):
		r = clamp(1, r, 3)
		if planes is not 0:
			rg4, rg11, rg20, uvm2, uvm3 = 4, 11, 20, 2, 3
		else:
			rg4 = rg11 = rg20 = uvm2 = uvm3 = -1
		
		self.max       = 2 ** clp.format.bits_per_sample - 1
		self.mid       = self.max // 2 + 1
		self.lut_range = range(self.max + 1)
		
		if r == 1:
			RG11D = self.mt_makediff(clp, self.rgrain(clp, 11, rg11), planes=planes)
			RG4D  = self.mt_makediff(clp, self.rgrain(clp, 4, rg4), planes=planes)
		elif r == 2:
			RG11D = self.mt_makediff(clp, self.rgrain(self.rgrain(clp, 11, rg11), 20, rg20), planes=planes)
			RG4D  = self.mt_makediff(clp, self.quantile(clp, radius_y=2, radius_u=uvm2, radius_v=uvm2), planes=planes)
		else:
			RG11D = self.mt_makediff(clp, self.rgrain(self.rgrain(self.rgrain(clp, 11, rg11), 20, rg20), 20, rg20), planes=planes)
			RG4D  = self.mt_makediff(clp, self.quantile(clp, radius_y=3, radius_u=uvm3, radius_v=uvm3), planes=planes)
		
		expr = lambda x, y: self.mid if ((x - self.mid) * (y - self.mid)) < 0 else (x if abs(x - self.mid) < abs(y - self.mid) else y)
		DD   = self.mt_lutxy(RG11D, RG4D, expr, planes=planes)
		
		return self.mt_makediff(clp, DD, planes=planes)

	def dehalo_alpha(self, src, rx=2.0, ry=2.0, darkstr=1.0, brightstr=1.0, lowsens=50, highsens=50, ss=1.5):
		his  = highsens / 100.0
		ox   = src.width
		oy   = src.height
		
		if src.format.id != vs.YUV420P8:
			src = self.bitdepth(clip=src, csp=vs.YUV420P8)
			
		self.max       = 2 ** src.format.bits_per_sample - 1
		self.mid       = self.max // 2 + 1
		self.lut_range = range(self.max + 1)
		
		this   = self.resample(clip=src, w=m4(ox/rx), h=m4(oy/ry), kernel='bicubic')
		halos  = self.bitdepth(clip=self.resample(clip=this, w=ox, h=oy, kernel='bicubic', a1=1, a2=0), csp=vs.YUV420P8)
		are    = self.mt_lutxy(c1=self.expand(c1=src, U=1, V=1), c2=self.inpand(c1=src, U=1, V=1), expr=lambda x, y: x - y)
		ugly   = self.mt_lutxy(c1=self.expand(c1=halos, U=1, V=1), c2=self.inpand(c1=halos, U=1, V=1), expr=lambda x, y: x - y)
		so     = self.mt_lutxy(c1=ugly, c2=are, expr=lambda x, y: ((((y - x) / (y + 0.001)) * 255) - lowsens) * (((y + 256) / 512) + his))
		lets   = self.std.MaskedMerge(clips=[halos, src], mask=so)
		if ss == 1:
			remove = self.repair(c1=src, c2=lets, mode=1, modeU=0)
		else:
			remove = self.bitdepth(clip=self.resample(clip=src, w=m4(ox*ss), h=m4(oy*ss)), csp=vs.YUV420P8)
			remove = self.mt_logic(c1=remove, c2=self.bitdepth(clip=self.resample(clip=self.expand(c1=lets, U=1, V=1), w=m4(ox*ss), h=m4(oy*ss)), csp=vs.YUV420P8), mode='min')
			remove = self.mt_logic(c1=remove, c2=self.bitdepth(clip=self.resample(clip=self.inpand(c1=lets, U=1, V=1), w=m4(ox*ss), h=m4(oy*ss)), csp=vs.YUV420P8), mode='max')
			remove = self.bitdepth(clip=self.resample(clip=remove, w=ox, h=oy), csp=vs.YUV420P8)
		them   = self.mt_lutxy(c1=src, c2=remove, expr=lambda x, y: x - ((x - y) * darkstr) if x < y else x - ((x - y) * brightstr))
		
		return them
	
	def yahr(self, src):
		if src.format.id != vs.YUV420P8:
			src = self.bitdepth(clip=src, csp=vs.YUV420P8)
		
		b1    = self.rgrain(self.minblur(src, 2), 11, -1)
		b1D   = self.mt_makediff(src, b1)
		w1    = self.awarp2(c1=src, depth=32, blur=2, thresh=128)
		w1b1  = self.rgrain(self.minblur(w1, 2), 11, -1)
		w1b1D = self.mt_makediff(w1, w1b1)
		DD    = self.repair(b1D, w1b1D, 13) 
		DD2   = self.mt_makediff(b1D, DD)
		
		return self.std.Merge([src, self.mt_makediff(src, DD2)], weight=[1, 0])
		
	def usage(self):
		usage = '''
		Reduce halo artifacts that can occur when sharpening. Ported from:
		http://forum.doom9.org/showpost.php?p=738264&postcount=43
		
		Input must be vs.YUV420P8, if not, it will be automatically converted.
		
		dehalo_alpha(src, rx=2.0, ry=2.0, darkstr=1.0, brightstr=1.0,
			lowsens=50, highsens=50, ss=1.5)
			rx, ry [float, 1.0 ... 2.0 ... ~3.0]
				As usual, the radii for halo removal.
				Note: this function is rather sensitive to 
				the radius settings. Set it as low as possible! 
				If radius is set too high, it will start missing small spots.
			darkstr, brightstr [float, 0.0 ... 1.0] [<0.0 and >1.0 possible]
				The strength factors for processing
				dark and bright halos. Default 1.0 both for
				symmetrical processing. On Comic/Anime, 
				darkstr=0.4~0.8 sometimes might be better... sometimes.
				In General, the function seems to preserve
				dark lines rather well.
			lowsens, highsens [int, 0 ... 50 ... 100] 
				Sensitivity settings, not that easy to describe
				them exactly ... in a sense, they define a window
				between how weak an achieved effect has to be to 
				get fully accepted, and how strong an achieved
				effect has to be to get fully discarded. 
				Defaults are 50 and 50 ... try and see for yourself. 
			ss [float, 1.0 ... 1.5 ...]
				Supersampling factor, to avoid creation of aliasing.
		
		And Y'et A'nother H'alo R'educing function. Ported from:
		http://forum.doom9.org/showpost.php?p=1205653&postcount=9
		
		yahr(src)
		'''
		return usage
