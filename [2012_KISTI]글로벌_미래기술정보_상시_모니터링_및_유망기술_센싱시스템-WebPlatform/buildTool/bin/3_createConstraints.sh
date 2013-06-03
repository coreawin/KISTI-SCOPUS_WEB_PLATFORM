CONNECT=scopus/scopus+11@KISTI5
SQL_FILE=../sql/scopus_create_constraints.sql

sqlplus $CONNECT @$SQL_FILE
exit
