cdf_leap_second_init
thm_init
cdf2tplot,files,files='/Users/qmr/data/rbsp/emfisis/Flight/RBSP-A/L3/2015/06/22/rbsp-a_magnetometer_hires-gsm_emfisis-L3_20150622_v1.3.2.cdf'
get_data,'Mag',data=tmp
index=where(tmp.x GT time_double('2015-06-22/19:20') and tmp.x lt time_double('2015-06-22/20:10'))
store_data,'Mag_wavea',data={x:tmp.x(index),y:tmp.y(index,*)}
tsmooth2,'Mag_wavea',3840*2,newname='rbspa_emfisis_l3_hires_gsm_Mag_DC_wave'
get_data,'rbspa_emfisis_l3_hires_gsm_Mag_DC_wave',data=tmp,limits=l,dlimits=dl
v_data_att = {coord_sys:'gsm',units:'nT'}
str_element,/add,dl,'data_att',v_data_att
rbsp_load_spice_state,probe='a',coord='gei'
get_data,'rbspa_state_pos_gei',data=tmp
index=where(tmp.x GT time_double('2015-06-22/19:20') and tmp.x lt time_double('2015-06-22/20:10'))
store_data,'rbspa_state_pos_gei_wave',data={x:tmp.x(index),y:tmp.y(index,*)}
fac_matrix_make,'rbspa_emfisis_l3_hires_gsm_Mag_DC_wave',pos_var_name='rbspa_state_pos_gei',other_dim='Xgse'
tvector_rotate, 'rbspa_emfisis_l3_hires_gsm_Mag_DC_wave_fac_mat', 'Mag_wavea'
twavpol, 'Mag_wavea_rot',nopfft=1024,steplength=128
get_data,'Magnitude',data=mag
;fce = 28.*mag.y
;store_data,'fce_a',data={x:mag.x,y:fce}
;store_data,'fcp_a',data={x:mag.x,y:fce/1836.}
;store_data,'fche_a',data={x:mag.x,y:fce/7344.}
;store_data,'fco_a',data={x:mag.x,y:fce/29376.}
file_id = H5F_OPEN('/Users/qmr/Downloads/rbspa_def_MagEphem_TS04D_20150622_v1.0.0.h5')
dataset_IsoTime = H5D_OPEN(file_id, '/IsoTime')
dataset_l = H5D_OPEN(file_id, '/L')
dataset_lstar = H5D_OPEN(file_id, '/Lstar')
dataset_Bmin = H5D_OPEN(file_id, '/Bmin_gsm')
IsoTime = H5D_READ(dataset_IsoTime)
la = H5D_READ(dataset_l)
lstara = H5D_READ(dataset_lstar)
Bmina = H5D_READ(dataset_Bmin)
H5D_CLOSE, dataset_l
H5D_CLOSE, dataset_lstar
H5D_CLOSE, dataset_Bmin
H5F_CLOSE, file_id

la1=reform(la(0,*))
lstara1=reform(lstara(0,*))
Bmina4=reform(Bmina(3,*))
store_data,'LA',data={x:time_double(IsoTime),y:la1}
store_data,'LstarA',data={x:time_double(IsoTime),y:lstara1}
store_data,'Bmina',data={x:time_double(IsoTime),y:Bmina4}
fce = 28.*Bmina4
store_data,'fce_a',data={x:time_double(IsoTime),y:fce}
store_data,'fcp_a',data={x:time_double(IsoTime),y:fce/1836.}
store_data,'fche_a',data={x:time_double(IsoTime),y:fce/7344.}
store_data,'fco_a',data={x:time_double(IsoTime),y:fce/29376.}
split_vec,'Mag_wavea'
get_data,'Mag_wavea_x',data=magx
get_data,'Mag_wavea_y',data=magy
Mag_horizontal=sqrt((magx.y)^2+(magy.y)^2)
store_data,'Mag_hori',data={x:magx.x,y:Mag_horizontal}
tdpwrspc,'Mag_hori',nboxpoints=1024,nshiftpoints=128,bin=1,trange=trange,newname='EMIC_RBSPA'
store_data,'rbspa_emfisis_l3_hires_gsm_Mag_x_dpwrspc_fce',data=['EMIC_RBSPA','fcp_a','fche_a','fco_a']
store_data,'Wave_normal_angle_a',data=['Mag_wavea_rot_waveangle','fcp_a','fche_a','fco_a']

tclip,