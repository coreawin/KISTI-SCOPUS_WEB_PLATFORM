/**
 * �˻������� ����� ���� DB�� �����Ѵ�.
 * ���� �˻��� ��� �˻��� Ȱ��ȴ�.
 */

--���� �˻�
DROP TABLE SCOPUS_AUTHOR_SEARCH CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_AUTHOR_SEARCH(
	author_id  VARCHAR2(12)  NOT NULL ,
	author_name  CLOB  NULL ,
	index_name  CLOB  NULL ,
	email  CLOB  NULL,
	doc_count  VARCHAR2(10)  NULL
);

--��� �˻�
DROP TABLE SCOPUS_AFFILATION_SEARCH CASCADE CONSTRAINTS PURGE;
CREATE TABLE SCOPUS_AFFILATION_SEARCH(
	afid  VARCHAR2(12)  NOT NULL ,
	org_name  CLOB  NULL ,
	country  CLOB  NULL ,
	doc_count  VARCHAR2(10)  NOT NULL
);
