pro diffusion_plot

  compile_opt idl2

  filename=file_search('/projectnb/burbsp/home/xcshen/Fcode/FDC_EMIC_event1_Helium/EMIC_BavD_L5.0_Ek*.txt',/fold_case,count=count)
   
  PA=findgen(90)+1
  Eng=fltarr(37) 
  Daa=dblarr(37,90)
  Dpp=dblarr(37,90)
  Dap=dblarr(37,90)
  DaE=dblarr(37,90)
  DEE=dblarr(37,90)

  for i=0,count-2 do begin
    f_id=filename[i]
    
    data = READ_ASCII(f_id, DATA_START=10)
    
    Eng[i] = data.field1[1,0]
    
    Daa[i,*] = data.field1[3,*]
    Dpp[i,*] = data.field1[4,*]
    Dap[i,*] = data.field1[5,*]
    DaE[i,*] = data.field1[6,*]
    DEE[i,*] = data.field1[7,*]

  endfor
   
  specplot,PA,Eng,transpose(Daa)  
  stop

END