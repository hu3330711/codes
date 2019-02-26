;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_pp_pos,nx,ny,ix,iy,ierase=ierase,position=position,ch=ch, no_increment=no_increment
if n_elements(position) ne 4 then position = [.1,.1,.9,.9]
if n_params() eq 0 then begin
   print,'usage: plot,.....,position= cmb_pp_pos_b(nx,ny,ipanel,ierase=ierase,position=position,ch=ch)
   print,'cmb_pp_pos_b,nx,ny,ipanel,ierase=ierase,position=position,ch=ch'
   print,'returns position on a panel on multi-panel nx by ny plot'
   print,';nx is the # of panels on x-axis'
   print,';ny is the # of panels on y-axis'
   print,';ipanel is the ipanel index for nx=1, 0 is the top panel'
   print,';position is the specifies panel boundaries on plot window'
   print,';ch is the normalize spacing between panels, default is 0.05'
   return,position
endif

if ny*nx eq 1 then return,position
if n_elements(ch) eq 0 then ch = 2./40.
if n_elements(ipanel) eq 0 then ipanel = 0

x0 = position[0]
x1 = position[2]
y0 = position[1]
y1 = position[3]

dx = (x1-x0 - (nx-1)*ch)/nx
dy = (y1-y0 - (ny-1)*ch)/ny

xa = x0 +ix*(dx+ch)
xb = xa + dx

yb = y1 -iy*(dy+ch)
ya = yb -dy
if keyword_set(no_increment) eq 0 then ipanel = ipanel + 1
return,[xa,ya,xb,yb]
end
