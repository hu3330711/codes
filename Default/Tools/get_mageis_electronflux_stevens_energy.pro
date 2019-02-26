pro get_mageis_electronflux_stevens_energy,time,sc,mode_name,ek,g0de
  ek=dblarr(8)
  if time_double(time) ge time_double('2013-07-12') and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then ek=[34,54,78,108,143,182,223]
  if (time_double(time) lt time_double('2013-07-12') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then ek=[34,62,129]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then ek=[34,62,129]

  if time_double(time) ge time_double('2013-07-12') and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then ek=[32,51,74,101,132,168,208]
  if (time_double(time) lt time_double('2013-07-12') and time_double(time) ge time_double('2013-04-03')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then ek=[32,58,121]
  if (time_double(time) lt time_double('2013-04-03') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then ek=[35,60,117]

  if time_double(time) ge time_double('2015-09-16') and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then ek=[230,334,454,584,724,879,1031]
  if (time_double(time) lt time_double('2015-09-16') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then ek=[260,492,802]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then ek=[146,288,684]

  if time_double(time) ge time_double('2015-09-16') and (sc eq 'B' or sc eq 'b') and mode_name eq 'M35' then ek=[246,354,475,604,749,909,1066]
  if (time_double(time) lt time_double('2015-09-16') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M35' then ek=[279,515,830]

  if time_double(time) ge time_double('2013-07-14') and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then ek=[238,346,465,646,952]
  if (time_double(time) lt time_double('2013-07-14') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then ek=[269,509,821]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-10-09')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then ek=[272,509,821]

  if time_double(time) ge time_double('2013-07-13') and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then ek=[243,350,470,654,941]
  if (time_double(time) lt time_double('2013-07-13') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then ek=[275,515,821]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then ek=[275,515,821]

  ek=double(ek)

  g0de=dblarr(8)
  if time_double(time) ge time_double('2013-07-12') and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then g0de=[4.13E-2,5.73E-2,6.056E-2,6.88E-2,7.35E-2,6.90E-2,5.98E-2]
  if (time_double(time) lt time_double('2013-07-12') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then g0de=[3.77E-2,0.112,0.208]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'LOW' then g0de=[5.93E-2,0.120,0.190]

  if time_double(time) ge time_double('2013-07-12') and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then g0de=[4.33E-2,5.41E-2,5.926E-2,6.605E-2,6.460E-2,6.23E-2,5.96E-2]
  if (time_double(time) lt time_double('2013-07-12') and time_double(time) ge time_double('2013-04-03')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then g0de=[4.56E-2,0.107,0.202]
  if (time_double(time) lt time_double('2013-04-03') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'LOW' then g0de=[4.72E-2,0.104,0.16]

  if time_double(time) ge time_double('2015-09-16') and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then g0de=[0.308,0.322,0.324,0.307,0.2835,0.252,0.202]
  if (time_double(time) lt time_double('2015-09-16') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then g0de=[0.606,0.607,0.683]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M35' then g0de=[0.319,0.967,0.944]

  if time_double(time) ge time_double('2015-09-16') and (sc eq 'B' or sc eq 'b') and mode_name eq 'M35' then g0de=[0.333,0.339,0.325,0.309,0.2684,0.240,0.195]
  if (time_double(time) lt time_double('2015-09-16') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M35' then g0de=[0.650,0.612,0.649]

  if time_double(time) ge time_double('2013-07-14') and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then g0de=[0.323,0.327,0.328,0.571,0.449]
  if (time_double(time) lt time_double('2013-07-14') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then g0de=[0.633,0.616,0.679]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-10-09')) and (sc eq 'A' or sc eq 'a') and mode_name eq 'M75' then g0de=[0.687,0.647,0.712]

  if time_double(time) ge time_double('2013-07-13') and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then g0de=[0.330,0.333,0.321,0.561,0.387]
  if (time_double(time) lt time_double('2013-07-13') and time_double(time) ge time_double('2013-04-04')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then g0de=[0.627,0.617,0.619]
  if (time_double(time) lt time_double('2013-04-04') and time_double(time) ge time_double('2012-12-23')) and (sc eq 'B' or sc eq 'b') and mode_name eq 'M75' then g0de=[0.679,0.638,0.628]

end