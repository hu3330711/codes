;; Get full dispersion relation for multi-ion of H, He, O
;; Input: b0 (background magnetic field in T), ne0 (density in m^-3), omega_w (wave frequency in rad/s), wn (normal angle in rad)
;; Input (Optional): wave_mode ('R' for R-mode [default]; 'L' for L-mode)
;; Input (Optional): rho_p_he_o (ion composition of [H, He, O], [1., 0., 0.] for default, [0.7, 0.2, 0.1] for typical value
;; Output: n_sqr (SQUARE of refractive index, positive means allowing wave propagation, negative means wave absorption)
;; Output: k_w (wave vector in m^-1, positive means allowing wave propagation, NaN means wave absorption)

pro cold_plasma_dispersion,b0,ne0,omega_w,wn,n_sqr,k_w,wave_mode=wave_mode,rho_p_he_o=rho_p_he_o
  me=double(9.1093897e-31)
  mp=double(1.6726231e-27)
  mhe=mp*4
  mo=mhe*4
  qe=double(1.60217733e-19)
  c=double(2.99792458e8)
  mu0=double(4e-7*!pi)
  epsilon0=1./c^2/mu0

  if ~keyword_set(wave_mode) then wave_mode = 'R'

  if n_elements(rho_p_he_o) eq 3 then begin
    rho_p=rho_p_he_o[0]
    rho_he=rho_p_he_o[1]
    rho_o=rho_p_he_o[2]
  endif else begin
    rho_p=1.
    rho_he=0.
    rho_o=0.
  endelse

  omega_ce=qe*b0/me
  omega_cp=qe*b0/mp
  omega_che=qe*b0/mhe
  omega_co=qe*b0/mo
  omega_pe=sqrt(ne0*qe^2/me/epsilon0)
  omega_pp=sqrt(rho_p*ne0*qe^2/mp/epsilon0)
  omega_phe=sqrt(rho_he*ne0*qe^2/mhe/epsilon0)
  omega_po=sqrt(rho_o*ne0*qe^2/mo/epsilon0)

  R_Stix=1-omega_pp^2/omega_w/(omega_w+omega_cp)-omega_phe^2/omega_w/(omega_w+omega_che)$
    -omega_po^2/omega_w/(omega_w+omega_co)-omega_pe^2/omega_w/(omega_w-omega_ce)
  L_Stix=1-omega_pp^2/omega_w/(omega_w-omega_cp)-omega_phe^2/omega_w/(omega_w-omega_che)$
    -omega_po^2/omega_w/(omega_w-omega_co)-omega_pe^2/omega_w/(omega_w+omega_ce)
  P_Stix=1-(omega_pp^2+omega_phe^2+omega_po^2+omega_pe^2)/omega_w^2
  S_Stix=(R_Stix+L_Stix)/2.
  D_Stix=(R_Stix-L_Stix)/2.

  A_Stix=S_Stix*(sin(wn))^2+P_Stix*(cos(wn))^2
  B_Stix=R_Stix*L_Stix*(sin(wn))^2+P_Stix*S_Stix*(1+(cos(wn))^2)
  C_Stix=P_Stix*R_Stix*L_Stix
  F_Stix=sqrt((R_Stix*L_Stix-P_Stix*S_Stix)^2*(sin(wn))^4+4*P_Stix^2*D_Stix^2*(cos(wn))^2)

  if wave_mode eq 'L' then if P_stix*D_stix gt 0 then n_sqr=(B_stix-F_Stix)/2/A_Stix else n_sqr=(B_stix+F_Stix)/2/A_Stix
  if wave_mode eq 'R' then if P_stix*D_stix lt 0 then n_sqr=(B_stix-F_Stix)/2/A_Stix else n_sqr=(B_stix+F_Stix)/2/A_Stix

  nr=sqrt(n_sqr)
  k_w=nr*omega_w/c
  
;  print,R_stix,L_stix,P_stix,D_stix,S_stix,A_stix,B_stix,C_stix,F_stix
;  stop
end