LOAD DATA 
INFILE './referenceAuthor.txt' 
BADFILE './referenceAuthor.bad'
DISCARDFILE './referenceAuthor.dsc'


INTO TABLE "SCOPUS_REFERENCE_AUTHOR"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (
	ref_eid  CHAR(12)
,
	author_seq_no 
,
	initials	CHAR(64)
,
	indexed_name	CHAR(128)
,	
	surname	CHAR(64)
)

