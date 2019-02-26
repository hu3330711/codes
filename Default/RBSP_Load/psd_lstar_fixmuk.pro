pro psd_lstar_fixMuK,yy,mm,dd,mu0,k0,mageis=mageis,rept=rept,suffix=suffix,lstar_ab=lstar_ab,psd_lstar_ab=psd_lstar_ab
;;input---
;  yy='13'
;  mm='09'
;  dd='24'
;  mu0=3000.
;  k0=0.11
;  mageis=1
;  rept=1
;  suffix='6'
;;run--
; psd_lstar_fixMuK,yy,mm,dd,mu0,k0,mageis=mageis,rept=rept,suffix=suffix,lstar_ab=lstar_ab,psd_lstar_ab=psd_lstar_ab
;;output--
; lstar_ab[time, spacecraft]
; psd_lstar_ab[time, spacecraft]

  if ~keyword_set(suffix) then suffix='0'

  delta_t=60.*5
  n_t=round(86400l/delta_t+1)
  psd_lstar_ab=dblarr(n_t,2)
  time=dindgen(n_t)*delta_t+time_double('20'+yy+'-'+mm+'-'+dd+'/00:00:00')
  store_data,'Uniform_Time',data={x:time,y:dblarr(n_t)}
  lstar_ab=dblarr(n_t,2)

  e_restmass=0.910938291e-30*(2.99792458e8)^2/1.60217657e-19/1.e6
  sc_all=['A','B']

  if keyword_set(mageis) then begin
    for scsc=0,1 do begin
      sc=sc_all[scsc]
      get_position_gsm_sm,yy,mm,dd,sc
      get_b0state,yy,mm,dd,sc
      get_mageis_electronflux,yy,mm,dd,sc
      rbsp_magephemeris_lstar_k_load,yy,mm,dd,sc

      tinterpol,'Magnitude','Uniform_Time',newname='Magnitude_int'
      tinterpol,'Lstar_pa','Uniform_Time',newname='Lstar_pa_int'
      tinterpol,'K_pa','Uniform_Time',newname='K_pa_int'

      get_data,'Magnitude_int',data=b0
      get_data,'Lstar_pa_int',data=lstar_pa
      get_data,'K_pa_int',data=k_pa
      get_data,'FEDU',data=fedu

      for tt=0,n_t-1 do begin
        b0_1=b0.y[tt]*1e-5
        index=where(finite(k_pa.y[tt,*]) and k_pa.y[tt,*] gt 0,count)
        if count le 1 then continue
        pa_1=interpol_flatboundary(reverse(k_pa.v),reverse(reform(k_pa.y[tt,*])),k0)
        index=where(finite(lstar_pa.y[tt,*]) and lstar_pa.y[tt,*] gt 1,count_non0)
        if count_non0 lt 2 then continue
        lstar_ab[tt,scsc]=interpol_flatboundary(lstar_pa.y[tt,index],lstar_pa[index].v,pa_1)

        ek_b_mu_pa,b0_1,mu0,pa_1/180.*!pi,ek_1

        n_ek_obs=n_elements(fedu.v2[0,*])
        psd_ek_obs=dblarr(n_ek_obs)
        n_pa_obs=(n_elements(fedu.v1)+1)/2
        flux=fedu.y
        ek_obs_t=fedu.v2*1e-3

        index_t=where(fedu.x ge time[tt]-delta_t/2 and fedu.x le time[tt]+delta_t/2,count_t)
        if count_t lt 1 then continue
        if ek_1 lt ek_obs_t[index_t[0],0] or ek_1 gt 1.8 then continue

        for ee=0,n_ek_obs-1 do begin
          v=dblarr(n_pa_obs)
          for pp=0,n_pa_obs-1 do begin
            array_tmp=reform([reform(flux[index_t,ee,pp]),reform(flux[index_t,ee,2*n_pa_obs-2-pp])])
            index_non0=where(array_tmp gt 0,count_non0)
            if count_non0 ge 1 then v[pp]=mean(array_tmp[index_non0])
          endfor

          x=fedu.v1[0:n_pa_obs-1]
          psd_ek_obs[ee]=interpol_flatboundary(v,x,pa_1)*3.325e-8/ek_obs_t[index_t[0],ee]/(ek_obs_t[index_t[0],ee]+2*e_restmass)
        endfor

        index_ek=where(psd_ek_obs gt 0 and finite(psd_ek_obs),count_ek)
        if count_ek lt 2 then continue
        v=alog(psd_ek_obs[index_ek])
        x=alog(ek_obs_t[index_t[0],index_ek])
        xout=alog(ek_1)
        if xout lt x[0] or xout gt x[count_ek-1] then continue
        vout=interpol_flatboundary(v,x,xout)
        psd_lstar_ab[tt,scsc]=exp(vout)
      endfor
    endfor
  endif



  if keyword_set(rept) then begin
    for scsc=0,1 do begin
      sc=sc_all[scsc]
      get_position_gsm_sm,yy,mm,dd,sc
      get_b0state,yy,mm,dd,sc
      get_rept_electronflux,yy,mm,dd,sc
      rbsp_magephemeris_lstar_k_load,yy,mm,dd,sc

      tinterpol,'Magnitude','Uniform_Time',newname='Magnitude_int'
      tinterpol,'Lstar_pa','Uniform_Time',newname='Lstar_pa_int'
      tinterpol,'K_pa','Uniform_Time',newname='K_pa_int'

      get_data,'Magnitude_int',data=b0
      get_data,'Lstar_pa_int',data=lstar_pa
      get_data,'K_pa_int',data=k_pa
      get_data,'REPT_FEDU',data=fedu

      for tt=0,n_t-1 do begin
        b0_1=b0.y[tt]*1e-5
        index=where(finite(k_pa.y[tt,*]) and k_pa.y[tt,*] gt 0,count)
        if count le 1 then continue
        pa_1=interpol_flatboundary(reverse(k_pa.v),reverse(reform(k_pa.y[tt,*])),k0)
        index=where(finite(lstar_pa.y[tt,*]) and lstar_pa.y[tt,*] gt 1,count_non0)
        if count_non0 lt 2 then continue
        lstar_ab[tt,scsc]=interpol_flatboundary(lstar_pa.y[tt,index],lstar_pa[index].v,pa_1)

        ek_b_mu_pa,b0_1,mu0,pa_1/180.*!pi,ek_1

        n_ek_obs=n_elements(fedu.v2)
        psd_ek_obs=dblarr(n_ek_obs)
        n_pa_obs=(n_elements(fedu.v1)+1)/2
        flux=fedu.y*1e-3
        ek_obs_t=fedu.v2

        index_t=where(fedu.x ge time[tt]-delta_t/2 and fedu.x le time[tt]+delta_t/2,count_t)
        if count_t lt 1 then continue
        if ek_1 gt ek_obs_t[n_ek_obs-1] or ek_1 lt 1.7 then continue

        for ee=0,n_ek_obs-1 do begin
          v=dblarr(n_pa_obs)
          for pp=0,n_pa_obs-1 do begin
            array_tmp=reform([reform(flux[index_t,ee,pp]),reform(flux[index_t,ee,2*n_pa_obs-2-pp])])
            index_non0=where(array_tmp gt 0,count_non0)
            if count_non0 ge 1 then v[pp]=mean(array_tmp[index_non0])
          endfor

          x=fedu.v1[0:n_pa_obs-1]
          psd_ek_obs[ee]=interpol_flatboundary(v,x,pa_1)*3.325e-8/ek_obs_t[ee]/(ek_obs_t[ee]+2*e_restmass)
        endfor

        index_ek=where(psd_ek_obs gt 0 and finite(psd_ek_obs),count_ek)
        if count_ek lt 2 then continue
        v=alog(psd_ek_obs[index_ek])
        x=alog(ek_obs_t[index_ek])
        xout=alog(ek_1)
        if xout lt x[0] or xout gt x[count_ek-1] then continue
        vout=interpol_flatboundary(v,x,xout)
        psd_lstar_ab[tt,scsc]=exp(vout)
        if psd_lstar_ab[tt,scsc] lt 1e-40 then stop
      endfor
    endfor
  endif



  set_plot,'ps'
  device,filename=strjoin('PSD_fixMuK_20'+yy+mm+dd+'_'+suffix+'.ps'),/color, Bits_per_Pixel=8,/times,xsize=18,ysize=18,xoffset=1,yoffset=1
  !p.MULTI=0
  !p.charsize=1
  !p.CHARTHICK=1
  !p.font=0
  !p.thick=3
  !P.background='ffffff'xl
  !p.COLOR=0
  loadct,43,file='/project/burbsp/small/QM/library/IDL/colortable/colors1.tbl'

  ymax=max(psd_lstar_ab)*2.
  if ymax le 0 then stop
  ytitle='PSD [(c/MeV/cm)!U3!N]'

  xpos=0.1
  ypos=0.1
  plot,lstar_ab[*,0],/nodata,position=[xpos,ypos,xpos+0.7,ypos+0.7],xrange=[2,6],xstyle=1,xtitle='L* (TS04D)',$
    ytickformat='exponent',/ylog,yrange=[ymax*1e-4,ymax],ystyle=1,$
    ytitle=ytitle,title=string(round(Mu0),format='(I4)')+' MeV/G    '+string(k0,format='(f5.2)')+' G!U0.5!NR!DE!N',xthick=4

  for scsc=0,1 do for tt=0,n_t-2 do $
    oplot,[lstar_ab[tt,scsc],lstar_ab[tt+1,scsc]],[psd_lstar_ab[tt,scsc],psd_lstar_ab[tt+1,scsc]],color=tt*254./(n_t-1)

  xyouts,xpos+0.72,ypos+0.68,'Time',/normal,charsize=1,charthick=1
  index_time_label=(n_t-1)/12*indgen(13)
  time_st=strmid(time_string(time[index_time_label]),0,16)
  for i=0,n_elements(time_st)-1 do $
    xyouts,xpos+0.71,ypos+0.65-i*0.03,time_st[i],/normal,charsize=1,charthick=1,color=i*254./(n_elements(time_st)-1)

  device,/close
  
  spawn,'convert -density 90 -background "#FFFFFF" -flatten '+strjoin('PSD_fixMuK_20'+yy+mm+dd+'_'+suffix+'.ps')+$
    ' '+strjoin('PSD_fixMuK_20'+yy+mm+dd+'_'+suffix+'.png')
end