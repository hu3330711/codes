;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_xryr_to_pix,xr,yr
if n_elements(xr) eq 0 then xr = cmb_crange(/x)
if n_elements(yr) eq 0 then yr = cmb_crange(/y)
u = convert_coord(xr,yr,/data,/to_device)
xrpix = [u[0,0],u[0,1]]
yrpix = [u[1,0],u[1,1]]
dxpix = xrpix[1]-xrpix[0]
dypix = yrpix[1]-yrpix[0]
return,{xrpix:xrpix,yrpix:yrpix,dxpix:dxpix,dypix:dypix}
end
