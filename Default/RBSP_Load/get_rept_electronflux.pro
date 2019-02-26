pro get_rept_electronflux,yy,mm,dd,sc,exist=exist
  ;;load spin-averaged flux 'FESA'
  exist=0
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/rept/level2/sectors/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-rept-sci-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1],/get_support_data

  tplot_rename,'FESA','REPT_FESA'
  options,'REPT_FESA',yrange=[1.8,2e1],/ylog,ystyle=1,zrange=[1,1],/zlog,ytitle='REPT_FESA',ysubtitle='E [MeV]',$
    ztitle='[s!U-1!Ncm!U-2!Nster!U-1!NMeV!U-1!N]',spec=1,ztickformat='exponent'


  ;;load uni-directional flux 'FEDU'
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+'/rept/level3/pitchangle/20'+yy+'/', $
    'rbsp'+sc+'_rel*_ect-rept-sci-L3_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return
  cdf2tplot,file=filename[count-1],/get_support_data

  get_data,'FEDU',data=dfedu
  tplot_rename,'FEDU','REPT_FEDU'

  time=dfedu.x
  pa=dfedu.v1
  flux_t_e_pa=dfedu.y
  energy=dfedu.v2
  n_e=n_elements(energy)
  n_time=n_elements(time)
  n_pa=n_elements(pa)

  for e=0,n_e-1 do begin
    flux_t_pa=dblarr(n_time,n_pa)/0.
    for p=0,n_pa-1 do begin
      flux_t_pa[*,p]=flux_t_e_pa[*,e,p]
    endfor
    store_data,'REPT_FEDU_E'+string(e,format='(I2.2)'),data={x:time,v:pa,y:flux_t_pa}
    options,'REPT_FEDU_E'+string(e,format='(I2.2)'),yrange=[0,180],yticks=4,ystyle=1,zrange=[1,1],/zlog,ytitle='REPT '+string(energy[e],format='(f5.2)')+'MeV!C',$
      ysubtitle='Pitch Angle [o]',ztitle='e Flux!C!C[s!U-1!Ncm!U-2!Nster!U-1!NMeV!U-1!N]',spec=1,ztickformat='exponent'
  endfor
end
