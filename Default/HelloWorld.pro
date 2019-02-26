PRO HelloWorld

set_plot,'ps'
popen,'~/idlCode/test',/encapsulated
plot,[1,2,3],[1,2,3]
pclose

END