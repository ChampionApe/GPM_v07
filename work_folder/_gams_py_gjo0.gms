$ONEOLCOM
$EOLCOM #
;
OPTION SYSOUT=OFF, SOLPRINT=OFF, LIMROW=0, LIMCOL=0, DECIMALS=6;


# ----------------------------------------------------------------------------------------------------
#  Define function: SolveEmptyNLP
# ----------------------------------------------------------------------------------------------------

sets
	alias_set
	alias_map2
	n
	s
;

alias(n,nn,nnn);

sets
	alias_[alias_set,alias_map2]
	t[t]
	t0[t]
	tE[t]
	tx0[t]
	txE[t]
	map_A[s,n,nn]
	map_spinp_A[s,n,nn]
	map_spout_A[s,n,nn]
	knout_A[s,n]
	kninp_A[s,n]
	spout_A[s,n]
	spinp_A[s,n]
	input_A[s,n]
	output_A[s,n]
	int_A[s,n]
	map_Tree1[s,n,nn]
	knot_Tree1[s,n]
	branch_Tree1[s,n]
	knot_o_Tree1[s,n]
	knot_no_Tree1[s,n]
	branch2o_Tree1[s,n]
	branch2no_Tree1[s,n]
	map_Tree2[s,n,nn]
	knot_Tree2[s,n]
	branch_Tree2[s,n]
	branch_o_Tree2[s,n]
	branch_no_Tree2[s,n]
	exomu_A[s,n,nn]
	endo_qD_A[s,n]
	endo_qS_A[s,n]
	endo_pS_A[s,n]
;
$GDXIN %rname%
$onMulti
$load alias_set
$load alias_map2
$load n
$load s
$load alias_
$load t
$load t0
$load tE
$load tx0
$load txE
$load map_A
$load map_spinp_A
$load map_spout_A
$load knout_A
$load kninp_A
$load spout_A
$load spinp_A
$load input_A
$load output_A
$load int_A
$load map_Tree1
$load knot_Tree1
$load branch_Tree1
$load knot_o_Tree1
$load knot_no_Tree1
$load branch2o_Tree1
$load branch2no_Tree1
$load map_Tree2
$load knot_Tree2
$load branch_Tree2
$load branch_o_Tree2
$load branch_no_Tree2
$load exomu_A
$load endo_qD_A
$load endo_qS_A
$load endo_pS_A
$GDXIN
$offMulti;

variables
	R_LR
	g_LR
	infl_LR
	mu[s,n,nn]
	sigma[s,n]
	eta[s,n]
	pS[t,s,n]
	pD[t,s,n]
	qS[t,s,n]
	qD[t,s,n]
	qnorm_out[t,s,n]
	qnorm_inp[t,s,n]
	qiv_out[t,s,n]
	qiv_inp[t,s,n]
;
$GDXIN %rname%
$onMulti
$load R_LR
$load g_LR
$load infl_LR
$load mu
$load sigma
$load eta
$load pS
$load pD
$load qS
$load qD
$load qnorm_out
$load qnorm_inp
$load qiv_out
$load qiv_inp
$GDXIN
$offMulti;

