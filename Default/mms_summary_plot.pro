pro mms_summary_plot
  n_events=56l
  dir='/projectnb/burbsp/home/QM/project/LappingEvents_rbsp/'

  for index_event=1,n_events do begin
    sc=' '
    tst0=' '
    openr,lun,dir+'MMS_RBSP_Lapping.txt',/get_lun
    for ii=1,index_event do readf,lun,tst0,sc,format='(A16,4X,A1)'
    free_lun,lun
    yy0=strmid(tst0,2,2)
    mm0=strmid(tst0,5,2)
    dd0=strmid(tst0,8,2)
    tst1=time_string(time_double(tst0)-30l*60l)
    dd1=strmid(tst1,8,2)
    if dd1 ne dd0 then tst1='20'+yy0+'-'+mm0+'-'+dd0+'/00:00'
    tst2=time_string(time_double(tst0)+30l*60l)
    dd2=strmid(tst2,8,2)
    if dd2 ne dd0 then tst2='20'+yy0+'-'+mm0+'-'+dd0+'/24:00'
    delta_t_sec=time_double(tst2)-time_double(tst1)

    del_data,'*'
    mms_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/mms/'
    loadct,43,file='/project/burbsp/small/QM/library/IDL/colortable/colors1.tbl'
    timespan, '20'+yy0+'-'+mm0+'-'+dd0,1,/day

    mms_load_state, probes=1, level='def', datatypes='pos'
    mms_load_fgm, probes=1

    tinterpol,'mms1_mec_mlat','mms1_fgm_b_gsm_srvy_l2_btot',newname='mms1_mec_mlat_int'
    calc,"'mms1_fgm_b_gsm_srvy_l2_beq'='mms1_fgm_b_gsm_srvy_l2_btot'*sqrt(1+3*(sin('mms1_mec_mlat_int'/180*3.1415926))^2)/(cos('mms1_mec_mlat_int'/180*3.1415926))^6"
    calc,"'fce_eq'=1.602e-19*'mms1_fgm_b_gsm_srvy_l2_beq'*1e-9/0.9019e-30/2/3.1415926"
    calc,"'fce_eq_double'='fce_eq'*2"
    calc,"'fce_eq_half'='fce_eq'/2"
    calc,"'fce_eq_tenth'='fce_eq'/10"
    calc,"'fLH_eq'='fce_eq'/43"
    calc,"'fcp_eq'=1.602e-19*'mms1_fgm_b_gsm_srvy_l2_beq'*1e-9/1.6727e-27/2/3.1415926"
    calc,"'fcHe_eq'='fcp_eq'/4"
    calc,"'fcO_eq'='fcp_eq'/16"
    options,['fce_eq','fcp_eq'],linestyle=0,color=255,labflag=0,thick=3
    options,['fLH_eq','fce_eq_*','fcHe_eq','fcO_eq'],linestyle=2,color=255,labflag=0,thick=3

    mms_load_dsp, data_rate='fast', probes=1, datatype=['epsd','bpsd'], level='l2'
    if tnames('mms1_dsp_epsd_omni') eq 'mms1_dsp_epsd_omni' and tnames('mms1_dsp_epsd_omni_fast_l2') eq '' $
      then tplot_rename,'mms1_dsp_epsd_omni','mms1_dsp_epsd_omni_fast_l2'
    mms_load_dsp, data_rate='slow', probes=1, datatype=['epsd','bpsd'], level='l2'
    if tnames('mms1_dsp_epsd_omni') eq 'mms1_dsp_epsd_omni' and tnames('mms1_dsp_epsd_omni_slow_l2') eq '' $
      then tplot_rename,'mms1_dsp_epsd_omni','mms1_dsp_epsd_omni_slow_l2'
    options,'mms1_mec_mlat',ytitle='LAT'
    options,'mms1_mec_mlt',ytitle='MLT'
    options,'mms1_mec_l_dipole',ytitle='L'
    options,['mms1_dsp_epsd_omni_fast_l2','mms1_dsp_epsd_omni_slow_l2'],yrange=[30,1e5],/ylog,zrange=[1e-10,1e-5],/zlog,ystyle=1,zstyle=1,ytickformat='exponent'
    options,['mms1_dsp_bpsd_omni_fast_l2','mms1_dsp_bpsd_omni_slow_l2'],yrange=[30,1e4],/ylog,zrange=[ 1e-9,1e-4],/zlog,ystyle=1,zstyle=1,ytickformat='exponent'


    scm_data_rate = 'srvy';'brst';'srvy'
    scm_datatype = 'scsrvy';'scb';'scsrvy'
    mms_load_scm, probes=1, level='l2', data_rate=scm_data_rate, datatype=scm_datatype
    scm_name = 'mms1_scm_acb_gse_'+scm_datatype+'_'+scm_data_rate+'_l2'
    if scm_datatype eq 'scb' then nboxpoints_input = 8192 else nboxpoints_input = 512
    tdpwrspc, scm_name, nboxpoints=nboxpoints_input,nshiftpoints=nboxpoints_input,bin=1
    calc,"'mms1_scm_scsrvy_srvy_l2_dpwrspc'='mms1_scm_acb_gse_scsrvy_srvy_l2_x_dpwrspc'+'mms1_scm_acb_gse_scsrvy_srvy_l2_y_dpwrspc'+'mms1_scm_acb_gse_scsrvy_srvy_l2_z_dpwrspc'"
    if scm_datatype eq 'scsrvy' then ylim, scm_name+'*_dpwrspc',0.5,16,1
    if scm_datatype eq 'scb' then ylim, scm_name+'*_dpwrspc',1,4096,1
    if scm_datatype eq 'schb' then ylim, scm_name+'*_dpwrspc',32,8192,1

    store_data,'Ew_fast_comb',data=['mms1_dsp_epsd_omni_fast_l2','fce_eq','fce_eq_double','fce_eq_half','fce_eq_tenth','fLH_eq','fcp_eq','fcHe_eq','fcO_eq']
    store_data,'Ew_slow_comb',data=['mms1_dsp_epsd_omni_slow_l2','fce_eq','fce_eq_double','fce_eq_half','fce_eq_tenth','fLH_eq','fcp_eq','fcHe_eq','fcO_eq']
    store_data,'Bw_fast_comb',data=['mms1_dsp_bpsd_omni_fast_l2','fce_eq','fce_eq_double','fce_eq_half','fce_eq_tenth','fLH_eq','fcp_eq','fcHe_eq','fcO_eq']
    store_data,'Bw_slow_comb',data=['mms1_dsp_bpsd_omni_slow_l2','fce_eq','fce_eq_double','fce_eq_half','fce_eq_tenth','fLH_eq','fcp_eq','fcHe_eq','fcO_eq']
    store_data,'Bw_survey_comb',data=['mms1_scm_scsrvy_srvy_l2_dpwrspc','fce_eq','fce_eq_double','fce_eq_half','fce_eq_tenth','fLH_eq','fcp_eq','fcHe_eq','fcO_eq']
    options,'?w_*_comb',/ylog,/zlog,ystyle=1,zstyle=1,ytickformat='exponent',ztickformat='exponent',ysubtitle=''

    options,'Ew_fast_comb',ytitle='Ew!C!CFrequency [Hz]',yrange=[30,1e5],zrange=[1e-10,1e-5],ztitle='(V/m)!U2!N/Hz'
    options,'Ew_slow_comb',ytitle='Ew!C!CFrequency [Hz]',yrange=[30,1e5],zrange=[1e-10,1e-5],ztitle='(V/m)!U2!N/Hz'
    options,'Bw_fast_comb',ytitle='Bw!C!CFrequency [Hz]',yrange=[30,1e4],zrange=[ 1e-9,1e-4],ztitle='nT!U2!N/Hz'
    options,'Bw_slow_comb',ytitle='Bw!C!CFrequency [Hz]',yrange=[30,1e4],zrange=[ 1e-9,1e-4],ztitle='nT!U2!N/Hz'
    options,'Bw_survey_comb',ytitle='Bw!C!CFrequency [Hz]',yrange=[0.5,16],zrange=[ 1e-4,1e0],ztitle='nT!U2!N/Hz'

    set_plot,'ps'
    !p.background='ffffff'xl
    !p.color=0
    !p.font=0
    !p.charsize=0.9
    !p.charthick=0.9
    device,filename=dir+'/MMSDataOverview/MMS1_full_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.ps',/color, Bits_per_Pixel=8, xsize=21,ysize=24,/times,xoffset=0.3,yoffset=0.3
    ;  tplot,['mms1_fgm_b_gsm_srvy_l2_bvec','mms1_dsp_epsd_omni_fast_l2','mms1_dsp_bpsd_omni_fast_l2','mms1_dsp_epsd_omni_slow_l2','mms1_dsp_bpsd_omni_slow_l2',$
    ;    'mms1_scm_scsrvy_srvy_l2_dpwrspc'],var_label=['mms1_mec_mlat','mms1_mec_mlt','mms1_mec_l_dipole']
    tplot,['Ew_fast_comb','Ew_slow_comb','Bw_fast_comb','Bw_slow_comb','Bw_survey_comb'],var_label=['mms1_mec_mlat','mms1_mec_mlt','mms1_mec_l_dipole']
    timebar,tst0
    device,/close
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+dir+'/MMSDataOverview/MMS1_full_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.ps '+$
      dir+'/MMSDataOverview/MMS1_full_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.png'
    

    set_plot,'ps'
    !p.background='ffffff'xl
    !p.color=0
    !p.font=0
    !p.charsize=0.9
    !p.charthick=0.9
    device,filename=dir+'/MMSDataOverview/MMS1_zoom_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.ps',/color, Bits_per_Pixel=8, xsize=21,ysize=24,/times,xoffset=0.3,yoffset=0.3
    tlimit,tst1,tst2
   timebar,tst0
    device,/close
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+dir+'/MMSDataOverview/MMS1_zoom_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.ps '+$
      dir+'/MMSDataOverview/MMS1_zoom_'+yy0+mm0+dd0+'_'+string(index_event,format='(I4.4)')+'.png'
  endfor
end
