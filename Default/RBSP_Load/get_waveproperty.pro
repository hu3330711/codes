pro get_waveproperty,yy,mm,dd,sc,exist=exist
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_wna-survey_emfisis-L4_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf_leap_second_init
  cdf2tplot,file=filename[count-1],/get_support_data

  wave_polarization_str1=['bsum','esum','bsumperp','esumperp','poy1_2_3']
  for i=0,n_elements(wave_polarization_str1)-1 do begin
    var_str_test=wave_polarization_str1[i]
    get_data,var_str_test,data=d
    store_data,var_str_test,data={x:d.x,y:d.y,v:transpose(d.v[0,*])}
    options,var_str_test,'spec',1
    ylim,var_str_test,1e1,1e4,1
    zlim,var_str_test,1,1,1
    options,var_str_test,ytitle='Frequency!C!C[Hz]',ysubtitle='',ztitle=var_str_test,zsubtitle='',ytickformat='exponent'
  endfor
  
  wave_polarization_str2=['eigen','ellsvd','phpoy1_2_3','phsvd','plansvd','thpoy1_2_3','thsvd','polsvd','cohb1_2','cohb1_3','cohb2_3']
  for i=0,n_elements(wave_polarization_str2)-1 do begin
    var_str_test=wave_polarization_str2[i]
    get_data,var_str_test,data=d,index=index
    if index eq 0 then continue
    store_data,var_str_test,data={x:d.x,y:d.y,v:transpose(d.v[0,*])}
    options,var_str_test,'spec',1
    ylim,var_str_test,1e1,1e4,1
    zlim,var_str_test,1,1,0
    options,var_str_test,ytitle='Frequency!C!C[Hz]',ysubtitle='',ztitle=var_str_test,zsubtitle='',ytickformat='exponent'
  endfor
end
