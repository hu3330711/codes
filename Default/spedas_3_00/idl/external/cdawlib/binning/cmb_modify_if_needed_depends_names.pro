pro cmb_add_newcdfvariable,d, d0, dependnameold
d0name = dependnameold + '_depend'
istat =  cmb_tag_name_exists(dependnameold + '_bin',  d)
print,' dependnameold:', dependnameold
print,' dependnamenew:', dependnameold + '_bin'
print,' istat of dependnamenew:', istat

if istat then return ; variable aready exists

istat =  cmb_tag_name_exists(d0name,  d0, i0)
print,'     ',(tag_names(d0))(i0)
istat =  cmb_tag_name_exists(dependnameold,  d, i1)
c = d.(i1)
c.handle = HANDLE_CREATE( value =  d0.(i0) )     
print,'     ', c.handle, d.(i1).handle
c.varname = c.varname + '_bin'
d = CREATE_STRUCT( d, c.varname, c)
end

pro cmb_modify_if_needed_depends_names,d,i0,d0
; .compile cmb_modify_if_needed_depends_names
; 1. if depends is varyting then change depends name to dependx_cmb
;depends = strlowcase( cmb_cdf_get_dependencies(d,i0) )
; INPUT d- data structure loaded by read_mycdf
;       d0 - data structure of binned variables
;tagnames = TAG_NAMES( d0)

print, 'checking depends of ', d.(i0).varname
sdepends = ['DEPEND_0','DEPEND_1', 'DEPEND_2', 'DEPEND_3']
n = n_elements(sdepends)
for i=0,n-1 do begin
   istat = cmb_tag_name_exists(sdepends[i],  d.(i0), i1)
   if istat then begin
	   print,'   ', sdepends[i], ' ', d.(i0).(i1)
	   istat = cmb_tag_name_exists(d.(i0).(i1),  d, i2)
	   if i2[0] eq -1 then goto,next ; message,'bad varname'
	   print,'     ', d.(i2).varname
	   nd = size( cmb_dat(d.(i2)),/n_dimensions)
	   print,sdepends[i],nd
	   if nd gt 1 then begin
	   print,'    changing depency name from: ', d.(i0).(i1), ' to ', d.(i0).(i1)+'_bin for variable: ', d.(i0).varname
	   dependnameold = d.(i0).(i1)
	   d.(i0).(i1) = d.(i0).(i1) + '_bin' 
	   cmb_add_newcdfvariable,d, d0, dependnameold 
   endif
   next:
   endif ;istat
endfor
end
