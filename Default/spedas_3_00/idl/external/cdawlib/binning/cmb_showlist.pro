;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;

function cmb_showlist,list,title=title,ysize=ysize,xsize=xsize
if n_elements(ysize) eq 0 then ysize=25
;main showlist
;if n_elements(base) ne 0 then widget_control,base,/destroy 
if n_elements(title) eq 0 then title='LIST'
base=widget_base(title=title)
a1 = widget_list(base,value=list,xsize=xsize,ysize=ysize,uvalue=list)
widget_control,base,/realize
return,base
end
