pro cmb_cdf_add_epoch_bin_to_structure,d,d0
atime = cmb_cdf_get_depend0(d)
atime = atime[0]
istat= cmb_tag_name_exists(atime.name,d,i0)
meta = cmb_cdf_extract_metadata( d, i0)
if cmb_tag_name_exists('VARNAME',meta) then meta.varname = 'EPOCH_BIN'
if cmb_tag_name_exists('FIELDNAM',meta) then meta.FIELDNAM = meta.FIELDNAM + '_bin'
a = create_struct(meta, 'HANDLE',handle_create(value = d0.epoch_bin))
d = create_struct('EPOCH_BIN', a,d)
end
