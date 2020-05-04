# EdgeCleaner.py (2012-12-03)
# Dependencies: RemoveGrain.dll (avs)
#		repair.dll (avs)
#		mt_masktools-25.dll (avs)
#		deen.dll (avs)
#		avisynthfilters.dll (avs)
#		aWarpSharp2.dll (avs)

import vapoursynth as vs

def clamp(minimum, x, maximum):
	return int(max(minimum, min(round(x), maximum)))

class EdgeCleaner(object):
	def __init__(self, core):
		self.rgrain    = core.avs.RemoveGrain
		self.repair    = core.avs.Repair
		self.expand    = core.avs.mt_expand
		self.inpand    = core.avs.mt_inpand
		self.edge      = core.avs.mt_edge
		self.conv      = core.avs.mt_convolution
		self.circle    = core.avs.mt_circle
		self.defl      = core.avs.mt_deflate
		self.levels    = core.avs.Levels
		self.awarp2    = core.avs.aWarpSharp2
		self.deen      = core.avs.deen
		self.point     = core.resize.Point
		self.std       = core.std
		self.lut_range = None
		self.max       = 0
		self.mid       = 0
	
	def mt_lut(self, c1, expr, planes=0):
		lut = [clamp(0, expr(x), self.max) for x in self.lut_range]
		return self.std.Lut(c1, lut, planes)
	
	def mt_invert(self, c1, planes=0):
		expr = lambda x: 255 - x
		return self.mt_lut(c1, expr, planes)
	
	def mt_lutxy(self, c1, c2, expr, planes=0):
		lut = []
		for y in self.lut_range:
			for x in self.lut_range:
				lut.append(clamp(0, expr(x, y), self.max))
		return self.std.Lut2([c1, c2], lut, planes)
	
	def mt_makediff(self, c1, c2, planes=0):
		expr = lambda x, y: x - y + self.mid
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def subtract(self, c1, c2, luma=126, planes=0):
		expr = lambda x, y: luma + x - y
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def starmask(self, src, mode=1):
		self.max = 2 ** src.format.bits_per_sample - 1
		self.mid = self.max // 2 + 1
		self.lut_range = range(self.max + 1)
		
		if mode == 1:
			clean = self.rgrain(src, 17)
			diff  = self.mt_makediff(src, clean)
			final = self.point(self.std.ShufflePlanes(diff, 0, vs.GRAY), format=vs.YUV420P8)
			final = self.levels(final, 40, 0.350, 168, 0, 255)
			final = self.rgrain(final, 7, -1)
			final = self.edge(final, 'prewitt', 4, 16, 4, 16)
		else:
			clean  = self.rgrain(self.repair(self.deen(src, 'a3d', 4, 12, 0), src, 15), 21)
			pmask  = self.mt_invert(self.expand(self.edge(src, 'roberts', 0, 2, 0, 2), mode=self.circle(1)))
			fmask  = self.std.MaskedMerge([clean, src], pmask)
			subt   = self.subtract(fmask, src)
			final  = self.defl(self.edge(subt, 'roberts', 0, 0, 0, 0))
		
		return final

	def edgecleaner(self, src, strength=16, rep=True, rmode=17, smode=0, hot=False):
		smode = clamp(0, smode, 2)
		if src.format.id != vs.YUV420P8:
			src = self.bitdepth(clip=src, csp=vs.YUV420P8)
		
		self.max = 2 ** src.format.bits_per_sample - 1
		self.mid = self.max // 2 + 1
		self.lut_range = range(self.max + 1)
		
		if smode != 0: strength = strength + 4
		
		main = self.awarp2(c1=src, depth=strength/2, blur=1)
		if rep == True: main = self.repair(main, src, rmode)
		
		mask  = self.conv(self.mt_invert(self.edge(src, 'prewitt', 4, 32, 4, 32)))
		
		final = self.std.MaskedMerge([src, main], mask, planes=0)
		
		if hot == True: final = self.repair(final, src, 2)

		if smode != 0:
			stmask = self.starmask(src, smode)
			final  = self.std.MaskedMerge([final, src], stmask)
		
		return final
	
	def usage(self):
		usage = '''
		A simple edge cleaning and weak dehaloing function ported to vapoursynth. Ported from:
		http://pastebin.com/7TCR7W4x
		
		edgecleaner(src, strength=16, rep=True, rmode=17, smode=0, hot=False)
			strength (float)      - specifies edge denoising strength (8.0)
			rep (boolean)         - actives Repair for the aWarpSharped clip (true; requires Repair).
			rmode (integer)       - specifies the Repair mode; 1 is very mild and good for halos, 
						16 and 18 are good for edge structure preserval 
						on strong settings but keep more halos and edge noise,
						17 is similar to 16 but keeps much less haloing,
						other modes are not recommended (17; requires Repair).
			smode (integer)       - specifies what method will be used for finding small particles,
						ie stars; 0 is disabled, 1 uses RemoveGrain and 2 uses Deen 
						(0; requires RemoveGrain/Repair/Deen).
			hot (boolean)         - specifies whether removal of hot pixels should take place (false).
		'''
		return usage
