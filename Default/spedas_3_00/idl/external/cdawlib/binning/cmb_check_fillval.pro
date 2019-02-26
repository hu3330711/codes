function cmb_check_fillval, fillvalin, iredefinefillval, validmax=validmax, validmin=validmin
; fillval = cmb_check_fillval( fillvalin, iredefinefillval, validmax=validmax, validmin=validmin)
; check is fillval is ok
;  calling routine is cmb_filter_time_series
; if ok return  fillvalin and set iredefinefillval = 0
; if not return new fillval and set iredefinefillval =1
; fillval = cmb_check_fillval( fillvalin, iredefinefillval)
; check if fillval equal -32768 I*4
; note for I*4: abs(-32768) = -32768
; if so change fillval to -32767 I*4: because abs(-32767) = 32767
if n_elements(validmin) eq 0 then begin
   validmin = 0
   validmax =0
endif
validmin = min(validmin)
validmax = max(validmax)
iredefinefillval = 0
fillval = fillvalin
if cmb_var_type(fillvalin) eq 'INT' then begin ; added due to 2's compliment problems,  abs(-32768) = -32768
   if fillvalin eq fix(-32768) then begin
      fillval=fillvalin + 1
      iredefinefillval = 1
   endif
endif

if cmb_var_type(fillvalin) eq 'LONG' then begin  ; added due to 2's compliment problems, abs(-2147483648) = -2147483648
   if fillvalin eq long(-2147483648) then begin
      fillval=fillvalin + 1
      iredefinefillval = 1
   endif
endif

if fillvalin eq 0 then begin ; set fillval if not defined
   if cmb_var_type(fillvalin) eq 'INT' then fillval=fix(-32767)
   if cmb_var_type(fillvalin) eq 'LONG' then fillval=long(-2147483647)
   if cmb_var_type(fillvalin) eq 'FLOAT' then fillval=  -1e31
   if cmb_var_type(fillvalin) eq 'DOUBLE' then fillval= -1d31
   iredefinefillval = 1
endif

if cmb_var_type(fillval) eq 'DOUBLE' or cmb_var_type(fillval) eq 'FLOAT' then begin ; redine fillval if near zero
   case cmb_var_type(fillval) of 
   'FLOAT':if abs(fillval) lt 1e-29 then fillval=-1e31
   'DOUBLE':if abs(fillval) lt 1d-29 then fillval=-1d31
   endcase
   if fillval ne fillvalin then iredefinefillval = 1
endif

if validmax gt validmin then begin ; check if fillval is outside of range of valid min/max
   if fillval ge validmin and fillval le validmax then BEGIN
	   if cmb_var_type(fillval) eq 'INT' then fillval=fix(-32767)
	   if cmb_var_type(fillval) eq 'LONG' then fillval=long(-2147483647)
	   if cmb_var_type(fillval) eq 'FLOAT' then fillval=  -1e31
	   if cmb_var_type(fillval) eq 'DOUBLE' then fillval= -1d31
	   iredefinefillval = 1 
   ENDIF
endif 

if iredefinefillval then begin
   print,'fill value=', fillvalin, ' changed to ', fillval
endif
;help,fillvalin,fillval
return, fillval
end