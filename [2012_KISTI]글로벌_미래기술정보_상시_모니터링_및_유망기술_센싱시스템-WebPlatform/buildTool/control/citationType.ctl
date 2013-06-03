LOAD DATA 
INFILE './citationType.txt' 
BADFILE './citationType.bad'
DISCARDFILE './citationType.dsc'


INTO TABLE "SCOPUS_CITATION_TYPE"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
citation_type  CHAR(2)
,
description	CHAR(255)
)

