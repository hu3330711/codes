pro lambda_mirror,pa,lam_rad

  x=1./(sin(pa))^2
  previous_value=0.
  
  for lam_test=1,89 do begin
    lam_test_rad=lam_test/180.*!pi
    test_function=sqrt(1.+3.*(sin(lam_test_rad))^2)/(cos(lam_test_rad))^6
    if((previous_value le x) and (test_function gt x)) then break
    previous_value=test_function
  endfor
  lam=lam_test-1.
  
  for lam_test=1,10 do begin
    lam_test_rad=(lam+lam_test/10.)/180.*!pi
    test_function=sqrt(1.+3.*(sin(lam_test_rad))^2)/(cos(lam_test_rad))^6
    if((previous_value le x) and (test_function gt x)) then break
    previous_value=test_function
  endfor
  lam=lam+(lam_test-1.)/10.

  for lam_test=1,10 do begin
    lam_test_rad=(lam+lam_test/100.)/180.*!pi
    test_function=sqrt(1.+3.*(sin(lam_test_rad))^2)/(cos(lam_test_rad))^6
    if((previous_value le x) and (test_function gt x)) then break
    previous_value=test_function
  endfor
  lam=lam+(lam_test-1.)/100.

  for lam_test=1,10 do begin
    lam_test_rad=(lam+lam_test/1000.)/180.*!pi
    test_function=sqrt(1.+3.*(sin(lam_test_rad))^2)/(cos(lam_test_rad))^6
    if((previous_value le x) and (test_function gt x)) then break
    previous_value=test_function
  endfor
  lam=lam+(lam_test-1.)/1000.

  lam_rad=lam/180.*!pi
end