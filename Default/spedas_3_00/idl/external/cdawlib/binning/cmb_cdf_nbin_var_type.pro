pro cmb_cdf_nbin_var_type,d
; change var_types of all varnames containing '_NBIN' to support_data; VAR_TYPE        STRING    'support_data'
tnames = tag_names(d)
ii = strpos(tnames,'_NBIN') & ii=where(ii ge 0)
if ii[0] eq -1 then return
ni = n_elements(ii)
;for i=0,ni-1 do print,d.(ii[i]).varname,' ', d.(ii[i]).var_type
for i=0,ni-1 do d.(ii[i]).var_type='support_data'
end