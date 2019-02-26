pro get_fUHRDensityEa
  tinterpol_mxn,'HFR_Spectra','PSD_05',newname='HFR_Spectra'
  tinterpol_mxn,'fce_eq','HFR_Spectra',newname='fce_eq'
  get_data,'HFR_Spectra',data=dhfr
  get_data,'fce_eq',data=dfce
  fuhr=dblarr(n_elements(dhfr.x))/0.0
  
  index_fre=where(dhfr.v gt 2*dfce.y[0])
  intensity_tmp=dhfr.y[0,index_fre]
  fre_tmp=dhfr.v[index_fre]
  Intensity_max=max(intensity_tmp,index_max)
  fuhr[0]=fre_tmp[index_max]
  
  m=3 ;;;m points in each grid
  n=27 ;;;n grids in total
  CriticalValue=2e-15 ;;;Critical emission value
  SearchWider=3 ;;;Begin wider search for emissions
  index_fre=where(abs(dhfr.v-fuhr[0]) lt 1)
  k=(index_fre[0]-1)/m ;;;k current grid index (0 to 79/m)
  count_blank=0
  
  for i=1,n_elements(dhfr.x)-1 do begin
    
    index_emission=where(dhfr.y[i,*] gt CriticalValue and dhfr.v[*] gt 2*dfce.y[i],count)
    if count lt 1 then begin
      count_blank=count_blank+1
      continue
    endif
    grid_emission=(index_emission-1)/m
    
    a0=where(grid_emission eq k,count0)
    if k lt n-1 then a1=where(grid_emission eq k+1,count1) else count1=0
    if k gt 0 then a2=where(grid_emission eq k-1,count2) else count2=0
    if count1 ge 1 then begin
      emission=dhfr.y[i,(k+1)*m+1:(k+1)*m+m]
      frequency=dhfr.v[(k+1)*m+1:(k+1)*m+m]
      index_emission=where(emission gt CriticalValue)
      fuhr[i]=frequency[index_emission[n_elements(index_emission)-1]]
      k=k+1
      count_blank=0
      continue
    endif else if count0 ge 1 then begin
      index_low=min([n_elements(dhfr.v)-1,k*m+1])
      index_high=min([n_elements(dhfr.v)-1,k*m+m])
      emission=dhfr.y[i,index_low:index_high]
      frequency=dhfr.v[index_low:index_high]
      index_emission=where(emission gt CriticalValue)
      fuhr[i]=frequency[index_emission[n_elements(index_emission)-1]]
      k=k
      count_blank=0
      continue
    endif else if count2 ge 1 then begin
      emission=dhfr.y[i,(k-1)*m+1:(k-1)*m+m]
      frequency=dhfr.v[(k-1)*m+1:(k-1)*m+m]
      index_emission=where(emission gt CriticalValue)
      fuhr[i]=frequency[index_emission[n_elements(index_emission)-1]]
      k=k-1
      count_blank=0
      continue
    endif
    
    if count_blank ge SearchWider then begin
      if k lt n-2 then a1=where(grid_emission eq k+2,count1) else count1=0
      if k gt 1 then a2=where(grid_emission eq k-2,count2) else count2=0
      if count1 ge 1 then begin
        emission=dhfr.y[i,(k+2)*m+1:(k+2)*m+m]
        frequency=dhfr.v[(k+2)*m+1:(k+2)*m+m]
        index_emission=where(emission gt CriticalValue)
        fuhr[i]=frequency[index_emission[n_elements(index_emission)-1]]
        k=k+2
        count_blank=0
        continue
      endif else if count2 ge 1 then begin
        emission=dhfr.y[i,(k-2)*m+1:(k-2)*m+m]
        frequency=dhfr.v[(k-2)*m+1:(k-2)*m+m]
        index_emission=where(emission gt CriticalValue)
        fuhr[i]=frequency[index_emission[n_elements(index_emission)-1]]
        k=k-2
        count_blank=0
        continue
      endif
    endif
    
    count_blank=count_blank+1
  endfor
  
  remove_nan,fuhr,dhfr.x,ynew
  fuhr=ynew
  
  index_nan=where(fuhr ge dhfr.v[n_elements(dhfr.v)-2]-0.1,count)
  if count ge 3 then fuhr[index_nan]=0.0/0.0
;  for i=n_elements(dhfr.x)-2,1,-1 do begin
;    if abs(fuhr[i] - fuhr[n_elements(dhfr.x)-1]) gt 0.1 then break
;    fuhr[i]=0./0.
;  endfor

  store_data,'fUHR',data={x:dhfr.x,y:fuhr},dlim={color:'w',thick:'2',linestyle:'0'}
  ;;;get Ne, EA begin;;;
  density=(fuhr^2-dfce.y^2)/8971.2^2
  store_data,'Density',data={x:dhfr.x,y:density}
  ylim,'Density',1e0,3e3,1
  options,'Density',ylog=1,ytitle='Density!C',ysubtitle='(cm!U-3!N)',ytickformat='exponent'
  
  get_data,'Magnitude',data=dB0
  Ea=(dB0.y*1e-9)^2/2/(4e-7*!pi)/(density*1e6)/1.6e-19
  store_data,'AlfvenEnergy',data={x:dhfr.x,y:Ea}
  ylim,'AlfvenEnergy',1e2,5e4,1
  options,'AlfvenEnergy',ylog=1,ytitle='Alfven Energy!C',ysubtitle='(eV)',ytickformat='exponent'
  ;;;get Ne, EA end;;;
  
  fpe=8.977297237e3*sqrt(density)
  store_data,'fpe',data={x:dhfr.x,y:fpe}
  ylim,'fpe',1,1,1
  options,'fpe',ytitle='fpe!C',ysubtitle='(Hz)',ytickformat='exponent'
end
