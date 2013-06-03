/* ���� �ϳ��� ASJC�� ����. ASJC �ڵ尡 �����Ϳ� ���� ����, 
 * ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: 
 * ��ü ���� �Ǽ��� ������� �� ���� 1% 
 * Ȯ�� 2012.07.18
 * �����˻� �÷��� HCP ���
 * */
drop table B_SCOPUS_TOP_ASJCMIN_CIT CASCADE CONSTRAINTS PURGE;
create table B_SCOPUS_TOP_ASJCMIN_CIT AS
SELECT eid, publication_year, asjc_code, total_record, cit_count, ranking
FROM
	(
	SELECT eid, publication_year, asjc_code, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, asjc_code ORDER BY cit_count desc) AS ranking
	FROM
		(
			SELECT distinct document_.eid, publication_year, asjc_code, count(distinct document_.eid) over (partition by publication_year, asjc_code) as total_record, cit_count
			FROM (select eid, min(asjc_code) as asjc_code from SCOPUS_CLASSIFICATION_ASJC group by eid) asjc, SCOPUS_DOCUMENT document_
			WHERE asjc.eid = document_.eid and document_.publication_year != 'null' and  CITATION_TYPE IN ('AR','RE','CP')
		)
	)
WHERE ranking <= 0.5;  
commit;
ALTER INDEX INDEX_STAMC_EID RENAME TO OINDEX_STAMC_EID;
DROP INDEX INDEX_STAMC_EID;
CREATE INDEX INDEX_STAMC_EID ON B_SCOPUS_TOP_ASJCMIN_CIT (
	"EID"
);  
ALTER INDEX INDEX_STAMC_PUBLICATION_YEAR RENAME TO OINDEX_STAMC_PUBLICATION_YEAR;
DROP INDEX INDEX_STAMC_PUBLICATION_YEAR;
CREATE INDEX INDEX_STAMC_PUBLICATION_YEAR ON B_SCOPUS_TOP_ASJCMIN_CIT (
	"PUBLICATION_YEAR"
);

ALTER INDEX INDEX_STAMC_ASJC_CODE RENAME TO OINDEX_STAMC_ASJC_CODE;
DROP INDEX INDEX_STAMC_ASJC_CODE;
CREATE INDEX INDEX_STAMC_ASJC_CODE ON B_SCOPUS_TOP_ASJCMIN_CIT (
	"ASJC_CODE"
);

ALTER INDEX INDEX_STAMC_RANKING RENAME TO OINDEX_STAMC_RANKING;
DROP INDEX INDEX_STAMC_RANKING;
CREATE INDEX INDEX_STAMC_RANKING ON B_SCOPUS_TOP_ASJCMIN_CIT (
	"RANKING"
);

ALTER INDEX INDEX_STAMC_CITCOUNT RENAME TO OINDEX_STAMC_CITCOUNT;
DROP INDEX INDEX_STAMC_CITCOUNT;
CREATE INDEX INDEX_STAMC_CITCOUNT ON B_SCOPUS_TOP_ASJCMIN_CIT (
	"CIT_COUNT"
);  
COMMIT;

DROP TABLE OLD_SCOPUS_TOP_ASJCMIN_CIT CASCADE CONSTRAINTS PURGE;
ALTER TABLE SCOPUS_TOP_ASJCMIN_CIT rename to OLD_SCOPUS_TOP_ASJCMIN_CIT;
ALTER TABLE B_SCOPUS_TOP_ASJCMIN_CIT rename to SCOPUS_TOP_ASJCMIN_CIT;

commit;

DROP TABLE SCOPUS_TOP_ASJCMIN_YEAR CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_TOP_ASJCMIN_YEAR AS
	SELECT distinct PUBLICATION_YEAR from SCOPUS_TOP_ASJCMIN_CIT GROUP BY PUBLICATION_YEAR ORDER BY PUBLICATION_YEAR;

commit;

/**
 * SCOPUS �м� ���̺��� �����մϴ�.
 * �м� ���̺��� ASJC, ISSN, ���뿡 ���� �м� ���̺��� �����մϴ�.
 */

/* ��ü��� ������ ISSN�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: ��ü ���� �Ǽ��� ������� �� ���� 50% */
drop table B_SCOPUS_TOP_ISSN_CIT CASCADE CONSTRAINTS PURGE;
create table B_SCOPUS_TOP_ISSN_CIT AS
    SELECT eid, publication_year, P_ISSN, total_record, cit_count, ranking
    FROM
        (
        SELECT eid, publication_year, P_ISSN, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, P_ISSN ORDER BY cit_count desc) AS ranking
        FROM
            (
                SELECT distinct document_.eid, publication_year, P_ISSN, count(distinct document_.eid) over (partition by publication_year, P_ISSN) as total_record, cit_count
                FROM SCOPUS_SOURCE_INFO source_, SCOPUS_DOCUMENT document_
                WHERE source_.source_id = document_.source_id and document_.publication_year != 'null' and source_.source_id is not null
                --order by P_ISSN, publication_year, cit_count desc
            )
        )
    WHERE ranking <= 0.5;
commit;
DROP TABLE OLD_SCOPUS_TOP_ISSN_CIT CASCADE CONSTRAINTS PURGE;
ALTER TABLE SCOPUS_TOP_ISSN_CIT rename to OLD_SCOPUS_TOP_ISSN_CIT;
ALTER TABLE B_SCOPUS_TOP_ISSN_CIT rename to SCOPUS_TOP_ISSN_CIT;
commit;
    
/* ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: 
 * ��ü ���� �Ǽ��� ������� �� ���� 1% 
 * */
drop table B_SCOPUS_TOP_ASJC_CIT CASCADE CONSTRAINTS PURGE;
create table B_SCOPUS_TOP_ASJC_CIT AS
SELECT eid, publication_year, asjc_code, total_record, cit_count, ranking
	FROM
		(
		SELECT eid, publication_year, asjc_code, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, asjc_code ORDER BY cit_count desc) AS ranking
		FROM
			(
				SELECT distinct document_.eid, publication_year, asjc_code, count(distinct document_.eid) over (partition by publication_year, asjc_code) as total_record, cit_count
				FROM SCOPUS_CLASSIFICATION_ASJC asjc, SCOPUS_DOCUMENT document_
				WHERE asjc.eid = document_.eid and document_.publication_year != 'null'
			)
		)
	WHERE ranking <= 0.5;
commit;
DROP TABLE OLD_SCOPUS_TOP_ASJC_CIT CASCADE CONSTRAINTS PURGE;
ALTER TABLE SCOPUS_TOP_ASJC_CIT rename to OLD_SCOPUS_TOP_ASJC_CIT;
ALTER TABLE B_SCOPUS_TOP_ASJC_CIT rename to SCOPUS_TOP_ASJC_CIT;
commit;    


DROP TABLE SCOPUS_TOP_ASJCMIN_CIT_1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_TOP_ASJCMIN_CIT_1 as
  select 
    asjc_code, 
    PUBLICATION_YEAR, 
    MIN(total_record) AS total, 
    count(eid) document_count, 
    MIN(cit_count) AS threshold  
  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.01
  group by cube (asjc_code, PUBLICATION_YEAR)
  order by asjc_code, PUBLICATION_YEAR;
  
DROP TABLE SCOPUS_TOP_ASJCMIN_CIT_3 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_TOP_ASJCMIN_CIT_3 as
  select 
    asjc_code, 
    PUBLICATION_YEAR, 
    MIN(total_record) AS total, 
    count(eid) document_count, 
    MIN(cit_count) AS threshold  
  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.03
  group by cube (asjc_code, PUBLICATION_YEAR)
  order by asjc_code, PUBLICATION_YEAR;

DROP TABLE SCOPUS_TOP_ASJCMIN_CIT_5 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_TOP_ASJCMIN_CIT_5 as
  select 
    asjc_code, 
    PUBLICATION_YEAR, 
    MIN(total_record) AS total, 
    count(eid) document_count, 
    MIN(cit_count) AS threshold  
  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.05
  group by cube (asjc_code, PUBLICATION_YEAR)
  order by asjc_code, PUBLICATION_YEAR;

DROP TABLE SCOPUS_TOP_ASJCMIN_CIT_7 CASCADE CONSTRAINTS PURGE;  
CREATE TABLE SCOPUS_TOP_ASJCMIN_CIT_7 as
  select 
    asjc_code, 
    PUBLICATION_YEAR, 
    MIN(total_record) AS total, 
    count(eid) document_count, 
    MIN(cit_count) AS threshold  
  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.07
  group by cube (asjc_code, PUBLICATION_YEAR)
  order by asjc_code, PUBLICATION_YEAR;

DROP TABLE SCOPUS_TOP_ASJCMIN_CIT_10 CASCADE CONSTRAINTS PURGE;  
CREATE TABLE SCOPUS_TOP_ASJCMIN_CIT_10 as
  select 
    asjc_code, 
    PUBLICATION_YEAR, 
    MIN(total_record) AS total, 
    count(eid) document_count, 
    MIN(cit_count) AS threshold  
  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.1
  group by cube (asjc_code, PUBLICATION_YEAR)
  order by asjc_code, PUBLICATION_YEAR;
  
commit;

--Research Front�� ���� ��� ������ ���� �����Ѵ�.
--tp ���� : Citation => 100 Reference =>0
--target : 5=>���� 1%, 15=>science, 25=>nature
DROP TABLE RF_SCOPUS_DOCUMNET_TOP1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RF_SCOPUS_DOCUMNET_TOP1 as
  select eid, 5 AS target , cit_eid as rc_eid, 100 AS tp
  from SCOPUS_CITATION c
    where eid in(
      select distinct eid from SCOPUS_TOP_ASJCMIN_CIT ca    
        WHERE RANKING <= 0.01 and cit_count > 0 
        		  AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
  UNION ALL
  select eid, 5 AS target , ref_eid as rc_eid, 0 AS tp
  from SCOPUS_REFERENCE r
    where eid in(
      select distinct eid from SCOPUS_TOP_ASJCMIN_CIT ca    
        WHERE RANKING <= 0.01 and cit_count > 0
        			AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
  UNION ALL
  select eid, 15 AS target , cit_eid as rc_eid, 100 AS tp
  from SCOPUS_CITATION c
    where eid in(
      select eid from SCOPUS_DOCUMENT sd    
        WHERE source_id = '21206' 
        		  AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
  UNION ALL
  select eid, 15 AS target , ref_eid as rc_eid, 0 AS tp
  from SCOPUS_REFERENCE r
    where eid in(
       select eid from SCOPUS_DOCUMENT sd    
        WHERE source_id = '21206' 
        		  AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
  UNION ALL
  select eid, 25 AS target , cit_eid as rc_eid, 100 AS tp
  from SCOPUS_CITATION c
    where eid in(
      select eid from SCOPUS_DOCUMENT sd    
        WHERE source_id = '23571' 
        		  AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
  UNION ALL
  select eid, 25 AS target , ref_eid as rc_eid, 0 AS tp
  from SCOPUS_REFERENCE r
    where eid in(
       select eid from SCOPUS_DOCUMENT sd    
        WHERE source_id = '23571' 
        		  AND publication_year >= TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-5) AND publication_year <= TO_CHAR(SYSDATE, 'YYYY')
  )
;

COMMIT;

CREATE INDEX SIDX_RSDT1_EID ON RF_SCOPUS_DOCUMNET_TOP1 (
	"EID"
);

CREATE INDEX SIDX_RSDT1_TARGET ON RF_SCOPUS_DOCUMNET_TOP1 (
	"TARGET"
);

CREATE INDEX SIDX_RSDT1_RCEID ON RF_SCOPUS_DOCUMNET_TOP1 (
	"RC_EID"
);

CREATE INDEX SIDX_RSDT1_TP ON RF_SCOPUS_DOCUMNET_TOP1 (
	"TP"
);

COMMIT;
   
/* ���� �ϳ��� ASJC�� ����. ASJC �ڵ尡 �����Ϳ� ���� ����, 
 * ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: 
 * ��ü ���� �Ǽ��� ������� �� ���� 1% 
 * �м� ���̺��� �����Ѵ�.
 * ������� �ʴ´�. 
 * Ȯ�� 2012.07.18
 * */
/*
drop table SCOPUS_ANALYSIS_TOP_ASJC_CIT CASCADE CONSTRAINTS PURGE;
create table  SCOPUS_ANALYSIS_TOP_ASJC_CIT
as
  select PUBLICATION_YEAR, asjc_code, MIN(total_record) AS total, count(eid) document_count, MIN(CIt_count) AS threshold  from SCOPUS_TOP_ASJCMIN_CIT
  where ranking <= 0.01
  group by cube (PUBLICATION_YEAR, asjc_code);
  
CREATE INDEX SCOPUS.INDEX_stamc_eid ON SCOPUS.SCOPUS_TOP_ASJCMIN_CIT (
	"EID"
);  

CREATE INDEX SCOPUS.INDEX_stamc_publication_year ON SCOPUS.SCOPUS_TOP_ASJCMIN_CIT (
	"PUBLICATION_YEAR"
);

CREATE INDEX SCOPUS.INDEX_stamc_asjc_code ON SCOPUS.SCOPUS_TOP_ASJCMIN_CIT (
	"ASJC_CODE"
);

CREATE INDEX SCOPUS.INDEX_stamc_ranking ON SCOPUS.SCOPUS_TOP_ASJCMIN_CIT (
	"RANKING"
);  
*/
/* HCP���� �� Ÿ��Ʋ �˻��� ���� �����Ѵ�.
 * 2012.07.18 ������� �ʴ´�. �� �˻� ��� �������� ����������� ��ü
 * */
/*
drop table SCOPUS_ANALYSIS_TOP_ASJC_TITLE CASCADE CONSTRAINTS PURGE;
create table SCOPUS_ANALYSIS_TOP_ASJC_TITLE
as
	select 
		eid, 
		(select title from SCOPUS_DOCUMENT sd where sd.eid = ac.eid) as title,  
		publication_year, 
		asjc_code
	from SCOPUS_TOP_ASJCMIN_CIT ac
*/	
/* HCP���� ��� Ÿ��Ʋ �˻��� ������ �ϱ� ���� �����Ѵ�.
 * 2012.07.18 ������� �ʴ´�. �� �˻� ��� �������� ����������� ��ü
CREATE INDEX idx_ctxcontext_satat ON SCOPUS_ANALYSIS_TOP_ASJC_TITLE(title) INDEXTYPE IS CTXSYS.CONTEXT	
*/	

/*
 * ���� �м� ���̺��� �����ϱ� ���� SCOPUS_DOCUMENT���� ���񿡼� ���� Ű����� �˻��� ���� ã�Ƽ� ���� ���̺��� �����մϴ�.
 * */
	/*
DROP TABLE SCOPUS_DOCUMENT_NANO CASCADE CONSTRAINTS PURGE;
create table SCOPUS_DOCUMENT_NANO as
  select * from scopus_document where (
  REGEXP_LIKE(title,'(^nano)', 'i') or REGEXP_LIKE(title,'[!@\*-/,."{\(@#\$\%\^\* | \s](nano)', 'i')
  --or
  --REGEXP_LIKE(abstract,'(^nano)', 'i') or REGEXP_LIKE(abstract,'[!@\*-/,."{\(@#\$\%\^\* | \s](nano)', 'i')
  )  
; 
*/

/*
 * �߰������� ���� Ű���忡�� ���� Ű����� �˻��� ���� ã�Ƽ� ���� ���̺� ���� �߰������� �����͸� �����մϴ�.
 * */
/*
DROP TABLE SCOPUS_DOCUMENT_NANO_KEYWORD CASCADE CONSTRAINTS PURGE;
create table SCOPUS_DOCUMENT_NANO_KEYWORD as
  select *
  from scopus_document
  where eid in (
    select distinct eid from scopus_author_keyword
      where        
        REGEXP_LIKE(keyword,'(^nano)', 'i') or REGEXP_LIKE(keyword,'[!@\*-/,."{\(@#\$\%\^\* | \s](nano)', 'i')        
  ) 
; 
INSERT INTO SCOPUS_DOCUMENT_NANO(
  select *
  from SCOPUS_DOCUMENT_NANO_KEYWORD
  where eid not in (
    select distinct eid from SCOPUS_DOCUMENT_NANO  
  )
);
*/

/*
 * �߰������� ���� �о߿� �ش��ϴ� ���� ���̵� �̿��Ͽ� �ش� ���ο� �Ҽӵ� ���� ã�Ƽ� ���� ���̺� ���� �߰������� �����͸� �����մϴ�.
 * */
/*
DROP TABLE SCOPUS_DOCUMENT_NANO_SOURCE CASCADE CONSTRAINTS PURGE;
create table SCOPUS_DOCUMENT_NANO_SOURCE as
(
  select *
    from scopus_document
    where 
		source_id = '11500153511'
		or source_id = '4700152612'
		or source_id = '19200156941'
		or source_id = '144782'
		or source_id = '26900'
		or source_id = '11200153548'
		or source_id = '16046'
		or source_id = '11700154398'
		or source_id = '16319'
		or source_id = '15464'
		or source_id = '5400152656'
		or source_id = '19600156908'
		or source_id = '18300156723'
		or source_id = '7700153108'
		or source_id = '19400157268'
		or source_id = '15489'
		or source_id = '21113'
		or source_id = '11700154733'
		or source_id = '13000154719'
		or source_id = '28136'
		or source_id = '5800207372'
		or source_id = '96642'
		or source_id = '7000153211'
		or source_id = '17400154831'
		or source_id = '17600155202'
		or source_id = '16088'
		or source_id = '18500166400'
		or source_id = '4000151616'
		or source_id = '19600161902'
		or source_id = '28545'
		or source_id = '9500154104'
		or source_id = '28546'
		or source_id = '28597'
		or source_id = '6100152803'
		or source_id = '130141'
		or source_id = '4500151512'
		or source_id = '11300153732'
		or source_id = '145658'
		or source_id = '19700174753'
		or source_id = '17853'
		or source_id = '17500155020'
		or source_id = '4700152457'
		or source_id = '130091'
		or source_id = '7000153207'
		or source_id = '6100152802'
		or source_id = '4000149101'
		or source_id = '19700175862'
		or source_id = '5200152801'
		or source_id = '7500153127'
		or source_id = '97953'
		or source_id = '110040'
		or source_id = '2100147401'
		or source_id = '11700154613'
		or source_id = '19700178100'
		or source_id = '5400152706'
		or source_id = '5200152704'
		or source_id = '14000156183'
		or source_id = '29112'
		or source_id = '29121'
		or source_id = '11500153308'
		or source_id = '144724'
		or source_id = '64940'
		or source_id = '11200153541'
		or source_id = '19700166902'
		or source_id = '66818'
		or source_id = '82647'
		or source_id = '71413'     
);
insert into SCOPUS_DOCUMENT_NANO(
  select *
  from SCOPUS_DOCUMENT_NANO_SOURCE
  where eid not in (
    select distinct eid from SCOPUS_DOCUMENT_NANO  
  )
);
*/

/*
 * ����� ���� ���̺��� Ȱ���Ͽ� 
 * ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: ���� ��� ���� �Ǽ��� ������� �� ���� 50% */
 * */
 /*
drop table SCOPUS_TOP_NANO_ASJC_CIT CASCADE CONSTRAINTS PURGE;
create table SCOPUS_TOP_NANO_ASJC_CIT AS
SELECT eid, publication_year, asjc_code, total_record, cit_count, ranking
	FROM
		(
		SELECT eid, publication_year, asjc_code, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, asjc_code ORDER BY cit_count desc) AS ranking
		FROM
			(
				SELECT distinct document_.eid, publication_year, asjc_code, count(distinct document_.eid) over (partition by publication_year, asjc_code) as total_record, cit_count
				FROM SCOPUS_CLASSIFICATION_ASJC asjc, SCOPUS_DOCUMENT_NANO document_
				WHERE asjc.eid = document_.eid and document_.publication_year != 'null'
			)
		)
	WHERE ranking <= 0.5;
*/
 
 
commit;

exit