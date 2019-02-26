pro get_ElectronFluxPSD,yy,mm,dd,sc,exist=exist,noclean=noclean
if not keyword_set(noclean) then noclean=0

  Ek_min=1e2 & Ek_max=5e4
  
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/hope/level3/', $
    'rbsp'+sc+'_rel*_ect-hope-PA-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1];,/get_support_data
  
  get_timespan,t
  data_tlimit,time_string(t[0]),time_string(t[1])
  
  get_data,'FEDU',data=dFPDU ;;P HE O E
  time=dFPDU.x
  Ek=transpose(dFPDU.v2[0,*])
  pitch=dFPDU.v1
  n_pitch=n_elements(pitch)
  n_pitch_90=n_pitch/2+1
  for i=0,n_pitch-1 do begin
    Ek=transpose(dFPDU.v2[0,*])
    if i lt 9.5 then suffix='_0'+strcompress(string(i),/remove_all) else suffix='_'+strcompress(string(i),/remove_all)
    
    flux=dFPDU.y[*,*,i]
    index_zeros=where(flux eq 0,count)
    if count ge 1 then begin
      Flux[index_zeros]=0.0/0.0
      remove_nan_3d,flux,time,Ek,flux_new
      flux=flux_new
    endif
    
    if (noclean ne 1) then begin
      clean_hope,ek,flux,ek1,flux1
      ek=ek1 & flux=flux1
    endif
    
    store_data,'EFlux'+suffix,data={x:time,v:Ek,y:Flux},dlim={spec:'1B'}
    ylim,'EFlux'+suffix,Ek_min,Ek_max,1
    zlim,'EFlux'+suffix,1,1,1
    options,'EFlux'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='Electron flux!C!C(s!U-1!Ncm!U-2!Nsr!U-1!NkeV!U-1!N)',ytickformat='exponent'
  endfor
  
  for i=0,n_pitch_90-1 do begin
    suffix='_HalfPA_'+strcompress(string(i),/remove_all)
    
    Ek=transpose(dFPDU.v2[0,*])
    flux=(dFPDU.y[*,*,i]+dFPDU.y[*,*,n_pitch-i-1])/2.
    index_zeros=where(flux eq 0,count)
    if count ge 1 then begin
      Flux[index_zeros]=0.0/0.0
      remove_nan_3d,flux,time,Ek,flux_new
      flux=flux_new
    endif
    
    if (noclean ne 1) then begin
      clean_hope,ek,flux,ek1,flux1
      ek=ek1 & flux=flux1
    endif
    
    store_data,'EFlux'+suffix,data={x:time,v:Ek,y:Flux},dlim={spec:'1B'}
    ylim,'EFlux'+suffix,Ek_min,Ek_max,1  ;;FPSA, FHESA, FOSA, FESA,
    zlim,'EFlux'+suffix,1,1,1
    options,'EFlux'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='Electron flux!C!C(s!U-1!Ncm!U-2!Nsr!U-1!NkeV!U-1!N)',ytickformat='exponent'
  endfor
  
  store_data,'PitchAngleDeg_For_EFluxPSD',data={x:indgen(n_pitch),y:pitch}
  store_data,'PitchAngleDeg_For_EFluxPSD_HalfPA',data={x:indgen(n_pitch_90),y:pitch[0:n_pitch_90-1]}
end
