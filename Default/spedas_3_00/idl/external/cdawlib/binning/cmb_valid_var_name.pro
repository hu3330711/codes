;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_valid_var_name,as, notvalid=notvalid,filename=filename,ivalid = ivalid
;Check if variable names in string array 'as' are  valid IDL variable names
;if not modify 'as' to make it valid by replacing invalid characters with '_'.
asv = as
for irec=0,n_elements(as)-1 do begin
    a = as[irec]
a = strtrim(a,2)
;a = strlowcase(a)
a0 = (byte('a'))(0)
z0 = (byte('z'))(0)
au = (byte('A'))(0)
zu = (byte('Z'))(0)
zero = (byte('0'))(0)
nine = (byte('9'))(0)
singlequote = (byte("'"))(0)
doublequote = (byte('"'))(0)
underscore = (byte('_'))(0)
null = (byte(''))(0)

;notvalid = [(byte(' '))(0), (byte('+'))(0),(byte('-'))(0), byte('!@#$%^&*()[]-+=?,.<>')]
if n_elements(notvalid) eq 0 then notvalid = byte(' !@#$%^&*()[]-+=?,.<>/\|:;"''')
if keyword_set(filename) then notvalid = byte(' !@#$%^&*()[]+=?,<>')
b = byte(a)
if ( (b[0] lt a0 or b[0] gt z0) $
 and (b[0] lt au or b[0] gt zu) ) $
 and (b[0] ge zero and b[0] le nine)  $
 and (b[0] ne singlequote and b[0] ne doublequote) then b = [(byte('z'))(0),b]

for i=0,n_elements(notvalid)-1 do begin
    ii=where(b eq notvalid[i])
    if ii[0] ne -1 then b[ii] = underscore ; underscore
endfor

asv[irec] = string(b)
endfor

return,asv
end
