;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_cdf_epoch_compare, epoch0, baseepoch0, endepoch0
; Returns: A scalar or array of integers of 
;    1 :  if epoch1 > baseepoch
;    0 :  if epoch1 = baseepoch
;   -1 :  if epoch1 < baseepoch
; 
; Calling the function with three arguments: It returns a scalar value or an
; array values of integer of 1 or 0.
; 
; If the value of the source epoch falls within the starting and ending epoch
; 1 is set. Otherwise, 0 is set.
; 
; Returns: A scalar or array of integers of
;    1 :  if baseepoch <= epoch1 <= endepoch
;    0 :  otherwise

epoch = cmb_epoch_modify( epoch0)
baseepoch = cmb_epoch_modify( baseepoch0)

n=n_elements(epoch)
if n gt 1 then ii = intarr(n) else ii=0

case n_params() of
2:begin
    i=where( epoch gt baseepoch)
    if i[0] ne -1 then ii[i] = 1
    i=where( epoch lt baseepoch)
    if i[0] ne -1 then ii[i] = -1
  end
3:begin
  endepoch = cmb_epoch_modify( endepoch0)
  i = where( epoch ge baseepoch and epoch le endepoch)
  if i[0] ne -1 then ii[i] = 1
  end
endcase
return,ii
end
