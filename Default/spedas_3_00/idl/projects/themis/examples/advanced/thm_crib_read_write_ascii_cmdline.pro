;+
;Name:
;  thm_crib_read_write_ascii_cmdline
;
;Purpose:
;  Demonstrates use of the read_ascii_cmdline and 
;  the write_ascii_cmdline IDL procedures.
;
;
;See also:
;  general/misc/write_ascii_cmdline.pro 
;  general/misc/write_ascii.pro 
;  general/misc/read_ascii_cmdline.pro
;  read_ascii.pro (IDL routine)
;  ascii_template (IDL routine)
;
;Notes:
;
;
;$LastChangedBy: aaflores $
;$LastChangedDate: 2015-05-14 16:11:04 -0700 (Thu, 14 May 2015) $
;$LastChangedRevision: 17618 $
;$URL: svn+ssh://thmsvn@ambrosia.ssl.berkeley.edu/repos/spdsoft/tags/spedas_3_00/projects/themis/examples/advanced/thm_crib_read_write_ascii_cmdline.pro $
;-

;**************************************************************
; General Notes
;**************************************************************
;
;  The read_ascii_cmdline can also take an ascii template structure as a parameter.
;  Ascii template structures can be generated by the IDL GUI ascii_template.
;
;    For Example:   myTemplate = ascii_template(filename)
;                   data = read_ascii_cmdline(filename, template=myTemplate)
;
;    See ascii_template and/or read_ascii for more details.
;


;**************************************************************
; Writing ASCII files
;**************************************************************

; Simplest example of writing data
;-----------------------------------------------
;create some data to write
data = dindgen(3,10)

;output file name
filename = 'test_simple.txt'
 
; in this case there is no header information and data is an array of 
; double precision data
write_ascii_cmdline, data, filename

stop


; Include header
;-----------------------------------------------
data = dindgen(3,10)

filename = 'test_header.txt'

header = ['This is a sample header', 'It is an array of strings']

write_ascii_cmdline, data, filename, header=header

stop    


; Include a count of the records written to the file
;-----------------------------------------------
data = dindgen(3,10)

filename='test_nrec.txt'

;the number of records includes only the data and not the header
;in this example the number of records should be 10
write_ascii_cmdline, data, filename, header=header, nrec=nrec

print, 'The number of data records written to the file is: ', nrec

stop    


; This example shows writing an ascii file using a data structure
; The data structure is of the form returned by read_ascii.
;-----------------------------------------------
filename= 'test_struc.txt'

dates = ['2008-12-27','2008-12-28','2008-12-29','2008-12-30','2008-12-31'] 

;create data structure
;  -all col's must be of the same size or nrows.
sdata = {date:dates, x:data[0,0:4], y:data[1,0:4], z:data[2,0:4]}

;in this example the number of records should be 5
write_ascii_cmdline, sdata, filename, header=header, nrec=nrec 

print, 'The number of data records written from the data structure is: ', nrec

stop



;**************************************************************
; Reading ASCII files
;**************************************************************

; Read basic example above
;-----------------------------------------------

; Read the simple test file created with a 3x10 double precision array.
; This file does not have header information
data = read_ascii_cmdline('test_simple.txt')

;the data structure returned should have 3 fields (or columns)
;and each field is a 1-d array of floats of length 10
help, data, /struc

stop


; Read example with header
;-----------------------------------------------

;Read the simple test file that has header information.
;In this case the starting line of data must be specified.
data = read_ascii_cmdline('test_header.txt', start_line=2)

;the results should be the same as noted in the previous example
help, data, /struc

stop


; Return header separately
;-----------------------------------------------

;Read the simple test file that has header information and return the 
;header along with the data structure.
data = read_ascii_cmdline('test_header.txt', start_line=2, header=header)

;the header information
print, header[0]
print, header[1]

stop


; Read the test file that used a data structure.
;-----------------------------------------------

data = read_ascii_cmdline('test_struc.txt', start_line=2, header=header)

;The data structure returned should be four fields of type float of length 5.
;
;Note that the first tag within the structure is of type float even though
;the data type written to the file was of type string.  If the data 
;structure contains different data types and no data type parameter
;is provided the procedure will default to float.
help, data, /struc

stop


; Read the test file that used a data structure and provide field type information
;-----------------------------------------------

field_types = ['string', 'double', 'double', 'double'] 

data = read_ascii_cmdline('test_struc.txt', start_line=2, header=header, field_types=field_types)

;When field type information is provided the data structure should contain'
;data types defined by field_types = [string, double, double, double].
help, data, /struc

stop


; Read the test file that used a data structure and provide field type information
;   -field info specified as a IDL data type
;-----------------------------------------------

;see IDL size() function
field_types = Long([7,5,5,5]) 

data = read_ascii_cmdline('test_struc.txt', start_line=2, header=header, field_types=field_types)

;In IDL data types can be defined by a variable of type long.
;In this example the data structure types should match the previous example.
help, data, /struc

stop

; User specified field names
;----------------------------------------------

; Read the test file using a data structure and provide field types and 
; field names. The routine defaults to field names field01, field02, etc...
; The user can provide an array of strings containing the names of each
; field.

field_names=['date', 'x', 'y', 'z']

data = read_ascii_cmdline('test_struc.txt', start_line=2, header=header, $
       field_types=field_types, field_names=field_names)

;The data structure returned should now contains the
;names defined by field_names.
help, data, /struc

stop

END