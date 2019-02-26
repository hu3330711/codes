pro get_ProtonFluxPSD,yy,mm,dd,sc,exist=exist,noclean=noclean
if not keyword_set(noclean) then noclean=0

  Ek_min=1e2 & Ek_max=5e4
  
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/hope/level3/pitchangle/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-hope-PA-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1];,/get_support_data
  
  get_timespan,t
  data_tlimit,time_string(t[0]),time_string(t[1])
  
  get_data,'FPDU',data=dFPDU ;;P HE O E
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
    
    store_data,'Flux'+suffix,data={x:time,v:Ek,y:Flux},dlim={spec:'1B'}
    ylim,'Flux'+suffix,Ek_min,Ek_max,1
    zlim,'Flux'+suffix,1e2,1e6,1
    options,'Flux'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='Proton flux!C!C(s!U-1!Ncm!U-2!Nsr!U-1!NkeV!U-1!N)',ytickformat='exponent'
    
    psd_hope=Flux
    for j=0,n_elements(Ek)-1 do begin
      vel=sqrt(1-1./(double(Ek[j])/(9.38e8)+1)^2)*3e8
      psd_hope[*,j]=1.67e-7/1.6/(vel^2)*flux[*,j]
    endfor
    store_data,'PSD'+suffix,data={x:time,v:Ek,y:psd_hope},dlim={spec:'1B'}
    ylim,'PSD'+suffix,Ek_min,Ek_max,1
    zlim,'PSD'+suffix,1e-16,1e-11,1
    options,'PSD'+suffix,'spec',1
    options,'PSD'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='Proton PSD!C!C(s!U-3!Nm!U-6!N)',ytickformat='exponent'
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
    
    store_data,'Flux'+suffix,data={x:time,v:Ek,y:Flux},dlim={spec:'1B'}
    ylim,'Flux'+suffix,Ek_min,Ek_max,1  ;;FPSA, FHESA, FOSA, FESA,
    zlim,'Flux'+suffix,1e2,1e6,1
    options,'Flux'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='Proton flux!C!C(s!U-1!Ncm!U-2!Nsr!U-1!NkeV!U-1!N)',ytickformat='exponent'
    
    psd_hope=Flux
    for j=0,n_elements(Ek)-1 do begin
      vel=sqrt(1-1./(double(Ek[j])/(9.38e8)+1)^2)*3e8
      psd_hope[*,j]=1.67e-7/1.6/(vel^2)*flux[*,j]
    endfor
    store_data,'PSD'+suffix,data={x:time,v:Ek,y:psd_hope},dlim={spec:'1B'}
    ylim,'PSD'+suffix,Ek_min,Ek_max,1
    zlim,'PSD'+suffix,1e-16,1e-11,1
    options,'PSD'+suffix,'spec',1
    options,'PSD'+suffix,ytitle='Energy!C',ysubtitle='(eV)',ztitle='PSD!C!C(s!U-3!Nm!U-6!N)',ytickformat='exponent'
  endfor
  
  store_data,'PitchAngleDeg_For_FluxPSD',data={x:indgen(n_pitch),y:pitch}
  store_data,'PitchAngleDeg_For_FluxPSD_HalfPA',data={x:indgen(n_pitch_90),y:pitch[0:n_pitch_90-1]}
end
