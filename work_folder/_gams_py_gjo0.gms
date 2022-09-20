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
	tx0E[t]
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
	dur_A_IC[s,n]
	dur2inv[s,n,nn]
	inv_A_IC[s,n]
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
$load tx0E
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
$load dur_A_IC
$load dur2inv
$load inv_A_IC
$GDXIN
$offMulti;

parameters
	R_LR
	g_LR
	infl_LR
	qnorm_out[t,s,n]
	qnorm_inp[t,s,n]
;
$GDXIN %rname%
$onMulti
$load R_LR
$load g_LR
$load infl_LR
$load qnorm_out
$load qnorm_inp
$GDXIN
$offMulti;

variables
	sigma[s,n]
	mu[s,n,nn]
	eta[s,n]
	pS[t,s,n]
	qS[t,s,n]
	pD[t,s,n]
	qD[t,s,n]
	qiv_out[t,s,n]
	qiv_inp[t,s,n]
	Rrate[t]
	rDepr[t,s,n]
	icpar1[s,n]
	icpar2[s,n]
	K_tvc[s,n]
	ic[t,s,n]
;
$GDXIN %rname%
$onMulti
$load sigma
$load mu
$load eta
$load pS
$load qS
$load pD
$load qD
$load qiv_out
$load qiv_inp
$load Rrate
$load rDepr
$load icpar1
$load icpar2
$load K_tvc
$load ic
$GDXIN
$offMulti;




# ----------------------------------------------B_A_Tree1---------------------------------------------
#  Initialize B_A_Tree1 equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_zp_out_Tree1[t,s,n];
E_zp_out_Tree1[t,s,n]$(knot_o_tree1[s,n] and txe[t]).. 	pS[t,s,n]*qS[t,s,n]  =E=  sum(nn$(map_Tree1[s,n,nn]), qD[t,s,nn]*pD[t,s,nn]);
EQUATION E_zp_nout_Tree1[t,s,n];
E_zp_nout_Tree1[t,s,n]$(knot_no_tree1[s,n] and txe[t]).. 	pD[t,s,n]*qD[t,s,n]  =E=  sum(nn$(map_Tree1[s,n,nn]), qD[t,s,nn]*pD[t,s,nn]);
EQUATION E_q_out_Tree1[t,s,n];
E_q_out_Tree1[t,s,n]$(branch2o_tree1[s,n] and txe[t]).. 	qD[t,s,n]  =E=  sum(nn$(map_Tree1[s,nn,n]), mu[s,nn,n] * (pS[t,s,nn]/pD[t,s,n])**(sigma[s,nn]) * qS[t,s,nn]);
EQUATION E_q_nout_Tree1[t,s,n];
E_q_nout_Tree1[t,s,n]$(branch2no_tree1[s,n] and txe[t]).. 	qD[t,s,n]  =E=  sum(nn$(map_Tree1[s,nn,n]), mu[s,nn,n] * (pD[t,s,nn]/pD[t,s,n])**(sigma[s,nn]) * qD[t,s,nn]);

# ----------------------------------------------------------------------------------------------------
#  Define B_A_Tree1 model
# ----------------------------------------------------------------------------------------------------
Model B_A_Tree1 /
E_zp_out_Tree1, E_zp_nout_Tree1, E_q_out_Tree1, E_q_nout_Tree1
/;




# ----------------------------------------------B_A_Tree2---------------------------------------------
#  Initialize B_A_Tree2 equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_zp_Tree2[t,s,n];
E_zp_Tree2[t,s,n]$(knot_tree2[s,n] and txe[t]).. 	pD[t,s,n]*qD[t,s,n]  =E=  sum(nn$(map_Tree2[s,nn,n] and branch_o_Tree2[s,nn]), qS[t,s,nn]*pS[t,s,nn])+sum(nn$(map_Tree2[s,nn,n] and branch_no_Tree2[s,nn]), qD[t,s,nn]*pD[t,s,nn]);
EQUATION E_q_out_Tree2[t,s,n];
E_q_out_Tree2[t,s,n]$(branch_o_tree2[s,n] and txe[t]).. 	qS[t,s,n]  =E=  sum(nn$(map_Tree2[s,n,nn]), qD[t,s,nn]*mu[s,n,nn] * exp((pS[t,s,n]-pD[t,s,nn])*eta[s,nn]) / (sum(nnn$(map_Tree2[s,nnn,nn] and branch_o_Tree2[s,nnn]), mu[s,nnn,nn] * exp((pD[t,s,nn]-pS[t,s,nnn])*eta[s,nn]))+sum(nnn$(map_Tree2[s,nnn,nn] and branch_no_Tree2[s,nnn]), mu[s,nnn,nn] * exp((pD[t,s,nn]-pD[t,s,nnn])*eta[s,nn]))));
EQUATION E_q_nout_Tree2[t,s,n];
E_q_nout_Tree2[t,s,n]$(branch_no_tree2[s,n] and txe[t]).. 		qD[t,s,n]  =E=  sum(nn$(map_Tree2[s,n,nn]), qD[t,s,nn]*mu[s,n,nn] * exp((pD[t,s,n]-pD[t,s,nn])*eta[s,nn]) / (sum(nnn$(map_Tree2[s,nnn,nn] and branch_o_Tree2[s,nnn]), mu[s,nnn,nn] * exp((pD[t,s,nn]-pS[t,s,nnn])*eta[s,nn]))+sum(nnn$(map_Tree2[s,nnn,nn] and branch_no_Tree2[s,nnn]), mu[s,nnn,nn] * exp((pD[t,s,nn]-pD[t,s,nnn])*eta[s,nn]))));

# ----------------------------------------------------------------------------------------------------
#  Define B_A_Tree2 model
# ----------------------------------------------------------------------------------------------------
Model B_A_Tree2 /
E_zp_Tree2, E_q_out_Tree2, E_q_nout_Tree2
/;




# ------------------------------------------------B_A_A-----------------------------------------------
#  Initialize B_A_A equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_lom_A[t,s,n];
E_lom_A[t,s,n]$(dur_a_ic[s,n] and txe[t]).. 	qD[t+1,s,n]	 =E=  (qD[t,s,n]*(1-rDepr[t,s,n])+sum(nn$(dur2inv[s,n,nn]), qD[t,s,nn]))/(1+g_LR);
EQUATION E_pk_A[t,s,n];
E_pk_A[t,s,n]$(dur_a_ic[s,n] and tx0e[t]).. 	pD[t,s,n]	 =E=  sum(nn$(dur2inv[s,n,nn]), Rrate[t]*(pD[t-1,s,nn]/(1+infl_LR)+icpar1[s,n]*(qD[t-1,s,nn]/qD[t-1,s,n]-icpar2[s,n]))+(icpar1[s,n]*0.5)*(sqr(icpar2[s,n]*qD[t,s,n])-sqr(qD[t,s,nn]))/sqr(qD[t,s,n])-(1-rDepr[t,s,n])*(pD[t,s,nn]+icpar1[s,n]*(qD[t,s,nn]/qD[t,s,n]-icpar2[s,n])));
EQUATION E_Ktvc_A[t,s,n];
E_Ktvc_A[t,s,n]$(dur_a_ic[s,n] and te[t]).. 	qD[t,s,n]	 =E=  (1+K_tvc[s,n])*qD[t-1,s,n];
EQUATION E_instcost_A[t,s,n];
E_instcost_A[t,s,n]$(output_a[s,n] and txe[t]).. 	ic[t,s,n]  =E=  (pS[t,s,n]/sum(nn$(output_A[s,nn]), qS[t,s,n]*pS[t,s,nn]))*sum([nn,nnn]$(dur_A_IC[s,nn] and dur2inv[s,nn,nnn]), icpar1[s,nn]*0.5*qD[t,s,nn]*sqr(qD[t,s,nnn]/qD[t,s,nn]-icpar2[s,nn]));

# ----------------------------------------------------------------------------------------------------
#  Define B_A_A model
# ----------------------------------------------------------------------------------------------------
Model B_A_A /
E_lom_A, E_pk_A, E_Ktvc_A, E_instcost_A
/;


qS.fx[t,s,n]$(((output_A[s,n] and ( not ((endo_qS_A[s,n] and t0[t])))) or (endo_qS_A[s,n] and t0[t]))) = qS.l[t,s,n];
pD.fx[t,s,n]$(input_A[s,n]) = pD.l[t,s,n];
sigma.fx[s,n]$(kninp_A[s,n]) = sigma.l[s,n];
eta.fx[s,n]$(knout_A[s,n]) = eta.l[s,n];
mu.fx[s,n,nn]$((exomu_A[s,n,nn] or ( not (exomu_A[s,n,nn])))) = mu.l[s,n,nn];
Rrate.fx[t] = Rrate.l[t];
rDepr.fx[t,s,n]$(dur_A_IC[s,n]) = rDepr.l[t,s,n];
icpar1.fx[s,n]$(dur_A_IC[s,n]) = icpar1.l[s,n];
icpar2.fx[s,n]$(dur_A_IC[s,n]) = icpar2.l[s,n];
K_tvc.fx[s,n]$(dur_A_IC[s,n]) = K_tvc.l[s,n];
qD.fx[t,s,n]$((dur_A_IC[s,n] and t0[t])) = qD.l[t,s,n];
pD.lo[t,s,n]$((int_A[s,n] or (dur_A_IC[s,n] and txE[t]))) = -inf;
pD.up[t,s,n]$((int_A[s,n] or (dur_A_IC[s,n] and txE[t]))) = inf;
pS.lo[t,s,n]$((((output_A[s,n] and tx0[t]) or (endo_pS_A[s,n] and t0[t])) or ((output_A[s,n] and t0[t]) and ( not ((endo_pS_A[s,n] and t0[t])))))) = -inf;
pS.up[t,s,n]$((((output_A[s,n] and tx0[t]) or (endo_pS_A[s,n] and t0[t])) or ((output_A[s,n] and t0[t]) and ( not ((endo_pS_A[s,n] and t0[t])))))) = inf;
qD.lo[t,s,n]$(((((int_A[s,n] or input_A[s,n]) and tx0[t]) or (endo_qD_A[s,n] and t0[t])) or (((int_A[s,n] or input_A[s,n]) and t0[t]) and ( not ((endo_qD_A[s,n] and t0[t])))) or (dur_A_IC[s,n] and tx0[t]))) = -inf;
qD.up[t,s,n]$(((((int_A[s,n] or input_A[s,n]) and tx0[t]) or (endo_qD_A[s,n] and t0[t])) or (((int_A[s,n] or input_A[s,n]) and t0[t]) and ( not ((endo_qD_A[s,n] and t0[t])))) or (dur_A_IC[s,n] and tx0[t]))) = inf;
qiv_inp.lo[t,s,n]$(spinp_A[s,n]) = -inf;
qiv_inp.up[t,s,n]$(spinp_A[s,n]) = inf;
qiv_out.lo[t,s,n]$(spout_A[s,n]) = -inf;
qiv_out.up[t,s,n]$(spout_A[s,n]) = inf;
ic.lo[t,s,n]$((output_A[s,n] and txE[t])) = -inf;
ic.up[t,s,n]$((output_A[s,n] and txE[t])) = inf;

# ----------------------------------------------------------------------------------------------------
#  Define A_B model
# ----------------------------------------------------------------------------------------------------
Model A_B /
E_zp_out_Tree1, E_zp_nout_Tree1, E_q_out_Tree1, E_q_nout_Tree1, E_zp_Tree2, E_q_out_Tree2, E_q_nout_Tree2, E_lom_A, E_pk_A, E_Ktvc_A, E_instcost_A
/;


solve A_B using CNS;