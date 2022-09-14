from _GmsWrite import *

def standardArgs(settings, db, gdx, blocks = None, functions = None, run = True, prefix = '', prefix_run = '', options=None):
	args = {'Root': writeRoot(**noneInit(options, {})), prefix+'Functions': writeFunctions(settings.Precompiler, settings.macros, f=functions), prefix+'Declare': writeDeclare(db, gdx=gdx), prefix+'Blocks': blocks}
	return {k:v for k,v in args.items() if v} | standardRun(settings, db, prefix=prefix_run) if run else {k:v for k,v in args.items() if v}

def standardRun(settings, db, prefix =''):
	return {prefix+'fix': settings.Compile.fixGroupsText(db,settings['g_exo']), prefix+'unfix': settings.Compile.unfixGroupsText(db,settings['g_endo']), 
			prefix+'model': writeModel(settings['name'], settings['blocks']), prefix+'solve': writeSolve(solve=settings['solve'],name=settings['name'])}


