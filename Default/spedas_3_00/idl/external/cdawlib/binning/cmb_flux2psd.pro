;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
function cmb_flux2psd, flux, energy,ytitle=ytitle,amu=amu,fill=fillvalue
;PURPOSE: convert differential flux in units of   1/(s* cm^2*sterradian* keV) to phase space density in units of s^3/km^3
;INPUT
; flux - differential flux in units of   1/(s* cm^2*sterradian* keV)
;       -note the lead dimension is the energy index.
;        flux = flux[ nenergy, npitchangle, ntime]
;        flux = flux[ nenergy, ntime]
;        flux = flux[ nenergy]
; energy - particle energy in units of keV.
;        energy = energy[nenergy]
;        energy = energy[nenergy,ntime]
;KEYWORDS
; amu-mass of species in atomic mass units
; ytitle - units label
;OUTPUT
;psd -phase space density in units of s^3/km^6
;USAGE
;psd = cmb_flux2psd( flux, energy,amu=amu)
;EXAMPLES
; RBSP HOPE   energy in eV
;     psd = cmb_flux2psd( flux, energy/1d3,amu=amu)
; RBSP ICE   flux in cnts/(Mev*cm^2*s*sterrad)\
;    psd = cmb_flux2psd( flux/1d3, energy*1d3,amu=amu)
if n_elements(fillvalue) eq 0 then fillvalue = -1e31
flux = reform(flux)
energy = reform(energy)
ifill = where( finite(flux) eq 0 or flux eq fillvalue )

;Note: For RBSP HOPE data
;FPDO            FLOAT     = Array[72, 360] [energy,time]
;FPDU            FLOAT     = Array[72, 11, 360] [energy, pitch angle]
; DE-1 EICS UNITS           STRING    '(cm^2-s-sr-keV)^-1'

psd = flux*0
if n_elements(amu) eq 0 then amu=1
n = n_elements(energy)
ytitle='AVERAGED PHASE SPACE DENSITY (km!u-6!n s!u3!n)'

si = size(flux,/dimen)
sie = size(energy,/dimen)

constant = amu^2*0.545

if n_elements(si) eq n_elements(sie) then begin
   if abs((si-sie)^2) eq 0 then return, constant*flux/energy
   print,'dimensions of energy and flux arrays are not equal:'
   stop
endif

case 1 of 
 ((n_elements(si) eq 2 and n_elements(sie) eq 1)): begin ; flux[nenergy, ntime] & energy[nenergy]
     if si[0] eq sie then for i=0,n-1 do psd[i,*] = constant*flux[i,*]/energy[i] $
     else for i=0,n-1 do psd[*,i] = constant*flux[*,i]/energy[i]
  end
 ((n_elements(si) eq 3 and n_elements(sie) eq 1)): begin ; flux[nenergy, npitchangle, ntime] & energy[nenergy]
     if si[0] eq sie then for i=0,n-1 do psd[i,*,*] = constant*flux[i,*,*]/energy[i] $
     else for i=0,n-1 do psd[*,i] = constant*flux[*,i]/energy[i]
  end
 ((n_elements(si) eq 3 and n_elements(sie) eq 2)): begin ; flux[nenergy, npitchangle, ntime] & energy[nenergy,ntime]
     npa = si[1]
     for i=0,npa-1 do psd[*,i,*] = constant*reform(flux[*,i,*])/energy
  end  
  else:stop
endcase
if ifill[0] ne -1 then psd[ifill] = !values.f_nan
return,psd
end
