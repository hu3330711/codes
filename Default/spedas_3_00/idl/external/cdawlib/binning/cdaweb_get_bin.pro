;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

pro cdaweb_get_bin,dataset_id,vars, t_init, t_final,dt_sec,time_name=time_name, autobad=autobad, sigmul=sigmul,$
                   tdas=tdas,$
                   to_struct=to_struct, $ 
                   keepfiles=keepfiles,$
                   move_cdf_files_to_directory=move_cdf_files_to_directory, $
                   multiple_modes=multiple_modes, $
                   diagnostic=diagnostic, $
                   nointerpolation=nointerpolation, $
                   tt2000 = tt2000

;+
; EXAMPLE USAGE:
;   cdaweb_get_bin, 'AC_H3_MFI', ['Magnitude', 'BRTN'], '2007-01-10T02:00:00.0Z', '2007-01-10T23:59:59.0Z',time_name='Julian_day'
;
; NAME:
;   cdaweb_get_bin
;            
; PURPOSE:   
; This procedure retrieves data remotely from the SPDF/CDAWeb and
; creates uniformly spaced binned data for the specified variables and data set.
; Bins containing no data are interpolated using nearest neighbor bins that contain data.
; It then creates these variables and their metadata on the calling level of your current IDL session.
;
; CATEGORY:
; Remote data retrieval and binning.
;
; CALLING SEQUENCE:                                   
; cdaweb_get_bin,dataset_id,vars, t_init, t_final,dt_sec,time_name=time_name, autobad=autobad, sigmul=sigmul,$
;        tdas=tdas, to_struct=to_struct,keepfiles=keepfiles,move_cdf_files_to_directory=move_cdf_files_to_directory                       
;                                                     
; INPUTS:                                             
;   dataset_id: cdf dataset id   i.e. dataset_id = 'AC_H3_MFI'
;       Note: the dataset_id and cdf variable names can be determined at http://heliophysicsdata.gsfc.nasa.gov/websearch/dispatcher.
;   vars: list of cdf variable names,  i.e. vars = ['Magnitude', 'BRTN']
;       Note: cdf variable names are case sensitive.
;       The default output variable name is the cdf variable name.
;       To rename output variables and/or break them into components use following syntaxt:
;       vars =['cdfvariablename1=var','cdfvariablename2=var1,var2,var3']
;       the later breaks 'cdfvariablename2' into components named 'var1','var2','var3',
;       Note: the number of specified output components must equal the number of components for that cdf variabe.
;       For example vars = ['Magnitude=B0', 'BRTN=Bvec'],
;       would create output variables named 'B0' and 'BVEC'.
;       For example vars = ['Magnitude=B0', 'BRTN=Bx,By,Bz'],
;       would create output variables named 'B0' and 'Bx','By','Bz' (components) instead of 'Magnitude' and 'BRTN' (vector).
;   t_init:  start time in isodate format, i.e.  t_init ='2007-01-10T02:00:00.0Z'
;   t_final: stop time in isodate format, i.e.   t_final='2007-01-10T23:59:59.0Z'
;   dt_sec: time interval in seconds of the time bin width.
;
; Keyword Inputs:
;   tt2000  - if set the data will be binned using tt2000
;               if the epoch is not in tt2000 it will be converted to tt2000                                             
;   time_name: name of output time variable, default is 'TIMEJD'.
;   autobad - if set data will be filtered for bad data points: data where |data - running mean| > sigmul*standard_deviation 
;            will be flagged as bad and not used.
;   sigmul - used only if autobad keyword is set: multiplicative factor of standard deviation for rejection of data: 5 (default),  4 (less aggressive), 6 (more aggressive). 
;   tdas  - if set the variables are moved into TDAS, not written to the calling level.
;   keepfile - if set keep the downloaded cdf files that contain the requested variable.
;   move_cdf_files_to_directory - if set to a directory and if keepfiles is set move the downloaded cdf files to that directory.
;   to_struct - if set to a name the requested variables will be placed in a structure with that name on the calling level.
;   multiple_modes = =1 (default) then set the non-dominant modes to fill
;                  =0 interpolate all modes to the dominant mode
;           this keyword was introduced because some multi dependency variables are composed of multiple modes, 
;           an example of possible mixture of modes is ion flux as function of time and energy where energy is time dependent.
;   nointerpolation =1 (leave empty bins empty), 0 (DEFAULT,linear interpolate using non-empty neighboring bins) 
;
; OUTPUTS:
;   <variable>: binned data whose name is specified by input variable 'vars'.
;   <variable>_NBIN; number of data points in a given bin.
;   time_name: center time in Julian Days of each data bin.
;   Note: these variables will be created on the calling level.
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
; PROCEDURE:
;
; MODIFICATION HISTORY:
;   Code developed by Aaron Roberts and Scott Boardsen at GSFC.
;-

LEVEL = ROUTINE_NAMES(/LEVEL)-1 ;FORCES VARIABLES to be returned to the calling procedure or function

if keyword_set(nointerpolation) then  fill_empty_bins=0 else fill_empty_bins=1
;if n_elements(dataset_id)*n_elements(vars)*n_elements(t_init)*n_elements(t_final)*n_elements(dt_sec)*n_elements(time_name) eq 0 then begin
if n_elements(dataset_id)*n_elements(vars)*n_elements(t_init)*n_elements(t_final)*n_elements(dt_sec) eq 0 then begin
    if n_elements(dataset_id) eq 0 then print,'Variable DATASET_ID not defined.'
    if n_elements(vars) eq 0 then print,'Variable VARS not defined.'
    if n_elements(t_init) eq 0 then print,'Variable T_INIT not defined.'
    if n_elements(t_final) eq 0 then print,'Variable T_FINAL not defined.'
    if n_elements(dt_sec) eq 0 then print,'Variable DT_SEC not defined.'
    if n_elements(time_name) eq 0 then print,'Keyword variable TIME_NAME not defined.'
    print,'Returning.'
    return
endif

if n_elements(dt_sec) eq 0 then dt_sec = 0.0 ; seconds, if not set do not bin
if keyword_set(time_name) eq 0 then if keyword_set(tt2000) then time_name = 'EPOCH' else time_name = 'TIMEJD'
if keyword_set(tt2000) then cdfepochtypeout = 'CDF_TIME_TT2000'
notes = 'dataset_id=' + dataset_id + ' input vars=' +cmb_str_flatten(vars,space=', ') + 'time_name=' + time_name $
       + ' t_init='+t_init + 't_final='+ t_final + 'dt_sec=' + strtrim(string(dt_sec),2)

isodates = [t_init, t_final]
if keyword_set(tt2000) then begin
  epr = cmb_string2epr(isodates,cdfepochtypeout=cdfepochtypeout) ;start/stop times in epoch
  tbeg = epr[0]
  tend = epr[1]
  dtbin = cmb_dtbin( dt_sec, cdfepochtype=cdfepochtypeout)
endif else begin ; used Julian date
  a = cmb_isodate2cdate(t_init)  & tbeg = a.julday
  a = cmb_isodate2cdate(t_final) & tend = a.julday
  dtbin = dt_sec/(24*3600d0)
endelse
;help,tbeg,tend & stop
av = cmb_cdf2user_var(vars)

d = spdfgetdata(dataset_id, av.cdfvar, [t_init, t_final], keepfiles=keepfiles) ;
;d = spdfgetdata(endpoint='http://localhost:8084/WS/cdasr/1',dataset_id, av.cdfvar, [t_init, t_final], keepfiles=keepfiles) ;for testing 1/15/2016
if cmb_var_type(d) ne 'STRUCT' then begin
   print,'----------------------------------------------------' 
   print,'----------------------------------------------------' 
   print,'Either the dataset_id ' + dataset_id + ' is not valid, '
   print,' or '
   print,'data does not exist for the specified time range ' + t_init + ' to ' + t_final + ', '
   print,' or '
   dummy = av.cdfvar[0] & for i=1,n_elements(av.cdfvar)-1 do dummy = dummy + ' '+ av.cdfvar[i]
   print,'the requested variable names ' + dummy + ' do not match actual cdf variable names,'
   print,'or the server is down.'
   print,'Therefore no data was retrieved.'
   print,'----------------------------------------------------' 
   print,'----------------------------------------------------'
   return
endif

tnames = tag_names(d)
nvars = n_elements(av.cdfvar)

diagnostic={dtbin:dtbin,tbeg:tbeg, tend:tend}
for ii = 0, nvars-1 do begin
    print,'----------------------------------------------------' 
    ;ip= where( strpos(tnames, strupcase(av.cdfvar[ii]) ) ne -1 ) & ip=ip[0] ; bug in this line
    ip = where( tnames eq strupcase(av.cdfvar[ii]) ) & if n_elements(ip) ne 1 then stop & ip = ip[0] ;bug fixed SAB 6/5/2014
    
    if ip eq -1 then goto, skip
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
       goto,skip
    endif
    ameta =cmb_cdaw_meta( d.(ip))
    cmb_cdf_check_if_dependencies_are_time_varying,d, ip, multiple_modes=multiple_modes ;add by SAB 4/17/2014
    other_depend = cmb_cdf_get_dependencies(d, ip, /not_zero, level=level) & if other_depend[0] ne '' then other=', another dependency is ' + other_depend else other=''
    print,'CDF VARIABLE ', av.cdfvar[ii], ', now called ',av.uservar[ii],' whose independent variable is ', time_name, other
    print,'CREATED VARIABLE: ', cmb_var_label(av.uservar[ii], other_depend, time_name)
    note =  cmb_var_label(av.uservar[ii], other_depend, time_name)
;    epochnative = d.(iep).dat
    print,'Depend_0', tnames[iep]
    if dt_sec le 0 then print,'Note data is not binned in time, original time dependency of ', av.cdfvar[ii],' is ',tnames[iep]
    ;t_d = spdfcdfepoch2julday(epoch)
    
    if keyword_set( tt2000) then t_d = cmb_epoch_modify( cmb_dat(d.(iep)),cdfepochtypeout=cdfepochtypeout) $
    else t_d = cmb_epoch2jd(cmb_dat(d.(iep))) ; SAB 04/21/2016
    ;help,time_name, tt2000,t_d ;& stop
    values = d.(ip).dat
    fillflag= d.(ip).fillval
    if finite(fillflag) eq 0 then fillflag = cmb_valid_data_range(d,ip)
    ibreak = cmb_break_decision(av,ii,size(d.(ip).dat,/structure))
    if ibreak eq -1 then goto,skip    
    if (ibreak) then begin ;break matrix in components
       vname0 = cmb_var_name_components(av.uservar[ii])
       for jj = 0, av.nc[ii]-1 do begin
;	fillflag = d.(ip).fillval
	vname = vname0[jj]
	;print,vname
	if n_elements(smeta) eq 0 then smeta = create_struct(vname,ameta) else smeta = create_struct(smeta,vname,cmb_cdaw_meta(ameta))	
	value = reform(values[jj,*])

	cmb_timebin_array,t_d, value, tbeg, tend, dtbin, t_out, valueout, fillflag ,serout_flag=valueout_nbin, fill_empty_bins=fill_empty_bins, autobad=autobad, sigmul=sigmul $
	,VALIDMIN=VALIDMIN, VALIDMAX=VALIDMAX
	cmb_move_variable,time_name, t_out,vname, valueout,valueout_nbin, dt_sec,ameta, tdas=tdas, isodates = isodates, to_struct=to_struct, level=level
	;DUMMY  = ROUTINE_NAMES(vname, valueout, STORE=level) ; store at calling level
	;if dt_sec gt 0 then DUMMY  = ROUTINE_NAMES(vname+'_nbin', valueout_nbin, STORE=level) ; store at calling level
;	print,'After binning created dependent variable: ' + vname, ' whose independent variable is ', time_name, other
       endfor
    endif else begin ;don't break into componets
	vname = av.uservar[ii]
	if n_elements(smeta) eq 0 then smeta = create_struct(vname,ameta) else smeta = create_struct(smeta,vname,cmb_cdaw_meta(ameta))
	;help, t_d, values, tbeg, tend, dtbin
 	cmb_timebin_array,t_d, values, tbeg, tend, dtbin, t_out, valueout ,fillflag,serout_flag=valueout_nbin,  fill_empty_bins=fill_empty_bins, autobad=autobad, sigmul=sigmul $
	,VALIDMIN=VALIDMIN, VALIDMAX=VALIDMAX

	cmb_move_variable,time_name, t_out,vname, valueout,valueout_nbin, dt_sec,ameta, tdas=tdas, isodates = isodates, to_struct=to_struct, level=level
	;DUMMY  = ROUTINE_NAMES(vname, valueout, STORE=level) ; store at calling level
	;if dt_sec gt 0 then DUMMY  = ROUTINE_NAMES(vname+'_nbin', valueout_nbin, STORE=level) ; store at calling level
;        print,'After binning created dependent variable: ' + vname, ' whose independent variable is ', time_name,other
    endelse
    notes = [notes,note]
    skip:
    if vname ne  cmb_valid_var_name(vname) then stop
;    help, vname, cmb_valid_var_name(vname)

endfor ;ii
print,'----------------------------------------------------'
help,time_name, t_out
DUMMY  = ROUTINE_NAMES(time_name, t_out, STORE=level) ; store at calling level
print,'Created time variable ' + time_name

;set time dependent dependencies to that of the dominant instrument mode
for ii = 0, nvars-1 do begin ;add by SAB 4/17/2014
    ip= where( strpos(tnames, strupcase(av.cdfvar[ii]) ) ne -1 ) & ip=ip[0] ;add by SAB 4/17/2014
    if ip[0] ne -1 then cmb_cdf_check_if_dependencies_are_time_varying,d, ip,/set_depend_to_dominant_mode ;add by SAB 4/17/2014
endfor ;add by SAB 4/17/2014

dummy = CMB_CDF_GET_DEPENDENCIES(d,/write,/not_zero,smeta=smeta, level=level, to_struct=to_struct) ;write other independent variable to calling level

cmb_update_top_level_variable, 'cmbnotes', notes, to_struct=to_struct
cmb_update_meta_data, 'cmbmeta',cmb_valid_var_name(ameta.logical_source),smeta, to_struct=to_struct, level=level
;varmeta = cmb_valid_var_name('META_'+ameta.logical_source)
;DUMMY  = ROUTINE_NAMES(varmeta, smeta, STORE=level) ; store at calling level
;print,'Created meta data structure ' + varmeta
print,'Placed meta data in structure "cmbmeta" in calling level'
if keyword_set(keepfiles) and keyword_set(move_cdf_files_to_directory) then  FILE_MOVE, ['*.cdf'], move_cdf_files_to_directory
end
