LOAD DATA 
INFILE './countryCode.txt' 
BADFILE './countryCode.bad'
DISCARDFILE './countryCode.dsc'


INTO TABLE "SCOPUS_COUNTRY_CODE"
APPEND

FIELDS TERMINATED BY X'9'
trailing nullcols

  (country_code  CHAR(3)
, 
   description  CHAR(255)
   ,
   oecd	CHAR(1)
   ,
   delegate_country_code  CHAR(3)
)

