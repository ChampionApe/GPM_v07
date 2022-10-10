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
	t
	l1
;

alias(n,nn,nnn);

sets
	alias_[alias_set,alias_map2]
	t0[t]
	tE[t]
	tx0[t]
	txE[t]
	tx0E[t]
	map_APi[s,n,nn]
	map_spinp_APi[s,n,nn]
	map_spout_APi[s,n,nn]
	knout_APi[s,n]
	kninp_APi[s,n]
	spout_APi[s,n]
	spinp_APi[s,n]
	input_APi[s,n]
	output_APi[s,n]
	int_APi[s,n]
	map_APi_tree[s,n,nn]
	knot_APi_tree[s,n]
	branch_APi_tree[s,n]
	knot_o_APi_tree[s,n]
	knot_no_APi_tree[s,n]
	branch2o_APi_tree[s,n]
	branch2no_APi_tree[s,n]
	endo_mu_APi[s,n,nn]
	endo_qD_APi[s,n]
	dur_APi[s,n]
	dur2inv[s,n,nn]
	inv_APi[s,n]
	output_n[n]
	s_APi[s]
	exomu_APi[s,n,nn]
	endo_qS_APi[s,n]
	endo_pS_APi[s,n]
	s_p[s]
	nOut_p[n]
	dur_p[s,n]
	inv_p[n]
	nOut_f[n]
	s_f[s]
	s_i[s]
	nOut_i[n]
	s_h[s]
	nOut_h[n]
	p_shock_ss[t,n]
	qD_shock_ss[t,s,n]
;
$GDXIN %rname_3%
$onMulti
$load alias_set
$load alias_map2
$load n
$load s
$load t
$load l1
$load alias_
$load t0
$load tE
$load tx0
$load txE
$load tx0E
$load map_APi
$load map_spinp_APi
$load map_spout_APi
$load knout_APi
$load kninp_APi
$load spout_APi
$load spinp_APi
$load input_APi
$load output_APi
$load int_APi
$load map_APi_tree
$load knot_APi_tree
$load branch_APi_tree
$load knot_o_APi_tree
$load knot_no_APi_tree
$load branch2o_APi_tree
$load branch2no_APi_tree
$load endo_mu_APi
$load endo_qD_APi
$load dur_APi
$load dur2inv
$load inv_APi
$load output_n
$load s_APi
$load exomu_APi
$load endo_qS_APi
$load endo_pS_APi
$load s_p
$load nOut_p
$load dur_p
$load inv_p
$load nOut_f
$load s_f
$load s_i
$load nOut_i
$load s_h
$load nOut_h
$load p_shock_ss
$load qD_shock_ss
$GDXIN
$offMulti;

parameters
	R_LR
	g_LR
	infl_LR
	qnorm_out[t,s,n]
	qnorm_inp[t,s,n]
	p_shock[l1,t,n]
	qD_shock[l1,t,s,n]
;
$GDXIN %rname_3%
$onMulti
$load R_LR
$load g_LR
$load infl_LR
$load qnorm_out
$load qnorm_inp
$load p_shock
$load qD_shock
$GDXIN
$offMulti;

variables
	mu[s,n,nn]
	sigma[s,n]
	vS[t,s,n]
	vD[t,s,n]
	TotalTax[t,s]
	p[t,n]
	rDepr[t,s,n]
	qD[t,s,n]
	qS[t,s,n]
	pD[t,s,n]
	pS[t,s,n]
	eta[s,n]
	qiv_out[t,s,n]
	qiv_inp[t,s,n]
	Rrate[t]
	icpar1[s,n]
	icpar2[s,n]
	K_tvc[s,n]
	ic[t,s,n]
	markup[s]
	tauS[t,s,n]
;
$GDXIN %rname_3%
$onMulti
$load mu
$load sigma
$load vS
$load vD
$load TotalTax
$load p
$load rDepr
$load qD
$load qS
$load pD
$load pS
$load eta
$load qiv_out
$load qiv_inp
$load Rrate
$load icpar1
$load icpar2
$load K_tvc
$load ic
$load markup
$load tauS
$GDXIN
$offMulti;




# ---------------------------------------------B_APi_tree---------------------------------------------
#  Initialize B_APi_tree equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_zp_out_APi_tree[t,s,n];
E_zp_out_APi_tree[t,s,n]$(knot_o_api_tree[s,n] and txe[t]).. 	pS[t,s,n]*qS[t,s,n]  =E=  sum(nn$(map_APi_tree[s,n,nn]), qD[t,s,nn]*pD[t,s,nn]);
EQUATION E_zp_nout_APi_tree[t,s,n];
E_zp_nout_APi_tree[t,s,n]$(knot_no_api_tree[s,n] and txe[t]).. 	pD[t,s,n]*qD[t,s,n]  =E=  sum(nn$(map_APi_tree[s,n,nn]), qD[t,s,nn]*pD[t,s,nn]);
EQUATION E_q_out_APi_tree[t,s,n];
E_q_out_APi_tree[t,s,n]$(branch2o_api_tree[s,n] and txe[t]).. 	qD[t,s,n]  =E=  sum(nn$(map_APi_tree[s,nn,n]), mu[s,nn,n] * (pS[t,s,nn]/pD[t,s,n])**(sigma[s,nn]) * qS[t,s,nn]);
EQUATION E_q_nout_APi_tree[t,s,n];
E_q_nout_APi_tree[t,s,n]$(branch2no_api_tree[s,n] and txe[t]).. 	qD[t,s,n]  =E=  sum(nn$(map_APi_tree[s,nn,n]), mu[s,nn,n] * (pD[t,s,nn]/pD[t,s,n])**(sigma[s,nn]) * qD[t,s,nn]);

# ----------------------------------------------------------------------------------------------------
#  Define B_APi_tree model
# ----------------------------------------------------------------------------------------------------
Model B_APi_tree /
E_zp_out_APi_tree, E_zp_nout_APi_tree, E_q_out_APi_tree, E_q_nout_APi_tree
/;




# ----------------------------------------------B_APi_IC----------------------------------------------
#  Initialize B_APi_IC equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_lom_APi_IC[t,s,n];
E_lom_APi_IC[t,s,n]$(dur_api[s,n] and txe[t]).. 	qD[t+1,s,n]	 =E=  (qD[t,s,n]*(1-rDepr[t,s,n])+sum(nn$(dur2inv[s,n,nn]), qD[t,s,nn]))/(1+g_LR);
EQUATION E_pk_APi_IC[t,s,n];
E_pk_APi_IC[t,s,n]$(dur_api[s,n] and tx0e[t]).. 	pD[t,s,n]	 =E=  sum(nn$(dur2inv[s,n,nn]), Rrate[t]*(pD[t-1,s,nn]/(1+infl_LR)+icpar1[s,n]*(qD[t-1,s,nn]/qD[t-1,s,n]-icpar2[s,n]))+(icpar1[s,n]*0.5)*sqr(qD[t,s,nn]/qD[t,s,n]-icpar2[s,n])-(1-rDepr[t,s,n])*(pD[t,s,nn]+icpar1[s,n]*(qD[t,s,nn]/qD[t,s,n]-icpar2[s,n])));
EQUATION E_Ktvc_APi_IC[t,s,n];
E_Ktvc_APi_IC[t,s,n]$(dur_api[s,n] and te[t]).. 	qD[t,s,n]	 =E=  (1+K_tvc[s,n])*qD[t-1,s,n];
EQUATION E_instcost_APi_IC[t,s,n];
E_instcost_APi_IC[t,s,n]$(output_api[s,n] and txe[t]).. 	ic[t,s,n]  =E=  ((qS[t,s,n]*pS[t,s,n])/sum(nn$(output_APi[s,nn]), qS[t,s,nn]*pS[t,s,nn]))*sum([nn,nnn]$(dur2inv[s,nn,nnn]), icpar1[s,nn]*0.5*qD[t,s,nn]*sqr(qD[t,s,nnn]/qD[t,s,nn]-icpar2[s,nn]));

# ----------------------------------------------------------------------------------------------------
#  Define B_APi_IC model
# ----------------------------------------------------------------------------------------------------
Model B_APi_IC /
E_lom_APi_IC, E_pk_APi_IC, E_Ktvc_APi_IC, E_instcost_APi_IC
/;




# --------------------------------------------B_APi_pWedge--------------------------------------------
#  Initialize B_APi_pWedge equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_pw_APi_pWedge[t,s,n];
E_pw_APi_pWedge[t,s,n]$(output_api[s,n] and txe[t]).. 	p[t,n]  =E=  (1+markup[s])*(pS[t,s,n]+tauS[t,s,n]+ic[t,s,n]);

# ----------------------------------------------------------------------------------------------------
#  Define B_APi_pWedge model
# ----------------------------------------------------------------------------------------------------
Model B_APi_pWedge /
E_pw_APi_pWedge
/;


qS.fx[t,s,n]$(output_APi[s,n]) = qS.l[t,s,n];
pD.fx[t,s,n]$(input_APi[s,n]) = pD.l[t,s,n];
sigma.fx[s,n]$(kninp_APi[s,n]) = sigma.l[s,n];
eta.fx[s,n]$(knout_APi[s,n]) = eta.l[s,n];
mu.fx[s,n,nn]$(((map_APi[s,n,nn] and ( not (endo_mu_APi[s,n,nn]))) or endo_mu_APi[s,n,nn])) = mu.l[s,n,nn];
tauS.fx[t,s,n]$(output_APi[s,n]) = tauS.l[t,s,n];
p.fx[t,n]$(( not (output_n[n]))) = p.l[t,n];
markup.fx[s]$(s_APi[s]) = markup.l[s];
Rrate.fx[t] = Rrate.l[t];
rDepr.fx[t,s,n]$(dur_APi[s,n]) = rDepr.l[t,s,n];
icpar1.fx[s,n]$(dur_APi[s,n]) = icpar1.l[s,n];
icpar2.fx[s,n]$(dur_APi[s,n]) = icpar2.l[s,n];
K_tvc.fx[s,n]$(dur_APi[s,n]) = K_tvc.l[s,n];
qD.fx[t,s,n]$((dur_APi[s,n] and t0[t])) = qD.l[t,s,n];
pD.lo[t,s,n]$((int_APi[s,n] or (dur_APi[s,n] and txE[t]))) = -inf;
pD.up[t,s,n]$((int_APi[s,n] or (dur_APi[s,n] and txE[t]))) = inf;
pS.lo[t,s,n]$(output_APi[s,n]) = -inf;
pS.up[t,s,n]$(output_APi[s,n]) = inf;
p.lo[t,n]$(((output_n[n] and tx0[t]) or (output_n[n] and t0[t]))) = -inf;
p.up[t,n]$(((output_n[n] and tx0[t]) or (output_n[n] and t0[t]))) = inf;
qD.lo[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or ((input_APi[s,n] and t0[t]) and ( not ((endo_qD_APi[s,n] and t0[t])))) or (dur_APi[s,n] and tx0[t]))) = -inf;
qD.up[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or ((input_APi[s,n] and t0[t]) and ( not ((endo_qD_APi[s,n] and t0[t])))) or (dur_APi[s,n] and tx0[t]))) = inf;
qiv_inp.lo[t,s,n]$(spinp_APi[s,n]) = -inf;
qiv_inp.up[t,s,n]$(spinp_APi[s,n]) = inf;
qiv_out.lo[t,s,n]$(spout_APi[s,n]) = -inf;
qiv_out.up[t,s,n]$(spout_APi[s,n]) = inf;
ic.lo[t,s,n]$((output_APi[s,n] and txE[t])) = -inf;
ic.up[t,s,n]$((output_APi[s,n] and txE[t])) = inf;

# ----------------------------------------------------------------------------------------------------
#  Define APi_B model
# ----------------------------------------------------------------------------------------------------
Model APi_B /
E_zp_out_APi_tree, E_zp_nout_APi_tree, E_q_out_APi_tree, E_q_nout_APi_tree, E_lom_APi_IC, E_pk_APi_IC, E_Ktvc_APi_IC, E_instcost_APi_IC, E_pw_APi_pWedge
/;


solve APi_B using CNS;