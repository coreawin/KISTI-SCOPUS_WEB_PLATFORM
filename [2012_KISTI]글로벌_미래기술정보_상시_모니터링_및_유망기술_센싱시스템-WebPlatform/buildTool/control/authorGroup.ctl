LOAD DATA 
INFILE './authorGroup.txt' 
BADFILE './authorGroup.bad'
DISCARDFILE './authorGroup.dsc'


INTO TABLE "B_SCOPUS_AUTHOR_GROUP"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   group_sequence  
, 
   author_seq 
,
   ranking CHAR(5)
)

