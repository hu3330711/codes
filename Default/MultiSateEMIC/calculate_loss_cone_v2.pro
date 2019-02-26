;Purpose: this program is used to calculate the local loss cone using TS01 model. Solar wind input is from OMNI data.
;
;Inputs: posvar   varname of the satellite location in GSM coordinates in km
;        magvar   varname of the magnetic field measured by the satellite in nT
;
;Output: 'local_loss_cone','equator_loss_cone'
;

pro calculate_loss_cone_v2,posvar=posvar,magvar=magvar

  compile_opt idl2

  get_data,posvar,data=tmp
  ntime=n_elements(tmp.x)
  trange=[tmp.x[0],tmp.x[ntime-1]]

  get_data,magvar,data=tmp,dlim=dlim
  store_data,magvar+'_bt',data={x:tmp.x,y:sqrt(tmp.y[*,0]^2+tmp.y[*,1]^2+tmp.y[*,2]^2)},dlim=dlim

  omni_hro_load,trange=trange
  tsmooth2,'OMNI_HRO_1min_flow_speed',10,newname='OMNI_HRO_1min_flow_speed'
  tsmooth2,'OMNI_HRO_1min_BY_GSM',10,newname='OMNI_HRO_1min_BY_GSM'
  tsmooth2,'OMNI_HRO_1min_BZ_GSM',10,newname='OMNI_HRO_1min_BZ_GSM'
  tsmooth2,'OMNI_HRO_1min_flow_speed',10,newname='OMNI_HRO_1min_flow_speed'


  tinterpol_mxn,posvar,'OMNI_HRO_1min_flow_speed',newname=posvar+'_int'

  get_data,'OMNI_HRO_1min_flow_speed',data=v
  get_data,'OMNI_HRO_1min_BY_GSM',data=by
  get_data,'OMNI_HRO_1min_BZ_GSM',data=bz

  ;;input to the t01 model
  geopack_getg,v.y,by.y,bz.y,g

  ttrace2iono,posvar+'_int',newname='ifoot',external_model='t01',r0=1.0157,pdyn='OMNI_HRO_1min_Pressure',dsti='OMNI_HRO_1min_SYM_H',yimf='OMNI_HRO_1min_BY_GSM',zimf='OMNI_HRO_1min_BZ_GSM',g1=g[*,0],g2=g[*,1],/km
  ttrace2equator,posvar+'_int',newname='efoot',external_model='t01',r0=1.0157,pdyn='OMNI_HRO_1min_Pressure',dsti='OMNI_HRO_1min_SYM_H',yimf='OMNI_HRO_1min_BY_GSM',zimf='OMNI_HRO_1min_BZ_GSM',g1=g[*,0],g2=g[*,1],/km

  ;;input to the t89 model
  ;ttrace2iono,posvar+'_int',newname='ifoot',external_model='t89',par=2.0D,/km
  ;ttrace2equator,posvar+'_int',newname='efoot',external_model='t89',par=2.0D,/km


  get_data,'ifoot',data=tmp,dlim=dlim
  altitudeRE=sqrt(tmp.y[*,0]^2+tmp.y[*,1]^2+tmp.y[*,2]^2)/6371.2
  bad=where(altitudeRE gt 1.02,count)
  tmp.y[bad,*]=!Values.F_NAN
  store_data,'ifoot_good',data=tmp,dlim=dlim

  tinterpol_mxn,'ifoot_good','OMNI_HRO_1min_flow_speed',newname='ifoot_good'
  tinterpol_mxn,'efoot','OMNI_HRO_1min_flow_speed',newname='efoot_good'

  tt01,'ifoot_good',pdyn='OMNI_HRO_1min_Pressure',dsti='OMNI_HRO_1min_SYM_H',yimf='OMNI_HRO_1min_BY_GSM',zimf='OMNI_HRO_1min_BZ_GSM',g1=g[*,0],g2=g[*,1]
  tt01,'efoot_good',pdyn='OMNI_HRO_1min_Pressure',dsti='OMNI_HRO_1min_SYM_H',yimf='OMNI_HRO_1min_BY_GSM',zimf='OMNI_HRO_1min_BZ_GSM',g1=g[*,0],g2=g[*,1]

  get_data,'ifoot_good_bt01',data=tmp,dlim=dlim
  store_data,'ifoot_bt',data={x:tmp.x,y:sqrt(tmp.y[*,0]^2+tmp.y[*,1]^2+tmp.y[*,2]^2)},dlim=dlim

  get_data,'efoot_good_bt01',data=tmp,dlim=dlim
  store_data,'efoot_bt',data={x:tmp.x,y:sqrt(tmp.y[*,0]^2+tmp.y[*,1]^2+tmp.y[*,2]^2)},dlim=dlim

  tinterpol_mxn,magvar+'_bt','ifoot_bt',newname=magvar+'_bt_int'

  get_data,magvar+'_bt_int',data=b
  get_data,'ifoot_bt',data=b0
  get_data,'efoot_bt',data=be

  store_data,'local_loss_cone',data={x:b.x,y:asin((b.y/b0.y)^0.5)*180./!pi},dlim=dlim
  store_data,'equator_loss_cone',data={x:b.x,y:asin((be.y/b0.y)^0.5)*180./!pi},dlim=dlim
  return

END