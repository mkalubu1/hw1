**COPPERBELT DO FILE
**1. generate a binary variable in stata
generate sex_numerical = 0
replace sex_numerical =1 if sex =="female"
replace sex_numerical =. if sex ==.
// create a binary variable 'gender' where 0 represents male and 1 represents female
egen gender = group(sex)
replace gender = (gender==2)
tab gender
replace gender = 0 if gender =="female"
replace gender = 1 if gender =="male"
drop gender
gen gender =.
replace gender = 0 if sex =="female"
replace gender = 1 if sex =="male"
tab gender
tab sex
log close

//2 generate age in years
gen ageatenrollment = (enrollmentdate - dateofbirth) / 365.25
gen ageatenrollmentfull = round(ageatenrollment)
 log close
 // 3a. create a categorical age variable
 gen agegroup =.
 replace agegroup = 1 if ageatenrollmentfull <= 15
 replace agegroup = 2 if ageatenrollmentfull >=16 & ageatenrollmentfull <=24
 replace agegroup =3 if ageatenrollmentfull >= 25
 tabulate agegroup
 // part B
 gen agegroup1 =.
 replace agegroup1 =1 if ageatenrollmentfull >=10 & ageatenrollmentfull <= 24
 replace agegroup1 =2 if ageatenrollmentfull >= 25
 tab agegroup1
 
 // 4a. Generate a binary variable in stata particularly  VL Suppression
  tab labtype
  sum labresult
  gen vl = .
  replace vl = 0 if labresult < 1000
  replace vl = 1 if labresult >= 1000
  tabulate vl
  //4. vl1 binary
  gen vl1 =.
  replace vl1 = 0 if labresult < 200
  replace vl1 = 1 if labresult >= 200
  tabulate vl1
  log close
  // 5 Generate time
  gen diff_days = datediff(enrollmentdate, testdate, "days")
  tab diff_days
  sum diff_days
  list diff_days
  gen diff_months =datediff(enrollmentdate, testdate, "months")
  tab diff_months
  sum diff_months
 gen diff_days1 = datediff( testdate, enrollmentdate, "days")
  tab diff_days1
  sum diff_days1
  gen diff_months1 =datediff( testdate, enrollmentdate, "months")
  tab diff_months1
  sum diff_months1
  *5 NEW TESTDATE AND NEW ENROLLMENTDATE
  gen new_testdate = date(testdate, "DMY")
  format new_testdate %td
  gen new_enrollmentdate = date(enrollmentdate, "DMY")
  format new_enrollmentdate %td
  gen between =testdate - enrollmentdate
  
  ** 5a BETWEEN VARIABLE IS THE NUMBER OF DAYS FROM ENROLLMENT TO TESTDATE
  *** SIX MONTHS PERIOD GROUPS HEREIN CALLED SEMESTERGROUP
  gen semestergroup =.
  replace semestergroup = 1 if between <=180
  replace semestergroup = 2 if between >=181 & between <= 360
  replace semestergroup = 3 if between >=361 & between <= 540
  replace semestergroup = 4 if between >=541 & between <= 720
  replace semestergroup = 5 if between >=721 & between <= 900
  replace semestergroup = 6 if between >=901 
  tabulate semester
  ** PROPORTION TESTDATE BY AGEGROUP
  prtest gen ==.5

by agegroup, sort: prtest vl ==.5
by agegroup, sort: prtest vl1 ==.5

** PROPORTION TEST BY TIME PERION
by semester, sort: prtest vl ==.5
by semester, sort: prtest vl1 ==.5

**TWOWAY GRAPH
twoway line_vl=0 semester || line_vl=1 semester
twoway line vl vl1 semester
twoway line vl semester
twoway line vl agegroup ||line vl1 agegroup
twoway line between semester || line between semester

