;
;Copyright 1996-2013 United States Government as represented by the
;Administrator of the National Aeronautics and Space Administration.
;All Rights Reserved.
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.
;


pro cmb_cdf_check_if_dependencies_are_time_varying,d, iv $
   ,set_depend_to_dominant_mode=set_depend_to_dominant_mode, multiple_modes=multiple_modes
; cmb_cdf_check_if_dependencies_are_time_varying,d, iv
;Note if the attribute CDFMAJOR='ROW_MAJOR then the variabile dimensions are [depend_1,depend_2,depend_0] else [depend_2,depend_1,depend_0]

; multiple_modes = 0 ;interpolate minor modes to major mode
;                  1 set minor modes to fillval, default is 1
depend=''
a = d.(iv)
zdepends = cmb_cdf_get_dependencies_dimensionandsize(d) ; not used, diagnositic check
if keyword_set(not_zero) eq 0 then if cmb_tag_name_exists('depend_0',a) then depend = cmb_add_element(depend,a.depend_0)
;if keyword_set(multiple_modes) eq 0 then multiple_modes=1 ; set minor modes to fillval
if n_elements(multiple_modes) eq 0 then multiple_modes=1 ; set minor modes to fillval
if cmb_tag_name_exists('depend_1',a) then depend = cmb_add_element(depend,a.depend_1)
if cmb_tag_name_exists('depend_2',a) then depend = cmb_add_element(depend,a.depend_2)
if cmb_tag_name_exists('depend_3',a) then depend = cmb_add_element(depend,a.depend_3)
if cmb_tag_name_exists('depend_4',a) then depend = cmb_add_element(depend,a.depend_4)
ii=where(depend ne '')
if ii[0] eq -1 then return
depend=depend[ii]
depend = cmb_unique_string(depend) 
ndimdata = n_elements(size(cmb_dat(a),/dimen))
data = cmb_dat(a)
for i=0,n_elements(depend)-1 do begin
       ip = where( strupcase(depend[i]) eq tag_names(d)) & ip=ip[0]
       vname = depend[i]
       x = cmb_dat(d.(ip))
       ndim =  n_elements(size(x,/dimen) )
       if ndim eq 1 then goto,next
       if ndim gt 2 then begin
          print,'routine cmb_cdf_check_dependencies_are_time_varying assumes that the dependencey dimensions are < 3'
          print,'vname:', vname
          stop
       endif
       xu = cmb_unique_arr(transpose(x),cnts=cnts,isame=isame)
       xu = transpose(xu)
       if n_elements(cnts) gt 1 then begin
          cntsmax = max(cnts,imax)
          j = where(isame eq imax) & j=j[0]
          ;x_dominant_mode = xu[*,j]
          xd = x[*,j]
          ixd = cmb_var_dependency_location(vname,a,z=zdepends) ;index of this dependency in the data array
          if keyword_set(set_depend_to_dominant_mode) then goto, next1
          print,'**********************************************************************'
          print,'WARNING DEPENDENCY:', vname, ' IS TIME DEPENDENT'
          ;help,x,xu
          print,'occurrence of unique vectors of ' + vname + ':',cnts
          help,multiple_modes, ndimdata
          if multiple_modes  or ndimdata gt 2 then print,'setting data of minor modes to fillval:'  $
          else print,'interpolating minor modes'
          for iu=0,n_elements(cnts)-1 do begin
              if cnts[iu] ne cntsmax then begin
                 ii=where(isame eq iu)
                 xo = x[*,ii[0]]
                 ;help,ii,cnts[iu]
                 if n_elements(ii) ne cnts[iu] then begin
                    print,'error: cnts ne cnts:',cnts[iu], n_elements(ii)
                    stop
                 endif
                 case ndimdata of
                 2:begin
                     ;xo = x[*,ii[0]]
                     datatemp = data[*,ii]
                     ;ik=where(datatemp eq a.fillval)
                     case multiple_modes of
		      0:begin
			;for ik=0,n_elements(ii)-1 do datatemp[*,ik]=interpol( datatemp[*,ik],xo,xd)
			cmb_interp_modes2d,datatemp,xo,xd,a.fillval
			data[*,ii] = datatemp
		      end
		      1:data[*,ii] = a.fillval
                     endcase
                   end
                 3:begin
                   case multiple_modes of
                   0:begin
                    datatemp = data[*,*,ii]
                    cmb_interp_modes3d,datatemp,xo,xd,ixd,a.fillval
                    data[*,*,ii] = datatemp
                    end 
                    1:data[*,*,ii] = a.fillval
                    endcase
                   end
                 4:begin
                    data[*,*,*,ii] = a.fillval
                    ;stop
                   end
                  else: begin
                    print,'Dimension of Data greater than 4:', size(data,/dimen)
                    stop
                  endelse
                  endcase              
                endif       
          endfor
          print,'**********************************************************************'
          next1: ii=where( isame ne imax)
          xumax =xu[*,imax]
          for ic=0, n_elements(xumax)-1 do x[ic,ii] = xumax[ic]
          ;if keyword_set(set_depend_to_dominant_mode) then d.(ip).dat=x
          if keyword_set(set_depend_to_dominant_mode) then  cmb_dat_storedata, d,x, ip
          if keyword_set(set_depend_to_dominant_mode) then  d.(ip).depend_0 = ''
          ;if keyword_set(set_depend_to_dominant_mode) then stop

       endif
       next: ;check next dependency
endfor
;d.(iv).dat = data
cmb_dat_storedata, d,data, iv
end

