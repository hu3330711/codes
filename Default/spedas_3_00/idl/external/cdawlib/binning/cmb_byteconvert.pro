;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_byteconvert,data0,zrange=zrange,fill=fill,color_index=color_index $
	,takelog=takelog ,czrange = czrange,bfill=white,color_fill=color_fill
;convert 2d data array into a byte array
common ct_top_bot,top0,bot0      
data = data0
nsize = size(data)
if n_elements(fill) eq 0 then fill = -1e31
white = !p.background
ifill = where(data eq fill)
if n_elements(ifill) eq n_elements(data) and ( data[0] eq fill)  then begin
   bdata = data*0 + white
   return,bdata
endif
nofill = where(data ne fill)
if keyword_set(takelog) then $
	if nofill(0) ne -1 then data(nofill)=alog10(data(nofill))
if( n_elements(zrange) eq 2)then begin
    dmin = zrange(0)
    dmax = zrange(1)
endif else dmax = max(data(nofill), min=dmin)
czrange = [dmin,dmax]

;print,'in cmb_byteconvert:zrange:',zrange
if n_elements(color_index) eq 2 then begin
   bot = byte(color_index(0))
   top = color_index(1)-color_index(0)
endif else begin
   bot = 1B
   top = !d.table_size-2
endelse

if n_elements(top0) ne 0 then top = top0
if n_elements(bot0) ne 0 then bot = bot0 

bdata = bytscl(data,min=dmin,max=dmax,top = top-1 )+bot

if n_elements(color_fill) eq 0  then color_fill = white
;help,ifill,color_fill
if(ifill[0] ne -1)then bdata[ifill]=color_fill ;set fill data to color_fill 
;print,' #fill,#pts=',n_elements(ifill),n_elements(bdata)
;print,' min and max of byte data=',min(bdata),max(bdata)
return,bdata
end
