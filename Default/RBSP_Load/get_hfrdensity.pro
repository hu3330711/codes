pro get_HFRDensity,yy,mm,dd,sc,exist=exist
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L2/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_HFR-spectra_emfisis-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
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
  
  ;;;store data
  store_data,'HFR_Spectra',data={x:dHFR.x,y:dHFR.y,v:transpose(dHFR.v[0,*])}
  options,'HFR_Spectra',ztitle='HFR spectra!C!C((V/m)!u2!n/Hz)'
  options,strjoin('HFR_Spectra'),'spec',1
  options,strjoin('HFR_Spectra'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  ylim,'HFR_Spectra',1e4,5e5,1
  zlim,'HFR_Spectra',1e-17,1e-13,1
  
  store_data,'HFR_Spectra_combo',data=['HFR_Spectra','fce_eq','fce_eq_double','fce_eq_half','fUHR']
  ylim,'HFR_Spectra_combo',1e4,5e5,1
  zlim,'HFR_Spectra_combo',1e-17,1e-13,1
  options,'HFR_Spectra_combo',ztitle='HFR spectra!C!C((V/m)!u2!n/Hz)',spec=1,ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  options,strjoin('HFR_Spectra_combo'),'spec',1
end
