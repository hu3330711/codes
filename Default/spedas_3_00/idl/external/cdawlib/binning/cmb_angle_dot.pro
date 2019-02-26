
function cmb_angle_dot,a,b,absolute=absolute
;compute dot product angle between the unit vectors of 'a' and 'b'
;a = a[nc,nt] or a[nc] & b = b[nc,nt] or b=b[nc] -nc number of components in vector, nt-vectors at different time steps
if cmb_var_type(a) eq 'DOUBLE' or cmb_var_type(b) eq 'DOUBLE' then idouble =1
si = size(a)
if si[0] eq 1 then begin
 if norm(a) eq 0 or norm(b) eq 0 then return,!pi
 a0 = a/sqrt(total(a^2, double = idouble))
 b0 = b/sqrt(total(b^2, double = idouble))
 dot = total(a0*b0, double = idouble)
 if abs(dot) gt 1 then dot = cmb_sgn(dot)
 ang = acos(dot)
 if keyword_set(absolute) then dot = abs(dot)
 if finite(ang) ne 1 then stop
return,acos(dot)
endif
;a[3,n],b[3,n]
a0 = a
b0 = b
am = sqrt(total(a^2,1, double = idouble))
bm = sqrt(total(b^2,1, double = idouble))
;help,am,bm
for i=0,si[1]-1 do begin
    a0[i,*] = a0[i,*]/am
    b0[i,*] = b0[i,*]/bm
endfor
dot = total( a0*b0,1, double = idouble)
if keyword_set(absolute) then dot = abs(dot)
ii=where( abs(dot) gt 1)
if ii[0] ne -1 then begin
   dot[ii] = cmb_sgn(dot[ii])
endif
return,acos(dot)
end
