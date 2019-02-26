
function cmb_listofvartobebinned, d
; tobin = cmb_listofvartobebinned( d)
;return indices of  varaibales in structure d to bin,  d = read_mycdf(....)
n = n_tags(d)
ibin =-1
for ip=0,n-1 do begin
    if d.(ip).var_type eq 'data' then begin
    	print,'varname:',d.(ip).varname
		if cmb_tag_name_exists('ALLOW_BIN',d.(ip)) then begin     
		   if d.(ip).allow_bin eq 'FALSE' then BEGIN
			  print, 'ALLOW_BIN = FALSE, variable:', d.(ip).varname, ' not binned'
		   endif else  ibin = [ibin,ip]
		endif else  ibin = [ibin,ip]
		print,ibin
    endif
endfor
ibin = ibin[where(ibin ge 0)]
return,ibin
end
