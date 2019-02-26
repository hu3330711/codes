pro mms_survey,probe=probe,trange=trange

    plot_init,'ps'
    ttmp=time_string(time_double(trange))

    yy0=strmid(ttmp[0],2,2)
    mm0=strmid(ttmp[0],5,2)
    dd0=strmid(ttmp[0],8,2)
    time=strmid(ttmp[0],11,2)
    dt=time_double(ttmp[1])-time_double(ttmp[0])
    
    dir='/projectnb/burbsp/home/xcshen/'
    
    del_data,'*'
    mms_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/mms/'
    loadct,43,file='/project/burbsp/small/QM/library/IDL/colortable/colors1.tbl'
    timespan, ttmp[0],dt,/seconds

    mms_load_state, probes=probe, level='def', datatypes='pos'
    mms_load_fgm, probes=probe
stop
    tinterpol,'mms'+probe+'_mec_mlat','mms'+probe+'_fgm_b_gsm_srvy_l2_btot',newname='mms'+probe+'_mec_mlat_int'
  
  if probe eq 1 then begin
    calc,"'mms1_fgm_b_gsm_srvy_l2_beq'='mms1_fgm_b_gsm_srvy_l2_btot'*sqrt(1+3*(sin('mms1_mec_mlat_int'/180*3.1415926))^2)/(cos('mms1_mec_mlat_int'/180*3.1415926))^6"
    calc,"'fce_eq'=1.602e-19*'mms1_fgm_b_gsm_srvy_l2_beq'*1e-9/0.9019e-30/2/3.1415926"
    calc,"'fcp_eq'=1.602e-19*'mms1_fgm_b_gsm_srvy_l2_beq'*1e-9/1.6727e-27/2/3.1415926"
  endif
  
  if probe eq 2 then begin
    calc,"'mms2_fgm_b_gsm_srvy_l2_beq'='mms2_fgm_b_gsm_srvy_l2_btot'*sqrt(1+3*(sin('mms2_mec_mlat_int'/180*3.1415926))^2)/(cos('mms2_mec_mlat_int'/180*3.1415926))^6"
    calc,"'fce_eq'=1.602e-19*'mms2_fgm_b_gsm_srvy_l2_beq'*1e-9/0.9019e-30/2/3.1415926"
    calc,"'fcp_eq'=1.602e-19*'mms2_fgm_b_gsm_srvy_l2_beq'*1e-9/1.6727e-27/2/3.1415926"
  endif
 
  if probe eq 3 then begin
    calc,"'mms3_fgm_b_gsm_srvy_l2_beq'='mms3_fgm_b_gsm_srvy_l2_btot'*sqrt(1+3*(sin('mms3_mec_mlat_int'/180*3.1415926))^2)/(cos('mms3_mec_mlat_int'/180*3.1415926))^6"
    calc,"'fce_eq'=1.602e-19*'mms3_fgm_b_gsm_srvy_l2_beq'*1e-9/0.9019e-30/2/3.1415926"
    calc,"'fcp_eq'=1.602e-19*'mms3_fgm_b_gsm_srvy_l2_beq'*1e-9/1.6727e-27/2/3.1415926"
  endif
  
  if probe eq 4 then begin
    calc,"'mms4_fgm_b_gsm_srvy_l2_beq'='mms4_fgm_b_gsm_srvy_l2_btot'*sqrt(1+3*(sin('mms4_mec_mlat_int'/180*3.1415926))^2)/(cos('mms4_mec_mlat_int'/180*3.1415926))^6"
    calc,"'fce_eq'=1.602e-19*'mms4_fgm_b_gsm_srvy_l2_beq'*1e-9/0.9019e-30/2/3.1415926"
    calc,"'fcp_eq'=1.602e-19*'mms4_fgm_b_gsm_srvy_l2_beq'*1e-9/1.6727e-27/2/3.1415926"
  endif
  
    calc,"'fce_eq_double'='fce_eq'*2"
    calc,"'fce_eq_half'='fce_eq'/2"
    calc,"'fce_eq_tenth'='fce_eq'/10"
    calc,"'fLH_eq'='fce_eq'/43"
    calc,"'fcHe_eq'='fcp_eq'/4"
    calc,"'fcO_eq'='fcp_eq'/16"

    options,['fce_eq','fcp_eq'],linestyle=0,color=214,labflag=0,thick=3
    options,['fLH_eq','fce_eq_*','fcHe_eq','fcO_eq'],linestyle=2,color=214,labflag=0,thick=3

    mms_load_dsp, data_rate='fast', probes=probe, datatype=['epsd','bpsd'], level='l2'
    if tnames('mms'+probe+'_dsp_epsd_omni') eq 'mms'+probe+'_dsp_epsd_omni' and tnames('mms'+probe+'_dsp_epsd_omni_fast_l2') eq '' $
      then tplot_rename,'mms'+probe+'_dsp_epsd_omni','mms'+probe+'_dsp_epsd_omni_fast_l2'
    mms_load_dsp, data_rate='slow', probes=probe, datatype=['epsd','bpsd'], level='l2'
    if tnames('mms'+probe+'_dsp_epsd_omni') eq 'mms'+probe+'_dsp_epsd_omni' and tnames('mms'+probe+'_dsp_epsd_omni_slow_l2') eq '' $
      then tplot_rename,'mms'+probe+'_dsp_epsd_omni','mms'+probe+'_dsp_epsd_omni_slow_l2'
    options,'mms'+probe+'_mec_mlat',ytitle='LAT'
    options,'mms'+probe+'_mec_mlt',ytitle='MLT'
    options,'mms'+probe+'_mec_l_dipole',ytitle='L'
    options,['mms'+probe+'_dsp_epsd_omni_fast_l2','mms'+probe+'_dsp_epsd_omni_slow_l2'],yrange=[30,1e5],/ylog,zrange=[1e-10,1e-5],/zlog,ystyle=1,zstyle=1,ytickformat='exponent'
    options,['mms'+probe+'_dsp_bpsd_omni_fast_l2','mms'+probe+'_dsp_bpsd_omni_slow_l2'],yrange=[30,1e4],/ylog,zrange=[ 1e-9,1e-4],/zlog,ystyle=1,zstyle=1,ytickformat='exponent'


    scm_data_rate = 'srvy';'brst';'srvy'
    scm_datatype = 'scsrvy';'scb';'scsrvy'
    mms_load_scm, probes=probe, level='l2', data_rate=scm_data_rate, datatype=scm_datatype
    scm_name = 'mms'+probe+'_scm_acb_gse_'+scm_datatype+'_'+scm_data_rate+'_l2'
    if scm_datatype eq 'scb' then nboxpoints_input = 8192 else nboxpoints_input = 512
    tdpwrspc, scm_name, nboxpoints=nboxpoints_input,nshiftpoints=nboxpoints_input,bin=1
    
    case fix(probe) of 
      1:calc,"'mms1_scm_scsrvy_srvy_l2_dpwrspc'='mms1_scm_acb_gse_scsrvy_srvy_l2_x_dpwrspc'+'mms1_scm_acb_gse_scsrvy_srvy_l2_y_dpwrspc'+'mms1_scm_acb_gse_scsrvy_srvy_l2_z_dpwrspc'"
      2:calc,"'mms2_scm_scsrvy_srvy_l2_dpwrspc'='mms2_scm_acb_gse_scsrvy_srvy_l2_x_dpwrspc'+'mms2_scm_acb_gse_scsrvy_srvy_l2_y_dpwrspc'+'mms2_scm_acb_gse_scsrvy_srvy_l2_z_dpwrspc'"
      3:calc,"'mms3_scm_scsrvy_srvy_l2_dpwrspc'='mms3_scm_acb_gse_scsrvy_srvy_l2_x_dpwrspc'+'mms3_scm_acb_gse_scsrvy_srvy_l2_y_dpwrspc'+'mms3_scm_acb_gse_scsrvy_srvy_l2_z_dpwrspc'"
      4:calc,"'mms4_scm_scsrvy_srvy_l2_dpwrspc'='mms4_scm_acb_gse_scsrvy_srvy_l2_x_dpwrspc'+'mms4_scm_acb_gse_scsrvy_srvy_l2_y_dpwrspc'+'mms4_scm_acb_gse_scsrvy_srvy_l2_z_dpwrspc'"
    endcase
      
    if scm_datatype eq 'scsrvy' then ylim, scm_name+'*_dpwrspc',0.5,16,1
    if scm_datatype eq 'scb' then ylim, scm_name+'*_dpwrspc',1,4096,1
    if scm_datatype eq 'schb' then ylim, scm_name+'*_dpwrspc',32,8192,1

    store_data,'Ew_fast_comb',data=['mms'+probe+'_dsp_epsd_omni_fast_l2','fce_eq','fce_eq_half','fce_eq_tenth','fLH_eq']
    store_data,'Ew_slow_comb',data=['mms'+probe+'_dsp_epsd_omni_slow_l2','fce_eq','fce_eq_half','fce_eq_tenth','fLH_eq']
    store_data,'Bw_fast_comb',data=['mms'+probe+'_dsp_bpsd_omni_fast_l2','fce_eq','fce_eq_half','fce_eq_tenth','fLH_eq']
    store_data,'Bw_slow_comb',data=['mms'+probe+'_dsp_bpsd_omni_slow_l2','fce_eq','fce_eq_half','fce_eq_tenth','fLH_eq']
    store_data,'Bw_survey_comb',data=['mms'+probe+'_scm_scsrvy_srvy_l2_dpwrspc','fcp_eq','fcHe_eq','fcO_eq']
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
    !p.thick=1
    device,filename=dir+'/MMSDataOverview/MMS'+probe+'_full_'+yy0+mm0+dd0+'T'+time+'.ps',/color, Bits_per_Pixel=8, xsize=21,ysize=24,/times,xoffset=0.3,yoffset=0.3
    ;  tplot,['mms'+probe+'_fgm_b_gsm_srvy_l2_bvec','mms'+probe+'_dsp_epsd_omni_fast_l2','mms'+probe+'_dsp_bpsd_omni_fast_l2','mms'+probe+'_dsp_epsd_omni_slow_l2','mms'+probe+'_dsp_bpsd_omni_slow_l2',$
    ;    'mms'+probe+'_scm_scsrvy_srvy_l2_dpwrspc'],var_label=['mms'+probe+'_mec_mlat','mms'+probe+'_mec_mlt','mms'+probe+'_mec_l_dipole']
    tplot,['Ew_fast_comb','Ew_slow_comb','Bw_fast_comb','Bw_slow_comb','Bw_survey_comb'],var_label=['mms'+probe+'_mec_mlat','mms'+probe+'_mec_mlt','mms'+probe+'_mec_l_dipole']
    
    device,/close
    spawn,'convert -density 90 -background "#FFFFFF" -flatten '+dir+'/MMSDataOverview/MMS'+probe+'_full_'+yy0+mm0+dd0+'T'+time+'.ps '+$
      dir+'/MMSDataOverview/MMS'+probe+'_full_'+yy0+mm0+dd0+'T'+time+'.png'

  
end
