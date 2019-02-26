function cmb_epoch_shift, dep
; dep is epoch structure
timeshift = 0
if cmb_tag_name_exists('DELTA_PLUS_VAR', dep) and cmb_tag_name_exists('DELTA_MINUS_VAR', dep) then BEGIN
  timeshift = (dep.DELTA_PLUS_VAR   + dep.DELTA_MINUS_VAR )/2
ENDIF
return, timeshift
end
