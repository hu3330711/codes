PRO EMIC_wave_polorization_plot
  
  sate=['b','a']
  yy=['2017','2016']
  mm=['01','02','03','04','05','06','07','08','09','10','11','12']

  for ii=0,11 do begin
    for jj=0,1 do begin
      for kk=0,1 do begin
        month=mm[ii]
        sc=sate[jj]
        year=yy[kk]

        RBSP_EMIC_plot_from_list,sc,year,month

      endfor
    endfor
  endfor
END
