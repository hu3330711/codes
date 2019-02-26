;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_file_exists,file
if n_elements(file) eq 0 then return,0
if file[0] eq '' then return,0
n = n_elements(file)
if n eq 1 then return, (file_test(file_search(file)))(0)
istat = intarr(n)
for i=0,n-1 do istat[i] =  file_test(file_search(file[i]))
return, istat
end
