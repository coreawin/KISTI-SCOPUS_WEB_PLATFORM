LOAD DATA 
INFILE './indexKeyword.txt' 
BADFILE './indexKeyword.bad'
DISCARDFILE './indexKeyword.dsc'

INTO TABLE "B_SCOPUS_INDEX_KEYWORD"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols
(
eid		CHAR(12)
, 
type	CHAR(6)
,
keyword  CHAR(255)
)

