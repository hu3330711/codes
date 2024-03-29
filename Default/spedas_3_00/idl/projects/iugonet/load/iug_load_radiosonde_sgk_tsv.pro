;+
;
;NAME:
;iug_load_radiosonde_sgk_tsv
;
;PURPOSE:
;  Queries the Kyoto RISH server for the text data (press, temp, rh, uwnd, vwnd) 
;  of the troposphere in tsv format taken by the radiosonde at Shigaraki MU Observatory 
;  and loads data into tplot format.
;
;SYNTAX:
; iug_load_radiosonde_sgk_tsv, downloadonly=downloadonly, trange=trange, verbose=verbose
;
;KEYWOARDS:
;  trange = (Optional) Time range of interest  (2 element array), if
;          this is not set, the default is to prompt the user. Note
;          that if the input time range is not a full day, a full
;          day's data is loaded.
;  /downloadonly, if set, then only download the data, do not load it
;                 into variables.
;  VERBOSE: [1,...,5], Get more detailed (higher number) command line output.
;  
;CODE:
;  A. Shinbori, 24/01/2014.
;
;MODIFICATIONS:
;  A. Shinbori, 09/08/2017.
;  A. Shinbori, 30/11/2017.  
;  
;ACKNOWLEDGEMENT:
; $LastChangedBy: nikos $
; $LastChangedDate: 2018-02-09 12:24:19 -0800 (Fri, 09 Feb 2018) $
; $LastChangedRevision: 24682 $
; $URL $
;-

pro iug_load_radiosonde_sgk_tsv, downloadonly=downloadonly, $
  trange=trange, $
  verbose=verbose

;**********************
;Verbose keyword check:
;**********************
if (not keyword_set(verbose)) then verbose=2

;***********************
;Keyword check (trange):
;***********************
if not keyword_set(trange) then begin
  get_timespan, time_org
endif else begin
  time_org =time_double(trange)
endelse

;======================
;Calculation of height:
;======================
max_height = 40000
dh=30.0
num_h= fix(max_height/dh)
height = fltarr(num_h)
for i=0, n_elements(height)-2 do begin
   if height[i] le 40000 then height[i+1] = height[i]+dh
endfor

;**************************
;Loop on downloading files:
;**************************
;==============================================================
;Change time window associated with a time shift from UT to LT:
;==============================================================
day_org = (time_org[1] - time_org[0])/86400.d
day_mod = day_org + 1
timespan, time_org[0] - 3600.0d * 9.0d, day_mod
if keyword_set(trange) then trange[1] = time_string(time_double(trange[1]) + 9.0d * 3600.0d); for GUI

;==================================================================
;Download files, read data, and create tplot vars at each component
;==================================================================
;******************************************************************
;Loop on downloading files
;******************************************************************
;Define FILE_NAMES, and load data:
;=================================

;Definition of parameter and array:
if ~size(fns,/type) then begin       
  ;****************************
  ;Get files for ith component:
  ;****************************     
   hour_res = 1  
   file_names = file_dailynames( $
                file_format='YYYY/'+$
                'YYYYMMDDhh',trange=trange,hour_res=hour_res,times=times,/unique)+'*.tsv'
  
  ;===============================        
  ;Define FILE_RETRIEVE structure:
  ;===============================
   source = file_retrieve(/struct)
   source.verbose=verbose
   source.local_data_dir =  root_data_dir() + 'iugonet/rish/misc/sgk/radiosonde/tsv/'
   source.remote_data_dir = 'http://database.rish.kyoto-u.ac.jp/arch/iugonet/sonde/data/shigaraki/tsv/'
  
  ;=======================================================  
  ;Get files and local paths, and concatenate local paths:
  ;=======================================================
   local_paths = spd_download(remote_file=file_names, remote_path=source.remote_data_dir, local_path=source.local_data_dir, _extra=source, /last_version)
   local_paths_all = ~(~size(local_paths_all,/type)) ? $
                    [local_paths_all, local_paths] : local_paths
   if ~(~size(local_paths_all,/type)) then local_paths=local_paths_all
endif else file_names=fns

;--- Load data into tplot variables
if (not keyword_set(downloadonly)) then downloadonly=0

if (downloadonly eq 0) then begin
  ;=========================
  ;Definition of parameters:
  ;=========================
   s=''
   
  ;==============     
  ;Loop on files: 
  ;==============
   for j=0,n_elements(local_paths)-1 do begin
      file= local_paths[j] 
      if file_test(/regular,file) then  dprint,'Loading Shigaraki sonde data file: ',file $
      else begin
         dprint,'Shigaraki sonde data file',file,'not found. Skipping'
         continue
      endelse
         
     ;---Open the read file:
      openr,lun,file,/get_lun
       
     ;---Read time and header information:
      head_data = strsplit(s,' ', /extract)
      year = strmid(file,50,4)
      month = strmid(file,54,2)
      day = strmid(file,56,2)
      hour = strmid(file,58,2)
      minute = strmid(file,60,2)

     ;==================   
     ;Loop on read data:
     ;==================
      while(not eof(lun)) do begin
         readf,lun,s

         ok=1
         if strmid(s,0,1) eq '[' then ok=0
         if ok && keyword_set(s) then begin
            dprint,s ,dlevel=5
     
            data_comp = strsplit(strcompress(s),' ', /extract)

            if data_comp[0] eq 'RS-Number' then Sonde_Serial_No = data_comp[2]
            if n_elements(data_comp) eq 19 then begin
            
           ;===================================================================   
           ;Append array of height, press., temp., rh, dewp, uwind, vwind data:
           ;===================================================================
            append_array,time_data, float(data_comp[0])
            append_array,height_data, float(data_comp[6])
            if float(data_comp[7]) ne -32768.00 then append_array,press, float(data_comp[7])
            if float(data_comp[7]) eq -32768.00 then append_array,press, -999.00
            if float(data_comp[2]) ne -32768.00 then append_array,temp, float(data_comp[2])-273.15
            if float(data_comp[2]) eq -32768.00 then append_array,temp, -999.00
            if float(data_comp[3]) ne -32768.00 then append_array,rh, float(data_comp[3])
            if float(data_comp[3]) eq -32768.00 then append_array,rh, -999.00
            if float(data_comp[5]) ne -32768.00 then append_array,uwind, float(data_comp[5])
            if float(data_comp[5]) eq -32768.00 then append_array,uwind, -999.00
            if float(data_comp[4]) ne -32768.00 then append_array,vwind, float(data_comp[4])
            if float(data_comp[4]) eq -32768.00 then append_array,vwind, -999.00
            append_array,lon_data, float(data_comp[14])
            append_array,lat_data, float(data_comp[15])
            endif
            continue       
         endif
        ; stop
      endwhile 
      free_lun,lun ;Close the file

     ;---Definition of parameters and arraies:
      h_num= 0
      press2 = fltarr(1,n_elements(height))+!values.f_nan
      temp2 = fltarr(1,n_elements(height))+!values.f_nan
      rh2 = fltarr(1,n_elements(height))+!values.f_nan
      uwind2 = fltarr(1,n_elements(height))+!values.f_nan
      vwind2 = fltarr(1,n_elements(height))+!values.f_nan
         
     ;---Replace missing number by NaN
      for i=0, n_elements(height_data)-1 do begin
         a = press[i]            
         wbad = where(a eq -32768.00,nbad)
         if nbad gt 0 then a[wbad] = !values.f_nan
         press[i] =a 
         b = temp[i]            
         wbad = where(b eq -32768.00,nbad)
         if nbad gt 0 then b[wbad] = !values.f_nan
         temp[i] =b 
         c = rh[i]            
         wbad = where(c eq -32768.00,nbad)
         if nbad gt 0 then c[wbad] = !values.f_nan
         rh[i] =c 
         d = uwind[i]            
         wbad = where(d eq -32768.00,nbad)
         if nbad gt 0 then d[wbad] = !values.f_nan
         uwind[i] =d 
         e = vwind[i]            
         wbad = where(e eq -32768.00,nbad)
         if nbad gt 0 then e[wbad] = !values.f_nan
         vwind[i] =e 
      endfor

     ;---Convert time from UT to UNIX time
      time = time_double(string(year)+'-'+string(month)+'-'+string(day)+'/'+string(hour)+':'+string(minute)) - double(9) * 3600.0d

      k=0
      for i=0, n_elements(height)-1 do begin
         idx = where((height_data ge height[i]-dh/2.0) and (height_data lt height[i]+dh/2.0),cnt)
         if idx[0] ne -1 then begin
            press2[0,i]=mean(press[idx],/NAN)
            temp2[0,i]=mean(temp[idx],/NAN)
            rh2[0,i]=mean(rh[idx],/NAN)
            uwind2[0,i]=mean(uwind[idx],/NAN)
            vwind2[0,i]=mean(vwind[idx],/NAN)
         endif
      endfor

     ;=====================
     ;Append time and data:
     ;=====================
      append_array, sonde_time, time
      append_array, sonde_press, press2
      append_array, sonde_temp, temp2
      append_array, sonde_rh, rh2
      append_array, sonde_uwind, uwind2
      append_array, sonde_vwind, vwind2

     ;---Clear Buffer:
      time=0
      time_data=0
      height_data=0
      press=0
      temp=0
      rh=0
      uwind=0
      vwind=0
      lat_data=0
      lon_data=0 
   endfor

  ;==============================================================
  ;Change time window associated with a time shift from UT to LT:
  ;==============================================================
   timespan, time_org
   get_timespan, init_time2
   if keyword_set(trange) then trange[1] = time_string(time_double(trange[1]) - 9.0d * 3600.0d); for GUI      
  ;==============================
  ;Store data in TPLOT variables:
  ;==============================
  ;---Acknowlegment string (use for creating tplot vars)
   acknowledgstring = 'If you acquire radiosonde data, we ask that you acknowledge us in your use of the data. ' $
                    + 'This may be done by including text such as radiosonde data provided by Research Institute ' $
                    + 'for Sustainable Humanosphere of Kyoto University. We would also appreciate receiving a copy ' $
                    + 'of the relevant publications. The distribution of radiosonde data' $
                    + 'has been partly supported by the IUGONET (Inter-university Upper atmosphere Global' $
                    + 'Observation NETwork) project (http://www.iugonet.org/) funded by the' $
                    + 'Ministry of Education, Culture, Sports, Science and Technology (MEXT), Japan.'
  
   if size(sonde_press,/type) eq 4 then begin 
     ;---Create tplot variables and options
      dlimit=create_struct('data_att',create_struct('acknowledgment',acknowledgstring,'PI_NAME', 'H. Hashiguchi'))
      store_data,'iug_radiosonde_sgk_press',data={x:sonde_time, y:sonde_press, v:height/1000.0},dlimit=dlimit
      
     ;----Edge data cut:
      time_clip,'iug_radiosonde_sgk_press', init_time2[0], init_time2[1], newname = 'iug_radiosonde_sgk_press'
      options,'iug_radiosonde_sgk_press',ytitle='RSND-sgk!CHeight!C[km]',ztitle='Press.!C[hPa]'

      store_data,'iug_radiosonde_sgk_temp',data={x:sonde_time, y:sonde_temp, v:height/1000.0},dlimit=dlimit
      
     ;----Edge data cut:
      time_clip,'iug_radiosonde_sgk_temp', init_time2[0], init_time2[1], newname = 'iug_radiosonde_sgk_temp'
      options,'iug_radiosonde_sgk_temp',ytitle='RSND-sgk!CHeight!C[km]',ztitle='Temp.!C[deg.]'

      store_data,'iug_radiosonde_sgk_rh',data={x:sonde_time, y:sonde_rh, v:height/1000.0},dlimit=dlimit

     ;----Edge data cut:
      time_clip,'iug_radiosonde_sgk_rh', init_time2[0], init_time2[1], newname = 'iug_radiosonde_sgk_rh'
      options,'iug_radiosonde_sgk_rh',ytitle='RSND-sgk!CHeight!C[km]',ztitle='RH!C[%]'

      store_data,'iug_radiosonde_sgk_vertical_velocity',data={x:sonde_time, y:sonde_vertical_velocity, v:height/1000.0},dlimit=dlimit

     ;----Edge data cut:
      time_clip,'iug_radiosonde_sgk_uwnd', init_time2[0], init_time2[1], newname = 'iug_radiosonde_sgk_uwnd'
      options,'iug_radiosonde_sgk_vertical_velocity',ytitle='RSND-sgk!CHeight!C[km]',ztitle='Ascending speed!C[m/s]'

      store_data,'iug_radiosonde_sgk_vertical_height',data={x:sonde_time, y:sonde_vertical_height, v:height/1000.0},dlimit=dlimit

     ;----Edge data cut:
      time_clip,'iug_radiosonde_sgk_vwnd', init_time2[0], init_time2[1], newname = 'iug_radiosonde_sgk_vwnd'
      options,'iug_radiosonde_sgk_vertical_height',ytitle='RSND-sgk!CHeight!C[km]',ztitle='Height!C[km]'
      options, ['iug_radiosonde_sgk_press','iug_radiosonde_sgk_temp',$
                'iug_radiosonde_sgk_rh',$
                'iug_radiosonde_sgk_vertical_velocity','iug_radiosonde_sgk_vertical_height'], 'spec', 1
   endif 

  ;---Clear time and data buffer:
   sonde_time = 0
   sonde_press = 0
   sonde_temp = 0
   sonde_rh = 0
   sonde_uwind = 0
   sonde_vwind = 0
       
  ;---Add tdegap
   new_vars=tnames('iug_radiosonde_*')
   if new_vars[0] ne '' then begin  
      tdegap, 'iug_radiosonde_sgk_press',/overwrite
      tdegap, 'iug_radiosonde_sgk_temp',/overwrite
      tdegap, 'iug_radiosonde_sgk_rh',/overwrite
      tdegap, 'iug_radiosonde_sgk_uwnd',/overwrite
      tdegap, 'iug_radiosonde_sgk_vwnd',/overwrite
      zlim, 'iug_radiosonde_sgk_uwnd', -40,40
      zlim, 'iug_radiosonde_sgk_vwnd', -40,40
   endif
endif 

;---Initialization of timespan for parameters-1:
timespan, time_org

new_vars=tnames('iug_radiosonde_*')
if new_vars[0] ne '' then begin    
   print,'*****************************
   print,'Data loading is successful!!'
   print,'*****************************
endif

;**************************
;Print of acknowledgement:
;**************************
print, '****************************************************************
print, 'Acknowledgement'
print, '****************************************************************
print, 'If you acquire radiosonde data, we ask that you acknowledge us in  ' 
print, 'your use of the data. This may be done by including text such as ' 
print, 'radiosonde data provided by Research Institute for Sustainable ' 
print, 'Humanosphere of Kyoto University. We would also appreciate ' 
print, 'receiving a copy of the relevant publications. The distribution ' 
print, 'of radiosonde data has been partly supported by the IUGONET ' 
print, '(Inter-university Upper atmosphere Global Observation NETwork) '
print, 'project (http://www.iugonet.org/) funded by theMinistry of Education, '
print, 'Culture, Sports, Science and Technology (MEXT), Japan.'
end
