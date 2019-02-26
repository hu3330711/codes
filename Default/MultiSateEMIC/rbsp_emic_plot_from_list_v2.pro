;plot rbsp a and b from list

PRO RBSP_EMIC_plot_from_list_v2,sc,year,month
 
  set_plot,'ps'
  !p.background='ffffff'xl
  !p.color=0
  ;init set
  rbsp_init
  sc=sc  

  ;READ LIST------------------
  f_id='/usr2/postdoc/shenxc/list_'+year+'_'+month+'RBSP'+sc+'.txt'  
;  f_id='/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_third_result/eventlist/list_'+year+'_'+month+'RBSP'+sc+'.txt'
  
  line=file_lines(f_id)

  list=strarr(2,line)

  OPENR,lun,f_id,/get_lun
  READF,lun,list,format='(A19,1X,A19)'
  CLOSE,lun
  
  start_time='Start_time'
  end_time='End_time'

  for i=1,line-1 do begin

    del_data,'*'

    ;LOAD DATA
    ;set date and probe

    st=list[0,i]
    et=list[1,i]
    
    if time_double(et)-time_double(st) lt 2.*60 then continue
    
    date=strmid(st,0,10)
    date2=strmid(et,0,10)
    
    time1=strmid(st,11,8)
    time2=strmid(et,11,8)
    
    pre_win=60.*15
    post_win=60.*15
    
    if not strmatch(strmid(time_string(time_double(st)-pre_win),0,10),date) then pre_win=time_double(st)-time_double(date)
    if not strmatch(strmid(time_string(time_double(et)+post_win),0,10),date2) then post_win=time_double(date)+60.*60*24-time_double(et)
    
    trange_data=[time_double(st)-pre_win,time_double(et)+post_win]
    trange_plot=[time_double(st)-pre_win,time_double(et)+post_win]
    timespan, trange_data[0],trange_data[1]-trange_data[0],/seconds

    
    rbspx = 'rbsp'+sc

    ;>>>>>>>>>>>>>>>>>> mGSE2GSE associated >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    rbsp_load_spice_kernels
    ;Get spin-axis pointing vector. Used for rotation from GSE -> MGSE
    time2=time_double(date) ; first get unix time double for beginning of day

    ;Grab first and last time of day
    time2 = [time2,time2+86399.]
    time3=time_string(time2, prec=6) ; turn it back into a string for ISO conversion
    strput,time3,'T',10 ; convert TPLOT time string 'yyyy-mm-dd/hh:mm:ss.msec' to ISO 'yyyy-mm-ddThh:mm:ss.msec'
    cspice_str2et,time3,et2 ; convert ISO time string to SPICE ET

    cspice_pxform,'RBSP'+strupcase(sc)+'_SCIENCE','GSE',et2[0],pxform1
    cspice_pxform,'RBSP'+strupcase(sc)+'_SCIENCE','GSE',et2[1],pxform2

    wsc1=dblarr(3)
    wsc1[2]=1d
    wsc_GSE1=dblarr(3)

    wsc2=dblarr(3)
    wsc2[2]=1d
    wsc_GSE2=dblarr(3)

    wsc_GSE1 = pxform1 ## wsc1  ;start of day
    wsc_GSE2 = pxform2 ## wsc2  ;end of day
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    ;load position and velocity data

    rbsp_load_emfisis,probe=sc,coord='gsm'
    rbsp_load_emfisis,probe=sc,coord='gsm',cadence='hires'

    rbsp_load_ect_l3,sc,'mageis',/get_support_data

    get_data,'rbsp'+sc+'_emfisis_l3_hires_gsm_Mag',data=tmp

    t1=tmp.x[0]
    t2=tmp.x[n_elements(tmp.x)-1]

    num=(t2-t1)*20.
    timesrs=dblarr(num)

    for ti=0,num-1 do timesrs[ti]=tmp.x[0]+1/20.*ti

    store_data,'time_reference',data={x:timesrs,y:timesrs}
    tinterpol_mxn,'rbsp'+sc+'_emfisis_l3_hires_gsm_Mag','time_reference',/overwrite

    ;rotate all data into field aligned coordinates
    ;thm_load_state,probe=probe2, coord='gei',/get_support_data

    tsmooth2, 'rbsp'+sc+'_emfisis_l3_hires_gsm_Mag', 20.*20, newname='rbsp'+sc+'_emfisis_l3_hires_gsm_Mag_DC' ;20 seconds
    rbsp_load_spice_state,probe=sc,coord='gei',/no_spice_load
    fac_matrix_make, 'rbsp'+sc+'_emfisis_l3_hires_gsm_Mag_DC', other_dim='Xgse', pos_var_name='rbsp'+sc+'_state_pos_gei',newname = 'rotmat'
    tvector_rotate, 'rotmat', 'rbsp'+sc+'_emfisis_l3_hires_gsm_Mag', newname = 'rbsp'+sc+'_emfisis_l3_hires_fac_Mag'
    ;tvector_rotate, 'rotmat', 'rbsp'+sc+'_efw_esvy_gsm_vxb_removed_spinfit', newname = 'rbsp'+sc+'_efw_esvy_fac_vxb_removed_spinfit'

    twavpol, 'rbsp'+sc+'_emfisis_l3_hires_fac_Mag',nopfft=1024,steplength=512

    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_waveangle',data=tmp,dlim=dlim
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_waveangle_degree',data={x:tmp.x,y:tmp.y/!pi*180.,v:tmp.v},dlim=dlim

    tmedian,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_powspec',0

    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_powspec',data=d
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_powspec_sm',data=bg


    ;to highligh the part with high wave power, 10 times stronger than background
    ;start here
    for k=0,n_elements(d.x)-1 do begin
      for j=0,n_elements(d.v)-1 do begin
        if d.y[k,j]/bg.y[k,j] le 10 then d.y[k,j]=!values.F_nan else d.y[k,j]=1
      endfor
    endfor


    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_waveangle_degree',data=tmp,dlim=dlim
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_waveangle_degree',data={x:tmp.x,y:tmp.y*d.y,v:tmp.v},dlim=dlim

    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_elliptict',data=tmp,dlim=dlim
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_elliptict',data={x:tmp.x,y:tmp.y*d.y,v:tmp.v},dlim=dlim
    
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_degpol',data=tmp,dlim=dlim
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_degpol',data={x:tmp.x,y:tmp.y*d.y,v:tmp.v},dlim=dlim
    
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_degpol',data=tmp,dlim=dlim
    
    
    judgdt=where(time_double(tmp.x) ge time_double(st) and time_double(tmp.x) le time_double(et))

    mediandeg=median(tmp.y[judgdt,1:*])
    meandeg=mean(tmp.y[judgdt,1:*],/nan)
    
    goodpoint=where(tmp.y[judgdt,1:*] ge 0, pointnum)

    ;end here
    ;-----------------------------

    get_data,'rbsp'+sc+'_emfisis_l3_4sec_gsm_Magnitude',data=mag
    fce = 28.*mag.y
    store_data,'rbsp'+sc+'_fce_a',data={x:mag.x,y:fce}
    store_data,'rbsp'+sc+'_fcp_a',data={x:mag.x,y:fce/1836.}
    store_data,'rbsp'+sc+'_fche_a',data={x:mag.x,y:fce/7344.}
    store_data,'rbsp'+sc+'_fco_a',data={x:mag.x,y:fce/29376.}
    
  

    store_data,'rbsp'+sc+'_WNA',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_waveangle_degree','rbsp'+sc+'_fcp_a','rbsp'+sc+'_fche_a','rbsp'+sc+'_fco_a']
    store_data,'rbsp'+sc+'_Ellipticity',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_elliptict','rbsp'+sc+'_fcp_a','rbsp'+sc+'_fche_a','rbsp'+sc+'_fco_a']
    store_data,'rbsp'+sc+'_SpectralDensity',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_powspec','rbsp'+sc+'_fcp_a','rbsp'+sc+'_fche_a','rbsp'+sc+'_fco_a']

    zlim,'rbsp'+sc+'_SpectralDensity',1e-4,1e2,1
    zlim,'rbsp'+sc+'_WNA',0,90
    zlim,'rbsp'+sc+'_Ellipticity',-1,1




    ylim,'*',0.1,10,1

    options,'rbsp*fc*a','color',1
    options,'rbsp*fc*a',thick=4
    options,'rbsp*fche_a',linestyle=2
    options,'rbsp*fco_a',linestyle=1

    !p.CHARSIZE=1
    !p.charthick=1

    tplot_options,'xthick',2
    tplot_options,'ythick',2
    tplot_options,'zthick',2

    tplot_options,'title','RBSP-'+sc+' '+string(mediandeg)+''+string(pointnum)

    options,'rbsp'+sc+'_ect_mageis_L3_L','ytitle','L!IA'
    options,'rbsp'+sc+'_ect_mageis_L3_L','ytitle','L!IB'
    options,'rbsp'+sc+'_ect_mageis_L3_MLT','ytitle','MLT!IA'
    options,'rbsp'+sc+'_ect_mageis_L3_MLT','ytitle','MLT!IB'
    options,'rbsp'+sc+'_ect_mageis_L3_MLAT','ytitle','MLAT!IA'
    options,'rbsp'+sc+'_ect_mageis_L3_MLAT','ytitle','MLAT!IB'


    options,'rbsp'+sc+'_SpectralDensity',ytitle='RBSP-'+sc,ysubtitle='Frequency [Hz]',ztitle='[(nT)!E2!N/Hz]'
  
    options,'rbsp'+sc+'_WNA',ytitle='RBSP-'+sc,ysubtitle='Frequency [Hz]',ztitle='WNA [deg]',ztickinterval=30,zminor=3
   
    options,'rbsp'+sc+'_Ellipticity',ytitle='RBSP-'+sc,ysubtitle='Frequency [Hz]',ztitle='Ellipticity'
    
    
    

    options,'rbsp*_SpectralDensity',ztickunits='Scientific'
    options,'*',zticklen=-0.4
    options,'*',xticklen=0.1
    
    
    if mediandeg gt 0.7 then begin
      
      popen,'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2),xsize=8,ysize=9,units=cm,/encapsulated
        tplot,['rbsp'+sc+'_SpectralDensity','rbsp'+sc+'_WNA','rbsp'+sc+'_Ellipticity'],trange=trange_plot,$
        var_label=['rbsp'+sc+'_ect_mageis_L3_MLAT','rbsp'+sc+'_ect_mageis_L3_MLT','rbsp'+sc+'_ect_mageis_L3_L']
      pclose
      
      spawn,'convert -density 90 -background "#FFFFFF" -flatten '+'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2)+'.eps '+'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2)+'.png'

      start_time=[start_time,st]
      end_time=[End_time,et]
    endif else begin
      popen,'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/removed/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2),xsize=8,ysize=9,units=cm,/encapsulated
      tplot,['rbsp'+sc+'_SpectralDensity','rbsp'+sc+'_WNA','rbsp'+sc+'_Ellipticity'],trange=trange_plot,$
        var_label=['rbsp'+sc+'_ect_mageis_L3_MLAT','rbsp'+sc+'_ect_mageis_L3_MLT','rbsp'+sc+'_ect_mageis_L3_L']
      pclose

      spawn,'convert -density 90 -background "#FFFFFF" -flatten '+'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/removed/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2)+'.eps '+'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/removed/RBSP_'+sc+'_EMIC_wave_polorization_'+strmid(st,0,10)+'T'+strmid(st,11,2)+strmid(st,14,2)+'.png'

    endelse
    
  endfor
  
  all_event=[transpose(start_time),transpose(end_time)]
  output_txt, all_event, filename = '/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/eventlist/list_'+year+'_'+month+'RBSP'+sc+'.txt'
  ;write_csv,'/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/eventlist/list_'+year+'_'+month+'RBSP'+sc+'.csv',start_time,end_time
  
END
