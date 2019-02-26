pro rbsp_orbits_draw
  del_data,'*'
  yy='12' & mm='12' & dd='04' & sc='A' & clock_start='05:00' & clock_end='16:00' & duration=1
  del_data,'*'
  rbsp_init
  
  tr1=yy+'-'+mm+'-'+dd+'/'+clock_start
  tr2=yy+'-'+mm+'-'+dd+'/'+clock_end
  tsec1=time_double(tr1)
  tsec2=time_double(tr2)
  timespan,tsec1,tsec2-tsec1,/sec
  exist=0
  get_B0State,yy,mm,dd,sc,exist=exist
  get_data,'MLT_sm',data=dA_MLT
  get_data,'L_sm',data=dA_L
  get_data,'LAT_sm',data=dA_LAT
  
  index_nan=where((abs(da_lat.y) gt 5) or (da_l.y lt 2) or (da_l.x lt time_double('2012-12-04/05:57:51') and da_l.x gt time_double('2012-12-04/05:12:03')))
  da_l.y[index_nan]=0.0/0.0
  da_mlt.y[index_nan]=0.0/0.0
  
  sc='B'
  del_data,'*'
  rbsp_init
  timespan,tsec1,tsec2-tsec1,/sec
  exist=0
  get_B0State,yy,mm,dd,sc,exist=exist
  get_data,'MLT_sm',data=dB_MLT
  get_data,'L_sm',data=dB_L
  get_data,'LAT_sm',data=dB_LAT
  index_nan=where((abs(db_lat.y) gt 5) or (db_l.y lt 2) or (da_l.x lt time_double('2012-12-04/09:50:05') and da_l.x gt time_double('2012-12-04/09:16:17')))
  db_l.y[index_nan]=0.0/0.0
  db_mlt.y[index_nan]=0.0/0.0
  
  r=da_l.y
  theta=da_mlt.y/24*2*!pi
  set_plot,'ps'
  tplot_options,'xmargin',[15,15]
  device,filename='orbit.ps',/color, Bits_per_Pixel=8, xsize=18,ysize=18,xoffset=1,yoffset=1,set_font='Times',/TT_FONT
  !p.font=1 & !p.BACKGROUND='ffffff'xl & !p.color=0 & !p.multi=[0,2,2,0,0]
  loadct,39
  plot,r,theta,/polar,xrange=[-6,6],yrange=[-6,6],xstyle=1,ystyle=1,title='Van Allen Probe A',position=[0.1,0.1,0.4,0.4], $
    xtitle='X (R!DE!N)',ytitle='Y (R!DE!N)',xtickname=['6','4','2','0','-2','-4','-6'],ytickname=['6','4','2','0','-2','-4','-6']
  n=n_elements(r)
  for i=1,n-1 do begin
    oplot,r[i-1:i],theta[i-1:i],color=255.0/n*i,/polar
  endfor
  
  oplot,dblarr(100)+1.,dindgen(100)/99*2*!pi,/polar
  oplot,dblarr(100)+2.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+3.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+4.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+5.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  
  r=db_l.y
  theta=db_mlt.y/24*2*!pi
  plot,r,theta,/polar,xrange=[-6,6],yrange=[-6,6],xstyle=1,ystyle=1,title='Van Allen Probe B',position=[0.45,0.1,0.75,0.4],$
    xtitle='X (R!DE!N)',ytitle=' ',xtickname=['6','4','2','0','-2','-4','-6'],ytickname=[' ',' ',' ',' ',' ',' ',' ']
  n=n_elements(r)
  for i=1,n-1 do begin
    oplot,r[i-1:i],theta[i-1:i],color=255.0/n*i,/polar
  endfor
  
  oplot,dblarr(100)+1.,dindgen(100)/99*2*!pi,/polar
  oplot,dblarr(100)+2.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+3.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+4.,dindgen(100)/99*2*!pi,/polar,linestyle=2
  oplot,dblarr(100)+5.,dindgen(100)/99*2*!pi,/polar,linestyle=2
fsc_colorbar,divisions=10,maxrange=16,minrange=5,vertical=1,right=1, $
  ticknames=['05','06','07','08','09','10','11','12','13','14','15','16'],title='UT (h)',position=[0.78,0.1,0.8,0.4]
device,/close
  
end