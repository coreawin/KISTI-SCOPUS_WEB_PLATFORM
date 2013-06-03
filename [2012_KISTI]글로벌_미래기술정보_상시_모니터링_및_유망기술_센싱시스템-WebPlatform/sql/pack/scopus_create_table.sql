/**
 * 한번 구축후 재사용.
DROP TABLE Scopus_Source_Type CASCADE CONSTRAINTS PURGE;
CREATE TABLE Scopus_Source_Type(
	code  CHAR(1)  NOT NULL ,
	description  VARCHAR2(255)  NULL ,
	CONSTRAINT  XPKScopus_Source_Type PRIMARY KEY (code)
);
*/
/*
2011-03-10 이창환 박사님이 새로 주신 저널 정보를 아래 테이블로
구축하며 SCOPUS_SOURCE 테이블을 대체한다.
한번 구축후 재사용.
DROP TABLE Scopus_SOURCE_INFO CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_SOURCE_INFO (
  SOURCE_ID    VARCHAR2(12)       NOT NULL,
  SOURCE_TITLE         VARCHAR2(2000)         NULL,
  P_ISSN       CHAR(8)           NULL,
  E_ISSN       CHAR(8)           NULL,
  SOURCE_TYPE        VARCHAR2(64)                NULL,
  PUBLICSHER_NAME        VARCHAR2(512)                NULL,
  COUNTRY        VARCHAR2(128)                NULL
)
*/

/*
2011-03-10 이창환 박사님이 새로 주신 저널 정보를 아래 테이블로
구축하며 저널이 가지고 있는 고유의 ASJC 코드를 부여한다.
해당 ASJC 코드는 순서가 있다. 순서는 매우 중요하다.
CREATE TABLE Scopus_SOURCE_ASJC (
  SOURCE_ID		VARCHAR2(12)       NOT NULL,
  ASJC				CHAR(4)                NOT NULL
)
*/
/**
한번 구축후 재사용.
DROP TABLE Scopus_Citation_Type CASCADE CONSTRAINTS PURGE;
CREATE TABLE Scopus_Citation_Type(
	citation_type  CHAR(2)  NOT NULL ,
	description  VARCHAR2(255)  NULL ,
	CONSTRAINT  XPKScopus_Citation_Type PRIMARY KEY (citation_type)
);
*/

DROP TABLE BU_SCOPUS_DOCUMENT CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_SCOPUS_DOCUMENT(
	eid  VARCHAR2(12)  NOT NULL ,
	title  VARCHAR2(3000)  NULL ,
	abstract  CLOB  NULL ,
	publication_year  VARCHAR2(4)  NULL ,
	publication_month  VARCHAR2(2)  NULL ,
	volumn  VARCHAR2(128)  NULL ,
	issue  VARCHAR2(256)  NULL ,
	page  VARCHAR2(512)  NULL ,
	source_id  VARCHAR2(12)  NULL ,
	doi  VARCHAR2(512)  NULL ,
	ref_count  INT  NOT NULL ,
	citation_type  CHAR(2)  NULL ,
	cit_count  INT  NOT NULL
);

DROP TABLE BU_SCOPUS_DOCUMENT_STATUS CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_SCOPUS_DOCUMENT_STATUS(
	eid  VARCHAR2(12)  NOT NULL ,
	stage  char(4)  NULL ,
	state  VARCHAR2(6)  NULL ,
	Document_Type  VARCHAR2(5)  NULL
);

DROP TABLE BU_SCOPUS_AUTHOR_KEYWORD CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_SCOPUS_AUTHOR_KEYWORD(
	author_keyword_seq  INT  NOT NULL ,
	eid  VARCHAR2(12)  NOT NULL ,
	keyword  VARCHAR2(255)  NOT NULL
);

DROP TABLE BU_Scopus_Index_Keyword CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Index_Keyword(
	eid  VARCHAR2(12)  NOT NULL ,
	type	VARCHAR2(6)	NOT	NULL,
	keyword  VARCHAR2(255)  NOT NULL
);


/*
 * 한번 구축후 계속 사용.
DROP TABLE BU_Scopus_ASJC CASCADE CONSTRAINTS PURGE; 
CREATE TABLE BU_Scopus_ASJC(
	asjc_code  CHAR(4)  NOT NULL ,
	description  VARCHAR2(255)  NULL ,
	CONSTRAINT  XPKScopus_Classification_Value PRIMARY KEY (asjc_code)
);
*/

DROP TABLE BU_Scopus_Classification_ASJC CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Classification_ASJC(
	eid  VARCHAR2(12)  NOT NULL ,
	asjc_code  CHAR(4)  NOT NULL
);

DROP TABLE BU_Scopus_Author CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Author(
	author_seq  INT  NOT NULL ,
	author_id  VARCHAR2(12)  NULL ,
	author_name  VARCHAR2(255)  NULL ,
	delegate_author_name  VARCHAR2(255)  NULL ,
	email  VARCHAR2(255)  NULL
);

/* 저자 정보 새로운 스키마 */
DROP TABLE BU_Scopus_AUTHOR_ID_INFO CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_AUTHOR_ID_INFO(
	eid  VARCHAR2(12)  NOT NULL ,
    group_sequence  INT  NOT NULL ,
	author_id  VARCHAR2(12)  NULL ,
	author_name  VARCHAR2(255)  NULL ,
	index_name  VARCHAR2(255)  NULL ,
	email  VARCHAR2(255)  NULL ,
	ranking  VARCHAR2(5)  NULL ,
	delegate_author_name  VARCHAR2(255)  NULL
	--CONSTRAINT  XPKScopus_Author_ID_INFO PRIMARY KEY (eid, group_sequence, author_id)
);

/* 검색을 위한 테이블 */
DROP TABLE BU_Scopus_AUTHOR_SEARCH CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_AUTHOR_SEARCH(
	author_id  VARCHAR2(12)  NULL ,
	author_name  VARCHAR2(4000)  NULL ,
	index_name  VARCHAR2(4000)  NULL ,
	email  VARCHAR2(4000)  NULL ,
	doc_count  INT  NOT NULL
);
/*
 * 한번 구축후 계속 사용.
DROP TABLE BU_Scopus_Country_Code CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Country_Code(
	country_code  VARCHAR2(3)  NOT NULL ,
	description  VARCHAR2(255)  NULL ,
	oecd  CHAR(1)  NULL ,
	delegate_country_code  VARCHAR2(3)  NULL ,
	CONSTRAINT  XPKScopus_Country_Code PRIMARY KEY (country_code)
);
*/

DROP TABLE BU_Scopus_Correspond_Author CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Correspond_Author(
	eid  VARCHAR2(12)  NOT NULL ,
	author_seq  INT  NOT NULL ,
	organization  VARCHAR2(1024)  NULL ,
	email  VARCHAR2(256)  NULL ,
	country_code  VARCHAR2(3)  NULL
);

DROP TABLE BU_Scopus_Citation CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Citation(
	eid  VARCHAR2(12)  NOT NULL ,
	cit_eid  VARCHAR2(12)  NOT NULL
);

DROP TABLE BU_Scopus_Reference CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Reference(
	eid  VARCHAR2(12)  NOT NULL ,
	ref_eid  VARCHAR2(12)  NOT NULL ,
	publication_year  VARCHAR2(4)  NULL ,
	text	VARCHAR2(3000)  NULL ,
	title	VARCHAR2(3000)  NULL ,
	source_title	VARCHAR2(3000)  NULL ,
	issue	VARCHAR2(1024)  NULL ,
	volumn	VARCHAR2(128)  NULL ,
	firstpage	VARCHAR2(32)  NULL,
	lastpage	VARCHAR2(1024)  NULL
);


/*
CREATE TABLE BU_Scopus_Org
(
	org_seq  INT  NOT NULL ,
	org_id  VARCHAR2(30)  NULL ,
	name  VARCHAR2(255)  NULL ,
	country_code  VARCHAR2(3)  NULL ,
	delegate_org_name  VARCHAR2(255)  NULL ,
CONSTRAINT  XPKScopus_Org PRIMARY KEY (org_seq),
CONSTRAINT  Country_Code_FK FOREIGN KEY (country_code) REFERENCES Scopus_Country_Code(country_code) ON DELETE SET NULL
);
*/

DROP TABLE BU_Scopus_Affilation_Group CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Affilation_Group(
    eid  VARCHAR2(12)  NOT NULL ,
    group_sequence  INT  NOT NULL ,
    afid  VARCHAR2(30)  NULL ,
    dftid  VARCHAR2(30)  NULL ,
	org_name VARCHAR2(2000)  NULL ,
	country_code  VARCHAR2(3)  NULL ,
    delegate_org_name VARCHAR2(2000)  NULL
);

DROP TABLE BU_Scopus_Author_Group CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Author_Group(
	eid  VARCHAR2(12)  NOT NULL ,
	group_sequence  INT  NOT NULL ,
	author_seq  INT  NOT NULL ,
	ranking  VARCHAR2(5)  NULL
);

DROP TABLE BU_Scopus_Classification_Others_BU CASCADE CONSTRAINTS PURGE;
CREATE TABLE BU_Scopus_Classification_Others_BU(
	eid  VARCHAR2(12)  NOT NULL ,
	type  VARCHAR2(20)  NOT NULL ,
	code  VARCHAR2(255)  NOT NULL
);

commit;