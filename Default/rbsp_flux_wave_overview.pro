pro rbsp_flux_wave_overview,sc,st,et,trange1=trange1,trange2=trange2,trange3=trange3,dir_fig=dir_fig

  del_data,'*'

  set_plot,'ps'
  rbsp_init
  dir_init
  if not keyword_set(trange1) then begin
    if time_double(st)-10.*60 ge time_double(strmid(st,0,10)) then trange1=[time_string(time_double(st)-10.*60),time_string(time_double(st)-5.*60)] else trange1=[time_string(time_double(strmid(st,0,10))),time_string(time_double(strmid(st,0,10))+5.*60)]
    trange2=[st,time_string(time_double(st)+5.*60)]
    trange3=[time_string(time_double(st)+10.*60),time_string(time_double(st)+15.*60)]
  endif 

   
  if not keyword_set(dir_fig) then dir_fig='/projectnb/burbsp/home/xcshen/mageis_HR/'
  
  ;sc='A' & yy='12' & mm='10' & dd='11' & time1='23:15' & time2='23:59'
  sc=sc
  st=st
  et=et

  yy=strmid(st,2,2)
  mm=strmid(st,5,2)
  dd=strmid(st,8,2)
 
  yy2=strmid(et,2,2)
  mm2=strmid(et,5,2)
  dd2=strmid(et,8,2)
  
  trange=[st,et]


  time1=strmid(st,11,5)
  time2=strmid(et,11,5)

  tr1='20'+yy+'/'+mm+'/'+dd+'/'+time1
  tr2='20'+yy2+'/'+mm2+'/'+dd2+'/'+time2
  tsec1=time_double(tr1)
  tsec2=time_double(tr2)
  tr1=time_string(tsec1)
  tr2=time_string(tsec2)
  timespan,tsec1,tsec2-tsec1,/sec

 ; mode_name_all=['M75','HIGH','LOW','M35']
 mode_name_all=['M75','LOW','M35']
  for index_mode=0,n_elements(mode_name_all)-1 do begin
    print,'Now checking mode: '+mode_name_all[index_mode]
    exist=0
    filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/rbsp-ect.newmexicoconsortium.org/data_prot/rbsp'+sc+'/mageis/level3/int/20'+yy+'/', $
      'rbsp'+sc+'_int_ect-mageis'+mode_name_all[index_mode]+'-hr-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
    if count gt 0 then print,mode_name_all[index_mode],count else continue
    cdf2tplot,file=filename[count-1],/get_support_data
    
    
    get_magnetometer_tdpwrspc,probe=sc,trange=trange
    get_rbsp_location,probe=sc,trange=trange
    
    tkm2re,'rbsp'+sc+'_xyz_gsm',/km
    calculate_loss_cone_v2,posvar='rbsp'+sc+'_xyz_gsm_km',magvar='rbsp'+sc+'_Mag'
    tsmooth2,'local_loss_cone',5
    ;;; 0 to 90
    del_data,'HighRate_E*'
    get_data,'HighRate',data=d
    n_ek=n_elements(d.v2)
    n_t=n_elements(d.x)
    n_pa=n_elements(d.v1[0,*])
    pa180=d.v1
    index=where(d.v1 gt 180 and d.v1 le 360,count)
    if count ge 1 then pa180[index]=360-pa180[index]
    ymax=180
    pa90=pa180
    index=where(pa180 gt 90 and pa180 le 180,count)
    if count ge 1 then pa90[index]=180-pa180[index]
    ymax=90

    pa=pa90
    index_sort=lonarr(n_t,n_pa)
    for ttt=0,n_t-1 do begin
      index_tmp=sort(pa[ttt,*])
      pa_tmp=pa[ttt,index_tmp]
      pa[ttt,*]=pa_tmp
      index_sort[ttt,*]=index_tmp
    endfor

    get_mageis_electronflux_stevens_energy,tr1,sc,mode_name_all[index_mode],ek,g0de
    
    index_ek_name=0
    ;for eee=0,n_ek-1 do begin
    for eee=0,n_elements(g0de)-1 do begin
      
      
      cr=dblarr(n_t,n_pa)
      for ppp=0,n_pa-1 do cr[*,ppp]=d.y[*,eee,ppp]
      index1=where(d.x ge tsec1 and d.x le tsec2,count1)
      if count1 le 0 then continue
      tmp_cr=reform(cr[index1,*])
      index=where(tmp_cr gt 0,count)
      if count le 0 then continue
      max_cr=max(tmp_cr[index])
      min_cr=max_cr/10.

      for ttt=0,n_t-1 do begin
        cr_tmp=cr[ttt,index_sort[ttt,*]]
        cr[ttt,*]=cr_tmp
      endfor

      insert_nan_for_get_mageis_electronflux_stevens,pa,cr,90.,pa_out,cr_out
      pa=pa_out
      cr=cr_out

      flux=cr/g0de[index_ek_name]
      max_cr=max_cr/g0de[index_ek_name]
      min_cr=max_cr*0.1
      store_data,mode_name_all[index_mode]+'HighRate_E'+string(eee,format='(I1)'),data={x:d.x,v:pa,y:flux}
      options,mode_name_all[index_mode]+'HighRate_E'+string(eee,format='(I1)'),yrange=[0,ymax],ystyle=1,zrange=[min_cr,max_cr],/zlog,ztitle='Flux!C!C[s!U-1!Nsr!U-1!Ncm!U-2!NkeV!U-1!N]',$
        ytitle=string(round(ek[index_ek_name]),format='(I4)')+' keV!C!CPitch Angle',spec=1,ztickformat='exponent',zminor=9,zticklen=-0.3,yticks=6,yminor=3,zstyle=1
      
      store_data,mode_name_all[index_mode]+'HighRate_combo_E'+string(eee,format='(I1)'),data=[mode_name_all[index_mode]+'HighRate_E'+string(eee,format='(I1)'),'local_loss_cone_sm']
      
      draw_pa_distribution,varname=mode_name_all[index_mode]+'HighRate_E'+string(eee,format='(I1)'),trange1=trange1,trange2=trange2,trange3=trange3,eng=ek[index_ek_name]  
      
      index_ek_name=index_ek_name+1
    endfor
    
    get_emfisis_L4,probe=sc,trange=[st,et]

    options,'local_loss_cone_sm',color=190,thick=3
    ylim,mode_name_all[index_mode]+'HighRate_combo_*',0,90,0
    
    store_data,'bsum_combo',data=['RBSP'+strupcase(sc)+'_bsum','rbsp'+strlowcase(sc)+'_fce_eq','rbsp'+strlowcase(sc)+'_fce_eq_half','rbsp'+strlowcase(sc)+'_fce_eq_tenth']
    store_data,'esum_combo',data=['RBSP'+strupcase(sc)+'_esum','rbsp'+strlowcase(sc)+'_fce_eq','rbsp'+strlowcase(sc)+'_fce_eq_half','rbsp'+strlowcase(sc)+'_fce_eq_tenth']
    ylim,'*sum_combo',30,1e4,1
    options,'bsum_combo',/ylog,/zlog,ytickunits='scientific',ztickunits='scientific',zrange=[1e-9,1e-5]
    options,'esum_combo',/ylog,/zlog,ytickunits='scientific',ztickunits='scientific'
    options,'rbsp'+strlowcase(sc)+'_Bw_mag_combo',/ylog,/zlog,ytickunits='scientific',ztickunits='scientific',zrange=[1e-3,1e-1]
    options,mode_name_all[index_mode]+'HighRate_combo_E*',ytickinterval=30
    ;tplot,['HighRate_combo_E0','HighRate_combo_E2','HighRate_combo_E4','HighRate_combo_E6','Bw_mag_combo','bsum_combo','esum_combo'],var_label=['MLT','L','MLAT'],title='Van Allen Probe '+sc+' MagEIS HR '+mode_name_all[index_mode]
    
    options,'rbsp?_f*',color=190,thick=3
    tplot,[mode_name_all[index_mode]+'HighRate_combo_E*','bsum_combo','rbsp'+strlowcase(sc)+'_Bw_mag_combo'],var_label=['rbsp'+sc+'_MLT','rbsp'+sc+'_L','rbsp'+sc+'_MLAT'],title='Van Allen Probe '+sc+' MagEIS HR '+mode_name_all[index_mode]
    
    set_plot,'ps'
    device,filename=dir_fig+'0_90/MagEIS_HR_'+mode_name_all[index_mode]+'_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.ps',$
      /color,bits_per_pixel=8,/times,xsize=21,ysize=21,xoffset=0.5,yoffset=1
    !p.FONT=0
    !p.BACKGROUND='ffffff'xl
    !p.color=0
    !p.charsize=1
    !p.charthick=1
    loadct,43,file='~/colortable/colors1.tbl'
    tplot
    device,/close
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+dir_fig+'0_90/MagEIS_HR_'+mode_name_all[index_mode]+$
      '_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.ps '+dir_fig+'0_90/MagEIS_HR_'+mode_name_all[index_mode]+$
      '_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.png'

    ylim,mode_name_all[index_mode]+'HighRate_combo_*',0,15,0
    options,mode_name_all[index_mode]+'HighRate_combo_E*',ytickinterval=5
    tplot,[mode_name_all[index_mode]+'HighRate_combo_E*','bsum_combo','rbsp'+strlowcase(sc)+'_Bw_mag_combo'],var_label=['rbsp'+sc+'_MLT','rbsp'+sc+'_L','rbsp'+sc+'_MLAT'],title='Van Allen Probe '+sc+' MagEIS HR '+mode_name_all[index_mode]

    set_plot,'ps'
    device,filename=dir_fig+'0_15/MagEIS_HR_'+mode_name_all[index_mode]+'_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.ps',$
      /color,bits_per_pixel=8,/times,xsize=21,ysize=21,xoffset=0.5,yoffset=1
    !p.FONT=0
    !p.BACKGROUND='ffffff'xl
    !p.color=01
    
    !p.charsize=1
    !p.charthick=1
    loadct,43,file='~/colortable/colors1.tbl'
    tplot
    device,/close
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+dir_fig+'0_15/MagEIS_HR_'+mode_name_all[index_mode]+$
      '_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.ps '+dir_fig+'0_15/MagEIS_HR_'+mode_name_all[index_mode]+$
      '_20'+yy+mm+dd+sc+strmid(time1,0,2)+'.png'
    stop 
    ;plot_init
  endfor
  
end
