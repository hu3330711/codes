pro localPa2eqpa
lam=5.
localpa=findgen(90)+1


    set_plot,'ps'
    device,filename='localPa2eqpa.ps',/color,bits_per_pixel=8,/times,xsize=18,ysize=18,xoffset=2,yoffset=2
    !p.FONT=0
    !p.BACKGROUND='ffffff'xl
    !p.color=0
    loadct,39
plot,fltarr(10),xrange=[0,90],yrange=[0,30],position=[0.1,0.1,0.9,0.9],xtitle='Local PA',ytitle='Local PA - Equator PA'
for index_lam=0,4 do begin
  lam=double(index_lam+1)*2.5
lam_rad=lam/180.*!pi
localpa_rad=localpa/180.*!pi
eqpa_rad=asin(sin(localpa_rad)*(cos(lam_rad))^3/sqrt(sqrt(1.+3.*(sin(lam_rad))^2)))
eqpa=eqpa_rad/!pi*180.
oplot,localpa,localpa-eqpa,color=index_lam*60
endfor

legend_draw,['LAT 2.5!Uo!N','LAT 5!Uo!N','LAT 7.5!Uo!N','LAT 10!Uo!N','LAT 12.5!Uo!N'],/left,/top,color=findgen(5)*60,linestyle=0,charsize=1
device,/close


end