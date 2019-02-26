;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_date,epochsin,cdate=cdate,format=format0,todms = todms,time_in_julday = time_in_julday
;written and modified 9/03/2007 by Scott Boardsen UMBC/GEST at GSFC
;format='yyyy ddd (mm/dd) hh:mm:ss'
epochs = cmb_epoch_modify(epochsin)
if cmb_var_type(epochs) ne 'DOUBLE' then return, fix(epochs)
if n_elements(format0) ne 0 then format=format0
if n_elements(todms) ne 0 then epochs = cmb_epoch0(2000,1,0d0) + todms
if n_elements(epochs) eq 0 then begin
   print,'datesab:date=datesab(epoch, cdate=cdate, format=format)'
   print,'format'
   list = ['yyyy ddd hh mm','yy/ddd/hh:mm','yyyy ddd hh:mm:ss']
   for i=0,n_elements(list)-1 do print,list[i]
   return,1
endif
smons=(['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'])
smon1s=(['January','Febuary','March','April','May','June','July','August','September','October','November','December'])
n = n_elements(epochs)
if n ne 1 then dates = strarr(n) else dates=''
for ik =0l,n-1 do begin
    epoch = epochs[ik] 
    if keyword_set(time_in_julday) then epoch = cmb_epoch2jd(epoch,/inverse)
    cdf_epoch,epoch,yr,month,dom,hr,minu,sec,msec,/break
    cmb_ical,yr,doy,month,dom,/idoy ;compute doy
    tod_fracday = (hr*3600d0 + minu*60d0 + sec + msec/1000d0 )/(24*3600d0)
    if n_elements(format) eq 0 then format='yrdoyhrmin'
    yroff = 1900
    if yr ge 2000 then yroff = 2000
    cdate={yr:yr,doy:doy,month:month,dom:dom,hr:hr,min:minu,sec:sec,msec:msec, yroff:yroff}

case (format) of
 'spice':begin
      formata = '(i4.4,"-", i3.3," // ",i2.2,":",i2.2,":",i2.2,".",i3.3)' 
      date = string( format= formata , yr, doy, hr,minu,sec, msec)
      end
 'isodate' or 'zulu' or 'yyyy-mm-ddThh:mm:ss.sssZ': $
      date = string( format= '(i4.4,"-", i2.2,"-",i2.2,"T",i2.2,":",i2.2,":",i2.2,".",i3.3,"Z")' , yr, month, dom, hr,minu,sec, msec)
 'isodate2': $
      date = string( format= '(i4.4, i2.2,i2.2,"T",i2.2,i2.2,i2.2,i3.3,"Z")' , yr, month, dom, hr,minu,sec, msec)
  'yyyy-mm-ddThh:mm:ss.sss': $
      date = string( format= '(i4.4,"-", i2.2,"-",i2.2,"T",i2.2,":",i2.2,":",i2.2,".",i3.3)' , yr, month, dom, hr,minu,sec, msec)     
 'isodate1' or 'Zulu' or 'yyyy-mm-ddThh:mm:ss.sZ': $
      date = string( format= '(i4.4,"-", i2.2,"-",i2.2,"T",i2.2,":",i2.2,":",i2.2,".",i1.1,"Z")' , yr, month, dom, hr,minu,sec, msec/100)
 'a': $
      date = string( format= '(i4,i4,3i3)' , yr, doy, hr,minu,sec)
 'all': $
      date = string(  $
      format= '(i2.2,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",i2.2," UT")'  $
      , yr-yroff,doy,month,dom,hr,minu)
 'cdf':date = string( yr,month,dom,hr,minu,sec $
              ,format= '(i4,"/",i2.2,"/",i2.2,x,i2.2,":",i2.2,":",i2.2)' )
 'pg':date = string( yr,doy,hr,minu $ 
		,format= '(i4.4," Y ",i3.3," D ",i2.2,":",i2.2 )' )
 'plan': $
      date = string( format= '(i4,5i3)' , yr, month,dom, hr,minu,sec)
 'plan1': $
      date = string( format= '(i2.2,i3.3,x,i2.2,":",i2.2)',yr-yroff,doy,hr,minu)
 'plan2': $
      date = string( format= '(i3.3,":",i2.2,":",i2.2,":",i2.2)',doy,hr,minu,sec)
 'rql': $
      date = string( format= '(i3.3,":",2(i2.2,":"),i2.2)' ,  doy, hr,minu,sec)
 'ssc':date = string( yr,doy,hr,minu $ 
		,format= '(i4.4,x,i3,2(x,i2.2) )' )
 'sscingest': $
      date = string( format= '(i2.2,"-",i2.2,"-",i4.4,x,i2.2,":",i2.2,":",f6.3)' , dom, month,yr, hr,minu,sec)


 'ddd/yymmdd': $
      date = string( format= '(i3.3,"/",i2.2,i2.2,i2.2)' ,doy, yr-yroff,month,dom)
 'ddd mm/dd yyyy':date = string( doy,month,dom,yr $
                ,format= '(i3.3,x,i2.2,"/",i2.2,x,i4)' )

 'doy': $
      date = string( format= '(i3.3)' , doy)
 'doy.dd':date=string(doy + tod_fracday, format='(f6.2)')
 'ddd.dd':date=string(doy + tod_fracday, format='(f6.2)')
 'dom': $
      date = string( format= '(i3.3)' , dom)
 'doydom': $
      date = string( $
    	   format= '(i4,x,i3.3," (",i2.2,"/",i2.2,") ", i2.2,":",i2.2," UT")' $
		, yr, doy,month,dom, hr,minu) 

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
 'hh HRS UTC MMM dd, yyyy': $
      date = string( format= '(i2," HRS UTC ", a3,x,i2.2,",",x,i4.4)' ,hr,  smons[month-1], dom, yr )
'MMM dd, yyyy': $
      date = string( format= '(a3,x,i2.2,",",x,i4.4)',  smons[month-1], dom, yr )
 'mm:ss': $
      date = string( format= '(i2.2,":",i2.2)' , minu,round(sec +msec/1000.))
 'mm:ss.sss': $
      date = string( format= '(i2.2,":",i2.2,".",i3.3)' , minu,sec, msec)
 'mm:ss.ss': $
      date = string( format= '(i2.2,":",i2.2,".",i2.2)' , minu,sec, round(msec/10.))
 'mm:ss.s': $
      date = string( format= '(i2.2,":",i2.2,".",i1.1)' , minu,sec, round(msec/100.))
  'ss.sss': $
      date = string( format= '(i2.2,".",i3.3)' , sec, msec)     
 'mm dd yyyy hh mm ss': $
      date = string( format= '(i2.2,x,i2.2,x,i4.4," ",i2.2,":",i2.2,":",i2.2)' , month,dom,yr, hr,minu,sec)
 'mm/dd/yy':date = string( month,dom,yr-yroff, $
               format= '(i2.2,"/",i2.2,"/",i2.2)')    
 'mm/dd/yyyy':date = string( month,dom,yr, $
               format= '(i2.2,"/",i2.2,"/",i4)')    

 'mmddhhmm':date = string( month,dom,hr,minu,  $ 
               format= '(4i2.2)' )
 'MMM dd, yyyy': $
      date = string( format= '(x, a3,x,i2.2,",",x,i4.4)' ,  smons[month-1], dom, yr )
 'MONTH dd, yyyy': $
      date = string( format= '(x, a,x,i2.2,",",x,i4.4)' ,  smon1s[month-1], dom, yr )
 'dd MONTH yyyy': $
      date = string( format= '(x, a,x,i2.2," ",x,i4.4)' ,  smon1s[month-1], dom, yr )
 'MONTH': $
      date = string( format= '(a)' ,  smons[month-1])

 'yy': $
      date = string( format= '(i2.2)' , yr-yroff)
 'yy-dd.ddd': $
      date = string( format= '(i2.2,"-",i3.3,".",i3.3)' , yr-yroff, doy,tod_fracday*1000)
 'yy ddd hh:mm': $
      date = string( format= '(i2.2," ",i3.3," ",i2.2,":",i2.2)' , yr-yroff, doy, hr,minu)
 'yydddhhmm': $
      date = string( format= '(i2.2,i3.3,2i2.2)' , yr-yroff, doy, hr,minu)
 'yy/ddd/hh:mm': $
      date = string( format= '(i2.2,"/",i3.3,"/",i2.2,":",i2.2)' , yr-yroff, doy, hr,minu)
 'yymmdd':date = string( yr-yroff,month,dom, $
               format= '(i2.2,i2.2,i2.2)')
 'yymmddhh':date = string( yr-yroff,month,dom,hr, $
               format= '(i2.2,i2.2,i2.2,i2.2)')
 'yymmddhhmm':date = string( yr-yroff,month,dom,hr,minu, $
               format= '(i2.2,i2.2,i2.2,i2.2,i2.2)')
 'yymmddhhmmss':date = string( yr-yroff,month,dom,hr,minu,sec, $
               format= '(i2.2,i2.2,i2.2,i2.2,i2.2,i2.2)')
 'yydddhh':date = string( yr-yroff,doy,hr $ 
		,format= '(i2.2,i3.3,i2.2)' )
 'yydddhhmmss':date = string( yr-yroff,doy,hr,minu,sec $ 
		,format= '(i2.2,i3.3,3(i2.2))' )
 'yydddhhmm ss.sss':date = string( yr-yroff,doy,hr,minu,sec+msec/1000. $ 
		,format= '(i2.2,i3.3,2(i2.2),f7.2)' )
 'yydddhhmmss.sss':date = string( yr-yroff,doy,hr,minu,sec,msec $ 
		,format= '(i2.2,i3.3,3(i2.2),".",i3.3)' )
 'yydddhhmm':date = string( yr-yroff,doy,hr,minu $ 
		,format= '(i2.2,i3.3,2(i2.2) )' )
 'yyyy/mm/dd hh:mm:ss.sss':date = string(yr, month, dom, hr,minu,sec,msec $
                ,format= '(i4.4,"/",i2.2,"/",i2.2,"/",x,i2.2,":",i2.2,":",i2.2,".",i3.3)')
 'yyyy': $
      date = string( format= '(i4)' , yr) 
 'yyyyddd': $
      date = string( format= '(i4,i3.3)' , yr, doy) 
 'yyddd.fraction': $
      date = string( format= '(i2.2,i3.3,".",i8.8)' , yr-yroff, doy, tod_fracday*1d8) 
 'yyyy_ddd': $
      date = string( format= '(i4,"_",i3.3)' , yr, doy) 
 'yyyydddhh': $
      date = string( format= '(i4,i3.3,i2.2)' , yr, doy, hr) 
 'yyyydddhhmm': $
      date = string( format= '(i4,i3.3,2i2.2)' , yr, doy, hr, minu) 
 'yyyy ddd': $
      date = string( format= '(i4,x,i3.3)' , yr, doy) 
 'yyyy ddd hh': $
      date = string( format= '(i4,x,i3.3,x,i2.2)' , yr, doy, hr) 
 'yyyy ddd hh mm': $
      date = string( format= '(i4,x,i3.3,x,i2.2,x,i2.2)' , yr, doy, hr, minu) 
 'yyyy ddd hh.hhh': $
      date = string( format= '(i4,x,i3.3,x,f8.5)' , yr, doy, tod_fracday*24d0) 
 'yyyy ddd hh mm ss': $
      date = string( format= '(i4,x,i3.3,x,i2.2,2(x,i2.2))' , yr, doy, hr, minu, sec) 
 'yyyy ddd hh:mm': $
      date = string( format= '(i4.4," ",i3.3," ",i2.2,":",i2.2)' , yr, doy, hr,minu)
 'yyyy ddd hh:mm:ss': $
      date = string( format= '(i4.4," ",i3.3," ",i2.2,":",i2.2,":",i2.2)' , yr, doy, hr,minu,sec)
 'yyyy mm dd hh mm ss.sss': $
      date = string( format= '(i4.4,x, i2.2,x,i2.2,x,i2.2,x,i2.2,x,i2.2,".",i3.3)' , yr, month, dom, hr,minu,sec, msec)
 'yyyy mm dd hh mm ss': $
      date = string( format= '(i4.4,x, i2.2,x,i2.2,x,i2.2,x,i2.2,x,i2.2)' , yr, month, dom, hr,minu,round(sec +msec/1000.))
 'yyyy-mm-dd':date = string( yr,month,dom, $
               format= '(i4.4,"-",i2.2,"-",i2.2)')

  'yyyy mm dd ddd hh mm ss.sss': $
      date = string( format= '(i4.4,x, i2.2,x,i2.2,x,i3.3,x,i2.2,x,i2.2,x,i2.2,".",i3.3)' , yr, month, dom, doy, hr,minu,sec, msec)
 'yyyy mm dd hh:mm:ss.sss': $
      date = string( format= '(i4.4,x, i2.2,x,i2.2,x,i2.2,":",i2.2,":",i2.2,".",i3.3)' , yr, month, dom, hr,minu,sec, msec)
 'yyyy/mm/dd hh:mm:ss': $
      date = string( format= '(i4.4,"/", i2.2,"/",i2.2, x, i2.2,":",i2.2,":",i2.2)' , yr, month, dom, hr,minu,sec)
 'yyyy ddd hh:mm:ss.sss': $
      date = string( format= '(i4.4,x,i3.3,x,i2.2,":",i2.2,":",i2.2,".",i3.3)' , yr, doy, hr, minu, sec, msec)

'yyyy,ddd,mm,dd,hh,mm,ss.sss':begin
      format= '(i4,",",i3.3,",",i2.2,",",i2.2, "," ,i2.2, "," ,I2.2,",",I2.2,".",I3.3)'
      date = string( yr,doy,month,dom,hr,minu,sec,msec,format= format)
     end
     
 'yyyy ddd hh mm ss.sss': $
      date = string( format= '(i4.4,x,i3.3,x,i2.2,x,i2.2,x,i2.2,".",i3.3)' , yr, doy, hr, minu, sec, msec)
'yyyy-ddd::hh:mm:ss.sss': $
      date = string( format= $
'(i4.4,"-",i3.3,"::",i2.2,":",i2.2,":",i2.2,".",i3.3)' , $
 yr, doy, hr, min, sec, msec)

 'yyyy MMM dd hh:mm:ss.sss': $
      date = string( format= '(i4.4,x, a3,x,i2.2,x,i2.2,":",i2.2,":",i2.2,".",i3.3)' , yr, smons[month-1], dom, hr,minu,sec, msec)
 'yyyymmdd':date = string( yr,month,dom, $
               format= '(i4,i2.2,i2.2)')
 'yyyy/mm/dd':date = string( yr,month,dom, $
               format= '(i4,"/",i2.2,"/",i2.2)')
 'yyyymmddhh':date = string( yr,month,dom,hr, $
               format= '(i4,i2.2,i2.2,i2.2)')
'yyyymmddhhmm':date = string( yr,month,dom,hr,minu, $
               format= '(i4,4(i2.2))')
 'yyyymmddhhmmss':date = string( yr,month,dom,hr,minu,sec, $
               format= '(i4,5(i2.2))')
 'yyyymmddhhmmss.sss':date = string( yr,month,dom,hr,minu,sec,msec/10, $
               format= '(i4,5(i2.2),".",i2.2)')
 'yyyy,mm,dd,hh,mm,ss.sss':date = string( yr,month,dom,hr,minu,sec,msec, $
               format= '(i4,", "4(i2.2,", "),(i2.2),".",i3.3)')
 'yyyymmddThh':date = string( yr,month,dom,hr, $
               format= '(i4,i2.2,i2.2,"T",i2.2)')
 'yyyy-ddd-hh-mm-ss.ss': date = string( yr,doy,hr,minu,sec,msec/10 $ 
		,format= '(i4,"-",i3.3,3("-",i2.2),".",i2.2)' )
 'yyyydddhhmmss':date = string( yr,doy,hr,minu,sec,msec/10 $ 
		,format= '(i4,"-",i3.3,3("-",i2.2),".",i2.2)' )
 'yyyydddhhmmsss':date = string( yr,doy,hr,minu,sec,msec $ 
		,format= '(i4,"-",i3.3,3("-",i2.2),".",i3.3)' )
 'yyyy ddd (mm/dd)':date = string( yr,doy,month,dom $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")")' )
 'yyyy (mm/dd) ddd.dd':date = string( yr,month,dom,doy+tod_fracday $ 
		,format= '(i4,x,"(",i2.2,"/",i2.2,")",x,f6.2)' )
 'yyyy ddd (mm/dom)':date = string( yr,doy,month,dom $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")")' )
'yyyy ddd.dd (mm/dd)':date = string( yr,doy + tod_fracday,month,dom $ 
		,format= '(i4,x,f6.2,x,"(",i2.2,"/",i2.2,")")' )
 'yyyy ddd (mm/dom) hh:mm':date = string( yr,doy,month,dom,hr,minu $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2)' )
 'yyyy ddd (mm/dd) hh:mm':date = string( yr,doy,month,dom,hr,minu $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2)' )
 'yyyy ddd (mm/dd) hh:mm:ss.sss':date = string( yr,doy,month,dom,hr,minu,sec,msec $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2,":",I2.2,".",I3.3)' )
 'yyyy ddd (mm/dd) hh:mm:ss.ssssss':date = string( yr,doy,month,dom,hr,minu,sec,msec*1000 $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2,":",I2.2,".",I6.6)' )
 'yyyy ddd mm dd hh mm ss.sss':date = string( yr,doy,month,dom,hr,minu,sec,msec $ 
		,format= '(i4,x,i3.3,x,"(",i2.2," ",i2.2,")",x,i2.2," ",I2.2," ",I2.2,".",I3.3)')
 'yyyy/mm/dd hh:mm:ss':date = string( yr,month,dom,hr,minu,sec $ 
		,format= '(i4,"/",i2.2,"/",i2.2,x,i2.2,":",I2.2,":",I2.2)' )
'YYYY-MM-DD/hh:mm:ss':date = string( yr,month,dom,hr,minu,sec $ 
		,format= '(i4,"-",i2.2,"-",i2.2,"/",i2.2,":",I2.2,":",I2.2)' )
 'yyyy ddd (mm/dd) hh:mm:ss':date = string( yr,doy,month,dom,hr,minu,round(sec+msec/1000.) $ 
		,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2,":",I2.2)' )
 'yyyy ddd mm dom hh mm':date = string( yr,doy,month,dom,hr,minu $ 
		,format= '(i4,x,i3.3,4(x,i2.2))' )
 'yyyy ddd (mm/dd) hh:mm:ss':date = string( yr,doy,month,dom,hr,minu,sec $
                ,format= '(i4,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2,":",I2.2,".",I3.3)' )
 'yyyy ddd hh:mm:ss.sss':date = string( yr,doy,hr,minu,sec,msec $ 
		,format= '(i4,x,i3.3,x,i2.2,":",I2.2,":",I2.2,".",I3.3)' )
 'yyyy ddd hh:mm:ss':date = string( yr,doy,hr,minu, sec $ 
		,format= '(i4,x,i3.3,x,i2.2,":",I2.2,":",I2.2)' )
'yyyy.ddd.hh.mm.ss':date = string( yr,doy,hr,minu,sec $ 
		,format= '(i4,".",i3.3,".",i2.2,".",I2.2,".",I2.2)')
'yyyy.ddd.hh.mm':date = string( yr,doy,hr,minu $ 
		,format= '(i4,".",i3.3,".",i2.2,".",I2.2)' )
 'yyyy_ddd_hh':date=string(yr,doy,hr,format='(i4.4,"_",i3.3,"_",i2.2)')
 'yyyy ddd hh mm': $
      date=string(yr,doy,hr,minu,format='(i4.4," ",i3.3," ",i2.2," ",i2.2)')
 'yyyy_ddd_hh_mm': $
      date=string(yr,doy,hr,minu,format='(i4.4,"_",i3.3,"_",i2.2,"_",i2.2)')
 'yyyydoyhrminsec':date = string( yr,doy,hr,minu,sec,msec/10 $ 
		,format= '(i4,x,i3,3(x,i2.2),".",i2.2)' )

 'yrdoyhr': $
      date = string( format= '(i2.2,i3.3,i2.2)' , yr-yroff, doy, hr) 
 'yrdoyhrmin': $
      date = string( format= '(i2.2,i3.3,2i2.2)' , yr-yroff, doy, hr,minu)
 'yrdoy': $
      date = string( format= '(i2.2,i3.3)' , yr-yroff, doy)
 'yyddd': $
      date = string( format= '(i2.2,i3.3)' , yr-yroff, doy)
 'yrmmdd':date = string( yr,month,dom, $ 
               format= '(i4,x,i2.2,"/",i2.2," UT ")' )

 'yy ddd (mm/dom) hh:mm':date = string( yr-yroff,doy,month,dom,hr,minu $ 
		,format= '(i2,x,i3.3,x,"(",i2.2,"/",i2.2,")",x,i2.2,":",I2.2)' )

 else:begin
     date = string( $
               format= '(i4,x,i2.2,"/",i2.2," ",i2.2,":",i2.2," UT ")' $
               ,yr,dom,month,hr,minu)
      date = string( format= '(i2.2,i3.3,2i2.2)' , yr-yroff, doy, hr,minu)
 end
endcase
dates[ik] = date
endfor ;ik
return,dates
end
