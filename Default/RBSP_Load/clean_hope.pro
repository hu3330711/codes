pro clean_hope,ek,flux,ek1,flux1

n_time=n_elements(flux[*,0])
n_energy=n_elements(ek)
increment=n_energy mod 2
n_energy_new=n_energy/2
ek1=dblarr(n_energy_new+increment)
flux1=dblarr(n_time,n_energy_new+increment)
ek1[0]=ek[0]
flux1[*,0]=flux[*,0]
for i=0,n_energy_new-1 do begin
  ek1[i+increment]=sqrt(ek[2*i]*ek[2*i+1])
  flux1[*,i+increment]=sqrt(flux[*,2*i]*flux[*,2*i+1])
endfor
end