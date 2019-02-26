;V110924 : original FFT
;;V111020 : plot dEdB_bp
;pro ulf_wave_overview_V111020bandpass
;V111109bpnew: using original B to get VxB, but not DC B!!!!
;V111123: legends
;del_data,'*'  ;  Delete all TPLOT variables.
;-----------------------------------------------
;thm_init

tplot_options,'title',' '
num=0
;-----------------------------------------------
cp_freq=0.0023
if num eq 0 then begin
start_date_togetFAC = '2008-06-25/04:00:00'
start_date_plot = '2008-06-25/15:30:00'
hour_togetFAC = 24.
hour_toplot = 30./60. 
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='e'
ylim_s=2e-7
flag_E='VxB'
trangFFT=['2008-06-25/15:30:00','2008-06-25/16:00:00']

cp_freq=0.0033
d_f=0.0002
flow=cp_freq-d_f
fhigh=cp_freq+d_f

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=1.
btype='fgs'
endif
;-----------------------------------------------
if num eq 1 then begin
start_date_togetFAC = '2010-01-11/00:00:00'
start_date_plot = '2010-01-11/07:30:00'
hour_togetFAC = 24.
hour_toplot = 60./60. 
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='d'
ylim_s=2e-7
flag_E='VxB'
trangFFT=['2010-01-11/07:30:00','2010-01-11/08:30:00']

cp_freq=0.0025
flow=cp_freq-0.0005
fhigh=cp_freq+0.0005

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=3.
btype='fgl'
endif
;-----------------------------------------------

;-----------------------------------------------
if num eq 2 then begin
start_date_togetFAC = '2010-01-11/00:00:00'
start_date_plot = '2010-01-11/07:30:00'
hour_togetFAC = 24.
hour_toplot = 60./60. 
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='e'
ylim_s=2e-7
flag_E='VxB'
trangFFT=['2010-01-11/07:30:00','2010-01-11/08:30:00']

cp_freq=0.0030
flow=cp_freq-0.0002
fhigh=cp_freq+0.0002

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=1.
btype='fgs'
endif
;-----------------------------------------------
if num eq 3 then begin
start_date_togetFAC = '2011-09-09/19:00'
start_date_plot = '2011-09-10/07:00'
hour_togetFAC = 24.
hour_toplot = 60./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='a'
ylim_s=8e-6
flag_E='VxB'
trangFFT=['2011-09-10/07:00','2011-09-10/08:00']
flow=0.003-0.001
fhigh=0.003+0.001
eb=5
endif
;-----------------------------------------------
if num eq 4 then begin
t1='2010-01-11/07:30:00'

start_date_togetFAC = time_string(time_double(t1)-60.*60.*12.)
start_date_plot = t1
hour_togetFAC = 24.
hour_toplot = 60./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='a'
ylim_s=2e-6
flag_E='VxB'
trangFFT=[t1,time_string(time_double(t1)+60.*60.*hour_toplot)]
cp_freq=0.0019;0.0027;
flow=cp_freq-0.0002;0.0018;0.0022;
fhigh=cp_freq+0.0002;0.0022;0.0032;

flow=0.0012
fhigh=0.0032
eb=3.
endif

if num eq 5 then begin
start_date_togetFAC = '2009-03-14/22:10:00'
start_date_plot = '2009-03-15/08:00:00'
hour_togetFAC = 24.
hour_toplot = 60./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='c'
ylim_s=1e-6
flag_E='VxB'
trangFFT=['2009-03-15/08:10:00','2009-03-15/08:30:00']
flow=0.009
fhigh=0.011

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=3.
endif

if num eq 6 then begin
t1='2011-03-29/15:50:00'

start_date_togetFAC = time_string(time_double(t1)-60.*60.*12.)
start_date_plot = t1
hour_togetFAC = 24.
hour_toplot = 60./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='e'
ylim_s=5e-7
flag_E='VxB'
trangFFT=[t1,time_string(time_double(t1)+60.*60.*hour_toplot)]
flow=0.0018
fhigh=0.0038

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=3.
endif

if num eq 7 then begin
t1='2008-04-15/06:00:00'

start_date_togetFAC = time_string(time_double(t1)-60.*60.*12.)
start_date_plot = t1
hour_togetFAC = 24.
hour_toplot = 100./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='d'
ylim_s=5e-7
flag_E='VxB'
trangFFT=[t1,time_string(time_double(t1)+60.*60.*hour_toplot)]
flow=0.002
fhigh=0.005

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=3.
cp_freq=0.009
endif


if num eq 8 then begin
t1='2008-04-13/03:00:00'

start_date_togetFAC = time_string(time_double(t1)-60.*60.*12.)
start_date_plot = t1
hour_togetFAC = 24.
hour_toplot = 120./60.
smooth_points = 500 ; 2011-03-29:250  ,  760
probe2='a'
ylim_s=1e-6
flag_E='VxB'
trangFFT=[t1,time_string(time_double(t1)+60.*60.*hour_toplot)]
flow=0.00167
fhigh=0.0067

;flow=0.0013-0.0002
;fhigh=0.0013+0.0003
eb=3.
cp_freq=0.0045
endif

if num eq 9 then begin
  start_date_togetFAC = '2013-12-15/04:00:00'
  start_date_plot = '2013-12-15/17:00:00'
  hour_togetFAC = 24.
  hour_toplot = 60./60.
  smooth_points = 500 ; 2011-03-29:250  ,  760
  probe2='d'
  ylim_s=3e-7
  flag_E='VxB'
  trangFFT=['2013-12-15/17:00:00','2013-12-15/18:00:00']

  cp_freq=0.0014;0.0029
  d_f=0.0005
  flow=cp_freq-d_f
  fhigh=cp_freq+d_f

  ;flow=0.0013-0.0002
  ;fhigh=0.0013+0.0003
  eb=4.
  btype='fgs'
endif

if num eq 10 then begin
  start_date_togetFAC = '2013-05-15/00:00:00'
  start_date_plot = '2013-05-15/07:40:00'
  hour_togetFAC = 24.
  hour_toplot = 60./60.
  smooth_points = 500 ; 2011-03-29:250  ,  760
  probe2='a'
  ylim_s=2e-7
  flag_E='VxB'
  trangFFT=['2013-05-15/07:40:00','2013-05-15/08:40:00']

  cp_freq=0.0025
  d_f=0.002
  flow=cp_freq-d_f
  fhigh=cp_freq+d_f

  ;flow=0.0013-0.0002
  ;fhigh=0.0013+0.0003
  eb=2.
  btype='fgs'
endif


;-----------------------------------------------
E_name='EvxB'
output_dir='/Volumes/DATA/plots/'
;---------------------
;;--------------------
; read_csv()

;cp_freq=0.005
;probe=['a','d','e']
;for jj=0,n_elements(probe)-1 do begin
;  probe2=probe[jj]
;===========================================================================
smthP_togetFAC=900;300;900
trangewvlt=[start_date_togetFAC,time_string(time_double(start_date_togetFAC)+24.*3600)]
;===========================================================================
;===========================================================================
prb='th'+probe2+'_'
;===========================================================================
timespan,start_date_togetFAC,hour_togetFAC,/hours
get_timespan,trange
thm_load_state,probe=probe2, coord='gei',/get_support_data
thm_load_state, probe=probe2, datatype=['pos_gsm','gse']
thm_load_fgm, probe=probe2, trange=trange, coord=['gsm','dsl'], datatype=[btype,btype+'_btotal'], level=2,  /cal_spin_harmonics, /cal_dac_offset, /cal_tone_removal
thm_load_esa, probe=probe2, level='l2', datatype = ['peir_velocity_gsm','peir_density','peir_t3','peir_en_eflux'], trange=trange
tplot_names
stop

;twavpol
;calculate L, MLT, MLAT
tkm2re,prb+'state_pos_gsm'
get_data,prb+'state_pos_gsm_re',data=pos
lshell=calculate_lshell(transpose([[pos.x],[pos.y]]))
store_data,prb+'state_pos_lshell',data={x:pos.x,y:lshell}
;stop
;
;x=pos.y[*,0]
;y=pos.y[*,1]
;r=sqrt(x^2+y^2); r in xy plane
;theta=acos(-x/r)
;good=where(y gt 0)
;theta(good)=2.*!pi-theta(good)
;smlt=theta*24./(2.*!pi)
;store_data,prb+'state_pos_mlt',data={x:pos.x,y:smlt}
;
;phi=asin(pos.y[*,2]/lshell)
;store_data,prb+'state_pos_mlat',data={x:pos.x,y:phi*180./!pi}
;
;options, prb+'state_pos_lshell', ytitle = 'L'
;options, prb+'state_pos_mlt', ytitle = 'MLT'
;options, prb+'state_pos_mlat', ytitle = 'MLAT'


;--------

sc=probe2
t=trange
thm_load_state, probe = sc, coord = 'sm', trange = t, suffix = '_sm_coordinates'


get_data, strjoin('th'+sc+'_state_pos_sm_coordinates'), data = tmp
If(is_struct(tmp) Eq 0) Then Begin
  dprint, 'Missing: '+'th'+sc+'_state_pos_sm_coordinates'
  return
Endif

store_data, 'th'+sc+'_R', data = {x:tmp.x, y:sqrt(tmp.y[*, 0]^2+tmp.y[*, 1]^2+tmp.y[*, 2]^2)/6371.}, $
  dlim = {colors:[0], labels:['R'], ysubtitle:'[km]', labflag:1, constant:0, ytitle:'th'+sc+'_R'}
MLT = atan(tmp.y[*, 1]/tmp.y[*, 0])*180/!pi/15.+12
if(n_elements(where(tmp.y[*, 0] lt 0)) gt 1) then MLT[where(tmp.y[*, 0] lt 0)] = $
  (atan(tmp.y[where(tmp.y[*, 0] lt 0), 1]/tmp.y[where(tmp.y[*, 0] lt 0), 0])+!pi)*180/!pi/15.+12
if(n_elements(where(MLT[*] gt 24)) gt 1) then MLT[where(MLT[*] ge 24)] = MLT[where(MLT[*] ge 24)]-24
store_data, 'th'+sc+'_MLT', data = {x:tmp.x, y:MLT}, $
  dlim = {colors:[0], labels:['MLT'], ysubtitle:'[km]', labflag:1, constant:0, ytitle:'th'+sc+'_MLT'}
MLAT = atan(tmp.y[*, 2]/sqrt(tmp.y[*, 0]^2+tmp.y[*, 1]^2))*180/!pi
store_data, 'th'+sc+'_MLAT', data = {x:tmp.x, y:MLAT}, $
  dlim = {colors:[0], labels:['MLAT'], ysubtitle:'[deg]', labflag:1, constant:0, ytitle:'th'+sc+'_MLAT'}
  
;--------

tplot_options,'title','THEMIS-'+probe2+'-'+strmid(start_date_plot,0,10)
;popen,output_dir+'GSM_origin'+strmid(start_date_plot,0,10)+'-'+strmid(start_date_plot,11,2)+'_'+'_E='+flag_E+'_th'+probe2,xsize=8,ysize=10,units=cm,/encapsulated
tplot,[prb+btype+'_gsm',prb+'peir_velocity_gsm'],var_label = ['th'+sc+'_MLAT',prb+'MLT',prb+'state_pos_lshell'],trange=trangFFT
;pclose

;dsl2gse, prb+'peim_velocity',prb+'state_spinras',prb+'state_spindec',prb+'peim_velocity_gse'
;cotrans, prb+'peim_velocity_gse',prb+'peim_velocity_gsm',/GSE2GSM

;tdegap,['th*_fgs_gsm','th*_fgs_dsl','th*_state_pos_gsm',prb+'peir_velocity_gsm'],/overwrite
;interpolate v to have the same time resolution as B

tinterpol_mxn,prb+btype+'_gsm',prb+'peir_velocity_gsm',/overwrite

;compute the DC magnetic field using ~45 minute smoothing window
tsmooth2, prb+btype+'_gsm', smthP_togetFAC, newname=prb+btype+'_gsm_dc'
;calculate vxB
tcrossp,prb+'peir_velocity_gsm',prb+btype+'_gsm',newname=prb+'EvxB' 
;tdegap,[prb+'EvxB'],/overwrite
get_data,prb+'EvxB',data=tmp
;make sure the units are right (mV/m)
Ecorr=-1.*(1000.)*(1/1e9)*(1000)
store_data,prb+'EvxB',data={x:tmp.x,y:tmp.y*Ecorr}

;also load electric field from efi
thm_load_fit,probe=probe2
tdegap,prb+'efs_0',/overwrite

;interpolate E to have the same time resolution as B
tinterpol_mxn,prb+btype+'_dsl',prb+btype+'_gsm',/overwrite
tinterpol_mxn,prb+'efs_0',prb+btype+'_gsm',/overwrite
;get the dc magnetic field in dsl to compute E*B=0
tsmooth2, prb+btype+'_dsl', smthP_togetFAC, newname=prb+btype+'_dsl_dc'
get_data,prb+btype+'_dsl_dc',data=B
get_data,prb+'efs_0',data=E, dlimits=d, alimits=a
;**************************************************
;compute the three components of E from E*B=0
E.y(*,2)=$
  	-(E.y(*,0)*B.y(*,0)+$
    E.y(*,1)*B.y(*,1))/ $
    B.y(*,2)

store_data,prb+'efs_dot0',data=E,dlimits=d
;rotate from DSL to GSM
dsl2gse, prb+'efs_dot0',prb+'state_spinras',prb+'state_spindec',prb+'efs_dot0_gse'
cotrans, prb+'efs_dot0_gse',prb+'efs_dot0_gsm',/GSE2GSM

;detrend the magnetic field data
dif_data, prb+btype+'_gsm',prb+btype+'_gsm_dc',newname=prb+btype+'_gsm_rmvDC'
;detrend the electric field data
tsmooth2, prb+'efs_dot0_gsm', smthP_togetFAC, newname=prb+'efs_dot0_gsm_dc'
dif_data, prb+'efs_dot0_gsm',prb+'efs_dot0_gsm_dc',newname=prb+'efs_dot0_gsm_rmvDC'
tsmooth2, prb+'EvxB', smthP_togetFAC, newname=prb+'EvxB_dc'
dif_data, prb+'EvxB',prb+'EvxB_dc',newname=prb+'EvxB_rmvDC'

;rotate all data into field aligned coordinates
thm_load_state,probe=probe2, coord='gei',/get_support_data

fac_matrix_make, prb+btype+'_gsm_dc', other_dim='Xgse', pos_var_name=prb+'state_pos',newname = 'rotmat'
tvector_rotate, 'rotmat', prb+btype+'_gsm_rmvDC', newname = prb+btype+'_gsm_rmvDC'
tvector_rotate, 'rotmat', prb+'EvxB_rmvDC', newname = prb+'EvxB_rmvDC'
tvector_rotate, 'rotmat', prb+'efs_dot0_gsm_rmvDC',newname=prb+'efs_dot0_gsm_rmvDC'
tvector_rotate, 'rotmat', prb+'EvxB',newname=prb+'EvxB_fac'
;store_data,prb+'EvxB_fac',data=[prb+'EvxB']

;plot the data in field-aligned coordinates
timespan,start_date_plot,hour_toplot,/hours

split_vec,prb+E_name+'_rmvDC'
split_vec,prb+btype+'_gsm_rmvDC'
thm_ui_wavelet, prb+E_name+'_rmvDC_x',new_names,trangewvlt
thm_ui_wavelet, prb+btype+'_gsm_rmvDC_y',new_names,trangewvlt
thm_ui_wavelet, prb+btype+'_gsm_rmvDC_x',new_names,trangewvlt
thm_ui_wavelet, prb+E_name+'_rmvDC_y',new_names,trangewvlt
thm_ui_wavelet, prb+btype+'_gsm_rmvDC_z',new_names,trangewvlt

zlim,prb+E_name+'_rmvDC_x_wv_pow',1e-1,1e4
zlim,prb+E_name+'_rmvDC_y_wv_pow',1e-1,1e4

zlim,prb+btype+'_gsm_rmvDC_x_wv_pow',1e-1,1e4
zlim,prb+btype+'_gsm_rmvDC_y_wv_pow',1e-1,1e4
zlim,prb+btype+'_gsm_rmvDC_z_wv_pow',1e-1,1e4


tplot_options,'title','THEMIS-'+probe2+'-'+strmid(start_date_plot,0,10)
options,prb+E_name+'_rmvDC_x',ytitle='Er',ysubtitle='[mV/m]'
options,prb+E_name+'_rmvDC_y',ytitle='Ea',ysubtitle='[mV/m]'
options,prb+btype+'_gsm_rmvDC_x',ytitle='Br',ysubtitle='[nT]'
options,prb+btype+'_gsm_rmvDC_y',ytitle='Ba',ysubtitle='[nT]'
options,prb+btype+'_gsm_rmvDC_z',ytitle='Bp',ysubtitle='[nT]'

;popen,output_dir+'FAC_origin'+strmid(start_date_plot,0,10)+'-'+strmid(start_date_plot,11,2)+'_'+'_E='+flag_E+'_th'+probe2,xsize=8,ysize=10,units=cm,/encapsulated
tplot,[prb+E_name+'_rmvDC_x',prb+E_name+'_rmvDC_y',prb+btype+'_gsm_rmvDC_x',prb+btype+'_gsm_rmvDC_y',prb+btype+'_gsm_rmvDC_z'],var_label = [prb+'state_pos_mlat',prb+'state_pos_mlt',prb+'state_pos_lshell'],trange=trangeFFT
;pclose  write_csv
stop
get_data,prb+E_name+'_rmvDC_x_wv_pow',data=tmp,dlim=dlim
store_data,prb+E_name+'_rmvDC_x_wv_pow',data={x:tmp.x,y:tmp.y,v:tmp.v*1000.},dlim=dlim
get_data,prb+E_name+'_rmvDC_y_wv_pow',data=tmp,dlim=dlim
store_data,prb+E_name+'_rmvDC_y_wv_pow',data={x:tmp.x,y:tmp.y,v:tmp.v*1000.},dlim=dlim
get_data,prb+btype+'_gsm_rmvDC_z_wv_pow',data=tmp,dlim=dlim
store_data,prb+btype+'_gsm_rmvDC_z_wv_pow',data={x:tmp.x,y:tmp.y,v:tmp.v*1000.},dlim=dlim
get_data,prb+btype+'_gsm_rmvDC_y_wv_pow',data=tmp,dlim=dlim
store_data,prb+btype+'_gsm_rmvDC_y_wv_pow',data={x:tmp.x,y:tmp.y,v:tmp.v*1000.},dlim=dlim
get_data,prb+btype+'_gsm_rmvDC_x_wv_pow',data=tmp,dlim=dlim
store_data,prb+btype+'_gsm_rmvDC_x_wv_pow',data={x:tmp.x,y:tmp.y,v:tmp.v*1000.},dlim=dlim

options,prb+btype+'_gsm_rmvDC_z_wv_pow',ytitle='Bp Frequency!c[mHz]'
options,prb+btype+'_gsm_rmvDC_y_wv_pow',ytitle='Ba Frequency!c[mHz]'
options,prb+btype+'_gsm_rmvDC_x_wv_pow',ytitle='Br Frequency!c[mHz]'
options,prb+E_name+'_rmvDC_y_wv_pow',ytitle='Ea Frequency!c[mHz]'
options,prb+E_name+'_rmvDC_x_wv_pow',ytitle='Er Frequency!c[mHz]'

ylim,'*pow',1,20,1
  
popen,output_dir+'FAC_wvlt'+strmid(start_date_plot,0,10)+'-'+strmid(start_date_plot,11,2)+'_'+'_E='+flag_E+'_th'+probe2,xsize=8,ysize=10,units=cm,/encapsulated
tplot,[prb+E_name+'_rmvDC_x_wv_pow',prb+E_name+'_rmvDC_y_wv_pow',prb+btype+'_gsm_rmvDC_x_wv_pow',prb+btype+'_gsm_rmvDC_y_wv_pow',prb+btype+'_gsm_rmvDC_z_wv_pow'],var_label = [prb+'state_pos_mlat',prb+'state_pos_mlt',prb+'state_pos_lshell'],trange=trangeFFT
pclose
;stop
;**********************************************************
;**filter B E**
;----------------------------------------------------------
;flow=.002
;fhigh=.004




get_data,prb+E_name+'_rmvDC',data=Edata,dlimits=Ed
get_data,prb+btype+'_gsm_rmvDC',data=Bdata,dlimits=Bd

tmp=Edata.y(*,0)
interp_gap, Edata.x, tmp
Edata.y(*,0)=tmp

tmp=Edata.y(*,1)
interp_gap, Edata.x, tmp
Edata.y(*,1)=tmp

tmp=Edata.y(*,2)
interp_gap, Edata.x, tmp
Edata.y(*,2)=tmp

tmp=Bdata.y(*,0)
interp_gap, Bdata.x, tmp
Bdata.y(*,0)=tmp

tmp=Bdata.y(*,1)
interp_gap, Bdata.x, tmp
Bdata.y(*,1)=tmp

tmp=Bdata.y(*,2)
interp_gap, Bdata.x, tmp
Bdata.y(*,2)=tmp


Bdata=time_domain_filter(Bdata,flow,fhigh)
Edata=time_domain_filter(Edata,flow,fhigh)



store_data,prb+E_name+'_rmvDCbp',data=Edata,dlimits=Ed
store_data,prb+btype+'_gsm_rmvDCbp',data=Bdata,dlimits=Bd

;stop
;;;;;;;;;;;;;;;;;;;;;;;
;plot the components specifically for the Alfven wave (ex, by) and compressional wave
;plot the components for pure bandpassed data
split_vec,prb+btype+'_gsm_rmvDCbp'
split_vec,prb+E_name+'_rmvDCbp'
split_vec,prb+'efs_dot0_gsm_rmvDCbp'

get_data,prb+E_name+'_rmvDCbp_y',data=tmp,dlim=dlim
store_data,prb+E_name+'_rmvDCbp_y',data={x:tmp.x,y:tmp.y},dlim=dlim
store_data,'Exby_bp',data=[prb+E_name+'_rmvDCbp_x',prb+btype+'_gsm_rmvDCbp_y']
store_data,'Eybx_bp',data=[prb+E_name+'_rmvDCbp_y',prb+btype+'_gsm_rmvDCbp_x']
store_data,'Eybz_bp',data=[prb+E_name+'_rmvDCbp_y',prb+btype+'_gsm_rmvDCbp_z']
store_data,'Exbz_bp',data=[prb+E_name+'_rmvDCbp_x',prb+btype+'_gsm_rmvDCbp_z']

;plus crossphase
nfft=256
;set the amount of overlap between FFT windows
;nshift=128 ; original!
nshift=32
;the number of frequency bins to average over (to reduce noise)
binsize=2 
;get the power spectral density of one variable
tdcoherence, prb+E_name+'_rmvDCbp_x', prb+btype+'_gsm_rmvDCbp_y', $
              trange = trange, nboxpoints=nfft,$
              nshiftpoints=nshift,bin=binsize,newname='Exby_tdcoherence' 
              
         ;tdcoherence,'OMNI_HRO_1min_Pressure','OMNI_HRO_1min_proton_density',trange=['2010-01-01','2010-01-02'],nboxpoints=1024,nshiftpoints=256,bin=1,newname='tdcoherence'    
              
    stop          
tdcoherence, prb+E_name+'_rmvDCbp_y', prb+btype+'_gsm_rmvDCbp_x', $
              trange = trange, nboxpoints=nfft,$
              nshiftpoints=nshift,bin=binsize,newname='Eybx_tdcoherence' 
tdcoherence, prb+E_name+'_rmvDCbp_y', prb+btype+'_gsm_rmvDCbp_z', $
              trange = trange, nboxpoints=nfft,$
              nshiftpoints=nshift,bin=binsize,newname='Eybz_tdcoherence' 
tdcoherence, prb+E_name+'_rmvDCbp_x', prb+btype+'_gsm_rmvDCbp_z', $
              trange = trange, nboxpoints=nfft,$
              nshiftpoints=nshift,bin=binsize,newname='Exbz_tdcoherence' 

;add time shift

time_shift, 'Exbz_tdcoherence_crossphase', nfft/2.*3.
time_shift, 'Eybz_tdcoherence_crossphase', nfft/2.*3.
time_shift, 'Exby_tdcoherence_crossphase', nfft/2.*3.
time_shift, 'Eybx_tdcoherence_crossphase', nfft/2.*3.

get_timespan,trange_plot
get_data,'Exby_tdcoherence_crossphase',data=tmp
time_tmp=tmp.x
ikeep = where((time_tmp ge time_double(trange_plot[0])) and (time_tmp le time_double(trange_plot[1])))
dummy=min(abs(double(tmp.v(0,*))-cp_freq),idx)
store_data,'Exby_crossphase_xmHz',data={x:tmp.x(ikeep),y:tmp.y(ikeep,idx)}
;
get_data,'Eybx_tdcoherence_crossphase',data=tmp
time_tmp=tmp.x
ikeep = where((time_tmp ge time_double(trange_plot[0])) and (time_tmp le time_double(trange_plot[1])))
dummy=min(abs(double(tmp.v(0,*))-cp_freq),idx)
store_data,'Eybx_crossphase_xmHz',data={x:tmp.x(ikeep),y:tmp.y(ikeep,idx)}
;
get_data,'Eybz_tdcoherence_crossphase',data=tmp
time_tmp=tmp.x
ikeep = where((time_tmp ge time_double(trange_plot[0])) and (time_tmp le time_double(trange_plot[1])))
dummy=min(abs(double(tmp.v(0,*))-cp_freq),idx)
store_data,'Eybz_crossphase_xmHz',data={x:tmp.x(ikeep),y:tmp.y(ikeep,idx)}
;
get_data,'Exbz_tdcoherence_crossphase',data=tmp
time_tmp=tmp.x
ikeep = where((time_tmp ge time_double(trange_plot[0])) and (time_tmp le time_double(trange_plot[1])))
dummy=min(abs(double(tmp.v(0,*))-cp_freq),idx)
store_data,'Exbz_crossphase_xmHz',data={x:tmp.x(ikeep),y:tmp.y(ikeep,idx)}

get_data, 'Exby_crossphase_xmHz', data=d0, limits=l0
get_data, 'Eybx_crossphase_xmHz', data=d1, limits=l1
get_data, 'Eybz_crossphase_xmHz', data=d2, limits=l2
get_data, 'Exbz_crossphase_xmHz', data=d3, limits=l3
store_data, 'crossphase_xmHz_new', data = {x:d0.x, y:[[d0.y],[d1.y],[d2.y],[d3.y]]}

;overplot Ex and by on the top, Ey and bz on the bottom
options,'Exby_bp','ytitle',prb+'__'+'Exby_bp'
options,'Eybx_bp','ytitle',prb+'__'+'Eybx_bp'
options,'Eybz_bp','ytitle',prb+'__'+'Eybz_bp'
options,'Exbz_bp','ytitle',prb+'__'+'Exbz_bp'
options,'E*b*_bp','colors',[250,70]

options,'Exby_bp',labels=['Er','Ba'],labflag=1
options,'Eybx_bp',labels=['Ea','Br'],labflag=1
options,'Eybz_bp',labels=['Ea','Bp'],labflag=1
options,'Exbz_bp',labels=['Er','Bp'],labflag=1
options, 'crossphase_xmHz_new', labels = ['Er-Ba','Ea-Br', 'Ea-Bp','Er-Bp'], $
                                colors = [0,2,6,4], $
                                labflag=1
                                
ylim,'E*b*_bp',-1*eb,eb,0
ylim,'crossphase_xmHz_new',-180,180,0

popen,output_dir+'FAC_'+strmid(start_date_plot,0,10)+'-'+strmid(start_date_plot,11,2)+'_pDC'+String(smthP_togetFAC, FORMAT='(I04)')+'_dEdBbpPure'+String(flow, FORMAT='(f7.5)')+'to'+String(fhigh, FORMAT='(f7.5)')+'_E='+flag_E+'_th'+probe2,xsize=8,ysize=10,units=cm,/encapsulated

;tplot,['Eybx_bp','crossphase_xmHz_new']
A = FINDGEN(17) * (!PI*2/16.) ;makes a circular symbol to mark spacecraft position
USERSYM, COS(A), SIN(A), /FILL 
;tplot_options,'TH-'+probe2+'_'+strmid(time_string(t1),0,10)


;store_data, 'crossphase_xmHz_new', data = {x:d0.x, y:[[d0.y],[d1.y],[d2.y]]}
;options, 'crossphase_xmHz_new', labels = ['Er-Ba','Ea-Br', 'Ea-Bp'],colors = [5,1,0],labflag=1

options, 'crossphase_xmHz_new',psym=-8,symsize=2,ytickinterval=90,yminor=1
tplot_options,'yticklen',0.015
tplot_options,'xticklen',0.04
tplot_options,'ygap',2



;options,'crossphase_xmHz_new',psym=8,symsize=1
tplot,['Eybz_bp','Exbz_bp','Exby_bp','Eybx_bp','crossphase_xmHz_new'],var_label = [prb+'state_pos_mlat',prb+'state_pos_mlt',prb+'state_pos_lshell'],trange=trangFFT
;tplot,['Eybz_bp','Eybx_bp','Exby_bp','crossphase_xmHz_new'],var_label = [prb+'state_pos_mlat',prb+'state_pos_mlt',prb+'state_pos_lshell'],trange=trangFFT

timebar,0,VARNAME='Eybz_bp',databar=6.,color=0,linestyle=2,thick=2
timebar,0,VARNAME='Exbz_bp',databar=6.,color=0,linestyle=2,thick=2
timebar,0,VARNAME='Exby_bp',databar=6.,color=0,linestyle=2,thick=2
timebar,0,VARNAME='Eybx_bp',databar=6.,color=0,linestyle=2,thick=2
;timebar,70,VARNAME='crossphase_xmHz_new',databar=6.,color=0,linestyle=2,thick=2
timebar,90,VARNAME='crossphase_xmHz_new',databar=6.,color=0,linestyle=2,thick=2
timebar,-90,VARNAME='crossphase_xmHz_new',databar=6.,color=0,linestyle=2,thick=2
;timebar,-70,VARNAME='crossphase_xmHz_new',databar=6.,color=0,linestyle=2,thick=2
pclose
timebar,t0,color=4,linestyle=2,thick=2

;
store_data,'tha_BpEa',data=['tha_EvxB_rmvDCbp_y','tha_fgs_gsm_rmvDCbp_z']
store_data,'thd_BpEa',data=['thd_EvxB_rmvDCbp_y','thd_fgs_gsm_rmvDCbp_z']
store_data,'the_BpEa',data=['the_EvxB_rmvDCbp_y','the_fgs_gsm_rmvDCbp_z']

stop ;rbsp_load_emfisis;ylim

get_data,'tha_EvxB_rmvDC_x_wv_pow',data=Exa
get_data,'thd_EvxB_rmvDC_x_wv_pow',data=Exd
get_data,'the_EvxB_rmvDC_x_wv_pow',data=Exe
get_data,'tha_EvxB_rmvDC_y_wv_pow',data=Eya
get_data,'thd_EvxB_rmvDC_y_wv_pow',data=Eyd
get_data,'the_EvxB_rmvDC_y_wv_pow',data=Eye
get_data,'tha_fgs_gsm_rmvDC_z_wv_pow',data=Bza
get_data,'thd_fgs_gsm_rmvDC_z_wv_pow',data=Bzd
get_data,'the_fgs_gsm_rmvDC_z_wv_pow',data=Bze
get_data,'tha_fgs_gsm_rmvDC_y_wv_pow',data=Bya
get_data,'thd_fgs_gsm_rmvDC_y_wv_pow',data=Byd
get_data,'the_fgs_gsm_rmvDC_y_wv_pow',data=Bye
get_data,'tha_fgs_gsm_rmvDC_x_wv_pow',data=Bxa
get_data,'thd_fgs_gsm_rmvDC_x_wv_pow',data=Bxd
get_data,'the_fgs_gsm_rmvDC_x_wv_pow',data=Bxe

gooda=16611
goodd=15611
goode=12398

plot,Bza.v,Bza.y[16611,*],/xlog,/ylog,xrange=[0.1,100],yrange=[1e-2,1e6]
oplot,Bzd.v,Bzd.y[15611,*],color=2
oplot,Bze.v,Bze.y[12398,*],color=6

oplot,Bxa.v,Bxa.y[16611,*],color=4
oplot,Bxd.v,Bxd.y[15611,*],color=4
oplot,Bxe.v,Bxe.y[12398,*],color=4

oplot,Bya.v,Bya.y[16611,*],color=4
oplot,Byd.v,Byd.y[15611,*],color=4
oplot,Bye.v,Bye.y[12398,*],color=4

plot,Eya.v,Eya.y[16611,*],linestyle=2,/xlog,/ylog,xrange=[0.1,100],yrange=[1e-2,1e4],ystyle=1,ytickinterval=3
oplot,Eyd.v,Eyd.y[15611,*],color=2,linestyle=2
oplot,Eye.v,Eye.y[12398,*],color=6,linestyle=2

;*************************************************************************
;calculate the **poynting vector**
;compute       **poynting vector** 
;-------------------------------------------------------------------------
if strcmp(flag_E,'VxB') then begin
tcrossp,prb+'EvxB_rmvDCbp',prb+btype+'_gsm_rmvDCbp',newname=prb+'s'
endif
if strcmp(flag_E,'EFI') then begin
tcrossp,prb+'efs_dot0_gsm_rmvDCbp',prb+btype+'_gsm_rmvDCbp',newname=prb+'s'
endif
;while calculating, convert B from nT to T and E from mV/m to V/m
;also divide by mu0 permeability of free space
;e.g., v was in km/s and B was in nT, E is desired in mV/m
mu0   =(4*3.141592654)*1e-7
extra =(1/1e9)*(1/1e3)*(1/mu0)
get_data,prb+'s',data=tmp;,dlimits=dl
;{
              tmp.y = tmp.y*extra
 ;         dl.ytitle = prb+'bps!CW/m^2'
 ;         dl.labels = [prb+'Sx',prb+'Sy',prb+'Sz']
 ; dl.data_att.units = 'W/m^2'
      ;dl.ysubtitle = '[W/m^2]'
;}
store_data,prb+'s',data=tmp;, dlimits=dl
split_vec,prb+'s'

tsmooth2, prb+'s_x', smooth_points, newname = prb+'s_x_sm601'
tsmooth2, prb+'s_y', smooth_points, newname = prb+'s_y_sm601'
tsmooth2, prb+'s_z', smooth_points, newname = prb+'s_z_sm601'

store_data,'sx_sxsm601',data=[prb+'s_x', prb+'s_x_sm601']
store_data,'sy_sysm601',data=[prb+'s_y', prb+'s_y_sm601']
store_data,'sz_szsm601',data=[prb+'s_z', prb+'s_z_sm601']

;ylim_s=ylim_s
ylim,'sx_sxsm601',-1*ylim_s,ylim_s,0
;ylim,'sx_sxsm601',-2e-6,2e-6,0 ;
ylim,'sy_sysm601',-1*ylim_s,ylim_s,0
;ylim,'sy_sysm601',-2e-6,2e-6,0
ylim,'sz_szsm601',-1*ylim_s,ylim_s,0
;ylim,'sz_szsm601',-2e-6,2e-6,0

options,'sz_szsm601','colors',[70,250]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
options,'sx_sxsm601','colors',[70,250]
options,'sy_sysm601','colors',[70,250]

options,'sz_szsm601','ytitle',prb+'  '+'Sz'
options,'sx_sxsm601','ytitle',prb+'  '+'Sx'
options,'sy_sysm601','ytitle',prb+'  '+'Sy'

options,'sz_szsm601','labels',['Sz','Sz_sm']
options,'sx_sxsm601','labels',['Sx','Sx_sm']
options,'sy_sysm601','labels',['Sy','Sy_sm']

;plot the Poynting vector - from top to bottom, all three components
;( overplotted,[ prb+'s'])then the X component of the Poynting vector, then Y, then Z

;popen,output_dir+'FAC_'+strmid(start_date_plot,0,10)+'-'+strmid(start_date_plot,11,2)+'_pDC'+String(smthP_togetFAC, FORMAT='(I04)')+'_PoyntingBP_new'+String(flow, FORMAT='(f7.5)')+'to'+String(fhigh, FORMAT='(f7.5)')+'_smth'+String(smooth_points, FORMAT='(I04)')+'_E='+flag_E+'_th'+probe2,xsize=8,ysize=10,units=cm,/encapsulated

;popen,'e:\poynting_vector_event_b'
tplot,['sx_sxsm601','sy_sysm601','sz_szsm601'],var_label = [prb+'state_pos_mlat',prb+'state_pos_mlt',prb+'state_pos_lshell'],trange=trangFFT

;timebar,0,VARNAME=prb+'s',databar=6.,color=6,linestyle=1
timebar,0,VARNAME='sx_sxsm601',databar=6.,color=6,linestyle=1
timebar,0,VARNAME='sy_sysm601',databar=6.,color=6,linestyle=1
timebar,0,VARNAME='sz_szsm601',databar=6.,color=6,linestyle=1  
;pclose
;sphere_to_cart
;endfor  rbsp_mgse2gse   output_txt

End