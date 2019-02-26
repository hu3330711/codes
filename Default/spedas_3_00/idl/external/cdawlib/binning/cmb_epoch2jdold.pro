;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_epoch2jdold,t,inverse=inverse,jd_to_epoch=jd_to_epoch,j2000=j2000
;NOTE this routine requires modification when the time range straddles a leap second if epoch is CDF_TIME_TT2000 long64.
;given epoch 't' compute jd
;if inverse set then compute epoch given jd 't'
if keyword_set(jd_to_epoch) then inverse = 1
common sv_epjd,jd0,ep0
if n_elements(inverse) eq 0 then inverse = 0
if n_elements(ep0) eq 0 then begin ;ep0 is the nssdc at J2000
   year = 2000
   month = 1
   dom = 1
   hr = 12
   cdf_epoch,ep0,year,month,dom,hr,/comp
   jd0 = julday(month,dom,year)
   ;print,pdate(ep0)
   ;print,'julian date:',jd0
endif
offset = 0d0
if keyword_set(j2000) then offset = jd0
;help,offset
if inverse eq 0 then begin
   ;jd = jd0 + (epoch-ep0)/(24*3600d3)
   return, jd0 + (cmb_epoch_modify(t)-ep0)/(24*3600d3) -offset
endif else begin
   ;epoch = ep0 + (jd-jd0)*(24*3600d3)
   return, ep0 + (t+offset-jd0)*(24*3600d3)
endelse
end
