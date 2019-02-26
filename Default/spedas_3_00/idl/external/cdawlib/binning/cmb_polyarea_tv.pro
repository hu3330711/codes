;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_polyarea_tv,a,x,y,fill=fill, takelog=takelog, zr=sr, add_colorbar=add_colorbar, ctitle=ctitle, cb_charsize=cb_charsize, _extra=extra
;Caveat Emptor: this code was written by Scott Boardsen, Heliophysics Division, NASA/GSFC and UMBC/GPHI.
;inputs
;a=image(nx,ny)
;x = x(nx)
;y = y(ny)
if !d.name eq 'PS' then begin
   cmb_polyarea,a,x,y,fill=fill, takelog=takelog, zr=sr, add_colorbar=add_colorbar, ctitle=ctitle, cb_charsize=cb_charsize, _extra=extra
   return
endif
xrc = cmb_crange(/x)
yrc = cmb_crange(/y)
ix = where(x ge xrc[0] and x le xrc[1])
iy = where(y ge yrc[0] and y le yrc[1])
b=a[*,iy]
b = b[ix,*]
;help,ix,iy,b
xrb = [min(x[ix]),max(x[ix])]
yrb = [min(y[iy]),max(y[iy])]
v = cmb_xryr_to_pix(xrb,yrb)
;help,ix,iy,v
d = cmb_congrid(a,x,y)
;d0 = congrid(b, v.dxpix,v.dypix,_extra=extra)
a0 = cmb_byteconvert(takelog=takelog, d, zr=sr,czr=czr,fill=fill)
tv,a0,v.xrpix[0],v.yrpix[0]
if keyword_set(add_colorbar) then cmb_colorbar,czr,ctitle,yfrac=.9,xfrac=.8,ycharsize=cb_charsize
end
