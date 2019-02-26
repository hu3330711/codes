;+
;Function: sec_read_ascii_data
;
;Purpose:
; This is a routine to read the sec ascii data files (James Weygand)
;
; Data contains Latitude, Longitude in geocoordinates and J (amplitude)
; Each file is for 10 seconds
; Files need to be read and bundled into one data array that spans the
; start and stop times
;
;INPUT:
;  filename: a
;OUTPUT:
;  data: array of data [4xn] ([time, lat, lon, amp])
;
;KEYWORDS:
; out_dir = the output directory for the .dat files
;
;
; $LastChangedBy: crussell $
; $LastChangedDate: 2012-05-10 14:23:29 -0700 (Thu, 10 May 2012) $
; $LastChangedRevision: 10410 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/thmsoc/trunk/idl/thmsoc/fmi_gmag/thm_read_fmi10secfile.pro $
;-
function sec_read_ascii_data, filenames

  sec_template = { version: 1.0, $
    datastart: 0L, $
    delimiter: 32b, $
    missingvalue: 0.0, $    ; OR? !values.f_nan
    commentsymbol: ';', $
    fieldcount: 3L, $
    fieldtypes: [5,5,5], $
    fieldnames: ['lat','long','amp'] ,$
    fieldlocations: [0,10,22], $
    fieldgroups: [0,1,2] }

  ;catch errors from incorrectly formatted files
  catch,err
  if err eq 0 then begin

    for i=0,n_elements(filenames)-1 do begin

      dprint, 'Reading filename: ' + filenames[i]
      ; extract time from filename
      idx=strpos(filenames[i], '_')
      year=strmid(filenames[i],idx-8,4)
      month=strmid(filenames[i],idx-4,2)
      day=strmid(filenames[i],idx-2,2)
      hr=strmid(filenames[i],idx+1,2)
      min=strmid(filenames[i],idx+3,2)
      sec=strmid(filenames[i],idx+5,2)
      date_str=year+'-'+month+'-'+day+'/'+hr+':'+min+':'+sec
      ; get data from file, data is read in as Lat, Long, Jx, and Jy
      results = read_ascii(filenames[i],template=sec_template)

      npts=n_elements(results.lat)
      time=make_array(npts, /double) + time_double(date_str)
      ; append each 10 second file set of data
      append_array, times, time
      append_array, lat, results.lat
      append_array, longs, results.long
      append_array, amp, results.amp
    endfor

    data=make_array(n_elements(times),4, /double)
    data[*,0]=times
    data[*,1]=lat
    data[*,2]=longs
    data[*,3]=amp
    return, data

  endif else begin

    dprint,"Error reading: " + filenames[i]
    dprint,"Error: " + !ERROR_STATE.MSG
    return, 'ERR'

  endelse
  catch,/cancel

end
