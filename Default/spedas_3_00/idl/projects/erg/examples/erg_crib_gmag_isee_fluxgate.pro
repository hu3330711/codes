;+
; PROGRAM: erg_crib_gmag_isee_fluxgate
;   This is an example crib sheet that will load ISEE fluxgate magnetometer data.
;   Open this file in a text editor and then use copy and paste to copy
;   selected lines into an idl window.
;   Or alternatively compile and run using the command:
;     .run erg_crib_gmag_stel_fluxgate
;
; NOTE: See the rules of the road.
;       For more information, see http://stdb2.isee.nagoya-u.ac.jp/magne/
;       and http://www1.osakac.ac.jp/crux/ (for mdm and tew).
;
; Written by: Y. Miyashita, Jun 19, 2013
;             ERG-Science Center, ISEE, Nagoya Univ.
;             erg-sc-core at isee.nagoya-u.ac.jp
;
; Renamed from erg_crib_gmag_stel_fluxgate by S. Kurita Nov. 24, 2017.
;
;   $LastChangedBy: nikos $
;   $LastChangedDate: 2017-12-05 22:09:27 -0800 (Tue, 05 Dec 2017) $
;   $LastChangedRevision: 24403 $
;   $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/erg/examples/erg_crib_gmag_isee_fluxgate.pro $
;-

; initialize
thm_init

; set the date and duration (in days)
timespan, '2006-11-20'


; load 1 min resolution data
erg_load_gmag_isee_fluxgate, site='msr kag', datatype='1min'

; view the loaded data names
tplot_names

; plot the H, D, and Z components
tplot, ['isee_fluxgate_mag_*_1min_hdz']
stop

; load 1 sec resolution data
erg_load_gmag_isee_fluxgate, site='msr kag', datatype='1sec'

; view the loaded data names
tplot_names

; plot the H, D, and Z components
tplot, ['isee_fluxgate_mag_*_1sec_hdz']

end
