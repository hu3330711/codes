;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_jdattime2isodattime, jday, idattime
caldat,jday,mo,day,yr,hr,min,sec
if (sec lt 1.e-4) then sec = 0.0
if (mo lt 10) then mo_str = string('0'+strcompress(string(mo),/remove_all)) else mo_str = strcompress(string(mo),/remove_all)
if (day lt 10) then day_str = string('0'+strcompress(string(day),/remove_all)) else day_str = strcompress(string(day),/remove_all)
if (hr lt 10) then hr_str = string('0'+strcompress(string(hr),/remove_all)) else hr_str = strcompress(string(hr),/remove_all)
if (min lt 10) then min_str = string('0'+strcompress(string(min),/remove_all)) else min_str = strcompress(string(min),/remove_all)
if (sec lt 10) then sec_str = string('0'+strcompress(string(sec),/remove_all)) else sec_str = strcompress(string(sec),/remove_all)

idattime = strcompress(string(yr)+'-'+mo_str+'-'+day_str+'T'+hr_str+':'+min_str+':'+sec_str+'Z',/remove_all)  ;String initial time for getdata

end
