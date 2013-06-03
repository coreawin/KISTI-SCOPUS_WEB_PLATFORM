LOAD DATA 
INFILE './affilation.txt' 
BADFILE './affilation.bad'
DISCARDFILE './affilation.dsc'


INTO TABLE "B_SCOPUS_AFFILATION_GROUP"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   group_sequence  
, 
   afid CHAR(30)
,
   dftid CHAR(30)
,
   org_name CHAR(2000)  
, 
   country_code CHAR(3)
,
   delegate_org_name CHAR(2000)     
)

