--기관검색
--기관ID, 기관명(싱글쿼터로 감쌈), 국가명(싱글쿼터로 감쌈), 문서수
create table SCOPUS_AFFILATION_SEARCH as
	select 
		afid, 
		substr(max(sys_connect_by_path(''''||org_name||'''',',')),2) org_name, 
		substr(max(sys_connect_by_path(''''||country_code||'''',',')),2) country_code,
		count(distinct eid) as doccnt
	from (
	    select afid, org_name, country_code, row_number() over (partition by afid order by afid) rn 
	    from SCOPUS_AFFILATION_GROUP
	)
	start with rn = 1
	connect by prior afid=afid and prior rn = rn -1
	group by afid;

	
--저자검색 (테이블이 아직 안만들어 졌음)
--저자ID, 저자명1(싱글쿼터로 감쌈), 저자명2(싱글쿼터로 감쌈), 저자이메일(싱글쿼터로 감쌈), 문서수
create table SCOPUS_AUTHOR_SEARCH as
	select 
		author_id, 
		substr(max(sys_connect_by_path(''''||author_name||'''',',')),2) author_name, 
		substr(max(sys_connect_by_path(''''||index_name||'''',',')),2) index_name,
		substr(max(sys_connect_by_path(''''||email||'''',',')),2) email,
		count(distinct eid) as doccnt
	from (
	    select eid, author_id, author_name, index_name, email, row_number() over (partition by author_id order by author_id) rn 
	    from SCOPUS_AUTHOR_ID_INFO
	)
	start with rn = 1
	connect by prior author_id=author_id and prior rn = rn -1
	group by author_id;


/*
insert into SCOPUS_AFFILATION_SEARCH(
	SELECT 
		afid, 
		XMLAGG(XMLELEMENT(x,org_name||'`') ORDER BY afid).EXTRACT('//text()').GetStringVal() org_name,
		XMLAGG(XMLELEMENT(x,country_code||'`') ORDER BY afid).EXTRACT('//text()').GetStringVal() country_code,
		count(distinct eid)
	FROM SCOPUS_AFFILATION_GROUP
	GROUP BY afid
)
;
*/
create table SCOPUS_AFFILATION_SEARCH as
	select 
		afid, 
		substr(max(sys_connect_by_path(''''||org_name||'''',',')),2) org_name, 
		substr(max(sys_connect_by_path(''''||country_code||'''',',')),2) country_code,
		count(distinct eid)
	from (
	    select eid, afid, org_name, country_code, row_number() over (partition by afid order by afid) rn 
	    from SCOPUS_AFFILATION_GROUP
	)
	start with rn = 1
	connect by prior afid=afid and prior rn = rn -1
	group by afid
;



select 
	afid, 
	substr(max(sys_connect_by_path(''''||org_name||'''',',')),2) org_name, 
	substr(max(sys_connect_by_path(''''||country_code||'''',',')),2) country_code,
	count(distinct eid)
from (
    select afid, org_name, country_code, row_number() over (partition by afid order by afid) rn 
    from SCOPUS_AFFILATION_GROUP
)
start with rn = 1
connect by prior afid=afid and prior rn = rn -1
group by afid

