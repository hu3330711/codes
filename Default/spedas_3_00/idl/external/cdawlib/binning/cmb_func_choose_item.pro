;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
pro cmb_choose_item_event,event
;Caveat Emptor: this code was written by Scott Boardsen, Heliophysics Division, NASA/GSFC and UMBC/GEST.
common choose_file_dat,index
index = event.index
widget_control,event.top,/destroy
end

function cmb_func_choose_item,list,index=index0,title=title,ysize=ysize,xsize=xsize,listonly=listonly
common choose_file_dat,index
;if n_elements(list) eq 1 then begin
;   item = list[0]
;   index0 = 0
;   return
;endif
if n_elements(title) eq 0 then title='SELECT FILE TO OPEN'
base=widget_base(title=title)
if n_elements(ysize) eq 0 then ysize=min( [n_elements(list) +2 , 30])
if n_elements(xsize) eq 0 then xsize = max(strlen([list,title]) )
a1 = widget_list(base,value=list,xsize=xsize,ysize=ysize)
widget_control,base,/realize
if keyword_set(listonly) then return,2
xmanager,'cmb_choose_item',base,event='cmb_choose_item_event',/modal
item = list[index]
index0 = index
return,item
end
