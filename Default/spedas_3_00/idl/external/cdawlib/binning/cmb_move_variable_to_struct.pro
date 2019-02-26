;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_create_new_struct, time_name,t_out, vname, valueout,valueout_nbin
;s = cmb_create_new_struct( time_name,t_out, vname, valueout,valueout_nbin)
    s = create_struct(time_name, t_out)
    s = create_struct(s, vname, valueout)
    if n_elements( valueout_nbin) ne 0 then $
    if n_elements( valueout_nbin) eq n_elements(valueout) then s = create_struct(s, vname+'_nbin', valueout_nbin)
    return,s
end

pro cmb_move_variable_to_struct, strname, time_name,t_out, vname, valueout,valueout_nbin, dt_sec, level=level
;strname=name of structure

if n_elements(level) eq 0 then level=1
IF N_ELEMENTS(ROUTINE_NAMES(STRNAME, FETCH=LEVEL)) GT 0 THEN  s  = ROUTINE_NAMES(STRNAME, FETCH=LEVEL) ;retrieve structure from the calling level

;help,s, strname, time_name,t_out, vname, valueout,valueout_nbin, dt_sec

if n_elements(s) ne 0 then begin ; strname already exists

   tnames= tag_names(s)
   if (where(strlowcase(time_name) eq strlowcase(tnames)))(0) eq -1 then s = create_struct(s,time_name, t_out) 
   if (where(strlowcase(vname) eq strlowcase(tnames)))(0) eq -1 then s = create_struct(s, vname, valueout) $
   else s = cmb_create_new_struct( time_name,t_out, vname, valueout,valueout_nbin)
   
   if n_elements( valueout_nbin) ne 0 then $
      if n_elements( valueout_nbin) eq n_elements(valueout) then $
      if (where(strlowcase(vname+'_nbin') eq strlowcase(tnames)))(0) eq -1 then $
         s = create_struct(s, vname+'_nbin', valueout_nbin)
end else begin    
    s = create_struct(time_name, t_out)
    s = create_struct(s, vname, valueout)
    if n_elements( valueout_nbin) ne 0 then $
    if n_elements( valueout_nbin) eq n_elements(valueout) then s = create_struct(s, vname+'_nbin', valueout_nbin)
endelse

DUMMY  = ROUTINE_NAMES(strname, s, STORE=level)
;  DUMMY  = ROUTINE_NAMES(time_name, t_out, STORE=1) ; store at top level
;  DUMMY  = ROUTINE_NAMES(vname, valueout, STORE=1) ; store at top level
;  if dt_sec gt 0 then DUMMY  = ROUTINE_NAMES(vname+'_nbin', valueout_nbin, STORE=1) 
end
