
function cmb_updatestructwith_epoch_bin,d,s
; d0 = cmb_updatestructwith_epoch_bin(d,s)
 a = cmb_cdf_get_depend0(d, varsthathavedepend0=vars, check_allow_bin=1)
 d0=d
 a0 = d.(a[0].index)
 iallow = where( a.allow_bin eq 1)
 if iallow[0] eq -1 then BEGIN
    print,'cmb_updatestructwith_epoch_bin: retaining all epoch definitions
    goto, jumpto
 endif
; help,a, iallow
 a = a[iallow]
; commented out below 3 lines, because we want to retain original epoch, SAB 2016/8/17
; for ia=0,n_elements(a)-1 do d0=cmb_remove_tagname_from_structure( d0, a[ia].name)
; for ia=0,n_elements(a)-1 do d0=cmb_remove_tagname_from_structure( d0, a[ia].delta_plus_var)
; for ia=0,n_elements(a)-1 do d0=cmb_remove_tagname_from_structure( d0, a[ia].delta_minus_var)
 a0.varname ='Epoch_bin'
 a0.fieldnam ='Epoch_bin'
 a0.catdesc = 'Time base for time binned measurements, the time is the center time of each bin.'
 if cmb_tag_name_exists('var_notes',a0) then a0.var_notes ='Time base for time binned measurements, the time is the center time of each bin.'
 if cmb_tag_name_exists('DELTA_MINUS_VAR',a0) then a0.DELTA_MINUS_VAR=''
 if cmb_tag_name_exists('DELTA_PLUS_VAR',a0) then a0.DELTA_PLUS_VAR=''
;redined depend0
; for it=0,n_tags(d)-1 do if cmb_tag_name_exists('depend_0',d.(it)) then d0.(it).depend_0='Epoch_bin'

jumpto:
for ivar=0,n_elements(vars)-1 do $
if cmb_tag_name_exists(vars[ivar], d0, i0) then begin 
  if d0.(i0).depend_0 ne '' and d0.(i0).var_type eq 'data' then begin      
      if cmb_tag_name_exists('allow_bin', d0.(i0)) then BEGIN
         if d0.(i0).allow_bin ne 'FALSE' then d0.(i0).depend_0='Epoch_bin'
      endif else d0.(i0).depend_0='Epoch_bin'
  endif
endif
 a0.handle = handle_create(value = s.epoch_bin)
 d0 = create_struct('Epoch_bin',a0,d0)
return,d0
end