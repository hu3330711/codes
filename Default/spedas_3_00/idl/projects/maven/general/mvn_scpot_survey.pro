;+
;PROCEDURE:   mvn_scpot_survey
;PURPOSE:
;  Makes a survey of the spacecraft potential at periapsis +/- 1 minute.
;
;USAGE:
;  mvn_scpot_survey, result=result
;
;INPUTS:
;      None.
;
;KEYWORDS:
;      DOPLOT:         Create tplot variables.
;       
; $LastChangedBy: dmitchell $
; $LastChangedDate: 2018-04-02 10:32:15 -0700 (Mon, 02 Apr 2018) $
; $LastChangedRevision: 24976 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/maven/general/mvn_scpot_survey.pro $
;
;CREATED BY:    David L. Mitchell  2017-04-02
;FILE: mvn_scpot_survey
;-
pro mvn_scpot_survey, result=result, doplot=doplot

  t0 = time_double('2014-11-15')
  t1 = time_double('2018-03-01')
  oneday = 86400D
  ndays = ((t1 - t0)/oneday) + 1L

  odat = mvn_orbit_num()
  indx = where((odat.peri_time gt t0) and (odat.peri_time lt t1), npts)
  time = odat[indx].peri_time
  onum = odat[indx].num
  alt = odat[indx].sc_alt
  phi = replicate(!values.f_nan, npts)
  raz = phi
  rel = phi
  saz = phi
  sel = phi
  sza = phi
  dt = 60D

  trange = [t0, (t0 + oneday)]
  for i=0L,(ndays-1L) do begin
    if ~(i mod 30) then begin
      timespan, trange[0], 30
      mvn_swe_spice_init, /force
      maven_orbit_tplot, /load, /shadow
      mvn_ramdir, /polar
      get_data, 'V_sc_PL_Phi', data=ram_az
      get_data, 'V_sc_PL_The', data=ram_el
      mvn_sundir, /polar
      get_data, 'Sun_PL_Phi', data=sun_az
      get_data, 'Sun_PL_The', data=sun_el
      get_data, 'sza', data=sc_sza
    endif
    mvn_scpot_restore, trange, result=pot, success=ok
    if (ok) then begin
      pndx = where((time gt (trange[0]+dt)) and (time lt (trange[1]-dt)), count)
      for j=0,(count-1) do begin
        t = time[pndx[j]]
        jndx = where((pot.time gt (t-dt)) and (pot.time lt (t+dt)), npts)
        if (npts gt 0) then phi[pndx[j]] = average(pot[jndx].potential, /nan)
        k = nn(ram_az.x, time[pndx[j]])
        raz[pndx[j]] = ram_az.y[k]
        rel[pndx[j]] = ram_el.y[k]
        k = nn(sun_az.x, time[pndx[j]])
        saz[pndx[j]] = sun_az.y[k]
        sel[pndx[j]] = sun_el.y[k]
        k = nn(sc_sza.x, time[pndx[j]])
        sza[pndx[j]] = sc_sza.y[k]
      endfor
    endif
    trange += oneday
  endfor

  result = {time:time     , $  ; UTC/SCET of geometric periapsis
            orbit:onum    , $  ; periapsis number
            potential:phi , $  ; spacecraft potential at periapsis +/- 1 min (V)
            ram_az:raz    , $  ; RAM azimuth at periapsis (deg)
            ram_el:rel    , $  ; RAM elevation at periapsis (deg)
            sun_az:saz    , $  ; Sun azimuth at periapsis (deg)
            sun_el:sel    , $  ; Sun elevation at periapsis (deg)
            alt:alt       , $  ; areodetic altitude at periapsis (km)
            sza:sza          } ; solar zenith angle at periapsis (deg)

  if keyword_set(doplot) then begin
    tpclear

    store_data,'pot',data={x:result.time, y:result.potential}
    options,'pot','ytitle','Potential (V)'
    options,'pot','colors',[4]
    options,'pot','constant',0
    options,'pot','psym',10

    store_data,'raz',data={x:result.time, y:result.ram_az}
    ylim,'raz',0,360,0
    options,'raz','ytitle','RAM Azimuth'
    options,'raz','colors',[4]
    options,'raz','yticks',4
    options,'raz','yminor',3
    options,'raz','constant',[90,180,270]
    options,'raz','psym',10

    store_data,'rel',data={x:result.time, y:result.ram_el}
    ylim,'rel',-90,90,0
    options,'rel','ytitle','RAM Elevation'
    options,'rel','colors',[4]
    options,'rel','yticks',2
    options,'rel','yminor',3
    options,'rel','constant',0
    options,'rel','psym',10

    store_data,'saz',data={x:result.time, y:result.sun_az}
    ylim,'saz',0,360,0
    options,'saz','ytitle','Sun Azimuth'
    options,'saz','colors',[4]
    options,'saz','yticks',4
    options,'saz','yminor',3
    options,'saz','constant',[90,180,270]
    options,'saz','psym',10

    store_data,'sel',data={x:result.time, y:result.sun_el}
    ylim,'sel',-90,90,0
    options,'sel','ytitle','Sun Elevation'
    options,'sel','colors',[4]
    options,'sel','yticks',2
    options,'sel','yminor',3
    options,'sel','constant',0
    options,'sel','psym',10

    store_data,'alt',data={x:result.time, y:result.alt}
    ylim,'alt',100,200,0
    options,'alt','ytitle','Altitude (km)!cEllipsoid'
    options,'alt','colors',[4]
    options,'alt','psym',10

    store_data,'sza',data={x:result.time, y:result.sza}
    ylim,'sza',0,180,0
    options,'sza','ytitle','SZA (deg)'
    options,'sza','colors',[4]
    options,'sza','yticks',2
    options,'sza','yminor',3
    options,'sza','constant',100
    options,'sza','psym',10

    tplot_options,'title','MAVEN Spacecraft Potential at Periapsis'
    timefit, var='pot'
    tplot, ['pot','raz','rel','saz','sez','alt','sza']
  endif

  return

end
