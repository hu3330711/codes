pro ulf_wave_find_rbsp,sc,year,month
  
  del_data, '*'
  CLOSE,/all
  
  set_plot,'ps'
  ;init set
  rbsp_init
  year=year
  month=month
  
  if month eq 4 or month eq 6 or month eq 9 or month eq 11 then trange=[year+' '+month+' '+'01',year+' '+month+' '+'30']
  if month eq 1 or month eq 3 or month eq 5 or month eq 7 or month eq 8 or month eq 10 or month eq 12 then trange=[year+' '+month+' '+'01',year+' '+month+' '+'31']
  if month eq 2 then begin
    if (year mod 4) eq 0 then trange=[year+' '+month+' '+'01',year+' '+month+' '+'29'] else trange=[year+' '+month+' '+'01',year+' '+month+' '+'28']
  endif
  
  ;trangefft=['2007-07-04/13:20','2007-07-04/24:10']
  
  step_hours=24.0
  
  st=trange[0]
  
  et=time_string(time_double(trange[0])+60.*60*step_hours)

  sc=sc
 
  start_time='Start_time'
  end_time='End_time'
  
  
  ;LOAD DATA
  ;set date and probe

  
  WHILE time_double(st) le time_double(trange[1]) do begin
    
    date=strmid(st,0,10)
  
    ;trange_data=[time_double(st)-60.*60*0.5,time_double(et)+60.*60*0.5]
    trange_plot=[st,et]
    timespan, time_double(st),60.*60*(step_hours),/seconds
    
   
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
    
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag',data=tmp,dlim=dlim
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp',data={x:tmp.x,y:sqrt(tmp.y[*,0]^2+tmp.y[*,1]^2)},dlim=dlim
  
    nboxpoints=1024
  
    tdpwrspc, 'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp', nboxpoints=nboxpoints, nshiftpoints=256,bin=1,trange=[st,et]
    ; time_shift, 'th'+sc+'_fgl_gsm_x_dpwrspc', nboxpoints/2.*3.
   
    tmedian,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc',1
  
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc',data=d
    get_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_sm',data=bg
    
    ratio=alog10(d.y/bg.y)-1
    
    for rationum=0,n_elements(d.x)-1 do begin
      bad=where(ratio[rationum,*] le 0)
      ratio[rationum,bad]=!values.F_nan
    endfor
    
    store_data,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_ratio',data={x:d.x,y:ratio,v:d.v}
  
    fmax=fltarr(n_elements(d.x))
    ftop=fltarr(n_elements(d.x))
    fbtm=fltarr(n_elements(d.x))
  
    for i=0,n_elements(d.x)-1 do begin
      rr=reform(ratio[i,*])
      bad=where(rr le 0)
      rr[bad]=!values.F_nan
      good=where(rr ge 0, count)
     
      if count eq 0 then continue
      
      pmax=where(rr eq max(rr,/nan),count)
      if count eq 0 then continue
      if d.v[i,pmax[0]] le 0.1 then continue
      if d.v[i,pmax[0]] ge 10. then continue
      fmax[i]=d.v[i,pmax[0]]
      fbtm[i]=d.v[i,good[0]]
      endn=n_elements(good)-1
      ftop[i]=d.v[i,good[endn]]
    endfor
  
    bad=where(fmax eq 0.)
    fmax[bad]=!values.F_nan
    bad=where(ftop eq 0.)
    ftop[bad]=!values.F_nan
    bad=where(fbtm eq 0.)
    fbtm[bad]=!values.F_nan
  
    tinterpol_mxn,'rbsp'+sc+'_emfisis_l3_4sec_gsm_Magnitude','rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_sm',/overwrite
    tinterpol_mxn,'rbsp'+sc+'_ect_mageis_L3_L','rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_sm',/overwrite
    get_data,'rbsp'+sc+'_emfisis_l3_4sec_gsm_Magnitude',data=bt
    
    ;get_data,'rbsp'+sc+'_ect_mageis_L3_L',data=Lrbsp
    
    fce = 28.*bt.y
    store_data,'fce_a',data={x:bt.x,y:fce}
    store_data,'fcp_a',data={x:bt.x,y:fce/1836.}
    store_data,'fche_a',data={x:bt.x,y:fce/7344.}
    store_data,'fco_a',data={x:bt.x,y:fce/29376.}
    
    for i=0,n_elements(d.x)-1 do begin
      ;timejudg=where(time_double(bt.x) ge time_double(d.x[i]))
      gyro_p=28.*bt.y[i]/1836.
      gyro_o=28.*bt.y[i]/29376.
      
      bottom=where(d.v[i,*] ge fbtm[i] and d.v[i,*] ge fce[i]/29376.,ind1)
      top=where(d.v[i,*] le ftop[i] and d.v[i,*] le fce[i]/1836.,ind2)
      
      if ind1 gt 0 and ind2 gt 0 and fce[i]/1836. lt 10. and bottom[0] lt top[n_elements(top)-1] then begin
        goodpoint=where(ratio[i,bottom[0]:top[n_elements(top)-1]] gt 0,count3)
        if count3 le 10 then begin
          fmax[i]=!values.F_nan
          ftop[i]=!values.F_nan
          fbtm[i]=!values.F_nan
        endif
      endif
      
      
      if fmax[i] gt gyro_p or fmax[i] lt gyro_o or (ftop[i]/fbtm[i] lt 1.2) or (fmax[i]/fbtm[i] lt 1.1) or (ftop[i]/fmax[i] lt 1.1) or bt.y[i] gt 1100. then begin
        fmax[i]=!values.F_nan
        ftop[i]=!values.F_nan
        fbtm[i]=!values.F_nan
      endif  
    endfor
    
    
    fremax=dblarr(n_elements(d.x))
    fretop=dblarr(n_elements(d.x))
    frebtm=dblarr(n_elements(d.x))

    fremax[*]=!values.F_nan
    fretop[*]=!values.F_nan
    frebtm[*]=!values.F_nan
    
            
    for i=5,n_elements(d.x)-6 do begin
      judge1=where(fmax[i-5:i+5] gt 0, count1)
      judge2=where(fmax[i-2:i+2] gt 0, count2)
      
      badt=where(bt.x ge d.x[i])
      
      bottom=where(d.v[i,*] ge fbtm[i] and d.v[i,*] ge fce[i]/29376.)
      top=where(d.v[i,*] le ftop[i]and d.v[i,*] le fce[i]/1836.)
      maxf=where(d.v[i,*] eq fmax[i])
      
      ele_num=n_elements(d.y[i-5:i+5,bottom[0]:maxf[0]])
   
      if ele_num le 15 then continue
     
      if fbtm[i] lt fce[i]/29376. and double(count3)/ele_num gt 0.6 and median(d.y[i-5:i+5,bottom[0]:maxf[0]]) gt 0.8*median(d.y[i-5:i+5,maxf[0]-5:maxf[0]+5]) then continue
      
      if count1 ge 5 and max(fmax[i-5:i+5])/min(fmax[i-5:i+5]) ge 1.05 then begin ;or (fbtm[i] le 0.05)
 
        fremax[i-5:i+5]=fmax[i-5:i+5]
        fretop[i-5:i+5]=ftop[i-5:i+5]
        frebtm[i-5:i+5]=fbtm[i-5:i+5]
        
      endif
      
      if count2 ge 3 and max(fmax[i-2:i+2])/min(fmax[i-2:i+2]) ge 1.05 then begin
        
        fremax[i-2:i+2]=fmax[i-2:i+2]
        fretop[i-2:i+2]=ftop[i-2:i+2]
        frebtm[i-2:i+2]=fbtm[i-2:i+2]
        
      endif
    endfor
    
    tout=time_string(time_double(st))
    goodt=where(fremax gt 0,count)
    
    if count gt 2 then begin
      time_list=time_string(d.x[goodt],TFORMAT='YYYY-MM-DD/hh:mm:ss')
      for tx=0,n_elements(time_list)-2 do begin

        If n_elements(start_time) eq n_elements(end_time) then begin
          start_time=[start_time,time_list[tx]]
        Endif else begin
          If (time_double(time_list[tx+1])-time_double(time_list[tx])) le 30.*60 then continue
          end_time=[end_time,time_list[tx]]
        Endelse

      endfor

      
      
      If n_elements(start_time) eq n_elements(end_time) then begin
        ;Print,n_elements(start_time)+' events were identified on '+strmid(tout,0,10)
      Endif else begin
        end_time=[end_time,time_list[n_elements(time_list)-1]]
        ;print,n_elements(start_time)+' events were identified on '+strmid(tout,0,10)
      Endelse
    endif
    
    
  
    options,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_ratio',spec=1
    zlim,'rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrsp*',1e-4,1e2,1
  
    store_data,'dot1',data={x:d.x,y:fretop}
    store_data,'dot2',data={x:d.x,y:fremax}
    store_data,'dot3',data={x:d.x,y:frebtm}

  
    store_data,'dot',data=['dot1','dot2','dot3','fcp_a','fche_a','fco_a']

    options,'dot1',Psym=1,sym_size=1
    options,'dot3',Psym=1,sym_size=1
    options,'dot2',color=6,Psym=1,sym_size=1.5
    
    options,'f*a','color',1
    options,'f*a',thick=3
    options,'fche_a',linestyle=2
    options,'fco_a',linestyle=1
    
    options,'rbsp'+sc+'_emfisis_l3_hires_gsm_Magnitude',ylog=1
    
    store_data,'SpectralDensity',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc','fcp_a','fche_a','fco_a']
    store_data,'SpectralDensity_median',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_sm','fcp_a','fche_a','fco_a']
    store_data,'Ratio',data=['rbsp'+sc+'_emfisis_l3_hires_fac_Mag_perp_dpwrspc_ratio','fcp_a','fche_a','fco_a']
  
    ylim,'SpectralDensity',0.1,10,1
    ylim,'SpectralDensity_median',0.1,10,1
    ylim,'Ratio',0.1,10,1
    ylim,'dot',0.1,10,1
  
    tplot_options,'zticklen',-0.4
    tplot_options,'zminor',10
    tplot_options,'xticklen',-0.03
    tplot_options,'yticklen',-0.01
    
    !p.CHARSIZE=1
    !p.charthick=1

    tplot_options,'xthick',2
    tplot_options,'ythick',2
    tplot_options,'zthick',2
    
    tplot_options,'title','RBSP-'+sc
    
    options,'rbsp'+sc+'_emfisis_l3_hires_gsm_Magnitude',ytitle='Bt [nT]',ysubtitle=''
    options,'SpectralDensity',ytitle='Spectral Density',ysubtitle='Frequency [Hz]',ztitle='[(nT)!E2!N/Hz]',ztickunits='Scientific'
    options,'SpectralDensity_median',ytitle='SD Median',ysubtitle='Frequency [Hz]',ztitle='[(nT)!E2!N/Hz]',ztickunits='Scientific'
    options,'Ratio',ytitle='lg(SD/SD_m)-1',ztickunits='Scientific'
    
    zlim,'Ratio',1e-2,1e2,1
    
    options,'rbspa_ect_mageis_L3_L','ytitle','L!IA'
    options,'rbspb_ect_mageis_L3_L','ytitle','L!IB'
    options,'rbspa_ect_mageis_L3_MLT','ytitle','MLT!IA'
    options,'rbspb_ect_mageis_L3_MLT','ytitle','MLT!IB'
    options,'rbspa_ect_mageis_L3_MLAT','ytitle','MLAT!IA'
    options,'rbspb_ect_mageis_L3_MLAT','ytitle','MLAT!IB'
    
    set_plot,'ps'
    
    popen,'/projectnb/burbsp/home/xcshen/RBSP_'+sc+'_EMIC_identify_'+strmid(tout,0,10)+'T'+strmid(tout,11,2)+strmid(tout,14,2),xsize=8,ysize=9,units=cm,/encapsulated
      tplot,['rbsp'+sc+'_emfisis_l3_hires_gsm_Magnitude','SpectralDensity','SpectralDensity_median','Ratio','dot'],trange=[st,et],var_label=['rbsp'+sc+'_ect_mageis_L3_MLAT','rbsp'+sc+'_ect_mageis_L3_MLT','rbsp'+sc+'_ect_mageis_L3_L'];['2007-07-04/13:30','2007-07-04/16:00']
      timebar,1000.,color=6,linestyle=2,varname='rbsp'+sc+'_emfisis_l3_hires_gsm_Magnitude',/databar
    pclose  
    
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+'/projectnb/burbsp/home/xcshen/RBSP_'+sc+'_EMIC_identify_'+strmid(tout,0,10)+'T'+strmid(tout,11,2)+strmid(tout,14,2)+'.eps '+'/projectnb/burbsp/home/xcshen/RBSP_'+sc+'_EMIC_identify_'+strmid(tout,0,10)+'T'+strmid(tout,11,2)+strmid(tout,14,2)+'.png'
   
    st=time_string(time_double(st)+step_hours*60.*60)
    et=time_string(time_double(et)+step_hours*60.*60)
   
  ENDWHILE
  
  all_event=[transpose(start_time),transpose(end_time)]
  output_txt, all_event, filename = '~/list_'+year+'_'+month+'RBSP'+sc+'.txt'
  ;write_csv,'~/list_'+year+'_'+month+'RBSP'+sc+'.csv',start_time,end_time
  
end
