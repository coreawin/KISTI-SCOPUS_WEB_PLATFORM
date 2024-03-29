/*기관 클린징을 위한 SQL 테이블*/

DROP TABLE SCOPUS_KISTI_AFFILIATION CASCADE CONSTRAINTS ;alter
CREATE TABLE SCOPUS_KISTI_AFFILIATION (
	AFID            VARCHAR2(20)     NOT NULL,
	AFFILATION      VARCHAR2(2048),
	COUNTRY_CODE    VARCHAR2(3)
);

/*아래는 기관 추출을 위한 테스트용 테이블*/
--D 추출 Top3
DROP TABLE AFF_CLEANSING_TEST_D_T3 CASCADE CONSTRAINTS ;
CREATE TABLE AFF_CLEANSING_TEST_D_T3 (
  AFID            VARCHAR2(20)     NOT NULL,
  AFFILATION      VARCHAR2(2048),
  COUNTRY_CODE    VARCHAR2(3),
  FEQ             NUMBER 
);

--CD 추출 Top3
DROP TABLE AFF_CLEANSING_TEST_CD_T3 CASCADE CONSTRAINTS ;
CREATE TABLE AFF_CLEANSING_TEST_CD_T3 (
  AFID            VARCHAR2(20)     NOT NULL,
  AFFILATION      VARCHAR2(2048),
  COUNTRY_CODE    VARCHAR2(3),
  FEQ             NUMBER 
);

--ABCD 추출 Top1
DROP TABLE AFF_CLEANSING_TEST_ABCD_T1 CASCADE CONSTRAINTS ;
CREATE TABLE AFF_CLEANSING_TEST_ABCD_T1 (
  AFID            VARCHAR2(20)     NOT NULL,
  AFFILATION      VARCHAR2(2048),
  COUNTRY_CODE    VARCHAR2(3),
  FEQ             NUMBER 
);