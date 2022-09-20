import pandas as pd
from pyDatabases import gpyDB
from auxFunctions import noneInit, dictInit

def df(x, kwargs):
    return x if x not in kwargs else kwargs[x]

class SmallOpen:
	""" Small open economy, exogenous long run interest rates, inflation rates and growth rates."""
	def __init__(self, kwargs_ns=None, kwargs_vals=None,**kwargs_oth):
		self.ns = {k: dictInit(k,k,noneInit(kwargs_ns,{})) for k in self.LongRunParameters + self.Time}
		self.db = self.Time_values(noneInit(kwargs_vals,{})) | self.LRP_values(noneInit(kwargs_vals,{}))

	@property
	def LongRunParameters(self):
		return ['R_LR','g_LR','infl_LR']

	@property
	def Time(self):
		return ['t', 't0', 'tx0', 'tE', 'txE', 'tx0E']

	def LRP_values(self,kwargs):
		_stdvals = {'R_LR': 1.03, 'g_LR': 0.02, 'infl_LR': 0.02}
		return {self.ns[k]: gpyDB.gpy(_stdvals[k] if k not in kwargs else kwargs[k],**{'type':'parameter','name':self.ns[k]}) for k in _stdvals}

	def Time_values(self,kwargs):
		t = pd.Index(kwargs['t'],name=self.ns['t']).astype(int).sort_values() if 't' in kwargs else pd.Index(range(1,3),name=self.ns['t'])
		return {	self.ns['t']: gpyDB.gpy(t), 
					self.ns['t0']: gpyDB.gpy(t[t==t[0]]), 
					self.ns['tE']: gpyDB.gpy(t[t==t[-1]]), 
					self.ns['tx0']: gpyDB.gpy(t[t!= t[0]]), 
					self.ns['txE']: gpyDB.gpy(t[t!= t[-1]]), 
					self.ns['tx0E']: gpyDB.gpy(t[(t!=t[0]) & (t!=t[-1])])}