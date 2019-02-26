Pro list_generation

dir='/projectnb/burbsp/home/xcshen/'
fID='list_to_plot.txt'



probe='probe'
start_date='start_date'
end_date='end_date'



;sc='a'
;
;trange=['2017-07-30','2017-08-31']
;st=trange[0]
;while time_double(st) le time_double(trange[1]) do begin
;  et=time_double(st)+24.*60*60
;
;  start_date=[start_date,time_string(st)]
;  end_date=[end_date,time_string(et)]
;  probe=[probe,sc]
;
;  st=time_double(st)+24.*60*60
;endwhile
;
;trange=['2016-09-17','2016-12-09']
;st=trange[0]
;while time_double(st) le time_double(trange[1]) do begin
;  et=time_double(st)+24.*60*60
;  
;  start_date=[start_date,time_string(st)]
;  end_date=[end_date,time_string(et)]
;  probe=[probe,sc]
;  
;  st=time_double(st)+24.*60*60
;endwhile
;
;trange=['2013-08-16','2013-09-06']
;st=trange[0]
;while time_double(st) le time_double(trange[1]) do begin
;  et=time_double(st)+24.*60*60
;
;  start_date=[start_date,time_string(st)]
;  end_date=[end_date,time_string(et)]
;  probe=[probe,sc]
;
;  st=time_double(st)+24.*60*60
;endwhile
;
;trange=['2013-01-08','2013-02-22']
;st=trange[0]
;while time_double(st) le time_double(trange[1]) do begin
;  et=time_double(st)+24.*60*60
;
;  start_date=[start_date,time_string(st)]
;  end_date=[end_date,time_string(et)]
;  probe=[probe,sc]
;
;  st=time_double(st)+24.*60*60
;endwhile
;
;trange=['2013-03-03','2013-03-03']
;st=trange[0]
;while time_double(st) le time_double(trange[1]) do begin
;  et=time_double(st)+24.*60*60
;
;  start_date=[start_date,time_string(st)]
;  end_date=[end_date,time_string(et)]
;  probe=[probe,sc]
;
;  st=time_double(st)+24.*60*60
;endwhile

sc='b'

trange=['2017-08-05','2017-08-05']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2017-08-13','2017-08-14']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2017-08-22','2017-08-22']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2015-09-17','2015-12-09']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2013-03-03','2013-03-03']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2013-01-08','2013-02-23']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

trange=['2013-05-24','2013-09-07']
st=trange[0]
while time_double(st) le time_double(trange[1]) do begin
  et=time_double(st)+24.*60*60

  start_date=[start_date,time_string(st)]
  end_date=[end_date,time_string(et)]
  probe=[probe,sc]

  st=time_double(st)+24.*60*60
endwhile

list_all=[transpose(start_date),transpose(end_date),transpose(probe)]

output_txt,list_all,filename=dir+fID,format='(A19,1X,A19,1X,A1)'

END