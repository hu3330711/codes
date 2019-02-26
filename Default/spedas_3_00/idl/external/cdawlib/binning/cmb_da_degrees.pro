;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_da_degrees,a,b
;return minimun angle between a and b, both in degrees
d = a-b
ii=where(abs(d) gt 180. and d lt 0.)
if ii[0] ne -1 then d[ii] = d[ii] + 360.
ii=where(abs(d) gt 180. and d gt 0.)
if ii[0] ne -1 then d[ii] = d[ii] - 360.
return,d
end
