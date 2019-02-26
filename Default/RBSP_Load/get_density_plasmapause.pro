pro get_density_plasmapause,yy,mm,dd,sc,exist=exist,load_efw=load_efw,load_emfisis=load_emfisis
if ~keyword_set(load_efw) then begin
  load_efw=1
endif else begin
  if load_efw ne 0 then load_efw=1
endelse
if ~keyword_set(load_emfisis) then begin
  load_emfisis=1
endif else begin
  if load_emfisis ne 0 then load_emfisis=1
endelse

  exist=0
  get_B0State,yy,mm,dd,sc,exist=exist
  if exist eq 0 then return
  exist=0
  get_HFRDensity,yy,mm,dd,sc,exist=exist
  if exist eq 0 then return
  tinterpol_mxn,'L_sm','HFR_Spectra',newname='L'
  tinterpol_mxn,'fce_eq','HFR_Spectra',newname='fce_eq'
  get_pp_from_hfr_fce
  get_data,'L',data=dl

  exist_nehfr=0
if load_emfisis ne 0 then begin
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_density_emfisis-L4_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then $
    filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_density_emfisis_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)

  flag=0
  if count ge 1 then begin
  for index_file=count-1,0,-1 do begin
    cdf2tplot,file=filename[count-1],/get_support_data
    get_data,'density',data=density,index=flag
    if flag ne 0 then begin
      exist_nehfr=1
      break
    endif
  endfor
  if exist_nehfr eq 1 then begin
    time_out=density.x
    density_out=density.y
    for index_t=1,n_elements(density.x)-1 do begin
      if density.x[index_t]-density.x[index_t-1] ge 3600. then begin
        time_out=[reform(time_out),(density.x[index_t]+density.x[index_t-1])/2.]
        density_out=[reform(density_out),-1e30]
      endif
    endfor
    index=sort(time_out)
    store_data,'density',data={x:time_out[index],y:density_out[index]}
    tinterpol_mxn,'density','pp',newname='density_hfr_int',/nan_extrapolate
  endif
  endif
endif

  exist_neefw=0
  if load_efw ne 0 then begin
  dir_local='/projectnb/burbsp/big/SATELLITE/rbsp/rbsp.space.umn.edu/data/rbsp/rbsp'+sc+'/l3/20'+yy+'/'
  filename0='rbsp'+sc+'_efw-l3_20'+yy+mm+dd+'_v*.cdf'
  filename=file_search(dir_local+filename0,/fold_case,count=count)
  if count ge 1 then begin
    catch,err_status
    if err_status ne 0 then begin
      count=count-1
      if count lt 1 then catch,/cancel
    endif
    if count ge 1 then data=readcdf(filename[count-1])
    catch,/cancel
    if count ge 1 then begin
      time=data.epoch.data
      cdf_epoch,time,year,month,date,hour,minute,sec,mili,/break
      time_st_tmp=string(year,format='(I4.4)')+'-'+string(month,format='(I2.2)')+'-'+string(date,format='(I2.2)')+'/'+$
        string(hour,format='(I2.2)')+':'+string(minute,format='(I2.2)')+':'+string(sec,format='(I2.2)')+'.'+string(mili,format='(I3.3)')
      density=data.density.data
      
      n_time_original=n_elements(time_st_tmp)
      time_out=time_double(time_st_tmp)
      density_out=density
      for index_t=1,n_time_original-1 do begin
        if time_out[index_t]-time_out[index_t-1] ge 3600. then begin
          time_out=[reform(time_out),(time_out[index_t]+time_out[index_t-1])/2.]
          density_out=[reform(density_out),-1e30]
        endif
      endfor
      index=sort(time_out)
      store_data,'density',data={x:time_out[index],y:density_out[index]}
      tinterpol_mxn,'density','pp',newname='density_efw_int',/nan_extrapolate
      exist_neefw=1
    endif
  endif
  endif

  get_data,'density_hfr_int',data=dne_hfr
  get_data,'density_efw_int',data=dne_efw
  if exist_neefw eq 1 and exist_nehfr eq 1 then begin
    index=where((~finite(dne_hfr.y) or dne_hfr.y le 0) and (finite(dne_efw.y) and dne_efw.y gt 0),count)
    dne_hfr.y[index]=dne_efw.y[index]
    store_data,'density',data={x:dne_hfr.x,y:dne_hfr.y}
    exist=1
  endif
  if exist_neefw eq 1 and exist_nehfr eq 0 then begin
    copy_data,'density_efw_int','density'
    exist=1
  endif
  if exist_neefw eq 0 and exist_nehfr eq 1 then begin
    copy_data,'density_hfr_int','density'
    exist=1
  endif
  if exist_neefw eq 0 and exist_nehfr eq 0 then exist=0

  if exist ne 0 then begin
    get_data,'density',data=dne
    index=where(dne.y le 0 or ~finite(dne.y),count)
    if count ge 1 then dne.y[index]=0./0.
    store_data,'density',data={x:dne.x,y:dne.y}
  
    ylim,'density',1e0,3e3,1
    get_data,'pp',data=pp
    get_data,'density',data=density

    index=where(pp.y eq 1 and (density.y ge 1390*(3/dl.y)^4.83 or density.y ge 80) and finite(density.y),count)
    if count ge 1 then pp.y[index]=0
    index=where(pp.y eq 0 and (density.y le 124*(3/dl.y)^4 or density.y le 30) and density.y gt 0 and finite(density.y),count)
    if count ge 1 then pp.y[index]=1
    index=where(dl.y le 2,count)
    if count ge 1 then pp.y[index]=0
    store_data,'pp',data={x:pp.x,y:pp.y}
    ylim,'pp',-1,2,0

    ;;;get Ne, EA begin;;;
    tinterpol_mxn,'Magnitude','density',newname='Magnitude_int'
    get_data,'Magnitude_int',data=dB0
    get_data,'density',data=dne
    density=dne.y

    Ea=(dB0.y*1e-9)^2/2/(4e-7*!pi)/(density*1e6)/1.6e-19

    store_data,'AlfvenEnergy',data={x:dne.x,y:Ea}
    ylim,'AlfvenEnergy',1e2,1e5,1
    options,'AlfvenEnergy',ylog=1,ytitle='Alfven Energy!C',ysubtitle='(eV)',ytickformat='exponent'
    ;;;get Ne, EA end;;;
  endif
  
  options,'density',yrange=[1e-1,3e3],/ylog,ytitle='density [cm!U-3!N]',ysubtitle='',ytickformat='exponent'
end
