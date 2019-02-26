PRO dir_init

setenv,'ROOT_DATA_DIR=/projectnb/burbsp/big/SATELLITE/'
 
;-------------------------| 
;-----------RBSP----------|
;-------------------------|
 
;ect

  defsysv,'!rbsp_ect',exists=exists
  
  if not keyword_set(exists) then begin
    defsysv,'!rbsp_ect', file_retrieve(/structure_format)
  endif
  
  !rbsp_ect=file_retrieve(/structure_format)
  
  !rbsp_ect.remote_data_dir='https://rbsp-ect.lanl.gov/data_pub/'
  !rbsp_ect.local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/www.rbsp-ect.lanl.gov/data_pub/'
  !rbsp_ect.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
  
;emfisis

  defsysv,'!rbsp_emfisis',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!rbsp_emfisis', file_retrieve(/structure_format)
  endif

  !rbsp_emfisis=file_retrieve(/structure_format)

  !rbsp_emfisis.remote_data_dir='https://emfisis.physics.uiowa.edu/Flight/'
  !rbsp_emfisis.local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/emfisis.physics.uiowa.edu/Flight/'
  !rbsp_emfisis.fig_dir='/projectnb/burbsp/home/xcshen/figs/' 
  
;mageis_hr
   
  defsysv,'!RBSP_MAGEISHR',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!RBSP_MAGEISHR', file_retrieve(/structure_format)
  endif

  !RBSP_MAGEISHR=file_retrieve(/structure_format)

  !RBSP_MAGEISHR.remote_data_dir='https://rbsp-ect.newmexicoconsortium.org/data_prot/'
  !RBSP_MAGEISHR.local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/rbsp-ect.newmexicoconsortium.org/data_prot/'
  !RBSP_MAGEISHR.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
 
;efw

  defsysv,'!rbsp_efw',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!rbsp_efw', file_retrieve(/structure_format)
  endif

  !rbsp_efw=file_retrieve(/structure_format)

  !rbsp_efw.remote_data_dir='http://rbsp.space.umn.edu/data/rbsp/'
  !rbsp_efw.local_data_dir='/projectnb/burbsp/big/SATELLITE/rbsp/rbsp.space.umn.edu/data/rbsp/'
  !rbsp_efw.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
;-------------------------|
;-----------GOES----------|
;-------------------------|

  defsysv,'!goes',exists=exists
  
  if not keyword_set(exists) then begin
    defsysv,'!goes', file_retrieve(/structure_format)
  endif
  
  !goes=file_retrieve(/structure_format)

  !goes.remote_data_dir='https://cdaweb.gsfc.nasa.gov/pub/data/goes/'
  !goes.local_data_dir='/projectnb/burbsp/big/SATELLITE/goes/'
  !goes.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
  
;-------------------------|
;-----------POES----------|
;-------------------------|

;raw

  defsysv,'!poes_raw',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!poes_raw', file_retrieve(/structure_format)
  endif
  
  !poes_raw=file_retrieve(/structure_format)

  !poes_raw.remote_data_dir='https://satdat.ngdc.noaa.gov/sem/poes/data/raw/ngdc/'
  !poes_raw.local_data_dir='/projectnb/burbsp/big/SATELLITE/poes/raw/ngdc/'  
  !poes_raw.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
  
;processed

  defsysv,'!poes_proc',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!poes_proc', file_retrieve(/structure_format)
  endif
  
  !poes_proc=file_retrieve(/structure_format)
  
  !poes_proc.remote_data_dir='https://satdat.ngdc.noaa.gov/sem/poes/data/processed/ngdc/uncorrected/full/'
  !poes_proc.local_data_dir='/projectnb/burbsp/big/SATELLITE/poes/processed/ngdc/uncorrected/full/' 
  !poes_proc.fig_dir='/projectnb/burbsp/home/xcshen/figs/'


;-------------------------|
;-----------MMS-----------|
;-------------------------|

  defsysv,'!mms',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!mms', file_retrieve(/structure_format)
  endif

  !mms=file_retrieve(/structure_format)
  !mms.local_data_dir='/projectnb/burbsp/big/SATELLITE/mms/'
  !mms.remote_data_dir='https://spdf.gsfc.nasa.gov/pub/data/mms/'
;-------------------------|
;-----------EIC ----------|
;-------------------------|

  defsysv,'!eic',exists=exists

  if not keyword_set(exists) then begin
    defsysv,'!eic', file_retrieve(/structure_format)
  endif

  !eic=file_retrieve(/structure_format)

  !eic.remote_data_dir='http://vmo.igpp.ucla.edu/data1/SECS/EICS/'
  !eic.local_data_dir='/projectnb/burbsp/big/GROUND/eic/'  
  !eic.fig_dir='/projectnb/burbsp/home/xcshen/figs/'
  
 
  
;-------------------------|
;-----------THEMIS--------|
;-------------------------|

defsysv,'!themis',exists=exists

if not keyword_set(exists) then begin
  defsysv,'!themis', file_retrieve(/structure_format)
endif

!themis=file_retrieve(/structure_format)
!themis.remote_data_dir = 'http://themis.ssl.berkeley.edu/data/themis/'
!themis.local_data_dir='/projectnb/burbsp/big/SATELLITE/themis/data/'
!themis.init=1
;-------------------------|
;-----------ARASE--------|
;-------------------------|

defsysv,'!arase',exists=exists

if not keyword_set(exists) then begin
  defsysv,'!arase', file_retrieve(/structure_format)
endif

!arase=file_retrieve(/structure_format)

!arase.remote_data_dir='https://ergsc.isee.nagoya-u.ac.jp/data/ergsc/satellite/erg/'

!arase.local_data_dir='/projectnb/burbsp/big/SATELLITE/erg/ergsc.isee.nagoya-u.ac.jp/data/ergsc/satellite/erg/'


;-------------------------|
;-----------files---------|
;-------------------------|

defsysv,'!files',exists=exists

if not keyword_set(exists) then begin
  defsysv,'!files', file_retrieve(/structure_format)
endif

!files=file_retrieve(/structure_format)

!files.fig_dir='/projectnb/burbsp/home/xcshen/'
!files.doc_dir='/projectnb/burbsp/home/xcshen/'
  
return


END
