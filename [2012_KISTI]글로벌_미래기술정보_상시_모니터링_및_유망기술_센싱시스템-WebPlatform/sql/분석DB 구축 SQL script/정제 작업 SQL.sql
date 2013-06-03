/** 2012.07.20*/

/* ������ ������ ��� Ŭ��¡ �����͸� ������ ���̺��� ����.*/
CREATE TABLE AFF_CLEANSING_RESULT (
	afid VARCHAR2(20) NOT NULL,
    affilation	VARCHAR2(512)	NOT NULL,
    country	CHAR(3)
);
COMMIT;

/* Ŭ��¡ ����� Ȯ���� ���̺��� �����Ѵ�. */
DROP TABLE AFF_CLEANSING_RESULT_REPORT CASCADE CONSTRAINTs PURGE;
CREATE TABLE AFF_CLEANSING_RESULT_REPORT (
	afid VARCHAR2(20) NOT NULL,
    affilation	VARCHAR2(512)	NOT NULL,
    country	CHAR(3),
    few	INTEGER
);
COMMIT;

/* ������ ������ �����Ϳ� ���������� ���� ���� Ŭ��¡ �����͸� ������. */
INSERT INTO AFF_CLEANSING_RESULT_REPORT (afid, affilation)
SELECT afid, dtop1 FROM AFF_DIFF_S
UNION ALL
SELECT afid, affilation FROM AFF_CLEANSING_RESULT;

COMMIT;

/* ��� ����� ���ؼ� SCOPUS ��ü �� ���� �󵵼��� ���Ѵ�.*/
DROP TABLE AFF_TOTAL_FRQ CASCADE CONSTRAINTs PURGE;
CREATE TABLE AFF_TOTAL_FRQ AS
  SELECT afid, COUNT(DISTINCT eid) AS feq FROM SCOPUS_AFFILATION_GROUP
  GROUP BY AFID;
COMMIT;

/* AFF_CLEANSING_RESULT_REPORT���̺��� �󵵼��� ������Ʈ �Ѵ�.*/
UPDATE AFF_CLEANSING_RESULT_REPORT report
SET (FEW) = (
	SELECT tf.feq FROM AFF_TOTAL_FRQ tf
	WHERE tf.afid = report.afid
);

/* AFF_CLEANSING_RESULT_REPORT���̺��� �����ڵ带 ������Ʈ �Ѵ�.*/
UPDATE AFF_CLEANSING_RESULT_REPORT report
SET (COUNTRY) = (
	SELECT COUNTRY_CODE FROM AFF_DIFF tf
	WHERE tf.afid = report.afid
);

/*10���̻��� KISTI���� ������(����)�� �־����Ƿ� 10�� ������ �����Ϳ� ���� �����Ѵ�.*/
INSERT INTO scopus_kisti_affiliation (afid, affilation, country_code)
SELECT afid, affilation, country FROM AFF_CLEANSING_RESULT_REPORT s WHERE few < 10 AND afid NOT IN (SELECT afid FROM scopus_kisti_affiliation);


/*�����ڵ� ������Ʈ*/

/*�����ڵ� ������Ʈ�� ���� ������ ����*/
DROP TABLE SCOPUS_KISTI_COUNTRY CASCADE CONSTRAINTs PURGE;
CREATE TABLE SCOPUS_KISTI_COUNTRY as
SELECT afid, MAX(country_code) KEEP(DENSE_RANK FIRST ORDER BY ccnt desc) AS country_code FROM (
		SELECT afid, country_code,  COUNT(country_code) AS ccnt FROM SCOPUS_AFFILATION_GROUP GROUP BY afid, country_code
) r GROUP BY afid;

CREATE INDEX INDEX_SKCOUNTRY_AFID ON SCOPUS_KISTI_COUNTRY (
	"AFID"
);

CREATE INDEX INDEX_SKCOUNTRY_COUN ON SCOPUS_KISTI_COUNTRY (
	"COUNTRY_CODE"
);  

/*�����ڵ� ������Ʈ ����*/
UPDATE scopus_kisti_affiliation ska
SET (country_code) = (
SELECT country_code FROM SCOPUS_KISTI_COUNTRY c WHERE c.afid = ska.afid AND c.COUNTRY_CODE IS NOT null
);

/*�����ڵ尡 �������� �ʴ� �����͸� ���� ����.*/
DROP TABLE SCOPUS_CC CASCADE CONSTRAINTs PURGE;
CREATE TABLE SCOPUS_CC as
SELECT ag.afid, ag.org_name, ag.COUNTRY_CODE  
FROM SCOPUS_AFFILATION_GROUP ag, (SELECT afid FROM SCOPUS_KISTI_AFFILIATION WHERE country_code IS null) sk
WHERE ag.afid = sk.afid
ORDER BY afid;

SELECT * FROM AFF_CLEANSING_RESULT_REPORT ORDER BY few ;

SELECT COUNT(*) FROM AFF_TOTAL_FRQ

