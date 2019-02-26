pro get_wavephi
  get_data,'phsvd',data=dphsvd
  get_data,'phpoy1_2_3',data=dphpoy1_2_3
  n_time=n_elements(dphsvd.x)
  n_fre=n_elements(dphsvd.v)
  phsvd_90=dphsvd.y
  phpoy1_2_3_90=dphpoy1_2_3.y
  phsvd_180=dphsvd.y
  phsvd_180_ew=phsvd_180
  phpoy1_2_3_180=dphpoy1_2_3.y
  for j=0,n_fre-1 do begin
    for i=0,n_time-1 do begin
      case 1 of
        dphsvd.y[i,j] gt 90 and dphsvd.y[i,j] le 180: phsvd_90[i,j]=180.-dphsvd.y[i,j]
        dphsvd.y[i,j] ge -90 and dphsvd.y[i,j] lt 0: phsvd_90[i,j]=-dphsvd.y[i,j]
        dphsvd.y[i,j] ge -180 and dphsvd.y[i,j] lt -90: phsvd_90[i,j]=180.+dphsvd.y[i,j]
        else:
      endcase
      case 1 of
        dphpoy1_2_3.y[i,j] gt 90 and dphpoy1_2_3.y[i,j] le 180: phpoy1_2_3_90[i,j]=180.-dphpoy1_2_3.y[i,j]
        dphpoy1_2_3.y[i,j] ge -90 and dphpoy1_2_3.y[i,j] lt 0: phpoy1_2_3_90[i,j]=-dphpoy1_2_3.y[i,j]
        dphpoy1_2_3.y[i,j] ge -180 and dphpoy1_2_3.y[i,j] lt -90: phpoy1_2_3_90[i,j]=180.+dphpoy1_2_3.y[i,j]
        else:
      endcase
      
      if dphsvd.y[i,j] ge 0 and dphsvd.y[i,j] le 90 then phsvd_180_ew[i,j]=90.-dphsvd.y[i,j]
      if dphsvd.y[i,j] gt 90 and dphsvd.y[i,j] le 180 then phsvd_180_ew[i,j]=dphsvd.y[i,j]-90.
      if dphsvd.y[i,j] ge -90 and dphsvd.y[i,j] lt 0 then phsvd_180_ew[i,j]=90.-dphsvd.y[i,j]
      if dphsvd.y[i,j] ge -180 and dphsvd.y[i,j] lt -90 then phsvd_180_ew[i,j]=270.+dphsvd.y[i,j]
      
      if dphsvd.y[i,j] ge -180 and dphsvd.y[i,j] lt 0 then phsvd_180[i,j]=-dphsvd.y[i,j]
      
      if dphpoy1_2_3.y[i,j] ge -180 and dphpoy1_2_3.y[i,j] lt 0 then phpoy1_2_3_180[i,j]=-dphpoy1_2_3.y[i,j]
    endfor
  endfor
  
  store_data,'phsvd_90',data={x:dphsvd.x,v:dphsvd.v,y:phsvd_90},dlim={spec:'1B'}
  store_data,'phsvd_180',data={x:dphsvd.x,v:dphsvd.v,y:phsvd_180},dlim={spec:'1B'}
  store_data,'phsvd_180_ew',data={x:dphsvd.x,v:dphsvd.v,y:phsvd_180_ew},dlim={spec:'1B'}
  store_data,'phpoy1_2_3_90',data={x:dphsvd.x,v:dphsvd.v,y:phpoy1_2_3_90},dlim={spec:'1B'}
  store_data,'phpoy1_2_3_180',data={x:dphsvd.x,v:dphsvd.v,y:phpoy1_2_3_180},dlim={spec:'1B'}
  ylim,['phsvd*','phpoy1_2_3*'],1e1,1e3,1
  zlim,['phsvd_90','phpoy1_2_3_90'],0,90,0
  zlim,['phsvd_180*','phpoy1_2_3_180'],0,180,0
  options,['phsvd*','phpoy1_2_3*'],ytitle='Frequency!C!C(Hz)',ytickformat='exponent'
  options,'phsvd_90',ztitle='phi!C!C0 to 90'
  options,'phsvd_180',ztitle='phi(O-I)!C!C0 to 180'
  options,'phsvd_180_ew',ztitle='phi(E-W)!C!C0 to 180'
end
