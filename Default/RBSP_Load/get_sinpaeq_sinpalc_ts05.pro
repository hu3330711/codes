pro get_sinpaeq_sinpalc_ts05
  sc_all=['A','B']
  rbsp_init
  re=double(6.371e3)
  
  for index_sc=0,1 do begin
    sc=sc_all[index_sc]
    for index_year=12,15 do begin
      yy=string(index_year,format='(I2.2)')
      for index_month=1,12 do begin
        mm=string(index_month,format='(I2.2)')
      for index_date=1,31 do begin
        dd=string(index_date,format='(I2.2)')
        del_data,'*'
        timespan,'20'+yy+'-'+mm+'-'+dd+'/'+'00:00',1,/d
        exist=0
        get_B0State,yy,mm,dd,sc,exist=exist
        if exist eq 0 then continue
        
        t05_pa_equator,'20'+yy,mm,dd,12,0,0,-1,1,0.5,sinpaeq_sinpalc,exist=exist
        if exist eq 0 then continue
        
        get_data,'coordinates',data=dcoord
        n_time=60l*24
        sinpaeq_sinpalc=dblarr(n_time)+1
        time=dindgen(n_time)*60.+dcoord.x[0]
        x_sm=interpol(dcoord.y[*,0],dcoord.x,time,/nan)
        y_sm=interpol(dcoord.y[*,1],dcoord.x,time,/nan)
        z_sm=interpol(dcoord.y[*,2],dcoord.x,time,/nan)

        for i=0l,n_time-1 do begin
          x0_sm=x_sm[i]/re
          y0_sm=y_sm[i]/re
          z0_sm=z_sm[i]/re
          if sqrt(x0_sm^2+y0_sm^2+z0_sm^2) le 1 or sqrt(x0_sm^2+y0_sm^2+z0_sm^2) ge 20 then continue
          time_in_a_day=long64(time[i]-time_double(strjoin('20'+yy+'-'+mm+'-'+dd+'/00:00:00')))
          if time_in_a_day lt 0 then time_in_a_day=0
          if time_in_a_day gt 84600 then time_in_a_day=86400
          hh=time_in_a_day/3600
          mmin=(time_in_a_day/60) mod 60
          ss=time_in_a_day mod 60
          
          t05_pa_equator,'20'+yy,mm,dd,hh,mmin,ss,x0_sm,y0_sm,z0_sm,sinpaeq_sinpalc0,exist=exist
          sinpaeq_sinpalc[i]=sinpaeq_sinpalc0
        endfor
        
        store_data,'SinPaEq_SinPaLc',data={x:time,y:sinpaeq_sinpalc}
        
        dir_out='/projectnb/burbsp/home/QM/DataSet/SinPaEq_SinPaLc_TS05_RBSP/'+yy+mm+'/'
        file_mkdir,dir_out
        tplot_save,'SinPaEq_SinPaLc',filename=dir_out+'SinPaEq_SinPaLc_20'+yy+mm+dd+'_RBSP'+sc+'_ts05'
        print,yy+mm+dd,sc,systime()
      endfor
    endfor
  endfor
  endfor
end
