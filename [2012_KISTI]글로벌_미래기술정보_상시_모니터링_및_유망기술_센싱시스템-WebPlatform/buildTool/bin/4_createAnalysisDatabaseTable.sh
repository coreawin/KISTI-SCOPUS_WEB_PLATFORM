CONNECT=scopus/scopus+11@KISTI_SCOPUS5
SQL_FILE=../sql/scopus_analysis_create_table.sql

sqlplus $CONNECT @$SQL_FILE
exit
