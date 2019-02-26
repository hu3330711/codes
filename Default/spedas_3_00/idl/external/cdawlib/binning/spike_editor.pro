;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function spike_editor,datain,sigmul,fillval=fillval,nsum=nsum,igood=ig, ibad=ib
;+
; NAME:
;   spike_editor
;   dataout =  spike_editor(datain,sigmul,fillval=fillval,nsum=nsum,igood=ig, ibad=ib)         
; EXAMPLE USAGE:
;   given time series y of x, filter bad data points in y
;   y=spike_editor(y,sigmul,nsum=nsum,fillval=-1e31,igood=igood, ibad=ibad)
;   plot,x[jgood],y
; PURPOSE:   
; To filter data returning data points judged to be good.
; Based on D. A. Roberts, "An algorithm for finding spurious points in turbulent signals.", 
; COMPUTERS IN PHYSICS, JOURNAL SECTION, SEPT/OCT 1993.
;
; CATEGORY:
; Data fitering.
;
; CALLING SEQUENCE:                                   
; result= cmb_autobad(datain,sigmul,fillval=fillval,nsum=nsum)                    
;                                                     
; INPUTS:                                             
;   datain - one or two dimensional data array of n n_elements: datain[2,n] or datain[n].
;   sigmul - multiplicative factor of standard devidation in each sub array: 5 (default).
;            Absolute values of the (data - mean) > sigmul*standard_deviation 
;            will be flagged as bad (0), if less than then flagged as good (1).
; Keyword Inputs:                                                      
;   fillval - fill values: -1e31 (default).
;   nsum - size of sub-array for each filter step: 100 (default).
;
; OUTPUTS:
;  filtered data
; Keyword Outputs:
;  igood - indices of input data array datain judged to be valid data points
;  ibad - indices of input data array datain judged NOT to be valid data points
; COMMON BLOCKS:
;   None.
;
; SIDE EFFECTS:
;   Unknown.
;
; RESTRICTIONS:
;   Unknown.
;
; PROCEDURE:
;
; MODIFICATION HISTORY:
;   Code developed by Aaron Roberts and Scott Boardsen at GSFC.
;-

ii = cmb_autobad(datain,sigmul,fillval=fillval,nsum=nsum) 
ig = where(ii eq 1)
ib = where(ii eq 0)
if ig[0] eq -1 then return,-1
return, datain[ig]
end
