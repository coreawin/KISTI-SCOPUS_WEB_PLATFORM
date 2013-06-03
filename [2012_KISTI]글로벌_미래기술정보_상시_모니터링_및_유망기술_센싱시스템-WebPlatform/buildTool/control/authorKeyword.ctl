LOAD DATA 
INFILE './authorKeyword.txt' 
BADFILE './authorKeyword.bad'
DISCARDFILE './authorKeyword.dsc'

INTO TABLE "B_SCOPUS_AUTHOR_KEYWORD"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols
(
author_keyword_seq
, 
eid		CHAR(12)
, 
keyword  CHAR(255)
)

