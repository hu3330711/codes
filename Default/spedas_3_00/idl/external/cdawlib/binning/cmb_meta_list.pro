;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

pro cmb_var_i, a
tnames = tag_names(a)
for i=0,n_elements(tnames)-1 do begin
    print,'     ***********************'
    print,'     ',tnames[i]
    b = a.(i)
    c = '        '
    print,c,'fieldnam:', b.FIELDNAM
    if cmb_tag_name_exists('depend_0',b) then $
       if b.depend_0 ne '' then print,c,'time dependency:', b.depend_0
    if cmb_tag_name_exists('depend_1',b) then $
       if b.depend_1 ne '' then  print,c,'depend_1:',b.depend_1
    if cmb_tag_name_exists('depend_2',b) then $
       if b.depend_2 ne '' then print,c,'depend_2:',b.depend_2
    if cmb_tag_name_exists('depend_3',b) then $
       if b.depend_3 ne '' then print,c,'depend_3:',b.depend_3
    print,c,'catdesc       :', b.catdesc
    print,c,'var_notes     :', b.var_notes
    print,c,'units     :', b.units
endfor

end

pro cmb_meta_list,cmbmeta

tnames = tag_names(cmbmeta)
for i=0,n_elements(tnames)-1 do begin
    print,'***********************'
    print,tnames[i]
    cmb_var_i, cmbmeta.(i)
endfor

end
