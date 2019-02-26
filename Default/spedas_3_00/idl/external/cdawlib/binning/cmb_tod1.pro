
;Caveat Emptor: this code was written by Scott Boardsen, Heliophysics Division, NASA/GSFC and UMBC/GEST.
function cmb_tod1,hr,min,sec
if n_elements(min) eq 0 then min = 0
if n_elements(sec) eq 0 then sec = 0
return, (hr*60d0 + min)*60d0 + sec
end 
