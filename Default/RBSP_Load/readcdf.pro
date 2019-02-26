;+
; NAME:
;     READCDF
;
; IDENT:
;     $Id: readcdf.pro,v 1.5 1998/05/15 16:02:46 esm Exp $
;
; PURPOSE:
;     Read in the contents of a CDF file, and return them in a data structure.
;
; AUTHOR:
;     Ed Santiago
;
; CALLING SEQUENCE:
;     data = READCDF( filename [,/Quiet] )
;
; INPUTS:
;     filename	- name of CDF file to read
;
; KEYWORDS:
;     /Quiet	- Read silently, without emitting progress reports.
;
; OUTPUTS:
;     A data structure containing all the zVariable and rVariable elements in the CDF.
;
; SIDE EFFECTS:
;
; EXAMPLE:
;
;     IDL> data = readcdf('1994-084_05-APR-1998.CDFSAVE')
;     Reading:    Theta_l[6]
;     Reading:    Theta_u[6]
;     ....
;     Reading: theta_phi_[2][971]
;     IDL> help, data, /st
;     ** Structure <81e7d7c>, 24 tags, length=52280200, refs=1:
;        THETA_L         STRUCT    -> <Anonymous> Array[1]
;        THETA_U         STRUCT    -> <Anonymous> Array[1]
;        ...
;        THETA_PHI_E     STRUCT    -> <Anonymous> Array[1]
;     IDL> help, data.theta_phi_e, /st
;     ** Structure <81be43c>, 8 tags, length=7824, refs=2:
;        NAME            STRING    'theta_phi_e'
;        FIELDNAM        STRING    'polar,azim ang e symm axis'
;        VALIDMIN        FLOAT     Array[2]
;        VALIDMAX        FLOAT     Array[2]
;        SCALEMIN        FLOAT     Array[2]
;        SCALEMAX        FLOAT     Array[2]
;        UNITS           STRING    'deg'
;        DATA            FLOAT     Array[971, 2]
;     IDL>
;
; HISTORY:
;     Original version by Ed Santiago
;     10/15/2004 H. Korth, JHU/APL: Added error checking to accommodate Oersted data
;     08/22/2007 H. Korth, JHU/APL: Process both z and r variables
;
;-
function readcdf, filename, quiet=quiet
  ; Perform sanity checks on our input parameters
  if n_elements(quiet) eq 0 then quiet=0

  ; Set quiet system variable
  thisquiet=!quiet
  !quiet=1

  ; Open the file, and get the inquiry data from it.
  cdfid=cdf_open(filename)
  glob=cdf_inquire(cdfid)

  ; Process Z variables

  ; CDF files contain "attributes", such as a nice description of the
  ; field, valid minimum and maximum values, units, etc.  Find out how
  ; many attributes are available for this CDF, and use that info later.
  cdf_control, cdfid, get_numattrs=num_attrs
  attrlist = [ {attrlist, attr_no:0l, name:'', maxzentry:0l} ]
  for attr=0, total(num_attrs)-1 do begin
    cdf_control, cdfid, attribute=attr, get_attr_info=attr_info
    if attr_info.maxzentry gt 0 then begin
      cdf_attinq, cdfid, attr, name, scope, maxe, maxz
      attrlist = [ attrlist, {attrlist, attr, name, attr_info.maxzentry} ]
    endif
  endfor

  ;
  ; Loop over all zVariables, reading them in and adding them to a structure.
  ;
  for var=0, glob.nzvars-1 do begin
    info = cdf_varinq(cdfid, var, /z)

    ; Since it takes so long to read these files, tell the user where we are
    if not quiet then begin
   ;   print,format='("Reading: ",A12,$)',info.name
      if info.dim[0] ne 0 then begin
   ;     print, format='("[",i0,$)', info.dim[0]
        order = n_elements(info.dim)
        ;for i=1,order-1 do ;print, format='("x",i0,$)', info.dim[i]
    ;    print, format='("]",$)'
      endif
    endif

    ; Read in all the given variable's attributes
    field = create_struct( 'name', info.name )
    for attr=1,n_elements(attrlist)-1 do begin
      if (cdf_attexists(cdfid,attrlist(attr).name,info.name,/z) eq 1) then begin
        cdf_attget, cdfid, attrlist[attr].attr_no, info.name, value
        field = create_struct(field, attrlist[attr].name, value)
      endif
    endfor

    ; Read in the data values.
    ; NOVARY records are easy -- there's just one of them.  Slurp it in.
    ; For VARY records, we need to figure out how many of them there are.
    if info.recvar eq 'novary' then begin
        cdf_varget, cdfid, info.name, data, /z
    endif else begin
        ; Find out how many of them there are, and read them all in.
        ; cdf_control, cdfid, get_var_info=varinfo, variable=info.name, $
        ; set_padvalue=-1
      cdf_control, cdfid, get_var_info=varinfo, variable=info.name

    ;  if not quiet then print, format='("[",i0,"]",$)',varinfo.maxrec

      if (varinfo.maxrec ge 0) then begin
        cdf_varget, cdfid, info.name, tmp, /z, rec_count = (varinfo.maxrec>1)

    ; Reform what we got into something nicer.  The CDF routines
	  ; return an array with the record number as the last index,
	  ; that is, something like Epoch[1,900], PCounts[24,6,40,900].
	  ; Since record number (ie, time) is the natural first index, we
	  ; would rather have something that looks like PCounts[t, *, *, *]
	  ; than PCounts[*, *, *, t].  We would also rather have one-by-N
	  ; arrays (eg, Epoch[1,900]) converted to vectors (Epoch[900]).
	  ; The two simple-looking lines below take care of that.  We
	  ; use IDL's TRANSPOSE() function to move the last array index
	  ; into first position and keep the other indices the same.
	  ; A nice side-effect of TRANSPOSE() is that it will convert
	  ; one-by-N arrays into straight vectors.
	  ;
	  ; Yes, it's ridiculous to spend this much comment space on
	  ; one simple function, but it took me so long to get this
	  ; figured out that I reckon this should help someone later.
        s=size(tmp)
        if (s[0] gt 1) then begin
          data = transpose(tmp, [s[0]-1, indgen(s[0]-1)])
        endif else data=tmp

      endif else data=-1
    endelse

  ;  if not quiet then print, ''

    ; We now have a nicely formatted field.  Create a data
    ; structure and add all the fields as we read them in.
    field=create_struct(field,'data',data)

    structinfoname=''
    for i=0,strlen(info.name)-1 do begin
      char=strmid(info.name,i,1)
      char_ascii=(fix(byte(char)))(0)

      if ( (char_ascii ge 48) and (char_ascii le 57) or $	     ; 0-9
           (char_ascii ge 65) and (char_ascii le 90) or $      ; A-Z
           (char_ascii ge 97) and (char_ascii le 122) ) then $ ; a-z
        structinfoname=structinfoname+char
        
      if (char_ascii eq 43) then structinfoname=structinfoname+'p'  ; + sign 

      if (char_ascii eq 45) then structinfoname=structinfoname+'m'  ; - sign 
    endfor
    
    structinfoname=idl_validname(structinfoname,/convert_all)

    if n_elements(mystruct) eq 0 then $
        mystruct=create_struct(structinfoname,field)	$
    else								$
        mystruct=create_struct(mystruct,structinfoname,field)
  endfor

  ; Process non-Z variables

  ; CDF files contain "attributes", such as a nice description of the
  ; field, valid minimum and maximum values, units, etc.  Find out how
  ; many attributes are available for this CDF, and use that info later.
  cdf_control, cdfid, get_numattrs=num_attrs
  attrlist = [ {attrlist, attr_no:0l, name:'', maxzentry:0l} ]
  for attr=0, total(num_attrs)-1 do begin
    cdf_control, cdfid, attribute=attr, get_attr_info=attr_info
    if attr_info.maxrentry gt 0 then begin
      cdf_attinq, cdfid, attr, name, scope, maxe, maxz
      attrlist = [ attrlist, {attrlist, attr, name, attr_info.maxrentry} ]
    endif
  endfor

  ;
  ; Loop over all zVariables, reading them in and adding them to a structure.
  ;
  for var=0, glob.nvars-1 do begin
    info = cdf_varinq(cdfid, var)

    ; Since it takes so long to read these files, tell the user where we are
    if not quiet then $
    ;  print,format='("Reading: ",A12,$)',info.name

    ; Read in all the given variable's attributes
    field = create_struct( 'name', info.name )
    for attr=1,n_elements(attrlist)-1 do begin
      if (cdf_attexists(cdfid,attrlist(attr).name,info.name) eq 1) then begin
        cdf_attget, cdfid, attrlist[attr].attr_no, info.name, value
        field = create_struct(field, attrlist[attr].name, value)
      endif
    endfor

    ; Read in the data values.
    ; NOVARY records are easy -- there's just one of them.  Slurp it in.
    ; For VARY records, we need to figure out how many of them there are.
    if info.recvar eq 'novary' then begin
        cdf_varget, cdfid, info.name, data
    endif else begin
        ; Find out how many of them there are, and read them all in.
        ;cdf_control, cdfid, get_var_info=varinfo, variable=info.name, $
        ;set_padvalue=-1
      cdf_control, cdfid, get_var_info=varinfo, variable=info.name

	  ;  if not quiet then print, format='("[",i0,"]",$)',varinfo.maxrec

      if (varinfo.maxrec ge 0) then begin
        cdf_varget, cdfid, info.name, tmp, rec_count = (varinfo.maxrec>1)

      ; Reform what we got into something nicer.  The CDF routines
  	  ; return an array with the record number as the last index,
  	  ; that is, something like Epoch[1,900], PCounts[24,6,40,900].
  	  ; Since record number (ie, time) is the natural first index, we
  	  ; would rather have something that looks like PCounts[t, *, *, *]
  	  ; than PCounts[*, *, *, t].  We would also rather have one-by-N
  	  ; arrays (eg, Epoch[1,900]) converted to vectors (Epoch[900]).
  	  ; The two simple-looking lines below take care of that.  We
  	  ; use IDL's TRANSPOSE() function to move the last array index
  	  ; into first position and keep the other indices the same.
  	  ; A nice side-effect of TRANSPOSE() is that it will convert
  	  ; one-by-N arrays into straight vectors.
  	  ;
  	  ; Yes, it's ridiculous to spend this much comment space on
  	  ; one simple function, but it took me so long to get this
  	  ; figured out that I reckon this should help someone later.
        s=size(tmp)
        if (s[0] gt 1) then begin
          data = transpose(tmp, [s[0]-1, indgen(s[0]-1)])
        endif else data=tmp

      endif else data=-1
    endelse

   ; if not quiet then print, ''

    ; We now have a nicely formatted field.  Create a data
    ; structure and add all the fields as we read them in.
    field=create_struct(field,'data',data)

    structinfoname=''
    for i=0,strlen(info.name)-1 do begin
      char=strmid(info.name,i,1)
      char_ascii=(fix(byte(char)))(0)

      if ( (char_ascii ge 48) and (char_ascii le 57) or $	     ; 0-9
           (char_ascii ge 65) and (char_ascii le 90) or $      ; A-Z
           (char_ascii ge 97) and (char_ascii le 122) ) then $ ; a-z
        structinfoname=structinfoname+char
    endfor

    if n_elements(mystruct) eq 0 then $
        mystruct=create_struct(structinfoname,field)	$
    else								$
        mystruct=create_struct(mystruct,structinfoname,field)
  endfor

  ; Done!  Close the CDF and return what we made.
  cdf_close, cdfid

  !quiet=thisquiet

  return, mystruct
end
