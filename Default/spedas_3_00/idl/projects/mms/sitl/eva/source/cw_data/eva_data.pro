; $LastChangedBy: moka $
; $LastChangedDate: 2017-05-02 22:51:02 -0700 (Tue, 02 May 2017) $
; $LastChangedRevision: 23260 $
; $URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/mms/sitl/eva/source/cw_data/eva_data.pro $

;PRO eva_data_update_date, state, update=update
;  if keyword_set(update) then widget_control, state.fldDate, SET_VALUE=state.eventdate
;  sstime = time_string(str2time(state.eventdate))
;  eetime = time_string(str2time(state.eventdate) + state.duration*86400.d)
;  orbit_state = { stime: sstime, etime: eetime, ttime: state.eventdate, $;location to be emphasized
;    probelist: state.probelist}
;  ;widget_control, wid.orbit, SET_VALUE = orbit_state
;END

PRO eva_data_update_time, state, update=update
  if keyword_set(update) then begin; update the fields
    widget_control, state.fldStartTime, SET_VALUE=state.start_time
    widget_control, state.fldEndTime,   SET_VALUE=state.end_time
  endif
;  sstime = time_string(str2time(state.start_time))
;  eetime = time_string(str2time(state.end_time))
;  orbit_state = { stime: sstime, etime: eetime, ttime: state.eventdate, $;location to be emphasized
;    probelist: state.probelist}
END

PRO eva_data_set_value, id, value ;In this case, value = activate
  compile_opt idl2, hidden
  stash = WIDGET_INFO(id, /CHILD)
  WIDGET_CONTROL, stash, GET_UVALUE=state, /NO_COPY
  ;-----
  str_element,/add,state,'pref',value
  ;-----
  WIDGET_CONTROL, stash, SET_UVALUE=state, /NO_COPY
END

FUNCTION eva_data_get_value, id
  compile_opt idl2, hidden
  stash = WIDGET_INFO(id, /CHILD)
  WIDGET_CONTROL, stash, GET_UVALUE=state, /NO_COPY
  ;-----
  ret = state
  ;-----
  WIDGET_CONTROL, stash, SET_UVALUE=state, /NO_COPY
  return, ret
END

FUNCTION eva_data_validate_time, str_stime, str_etime
  
  msg = ''
  stime = str2time(str_stime)
  etime = str2time(str_etime)
  timec = systime(/seconds,/utc)
  timem = str2time('2015-03-12'); MMS launch date
  
  if stime gt etime then msg = 'Start time must be before end time.'
  
  thm_start = str2time('2007-02-17'); THEMIS launch date
  if stime lt thm_start then msg = 'Start time must be later than 2007-02-17.'  
  
  ;if etime gt timec then msg = 'Time range must not be a future.'
  
  ttimeS = str2time('2015-04-09/23:00'); This is the time period used for testing
  ttimeE = str2time('2015-04-11/01:00'); rick's fetch routine
  if (timec lt timem) and (ttimeS lt stime) and (etime lt ttimeE) then msg = ''
  
  return, msg
END

FUNCTION eva_data_load_and_plot, state, cod=cod
  @tplot_com

  ; validate time range
  msg = eva_data_validate_time(state.start_time, state.end_time)
  if strlen(msg) gt 0 then begin
    print, 'EVA: '+msg
    result = dialog_message(msg,/center)
    return, state
  endif

  ; validate parameter file
  result = read_ascii(state.paramFileList[state.paramID],template=eva_data_template())
  paramlist = result.param
  if n_elements(paramlist) eq 0 then begin
    msg =  '!!!!! WARNING: Selected parameter set '+state.paramSetList[state.paramID]+$
      ' is not available !!!!!'
    print, 'EVA: '+ msg
    result = dialog_message(msg,/center)
    return, state
  endif

  ; initialize
  clock = eva_tic('LOAD_AND_PLOT')
  if state.trangeChanged then begin
    del_data,'*'
    str_element,/add,state,'trangeChanged',0
  endif
  plshort = strmid(paramlist,0,2); first 2 letters
  str_element,/add,state,'paramlist',paramlist
  
  ;----------------------
  ; Load SITL
  ;----------------------
  idx=where(strpos(paramlist,'stlm') gt 0,ct)
  paramlist_stlm = (ct ge 1) ? paramlist[idx] : ''
  str_element,/add,state,'paramlist_stlm',paramlist_stlm
  if keyword_set(cod) then begin
    rst_stlm = 'Yes'
  endif else begin
    rst_stlm = (ct ge 1) ? eva_data_load_sitl(state) : 'No'
  endelse
  print, 'EVA: load SITL: number of parameters:'+string(ct)

  ;----------------------
  ; Load THEMIS
  ;----------------------
  
  idx=where(strmatch(plshort,'th'),ct)
  paramlist_thm = (ct ge 1) ? paramlist[idx] : ''
  str_element,/add,state,'paramlist_thm',paramlist_thm
  rst_thm = 'No'
  if (ct ge 1) then begin
    rst_thm = eva_data_load_thm(state)
    if strmatch(rst_thm,'Yes') then begin
      paramlist = strlowcase(state.paramlist_thm)
      probelist = state.probelist_thm
      rst_thm = eva_data_load_reformat(paramlist, probelist)
    endif 
  endif
  ;rst_thm = (ct ge 1) ? eva_data_load_thm(state) : 'No'
  print, 'EVA: load THEMIS: number of parameters:'+string(ct)
  
  ;----------------------
  ; Load MMS
  ;----------------------
  
  idx=where(strmatch(plshort,'mm'),ct)
  paramlist_mms = (ct ge 1) ? paramlist[idx] : ''  
  ;--exceptional parameter --
  idx=where(strmatch(paramlist,'thg_idx_ae'),ct2)
  if ct2 eq 1 then paramlist_mms = [paramlist_mms,'thg_idx_ae']
  ;----    
  str_element,/add,state,'paramlist_mms',paramlist_mms
  rst_mms = 'No'
  if (ct ge 1) then begin
    rst_mms = eva_data_load_mms(state)
    if strmatch(rst_mms,'Yes') then begin
      paramlist = strlowcase(state.paramlist_mms)
      probelist = state.probelist_mms
      rst_mms = eva_data_load_reformat(paramlist, probelist,/FOURTH)
    endif
  endif
  ;rst_mms = (ct ge 1) ? eva_data_load_mms(state) : 'No'
  print, 'EVA: load MMS: number of parameters'+string(ct)

  
  ;----------------------
  ; Plot
  ;----------------------
  if(strcmp(rst_stlm,'Yes') or strcmp(rst_thm,'Yes') or strcmp(rst_mms,'Yes'))then begin
    ; destroy previously displayed windows
    barr = widget_info(/managed); find currently managed windows
    if n_elements(barr) gt 1 then begin
      for b=1,n_elements(barr)-1 do begin ; for each window (except the main window (b=0)),
        widget_control,barr[b],/destroy ; destroy
      endfor
      str_element,/add,tplot_vars,'options.base',-1; reset the 'base' flag
    endif
    ;##############################################################
    eva_data_plot, state; ............. PLOT
    ;##############################################################
    
    if not keyword_set(cod) then begin
      ;Activate DASHBOARD
      tn = tnames('*_stlm_*',ct); Check for the existence of stlm parameters
      s = (ct gt 0)
      id_sitl = widget_info(state.parent, find_by_uname='eva_sitl')
      widget_control, id_sitl, SET_VALUE=s
    endif
  endif
  
  eva_toc,clock,str=str
  return, state
END

FUNCTION eva_data_probelist, state
  widget_control,state.bgTHM,GET_VALUE=gvl_thm
  thm_probes = ['thb','thc','thd','tha','the']
  idx = where(gvl_thm eq 1, ct)
  if ct ge 1 then probelist_thm = thm_probes[idx] else probelist_thm = -1
  str_element,/add,state,'probelist_thm',probelist_thm 
  
  widget_control,state.bgMMS,GET_VALUE=gvl_mms
  mms_probes = ['mms1','mms2','mms3','mms4']
  idx = where(gvl_mms eq 1, ct)
  if ct ge 1 then probelist_mms = mms_probes[idx] else probelist_mms = -1
  str_element,/add,state,'probelist_mms',probelist_mms

  str_element,/add,state,'probelist',probelist
  eva_data_update_time, state,/update
  tot = total(gvl_thm) + total(gvl_mms)
  widget_control,state.bgOPOD,SENSITIVE=(tot gt 1)
  widget_control,state.bgSRTV,SENSITIVE=(tot gt 1)
  return,state
END

FUNCTION eva_data_login, state, evTop
  compile_opt idl2
  
  print,'EVA: accessing MMS SDC...'

  ;---------------------
  ; Establish Connection
  ;---------------------
  user_flag = state.USER_FLAG  
;  ;lgn = eva_login_widget(title='Login as '+state.userType[user_flag], group_leader=evTop)
;  r = get_mms_sitl_connection(group_leader=evTop);, username=lgn.username, password=lgn.username)
;  ; establish connection with login-widget 
;  type = size(r, /type) ;will be 11 if object has been created
;  connected = (type eq 11)
  
  widget_note = 'You must have a valid MMS/SITL account in order to use EVA.'
  connected = mms_login_lasp(username = username, widget_note = widget_note)
    
  msg2 = ''
  FAILED=1

  if connected then begin
    

    ;---------------------
    ; Update DATA MODULE
    ;---------------------
    ;state.paramID = 0
    state = eva_data_paramSetList(state)
    widget_control, state.sbMMS, SENSITIVE=1
    ;widget_control, state.drpSet, SET_VALUE=state.paramSetList
    
    ;---------------------
    ; Get Target Time
    ;---------------------

    unix_FOMstr = eva_sitl_load_soca_getfom(state.PREF, evTop)
    if n_tags(unix_FOMstr) gt 0 then begin
      s = unix_FOMstr
      start_time = time_string(s.timestamps[0],precision=3)
      ;end_time = time_string(s.timestamps[nmax-1],precision=3)
      dtlast = s.TIMESTAMPS[s.NUMCYCLES-1]-s.TIMESTAMPS[s.NUMCYCLES-2]
      end_time = time_string(s.TIMESTAMPS[s.NUMCYCLES-1]+dtlast,precision=3)
      
      ;---------------------
      ; Update SITL MODULE
      ;---------------------
      lbl = ' '+start_time+' - '+end_time
      print,'EVA: updating cw_sitl target_time label:'
      print, 'EVA: '+lbl
      id_sitl = widget_info(state.parent, find_by_uname='eva_sitl')
      sitl_stash = WIDGET_INFO(id_sitl, /CHILD)
      widget_control, sitl_stash, GET_UVALUE=sitl_state, /NO_COPY;******* GET
      widget_control, sitl_state.lblTgtTimeMain, SET_VALUE=lbl; target time time label
      widget_control, sitl_state.bsAction0, SENSITIVE=(user_flag ge 1); main SITL control
      widget_control, sitl_state.bsActionSubmit, SENSITIVE=(user_flag ge 1); submit button
      this_hlSet = (user_flag ge 2) ? sitl_state.hlSet2 : sitl_state.hlSet; hightlight list
      widget_control, sitl_state.drpHighlight, SET_VALUE=this_hlSet; highlight droplit
      str_element,/add,sitl_state,'user_flag',user_flag; synchronize user_flag/userType
      str_element,/add,sitl_state,'userType',state.userType;
      ;widget_control, sitl_state.btnSplit, SENSITIVE= (user_flag ne 4); disable "split" if FPI-cal
      val = mms_load_fom_validation(); Add/update validation structure
      if n_tags(val) eq 0 then begin
        message,'Failed to load validation structure.'
      endif
      str_element,/add,sitl_state,'val',val
      widget_control, sitl_stash, SET_UVALUE=sitl_state, /NO_COPY;******* SET
      
      ;---------------------
      ; Update DATA MODULE
      ;---------------------
      print,'EVA: updating cw_data start and end times'
      str_element,/add,state,'start_time',start_time
      str_element,/add,state,'end_time',end_time
      eva_data_update_time, state,/update
      FAILED=0
    endif else begin; if n_tags(unix_FOMstr)
      
      if  unix_FOMstr eq 3 then begin
        FAILED=0
      endif
    endelse
  endif; if connected

  if FAILED then begin
    str_element,/add,state,'user_flag',0
    widget_control, state.drpUserType, SET_DROPLIST_SELECT=0
    msg = 'Log-in Failed'
  endif else begin
    msg = 'Logged-in!'
    if(user_flag ge 1)then begin
      ut = state.userType[user_flag]
      nl = ssl_newline()
      msg = 'Logged-in as a '+ut
    endif 
  endelse
  answer = dialog_message(msg,/info,title='EVA',/center)
  return, state
END

; The purpose of this routine is to extract necessary parameter-set from 
; all available parameter-sets in the directory.
FUNCTION eva_data_paramSetList, state
  ; 'dir' produces the directory name with a path separator character that can be OS dependent.
  dir = file_search(ProgramRootDir(/twoup)+'parameterSets',/MARK_DIRECTORY,/FULLY_QUALIFY_PATH); directory
  paramFileList_tmp = file_search(dir,'*',/FULLY_QUALIFY_PATH,count=cmax); full path to the files
  filename = strmid(paramFileList_tmp,strlen(dir),1000); extract filenames only
  if strlen(state.pref.EVA_PARAMSET_DIR) gt 0 then begin
    paramFileList_tmp2 = file_search(state.pref.EVA_PARAMSET_DIR,'*',/FULLY_QUALIFY_PATH,count=cmax2); full path to the files
    if cmax2 gt 0 then begin
      filename2 = strmid(paramFileList_tmp2,strlen(state.pref.EVA_PARAMSET_DIR),1000); extract filenames only
      filename = [filename, filename2]
      paramFileList_tmp = [paramFileList_tmp, paramFileList_tmp2]
      cmax = n_elements(paramFileList_tmp)
    endif
  endif
  
  paramSetList = ['dummy']
  paramFileList = ['dummy']
  for c=0,cmax-1 do begin; for each file
    spl = strsplit(filename[c],'_',/extract)
;    case spl[1] of
;      'THM': skip = 0
;      'MMS': skip = (state.user_flag eq 0); skip if guest_user (public user)
;      'SITL': skip = (state.user_flag eq 0) ; skip if guest_user (public user)
;      else: skip = 0
;    endcase
    ;/////////// ; Inserted on 2017 Apr 15
    skip = 0     ; No need to skip because MMS data is open to public
    ;/////////// ; 
    if ~skip then begin
      tmp = strjoin(spl,' '); replace '_' with ' '
      paramSetList = [paramSetList, strmid(tmp,0,strlen(tmp)-4)]; remove file extension .txt etc.
      paramFileList = [paramFileList, paramFileList_tmp[c]]
    endif
  endfor
  str_element,/add,state,'paramSetList',paramSetList[1:*]
  str_element,/add,state,'paramFileList',paramFileList[1:*]
  return, state
END

FUNCTION eva_data_drpSet, state, evindex
  print,'EVA: ***** EVENT: drpSet *****'
  str_element,/add,state,'paramID',evindex
  fname = state.paramFileList[state.paramID]
  fname_broken=strsplit(fname,'/',/extract,count=count)
  fname_param = fname_broken[count-1]
  result = read_ascii(fname,template=eva_data_template(),count=count)
  if count gt 0 then begin
    str_element,/add,state,'paramlist',result.param
    print, 'EVA: reading '+fname_param
  endif else begin; if parameterSet list invalid
    msg = 'The selected parameter-set is not valid. Check the file: '+fname_param
    result = dialog_message(msg,/center)
    print,'EVA: '+msg
  endelse
  return, state
END

FUNCTION eva_data_event, ev
  compile_opt idl2
  
  catch, error_status
  if error_status ne 0 then begin
    catch, /cancel
    eva_error_message, error_status
    message, /reset
    return, {ID:ev.handler, TOP:ev.top, HANDLER:0L }
  endif

  
  parent=ev.handler
  stash = WIDGET_INFO(parent, /CHILD)
  WIDGET_CONTROL, stash, GET_UVALUE=state, /NO_COPY
  exitcode=0

  ;-----
  case ev.id of
    state.drpUserType: begin
      print,'EVA: ***** EVENT: drpUserType *****'
      str_element,/add,state,'user_flag',ev.INDEX
      str_element,/add,state,'trangeChanged',1
      
      ;;;;;;;;;; userType = ['Public','SITL','Super SITL']
      if state.USER_FLAG ne 0 then begin; if not 'Public'....  Get time range from FOMstr
        state = eva_data_login(state,ev.TOP)
      endif
      if state.USER_FLAG eq 0 then begin; ............... Use default time range
        print,'EVA: resetting cw_data start and end times'
        start_time = strmid(time_string(systime(/seconds,/utc)-86400.d*4.d),0,10)+'/00:00:00'
        end_time   = strmid(time_string(systime(/seconds,/utc)-86400.d*4.d),0,10)+'/24:00:00'
        str_element,/add,state,'start_time',start_time
        str_element,/add,state,'end_time',end_time
        eva_data_update_time, state,/update
        state = eva_data_paramSetList(state)
        ;widget_control, state.sbMMS, SENSITIVE=0
        ;widget_control, state.drpSet, SET_VALUE=state.paramSetList
      endif
      end
;    state.btnUpdateABS: begin
;      msg = 'This feature should be ready by May 2017'
;      result = dialog_message(msg,/center)
;      end
    state.fldStartTime: begin
      widget_control, ev.id, GET_VALUE=new_time;get new eventdate
      str_element,/add,state,'start_time',new_time
      str_element,/add,state,'trangeChanged',1
      ;eva_data_update_time, state ; not updating fldStartTime
    end
    state.fldEndTime: begin
      widget_control, ev.id, GET_VALUE=new_time;get new eventdate
      str_element,/add,state,'end_time',new_time
      str_element,/add,state,'trangeChanged',1
      ;eva_data_update_time, state ; not updating fldEndTime
    end
    state.calStartTime: begin
      print,'EVA: ***** EVENT: calStartTime *****'
      otime = obj_new('spd_ui_time')
      otime->SetProperty,tstring=state.start_time
      spd_ui_calendar,'EVA Calendar',otime,ev.top
      otime->GetProperty,tstring=tstring         ; get tstring
      str_element,/add,state,'start_time',tstring; put tstring into state structure
      str_element,/add,state,'trangeChanged',1
      widget_control, state.fldStartTime, SET_VALUE=state.start_time; update GUI field
      ;eva_data_update_time, state
      obj_destroy, otime
    end
    state.calEndTime: begin
      print,'EVA: ***** EVENT: calEndTime *****'
      otime = obj_new('spd_ui_time')
      otime->SetProperty,tstring=state.end_time
      spd_ui_calendar,'EVA Calendar',otime,ev.top
      otime->GetProperty,tstring=tstring
      str_element,/add,state,'end_time',tstring
      str_element,/add,state,'trangeChanged',1
      widget_control, state.fldEndTime, SET_VALUE=state.end_time
      ;eva_data_update_time, state
      obj_destroy, otime
    end
    state.bgTHM: state = eva_data_probelist(state)
    state.bgMMS: state = eva_data_probelist(state)
    state.drpSet: state = eva_data_drpSet(state, ev.index)
    state.load: begin
      print,'EVA: --------------'
      print,'EVA:  EVENT: load '
      print,'EVA: --------------'
      widget_note = 'You must have a valid MMS/SITL account in order to use EVA.'
      connected = mms_login_lasp(username = username, widget_note = widget_note)
      state = eva_data_load_and_plot(state)
      end
    state.loadforce: begin
      print,'EVA: --------------'
      print,'EVA:  EVENT: load '
      print,'EVA: --------------'
      del_data,'*'
      state = eva_data_load_and_plot(state)
      end
    state.bgOPOD: str_element,/add,state,'OPOD',ev.select
    state.bgSRTV: str_element,/add,state,'SRTV',ev.select
    else:
    endcase
    ;-----

WIDGET_CONTROL, stash, SET_UVALUE=state, /NO_COPY
RETURN, { ID:parent, TOP:ev.top, HANDLER:0L }
END

;-----------------------------------------------------------------------------

FUNCTION eva_data, parent, $
  UVALUE = uval, UNAME = uname, TAB_MODE = tab_mode, XSIZE = xsize, YSIZE = ysize
  compile_opt idl2
  
  IF (N_PARAMS() EQ 0) THEN MESSAGE, 'Must specify a parent for eva_data'
  IF NOT (KEYWORD_SET(uval))  THEN uval = 0
  IF NOT (KEYWORD_SET(uname))  THEN uname = 'eva_data'
  
  ; ----- INITIALIZE -----
  
  eventdate = strmid(time_string(systime(/seconds,/utc)-86400.d*4.d),0,10)
  start_time = strmid(time_string(systime(/seconds,/utc)-86400.d*4.d),0,10)+'/00:00:00'
  end_time   = strmid(time_string(systime(/seconds,/utc)-86400.d*4.d),0,10)+'/24:00:00'
  ProbeNamesTHM = ['P1 (THB)','P2 (THC)','P3 (THD)','P4 (THA)','P5 (THE)']
  ProbeNamesMMS = ['MMS 1', 'MMS 2', 'MMS 3', 'MMS 4']
  SetTimeList = ['Default','SITL Current Target Time', 'SITL Back-Structure Time']
  user_flag = 0
  ;userType = ['Guest','MMS member','SITL','Super SITL'];'FPI-cal'
  userType = ['Public','SITL','Super SITL']; MMS data is open to public; No meaning for having Guest 
  
  ;----- PREFERENCES -----
  
  ;home_dir = (file_search('~',/expand_tilde))[0]+'/'
  ;pref = {EVA_CACHE_DIR: home_dir + 'data/mms/sitl/eva_cache/', $
  pref = {EVA_CACHE_DIR: !MMS.LOCAL_DATA_DIR+'sitl/eva_cache/', $
    EVA_PARAMSET_DIR: '',$
    EVA_TESTMODE: 0}

  ;----- STATE ----- 
  state = { $
    pref:          pref,         $; preferences
    parent:        parent,       $; parent widget ID (EVA's main window widget)
    eventdate:     eventdate,    $;
    start_time:    start_time,   $;
    end_time:      end_time,     $
    duration:      1.0,          $;
    stepdate:      1,            $; how many days to increment
    paramID:       0,            $; which parameter set to be used
    OPOD:          0,            $; One Plot One Display
    SRTV:          0,            $; Sort by Variables when display
    probelist_thm: -1,        $; which THM probe(s) to be used
    probelist_mms: 'mms3',           $; which MMS probe(s) to be used
    paramSetList:  '', $; List of ParameterSets
    paramFileList: '',$
    userType: userType, $
    user_flag: user_flag,$
    trangeChanged: 0}
  
  
  ; ----- CONFIG (READ and VALIDATE) -----
  cfg = mms_config_read()         ; Read config file and
  pref = mms_config_push(cfg,pref); push the values into preferences
  
  ; For the following itesm, ignore what's in the config file
  str_element,/add,pref,'ABS_LOCAL',''
  str_element,/add,state,'pref',pref
  str_element,/add,pref,'EVA_CACHE_DIR',!MMS.LOCAL_DATA_DIR+'sitl/eva_cache/'
  state = eva_data_paramSetList(state)

  ;----- CACHE DIRECTORY -----
  ;found = file_test(pref.EVA_CACHE_DIR+'/abs_data')
  ;if not found then file_mkdir, pref.EVA_CACHE_DIR+'/abs_data'
  
  ; ----- WIDGET LAYOUT -----
  
  mainbase = WIDGET_BASE(parent, UVALUE = uval, UNAME = uname, /column,$
    EVENT_FUNC = "eva_data_event", $
    FUNC_GET_VALUE = "eva_data_get_value", $
    PRO_SET_VALUE = "eva_data_set_value", $
    XSIZE = xsize, YSIZE = ysize)
  str_element,/add,state,'mainbase',mainbase
  
  baseUserType = widget_base(mainbase,/row,SPACE=0, YPAD=0)
  str_element,/add,state,'drpUserType',widget_droplist(baseUserType,VALUE=state.userType,TITLE='User Type ')
  ;spaceUserType = widget_base(baseUserType,xsize=20)
  ;str_element,/add,state,'btnUpdateABS',widget_button(baseUserType,VALUE=" Reload ABS ");,ysize=10);,xsize=100)
  
  ; calendar icon
  getresourcepath,rpath
  cal = read_bmp(rpath + 'cal.bmp', /rgb)
  spd_ui_match_background, parent, cal; thm_ui_match_background
  
  baseStartTime = widget_base(mainbase,/row, SPACE=0, YPAD=0)
  lblStartTime = widget_label(baseStartTime,VALUE='Start Time',/align_left,xsize=70)
  str_element,/add,state,'fldStartTime',cw_field(baseStartTime,VALUE=state.start_time,TITLE='',/ALL_EVENTS,XSIZE=24)
  str_element,/add,state,'calStartTime',widget_button(baseStartTime,VALUE=cal)
  
  baseEndTime = widget_base(mainbase,/row)
  lblEndTime = widget_label(baseEndTime,VALUE='End Time',/align_left,xsize=70)
  str_element,/add,state,'fldEndTime',cw_field(baseEndTime,VALUE=state.end_time,TITLE='',/ALL_EVENTS,XSIZE=24)
  str_element,/add,state,'calEndTime',widget_button(baseEndTime,VALUE=cal)
  
  subbase = widget_base(mainbase,/row,/frame, space=0, ypad=0)
    str_element,/add,state,'bgTHM',cw_bgroup(subbase, ProbeNamesTHM, /COLUMN, /NONEXCLUSIVE,$
      SET_VALUE=[0,0,0,0,0],BUTTON_UVALUE=bua,ypad=0,space=0)
    sbMMS = widget_base(subbase,space=0,ypad=0,SENSITIVE=1)
      str_element,/add,state,'sbMMS',sbMMS
      str_element,/add,state,'bgMMS',cw_bgroup(sbMMS, ProbeNamesMMS, /COLUMN, /NONEXCLUSIVE,$
        SET_VALUE=[0,0,1,0],BUTTON_UVALUE=bua,ypad=0,space=0)
        ; If you edit the above line, DON'T forget to edit the line for probelist_mms 
        ; It should be at around line 491: probelist_mms: 'mms3'  
    bsCtrl = widget_base(subbase, /COLUMN,/align_center, space=0, ypad=0)
      str_element,/add,state,'lblPS',widget_label(bsCtrl,VALUE='Parameter Set')
      str_element,/add,state,'drpSet',widget_droplist(bsCtrl,VALUE=state.paramSetList,$
        TITLE='',DYNAMIC_RESIZE=strmatch(!VERSION.OS_FAMILY,'Windows'))
      str_element,/add,state,'bgOPOD',cw_bgroup(bsCtrl,'separate windows', /NONEXCLUSIVE,$
        SET_VALUE=0)
      widget_control,state.bgOPOD,SENSITIVE=0
      str_element,/add,state,'bgSRTV',cw_bgroup(bsCtrl,'sort by variables', /NONEXCLUSIVE,$
        SET_VALUE=0)
      widget_control,state.bgSRTV,SENSITIVE=0

  baseLoad = widget_base(mainbase,/row,/align_center)
  str_element,/add,state,'load',widget_button(baseLoad, VALUE = 'LOAD',ysize=30,xsize=200,$
    TOOLTIP='Restore from cache or retrieve from a remote server and then plot.')
  str_element,/add,state,'loadforce',widget_button(baseLoad, VALUE = ' FORCE RELOAD ',ysize=30,$;xsize=330,$
    TOOLTIP='Clear the static memory and force reloading all tplot variables.')

  
  ; Save out the initial state structure into the first childs UVALUE.
  WIDGET_CONTROL, WIDGET_INFO(mainbase, /CHILD), SET_UVALUE=state, /NO_COPY
  
  ; Return the base ID of your compound widget.  This returned
  ; value is all the user will know about the internal structure
  ; of your widget.
  RETURN, mainbase
END
