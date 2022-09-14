import pandas as pd

def noneInit(x,FallBackVal):
	return FallBackVal if x is None else x

def dictInit(key,df_val,kwargs):
	return kwargs[key] if key in kwargs else df_val

def concatMultiIndices(l, names = None):
	if l:
		return pd.MultiIndex.from_frame(pd.concat([i.to_frame() for i in l]))
	elif len(names)==1:
		return pd.Index([], name = names[0])
	elif len(names)>1:
		return pd.MultiIndex.from_tuples([],names=names)
