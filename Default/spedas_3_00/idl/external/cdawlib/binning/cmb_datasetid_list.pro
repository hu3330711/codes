
function cmb_datasetid_list
;a= cmb_datasetid_list()
url ='https://cdaweb.gsfc.nasa.gov/pub/software/cdaweb_idl_clients/cdaweb_get_bin/List_of_valid_CDAWEB_dataset_IDs_and_variable_names.txt'
b = wget( url )
a = wget( url,/string)
return,a
end
