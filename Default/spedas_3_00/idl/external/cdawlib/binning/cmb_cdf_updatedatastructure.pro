
pro cmb_add_nbin2datastructure,d,itag, d0, varname
; add  varname + '_NBIN' to data structure d
varname0 = varname + '_NBIN'
i0=strpos( strlowcase(tag_names(d0)), strlowcase(varname0) ) & i0=where(i0 ne -1) & i0=i0[0]
i1=strpos( strlowcase(tag_names(d)), strlowcase(varname) ) & i1=where(i1 ne -1) & i1=i1[0]
if i0 le 0 then return ;i0=0 is depend_0, i0=-1 not found so return without doing anything
;help,d.(i1),itag, d0.(i0),varname0, varname

meta = cmb_cdf_extract_metadata( d, i1)
if cmb_tag_name_exists('VARNAME',meta) then meta.varname = varname0
if cmb_tag_name_exists('UNITS',meta) then meta.UNITS = 'CNTS'
if cmb_tag_name_exists('VALIDMIN',meta) then meta.VALIDMIN = 0
if cmb_tag_name_exists('VALIDMAX',meta) then meta.VALIDMAX = max(d0.(i0))
if cmb_tag_name_exists('FIELDNAM',meta) then meta.FIELDNAM = meta.FIELDNAM + '_NBIN'
if cmb_tag_name_exists('catdesc',meta) then meta.catdesc = 'Time Binning of ' +  meta.FIELDNAM
if cmb_tag_name_exists('LABLAXIS',meta) then $
  if meta.LABLAXIS[0] ne '' then meta.LABLAXIS = '# of '+ meta.LABLAXIS

if cmb_tag_name_exists('LABL_PTR_1',meta) then $
  if meta.LABL_PTR_1[0] ne '' then meta.LABL_PTR_1 = '# of '+ meta.LABL_PTR_1

if cmb_tag_name_exists('LABL_PTR_2',meta) then $
  if meta.LABL_PTR_1[0] ne '' then meta.LABL_PTR_2 = '# of '+ meta.LABL_PTR_2
  
if cmb_tag_name_exists('LABL_PTR_3',meta) then $
  if meta.LABL_PTR_1[0] ne '' then meta.LABL_PTR_3 = '# of '+ meta.LABL_PTR_3


;if cmb_tag_name_exists('LABL_PTR_1',meta) then $
;  if meta.LABL_PTR_1[0] ne '' then string_list, ['LABL_PTR',meta.LABL_PTR_1]

handle = handle_create(value = d0.(i0))
a = create_struct(meta, 'HANDLE',handle_create(value = d0.(i0)))
d = create_struct(d,varname0, a)
end

;pro cmb_update_depend2datastructure,d, d0
;tnames = tag_names(d0)
;ii=strpos(tnames,'_DEPEND') & ii=where(ii ge 0)
;if ii[0] eq -1 then return
;for i=0,n_elements(ii)-1 do begin
;   varname0 = tnames[ii[i]]
;   varname = strmid( varname0,0, strpos( varname0,'_DEPEND'))
;   print,'******** UPDATING DEPENDENCIES *********'
;   print,varname,' ', varname0   
;   i0=strpos( strlowcase(tag_names(d0)), strlowcase(varname0) ) & i0=where(i0 ne -1) & i0=i0[0]
;   i1=strpos( strlowcase(tag_names(d)), strlowcase(varname) ) & i1=where(i1 ne -1) & i1=i1[0]
;   ;if handle_info(d.(i0).handle) then handle_free, d.(i1).handle
;   d.(i1).handle = handle_create(value = d0.(i0))
;endfor
;end

pro cmb_cdf_updatedatastructure,d,d0
;assume .handle instead of .dat
tnames = tag_names(d0)
ip = strpos( tnames, '_DEPEND')
iq = strpos( tnames, '_NBIN')
ip = where( ip eq -1 and iq eq -1) ; list of variables binned
tnames = tnames[ip]
tnames = tnames[1:n_elements(tnames)-2]
for itag=0,n_elements(tnames)-1 do begin
    if cmb_tag_name_exists(tnames[itag], d, i0) then begin
       ;if handle_info(d.(i0).handle) then handle_free, d.(i0).handle
       if cmb_tag_name_exists('handle',  d.(i0)) eq 0 then BEGIN
          print,'handle expected, stopping code'
       endif
       dummy = cmb_tag_name_exists(tnames[itag], d0, jtag)
       d.(i0).handle = handle_create(value = d0.(jtag))
       help, d.(i0).varname, cmb_dat(d.(i0) )
       cmb_modify_if_needed_depends_names,d,i0,d0
       cmb_add_nbin2datastructure, d,itag, d0, tnames[itag]
    endif
endfor
;cmb_update_depend2datastructure,d, d0 ;superceeded by cmb_modify_if_needed_depends_names
d = cmb_updatestructwith_epoch_bin(d,d0)  ;add epoch_nbin to structure
cmb_cdf_add_attribute,d, tnames, 'time_bin_width_sec', d0.aux.TIME_BIN_WIDTH_SEC
end