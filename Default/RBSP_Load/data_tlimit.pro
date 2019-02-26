pro data_tlimit,tr1,tr2
  tsec1=time_double(tr1)
  tsec2=time_double(tr2)
  tplot_names,names=names
  n_names=n_elements(names)
  if n_names le 0 then return
  for i=0,n_names-1 do begin
    get_data,names[i],data=d
    if size(d,/tname) ne 'STRUCT' then continue
    index=where(d.x ge tsec1 and d.x le tsec2,count)
    if count le 0 then continue
    index_low=index[0]
    index_high=index[n_elements(index)-1]
    if index_high ge size(d.y[*,0],/dimensions) then index_high=index_high-1
    case n_tags(d) of
      2: if abs(n_elements(d.x)-n_elements(d.y)) le 1 then store_data,names[i],data={x:d.x[index_low:index_high],y:d.y[index_low:index_high]}
      3: store_data,names[i],data={x:d.x[index_low:index_high],v:d.v,y:d.y[index_low:index_high,*]}
      else: 
    endcase
  endfor
end