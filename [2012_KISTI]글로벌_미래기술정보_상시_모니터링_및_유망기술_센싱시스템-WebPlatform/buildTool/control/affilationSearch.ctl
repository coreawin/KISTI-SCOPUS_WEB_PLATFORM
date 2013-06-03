LOAD DATA 
INFILE './affilationSearch.txt' 
BADFILE './affilationSearch.bad'
DISCARDFILE './affilationSearch.dsc'

INTO TABLE "SCOPUS_AFFILATION_SEARCH"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
   afid  CHAR(12)
, 
   org_name	CHAR(65535)
, 
   country	CHAR(65535)
,
   doc_count CHAR(20)
)

