function cmb_cdf_var_type,d
; var_type = cmb_cdf_var_type(d)
tnames = tag_names(d)
var_type = strarr(n_elements(tnames))
for itag=0,n_elements(tnames)-1 do begin
    if cmb_tag_name_exists('var_type',d.(itag)) then $
    var_type[itag] = d.(itag).var_type
endfor
return, var_type
end
