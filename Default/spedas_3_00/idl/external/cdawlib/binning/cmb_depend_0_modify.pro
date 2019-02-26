
pro cmb_depend_0_modify,d0,d,ip,t_out
if n_elements(d0) eq 0 then d0 = create_struct(d.(ip).depend_0, t_out)
if  cmb_tag_name_exists(d.(ip).depend_0, d0) then return
d0 = create_struct(d0, d.(ip).depend_0, t_out)
end