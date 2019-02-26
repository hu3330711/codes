pro K_l_pa_dipole,lshell, pa,k
b_eq=0.30911553/lshell^3

  n_x=101
  
  lambda_mirror,pa,lam_mirror
  
  x_m = double(sin(lam_mirror))
  pa=double(pa)
  step_x = x_m / (n_x - 1)
  j_pa=step_x/2.*sqrt(abs(1.-(sin(pa))^2*sqrt(1.+3.*x_m^2)/(1.-x_m^2)^3))*sqrt(1.+3*x_m^2)+step_x/2.*sqrt(1.-(sin(pa))^2)

  for i=2,n_x-1 do begin
    x=step_x*(i-1)
    j_pa=j_pa+step_x*sqrt(abs(1-(sin(pa))^2*sqrt(1+3*x^2)/(1-x^2)^3))*sqrt(1+3*x^2)
  endfor
  
  k=j_pa*2.*lshell*sqrt(B_eq/(sin(pa))^2)
  
  if pa lt 0.1/180*!pi then k=20
end