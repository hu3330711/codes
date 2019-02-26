;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
Pro cmb_colorbar,zscale,ytitle,zlog = zlog,ctickname=ctickname $
;this code was modified by SAB from the cdaweb colorbar.pro
      ,xloc=xloc,ycharsize=ycharsize,yscale=yscale,yoffset=yoffset $
      ,cmap=cmap,xfrac=xfrac,yfrac=yfrac, pos = pos
cmb_save_scales_2,ascale
if n_elements(pos) eq 4 then plot,/noerase,/nodata,[0.,.1],[0.,1.],xstyle=4,ystyle=4,pos=pos
;xloc location of color bar on x axis in physical units
; plot the colorbar
ywindow_old = !y.window
if(n_elements(cmap) eq 0 )then cmap = 1
if(n_elements(xfrac) eq 0 )then xfrac = 1.
if(n_elements(yfrac) eq 0 )then yfrac = 1.
if(n_elements(yscale) eq 0)then yscale =.6
if(n_elements(yoffset) eq 0) then yoffset = 0. 
if(n_elements(ycharsize) eq 0) then ycharsize=1
if( n_elements(ctickname) eq 0 ) then ctickname = strarr(30)
if n_elements(zlog) eq 0 then zlog=0
if zlog eq 1 then zscale = 10^zscale
;common deviceTypeC, deviceType
case !d.name of ;add SAB
('X'):devicetype=0
('WIN'):devicetype=0
'Z':devicetype=5
'PS':devicetype=1
endcase
common ct_top_bot,top0,bot0 
if n_elements(top0) ne 0 then top = top0 else top = !d.table_size-1
if n_elements(bot0) ne 0 then bot = bot0 else bot = 1b
ncolors = top -2 
colors = bindgen(ncolors)+bot
if n_elements(devicetype) ne 0 then $
if (deviceType eq 2) then colors = !d.table_size-1b - colors
if n_elements(cmap) gt 1 then colors = cmap + bot
if n_elements(xloc) eq 0 then begin
   dy = (!y.window(1)-!y.window(0))/ncolors*yfrac
   dybar = (!y.window(1)-!y.window(0))*yfrac
   x0 = !x.window(1) 
   dxw = !x.window[1]-!x.window[0]
   x01 = dxw/36.
   x02 = dxw/36.*xfrac*2.
   ;xpt = x0 + [.02,.04,.04,.02]*xfrac
;   help,dxw,x0,x01,x02
   xpt = x0 + [x01,x02,x02,x01]
   y0 = !y.window(0) + yoffset*(!y.window(1)-!y.window(0))
   y0 = total(!y.window)/2 - dybar/2
   !y.window = y0 + [0.,dybar]
   ypt = y0 + [.0,.0,1.,1.]*dy
endif else begin
   dxwin = !x.window(1) - !x.window(0)
   dxran = !x.crange(1) - !x.crange(0)
   x0 = dxwin/dxran*(xloc-!x.crange(0)) + !x.window(0)
   xpt = x0 + [0,1,1,0]*.01 + .01
   dywin = !y.window(1) - !y.window(0)
   y0 = !y.window(0) + dywin*(1-yscale)/2. + yoffset
   y1 = !y.window(0) + dywin*(1+yscale)/2. + yoffset
   !y.window = [y0,y1] 
   dywin = !y.window(1) - !y.window(0)
   dy = dywin/ncolors
   ypt = y0 + [.0,.0,1.,1.]*dy
endelse
for i=0,ncolors-1 do polyfill,xpt,ypt+i*dy,/norm,color = colors(i)
axis,xpt(1),/norm,yaxis=1,ystyle=1,ytype = zlog $
   ,yrange =zscale, ticklen=-0.0075,ytitle=ytitle,ycharsize=ycharsize $
   ,yminor=2,ytickname=ctickname ;$
!y.window = ywindow_old
cmb_save_scales_2,ascale,/irestore
END

