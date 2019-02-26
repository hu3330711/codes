
;  cmb_cdf_struct_tools

pro cmb_cdf_struct_addtagname,d,tagname0,tagname1,values1
; cmb_cdf_struct_addtagname,d,'de1','time_bin_width_sec',dt_sec
istat = cmb_tag_name_exists(tagname0, d, i0)
a = d.(i0)
if cmb_tag_name_exists(tagname1, a, i1) then begin
   a.(i1) = values1
endif else begin
   a = create_struct( a, tagname1,values1)
endelse

tagnames = tag_names(d)
if i0 eq 0 then d0 = create_struct( tagnames[0],a ) $
else d0 = create_struct( tagnames[0],d.(0) )

for itag=1l, n_tags(d)-1 do $
    if i0 eq itag then d0 = create_struct(d0, tagnames[itag],a ) $
    else d0 = create_struct(d0, tagnames[itag],d.(0) )
    d=d0
end


pro cmb_cdf_struct_deletetagname,d,tagname0
; cmb_cdf_struct_deletetagname,d,'epoch'
istat = cmb_tag_name_exists(tagname0, d, i0)
if istat eq 0 then return
tagnames = tag_names(d)
for itag=0l, n_tags(d)-1 do begin
    if i0 eq itag then begin
       ;do nothing
    endif else begin
      if n_elements(d0) ne 0 then $
      d0 = create_struct(d0, tagnames[itag],d.(0) ) $
      else d0 = create_struct( tagnames[itag],d.(0) )
    endelse
endfor
d=d0
end



pro cmb_cdf_struct_tools,d, tagname0,tagname1,values1, option=option
;option = ['addtagname','deletetagname']
;examples
; cmb_cdf_struct_tools,d,'de1','time_bin_width_sec',dt_sec,option='addtagname'
; cmb_cdf_struct_tools,d,'epoch','time_bin_width_sec',dt_sec,option='deletetagname'

case option of
 'addtagname':cmb_cdf_struct_addtagname,d,tagname0,tagname1,values1
 'deletetagname':cmb_cdf_struct_deletetagname,d,tagname0
endcase
end