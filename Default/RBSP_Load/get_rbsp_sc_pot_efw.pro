pro get_rbsp_sc_pot_efw,yy,mm,dd,sc,exist=exist
exist=0
dir_local='/projectnb/burbsp/big/SATELLITE/rbsp/rbsp.space.umn.edu/data/rbsp/rbsp'+sc+'/l2/vsvy-hires/20'+yy+'/'
filename0='rbsp'+sc+'_efw-l2_vsvy-hires_20'+yy+mm+dd+'_v*.cdf'
filename=file_search(dir_local+filename0,/fold_case,count=count)
if count lt 1 then return
cdf2tplot,filename
get_data,'vsvy',data=dvefw
scpot=(dvefw.y[*,0]+dvefw.y[*,1])/2
store_data,'SpacecraftPotential',data={x:dvefw.x,y:scpot}
options,'SpacecraftPotential',yrange=[-50,50],ytitle='Spacecraft Potential!C!C[V]',ystyle=1
exist=1
end