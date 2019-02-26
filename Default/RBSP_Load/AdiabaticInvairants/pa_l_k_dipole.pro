pro pa_l_k_dipole,lvalue,k0,pa0
n_pa=90
n_x=10
pa=(dindgen(n_pa)+1)/180.*!pi
  
  K_l_pa_dipole,lvalue, pa[0],k_tmp
  if(k_tmp le k0) then begin
    pa0=pa[0]
    return
  endif
  k_l_pa_dipole,lvalue,pa[n_pa-1],k_tmp
  if(k_tmp ge k0) then begin
    pa0=pa[n_pa-1]
    return
  endif
  
  for i=1,n_pa-1 do begin
    k_l_pa_dipole,lvalue,pa[i],k_tmp
    if(k_tmp lt k0) then break
  endfor
  pa0=pa[i-1]
  
  step_x=(pa[1]-pa[0])/n_x
  for i=1,n_x do begin
    pa_tmp=step_x*i+pa0
    k_l_pa_dipole,lvalue,pa_tmp,k_tmp
    if(k_tmp lt k0) then break
  endfor
  pa0=pa0+step_x*(i-1)
  
  step_x=(pa[1]-pa[0])/n_x/n_x
  for i=1,n_x do begin
    pa_tmp=step_x*i+pa0
    k_l_pa_dipole,lvalue,pa_tmp,k_tmp
    if(k_tmp lt k0) then break
  endfor
  pa0=pa0+step_x*(i-1)
  
  step_x=(pa[1]-pa[0])/n_x/n_x/n_x
  for i=1,n_x do begin
    pa_tmp=step_x*i+pa0
    k_l_pa_dipole,lvalue,pa_tmp,k_tmp
    if(k_tmp lt k0) then break
  endfor
  pa0=pa0+step_x*(i-1)
end