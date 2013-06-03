LOAD DATA 
INFILE './author.txt' 
BADFILE './author.bad'
DISCARDFILE './author.dsc'


INTO TABLE "B_SCOPUS_AUTHOR"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (author_seq
, 
   author_id  CHAR(12)
, 
   author_name  CHAR(255)
, 
   delegate_author_name  CHAR(255)
,
	email CHAR(255)
)

