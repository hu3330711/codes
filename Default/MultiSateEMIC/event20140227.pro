PRO Event20140227

plot_init,'ps'
rbsp_init
;init set
rbsp_efw_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/'

;set date and probe
;date = '2014-02-27'
;trange=['2014-02-27/15:30','2014-02-27/22:00']

date = '2017-05-28'
trange=['2017-05-28/05:50','2017-05-28/09:50']

timespan, date

sc='a'
rbspx = 'rbsp'+sc

;>>>>>>>>>>>>>>>>>> mGSE2GSE associated >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
rbsp_load_spice_kernels
;Get spin-axis pointing vector. Used for rotation from GSE -> MGSE
time2=time_double(date) ; first get unix time double for beginning of day

;Grab first and last time of day
time2 = [time2,time2+86399.]
time3=time_string(time2, prec=6) ; turn it back into a string for ISO conversion
strput,time3,'T',10 ; convert TPLOT time string 'yyyy-mm-dd/hh:mm:ss.msec' to ISO 'yyyy-mm-ddThh:mm:ss.msec'
cspice_str2et,time3,et2 ; convert ISO time string to SPICE ET

cspice_pxform,'RBSP'+strupcase(sc)+'_SCIENCE','GSE',et2[0],pxform1
cspice_pxform,'RBSP'+strupcase(sc)+'_SCIENCE','GSE',et2[1],pxform2

wsc1=dblarr(3)
wsc1[2]=1d
wsc_GSE1=dblarr(3)

wsc2=dblarr(3)
wsc2[2]=1d
wsc_GSE2=dblarr(3)

wsc_GSE1 = pxform1 ## wsc1  ;start of day
wsc_GSE2 = pxform2 ## wsc2  ;end of day
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;load position and velocity data
rbsp_load_spice_state,probe=sc,coord='gse',/no_spice_load
rbsp_load_efw_waveform_l3,probe=sc

rbsp_load_emfisis,probe=sc,coord='gse'
rbsp_load_emfisis,probe=sc,coord='gsm'
rbsp_load_emfisis,probe=sc,coord='gsm',cadence='hires'

rbsp_gse2mgse, 'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag', reform(wsc_GSE1), newname = 'rbsp'+sc+'_emfisis_l3_4sec_mgse_Mag'

tinterpol_mxn,'rbsp'+sc+'_emfisis_l3_4sec_mgse_Mag','rbsp'+sc+'_efw_efield_inertial_frame_mgse',/overwrite
tsmooth2, 'rbsp'+sc+'_emfisis_l3_4sec_mgse_Mag', 300, newname='rbsp'+sc+'_emfisis_l3_4sec_mgse_Mag_DC' ;20 min

;rbsp_mgse2gse,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_spinfit', reform(wsc_GSE1), newname = 'rbsp'+sc+'_efw_esvy_gse_vxb_removed_spinfit'
;cotrans,'rbsp'+sc+'_efw_esvy_gse_vxb_removed_spinfit','rbsp'+sc+'_efw_esvy_gsm_vxb_removed_spinfit',/gse2gsm

get_data,'rbsp'+sc+'_efw_efield_inertial_frame_mgse',data=tmp,dlim=dlim
tmp.y[*,0]=0
store_data,'rbsp'+sc+'_efw_efield_inertial_frame_mgse',data={x:tmp.x,y:tmp.y},dlim=dlim

rbsp_mgse2gse, 'rbsp'+sc+'_efw_efield_inertial_frame_mgse', reform(wsc_GSE1), newname = 'rbsp'+sc+'_efw_efield_inertial_frame_gse'
cotrans,'rbsp'+sc+'_efw_efield_inertial_frame_gse','rbsp'+sc+'_efw_efield_inertial_frame_gsm',/gse2gsm

options,'rbsp'+sc+'_efw_efield_inertial_frame_mgse',labels=['x','y','z'],labflag=1
options,'rbsp'+sc+'_efw_efield_inertial_frame_gse',labels=['x','y','z'],labflag=1
options,'rbsp'+sc+'_efw_efield_inertial_frame_gsm',labels=['x','y','z'],labflag=1

split_vec,'rbsp'+sc+'_efw_efield_inertial_frame_gsm'

;rotate all data into field aligned coordinates
;thm_load_state,probe=probe2, coord='gei',/get_support_data

tsmooth2, 'rbsp'+sc+'_emfisis_l3_4sec_gsm_Mag', 300, newname='rbsp'+sc+'_emfisis_l3_4sec_gsm_Mag_DC' ;20 min
rbsp_load_spice_state,probe=sc,coord='gei',/no_spice_load
fac_matrix_make, 'rbsp'+sc+'_emfisis_l3_4sec_gsm_Mag_DC', other_dim='Xgse', pos_var_name='rbsp'+sc+'_state_pos_gei',newname = 'rotmat'
tvector_rotate, 'rotmat', 'rbsp'+sc+'_efw_efield_inertial_frame_gsm', newname = 'rbsp'+sc+'_efw_efield_inertial_frame_fac'
tvector_rotate, 'rotmat', 'rbsp'+sc+'_emfisis_l3_4sec_gsm_Mag', newname = 'rbsp'+sc+'_emfisis_l3_4sec_fac_Mag'
;tvector_rotate, 'rotmat', 'rbsp'+sc+'_efw_esvy_gsm_vxb_removed_spinfit', newname = 'rbsp'+sc+'_efw_esvy_fac_vxb_removed_spinfit'
split_vec,'rbsp'+sc+'_efw_efield_inertial_frame_fac'
options,'rbsp'+sc+'_efw_efield_inertial_frame*',colors=[2,4,6]
tplot,['rbsp'+sc+'_efw_efield_inertial_frame_gsm','rbsp'+sc+'_efw_efield_inertial_frame_fac'],trange=trange

tvector_rotate,'rotmat','rbspa_emfisis_l3_hires_gsm_Mag'
twavpol, 'rbspa_emfisis_l3_hires_gsm_Mag_rot',nopfft=1024,steplength=512

stop
end