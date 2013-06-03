--����� ���� ���̺�
drop table USER_INFO CASCADE CONSTRAINTS PURGE;
create table USER_INFO (
    ID  VARCHAR2(16)  NOT NULL ,
    PWD VARCHAR2(32) NOT NULL,
    NAMES VARCHAR2(256)  NOT NULL ,
    EMAIL VARCHAR2(128)  NOT NULL ,
    DEPARTMENT VARCHAR2(12)  NOT NULL ,
    AUTH CHAR(1) NOT NULL ,
    REGIST_DATE TIMESTAMP NOT NULL,
    CONSTRAINT  XPKUSER_INFO PRIMARY KEY (ID)
);
--insert into USER_INFO values('super', 'super123', '������', 'info@kisti.re.kr', '�����μ�' , 'A', CURRENT_DATE);
select * from USER_INFO where id='super' and pwd='super123';

-- �̿���Ȳ ���̺�
drop table USER_USE_INFO CASCADE CONSTRAINTS PURGE;
create table USER_USE_INFO (
    ID  VARCHAR2(16)  NOT NULL ,
    SEARCH LONG NOT NULL,
    SEARCH_COUNT NUMBER  NOT NULL ,
    DOWNLOAD_DATE TIMESTAMP  NOT NULL
);

--Ŭ������ �м� ����.
drop table CLUSTER_REGIST CASCADE CONSTRAINTS PURGE;
create table CLUSTER_REGIST(
    SEQ NUMBER NOT NULL,
    USER_ID VARCHAR(16) NOT NULL,
    TITLE   VARCHAR(512) NOT NULL,
    DESCRIPTION VARCHAR(3000)    NOT NULL,
    FILENAME VARCHAR(512) NOT NULL,
    THRESHOLD   NUMBER NOT NULL,
    MAXCLUSTER  NUMBER NOT NULL,
    MINCLUSTER  NUMBER NOT NULL,
    REGIST_DATE TIMESTAMP NOT NULL,
    CONSTRAINT  XPKUSER_INFO PRIMARY KEY (SEQ)
);

create sequence CLUSTER_REGIST_SEQUENCE
increment by 1   -- 1�� �����϶�°Ű��
start with 1        -- 1���� �����̰�� 100 �����ҷ��� 100 �̶�� ���ø� �˴ϴ�.
nomaxvalue       -- �ִ밪 ������ ����
nocycle
nocache;

--Ŭ������ ������ ����.
CREATE TABLE CLUSTER_DATA(
    CLUSTER_REGIST_SEQ  NUMBER NOT NULL,
    CLUSTER_KEY VARCHAR(128) NOT NULL,
    EIDS    LONG    NOT NULL,
    ISDEL   CHAR(1) NOT NULL
)
-- Ŭ������ ���絵 ���� ����
CREATE TABLE CLUSTER_SIMILITY_DATA(
    CLUSTER_REGIST_SEQ  NUMBER NOT NULL,
    WORD1 VARCHAR(512) NOT NULL,
    WORD2 VARCHAR(512) NOT NULL,
    SIMILITY    VARCHAR(10) NOT NULL
)

-- �˻��� ���� ���̺�
drop table USER_SEARCHRULE constraints purge;
create table USER_SEARCHRULE(
    SEQ NUMBER NOT NULL,
    USER_ID VARCHAR(16) NOT NULL,
    SEARCHRULE   VARCHAR(4000) NOT NULL,
    SEARCHCOUNT  NUMBER NOT NULL,
    INSERT_DATE TIMESTAMP NOT NULL,
    CONSTRAINT  XPKUSER_SEARCHRULE PRIMARY KEY (SEQ)
);

create sequence USER_SEARCHRULE_SEQUENCE
increment by 1
start with 1
nomaxvalue
nocycle
nocache;

-- ����� �̿���Ȳ ���̺�
drop table USER_USE_PLATFORM CASCADE CONSTRAINTS PURGE;
create table USER_USE_PLATFORM(
    SEQ NUMBER NOT NULL,
    USER_ID VARCHAR(16) NOT NULL,
    USE_TYPE  NUMBER NOT NULL,
    INSERT_DATE TIMESTAMP NOT NULL,
    CONSTRAINT  XPKUSER_USE_PLATFORM PRIMARY KEY (SEQ)
);

create sequence USER_USE_PLATFORM_SEQUENCE
increment by 1
start with 1
nomaxvalue
nocycle
nocache;


-- �ͽ���Ʈ �α� �̿� ��Ȳ
drop table EXPORT_LOG CASCADE CONSTRAINTS PURGE;
create table EXPORT_LOG(
    IDS VARCHAR(512) NOT NULL,
    CONTENTS  VARCHAR(4000) NOT NULL,
    INSERT_DATE TIMESTAMP NOT NULL
);