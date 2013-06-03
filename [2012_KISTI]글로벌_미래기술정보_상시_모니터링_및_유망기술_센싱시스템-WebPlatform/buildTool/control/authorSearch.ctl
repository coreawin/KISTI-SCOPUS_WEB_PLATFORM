LOAD DATA 
INFILE './authorSearch.txt' 
BADFILE './authorSearch.bad'
DISCARDFILE './authorSearch.dsc'

INTO TABLE "SCOPUS_AUTHOR_SEARCH"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
   author_id  CHAR(12)
, 
   author_name	CHAR(65535)
, 
   index_name	CHAR(65535)
,
   email	CHAR(65535)
,
   doc_count	CHAR(10)
)

