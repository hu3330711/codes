;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_set_up_colors,ict
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
idx = (where([ 'MacOS', 'Windows', 'unix' ] eq !version.os_family))[0]
top = 255
bottom = 0
;if idx eq 1 then set_plot,'WIN' else  set_plot,'X'
device,decomposed=0
if n_elements(ict) eq 0 then ict = 13
if ict eq 75 then sab_redbluect else loadct,ict
nc = !d.table_size 
!p.color = 0
!p.background = nc-1
!p.thick = 1.0 & !x.thick = 1.0 & !y.thick = 1.0
!p.charthick = 1.0 & !p.charsize = 1.0
!p.font = -1
  r_curr[0] = bottom & g_curr[0] = bottom
  b_curr[0] = bottom
  r_curr[nc-1] = top & g_curr[nc-1] = top
  b_curr[nc-1] = top
  tvlct, r_curr, g_curr, b_curr
end
