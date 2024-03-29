;+
; MMS HPCA summary QL plots crib sheet
;
; H+ spectra
; He++ spectra
; O+ spectra
; density (H+, O+)
; H+ velocity
; O+ velocity
; temperature (H+, O+)
;
; do you have suggestions for this crib sheet?
;   please send them to egrimes@igpp.ucla.edu
;
; $LastChangedBy: egrimes $
; $LastChangedDate: 2016-08-09 15:13:07 -0700 (Tue, 09 Aug 2016) $
; $LastChangedRevision: 21627 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/mms/examples/quicklook/mms_load_hpca_summary_qlplots.pro $
;-

probe=1
probe = strcompress(string(probe), /rem)
date = '2015-10-16'
timespan, date, 1

; options for send_plots_to:
;   ps: postscript files
;   png: png files
;   win: creates/opens all of the tplot windows
send_plots_to = 'win'
plot_directory = 'hpca_summary/'+time_string(date, tformat='YYYY/MM/DD/')

tplot_options,'xmargin',[15,15]              ; Set left/right margins to 10 characters
tplot_options,'ymargin',[4,5]                ; Set top/bottom margins to 4/2 lines

postscript = send_plots_to eq 'ps' ? 1 : 0

; handle any errors that occur in this script gracefully
catch, errstats
if errstats ne 0 then begin
  error = 1
  dprint, dlevel=1, 'Error: ', !ERROR_STATE.MSG
  catch, /cancel
endif

mms_load_fgm, instrument='dfg', probe=probe, data_rate='srvy', level='ql'
mms_load_hpca, datatype='moments', probe=probe, level='l1b', data_rate='srvy'
mms_load_hpca, datatype='flux', probe=probe, level='l1b', data_rate='srvy'
mms_hpca_calc_anodes, fov=[0, 360]
spd_mms_load_bss, /include_labels, datatype=['fast', 'burst']

; let's put the ephemeris data at the bottom
eph_variable = 'mms'+strcompress(string(probe), /rem)+'_ql_pos_gse'
suffix_kludge = ['0', '1', '2'] ; because the suffix is different depending on the level...

; eph_variable = 'mms'+strcompress(string(i), /rem)+'_dfg_srvy_gsm_dmpa'
calc,'"'+eph_variable+'_re" = "'+eph_variable+'"/6371.2'

; split the position into its components
split_vec, eph_variable+'_re'

; set the label to show along the bottom of the tplot
options, eph_variable+'_re_'+suffix_kludge[0],ytitle='X (Re, GSE)'
options, eph_variable+'_re_'+suffix_kludge[1],ytitle='Y (Re, GSE)'
options, eph_variable+'_re_'+suffix_kludge[2],ytitle='Z (Re, GSE)'
options, eph_variable+'_re_3', ytitle='R (Re)' ; magnitude

position_vars = [eph_variable+'_re_3', eph_variable+'_re_'+suffix_kludge[2], eph_variable+'_re_'+suffix_kludge[1], eph_variable+'_re_'+suffix_kludge[0]]


store_data, 'mms'+probe+'_hpca_number_density', data='mms'+probe+['_hpca_hplus_number_density', '_hpca_oplus_number_density']
store_data, 'mms'+probe+'_hpca_scalar_temperature', data='mms'+probe+['_hpca_hplus_scalar_temperature', '_hpca_oplus_scalar_temperature']

options, 'mms'+probe+'_hpca_number_density', labflag=1, colors=[0, 2], ytitle='HPCA!CDensity'
options, 'mms'+probe+'_hpca_scalar_temperature', labflag=1, colors=[0, 2], ytitle='HPCA!CTemp'

panels = 'mms'+probe+['_hpca_hplus_flux_elev_0-360', $
          '_hpca_heplus_flux_elev_0-360', $
          '_hpca_oplus_flux_elev_0-360', $
          '_hpca_number_density', $
          '_hpca_hplus_ion_bulk_velocity', $
          '_hpca_oplus_ion_bulk_velocity', $
          '_hpca_scalar_temperature']

mms_tplot_quicklook, panels, title='MMS'+probe+' HPCA Summary', var_label=position_vars, $
          burst_bar = 'mms_bss_burst', fast_bar = 'mms_bss_fast'

if postscript then tprint, plot_directory + 'mms'+probe+"_hpca_hplus_ql"

if send_plots_to eq 'png' then begin
  mms_gen_multipngplot, 'mms'+probe+'_hpca_'+ $
    time_string(date, tformat='YYYYMMDD_hhmmss.fff'), date, directory = plot_directory, /mkdir, $
    vars24 = panels, vars06 =  panels, vars02 = panels, vars12=panels, $
    burst_bar = 'mms_bss_burst', $
    fast_bar = 'mms_bss_fast'
endif
stop

end
