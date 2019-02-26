pro cmb_cdf_list_dependencies,d

tnames = tag_names(d)

for itag=0,n_tags(d)-1 do begin
    a = d.(itag)
    if a.var_type eq 'data' then begin
    var = a.varname
    depend0 ='' & if cmb_tag_name_exists('depend_0',a) then depend0 = a.depend_0
    print, var,' ',depend0
    endif
endfor

end