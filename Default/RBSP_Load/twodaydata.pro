pro TwoDayData,yy,mm,dd,sc,exist=exist
  get_data,'HFR_Spectra',data=dHFR1
  get_data,'FPSA',data=dFPSA1
  get_data,'PSD',data=dPSD1
  get_data,'BwaveIntensity',data=dBwaveIntensity1
  get_data,'EwaveIntensity',data=dEwaveIntensity1
  get_data,'L',data=dl1
  get_data,'MLT',data=dMLT1
  get_data,'LAT',data=dLAT1
  get_data,'Magnitude',data=dMagnitude1
  get_data,'fce_eq',data=dfce1
  
  dd2=strtrim(string(dd+1),2)
  if dd+1 le 9 then dd2='0'+dd2
  get_B0State,yy,mm,dd2,sc,exist=exist
  get_WaveEB,yy,mm,dd2,sc,exist=exist
  get_ProtonFluxPSD,yy,mm,dd2,sc,exist=exist
  get_HFRDensity,yy,mm,dd2,sc,exist=exist
  
  get_data,'HFR_Spectra',data=dHFR2
  get_data,'FPSA',data=dFPSA2
  get_data,'PSD',data=dPSD2
  get_data,'BwaveIntensity',data=dBwaveIntensity2
  get_data,'EwaveIntensity',data=dEwaveIntensity2
  get_data,'L',data=dl2
  get_data,'MLT',data=dMLT2
  get_data,'LAT',data=dLAT2
  get_data,'Magnitude',data=dMagnitude2
  get_data,'fce_eq',data=dfce2
  
  store_data,'HFR_Spectra',data={x:[dHFR1.x,dHFR2.x],y:[dHFR1.y,dHFR2.y],v:dHFR1.v}
  store_data,'FPSA',data={x:[dFPSA1.x,dFPSA2.x],y:[dFPSA1.y,dFPSA2.y],v:dFPSA1.v}
  store_data,'PSD',data={x:[dPSD1.x,dPSD2.x],y:[dPSD1.y,dPSD2.y],v:dPSD1.v}
  store_data,'BwaveIntensity',data={x:[dBwaveIntensity1.x,dBwaveIntensity2.x],y:[dBwaveIntensity1.y,dBwaveIntensity2.y],v:dBwaveIntensity1.v}
  store_data,'EwaveIntensity',data={x:[dEwaveIntensity1.x,dEwaveIntensity2.x],y:[dEwaveIntensity1.y,dEwaveIntensity2.y],v:dEwaveIntensity1.v}
  store_data,'L',data={x:[dL1.x,dL2.x],y:[dL1.y,dL2.y]}
  store_data,'MLT',data={x:[dMLT1.x,dMLT2.x],y:[dMLT1.y,dMLT2.y]}
  store_data,'Magnitude',data={x:[dMagnitude1.x,dMagnitude2.x],y:[dMagnitude1.y,dMagnitude2.y]}
  store_data,'fce_eq',data={x:[dfce1.x,dfce2.x],y:[dfce1.y,dfce2.y]}
  store_data,'FPSA',data={x:[dFPSA1.x,dFPSA2.x],y:[dFPSA1.y,dFPSA2.y],v:dFPSA1.v}
  
  get_data,'fce_eq',data=dfce
  store_data,'fce_eq_double',data={x:dfce.x,y:2*dfce.y}
  store_data,'fce_eq_half',data={x:dfce.x,y:dfce.y/2}
  store_data,'fLHR',data={x:dfce.x,y:dfce.y/1837*43}
  store_data,'fLHR_half',data={x:dfce.x,y:dfce.y/1837*43/2}
  store_data,'EwaveIntensity_combo',data=['EwaveIntensity','fce_eq','fce_eq_half','fLHR','fLHR_half']
  store_data,'BwaveIntensity_combo',data=['BwaveIntensity','fce_eq','fce_eq_half','fLHR','fLHR_half']
  store_data,'HFR_Spectra_combo',data=['HFR_Spectra','fce_eq','fce_eq_double','fce_eq_half']
  
end