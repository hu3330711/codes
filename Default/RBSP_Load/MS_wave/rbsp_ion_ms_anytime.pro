pro rbsp_ion_ms_anytime
  fre_min=10
  fre_max=300
  
  yy='13' & mm='06' & dd='29' & sc='A' & clock_start='00:00' & clock_end='24:00' & duration=1
  
  del_data,'*'
  rbsp_init
  set_plot,'X'
  !P.background='ffffff'xl
  !p.COLOR=0
  !p.CHARSIZE=1.5
  tplot_options,'xmargin',[15,15]
  
  tr1=yy+'-'+mm+'-'+dd+'/'+clock_start
  tr2=yy+'-'+mm+'-'+dd+'/'+clock_end
  tsec1=time_double(tr1)
  tsec2=time_double(tr2)
  timespan,tsec1,tsec2-tsec1,/sec
  exist=0
  get_ProtonFluxPSD,yy,mm,dd,sc,exist=exist
  stop
  kyoto_load_ae
  options,'kyoto_ae',ytitle='AE!C',ysubtitle='(nT)'
  get_B0State,yy,mm,dd,sc,exist=exist
  get_position_gsm_sm,yy,mm,dd,sc
  get_WaveEB,yy,mm,dd,sc,exist=exist
  get_waveproperty,yy,mm,dd,sc,exist=exist
  tinterpol_mxn,'Magnitude','PSD_05',newname='Magnitude'
  tinterpol_mxn,'fce_eq','PSD_05',newname='fce_eq'
  get_HFRDensity,yy,mm,dd,sc,exist=exist,load_density=0  ;;;modify get_fuhrDensityEa for different cases
  tinterpol_mxn,'MLT_sm','PSD_05',newname='MLT'
  tinterpol_mxn,'L_sm','PSD_05',newname='L'
  tinterpol_mxn,'LAT_sm','PSD_05',newname='LAT'
  tinterpol_mxn,'kyoto_ae','PSD_05',newname='kyoto_ae'
  tinterpol_mxn,'BwaveIntensity','PSD_05',newname='BwaveIntensity'
  tinterpol_mxn,'EwaveIntensity','PSD_05',newname='EwaveIntensity'
  ;  if duration eq 2 then TwoDayData,yy,mm,dd,sc,exist=exist
  ;  get_ms_bfield_strength
  
 ; get_pp_from_hfr_fce
  if exist eq 0 then return
  store_data,'PSD_combo',data=['PSD_05','AlfvenEnergy']
  zlim,'BwaveIntensity_combo',1e-8,1e-4
  ylim,'BwaveIntensity_combo',1e1,1e3
  zlim,'PSD_combo',1e-16,1e-12
  ylim,'PSD_combo',1e2,5e4
  ylim,'Density',1e1,3e3,1
  ylim,'kyoto_ae',1,1,0
  options,'ellsvd',ztitle='Ellipticity'
  ;  options,'phsvd',ztitle='Phi -180 - 180!C!C(deg)'
  options,'thsvd',ztitle='theta!C!C(deg)'
  
  ylim,'PSD_combo',1e2,5e4,1
  zlim,'PSD_combo',1e-16,1e-10,1
  zlim,'EwaveIntensity_combo',1e-12,1e-8
  zlim,'BwaveIntensity_combo',1e-6,1e-2
  time_stamp,/off
    window,xsize=1000,ysize=1000
  ;  tlimit,yy+'-'+mm+'-'+dd+'/10:00',yy+'-'+mm+'-'+dd+'/12:00'
    tplot,['HFR_Spectra_combo','pp','Density','PSD_combo','EwaveIntensity_combo','BwaveIntensity_combo','BwaveStrength','thsvd','ellsvd'],var_label=['MLT','L','LAT'],title='Van Allen Probe '+sc
    makepng,yy+mm+dd+'RB'+sc
  
;  store_data,'BwaveIntensity_combo',data=['BwaveIntensity','fLHR','fcp_eq']
;  zlim,'HFR_Spectra_combo',1e-17,1e-14,1
;  zlim,'PSD_combo',3e-17,3e-14,1
;  ylim,'PSD_combo',5e2,5e4,1
;  ylim,'EwaveIntensity_combo',fre_min,fre_max,1
;  ylim,'BwaveIntensity_combo',fre_min,fre_max,1
;  zlim,'BwaveIntensity_combo',1e-7,1e-4,1
;  ylim,'thsvd',fre_min,fre_max,1
;  ylim,'ellsvd',fre_min,fre_max,1
;  ylim,'BwaveStrength',2e1,2e3,1
;  time_stamp,/off
;  options,'thsvd',ztitle='Wave normal angle!C!C (!Uo!N)'
;  options,'fLHR',colors='w',thick='2',linestyles='0'
;  options,'fcp_eq',colors='w',thick='2',linestyles='2'
;  options,'BwaveIntensity_conbo',ytitle='Frequency (Hz)',ztitle='B!Dw!N Intensity (nT!U2!N/Hz)'
;  set_plot,'ps'
;  device,filename=yy+mm+dd+'RB'+sc+'.ps',/color,bits_per_pixel=8,/times,xsize=18,ysize=22,xoffset=0,yoffset=1
;  !p.FONT=0
;  !p.BACKGROUND='ffffff'xl
;  !p.color=0
;  !p.charsize=1
;  !p.CHARTHICK=1
;  !p.THICK=1
;  loadct,39
;  tplot,['HFR_Spectra_combo','PSD_combo','EwaveIntensity_combo','BwaveIntensity_combo','thsvd','ellsvd'],$
;    var_label=['MLT','L','LAT'],title='Van Allen Probe '+sc
;  device,/close
end