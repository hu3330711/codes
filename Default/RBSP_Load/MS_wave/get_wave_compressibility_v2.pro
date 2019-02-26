pro get_wave_compressibility_v2,yy,mm,dd,sc,exist=exist
rbsp_init
del_data,'*'
;cdf_leap_second_init
yy='12' & mm='09' & dd='21' & sc='A'
timespan,'12-09-21/04',6,/h

  filename=file_search('/data/rbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_wna-survey_emfisis-L4_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1],/get_support_data

  wave_polarization_str1=['bsum','b3','bsumperp']
  for i=0,n_elements(wave_polarization_str1)-1 do begin
    var_str_test=wave_polarization_str1[i]
    get_data,var_str_test,data=d
    store_data,var_str_test,data={x:d.x,y:d.y,v:transpose(d.v[*,*])}
    options,var_str_test,'spec',1
    ylim,var_str_test,2e0,1e4,1
    zlim,var_str_test,1,1,1
    options,var_str_test,ytitle='Frequency!C!C(Hz)',ysubtitle='',ztitle=var_str_test,zsubtitle='',ytickformat='logticks_exp'
  endfor

get_data,'b3',data=db11
get_data,'bsum',data=dbtotal
comp=db11.y/dbtotal.y

  store_data,'compressibility',data={x:db11.x,v:db11.v,y:comp},dlim={spec:'1B'}
  ylim,'compressibility',2e0,1e4,1
  zlim,'compressibility',0,1,0
  
  window,xsize=1000,ysize=1000
  tplot,['b3','bsum','bsumperp','compressibility'],title='Van Allen probe A'
  makepng,'compressibility_scott'
end
