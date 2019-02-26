;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

pro cmb_save_scales_2,ascale, irestore=irestore
if keyword_set(irestore) then begin
   !x = ascale.x
   !y = ascale.y
   !p = ascale.p
endif else begin
   ascale = {x: !x, y: !y, p: !p }
endelse
end
