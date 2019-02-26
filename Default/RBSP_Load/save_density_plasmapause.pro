pro save_density_plasmapause,month_select
  rbsp_init
  for year=12,18 do begin
    yy=string(year,format='(I2.2)')
    for month=month_select,month_select do begin
      mm=string(month,format='(I2.2)')
      for date=1,31 do begin
        dd=string(date,format='(I2.2)')
        for index_sc=0,1 do begin
          if index_sc eq 0 then sc='A' else sc='B'
        
        clock_start='00:00' & clock_end='24:00'
        del_data,'*'
        
        tr1=yy+'-'+mm+'-'+dd+'/'+clock_start
        tr2=yy+'-'+mm+'-'+dd+'/'+clock_end
        tsec1=time_double(tr1)
        tsec2=time_double(tr2)
        timespan,tsec1,tsec2-tsec1,/sec
        
        exist=0
        get_B0State,yy,mm,dd,sc,exist=exist
        if exist eq 0 then continue
        exist=0
        get_HFRDensity,yy,mm,dd,sc,exist=exist
        if exist eq 0 then continue
        tinterpol_mxn,'L_sm','HFR_Spectra',newname='L'
        tinterpol_mxn,'fce_eq','HFR_Spectra',newname='fce_eq'
        get_pp_from_hfr_fce
        
        filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
          'rbsp-'+sc+'_density_emfisis-L4_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
        if count eq 0 then $
          filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/RBSP-'+sc+'/L4/20'+yy+'/'+mm+'/'+dd+'/', $
          'rbsp-'+sc+'_density_emfisis_20'+yy+mm+dd+'_v*.*.*.cdf',/fold_case,count=count)
        if count ge 1 then begin
          flag=0
          for index_file=count-1,0,-1 do begin
            cdf2tplot,file=filename[count-1],/get_support_data
            get_data,'density',data=density,index=flag
            if flag ne 0 then break
          endfor
          
          if flag ne 0 then begin
            ylim,'density',1e0,3e3,1
            tinterpol_mxn,'density','pp',newname='density_int'
            get_data,'pp',data=pp
            get_data,'density_int',data=density_int
            
            index=where(pp.y eq 1 and density_int.y ge 80 and finite(density_int.y),count)
            if count ge 1 then pp.y[index]=0
            index=where(pp.y eq 0 and density_int.y le 20 and finite(density_int.y),count)
            if count ge 1 then pp.y[index]=1
            store_data,'pp_int',data={x:pp.x,y:pp.y}
            ylim,'pp_int',-1,2,0
          endif
        endif
        
        time_start=time_double('20'+yy+'-'+mm+'-'+dd+'/'+clock_start)
        n_min=60l*24
        get_data,'pp',data=pp
        pp_min=dblarr(n_min)
        cnt_min=dblarr(n_min)
        for i=0l,n_elements(pp.x)-1 do begin
          if ~finite(pp.y[i]) then continue
          index_time=fix((pp.x[i]-time_start)/60.+0.5)
          if index_time lt 0 or index_time ge n_min then continue
          pp_min[index_time]=pp.y[i]+pp_min[index_time]
          cnt_min[index_time]=cnt_min[index_time]+1
        endfor
        pp_min=pp_min/cnt_min
        pp_min=fix(pp_min+0.5)
        
        get_data,'pp_int',data=pp_int,index=flag
        pp_int_min=dblarr(n_min)
        cnt_min=dblarr(n_min)
        if flag ne 0 then begin
        for i=0l,n_elements(pp_int.x)-1 do begin
          if ~finite(pp_int.y[i]) then continue
          index_time=fix((pp_int.x[i]-time_start)/60.+0.5)
          if index_time lt 0 or index_time ge n_min then continue
          pp_int_min[index_time]=pp_int.y[i]+pp_int_min[index_time]
          cnt_min[index_time]=cnt_min[index_time]+1
        endfor
        endif
        pp_int_min=pp_int_min/cnt_min
        pp_int_min=fix(pp_int_min+0.5)
        
        get_data,'density',data=density,index=flag
        density_min=dblarr(n_min)
        cnt_min=dblarr(n_min)
        if flag ne 0 then begin
          for i=0l,n_elements(density.x)-1 do begin
            if ~finite(density.y[i]) or density.y[i] le 0 then continue
            index_time=fix((density.x[i]-time_start)/60.+0.5)
            if index_time lt 0 or index_time ge n_min then continue
            density_min[index_time]=density.y[i]+density_min[index_time]
            cnt_min[index_time]=cnt_min[index_time]+1
          endfor
        endif
        density_min=density_min/cnt_min
        
        get_data,'density_int',data=density_int,index=flag
        density_int_min=dblarr(n_min)
        cnt_min=dblarr(n_min)
        if flag ne 0 then begin
          for i=0l,n_elements(density_int.x)-1 do begin
            if ~finite(density_int.y[i]) or density_int.y[i] le 0 then continue
            index_time=fix((density_int.x[i]-time_start)/60.+0.5)
            if index_time lt 0 or index_time ge n_min then continue
            density_int_min[index_time]=density_int.y[i]+density_int_min[index_time]
            cnt_min[index_time]=cnt_min[index_time]+1
          endfor
        endif
        density_int_min=density_int_min/cnt_min
        
        index=where(finite(density_min),count)
        if count ge 1 then pp_min[index]=pp_int_min[index]
        store_data,'pp',data={x:dindgen(n_min)*60.+time_start,y:pp_min}
        ylim,'pp',-1,2,0
        
        dir='/projectnb/burbsp/home/QM/DataSet/hope_rbspice_statistics/pt_statistics_hope_rbspice_v3.4/Density_PP/'+yy+mm+'/'
        file_mkdir,dir
        openw,lun,dir+'Density_PP_'+yy+mm+dd+sc+'.txt',/get_lun
        printf,lun,'Time','sc','PP','Density (cm^-3)',format='(A20,A3,A3,A16)'
        for i=0l,n_min-1 do printf,lun,time_string(time_start+i*60.),sc,pp_min[i],density_min[i],format='(A20,A3,I3,e16.7e3)'
        free_lun,lun
        
        set_plot,'X'
        !p.background='ffffff'xl
        !p.color=0
        window,xsize=800,ysize=600
        tplot,['HFR_Spectra','pp','density'],title='Van Allen Probe '+sc
        makepng,dir+'Density_PP_'+yy+mm+dd+sc
        wdelete
        endfor
      endfor
    endfor
  endfor
end
