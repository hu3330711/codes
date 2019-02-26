pro k_pa_l_dipole
l=double(4.0)
b0_earth=double(0.30911553)
b0=b0_earth/l^3

pa=double(54.5)
pa_rad=pa/180.*!pi

f2=double(1.)/(sin(pa_rad)^2)
for i=0l,9e4 do begin
  lam_tmp=double(i)/9.e4*!pi/2.
  f1=sqrt(double(1.) + double(3.) * (sin(lam_tmp))^2)/((cos(lam_tmp))^6)
  if f1 ge f2 then break
endfor

lam_mirror=double(i)/1.e3
lam_mirror_rad=lam_mirror/180.*!pi
print,'mirror latitude',lam_mirror

n_x=100
x_m=sin(double(lam_mirror_rad))
step_x=double(x_m/n_x)

k_x=sqrt(double(1.) -(sin(pa_rad))^2)*step_x/2.
for i=1,n_x-1 do begin
  x_tmp=step_x*double(i)
  k_x=k_x+sqrt(double(1.) -(sin(pa_rad))^2*sqrt(double(1.) + 3*x_tmp^2)/((double(1.) -x_tmp^2)^3))*sqrt(double(1.) +3.*x_tmp^2)*step_x
endfor

k_inv=k_x*2.*l*sqrt(b0/(sin(pa_rad))^2)
end