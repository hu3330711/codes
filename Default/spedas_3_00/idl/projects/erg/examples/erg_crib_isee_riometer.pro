;+
; PROGRAM: erg_crib_isee_riometer
;   This is an example crib sheet that will load ISEE riometer data.
;   Open this file in a text editor and then use copy and paste to copy
;   selected lines into an idl window.
;   Or alternatively compile and run using the command:
;     .run erg_crib_isee_riometer
;
; NOTE: See the rules of the road.
;       For more information, see http://stdb2.isee.nagoya-u.ac.jp/riometer/
;
; Written by: S. Kurita, Nov 24, 2017
;             Center for Integrated Data Science, ISEE, Nagoya Univ.
;             erg-sc-core at isee.nagoya-u.ac.jp
;;
;   $LastChangedBy: nikos $
;   $LastChangedDate: 2017-12-05 22:09:27 -0800 (Tue, 05 Dec 2017) $
;   $LastChangedRevision: 24403 $
;   $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/erg/examples/erg_crib_isee_riometer.pro $
;-

; initialize
thm_init

; Specify time range for 1 day
timespan,'2017-03-30',1,/d

; load ISEE induction riometer data. Site is ATH.
erg_load_isee_brio,site='ath'

; plot CNA plot obtained at ATH
tplot,'isee_brio30_ath_64hz_cna'
stop

; merge two tplot variables into one to compare QDC with raw data
store_data,'isee_brio30_ath_64hz_raw_w_qdc',$
           data=['isee_brio30_ath_64hz_raw','isee_brio30_ath_64hz_qdc']

; change color for QDC plot
options,'isee_brio30_ath_64hz_qdc',color=1
tplot,'isee_brio30_ath_64hz_raw_w_qdc'

end
