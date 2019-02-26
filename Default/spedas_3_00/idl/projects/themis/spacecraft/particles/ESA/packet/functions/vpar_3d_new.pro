;+
;FUNCTION:	vpar_3d_new(dat,ENERGY=en,ERANGE=er,EBINS=ebins,ANGLE=an,ARANGE=ar,BINS=bins)
;INPUT:	
;	dat:	structure,	3d data structure 
;KEYWORDS
;	ENERGY:	fltarr(2),	optional, min,max energy range for integration
;	ERANGE:	fltarr(2),	optional, min,max energy bin numbers for integration
;	EBINS:	bytarr(na),	optional, energy bins array for integration
;					0,1=exclude,include,  
;					na = dat.nenergy
;	ANGLE:	fltarr(2,2),	optional, angle range for integration
;				theta min,max (0,0),(1,0) -90<theta<90 
;				phi   min,max (0,1),(1,1)   0<phi<360 
;	ARANGE:	fltarr(2),	optional, min,max angle bin numbers for integration
;	BINS:	bytarr(nb),	optional, angle bins array for integration
;					0,1=exclude,include,  
;					nb = dat.ntheta
;	BINS:	bytarr(na,nb),	optional, energy/angle bins array for integration
;					0,1=exclude,include
;PURPOSE:
;	Returns Vpar, km/s, corrects for spacecraft potential if dat.sc_pot exists
;NOTES:	
;	Function normally called by "get_3dt" or "get_2dt" to 
;	generate time series data for "tplot.pro".
;
;CREATED BY:
;	J.McFadden	07-6-05	
;LAST MODIFICATION:
;-
function vpar_3d_new,dat2,ENERGY=en,ERANGE=er,EBINS=ebins,ANGLE=an,ARANGE=ar,BINS=bins,_extra=_extra

vpar = 0.

if dat2.valid eq 0 then begin
  dprint, 'Invalid Data'
  return, vpar
endif

vel = v_3d_new(dat2,ENERGY=en,ERANGE=er,EBINS=ebins,ANGLE=an,ARANGE=ar,BINS=bins,_extra=_extra)

vperp = -crossp2(crossp2(vel,dat2.magf),dat2.magf)/total(dat2.magf*dat2.magf)

vpar=vel-vperp

; units are mV/m

return, vpar

end

