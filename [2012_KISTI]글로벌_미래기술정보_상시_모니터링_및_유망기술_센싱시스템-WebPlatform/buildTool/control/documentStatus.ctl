LOAD DATA 
INFILE './document.txt' 
BADFILE './document.bad'
DISCARDFILE './document.dsc'

INTO TABLE "B_SCOPUS_DOCUMENT_STATUS"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols
  (EID
, 
   STAGE CHAR(4)
, 
   STATE  CHAR(6)
, 
   DOCUMENT_TYPE  CHAR(5)
)