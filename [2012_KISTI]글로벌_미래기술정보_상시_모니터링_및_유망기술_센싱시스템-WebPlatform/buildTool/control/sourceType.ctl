LOAD DATA 
INFILE './sourceType.txt' 
BADFILE './sourceType.bad'
DISCARDFILE './sourceType.dsc'


INTO TABLE "SCOPUS_SOURCE_TYPE"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (code  CHAR(1)
, 
   DESCRIPTION  CHAR(255)
)

