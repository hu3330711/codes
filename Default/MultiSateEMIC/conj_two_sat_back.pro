PRO Conj_two_sat_back,varla,varmlta,varmlata,varlb,varmltb,varmlatb,deltal,deltamlt,deltamlat

  If not keyword_set(deltal) then begin
    print,'delta L is not given; it will be set to 0.2'
    deltal=0.2
  Endif

  If not keyword_set(deltamlt) then begin
    print,'delta MLT is not given; it will be set to 0.5'
    deltamlt=0.5
  Endif

  If not keyword_set(deltal) then begin
    print,'delta MLAT is not given; it will be set to 10'
    deltamlat=2
  Endif

  tinterpol_mxn,varlb,varla,/overwrite
  tinterpol_mxn,varmltb,varmlta,/overwrite
  tinterpol_mxn,varmlatb,varmlata,/overwrite

  get_data,varla,data=la
  get_data,varlb,data=lb

  get_data,varmlta,data=mlta
  get_data,varmltb,data=mltb

  get_data,varmlata,data=mlata
  get_data,varmlatb,data=mlatb

  cri_l=abs(la.y-lb.y)
  cri_mlt=abs(mlta.y-mltb.y)
  cri_mlat=abs(mlata.y-mlatb.y)

  event=''

  For i=0,n_elements(la.x)-1 do begin

    if (cri_l[i] le deltal) and (cri_mlt[i] le deltamlt) and (cri_mlat[i] gt deltamlat) then a=a
    if (cri_l[i] le deltal) and (cri_mlt[i] gt deltamlt) and (cri_mlat[i] le deltamlat) then a=a
    if (cri_l[i] gt deltal) and (cri_mlt[i] le deltamlt) and (cri_mlat[i] le deltamlat) then a=a

  Endfor

  Return

END