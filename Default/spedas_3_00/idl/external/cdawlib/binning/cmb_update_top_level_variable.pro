;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

pro cmb_update_top_level_variable, svartop, var, to_struct=to_struct
;INPUT
; svartop - name of top level variable vartop
; var - variable to concatinate to vartop
level=1
IF N_ELEMENTS(ROUTINE_NAMES(svartop, FETCH=LEVEL)) GT 0 THEN vartop  = ROUTINE_NAMES(svartop, FETCH=LEVEL)

if n_elements(vartop) eq 0 then begin
   DUMMY  = ROUTINE_NAMES(svartop, var, STORE=1)
   return
endif

type0 = cmb_var_type(vartop)
type1 = cmb_var_type(var)

if type0 ne type1 then print, vartop + ' is the the same type as ' + var



case type0 of
'STRING': vartop = [vartop, var]
endcase
DUMMY  = ROUTINE_NAMES(svartop, vartop, STORE=1)
end
