LOAD DATA 
INFILE './classificationAsjc.txt' 
BADFILE './classificationAsjc.bad'
DISCARDFILE './classificationAsjc.dsc'


INTO TABLE "B_SCOPUS_CLASSIFICATION_ASJC"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   asjc_code  CHAR(4)
)

