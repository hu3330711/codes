;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_total,x0,dimensions,fill=fill, average=average, maximum=maximum, median0 = median0
;
; dimensions -[a,b] dimensions of x0[1,2,...] to remove 
dimensions = dimensions[sort(dimensions)]
x=x0
if keyword_set(fill) then begin
   ii=where( x eq fill)
   if ii[0] ne -1 then x[ii]=fill
endif
for idim = 0, n_elements(dimensions)-1 do  x = total(x, dimensions(idim)-idim)

if keyword_set(average) then begin
   si = size(x0,/str)
   nave =1.0
   for i=0,n_elements(dimensions)-1 do nave = nave*si.dimensions[dimensions[i]-1]
   x = x/nave
   ;note must be modified if fill set
endif

return,x
end
