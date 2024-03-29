;+
; Please note this routine is still in development
;CDF2TPLOT ,files,varnames=varnames,all=all
;
; record=record if only one record and not full cdf-file is requested
;
;load_labels=load_labels ;copy labels from labl_ptr_1 in attributes into dlimits
;         resolve labels implemented as keyword to preserve backwards compatibility
;
;
; $LastChangedBy: pcruce $
; $LastChangedDate: 2014-02-28 16:39:25 -0800 (Fri, 28 Feb 2014) $
; $LastChangedRevision: 14473 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/trunk/general/CDF/cdf2tplot.pro $
;-

pro cdf2tplot_qm,files=files,prefix=prefix,midfix=midfix,midpos=midpos,suffix=suffix ,newname=newname $
   ,varformat=varformat ,varnames=varnames2 $
   ,all=all,verbose=verbose, get_support_data=get_support_data, convert_int1_to_int2=convert_int1_to_int2 $
   ,record=record, tplotnames=tplotnames,load_labels=load_labels


dprint,dlevel=4,verbose=verbose,'$Id: cdf2tplot.pro 14473 2014-03-01 00:39:25Z pcruce $'
vb = keyword_set(verbose) ? verbose : 0

; Load data from file(s)
dprint,dlevel=5,verbose=verbose,'Starting CDF file load'

if not keyword_set(varformat) then var_type = 'data'
if keyword_set(get_support_data) then var_type = ['data','support_data']
cdfi = cdf_load_vars(files,varformat=varformat,var_type=var_type,/spdf_depend, $
     varnames=varnames2,verbose=verbose,record=record, convert_int1_to_int2=convert_int1_to_int2)

dprint,dlevel=5,verbose=verbose,'Starting load into tplot'
;  Insert into tplot format
cdf_info_to_tplot_qm,cdfi,varnames2,all=all,prefix=prefix,midfix=midfix,midpos=midpos,suffix=suffix,newname=newname, $  ;bpif keyword_set(all) eq 0
       verbose=verbose,  tplotnames=tplotnames,load_labels=load_labels


dprint,dlevel=5,verbose=verbose,'Starting Clean up' ;bpif keyword_set(all) eq 0
tplot_ptrs = ptr_extract(tnames(/dataquant))
unused_ptrs = ptr_extract(cdfi,except=tplot_ptrs)
ptr_free,unused_ptrs

end



