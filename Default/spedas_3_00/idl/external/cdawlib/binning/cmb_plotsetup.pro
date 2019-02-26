;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_n_colors_0
return,!d.table_size
end

pro cmb_postscript,portrait=portrait,even=even
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
top = 255
bottom = 0
     set_plot, 'ps'
     if keyword_set(portrait) then begin
        if keyword_set(even) then begin
           device,/portrait,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=.5,XSIZE=8,ysize=8.,xoffset=0.25,encapsulated=0,/times,/ISOLATIN1
        endif else begin
           device,/portrait,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=.5,XSIZE=8,ysize=10.,xoffset=0.25,encapsulated=0,/times,/ISOLATIN1
        endelse
     endif else begin
        device,/landscape,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=10.6,XSIZE=10,ysize=7.5,xoffset=0.5,encapsulated=0,/times,/ISOLATIN1
     endelse
     !p.background = cmb_n_colors_0()-1
     !p.color = 0
     loadct,13
     thick=3.0
     !p.thick = thick & !x.thick = thick & !y.thick = thick
     !p.charthick = 3.0 & !p.charsize = 1.0
     !p.font = 0
     ;!p.font = 17
     ;!p.font =  -1 ;0 hardware font, -1 for Hershey character set
        nc = min([n_elements(r_curr),cmb_n_colors_0()])
   nc = cmb_n_colors_0()
  r_curr(0) = bottom & g_curr(0) = bottom
  b_curr(0) = bottom
  r_curr[nc-1] = top & g_curr[nc-1] = top
  b_curr[nc-1] = top
  tvlct, r_curr, g_curr, b_curr
end



pro cmb_encapsulatedpostscript,portrait=portrait,even=even
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
     set_plot, 'ps'
     if keyword_set(portrait) then begin
        if keyword_set(even) then begin
           device,/portrait,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=.5,XSIZE=8,ysize=8.,xoffset=0.25,encapsulated=1,/times,/ISOLATIN1
        endif else begin
           device,/portrait,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=.5,XSIZE=8,ysize=10.,xoffset=0.25,encapsulated=1,/times,/ISOLATIN1
        endelse
     endif else begin
        device,/landscape,bits=8,font_size=12,/color,/INCHES,$
		YOFFSET=10.6,XSIZE=10,ysize=7.5,xoffset=0.5,encapsulated=1,/times,/ISOLATIN1
     endelse
     loadct,13
     !p.background = cmb_n_colors_0()-1
     !p.color = 0
     loadct,13
     thick=3.0
     !p.thick = thick & !x.thick = thick & !y.thick = thick
     !p.charthick = 3.0 & !p.charsize = 1.0
     !p.font = 0
end

pro cmb_zbuf,portrait = portrait, xsize = xsize, ysize=ysize
;help,xsize,ysize
if n_elements(xsize) eq 0 then xsize = 800
if n_elements(ysize) eq 0 then ysize = xsize

if keyword_set(portrait) then ysize = xsize*8.5/11.
     set_plot,'z'
     ncolors = 256
     print,'in deviceopen 5, xsize,ysize=',xsize,ysize

     device,set_resolution=[xsize,ysize],set_colors=ncolors,set_char=[6,11] $
           ,z_buffering=0
     !p.background = cmb_n_colors_0()-1
     !p.color = 0
     loadct,13
     !p.thick = 1.0 & !x.thick = 1.0 & !y.thick = 1.0
     !p.charthick = 1.0 & !p.charsize = 1.0
     !p.font = -1 ; 0 ; hardware font, -1 for Hershey character set
End



pro cmb_plotsetup,dev,portrait=portrait,even=even, xsize = xsize, ysize=ysize
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
if n_elements(dev) ne 0 then dev=strlowcase(dev)

if keyword_set(dev) then begin
     if strlowcase(dev) eq 'z' then cmb_zbuf,portrait = portrait, xsize = xsize, ysize=ysize
     if strlowcase(dev) eq 'ps' then begin
        cmb_postscript,portrait=portrait,even=even
        return
     endif
     if dev eq 'eps' then begin
        cmb_postscript,portrait=portrait,even=even
        return   
     endif
endif else begin
	dev= 'xwin'
	idx = (where([ 'MacOS', 'Windows', 'unix' ] eq !version.os_family))[0]
	if idx eq 1 then set_plot,'WIN' else  set_plot,'X'
endelse

top = 255
bottom = 0

if dev eq 'xwin' then device,decomposed=0
loadct,13
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
;help,!d & stop
end
