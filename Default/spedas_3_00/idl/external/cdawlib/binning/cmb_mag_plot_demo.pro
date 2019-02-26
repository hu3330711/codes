;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_mag_plot_demo,jdr, cl, vmag,vvec,posv, scname,pos=pos,noerase=noerase,b0max=b0max
tnames = tag_names(cl)
isatmag = cmb_tag_name_exists(vmag,cl,ivm)
isat = cmb_tag_name_exists(vvec+'_nbin',cl,ivbin)
if isat ne 1 then return
isat = cmb_tag_name_exists(vvec,cl,iv)
isatpos = cmb_tag_name_exists(posv,cl,ivp)
;help,ivm,iv,ip,ivbin
ii = where((cl.(ivbin))[0,*] ne 0)
re=6371.2
  jd = cl.jd[ii]
  b = (cl.(iv))[*,ii]
  if isatmag then b0 = (cl.(ivm))[ii] else b0 = sqrt(total(b^2,1))
  if isatpos then p = (cl.(ivp)[*,ii])/re ;else p = b*0.
  title=scname
;help,title,jd,b0,b,p  
idetrend=0
;read,'input 1 to detrend data:', idetrend
if idetrend then begin
   nsum = 1000/6
   b0 = cmb_simple_detrend(jd,b0, nsum)
   for ic=0,2 do b[ic,*] = cmb_simple_detrend(jd,reform(b[ic,*]), nsum )
endif

charsize=1.25
tr = cmb_date([min(jd),max(jd)],/time_in_julday,format='yyyy ddd (mm/dd) hh:mm')
title= title + ' ' + tr[0] + ' to ' + tr[1]
if isatpos then begin
r = sqrt(total(p^2,1))
mlat = reform(!radeg*asin(p[2,*]/r))
mlt = reform((atan(p[1,*],p[0,*])*12/!pi + 12) mod 24)
atimeaxis = {time:jd,r:r, mlat:mlat,mlt:mlt,labels:['hh:mm:ss','r(re)','latgse(degrees)','mlt(hours)']}
endif else atimeaxis = {time:jd}
dummy = cmb_label_date(xaxis_info=atimeaxis) ;store x axis information for labelling
ytitle='B (nT)'

if keyword_set(b0max) eq 0 then b0max = max(b0)

plot,jd,b0,yr=[-1,1]*b0max,xtickformat='cmb_label_date', pos =pos,charsize=charsize,ytitle=ytitle,title=title,noerase=noerase,xr=jdr,xstyle=1
oplot,!x.crange,[1,1],linestyle=1
oplot,jd,-b0
colors=[250,120,80]
for ic=0,2 do oplot, jd,b[ic,*], color= colors[ic]
cmb_label_pos_label;,charsize=charsize
end
