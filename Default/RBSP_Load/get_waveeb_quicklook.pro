pro get_waveeb_quicklook,yy,mm,dd,sc,exist=exist
fre_min=1e1 & fre_max=1e3

  filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/Quick-Look/20'+yy+'/'+mm+'/'+dd+'/', $
    'rbsp-'+sc+'_WFR-spectral-matrix_emfisis-Quick-Look_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
  if count eq 0 then return else exist=1

  cdf2tplot_qm,file=filename[count-1];,/get_support_data
  
  get_data,'BuBu',data=dBu
  store_data,'BuBu',data={x:dBu.x,y:dBu.y,v:transpose(dBu.v[0,*])}
  options,'BuBu',ztitle='BuBu!C!C(nT!u2!n/Hz)'
  get_data,'BvBv',data=dBv
  store_data,'BvBv',data={x:dBv.x,y:dBv.y,v:transpose(dBv.v[0,*])}
  options,'BvBv',ztitle='BvBv!C!C(nT!u2!n/Hz)'
  get_data,'BwBw',data=dBw
  store_data,'BwBw',data={x:dBw.x,y:dBw.y,v:transpose(dBw.v[0,*])}
  options,'BwBw',ztitle='BwBw!C!C(nT!u2!n/Hz)'
  options,strjoin('B?B?'),'spec',1
  options,strjoin('B?B?'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  ylim,'B?B?',fre_min,fre_max,1
  zlim,'B?B?',1e-9,1e-5,1
  
  Bwave=dBu.y+dBv.y+dBw.y
  store_data,'BwaveIntensity',data={x:dBw.x,y:Bwave,v:transpose(dBw.v[0,*])}
  options,'BwaveIntensity',ztitle='B Intensity!C!C(nT!u2!n/Hz)'
  options,strjoin('BwaveIntensity'),'spec',1
  options,strjoin('BwaveIntensity'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  store_data,'BwaveIntensity_combo',data=['BwaveIntensity','fce_eq','fce_eq_half','fLHR','fLHR_half','fcp_eq']
  ylim,'BwaveIntensity*',fre_min,fre_max,1
  zlim,'BwaveIntensity*',1e-9,1e-5,1
  
  get_data,'EuEu',data=dEu
  a=min(abs(dEu.v[0,*]-2e3),index)
  dEu.y[*,index]=(deu.y[*,index-1]*(deu.v[index+1]-deu.v[index])+ $
    deu.y[*,index+1]*(deu.v[index]-deu.v[index-1]))/(deu.v[index+1]-deu.v[index-1])
  store_data,'EuEu',data={x:dEu.x,y:dEu.y,v:transpose(dEu.v[0,*])}
  options,'EuEu',ztitle='EuEu!C!C((V/m)!u2!n/Hz)'
  get_data,'EvEv',data=dEv
  dEv.y[*,index]=(dev.y[*,index-1]*(dev.v[index+1]-dev.v[index])+ $
    dev.y[*,index+1]*(dev.v[index]-dev.v[index-1]))/(dev.v[index+1]-dev.v[index-1])
  store_data,'EvEv',data={x:dEv.x,y:dEv.y,v:transpose(dEv.v[0,*])}
  options,'EvEv',ztitle='EvEv!C!C((V/m)!u2!n/Hz)'
  get_data,'EwEw',data=dEw
  dEw.y[*,index]=(dew.y[*,index-1]*(dew.v[index+1]-dew.v[index])+ $
    dew.y[*,index+1]*(dew.v[index]-dew.v[index-1]))/(dew.v[index+1]-dew.v[index-1])
  store_data,'EwEw',data={x:dEw.x,y:dEw.y,v:transpose(dEw.v[0,*])}
  options,'EwEw',ztitle='EwEw!C!C((V/m)!u2!n/Hz)'
  options,strjoin('E?E?'),'spec',1
  options,strjoin('E?E?'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  ylim,'E?E?',fre_min,fre_max,1
  zlim,'E?E?',1e-14,1e-10,1
  
  Ewave=dEu.y+dEv.y
  store_data,'EwaveIntensity',data={x:dEw.x,y:Ewave,v:transpose(dEw.v[0,*])}
  options,'EwaveIntensity',ztitle='E Intensity!C!C((V/m)!u2!n/Hz)'
  options,strjoin('EwaveIntensity'),'spec',1
  options,strjoin('EwaveIntensity'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='exponent'
  store_data,'EwaveIntensity_combo',data=['EwaveIntensity','fce_eq','fce_eq_half','fLHR','fLHR_half','fcp_eq']
  ylim,'EwaveIntensity*',fre_min,fre_max,1
  zlim,'EwaveIntensity*',1e-13,1e-8,1
  
  get_timespan,t
  data_tlimit,time_string(t[0]),time_string(t[1])
end
