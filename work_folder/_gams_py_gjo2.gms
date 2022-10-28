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
	t2E[t]
	tx0[t]
	txE[t]
	tx2E[t]
	tx0E[t]
	tx02E[t]
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
	input_n[n]
	output_n_APi[n]
	input_n_APi[n]
	s_APi[s]
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
$load t2E
$load tx0
$load txE
$load tx2E
$load tx0E
$load tx02E
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
$load input_n
$load output_n_APi
$load input_n_APi
$load s_APi
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
	vD[t,s,n]
	vS[t,s,n]
	TotalTax[t,s]
	p[t,n]
	qD[t,s,n]
	rDepr[t,s,n]
	qS[t,s,n]
	pD[t,s,n]
	pS[t,s,n]
	tauS[t,s,n]
	eta[s,n]
	qiv_out[t,s,n]
	qiv_inp[t,s,n]
	Rrate[t]
	icpar[s,n]
	K_tvc[s,n]
	ic[t,s,n]
	markup[s]
	tauD[t,s,n]
	outShare[t,s,n]
	tauLump[t,s]
;
$GDXIN %rname%
$onMulti
$load sigma
$load mu
$load vD
$load vS
$load TotalTax
$load p
$load qD
$load rDepr
$load qS
$load pD
$load pS
$load tauS
$load eta
$load qiv_out
$load qiv_inp
$load Rrate
$load icpar
$load K_tvc
$load ic
$load markup
$load tauD
$load outShare
$load tauLump
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
E_lom_APi_IC[t,s,n]$(dur_api[s,n] and txe[t]).. 		qD[t+1,s,n]	 =E=  (qD[t,s,n]*(1-rDepr[t,s,n])+sum(nn$(dur2inv[s,n,nn]), qD[t,s,nn]))/(1+g_LR);
EQUATION E_pk_APi_IC[t,s,n];
E_pk_APi_IC[t,s,n]$(dur_api[s,n] and tx02e[t]).. 	pD[t,s,n]	 =E=  sqrt(sqr(sum(nn$(dur2inv[s,n,nn]), Rrate[t]*pD[t-1,s,nn]*(1+icpar[s,n]*(qD[t-1,s,nn]/qD[t-1,s,n]-(rDepr[t-1,s,n]+g_LR)))/(1+infl_LR)+pD[t,s,nn]*(icpar[s,n]*0.5*(sqr(rDepr[t,s,n]+g_LR)-sqr(qD[t,s,nn]/qD[t,s,n]))-(1-rDepr[t,s,n])*(1+icpar[s,n]*(qD[t,s,nn]/qD[t,s,n]-(rDepr[t,s,n]+g_LR)))))));
EQUATION E_pkT_APi_IC[t,s,n];
E_pkT_APi_IC[t,s,n]$(dur_api[s,n] and t2e[t]).. 		pD[t,s,n]	 =E=  sum(nn$(dur2inv[s,n,nn]), Rrate[t]*pD[t-1,s,nn] * (1+icpar[s,n]*(qD[t-1,s,nn]/qD[t-1,s,n]-(rDepr[t-1,s,n]+g_LR)))/(1+infl_LR) + (rDepr[t,s,n]-1)*pD[t,s,nn]);
EQUATION E_Ktvc_APi_IC[t,s,n];
E_Ktvc_APi_IC[t,s,n]$(dur_api[s,n] and te[t]).. 		qD[t,s,n]	 =E=  (1+K_tvc[s,n])*qD[t-1,s,n];
EQUATION E_instcost_APi_IC[t,s,n];
E_instcost_APi_IC[t,s,n]$(output_api[s,n] and txe[t]).. 	ic[t,s,n]  =E=  outShare[t,s,n]*sum([nn,nnn]$(dur2inv[s,nn,nnn]), pD[t,s,nnn] * icpar[s,nn]*0.5*qD[t,s,nn]*sqr(qD[t,s,nnn]/qD[t,s,nn]-(rDepr[t,s,nn]+g_LR)));

# ----------------------------------------------------------------------------------------------------
#  Define B_APi_IC model
# ----------------------------------------------------------------------------------------------------
Model B_APi_IC /
E_lom_APi_IC, E_pk_APi_IC, E_pkT_APi_IC, E_Ktvc_APi_IC, E_instcost_APi_IC
/;




# --------------------------------------------B_APi_pWedge--------------------------------------------
#  Initialize B_APi_pWedge equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_pwInp_APi_pWedge[t,s,n];
E_pwInp_APi_pWedge[t,s,n]$(input_api[s,n] and txe[t]).. 			pD[t,s,n]		 =E=  p[t,n]+tauD[t,s,n];
EQUATION E_pwOut_APi_pWedge[t,s,n];
E_pwOut_APi_pWedge[t,s,n]$(output_api[s,n] and txe[t]).. 		p[t,n] 			 =E=  (1+markup[s])*(pS[t,s,n]+tauS[t,s,n]+ic[t,s,n]+tauLump[t,s]*outShare[t,s,n]/qS[t,s,n]);
EQUATION E_outShare_APi_pWedge[t,s,n];
E_outShare_APi_pWedge[t,s,n]$(output_api[s,n] and txe[t]).. 		outShare[t,s,n]  =E=  qS[t,s,n]*pS[t,s,n]/(sum(nn$(output_APi[s,nn]), qS[t,s,nn]*pS[t,s,nn]));
EQUATION E_TaxRev_APi_pWedge[t,s];
E_TaxRev_APi_pWedge[t,s]$(s_api[s] and txe[t]).. 				TotalTax[t,s]	 =E=  tauLump[t,s]+sum(n$(input_APi[s,n]), tauD[t,s,n] * qD[t,s,n])+sum(n$(output_APi[s,n]), tauS[t,s,n]*qS[t,s,n]);

# ----------------------------------------------------------------------------------------------------
#  Define B_APi_pWedge model
# ----------------------------------------------------------------------------------------------------
Model B_APi_pWedge /
E_pwInp_APi_pWedge, E_pwOut_APi_pWedge, E_outShare_APi_pWedge, E_TaxRev_APi_pWedge
/;


qS.fx[t,s,n]$(output_APi[s,n]) = qS.l[t,s,n];
sigma.fx[s,n]$(kninp_APi[s,n]) = sigma.l[s,n];
eta.fx[s,n]$(knout_APi[s,n]) = eta.l[s,n];
mu.fx[s,n,nn]$(((map_APi[s,n,nn] and ( not (endo_mu_APi[s,n,nn]))) or endo_mu_APi[s,n,nn])) = mu.l[s,n,nn];
tauS.fx[t,s,n]$(output_APi[s,n]) = tauS.l[t,s,n];
tauD.fx[t,s,n]$(input_APi[s,n]) = tauD.l[t,s,n];
tauLump.fx[t,s]$(((s_APi[s] and tx0E[t]) or (s_APi[s] and t0[t]))) = tauLump.l[t,s];
p.fx[t,n]$((input_n_APi[n] and ( not (output_n_APi[n])))) = p.l[t,n];
markup.fx[s]$(s_APi[s]) = markup.l[s];
Rrate.fx[t] = Rrate.l[t];
rDepr.fx[t,s,n]$(dur_APi[s,n]) = rDepr.l[t,s,n];
icpar.fx[s,n]$(dur_APi[s,n]) = icpar.l[s,n];
K_tvc.fx[s,n]$(dur_APi[s,n]) = K_tvc.l[s,n];
qD.fx[t,s,n]$((dur_APi[s,n] and t0[t])) = qD.l[t,s,n];
pD.lo[t,s,n]$(((int_APi[s,n] or input_APi[s,n]) or (dur_APi[s,n] and txE[t]))) = -inf;
pD.up[t,s,n]$(((int_APi[s,n] or input_APi[s,n]) or (dur_APi[s,n] and txE[t]))) = inf;
pS.lo[t,s,n]$(output_APi[s,n]) = -inf;
pS.up[t,s,n]$(output_APi[s,n]) = inf;
p.lo[t,n]$(((output_n_APi[n] and tx0[t]) or (output_n_APi[n] and t0[t]))) = -inf;
p.up[t,n]$(((output_n_APi[n] and tx0[t]) or (output_n_APi[n] and t0[t]))) = inf;
qD.lo[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or ((input_APi[s,n] and t0[t]) and ( not ((endo_qD_APi[s,n] and t0[t])))) or (dur_APi[s,n] and tx0[t]))) = -inf;
qD.up[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or ((input_APi[s,n] and t0[t]) and ( not ((endo_qD_APi[s,n] and t0[t])))) or (dur_APi[s,n] and tx0[t]))) = inf;
qiv_inp.lo[t,s,n]$(spinp_APi[s,n]) = -inf;
qiv_inp.up[t,s,n]$(spinp_APi[s,n]) = inf;
qiv_out.lo[t,s,n]$(spout_APi[s,n]) = -inf;
qiv_out.up[t,s,n]$(spout_APi[s,n]) = inf;
outShare.lo[t,s,n]$(output_APi[s,n]) = -inf;
outShare.up[t,s,n]$(output_APi[s,n]) = inf;
TotalTax.lo[t,s]$(((s_APi[s] and tx0E[t]) or (s_APi[s] and t0[t]))) = -inf;
TotalTax.up[t,s]$(((s_APi[s] and tx0E[t]) or (s_APi[s] and t0[t]))) = inf;
ic.lo[t,s,n]$((output_APi[s,n] and txE[t])) = -inf;
ic.up[t,s,n]$((output_APi[s,n] and txE[t])) = inf;

# ----------------------------------------------------------------------------------------------------
#  Define APi_B model
# ----------------------------------------------------------------------------------------------------
Model APi_B /
E_zp_out_APi_tree, E_zp_nout_APi_tree, E_q_out_APi_tree, E_q_nout_APi_tree, E_lom_APi_IC, E_pk_APi_IC, E_pkT_APi_IC, E_Ktvc_APi_IC, E_instcost_APi_IC, E_pwInp_APi_pWedge, E_pwOut_APi_pWedge, E_outShare_APi_pWedge, E_TaxRev_APi_pWedge
/;


solve APi_B using CNS;