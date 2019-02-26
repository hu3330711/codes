;$Author: ryurow $
;$Date: 2017/05/31 20:26:20 $
;$Revision: 1.26 $
; This file contains a utility function to return the date of the last
; modification to the library.

; Return a string with the date and version of binning software being used.
; Note: this string should be updated manually with each new release of the
; binning software.
function cmb_bin_version
    return, 'Binning library version is: 1.02.01 (May 16, 2017)'
end
