LOAD DATA 
INFILE './classificationOthers.txt' 
BADFILE './classificationOthers.bad'
DISCARDFILE './classificationOthers.dsc'


INTO TABLE "B_SCOPUS_CLASSIFICATION_OTHERS"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   type CHAR(20)
,
   code  CHAR(255)
)

