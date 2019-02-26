pro get_mageis_electronflux,yy,mm,dd,sc,exist=exist
  ;;load spin-averaged flux with correction 'FESA_CORR'
  exist=0
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/mageis/level2/sectors/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-mageis-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1],/get_support_data

  copy_data,'FESA_CORR','MagEIS_FESA'
  options,'MagEIS_FESA',yrange=[30,4e3],/ylog,ystyle=1,zrange=[1,1],/zlog,ytitle='MagEIS_FESA',ysubtitle='E [keV]',$
    ztitle='[s!U-1!Ncm!U-2!Nster!U-1!NkeV!U-1!N]',spec=1,ytickformat='exponent',ztickformat='exponent'

  ;;load uni-directional flux with correction 'FEDU_CORR'
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/mageis/level3/pitchangle/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-mageis-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return
  cdf2tplot,file=filename[count-1],/get_support_data

  get_data,'FEDU_CORR',data=dfedu
  tplot_rename,'FEDU_CORR','MagEIS_FEDU'

  time=dfedu.x
  pa=dfedu.v1
  flux_t_e_pa=dfedu.y
  n_e=n_elements(dfedu.v2[0,*])
  n_time=n_elements(time)
  n_pa=n_elements(pa)

  energy=dblarr(n_e)
  for e=0,n_e-1 do begin
    energy[e]=median(dfedu.v2[*,e])
  endfor

  for e=0,n_e-1 do begin
    flux_t_pa=dblarr(n_time,n_pa)/0.
    for p=0,n_pa-1 do begin
      index_good=where(dfedu.v2[*,e] ge 0.9*energy[e] and dfedu.v2[*,e] le 1.1*energy[e],count)
      if count le 0 then continue
      flux_t_pa[index_good,p]=flux_t_e_pa[index_good,e,p]
    endfor
    store_data,'MagEIS_FEDU_E'+string(e,format='(I2.2)'),data={x:time,v:pa,y:flux_t_pa}
    options,'MagEIS_FEDU_E'+string(e,format='(I2.2)'),yrange=[0,180],yticks=4,ystyle=1,zrange=[1,1],/zlog,ytitle='MagEIS '+string(energy[e],format='(f6.1)')+'keV!C',$
      ysubtitle='Pitch Angle [o]',ztitle='e Flux!C!C[s!U-1!Ncm!U-2!Nster!U-1!NkeV!U-1!N]',spec=1,ztickformat='exponent'
  endfor
end
