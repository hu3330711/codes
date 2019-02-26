pro rbsp_wave_survey
  years=['12','13','14','15','16']
  sc_names=['A','B']
  dir='/project/burbsp/small/QM/DataSet/RBSP_MS_survey_V2.1/'
  file_mkdir,dir
  file_mkdir,dir+'figs/'
  file_mkdir,dir+'data/'
  for i_year=3,4 do begin
    yy=years[i_year]
    for i_sc=0,1 do begin
      sc=sc_names[i_sc]
      for month=1,12 do begin
        mm=strtrim(string(month),2)
        if month le 9 then mm='0'+mm
        file_mkdir,dir+'figs/'+yy+mm+'/'
        file_mkdir,dir+'data/'+yy+mm+'/'
        for date=1,31 do begin
          dd=strtrim(string(date),2)
          if date le 9 then dd='0'+dd
          error=0
          catch,error
          if error ne 0 then begin
            catch,/cancel
            continue
          endif
          rbsp_ion_ms_perday,yy,mm,dd,sc,dir=dir
        endfor
      endfor
    endfor
  endfor
end
