
function cmb_minmax,x,fill=fill, greaterthan=mini, lessthan = maxi, strict=strict,i=i, sinfo=sinfo
if cmb_var_type(x) eq 'STRING' then return, ['STRING VARAIBLE','STRING VARAIBLE']
if n_elements(x) eq 0 then begin
   print,'in minmax x not defined returning 0'
   return,0
endif
; set strict to filter by greater than instead of greater than or equal etc.
if n_elements(fill) eq 0 then fill = -1e31
i=where( (finite(x) eq 1) and (x ne fill) )
if keyword_set( sinfo) then begin
   print,'no of       elements in x:', n_elements(x)
   print,'no of valid elements in x:',n_elements(i)
endif
if i[0] eq -1 then return, [min(x),max(x)]
if n_elements(xmin) eq 0 then xmin = min(x[i])
if n_elements(xmax) eq 0 then xmax = max(x[i])
if n_elements(mini) eq 1 then begin
    xmin = mini
    strict=1
endif
if n_elements(maxi) eq 1 then begin
   xmax = maxi
   strict=1
endif
if keyword_set(strict) then $
   i=where( (finite(x) eq 1) and (x ne fill) and (x gt xmin) and (x lt xmax) ) $
else $
   i=where( (finite(x) eq 1) and (x ne fill) and (x ge xmin) and (x le xmax) )
if i[0] eq -1 then return, [-1e31,-1e31]
return,[min(x[i]),max(x[i])]
end
