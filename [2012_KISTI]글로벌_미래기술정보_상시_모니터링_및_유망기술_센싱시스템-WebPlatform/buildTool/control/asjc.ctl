LOAD DATA 
INFILE './asjc.txt' 
BADFILE './asjc.bad'
DISCARDFILE './asjc.dsc'


INTO TABLE "SCOPUS_ASJC"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
asjc_code  CHAR(4)
,
description	CHAR(255)
)

