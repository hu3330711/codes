pro get_wave_compressibility,yy,mm,dd,sc,exist=exist
rbsp_init
del_data,'*'
;cdf_leap_second_init
yy='12' & mm='09' & dd='21' & sc='A'
timespan,'12-09-21/04',6,/h
!p.charsize=1.5

  filename=file_search('/data/rbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L2/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_magnetometer_uvw_emfisis-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot,file=filename[count-1],/get_support_data
  get_data,'Mag',data=d
  tmp=sqrt((d.y[*,0]^2+d.y[*,1]^2)/2)
  store_data,'Mag_u',data={x:d.x,y:d.y[*,0]}
  store_data,'Mag_v',data={x:d.x,y:d.y[*,1]}
  store_data,'Mag_w',data={x:d.x,y:d.y[*,2]}

  filename=file_search('/data/rbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L2/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_WFR-spectral-matrix_emfisis-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
  cdf2tplot_qm,file=filename[count-1],/get_support_data
  
  get_data,'BuBu',data=dBu
  store_data,'BuBu',data={x:dBu.x,y:dBu.y,v:transpose(dBu.v[*,*])}
  options,'BuBu',ztitle='BuBu!C!C(nT!u2!n/Hz)'
  get_data,'BvBv',data=dBv
  store_data,'BvBv',data={x:dBv.x,y:dBv.y,v:transpose(dBv.v[*,*])}
  options,'BvBv',ztitle='BvBv!C!C(nT!u2!n/Hz)'
  get_data,'BwBw',data=dBw
  store_data,'BwBw',data={x:dBw.x,y:dBw.y,v:transpose(dBw.v[*,*])}
  get_data,'BuBv',data=dbubv
  get_data,'BuBw',data=dbubw
  ylim,'B?B?',2e0,1e4,1
  zlim,'B?B?',1e-10,1e-5,1

tinterpol_mxn,'Mag_u','BuBu',newname='Mag_u'
  get_data,'Mag_u',data=dB0_u
tinterpol_mxn,'Mag_v','BuBu',newname='Mag_v'
  get_data,'Mag_v',data=dB0_v
tinterpol_mxn,'Mag_w','BuBu',newname='Mag_w'
  get_data,'Mag_w',data=dB0_w
  
;  dbu.y[*,*]=1.
;  dbv.y[*,*]=1.
;  dbw.y[*,*]=1.
  
  
  comp=dbu.y
  for i=0,n_elements(comp[0,*])-1 do begin
    for j=0,n_elements(comp[*,0])-1 do begin
      b0_tmp=sqrt(db0_u.y[j]^2+db0_v.y[j]^2+db0_w.y[j]^2)
      b1_tmp=sqrt(dbu.y[j,i]+dbv.y[j,i]+dbw.y[j,i])
      
      comp[j,i]=(db0_u.y[j]/b0_tmp*(sqrt(dbu.y[j,i])/b1_tmp)+ $
                 db0_v.y[j]/b0_tmp*(sqrt(dbv.y[j,i])/b1_tmp) *sign(dbubv.y[j,i])+ $
                 db0_w.y[j]/b0_tmp*(sqrt(dbw.y[j,i])/b1_tmp) *sign(dbubw.y[j,i]) )^2
            
      if b0_tmp*b1_tmp le 0. or ~finite(b0_tmp*b1_tmp) then comp[j,i]=1./3
      
;      if j eq 10 then print,dbu.y[j,i],dbv.y[j,i],dbw.y[j,i],sign(dbubv.y[j,i]),sign(dbubw.y[j,i]),comp[j,i],db0_u.y[j],db0_v.y[j],db0_w.y[j]
    endfor
  endfor
  
  store_data,'compressibility',data={x:dbu.x,v:transpose(dbu.v[*,*]),y:comp},dlim={spec:'1B'}
  ylim,'compressibility',2e0,1e4,1
  zlim,'compressibility',0,1,0
  
  window,xsize=1200,ysize=1000
  tplot,['BuBu','BvBv','BwBw','Mag_?','compressibility'],title='Van Allen probe A'
  makepng,'compressibility_scott'
end
