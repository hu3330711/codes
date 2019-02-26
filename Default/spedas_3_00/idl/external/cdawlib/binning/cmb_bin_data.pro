;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_bin_data,d,dt_sec= dt_sec,dates=dates, sigmul=sigmul,vars=vars,multiple_modes=multiple_modes $
                     ,cdfepochtype=cdfepochtype,diagnostic=diagnostic $
                     ,nointerpolation=nointerpolation

;+
; EXAMPLE USAGE:
;   status= cmb_bin_data( d,dates=[start,stop],dt_sec = dt_sec)
;
; NAME:
;   cmb_bin_data
;            
; PURPOSE:   
; This procedure creates uniformly spaced binned data for the specified variables and data set.
; Bins containing no data are interpolated using nearest neighbor bins that contain data.
; It then creates these variables and their metadata on the calling level of your current IDL session.
;
; CATEGORY:
; Data binning.
;
; CALLING SEQUENCE:                                   
;  status= cmb_bin_data( d, d,dt_sec= dt_sec,dates=dates,sigmul=sigmul,vars=vars,multiple_modes=multiple_modes,cdfepochtype=cdfepochtype)
;                                                     
; INPUTS:                                             
; d = data structure returned by read_mycdf.pro
;
; Keyword Inputs:
;   dates: string of start/stop times; e.g. start='2014/01/20 00:00:00.000',  stop='2014/01/20 03:00:00.000'
;   dt_sec: time interval in seconds of the time bin width, in double precision.
;   sigmul: if set and sigmul >= 1, sigmul is the multiplicative factor of standard deviation for rejection of data: 
;           5 (default),  4 (less aggressive), 6 (more aggressive). Note is sigmul < 1 or not defined filtering is skipped.
;   multiple_modes =1 (default) then set the non-dominant modes to fill
;                  =0 interpolate all modes to the dominant mode 
;           this keyword was introduced because some multi dependency variables are composed of multiple modes, 
;           an example of possible mixture of modes is ion flux as function of time and energy where energy is time dependent.
;   vars: list of cdf variable names,  i.e. vars = ['Magnitude', 'BRTN']
;       Note: cdf variable names are case sensitive.
;       The default output variable name is the cdf variable name.
;       To rename output variables and/or break them into components use following syntax:
;       vars =['cdfvariablename1=var','cdfvariablename2=var1,var2,var3']
;       the later breaks 'cdfvariablename2' into components named 'var1','var2','var3',
;       Note: the number of specified output components must equal the number of components for that cdf variable.
;       For example vars = ['Magnitude=B0', 'BRTN=Bvec'],
;       would create output variables named 'B0' and 'BVEC'.
;       For example vars = ['Magnitude=B0', 'BRTN=Bx,By,Bz'],
;       would create output variables named 'B0' and 'Bx','By','Bz' (components) instead of 'Magnitude' and 'BRTN' (vector).
;   nointerpolation =1 (leave empty bins empty), 0 (DEFAULT,linear interpolate using non-empty neighboring bins)
;
; OUTPUTS:
;   1 is successful
;   0 if not.
;
; COMMON BLOCKS:
;   None.
;
; SIDE EFFECTS:
;   Unknown.
;
; RESTRICTIONS:
;   Unknown.
;
; FUNCTION:
;
; MODIFICATION HISTORY:
;   Code developed by Aaron Roberts and Scott Boardsen at GSFC.
;-

if cmb_var_type(d) ne 'STRUCT' then return,0
if n_elements(dates) ne 2 then return,0
if keyword_set(nointerpolation) then  fill_empty_bins=0 else fill_empty_bins=1
if n_elements(dt_sec) eq 0 then dt_sec = 0d0 ; seconds, if not set do not bin
if n_elements(sigmul) eq 0 then sigmul=0
if sigmul ge 1. then autobad = 1

if dt_sec le 0 and sigmul ge 1. then begin
   cmb_spike_editor0,d,sigmul
end
if dt_sec le 0 then return,0
;if n_elements(cdfepochtype) eq 0 then cdfepochtype='CDF_EPOCH'
depend0 = cmb_cdf_get_depend0(d) 
if n_elements(cdfepochtype) eq 0 then cdfepochtype=depend0[0].cdftype
if cdfepochtype eq 'CDF_EPOCH16' then cdfepochtype = 'CDF_TIME_TT2000'
dtbin = cmb_dtbin( dt_sec, cdfepochtype=cdfepochtype)

time_name = 'EPOCH_BIN'
av = cmb_cdf2user_var(vars,d)
tnames = tag_names(d)
nvars = n_elements(av.cdfvar)
epr = cmb_string2epr(dates,cdfepochtypeout=cdfepochtype) ;start/stop times in epoch
tbeg = epr[0]
tend = epr[1]
diagnostic={dtbin:dtbin,tbeg:tbeg, tend:tend}
for ii = 0, nvars-1 do begin
    print,'----------------------------------------------------' 
    ip = where( tnames eq strupcase(av.cdfvar[ii]) ) & if n_elements(ip) ne 1 then stop & ip = ip[0] ;bug fixed SAB 6/5/2014
    
    if ip eq -1 then goto, skipthisvar
    if cmb_tag_name_exists('ALLOW_BIN',d.(ip)) then begin ;SAB 4/6/2016
       if d.(ip).allow_bin eq 'FALSE' then BEGIN
          print, 'ALLOW_BIN = FALSE, variable:', d.(ip).varname, ' not binned'
          if cmb_tag_name_exists('units',d.(ip)) then  $
                      d.(ip).units = d.(ip).units + ' (not binned)'
          goto, skipthisvar 
       ENDIF
    endif 
    iep=where( strlowcase(d.(ip).depend_0) eq strlowcase(tnames)) & iep=iep[0]
    VALIDMIN = 0
    VALIDMAX = 0
    if cmb_tag_name_exists('VALIDMIN',d.(ip)) and cmb_tag_name_exists('VALIDMAX',d.(ip)) then begin
       VALIDMIN = d.(ip).VALIDMIN
       VALIDMAX = d.(ip).VALIDMAX
    endif
    ;print,'name,valid min/max:', d.(0).varname, validmin, validmax ; for diagnostic
    if iep eq -1 then begin
       print,'CDF variable ' + av.cdfvar[ii] + ' is not dependent on time, skipped.'
       goto,skipthisvar
    endif
    cmb_cdf_check_if_dependencies_are_time_varying,d, ip, multiple_modes=multiple_modes ;add by SAB 4/17/2014
    other_depend = cmb_cdf_get_dependencies(d, ip, /not_zero, level=level) & if other_depend[0] ne '' then other=', another dependency is ' + other_depend else other=''
    print,'CDF VARIABLE ', av.cdfvar[ii], ', now called ',av.uservar[ii],' whose independent variable is ', time_name, other
    print,'CREATED VARIABLE: ', cmb_var_label(av.uservar[ii], other_depend, time_name)
    note =  cmb_var_label(av.uservar[ii], other_depend, time_name)
    t_d = cmb_epoch_modify( cmb_dat(d.(iep)),cdfepochtypeout=cdfepochtype)
;    help,cdfepochtype, t_d,cmb_dat(d.(iep)) &stop   
    print,'Depend_0', tnames[iep]
;    help,t_d,cdfepochtype
    if dtbin le 0 then print,'Note data is not binned in time, original time dependency of ', av.cdfvar[ii],' is ',tnames[iep]
    values = cmb_dat(d.(ip))
    fillflag= d.(ip).fillval
    if finite(fillflag) eq 0 then fillflag = cmb_valid_data_range(d,ip)
    ibreak = cmb_break_decision(av,ii,size(cmb_dat(d.(ip)),/structure))
    if ibreak eq -1 then goto,skipthisvar    
    if (ibreak) then begin ;break matrix in components
       vname0 = cmb_var_name_components(av.uservar[ii])
       for jj = 0, av.nc[ii]-1 do begin
	vname = vname0[jj]
	value = reform(values[jj,*])
	if n_elements(value) eq  1 then goto,skipthisvar
	cmb_timebin_array,t_d, value, tbeg, tend, dtbin, t_out, valueout, fillflag $
	,serout_flag=valueout_nbin, fill_empty_bins=fill_empty_bins, autobad=autobad, sigmul=sigmul $
	,VALIDMIN=VALIDMIN, VALIDMAX=VALIDMAX
       endfor
    endif else begin ;don't break into componets
	vname = av.uservar[ii]
	if n_elements(values) eq  1 then goto,skipthisvar
	cmb_timebin_array,t_d, values, tbeg, tend, dtbin, t_out, valueout ,fillflag $
	,serout_flag=valueout_nbin, fill_empty_bins=fill_empty_bins, autobad=autobad, sigmul=sigmul $
	,VALIDMIN=VALIDMIN, VALIDMAX=VALIDMAX
    endelse
    if n_elements(d0) eq 0 then d0 = create_struct(time_name, cmb_epoch_modify(t_out,cdfepochtypeout=depend0[0].cdftype) )
    ;cmb_depend_0_modify,d0,d,ip,t_out
    d0 = create_struct(d0, vname, valueout, vname+'_NBIN', valueout_nbin)
    if cmb_tag_name_exists('epoch', d0) then stop
    skipthisvar:
endfor ;ii
print,'----------------------------------------------------'

print,'Created time variable ' + time_name
if cmb_var_type(d0) ne 'STRUCT' then return,1
d0 = create_struct(d0,'aux', create_struct('time_bin_width_sec',dt_sec, 'epr', epr))
;set time dependent dependencies to that of the dominant instrument mode
for ii = 0, nvars-1 do begin ;add by SAB 4/17/2014
    ip= where( strpos(tnames, strupcase(av.cdfvar[ii]) ) ne -1 ) & ip=ip[0] ;add by SAB 4/17/2014
    if ip[0] ne -1 then cmb_cdf_check_if_dependencies_are_time_varying,d, ip,/set_depend_to_dominant_mode ;add by SAB 4/17/2014
endfor ;add by SAB 4/17/2014
dummy = CMB_CDF_GET_DEPENDENCIES(d,/write,/not_zero, d0=d0) ; removes time dependent dependencies for variables that where binned.
; save,d,d0 ; note comment out after testing cmb_updatestructwith_epoch_bin
; stop
cmb_cdf_updatedatastructure,d,d0 ; overwrite handles with handles pointing to the binned data

;d = cmb_updatestructwith_epoch_bin(d,d0) ; replace the depend_0 values to 'EPOCH_BIN' for variables that where binned.
;cmb_meta_validate,d  ;fixes depend_0 metadata
;cmb_cdf_nbin_var_type,d ;change new _bin variables to support data.
;return,d0
return,1
end