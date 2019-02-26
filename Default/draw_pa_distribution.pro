PRO draw_pa_distribution,varname=varname,trange1=trange1,trange2=trange2,trange3=trange3,eng=eng

get_data,varname,data=tmp,dlim=dlim

good1=where(time_double(tmp.x) ge time_double(trange1[0]) and time_double(tmp.x) le time_double(trange1[1]),count1)
good2=where(time_double(tmp.x) ge time_double(trange2[0]) and time_double(tmp.x) le time_double(trange2[1]),count2)
good3=where((time_double(tmp.x) ge time_double(trange3[0])) and (time_double(tmp.x) le time_double(trange3[1])),count3)

pa=reform(tmp.v[1,*])
flux1=dblarr(n_elements(tmp.v[1,*]))
flux2=dblarr(n_elements(tmp.v[1,*]))
flux3=dblarr(n_elements(tmp.v[1,*]))

for i=0,n_elements(tmp.v[1,*])-1 do begin
  flux1[i]=mean(tmp.y[good1,i],/nan) 
  flux2[i]=mean(tmp.y[good2,i],/nan) 
  flux3[i]=mean(tmp.y[good3,i],/nan)
endfor

yrange=[1e3,1e6]
st=time_string(trange1[0])
yy=strmid(st,0,4)
mm=strmid(st,5,2)
dd=strmid(st,8,2)
tt=strmid(st,11,2)

popen,'/projectnb/burbsp/home/xcshen/'+yy+mm+dd+'T'+tt+'_'+strtrim(string(round(eng),format='(I4)'),1),/encapsulated,xsize=6,ysize=6,units=cm

plot,pa,flux1,xrange=[0,90],yrange=yrange,xstyle=1,ystyle=1,/ylog,xtitle='Pitch Angle (degrees)',ytitle='Flux (s!U-1!Nsr!U-1!Ncm!U-2!NkeV!U-1!N)',title=string(round(eng),format='(I4)')+' keV '+strmid(trange1[0],0,10),thick=3
oplot,pa,flux2,thick=3,color=50
oplot,pa,flux3,thick=3,color=250

get_data,'local_loss_cone_sm',data=tmp
good=where(time_double(tmp.x) ge time_double(trange1[0]) and time_double(tmp.x) le time_double(trange3[1]))
losscone=median(tmp.y[good])
oplot,[losscone,losscone],yrange,thick=3,linestyle=2
xyouts,losscone+1,0.5*(yrange[0]+yrange[1]),'Loss cone: '+strtrim(string(round(losscone),format='(I3)'),1)+' degrees',charsize=1

xyouts,65,7e5,strmid(trange1[0],11,5)+'--'+strmid(trange1[1],11,5)+'UT',charsize=1,color=0
xyouts,65,6e5,strmid(trange2[0],11,5)+'--'+strmid(trange2[1],11,5)+'UT',charsize=1,color=50
xyouts,65,5.2e5,strmid(trange3[0],11,5)+'--'+strmid(trange3[1],11,5)+'UT',charsize=1,color=250

pclose

return
END

