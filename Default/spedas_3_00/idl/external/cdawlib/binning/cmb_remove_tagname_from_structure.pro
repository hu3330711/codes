function cmb_remove_tagname_from_structure, s, tagname
; s0 = cmb_remove_tagname_from_structure( s, tagname)
tnames = tag_names(s)
ir = where( strlowcase(tagname) eq strlowcase(tnames)) & ir=ir[0]
for itag=0,n_tags(s)-1 do begin
   if itag ne ir then begin
      if n_elements(s0) eq 0 then s0 = create_struct(tnames[itag], s.(itag)) $ 
      else s0 = create_struct(s0, tnames[itag], s.(itag))
   endif
endfor
return,s0
end

