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
;

alias(n,nn,nnn);
alias(s,ss);

sets
	alias_[alias_set,alias_map2]
	s_p[s]
	nOut_p[n]
	nOut_f[n]
	s_f[s]
	s_i[s]
	nOut_i[n]
	s_h[s]
	nOut_h[n]
	dom2for[n,nn]
	nEqui[n]
	d_qS[s,n]
	d_qD[s,n]
	d_qSEqui[s,n]
	d_pEqui[n]
	dur_p[s,n]
	inv_p[s,n]
	dur2inv[s,n,nn]
	svngs[s,n]
	mapOut[s,n,nn]
	knotOutTree[s,n]
	branchOut[s,n]
	branchNOut[s,n]
	mapInp[s,n,nn]
	knotOut[s,n]
	knotNOut[s,n]
	branch2Out[s,n]
	branch2NOut[s,n]
	map[s,n,nn]
	output[s,n]
	input[s,n]
	int[s,n]
;
$GDXIN %IO_A_0%
$onMulti
$load alias_set
$load alias_map2
$load n
$load s
$load t
$load alias_
$load s_p
$load nOut_p
$load nOut_f
$load s_f
$load s_i
$load nOut_i
$load s_h
$load nOut_h
$load dom2for
$load nEqui
$load d_qS
$load d_qD
$load d_qSEqui
$load d_pEqui
$load dur_p
$load inv_p
$load dur2inv
$load svngs
$load mapOut
$load knotOutTree
$load branchOut
$load branchNOut
$load mapInp
$load knotOut
$load knotNOut
$load branch2Out
$load branch2NOut
$load map
$load output
$load input
$load int
$GDXIN
$offMulti;

variables
	vD[t,s,n]
	vS[t,s,n]
	TotalTax[t,s]
	p[t,n]
	qD[t,s,n]
	rDepr[t,s,n]
	qS[t,s,n]
	pD[t,s,n]
	pS[t,s,n]
	mu[t,s,n,nn]
;
$GDXIN %IO_A_0%
$onMulti
$load vD
$load vS
$load TotalTax
$load p
$load qD
$load rDepr
$load qS
$load pD
$load pS
$load mu
$GDXIN
$offMulti;




# --------------------------------------------B_ValueShares-------------------------------------------
#  Initialize B_ValueShares equation block
# ----------------------------------------------------------------------------------------------------
EQUATION E_Out_knot[t,s,n];
E_Out_knot[t,s,n]$(knotouttree[s,n]).. 								vD[t,s,n]	 =E=  sum(nn$(map[s,nn,n] and branchOut[s,nn]), vS[t,s,n])+sum(nn$(map[s,nn,n] and branchNOut[s,nn]), vD[t,s,n]);
EQUATION E_Out_shares_o[t,s,n,nn];
E_Out_shares_o[t,s,n,nn]$(mapout[s,n,nn] and branchout[s,n]).. 		mu[t,s,n,nn] =E=  vS[t,s,n]/vD[t,s,nn];
EQUATION E_Out_shares_no[t,s,n,nn];
E_Out_shares_no[t,s,n,nn]$(mapout[s,n,nn] and branchnout[s,n]).. 	mu[t,s,n,nn] =E=  vD[t,s,n]/vD[t,s,nn];
EQUATION E_Inp_knot_o[t,s,n];
E_Inp_knot_o[t,s,n]$(knotout[s,n]).. 								vS[t,s,n]	 =E=  sum(nn$(map[s,n,nn]), vD[t,s,nn]);
EQUATION E_Inp_knot_no[t,s,n];
E_Inp_knot_no[t,s,n]$(knotnout[s,n]).. 								vD[t,s,n]	 =E=  sum(nn$(map[s,n,nn]), vD[t,s,nn]);
EQUATION E_Inp_shares2o[t,s,n,nn];
E_Inp_shares2o[t,s,n,nn]$(mapinp[s,n,nn] and branch2out[s,nn]).. 	mu[t,s,n,nn] =E=  vD[t,s,nn]/vS[t,s,n];
EQUATION E_Inp_shares2no[t,s,n,nn];
E_Inp_shares2no[t,s,n,nn]$(mapinp[s,n,nn] and branch2nout[s,nn]).. 	mu[t,s,n,nn] =E=  vD[t,s,nn]/vD[t,s,n];

# ----------------------------------------------------------------------------------------------------
#  Define B_ValueShares model
# ----------------------------------------------------------------------------------------------------
Model B_ValueShares /
E_Out_knot, E_Out_shares_o, E_Out_shares_no, E_Inp_knot_o, E_Inp_knot_no, E_Inp_shares2o, E_Inp_shares2no
/;


vS.fx[t,s,n]$(output[s,n]) = vS.l[t,s,n];
vD.fx[t,s,n]$(input[s,n]) = vD.l[t,s,n];
mu.lo[t,s,n,nn]$(map[s,n,nn]) = -inf;
mu.up[t,s,n,nn]$(map[s,n,nn]) = inf;
vD.lo[t,s,n]$(int[s,n]) = -inf;
vD.up[t,s,n]$(int[s,n]) = inf;

# ----------------------------------------------------------------------------------------------------
#  Define valueShare_APi_B model
# ----------------------------------------------------------------------------------------------------
Model valueShare_APi_B /
E_Out_knot, E_Out_shares_o, E_Out_shares_no, E_Inp_knot_o, E_Inp_knot_no, E_Inp_shares2o, E_Inp_shares2no
/;


variable randomnameobj;  
randomnameobj.L = 0;

EQUATION E_EmptyNLPObj;
E_EmptyNLPObj..    randomnameobj  =E=  0;

Model M_SolveEmptyNLP /
E_EmptyNLPObj, valueShare_APi_B
/;
solve M_SolveEmptyNLP using NLP min randomnameobj;
