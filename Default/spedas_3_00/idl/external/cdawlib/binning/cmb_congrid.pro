;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_congrid,data,xdata,ydata

yrdata = cmb_crange(/y)
xrdata = cmb_crange(/x)
nx = n_elements(xdata)
ny = n_elements(ydata)


ix = where(xdata ge xrdata[0] and xdata le xrdata[1])
iy = where(ydata ge yrdata[0] and ydata le yrdata[1])
b=data[*,iy]
b = data[ix,*]
nx = n_elements(ix)
ny = n_elements(iy)
;help,ix,iy,b


xrb = [min(xdata[ix]),max(xdata[ix])]
yrb = [min(ydata[iy]),max(ydata[iy])]


;xpix = convert_coord(xdata,1+xdata*0,/data,/to_device) & xpix= reform(xpix[0,*])
;ypix = convert_coord(ydata*0.+1,ydata,/data,/to_device) & ypix= reform(ypix[1,*])

v = cmb_xryr_to_pix(xrb,yrb)
xr = v.xrpix
yr = v.yrpix
ytype=!y.type
xtype=!x.type

nx0 = cmb_dt_calc(xr,/noadd)+1
ny0 = cmb_dt_calc(yr,/noadd)+1
x0 = lindgen(nx0)*1 + xr[0]
y0 = lindgen(ny0)*1.+ yr[0]

d = fltarr(nx0,ny0)
ix = nx/v.dxpix*lindgen(nx0)
;iy = ny/v.dypix*lindgen(ny0)
;xdatapts = convert_coord(xr[0]+ix,0,0,/device,/to_data) & xdatapt = reform( xdatapt[0,*])
;ydatapts = convert_coord(xr[0]+ix,0,0,/device,/to_data) & xdatapt = reform( xdatapt[0,*])
for iy0=0l,ny0-1 do begin
    iy = ny/v.dypix*iy0
    ydatapt = convert_coord(1,yr[0]+iy0,/device,/to_data) & ydatapt= reform(ydatapt[1,*])
    ydatapt = ydatapt[0]
    ;print,'ydatapt, iy:',ydatapt,iy
    dummy = min(abs(ydata-ydatapt),iy )
    d[*,iy0] = b[ix,iy]
endfor
return,d
end
