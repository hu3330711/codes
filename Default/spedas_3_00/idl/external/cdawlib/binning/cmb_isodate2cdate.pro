;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_isodate2cdate, isodate, yr, mo, day, hr, min, sec
;example of isodate is  isodate='2007-01-10T02:00:00.0Z'
; dattim = strsplit(isodate,'T',/extract)
; yrmoda = strsplit(dattim(0),'-',/extract)
; yr = long(yrmoda(0))
; mo = long(yrmoda(1))
; day = long(yrmoda(2))
; hrminsec = strsplit(dattim(1),' ,/,:TZ-',/extract)
; hr = long(hrminsec(0))
; min = long(hrminsec(1))
; sec = float(hrminsec(2))
    a = strsplit(/ext,isodate,' ,/,:TZ-')
    yr = long(a[0])
    month = long(a[1])
    dom = long(a[2])
    hr = long(a[3])
    minu = long(a[4])
    sec = double(a[5])
    isec = floor(sec)
    msec = 1000*(sec-isec)
;    help,yr,month, dom,hr,minu,sec,isec,msec
    cdate ={year:yr, month:month, dom:dom, hour:hr, min:minu, sec:sec, msec:msec}
    jday = julday(month,dom,yr,hr,minu,sec)
    cdf_epoch,epoch, yr,month,dom, hr,minu,sec,/comp 
;Result = CDF_PARSE_EPOCH(Epoch_string) 
;Result = CDF_PARSE_EPOCH16(Epoch_string)
;Result = CDF_PARSE_TT2000(Epoch_string)
return,{epoch:epoch,julday:jday, cdate:cdate}
end
