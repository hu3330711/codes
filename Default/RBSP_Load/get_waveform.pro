pro get_waveform
del_data,'*'
sc='a' & yy='12' & mm='12' & dd='04'
  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L2/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_WFR-waveform-continuous-burst_emfisis-L2_20'+yy+mm+dd+'???_v*.*.*.cdf',/fold_case,count=count)
;  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L2/20'+yy+'/'+mm+'/'+dd+'/', $
;    'rbsp-'+sc+'_WFR-spectral-matrix-diagonal-merged_emfisis-L2_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1
cdf_leap_second_init
  cdf2tplot,file=filename[count-1],/get_support_data
  tplot_names
  timespan,'12-12-04/00',1,/d
  !p.background='ffffff'xl
  !p.color=0
  tplot,[4,5,6]
end
