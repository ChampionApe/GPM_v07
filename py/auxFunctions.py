import pandas as pd
from pyDatabases import GpyDB, gpy, adjMultiIndex, cartesianProductIndex
from pyDatabases.gpyDB_wheels import adj, aggregateDB

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

def gridDB(db0, dbT, name, n = 10, extractSol = None, db_name = 'grids', loop = 'l1', gridtype = 'linear', phi = 1, checkDiff = True, error = 1e-11):
	db = GpyDB(ws = db0.ws, alias = db0.get('alias_'), **{'name': db_name})
	db[loop] = loop+'_'+pd.Index(range(1,n+1),name=loop).astype(str)
	for var in set(db0.getTypes(['variable','parameter'])).intersection(set(dbT.getTypes(['variable','parameter']))):
		commonIndex = db0.get(var).index.intersection(dbT.get(var).index)
		v0,vT = adj.rc_pd(db0.get(var),commonIndex), adj.rc_pd(dbT.get(var),commonIndex)
		if checkDiff:
			commonIndex = vT[abs(v0-vT)>error].index
			v0,vT = adj.rc_pd(v0,commonIndex),adj.rc_pd(vT,commonIndex)
		if not vT.empty:
			db['_'.join([var,name,'ss'])] = commonIndex
			db['_'.join([var,name])] = gpy(adjMultiIndex.addGrid(v0,vT,db.get(loop),'_'.join([var,name]), gridtype=gridtype, phi=phi), **{'type':'parameter'})
	for var in set(db0.getTypes(['scalar_variable','scalar_parameter'])).intersection(set(dbT.getTypes(['scalar_variable','scalar_parameter']))):
		if (not checkDiff) or (abs(db0.get(var)-dbT.get(var))>error):
			db['_'.join([var,name,'ss'])] = db.get(loop)
			db['_'.join([var,name])] = gpy(adjMultiIndex.addGrid(db0.get(var),dbT.get(var),db.get(loop),'_'.join([var,name]),gridtype=gridtype,phi=phi),**{'type':'parameter'})
	for var in noneInit(extractSol,{}):
		db['_'.join(['sol',var,name])] = gpy(pd.Series(0, index = cartesianProductIndex([db.get(loop), adj.rc_pdInd(db0[var], c = extractSol[var])]), name = '_'.join(['sol',var,name])),**{'type':'parameter'})
	aggregateDB.updateSets(db,clean_alias=True)
	db.merge_internal()
	return db