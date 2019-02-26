PRO mageis_high_rate_plot,sc,year

  set_plot,'ps'
  ;init set
  rbsp_init
  
 
      sc=sc
      year=year
      ;READ LIST------------------
      f_id='/projectnb/burbsp/home/xcshen/Identified_EMIC_wave_forth_result/eventlist/list_'+year+'_RBSP'+sc+'.txt'

      line=file_lines(f_id)
      list=strarr(2,line)

      OPENR,lun,f_id,/get_lun
      READF,lun,list,format='(A19,1X,A19)'
      CLOSE,lun

      for ev=1,line-1 do begin
        tstart=time_string(time_double(list[0,ev])) 
        if strmid(tstart,0,10) eq '2017-01-03' then continue
        if strmid(tstart,0,10) eq '2017-01-11' then continue
        if strmid(tstart,0,10) eq '2017-01-17' then continue
        if strmid(tstart,0,10) eq '2017-01-25' then continue


        del_data,'*'
        get_mageis_electronflux_stevens,sc,time_string(time_double(list[0,ev])-60.*15),time_string(time_double(list[1,ev])+60.*15)

      endfor
  
End
