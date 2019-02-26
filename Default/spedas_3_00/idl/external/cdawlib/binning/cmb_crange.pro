;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_crange,xaxis=xaxis,yaxis=yaxis

if n_elements(xaxis) eq 0 and n_elements(yaxis) eq 0 then begin
   xaxis=1
   yaxis=0
endif
if keyword_set(xaxis) then yaxis=0
if keyword_set(yaxis) then xaxis=0

if xaxis eq 1 then begin
   r = !x.crange
   type = !x.type 
endif else begin
   r = !y.crange
   type = !y.type
endelse

if type eq 1 then return,10^r
return,r
end
