;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_tag_name_exists, tag_name,  s,i0
; istat = cmb_tag_name_exists(tag_name, s, i0)
; i0 is the local of the tag_name is s    i.e. s.(i0)
;determine if structure 's' contains tag name 'tag_name'
if cmb_var_type(s) ne 'STRUCT' then return,0
 name = strlowcase(tag_name)
 names = strlowcase(tag_names(s))
 i0 =(where( name eq names) )(0)
if i0 ne -1 then return,1
return,0
end
