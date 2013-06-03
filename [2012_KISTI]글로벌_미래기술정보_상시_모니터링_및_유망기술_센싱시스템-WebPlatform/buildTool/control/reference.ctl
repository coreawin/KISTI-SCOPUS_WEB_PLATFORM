LOAD DATA 

INTO TABLE "B_SCOPUS_REFERENCE"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (eid  CHAR(12)
, 
	ref_eid  CHAR(12)
,
	publication_year CHAR(4)
,
    text	CHAR(3000)
,
	title	CHAR(3000)
,
	source_title	CHAR(3000)
,	
	issue	CHAR(1024)
,
	volumn	CHAR(128)
,	
	firstpage	CHAR(32)
,
	lastpage	CHAR(1024)
)

