;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_adjust_screen_size,xsize,ysize
;check is plot fits in the computer screen, if not adjust xsize and ysize

scrsize = get_screen_size()
ysize0 = scrsize[1]*0.9
xsize0 = scrsize[0]*0.4

if n_elements(xsize) eq 0 then xsize=xsize0
if n_elements(ysize) eq 0 then ysize=ysize0
if xsize gt xsize0 then xsize=xsize0
if ysize gt ysize0 then ysize=ysize0

end
