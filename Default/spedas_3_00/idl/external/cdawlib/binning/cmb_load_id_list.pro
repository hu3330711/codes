;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;
; list = cmb_load_id_list(loadfromweb=1)
function cmb_load_id_list,file,loadfromweb=loadfromweb

if n_elements(file) eq 0 then file='List_of_valid_CDAWEB_dataset_IDs_and_variable_names.txt'

if keyword_set(loadfromweb) then begin
   print,'Loading file: "List_of_valid_CDAWEB_dataset_IDs_and_variable_names.txt" from the web'
   a= cmb_datasetid_list()
   print,'Writing file: "List_of_valid_CDAWEB_dataset_IDs_and_variable_names.txt" to your current directory.'
   openw,/get_lun,lun, file
   for i=0,n_elements(a)-1 do printf,lun,a[i]
   free_lun,lun
endif else begin
   a =strarr(file_lines(file))
   openr,/get_lun,lun, file
   readf,lun,a
   free_lun,lun
endelse
;nc = 250     ; not used
;c= strlen(a) ; not used

ii=where( strpos(a,'dataset_id') ne -1)

rec0={dataset_id:'',nvars:0l, vars:strarr(250),info0:'',timerange:'',t0:'',t1:''}
s = replicate(rec0,n_elements(ii))
sold='''
nid = n_elements(ii)
for irec = 0l,nid-1 do begin
    rec = rec0
    i0 = ii[irec]
     if irec  eq nid-1 then i1 = n_elements(a)-1 else i1 = ii[irec+1]-1
    b = a[i0:i1]
    rec.info0 = b[1]
    rec.timerange = strmid(b[2],strpos(b[2],'Time range:')+strlen('Time range:'))
    m = strlen(rec.timerange)
    t0 = strmid(rec.timerange,1,m/2-2)
    t1 = strmid(rec.timerange,m/2+2)
    rec.t0 = t0
    rec.t1 = t1
    ;print,b
    dataset_id = strsplit(b[0],'= ''',/ext) & dataset_id=dataset_id[1]
    rec.dataset_id = dataset_id
    ;vars = strmid(b[3],strpos(b[3],'vars= [') + strlen('vars= [') )
    ;stop
    ;vars = strmid(vars,0, strpos(vars,']'''))
    ;vars = strsplit(vars,',',/extract)
    vars = strsplit(b[3],'= [],''',/ext)
    if n_elements(vars) gt 1 then begin
    vars = vars[1:*]    
    rec.nvars = n_elements(vars)
    rec.vars[0:rec.nvars-1] = vars
    endif
    if vars[0] eq '' then stop
    ;help,rec,/str
    s[irec] = rec
endfor

;aempty = "''"
;ii=where( s.vars[0] ne aempty)
ii=where(s.nvars ge 1)
s=s[ii]
;save,s,file='List_of_valid_CDAWEB_dataset_IDs_and_variable_names.sv'  ;'cdaw_dataset.sav'
return,s
end