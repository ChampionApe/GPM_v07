qS.fx[t,s,n]$(output_APi[s,n]) = qS.l[t,s,n];
sigma.fx[s,n]$(kninp_APi[s,n]) = sigma.l[s,n];
eta.fx[s,n]$(knout_APi[s,n]) = eta.l[s,n];
mu.fx[s,n,nn]$((map_APi[s,n,nn] and ( not (endo_mu_APi[s,n,nn])))) = mu.l[s,n,nn];
tauS.fx[t,s,n]$(output_APi[s,n]) = tauS.l[t,s,n];
tauD.fx[t,s,n]$(input_APi[s,n]) = tauD.l[t,s,n];
tauLump.fx[t,s]$((s_APi[s] and tx0E[t])) = tauLump.l[t,s];
p.fx[t,n]$(((input_n_APi[n] and ( not (output_n_APi[n]))) or (output_n_APi[n] and t0[t]))) = p.l[t,n];
qD.fx[t,s,n]$((((input_APi[s,n] and t0[t]) and ( not ((endo_qD_APi[s,n] and t0[t])))) or (dur_APi[s,n] and t0[t]))) = qD.l[t,s,n];
TotalTax.fx[t,s]$((s_APi[s] and t0[t])) = TotalTax.l[t,s];
Rrate.fx[t] = Rrate.l[t];
rDepr.fx[t,s,n]$(dur_APi[s,n]) = rDepr.l[t,s,n];
icpar.fx[s,n]$(dur_APi[s,n]) = icpar.l[s,n];
K_tvc.fx[s,n]$(dur_APi[s,n]) = K_tvc.l[s,n];
pD.lo[t,s,n]$(((int_APi[s,n] or input_APi[s,n]) or (dur_APi[s,n] and txE[t]))) = -inf;
pD.up[t,s,n]$(((int_APi[s,n] or input_APi[s,n]) or (dur_APi[s,n] and txE[t]))) = inf;
pS.lo[t,s,n]$(output_APi[s,n]) = -inf;
pS.up[t,s,n]$(output_APi[s,n]) = inf;
p.lo[t,n]$((output_n_APi[n] and tx0[t])) = -inf;
p.up[t,n]$((output_n_APi[n] and tx0[t])) = inf;
qD.lo[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or (dur_APi[s,n] and tx0[t]))) = -inf;
qD.up[t,s,n]$(((int_APi[s,n] or (input_APi[s,n] and tx0[t]) or (endo_qD_APi[s,n] and t0[t])) or (dur_APi[s,n] and tx0[t]))) = inf;
qiv_inp.lo[t,s,n]$(spinp_APi[s,n]) = -inf;
qiv_inp.up[t,s,n]$(spinp_APi[s,n]) = inf;
qiv_out.lo[t,s,n]$(spout_APi[s,n]) = -inf;
qiv_out.up[t,s,n]$(spout_APi[s,n]) = inf;
outShare.lo[t,s,n]$(output_APi[s,n]) = -inf;
outShare.up[t,s,n]$(output_APi[s,n]) = inf;
TotalTax.lo[t,s]$((s_APi[s] and tx0E[t])) = -inf;
TotalTax.up[t,s]$((s_APi[s] and tx0E[t])) = inf;
mu.lo[s,n,nn]$(endo_mu_APi[s,n,nn]) = -inf;
mu.up[s,n,nn]$(endo_mu_APi[s,n,nn]) = inf;
tauLump.lo[t,s]$((s_APi[s] and t0[t])) = -inf;
tauLump.up[t,s]$((s_APi[s] and t0[t])) = inf;
markup.lo[s]$(s_APi[s]) = -inf;
markup.up[s]$(s_APi[s]) = inf;
ic.lo[t,s,n]$((output_APi[s,n] and txE[t])) = -inf;
ic.up[t,s,n]$((output_APi[s,n] and txE[t])) = inf;

# ----------------------------------------------------------------------------------------------------
#  Define APi_C model
# ----------------------------------------------------------------------------------------------------
Model APi_C /
E_zp_out_APi_tree, E_zp_nout_APi_tree, E_q_out_APi_tree, E_q_nout_APi_tree, E_lom_APi_IC, E_pk_APi_IC, E_pkT_APi_IC, E_Ktvc_APi_IC, E_instcost_APi_IC, E_pwInp_APi_pWedge, E_pwOut_APi_pWedge, E_outShare_APi_pWedge, E_TaxRev_APi_pWedge
/;


solve APi_C using CNS;