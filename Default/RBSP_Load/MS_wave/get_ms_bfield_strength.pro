pro get_ms_bfield_strength
  tinterpol_mxn,'fLHR','BwaveIntensity',newname='fLHR_int'
  get_data,'BwaveIntensity',data=dBw
  get_data,'fLHR_int',data=dflhr
  fcp=dflhr.y/43.
  n_time=n_elements(dBw.x)
  Bfield=dblarr(n_time)/0.0
  
  tinterpol_mxn,'thsvd','BwaveIntensity',newname='thsvd_int'
  tinterpol_mxn,'ellsvd','BwaveIntensity',newname='ellsvd_int'
  get_data,'thsvd_int',data=dth
  get_data,'ellsvd_int',data=dell

  bw_ms=dbw.y * 0.
  for i=0,n_time-1 do begin
    index=where((dth.y[i,*] ge 65) and (abs(dell.y[i,*]) le 0.5),count)
    if count ge 1 then bw_ms[i,index]=dbw.y[i,index]
  endfor
  
  for i=0,n_time-1 do begin
    if ~finite(fcp[i]) or ~finite(dflhr.y[i]) then continue
    fre_low=max([fcp[i],2e1])
    fre_high=min([dflhr.y[i],4e3])
    index=where(dBw.v ge fre_low and dBw.v le fre_high,count)
    if count lt 1 then continue
    Bfield[i]=bw_ms[i,index[count-1]]*(fre_high-dBw.v[index[count-1]])/2.+bw_ms[i,index[0]]*(dBw.v[index[0]]-fre_low)
    for j=0,count-2 do begin
      j_index=index[j]
      Bfield[i]=Bfield[i]+(bw_ms[i,j_index]+bw_ms[i,j_index+1])/2.*(dBw.v[j_index+1]-dBw.v[j_index])
    endfor
  endfor
  
  Bfield=sqrt(Bfield)*1e3
;  background=min(BField)
;  Bfield=bfield-background
  store_data,'BwaveStrength',data={x:dBw.x,y:Bfield}
  options,'BwaveStrength',ytitle='MS wave strength!C!C(pT)',ysubtitle=''
  ylim,'BwaveStrength',1,3e2,1
  
  
  bw_ms_subtract=bw_ms * 0.
  for i=0,n_time-1 do begin
    if ~finite(fcp[i]) or ~finite(dflhr.y[i]) then continue
    fre_low=max([fcp[i],2e1])
    fre_high=min([dflhr.y[i],4e3])
    index=where(dBw.v ge fre_low and dBw.v le fre_high,count)
    if count lt 1 then continue
    bw_ms_subtract[i,index]=bw_ms[i,index]
  endfor
  store_data,'BwaveIntensity_MS',data={x:dbw.x,v:dbw.v,y:bw_ms_subtract}
  options,'BwaveIntensity_MS',ztitle='B Intensity!C!C(nT!u2!n/Hz)'
  options,strjoin('BwaveIntensity_MS'),'spec',1
  options,strjoin('BwaveIntensity_MS'),ylog=1,ytitle='Frequency!C',ysubtitle='(Hz)',ytickformat='logticks_exp'
  ylim,'BwaveIntensity_MS',1e1,1e3,1
  zlim,'BwaveIntensity_MS',1e-9,1e-5,1
  
end