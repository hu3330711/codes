;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_jd2unix, timein, inverse=inverse
;convert from double precision julian day (most common definition) to unix time
tunix0 = 0d0 ;unix time is zero at GMT of 1970 01/01 00:00:00.000
cdf_epoch,epunix0, 1970,1,1,/comp
;print,time_string(tunix0,tformat='YYYY-MM-DD/hh:mm:ss.fff')
;print,datesab(epunix0,cdate=cdate,format='yyyy ddd (mm/dd) hh:mm:ss.sss')

if keyword_set(inverse) then begin
   ;convert from unix time to Julian day
   jd = cmb_epoch2jd(epunix0 + timein*1d3)   
   return,jd
endif else begin
  ;convert from Julian day to unix time
  timeunix = (cmb_epoch2jd(timein, /inverse)-epunix0)/1d3
  return, timeunix
endelse
end
