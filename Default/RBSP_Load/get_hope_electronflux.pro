pro get_hope_electronflux,yy,mm,dd,sc,exist=exist
  ;;load omni-directional flux FEDO
  exist=0
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/hope/level3/pitchangle/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-hope-PA-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1],/get_support_data

  copy_data,'FEDO','HOPE_FEDO'
  options,'HOPE_FEDO',yrange=[10,5e4],/ylog,ystyle=1,ytickformat='exponent',zrange=[1,1],/zlog,ytitle='HOPE_FEDO',ysubtitle='E [eV]',$
    ztitle='[s!U-1!Ncm!U-2!Nster!U-1!NkeV!U-1!N]',spec=1,ztickformat='exponent'


  ;;load uni-directional flux FEDU
  get_data,'FEDU',data=dfedu

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
    store_data,'HOPE_FEDU_E'+string(e,format='(I2.2)'),data={x:time,v:pa,y:flux_t_pa}
    options,'HOPE_FEDU_E'+string(e,format='(I2.2)'),yrange=[0,180],yticks=4,ystyle=1,zrange=[1,1],/zlog,ytitle='HOPE '+string(energy[e],format='(f8.1)')+'eV!C',$
      ysubtitle='Pitch Angle [o]',ztitle='e Flux!C!C[s!U-1!Ncm!U-2!Nster!U-1!NkeV!U-1!N]',spec=1,ztickformat='exponent'
  endfor
end
