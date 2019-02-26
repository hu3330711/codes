FUNCTION Exponent, axis, index, number

  ; A special case.
  IF number EQ 0 THEN RETURN, '0'
  
  ; Assuming multiples of 10 with format.
  ex = String(number, Format='(e8.1)')
  pt = StrPos(ex, '.')
  
  first = StrMid(ex, 0, pt)
  
  second=strmid(ex,pt,2)
  ;   print,ex,first,pt,second,number
  
  sign = StrMid(ex, pt+3, 1)
  thisExponent = StrMid(ex, pt+4)
  
  ; Shave off leading zero in exponent
  WHILE StrMid(thisExponent, 0, 1) EQ '0' DO thisExponent = StrMid(thisExponent, 1)
  
  ; Fix for sign and missing zero problem.
  IF (Long(thisExponent) EQ 0) THEN BEGIN
    sign = ''
    thisExponent = '0'
  ENDIF
  
  ; Make the exponent a superscript.
  if second eq '.0' then begin
  
    if strcmp(strcompress(first,/remove_all),'1') eq 1 then begin
      IF sign EQ '-' THEN BEGIN
        RETURN, '10!U' + sign + thisExponent + '!N'
      ENDIF ELSE BEGIN
        RETURN, '10!U' + thisExponent + '!N'
      ENDELSE
    endif else begin
      IF sign EQ '-' THEN BEGIN
        RETURN, first + 'x10!U' + sign + thisExponent + '!N'
      ENDIF ELSE BEGIN
        RETURN, first + 'x10!U' + thisExponent + '!N'
      ENDELSE
    endelse
    
  endif else begin
    IF sign EQ '-' THEN BEGIN
      RETURN, first + second+ 'x10!U' + sign + thisExponent + '!N'
    ENDIF ELSE BEGIN
      RETURN, first + second+ 'x10!U' + thisExponent + '!N'
    ENDELSE
  endelse

END
