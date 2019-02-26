PRO plot_emphisis_l4_from_list
  
  trange=['2015-09-04/07:00','2015-09-04/08:00']
  trange=['2015-09-19/08:30','2015-09-19/09:20']
  trange=['2016-01-24/10:40','2016-01-24/11:30']
  trange=['2016-02-09/03:00','2016-02-09/03:40']
  trange=['2016-03-20/09:20','2016-03:20/09:55']
  trange=['2018-05-28/05:50','2018-05-28/09:50']
  
  get_emphisis_l4,probe='a',trange=trange
  tplot,['bsum','esum'],trange=trange

  ;epssave
end

