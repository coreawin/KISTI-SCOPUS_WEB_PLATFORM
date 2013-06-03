LOAD DATA 
INFILE './citation.txt' 
BADFILE './citation.bad'
DISCARDFILE './citation.dsc'


INTO TABLE "B_SCOPUS_CITATION"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   cit_eid  CHAR(12)
)

