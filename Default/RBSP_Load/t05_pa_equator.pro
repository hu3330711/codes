pro t05_pa_equator,yy,mm,dd,hh,mmin,ss,x0_sm,y0_sm,z0_sm,sinpaeq_sinpalc,exist=exist

 exist=0
 dir_input='/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/QinDenton/'+yy+'/'
 filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/QinDenton/'+yy+'/', $
    'QinDenton_'+yy+mm+dd+'_1min.txt',/fold_case,count=count)
  linenumber=min([1439,long(hh*60.+mmin+ss/60.+0.5)])
  if count eq 0 then begin
    filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/QinDenton/'+yy+'/', $
    'QinDenton_'+yy+mm+dd+'_5min.txt',/fold_case,count=count)
    linenumber=min([287,long((hh*60.+mmin+ss/60.)/5.+0.5)])
  endif
  if count eq 0 then begin
    filename=file_search('/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/QinDenton/'+yy+'/', $
    'QinDenton_'+yy+mm+dd+'_hour.txt',/fold_case,count=count)
    linenumber=min([23,long((hh*60.+mmin+ss/60.)/60.+0.5)])
  endif
  if count eq 0 then return else exist=1
  
 openr,lun,filename[count-1],/get_lun
 tmp_st=' '
 for i=0,191 do readf,lun,tmp_st
 g_arr=dblarr(3)
 w_arr=dblarr(6)
 bz_arr=dblarr(6)
 g_st_arr=intarr(3)
 w_st_arr=intarr(6)
 for i=0,linenumber do readf,lun,tmp_st,yy_tmp,mm_tmp,dd_tmp,hh_tmp,mmin_tmp,ss_tmp,byimf,bzimf,vsw,np,psw,g_arr,byimf_st,bzimf_st,vsw_st,np_st,psw_st,g_st_arr,kp,akp3,dst,bz_arr,w_arr,w_st_arr $
 ,format='(A19,I5,I4,4I3,1X,2f7.2,f7.1,1X,2f7.2,1X,3f7.2,1X,8I2,1X,2f6.2,I6,1X,6f7.2,1X,6f7.3,1X,6I2)'
 free_lun,lun
 
 para=dblarr(10)
 para[0]=psw
 para[1]=dst
 para[2]=byimf
 para[3]=bzimf
 para[4:9]=w_arr[0:5]
 
 geopack_recalc,yy,mm,dd,hh,mmin,ss,/date
 geopack_conv_coord,x0_sm,y0_sm,z0_sm,x0_gsm,y0_gsm,z0_gsm,/From_sm,/to_gsm 
 geopack_igrf_gsm,x0_gsm,y0_gsm,z0_gsm,bx0_0,by0_0,bz0_0
 geopack_ts04,para,x0_gsm,y0_gsm,z0_gsm,bx0_1,by0_1,bz0_1
 bx0=bx0_0+bx0_1 & by0=by0_0+by0_1 & bz0=bz0_0+bz0_1
 b0=sqrt(bx0^2+by0^2+bz0^2)
 
 geopack_trace,x0_gsm,y0_gsm,z0_gsm,1,para,x1_gsm,y1_gsm,z1_gsm,/equator,/ts04,/igrf,/refine
 geopack_igrf_gsm,x1_gsm,y1_gsm,z1_gsm,bx1_0,by1_0,bz1_0
 geopack_ts04,para,x1_gsm,y1_gsm,z1_gsm,bx1_1,by1_1,bz1_1
 bx1=bx1_0+bx1_1 & by1=by1_0+by1_1 & bz1=bz1_0+bz1_1
 b1=sqrt(bx1^2+by1^2+bz1^2)
 
 sinpaeq_sinpalc=sqrt(b1/b0)
 if sinpaeq_sinpalc gt 1. then sinpaeq_sinpalc=1.
end
