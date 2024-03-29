;+
; PROCEDURE:
;         mms_edi_set_metadata
;
; PURPOSE:
;         Helper routine for setting EDI metadata.
;
;$LastChangedBy: egrimes $
;$LastChangedDate: 2018-01-05 13:19:41 -0800 (Fri, 05 Jan 2018) $
;$LastChangedRevision: 24484 $
;$URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/mms/edi/mms_edi_set_metadata.pro $
;-

pro mms_edi_set_metadata, tplotnames, prefix = prefix, data_rate = data_rate, suffix = suffix
  if undefined(prefix) then prefix = 'mms1'
  if undefined(instrument) then instrument = 'edi'
  if undefined(data_rate) then data_rate = 'srvy'
  if undefined(suffix) then suffix = ''
  instrument = strlowcase(instrument) ; just in case we get an upper case instrument

  for sc_idx = 0, n_elements(prefix)-1 do begin
    for name_idx = 0, n_elements(tplotnames)-1 do begin
      tplot_name = tplotnames[name_idx]

      case tplot_name of
        prefix[sc_idx] + '_'+instrument+'_E_dmpa'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + ' ' + strupcase(instrument)
          options, /def, tplot_name, 'labels', ['Ex', 'Ey', 'Ez']
        end
        prefix[sc_idx] + '_'+instrument+'_E_bc_dmpa'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + ' ' + strupcase(instrument) + ' BC'
          options, /def, tplot_name, 'labels', ['Ex', 'Ey', 'Ez']
        end
        prefix[sc_idx] + '_'+instrument+'_v_ExB_dmpa'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + ' ' + strupcase(instrument)
          options, /def, tplot_name, 'labels', ['Vx', 'Vy', 'Vz']
        end
        prefix[sc_idx] + '_'+instrument+'_v_ExB_bc_dmpa'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + ' ' + strupcase(instrument) + ' BC'
          options, /def, tplot_name, 'labels', ['Vx', 'Vy', 'Vz']
        end
        prefix[sc_idx] + '_'+instrument+'_vdrift_dsl_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C' + 'drift velocity'
          options, /def, tplot_name, 'labels', ['Vx DSL', 'Vy DSL', 'Vz DSL']
          spd_set_coord, tplot_name, 'DSL'
        end
        prefix[sc_idx] + '_'+instrument+'_vdrift_gse_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C' + 'drift velocity'
          options, /def, tplot_name, 'labels', ['Vx GSE', 'Vy GSE', 'Vz GSE']
          spd_set_coord, tplot_name, 'GSE'
        end
        prefix[sc_idx] + '_'+instrument+'_vdrift_gsm_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C' + 'drift velocity'
          options, /def, tplot_name, 'labels', ['Vx GSM', 'Vy GSM', 'Vz GSM']
          spd_set_coord, tplot_name, 'GSM'
        end
        prefix[sc_idx] + '_'+instrument+'_e_dsl_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C'+ 'e-field'
          options, /def, tplot_name, 'labels', ['Ex DSL', 'Ey DSL', 'Ez DSL']
          spd_set_coord, tplot_name, 'DSL'
        end
        prefix[sc_idx] + '_'+instrument+'_e_gse_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C' + 'e-field'
          options, /def, tplot_name, 'labels', ['Ex GSE', 'Ey GSE', 'Ez GSE']
          spd_set_coord, tplot_name, 'GSE'
        end
        prefix[sc_idx] + '_'+instrument+'_e_gsm_srvy_l2'+suffix: begin
          options, /def, tplot_name, 'labflag', 1
          options, /def, tplot_name, 'colors', [2,4,6]
          options, /def, tplot_name, 'ytitle', strupcase(prefix[sc_idx]) + '!C' + strupcase(instrument) + '!C' + 'e-field'
          options, /def, tplot_name, 'labels', ['Ex GSM', 'Ey GSM', 'Ez GSM']
          spd_set_coord, tplot_name, 'GSM'
        end
        else:
      endcase
    endfor
  endfor

end