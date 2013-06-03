/**
 * SCOPUS 분석 테이블을 생성합니다.
 * 분석 테이블은 ASJC, ISSN, 나노에 따른 분석 테이블을 생성합니다.
 */

/* 전체대상 연도별 ISSN별 인용건수 통계 분석 테이블을 생성합니다.: 전체 문서 건수를 대상으로 한 상위 50% */
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


/* 전체대상 연도별 ASJC별 인용건수 통계 분석 테이블을 생성합니다.: 전체 문서 건수를 대상으로 한 상위 1% */
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

/*
 * 나노 분석 테이블을 생성하기 전에 SCOPUS_DOCUMENT에서 제목에서 나노 키워드로 검색된 논문을 찾아서 나노 테이블을 구축합니다.
 * */
DROP TABLE SCOPUS_DOCUMENT_NANO CASCADE CONSTRAINTS PURGE;
create table SCOPUS_DOCUMENT_NANO as
  select * from scopus_document where (
  REGEXP_LIKE(title,'(^nano)', 'i') or REGEXP_LIKE(title,'[!@\*-/,."{\(@#\$\%\^\* | \s](nano)', 'i')
  --or
  --REGEXP_LIKE(abstract,'(^nano)', 'i') or REGEXP_LIKE(abstract,'[!@\*-/,."{\(@#\$\%\^\* | \s](nano)', 'i')
  )  
; 


/*
 * 추가적으로 저자 키워드에서 나노 키워드로 검색된 논문을 찾아서 나노 테이블에 대해 추가적으로 데이터를 구축합니다.
 * */
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


/*
 * 추가적으로 나노 분야에 해당하는 저널 아이디를 이용하여 해당 저널에 소속된 논문을 찾아서 나노 테이블에 대해 추가적으로 데이터를 구축합니다.
 * */
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


/*
 * 구축된 나노 테이블을 활용하여 
 * 전체대상 연도별 ASJC별 인용건수 통계 분석 테이블을 생성합니다.: 나노 대상 문서 건수를 대상으로 한 상위 50% */
 * */
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
	WHERE ranking <= 0.1;
