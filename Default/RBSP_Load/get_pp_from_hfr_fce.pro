pro get_pp_from_hfr_fce
tinterpol_mxn,'fce_eq','HFR_Spectra',newname='fce_eq_int'
tinterpol_mxn,'L','HFR_Spectra',newname='L_int'
  get_data,'HFR_Spectra',data=dhfr
  get_data,'fce_eq_int',data=dfce
  get_data,'L_int',data=dl
  f_min=1e4
  f_max=5e5
  
  n_time=n_elements(dhfr.x)
  n_fre=n_elements(dhfr.v)
  int_ech=dblarr(n_time)
  mid_bac=dblarr(n_time)
  
  for i=0,n_fre-1 do begin
    tmp=dhfr.y[*,i]
    sort_index=sort(tmp)
    index=0.2*n_time
    tmp=tmp-tmp[sort_index[index]]
    index=where(tmp lt 0.,count)
    if count ge 1 then tmp[index]=0.
    dhfr.y[*,i]=tmp
  endfor
  store_data,'HFR_Spectra_subtracted',data={x:dhfr.x,v:dhfr.v,y:dhfr.y}
  
  
  index=where(dhfr.y ge 1e-17,count)
  if count ge 1 then tmp=dhfr.y[index] else tmp=dhfr.y
  index=sort(tmp)
  bac=tmp[index[0.2*n_elements(index)]]
  
  for i=0,n_time-1 do begin
    if ~finite(dfce.y[i]) then continue
    fre_low=max([dfce.y[i],f_min])
;    if sqrt(dl.y[i])*dfce.y[i] gt 1e4 then fre_high=min([2.5*sqrt(dl.y[i])*dfce.y[i],f_max]) else fre_high=min([8*dfce.y[i],f_max])
;    if dl.y[i] lt 3 then fre_high=min([fix(dl.y[i])*dfce.y[i],f_max])
    fre_high=min([1.5*dfce.y[i],f_max])
    if dl.y[i] lt 3.5 and dl.y[i] ge 2.5 then fre_high=min([2*dfce.y[i],f_max])
    if dl.y[i] lt 4.5 and dl.y[i] ge 3.5 then fre_high=min([4*dfce.y[i],f_max])
    if dl.y[i] lt 5.5 and dl.y[i] ge 4.5 then fre_high=min([6*dfce.y[i],f_max])
    if dl.y[i] ge 5.5 or fre_high le 1e4 then fre_high=min([8*dfce.y[i],f_max])
    index=where(dhfr.v ge fre_low and dhfr.v le fre_high,count)
    if count lt 1 then continue
    
    y_tmp=dhfr.y[i,index]
    v_tmp=dhfr.v[index]
    index_no0=where(y_tmp gt 0.,count)
    if count ge 1 then begin
      y_tmp=y_tmp[index_no0]
      v_tmp=v_tmp[index_no0]
    endif
    count=n_elements(y_tmp)
    
;    int_ech[i]=y_tmp[count-1]*(fre_high-v_tmp[count-1])/2.+y_tmp[0]*(v_tmp[0]-fre_low)
;    for j=0,count-2 do int_ech[i]=int_ech[i]+(y_tmp[j]+y_tmp[j+1])/2.*(v_tmp[j+1]-v_tmp[j])
;    int_ech[i]=int_ech[i]/(fre_high-fre_low)
    
    ;;another way begin
    sort_index=sort(y_tmp)
    index=0.8*count
    int_ech[i]=y_tmp[sort_index[index]]
    ;;another way end
    
    sort_index=sort(y_tmp)
    index=0.2*count
    mid_bac[i]=y_tmp[sort_index[index]]
  endfor
  
  pp=intarr(n_time)
  index=where(int_ech ge min([1e-16,5*mid_bac]) and int_ech ge max([bac,2e-17]) and dl.y ge 2.,count)
  if count ge 1 then pp[index]=1
  
  pp=median(pp,51)
  pp_out=pp
  for i=300,n_time-301 do begin
    tmp=pp[i-300:i+300]
    med=median(tmp)
    index=where(tmp ne med,count)
    if count le 80 and pp[i] ne med then pp_out[i]=med
  endfor
  
;  pp=pp_out
;  l=dl.y
;  delta_l=dblarr(n_time)/0.
;  for i=1,n_time-1 do delta_l[i]=(l[i]-l[i-1])/abs(l[i]-l[i-1]) ;;delta_l: 1 outbound; 0 inbound
;  delta_l=interpol(delta_l,dl.x,dl.x,/nan)
;  delta_delta_l=dblarr(n_time)
;  for i=1,n_time-1 do delta_delta_l[i]=delta_l[i]-delta_l[i-1]  ;;delta_delta_l: 1: inbound -> outbound; 0: unchanged; -1: outbound -> inbound
;  delta_delta_l[0]=1
;  delta_delta_l[n_time-1]=1
;  index_change=where(abs(delta_delta_l) eq 1,count_change)  ;;index_change: change of in/outbound
;  for i=0,count_change-2 do begin
;      l_test=l[index_change[i]:index_change[i+1]]
;      pp_test=pp[index_change[i]:index_change[i+1]]
;    mean_out=where(pp_test eq 1,count)
;    if count ge 600 then begin  ;;600 is 1h
;      mean_l=median(l_test[mean_out])
;      index=where(l_test gt mean_l and pp_test eq 0,count)
;      if count ge 1 then pp[index_change[i]+index]=1
;    endif
;    
;    mean_in=where(pp_test eq 0,count)
;    if count ge 300 then begin
;      tmp=l_test[mean_in]
;      sort_index=sort(tmp)
;      index=0.8*n_elements(tmp)
;      mean_l=tmp[sort_index[index]]
;      
;      index=where(l_test lt mean_l and pp_test eq 1,count)
;      if count ge 1 then pp[index_change[i]+index]=0
;    endif
;  endfor
;  
;  pp_out=pp

  store_data,'pp',data={x:dhfr.x,y:pp_out}
  ylim,'pp',-1,2,0
end