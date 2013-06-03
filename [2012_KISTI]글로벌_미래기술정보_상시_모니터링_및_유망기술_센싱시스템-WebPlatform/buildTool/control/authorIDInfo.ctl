LOAD DATA 
INFILE './authorIDInfo.txt' 
BADFILE './authorIDInfo.bad'
DISCARDFILE './authorIDInfo.dsc'


INTO TABLE "B_SCOPUS_AUTHOR_ID_INFO"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
  
   eid  CHAR(12)
,
   group_sequence
,
   author_id  CHAR(12)
,
   author_name  CHAR(4000)
,
   index_name   CHAR(4000)
,
   email        CHAR(4000)
,
   ranking      CHAR(5)
)