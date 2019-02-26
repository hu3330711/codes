;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

pro cmb_update_meta_data , svartop, varname, var, to_struct=to_struct, level=level

;if keyword_set(to_struct) then begin
;endif else 
cmb_update_top_level_meta_info, svartop, varname, var, level=level, to_struct=to_struct

end
