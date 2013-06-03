/**
 * SCOPUS �м� ���̺��� �����մϴ�.
 * �м� ���̺��� ASJC, ISSN, ���뿡 ���� �м� ���̺��� �����մϴ�.
 */

/* ��ü��� ������ ISSN�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: ��ü ���� �Ǽ��� ������� �� ���� 50% */
drop table SCOPUS_TOP_ISSN_CIT CASCADE CONSTRAINTS PURGE;
create table SCOPUS_TOP_ISSN_CIT AS
    SELECT eid, publication_year, P_ISSN, total_record, cit_count, ranking
    FROM
        (
        SELECT eid, publication_year, P_ISSN, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, P_ISSN ORDER BY cit_count desc) AS ranking
        FROM
            (
                SELECT distinct document_.eid, publication_year, P_ISSN, count(distinct document_.eid) over (partition by publication_year, P_ISSN) as total_record, cit_count
                FROM SCOPUS_SOURCE_INFO source_, SCOPUS_DOCUMENT document_
                WHERE source_.source_id = document_.source_id and document_.publication_year != 'null' and source_.source_id is not null
                order by P_ISSN, publication_year, cit_count desc
            )
        )
    WHERE ranking <= 0.5;

    
/* ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: 
 * ��ü ���� �Ǽ��� ������� �� ���� 1% 
 * */
drop table SCOPUS_TOP_ASJC_CIT CASCADE CONSTRAINTS PURGE;
create table SCOPUS_TOP_ASJC_CIT AS
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
    
   
/* ���� �ϳ��� ASJC�� ����. ASJC �ڵ尡 �����Ϳ� ���� ����, 
 * ��ü��� ������ ASJC�� �ο�Ǽ� ��� �м� ���̺��� �����մϴ�.: 
 * ��ü ���� �Ǽ��� ������� �� ���� 1% 
 * Ȯ�� 2012.07.18
 * �����˻� �÷��� HCP ���
 * */
drop table SCOPUS_TOP_ASJCMIN_CIT CASCADE CONSTRAINTS PURGE;
create table SCOPUS_TOP_ASJCMIN_CIT AS
SELECT eid, publication_year, asjc_code, total_record, cit_count, ranking
FROM
	(
	SELECT eid, publication_year, asjc_code, total_record, cit_count as, PERCENT_RANK() OVER (partition by publication_year, asjc_code ORDER BY cit_count desc) AS ranking
	FROM
		(
			SELECT distinct document_.eid, publication_year, asjc_code, count(distinct document_.eid) over (partition by publication_year, asjc_code) as total_record, cit_count
			FROM (select eid, min(asjc_code) as asjc_code from SCOPUS_CLASSIFICATION_ASJC group by eid) asjc, SCOPUS_DOCUMENT document_
			WHERE asjc.eid = document_.eid and document_.publication_year != 'null'
		)
	)
WHERE ranking <= 0.5;  

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