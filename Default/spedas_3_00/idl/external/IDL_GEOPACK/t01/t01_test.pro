;+
; tt01_test
;
; Purpose: A few tests to verify that the model and the wrapper
; procedures work correctly
;
; $LastChangedBy: egrimes $
; $LastChangedDate: 2014-03-18 08:26:40 -0700 (Tue, 18 Mar 2014) $
; $LastChangedRevision: 14570 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/external/IDL_GEOPACK/t01/t01_test.pro $
;-

;takes a matrix whose columns define a plane
;and an Nx3 series of points
;returns an Nx2 series of points generated by projecting x into a
function project_t01, a, x

p = a ## invert(transpose(a) ## a) ## transpose(a)

return, p ## x

end

;constructs a vector field from orbital data, useful for visualization
;of results
pro orbital_vf_t01, name

  get_data, name, data = d

  tt01,name,pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,g1=6.0D,g2=10.0D,error=e

  get_data, name+'_bt01', data = td

  t_size = n_elements(d.x)

  ;3 points selected to define a plane
  v1 = d.y[0, *]

  v2 = d.y[floor(t_size/3), *]

  v3 = d.y[floor(2*t_size/3), *]

  ;plane vectors are just v2, and v3 shifted by the reference point v1
  vp1 = v2-v1

  vp2 = v3-v1

  proj_pos = project_t01([vp1, vp2], d.y)
  
  proj_mag = project_t01([vp1, vp2], td.y)

  ivector, interpol(proj_mag[*, 0],20),interpol(proj_mag[*, 1],20), interpol(proj_pos[*, 0],20), interpol(proj_pos[*, 1],20),renderer=1

end

timespan, '2007-03-23'

;load state data
thm_load_state, probe = 'b', coord = 'gsm'

;test with single number argument
tt01, 'thb_state_pos',pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,g1=6.0D,g2=10.0D,error=e

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'thb_state_pos_bt01'

stop

del_data,'thb_state_pos_bt01'

get_data,'thb_state_pos',data=d

n = n_elements(d.x)

;test with an array argument
tt01, 'thb_state_pos',pdyn=replicate(2.0D,n),dsti=replicate(-30.0D,n),yimf=replicate(0.0D,n),zimf=replicate(-5.0D,n),g1=replicate(6.0D,n),g2=replicate(10.0D,n),error=e

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'thb_state_pos_bt01'

stop

del_data,'thb_state_pos_bt01'

d2 = {x:d.x[0],y:2.0D}

store_data,'t_pdyn',data=d2

d2 = {x:d.x[0],y:-30.0D}

store_data,'t_dsti',data=d2

d2 = {x:d.x[0],y:0.0D}

store_data,'t_yimf',data=d2

d2 = {x:d.x[0],y:-5.0D}

store_data,'t_zimf',data=d2

d2 = {x:d.x[0],y:6.0D}

store_data,'t_g1',data=d2

d2 = {x:d.x[0],y:10.0D}

store_data,'t_g2',data=d2

;test with tplot arguments
tt01,'thb_state_pos',pdyn='t_pdyn',dsti='t_dsti',yimf='t_yimf',zimf='t_zimf',g1='t_g1',g2='t_g2',error=e

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'thb_state_pos_bt01'

stop

del_data,'thb_state_pos_bt01'

;test with newname
tt01, 'thb_state_pos',pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,newname='test',g1='t_g1',g2='t_g2',error=e

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'test'

stop

del_data,'test'

;test with a different period
tt01, 'thb_state_pos',pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,period=30,g1='t_g1',g2='t_g2',error=e

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'thb_state_pos_bt01'

stop

del_data,'test'

;test with an incremented tilt
tt01, 'thb_state_pos',pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,period=30,error=e,get_tilt='tilt_vals',get_nperiod=gn,add_tilt=1,g1='t_g1',g2='t_g2'

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

tplot,'tilt_vals'

stop

;test with a set tilt
tt01, 'thb_state_pos',pdyn=2.0D,dsti=-30.0D,yimf=0.0D,zimf=-5.0D,period=30,error=e,get_tilt='tilt_vals',get_nperiod=gn,set_tilt=1,g1='t_g1',g2='t_g2'

if e eq 0 then begin
    message,/continue,'error detected, stopping'
    stop
endif

print,gn

options,'tilt_vals',yrange=[0,2]
tplot,'tilt_vals'
options,'tilt_vals',yrange=[1,1]  ;reset to auto-range
stop

orbital_vf_t01,'thb_state_pos'

print,'The plot produced should look like the plot titled t01_test.png'

end