pro rbsp_magephemeris_lstar_k_load,yy,mm,dd,sc

  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/rbsp'+sc+ $
    '/MagEphem/definitive/20'+yy+'/rbsp'+sc+'_def_MagEphem_TS04D_20'+yy+mm+dd+'_v*.*.*.h5',/fold_case,count=count)
  result=h5_parse(filename[count-1],/read_data)
  
  lstar_pa_t=result.lstar._data
  k_pa_t=result.k._data
  
  isotime=result.isotime._data
  time=time_double(strmid(isotime,0,10)+'/'+strmid(isotime,11,8))
  n_time=n_elements(time)
  
  pa=result.alpha._data
  n_pa=n_elements(pa)
  
  index=where(lstar_pa_t le 0,count)
  if count ge 1 then lstar_pa_t[index]=0./0.
  index=where(k_pa_t le 0,count)
  if count ge 1 then k_pa_t[index]=0./0.
  
  pa=reverse(pa)
  lstar_t_pa=dblarr(n_time,n_pa)
  k_t_pa=dblarr(n_time,n_pa)
  
  for j=0,n_time-1 do lstar_t_pa[j,*]=reverse(lstar_pa_t[*,j])
  for j=0,n_time-1 do k_t_pa[j,*]=reverse(k_pa_t[*,j])

store_data,'Lstar_pa',data={x:time,v:pa,y:lstar_t_pa}
store_data,'K_pa',data={x:time,v:pa,y:K_t_pa}

options,'Lstar_pa',ytitle='Pitch Angle [o]',/spec,yrange=[0,90],ystyle=1,zrange=[1,6],zstyle=1,ztitle='L star'
options,'K_pa',ytitle='Pitch Angle [o]',/spec,yrange=[0,90],ystyle=1,zrange=[1,1],/zlog,zstyle=1,ztitle='K [R!BE!N G!A0.5!N]'

end