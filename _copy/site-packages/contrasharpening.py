# contrasharpening.py (2012-12-03)
# Dependencies: RemoveGrain.dll (avs)
#		RemoveGrainHD.dll (avs)
#		Repair.dll (avs)

import vapoursynth as vs

def clamp(minimum, x, maximum):
	return int(max(minimum, min(round(x), maximum)))

class ContraSharpening(object):
	def __init__(self, core):
		self.std       = core.std
		self.repair    = core.avs.Repair
		self.rgrain    = core.avs.RemoveGrain
		self.quantile  = core.avs.Quantile
		self.lut_range = None
		self.max       = 0
		self.mid       = 0
	
	def mt_lutxy(self, c1, c2, expr, planes=0):
		lut = []
		for y in self.lut_range:
			for x in self.lut_range:
				lut.append(clamp(0, expr(x, y), self.max))
		return self.std.Lut2([c1, c2], lut, planes)
	
	def mt_adddiff(self, c1, c2, planes=0):
		expr = lambda x, y: x + y - self.mid
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def mt_makediff(self, c1, c2, planes=0):
		expr = lambda x, y: x - y + self.mid
		return self.mt_lutxy(c1, c2, expr, planes)
	
	def minblur(self, clp, r=1, planes=0):
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
		
	def contrasharpening(self, filtered, original):
		self.max       = 2 ** filtered.format.bits_per_sample - 1
		self.mid       = self.max // 2 + 1
		self.lut_range = range(self.max + 1)
		
		s    = self.minblur(filtered)
		allD = self.mt_makediff(original, filtered)
		ssD  = self.mt_makediff(s, self.rgrain(s, 11, -1))
		ssDD = self.repair(ssD, allD, 1)
		ssDD = self.mt_lutxy(ssDD, ssD, lambda x, y: x if abs(x - self.mid) < abs(y - self.mid) else y)
		
		return self.mt_adddiff(filtered, ssDD)
	
	def usage(self):
		usage='''
		ContraSharpening module ported from:
		http://forum.doom9.org/showpost.php?p=1474191&postcount=337
		
		contrasharpening(filtered, original)
			filtered: A clip blured due the filtering done on it.
			original: The same clip before the filtering.
		'''
		return usage
