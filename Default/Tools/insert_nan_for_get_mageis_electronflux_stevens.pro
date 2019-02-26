pro insert_nan_for_get_mageis_electronflux_stevens,pa,cr,max_pa,pa_out,cr_out
  n_t=n_elements(pa[*,0])
  n_pa=n_elements(pa[0,*])
  pa_out=pa
  cr_out=cr
  for ttt=0,n_t-1 do begin
    pa_0=reverse(reform(pa[ttt,*]))
    cr_0=reverse(reform(cr[ttt,*]))

    pa_1=pa_0
    cr_1=cr_0
    index0=0
    index1=0
    while ~(pa_0[index0] ge 0 and pa_0[index0] le max_pa) and (index0 le n_pa-2) do begin
      index0=index0+1
      index1=index1+1
      continue
    endwhile
    if index0 ge n_pa-2 then begin
      cr_1[*]=-1.
      continue
    endif
    if fix(pa_0[index0]) lt max_pa-2 then begin
      pa_1[index1]=max_pa
      pa_1[index1+1]=fix(pa_0[index0])+1
      pa_1[index1+2]=pa_0[index0]
      cr_1[index1]=-1.
      cr_1[index1+1]=-1.
      cr_1[index1+2]=cr_0[index0]
      index0=1+index0
      index1=3+index1
    endif
    while pa_0[index0] ge 0 and pa_0[index0+1] ge 0 do begin
      if pa_0[index0]-pa_0[index0+1] gt 2 then begin
        pa_1[index1]=pa_0[index0]
        pa_1[index1+1]=fix(pa_0[index0])
        pa_1[index1+2]=fix(pa_0[index0+1])+1
        cr_1[index1]=cr_0[index0]
        cr_1[index1+1]=-1.
        cr_1[index1+2]=-1.
        index0=index0+1
        index1=index1+3
      endif else begin
        pa_1[index1]=pa_0[index0]
        cr_1[index1]=cr_0[index0]
        index1=index1+1
        index0=index0+1
      endelse
    endwhile
    if pa_0[index0] gt 1 then begin
      pa_1[index1]=pa_0[index0]
      pa_1[index1+1]=fix(pa_0[index0])
      pa_1[index1+2]=0.
      cr_1[index1]=cr_0[index0]
      cr_1[index1+1]=-1.
      cr_1[index1+2]=-1.
    endif

    pa_out[ttt,*]=reverse(pa_1)
    cr_out[ttt,*]=reverse(cr_1)
  endfor
end