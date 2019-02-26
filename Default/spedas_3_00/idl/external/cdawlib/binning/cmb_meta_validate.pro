
pro cmb_meta_validate,d
; validate depend_0 metadata, change if necessary
;convert epoch_in to standard epoch
;if cdftype is CDF_TIME_TT2000 then nssdc epoch is long64
;if cdftype is CDF_EPOCH16 then nssdc epoch is double precision complex
;return nssdc epoch as the standard double precision value
vartype = ['DOUBLE',   'DCOMPLEX',   'LONG64']
CDFTYPE = ['CDF_EPOCH','CDF_EPOCH16','CDF_TIME_TT2000']
units = ['ms','ns','ns']
tnames = tag_names(d)
depends = cmb_cdf_get_dependencies(d,dp='0') ;retrieve only 0 dependencies
fillval = -1d31
for ip=0,n_elements(depends)-1 do begin    
     iv = where(strlowcase(depends[ip]) eq strlowcase(tnames)) & iv=iv[0]
     if iv ne -1 then begin
        ;print, depends[ip]
        ;help, d.(iv).cdftype,/str
        ii=where( cmb_var_type( cmb_dat( d.(iv)) ) eq vartype) & ii=ii[0]
        print, d.(iv).cdftype,' ',cdftype[ii]
        if d.(iv).cdftype eq cdftype[ii] then goto,skip   ; skip because vartype not changed
        print,  cmb_var_type( cmb_dat( d.(iv)) ),' ', cdftype[ii]
        d.(iv).cdftype = cdftype[ii]
        d.(iv).units = units[ii]
;problem if vartype is different, we need to delete var from structure and create a with new vartype.        
        case cdftype[ii] of
        'CDF_EPOCHa':begin
           end
        'CDF_EPOCH16a':begin
           d.(iv).fillval = dcomplex( fillval, fillval)
           d.(iv).validmin = dcomplex( 6.3148378e+10, 0.0000000)  ;2001 33
           d.(iv).validmax = dcomplex( 6.3776678e+10, 1.0000000e+12) ; 2020 366
           end        
        'CDF_TIME_TT2000a':begin
           d.(iv).fillval = -9223372036854775808
           d.(iv).validmin =-315575942816000000  ; 1990 001
           d.(iv).validmax = 946728067183000000  ; 2029 365
           end 
           else:
        endcase
        skip:
     endif   
endfor

end