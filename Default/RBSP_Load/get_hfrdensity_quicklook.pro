pro get_HFRDensity_quicklook,yy,mm,dd,sc,exist=exist,load_density=load_density
  if not keyword_set(load_density) then load_density=0
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/Quick-Look/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_HFR-spectra_emfisis-Quick-Look_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1]
  get_data,'HFR_Spectra',data=dHFR
  ;;;remove tones
  avg_hfr=dblarr(n_elements(dhfr.v))
  for i=0,n_elements(dhfr.v)-1 do avg_hfr[i]=median(dhfr.y[*,i])
  for i=1,n_elements(dhfr.v)-2 do begin
    if avg_hfr[i] ge 5*avg_hfr[i-1] and avg_hfr[i] ge 5*avg_hfr[i+1] then begin
    dHFR.y[*,i]=(dHFR.y[*,i-1]*(dHFR.v[i+1]-dHFR.v[i])+ $
      dHFR.y[*,i+1]*(dHFR.v[i]-dHFR.v[i-1]))/(dHFR.v[i+1]-dHFR.v[i-1])
    i=i+1
    endif
  endfor
  
  ;;;remove spikes
  for i=1,n_elements(dHFR.x)-2 do begin
    a=where(dHFR.y[i,*] gt 1e-15, count)
    if count ge 41 then dHFR.y[i,*]=0.0/0.0
  endfor
  remove_nan_3d,dHFR.y,dHFR.x,transpose(dHFR.v[0,*]),ynew
  dHFR.y=ynew
  ;;;store data
  store_data,'HFR_Spectra',data={x:dHFR.x,y:dHFR.y,v:transpose(dHFR.v[0,*])}
  options,'HFR_Spectra',ztitle='HFR spectra!C!C((V/m)!u2!n/Hz)'
  options,strjoin('HFR_Spectra'),'spec',1
  options,strjoin('HFR_Spectra'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  ylim,'HFR_Spectra',1e4,5e5,1
  zlim,'HFR_Spectra',1e-17,1e-13,1
  
  get_timespan,t
  data_tlimit,time_string(t[0]),time_string(t[1])
  
  if (load_density eq 1) then get_fuhrDensityEa,filename_out=filename_out
  
  store_data,'HFR_Spectra_combo',data=['HFR_Spectra','fce_eq','fce_eq_double','fce_eq_half','fUHR']
  ylim,'HFR_Spectra_combo',1e4,5e5,1
  zlim,'HFR_Spectra_combo',1e-17,1e-13,1
end
