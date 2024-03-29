pro run_mageis_hr_from_list
 
  compile_opt idl2
  
  f_id='/projectnb/burbsp/home/xcshen/list_to_plot.txt'

  line=file_lines(f_id)

  list=strarr(3,line)

  OPENR,lun,f_id,/get_lun
  READF,lun,list,format='(A19,1X,A19,1X,A1)'
  CLOSE,lun

  start_time='Start_time'
  end_time='End_time'

  for i=1,line-1 do begin
  
    st=list[0,i]
    et=list[1,i]
    sc=list[2,i]
    
    rbsp_flux_wave_overview,sc,time_string(time_double(st)-60.*15),time_string(time_double(et)-60.*15),dir_fig='/projectnb/burbsp/home/xcshen/mageis_HR/survey/'
  endfor
  
END    