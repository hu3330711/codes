;calling sequence 1 (load the whole time interval)
;load_kpap
;
;calling sequence 2 (load only in the timespan)
;timespan,'2000-1-1',10,/days
;load_kpap,/clip

pro load_kpap_QM,clip=clip,filename=filename

  ;; fname='/aurora-big/GROUND/kp/kp.dat'
  if keyword_set(filename) then fname  = filename else fname='/projectnb/burbsp/big/SATELLITE/geom_indices/kyoto/kp/kp.dat'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;read data
  spawn,'ls -alF '+fname, line
  IF(line eq '') THEN BEGIN
    PRINT, 'Cannot read the data file for ',fname
    return
  ENDIF

  datafile=fname
  nlines=File_Lines(datafile)
  data3=strarr(nlines)
  OpenR,lun,datafile,/get_lun
  ReadF,lun,data3
  close,/all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  time_3h=dblarr(nlines*8)
  time_1d=dblarr(nlines)
  kp=intarr(nlines*8)
  kppm=intarr(nlines*8)
  skp=intarr(nlines)
  Skppm=intarr(nlines)
  ap=intarr(nlines*8)
  sap=intarr(nlines)
  Wyear=''
  Wmonth=''
  Wday=''

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;/*file read*/
  ii=1
  ii=long64(ii)
  print,'nlines=',nlines
  while (ii le nlines-1) do begin
    loop=ii-1

    ;/*Wyymmdd*/
    reads,data3(ii),Wyear,Wmonth,Wday,format='(a4,a2,a2)'
    if(ii mod 5000 eq 0) then print,Wyear+'-'+Wmonth+'-'+Wday
    ;//==============
    time_1d(loop)=time_double(Wyear+'-'+Wmonth+'-'+Wday)
    for j=0,7,1 do begin
      time_3h(loop*8+j)=time_1d(loop)+j*3*3600.
      ;/*kp*/
      kp[loop*8+j]=long(strmid(data3(ii),9+j*2,1))
      ;/*\pm(Kp)*/
      if(strmid(data3(ii),10+j*2,1) eq ' ') then kppm[loop*8+j]= 0
      if(strmid(data3(ii),10+j*2,1) eq '+') then kppm[loop*8+j]= 1
      if(strmid(data3(ii),10+j*2,1) eq '-') then kppm[loop*8+j]=-1
      ;/*ap*/
      ap[loop*8+j]=long(strmid(data3(ii),29+j*3,2))
    endfor
    ;/*\sigma Kp*/
    skp[loop]=long(strmid(data3(ii),25,2))
    ;/*\pm(\sigma Kp)*/
    if(strmid(data3(ii),27,1) eq ' ') then skppm[loop]= 0
    if(strmid(data3(ii),27,1) eq '+') then skppm[loop]= 1
    if(strmid(data3(ii),27,1) eq '-') then skppm[loop]= -1
    ;/*Ap*/
    sap[loop]=long(strmid(data3(ii),53,2))
    ii=ii+1
  endwhile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  store_data,'kp_unsigned',data={x:time_3h,y:kp}
  store_data,'kp_sign',data={x:time_3h,y:kppm}
  store_data,'ap',data={x:time_3h,y:ap}
  store_data,'sigmakp_unsigned',data={x:time_1d,y:skp}
  store_data,'sigmakp_sign',data={x:time_1d,y:skppm}
  store_data,'sigmaap',data={x:time_1d,y:sap}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if keyword_set(clip) then begin
    get_timespan,t
    time_clip,'kp_unsigned',t[0],t[1],/replace
    time_clip,'kp_sign',t[0],t[1],/replace
    time_clip,'ap',t[0],t[1],/replace
    time_clip,'sigmakp_unsigned',t[0],t[1],/replace
    time_clip,'sigmakp_sign',t[0],t[1],/replace
    time_clip,'sigmaap',t[0],t[1],/replace
  endif


end
