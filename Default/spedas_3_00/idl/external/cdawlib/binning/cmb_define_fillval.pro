function cmb_define_fillval,x
; fillval = cmb_define_fillval(x)
case cmb_var_type(x) of
'FLOAT':return, -1e31
'DOUBLE':return, -1d31
'INT':return,fix(32767)
'LONG':return,long(-2147483647)
'LONG64':return,long64(-9223372036854775807)
'STRING':return,''
endcase
return,-1e31
end
