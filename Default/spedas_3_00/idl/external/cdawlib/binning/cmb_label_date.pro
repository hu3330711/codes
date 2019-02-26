;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
; .compile cmb_label_date

function cmb_label_pos_label_idlgraphics,p0, charsize=charsize
; INPUT  p0 = plot(....)
; t0 = cmb_label_pos_label_idlgraphics(p0, charsize=charsize)
common cmb_label_date,a
if n_elements(charsize) eq 0 then charsize=1
if cmb_var_type(a) ne 'STRUCT' then return,0
if cmb_tag_name_exists('labels',a) eq 0 then return,0
alab = a.labels
ns = n_elements(alab)
m = max(strlen(alab)) + 1
for i=0,ns-1 do alab[i] = alab[i] + cmb_stringpad(m- strlen(alab[i])) + cmb_stringpad(m/4)
lab = '' 
for i=0,ns-1 do lab = lab + alab[i] + '!c'
x0 = p0.position[0]
y0 = p0.position[1]
help, x0, y0, lab
t0 = text( x0*0.75, y0, lab, /norm, align=1, VERTICAL_ALIGNMENT=1 )
return,t0
end

pro cmb_label_pos_label,charsize=charsize
; old idl graphics
common cmb_label_date,a
if n_elements(charsize) eq 0 then charsize=1
if cmb_var_type(a) ne 'STRUCT' then return
if cmb_tag_name_exists('labels',a) eq 0 then return
alab = a.labels
ns = n_elements(alab)
m = max(strlen(alab)) + 1
for i=0,ns-1 do alab[i] = alab[i] + cmb_stringpad(m- strlen(alab[i])) + cmb_stringpad(m/4)
lab = '  !c !c' 
for i=0,ns-1 do lab = lab + alab[i] + '!c'

dx = !x.window[1] -!x.window[0]
dy = !y.window[1] -!y.window[0]

x0 = !x.window[0];-dx/40.
y0 = !y.window[0]
xyouts,x0,y0,lab,charsize=charsize,/normal,align=1
end

function cmb_label_pos, time
common cmb_label_date,a
n = n_tags(a)
if n eq 1 then return,''
format='(f7.2)'
for i=1,n-2 do begin
    x = string( interpol(a.(i), a.(0), time),format=format)
    if n_elements(spos) eq 0  then spos = x else spos = spos + '!c' + x
endfor
;help,spos
return,spos
end

function cmb_date_format,Julian,format=format
CALDAT, Julian, Month, Dom, Yr, Hr, Minu, Sec
msec = 1000.*( Sec - floor(Sec))
sec = floor(sec)
;help, format
case format of
 'isodate': $
      date = string( format= '(i4.4,"-", i2.2,"-",i2.2,"T",i2.2,":",i2.2,":",i2.2,".",i3.3,"Z")' , yr, month, dom, hr,min,sec, msec)
 'hh': $
      date = string( format= '(i2.2)' ,  hr)
 'hh:mm': $
      date = string( format= '(i2.2,":",i2.2)' ,  hr,minu)
 'hhmm': $
      date = string( format= '(i2.2,i2.2)' ,  hr,minu)
 'hh:mm:ss':date = string( hr,minu,round(sec+msec/1000.) $ 
		,format= '(I2.2,":",I2.2,":",I2.2)' )
 'hh:mm:ss.sss': $
      date = string( format= '(i2.2,":",i2.2,":",i2.2,".",i3.3)' , hr,minu,sec, msec)

 else:date = string( $
               format= '(i4,x,i2.2,"/",i2.2," ",i2.2,":",i2.2)' $
               ,yr,dom,month,hr,minu)
endcase
return,date
end

function cmb_label_date, axisin, indexin, valuein, levelin, $
	am_pm = am_pm, $
	date_format = dateformat, $
	days_of_week = days_of_week, $
	months = months, $
	offset = offs, $
	round_up = round_up, $
	xaxis_info = a0, $
	addxaxisunits = addxaxisunits
; sdate = cmb_label_date(axisin, indexin,xr[0])
; a={time:time, r:r, mlat:mlat, mlt:mlt, labels:['hh:mm:ss','r(re)','l-shell','mlat(!uo!n)','mlt(hours)']
common cmb_label_date,a
if keyword_set(a0)then begin
   a =a0
   return, 1
endif

if keyword_set( addxaxisunits ) then return, cmb_label_pos_label_idlgraphics(addxaxisunits)

dateformat =  strtrim( a.labels[0],2)
date =cmb_date_format(valuein,format=dateformat)
if n_elements(a) ne '' then date = date + ' !c' + cmb_label_pos(valuein)
;help,date      
return,date
end
