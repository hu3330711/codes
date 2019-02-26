;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

;function cmb_remove_quotes,as
;for i=0,n_elements(as)-1 do begin
;a = strtrim(as[i],2)
;l = strlen(a)
;as[i]=strmid(a,1,l-2 )
;endfor
;return,as
;end

function cmb_remove_quotes,a
return,strmid(strtrim(a,2),1,strlen(strtrim(a,2))-2)
end
