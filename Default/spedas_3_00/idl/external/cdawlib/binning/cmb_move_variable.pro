;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_tplot_yvar, y
a = size(y,/str)
if a.n_dimensions ge 2 then begin
   return, transpose(y)
endif
return,y
end

function cmb_tplot_dlimit,vname, ameta,a
dlim={ytitle:vname + '(' + ameta.units + ')'}

if a.n_dimensions ge 2 then begin
   dlim = create_struct( dlim, 'spec',1,'zlog',1 )
endif
return, dlim
end


pro cmb_move_variable,time_name, t_out,vname, valueout,valueout_nbin, dt_sec,ameta, tdas=tdas, isodates = isodates, to_struct=to_struct, level=level

icase=0 ;write variables to top level
if keyword_set(tdas) then icase =1
if keyword_set(to_struct) then icase =2

case icase of
0:begin
  DUMMY  = ROUTINE_NAMES(time_name, t_out, STORE=level) ; store at top level
  DUMMY  = ROUTINE_NAMES(vname, valueout, STORE=level) ; store at top level
  if dt_sec gt 0 then DUMMY  = ROUTINE_NAMES(vname+'_nbin', valueout_nbin, STORE=level) ; store at top level
  end
1:begin
  dlim = cmb_tplot_dlimit(vname, ameta,size(valueout,/str))
  dlim_nbin = cmb_tplot_dlimit(vname+'_nbin', ameta,size(valueout_nbin,/str))
  si = size(valueout,/str)
  if si.n_dimensions gt 1 then begin
      v=1. + lindgen(si.dimensions[0])
      cmb_spedas_store_data,vname,dat={x:cmb_jd2unix(t_out), y:cmb_tplot_yvar(valueout),v:v},dlim=dlim
      cmb_spedas_store_data,vname+'_nbin',dat={x:cmb_jd2unix(t_out), y:cmb_tplot_yvar(valueout_nbin),v:v},dlim=dlim_nbin
  endif else begin
      cmb_spedas_store_data,vname,dat={x:cmb_jd2unix(t_out), y:cmb_tplot_yvar(valueout)},dlim=dlim
      cmb_spedas_store_data,vname+'_nbin',dat={x:cmb_jd2unix(t_out), y:cmb_tplot_yvar(valueout_nbin)},dlim=dlim_nbin
  endelse
  if n_elements(isodates) eq 2 then cmb_spedas_timespan,isodates
  end

2:begin
  strname = to_struct
  cmb_move_variable_to_struct, strname, time_name,t_out, vname, valueout,valueout_nbin, dt_sec, level=level
  end
endcase
end
