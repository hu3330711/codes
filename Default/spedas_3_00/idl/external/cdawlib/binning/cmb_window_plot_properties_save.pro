;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

;Caveat Emptor: this code was written by Scott Boardsen, Heliophysics Division, NASA/GSFC and UMBC/GEST.
pro cmb_window_plot_properties_save,jsave,epr=epr,removeclosedwindows=removeclosedwindows
;save plot axis properties of window
if !d.name eq 'PS' then return
if cmb_var_type(jsave) ne 'STRING' then isave=jsave $
else if strlowcase(jsave) eq 'save' then isave=1 else isave=0
;isave=1 save scaling for current window
;isave=0 restore scaling for current window
if !d.name ne 'X' and !d.name ne 'WIN' then return
common cmb_window_plot_properties_save,win
if n_elements(isave) eq 0 then isave=0
if n_elements(win) eq 0 then begin
   win=replicate( {window:-1,d:!d, p:!p, x:!x, y:!y,epr:dblarr(2)}, 20 ) 
endif
if keyword_set(removeclosedwindows) then begin
   iopen = windows_opened(win.window)
   ii=where(iopen eq 0)
   if ii[0] ne -1 then win[ii].window=-1
end

index = where( !d.window eq win.window) & index=index[0]
if isave eq 1 then begin
  if index[0] eq -1 then begin 
     index=where( win.window eq -1) & index=index[0]
  endif
  if index eq -1 then begin
     print,'error in window_save_2'
     stop
  endif
  win[index].window = !d.window
  win[index].d = !d
  win[index].p=!p
  win[index].x=!x
  win[index].y=!y
  if n_elements(epr) eq 2 then win[index].epr = epr
  print,'saved scaling for window:',index
endif else begin
  !p = win[index].p
  !x = win[index].x
  !y = win[index].y
  epr =win[index].epr
  print,'restored scaling for window:',index
endelse
end

