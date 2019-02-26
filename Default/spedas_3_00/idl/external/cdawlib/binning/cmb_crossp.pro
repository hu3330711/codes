
function cmb_crossp,ai,bi

if n_elements(a) eq 3 then begin
a=ai
b=bi
x = a[1]*b[2]-a[2]*b[1]
y = a[2]*b[0]-a[0]*b[2]
z = a[0]*b[1]-a[1]*b[0]
return,[x,y,z]
endif

n = n_elements(ai[0,*])
if cmb_var_type(ai) eq 'COMPLEX' then v = COMPLEXARR(3,n) $
else v = fltarr(3,n)

for i=0l,n-1 do begin
    a = ai[*,i]
    b = bi[*,i]
    x = a[1]*b[2]-a[2]*b[1]
    y = a[2]*b[0]-a[0]*b[2]
    z = a[0]*b[1]-a[1]*b[0]
    v[*,i] = [x,y,z]
endfor
return,v
end
