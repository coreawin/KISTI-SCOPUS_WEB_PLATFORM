LOAD DATA 
INFILE './correspondAuthor.txt' 
BADFILE './correspondAuthor.bad'
DISCARDFILE './correspondAuthor.dsc'


INTO TABLE "B_SCOPUS_CORRESPOND_AUTHOR"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
   author_seq
,
   organization CHAR(1024)
,
   email  CHAR(256)
,
   country_code CHAR(3)
)

