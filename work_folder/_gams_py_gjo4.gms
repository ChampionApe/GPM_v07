sets
	l1
;


$GDXIN %grids%
$onMulti
$load l1
$GDXIN
$offMulti;

loop(l1,
	
	solve APi_C using CNS;
	
);