pro rbsp_init
setenv,'ROOT_DATA_DIR=/projectnb/burbsp/big/SATELLITE/'
cdf_leap_second_init
rbsp_emfisis_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/'
rbsp_ect_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/'
rbsp_efw_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/'
rbsp_spice_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/'
thm_init,local_data_dir='/projectnb/burbsp/big/SATELLITE/themis/data/'
thm_set_verbose,0
end
