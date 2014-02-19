-- RESEARCH_FRONT
DROP TABLE RF_CLUSTER_DOMESTIC CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSTER_KEYWORD CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSTER_INFO CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSTER_ASJC CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSETER_DOCUMENT CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSTER_EID CASCADE CONSTRAINTS;
DROP TABLE RF_CLUSTER_UPDATE_INFO CASCADE CONSTRAINTS;
DROP TABLE RF_ANALYSIS_OPTION CASCADE CONSTRAINTS;
DROP TABLE RF_ANALYSIS_ASJC CASCADE CONSTRAINTS;
DROP TABLE RF_ANALASYS_CLUSTER CASCADE CONSTRAINTS;
DROP TABLE RF_ANALYSIS CASCADE CONSTRAINTS;

CREATE TABLE RF_ANALYSIS( 
     SEQ INTEGER  NOT NULL , 
     TITLE VARCHAR2(512) , 
     DESCRIPTION VARCHAR2(1000) , 
     ADD_SCIENCE CHAR (1) , 
     ADD_NATURE CHAR (1) , 
     SHOW_MIRIAN CHAR (1) , 
     REG_USER VARCHAR2(16) , 
     REG_DATE_FIRST DATE , 
     MOD_USER VARCHAR2(16) , 
     MOD_DATE DATE 
);
ALTER TABLE RF_ANALYSIS 
    ADD CONSTRAINT RF_ANLAYSIS_PK PRIMARY KEY ( SEQ ) ;

CREATE TABLE RF_ANALASYS_CLUSTER( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL , 
     UPDATE_FLAG INTEGER NOT NULL, 
     DOCUMNET_COUNT INTEGER  NOT NULL , 
     DOCUMENT_REFERENCE_COUNT INTEGER  NOT NULL , 
     REFERENCE_COUNT_PER_DOCUMENT FLOAT  NOT NULL , 
     AVERAGE_PUB_YEAR_DOCUMENT FLOAT  NOT NULL , 
     AVERAGE_PUB_YEAR_CITATION_DOC FLOAT, 
     CLUSTER_NO VARCHAR(12)	NOT NULL, 
     REG_DATE DATE  NOT NULL
);

ALTER TABLE RF_ANALASYS_CLUSTER 
    ADD CONSTRAINT RF_ANALASYS_CLUSTER_PK PRIMARY KEY ( SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG) ;

ALTER TABLE RF_ANALASYS_CLUSTER 
    ADD CONSTRAINT RF_ANALASYS_CLUSTER_FK FOREIGN KEY (SEQ) REFERENCES RF_ANALYSIS(SEQ) ON DELETE CASCADE ;    

CREATE TABLE RF_ANALYSIS_ASJC( 
     SEQ INTEGER  NOT NULL , 
     ASJC CHAR (4 CHAR) 
);

CREATE TABLE RF_ANALYSIS_OPTION( 
     SEQ INTEGER  NOT NULL , 
     CONTENTS_JSON VARCHAR2(2000) , 
     REG_USER VARCHAR2(16) ,
     REG_DATE DATE  NOT NULL
);

ALTER TABLE RF_ANALYSIS_OPTION 
    ADD CONSTRAINT RF_ANALYSIS_OPTION_PK PRIMARY KEY ( SEQ ) ;

CREATE TABLE RF_CLUSTER_UPDATE_INFO( 
     ID INTEGER  NOT NULL , 
     SEQ INTEGER  NOT NULL , 
     REG_DATE DATE  NOT NULL
);

ALTER TABLE RF_CLUSTER_UPDATE_INFO 
    ADD CONSTRAINT RF_CLUSTER_UPDATE_INFO_PK PRIMARY KEY (ID) ;
    
ALTER TABLE RF_CLUSTER_UPDATE_INFO 
    ADD CONSTRAINT RF_CUI_RF_AO_FK FOREIGN KEY(SEQ) REFERENCES RF_ANALYSIS_OPTION(SEQ) ON DELETE CASCADE;    


DROP SEQUENCE RF_CLUSTER_UPDATE_INFO_ID;
CREATE SEQUENCE RF_CLUSTER_UPDATE_INFO_ID
increment by 1
start with 1
nomaxvalue
nocycle
nocache
ORDER ;    

CREATE TABLE RF_CLUSTER_EID( 
     EID VARCHAR2 (12)  NOT NULL , 
     TITLE VARCHAR2 (3000 CHAR) , 
     AFFILATION VARCHAR2 (3000) , 
     IS_KOREA CHAR(1),
     AUTHOR CLOB 
);

ALTER TABLE RF_CLUSTER_EID 
    ADD CONSTRAINT RF_CLUSTER_EID_PK PRIMARY KEY (EID) ;

CREATE TABLE RF_CLUSETER_DOCUMENT( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL , 
     UPDATE_FLAG	INTEGER NOT NULL,
     EID VARCHAR2 (12 CHAR)  NOT NULL , 
     COUNT INTEGER 
);
ALTER TABLE RF_CLUSETER_DOCUMENT 
    ADD CONSTRAINT RF_CLUSETER_DOCUMENT_PK PRIMARY KEY ( SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG, EID ) ;

ALTER TABLE RF_CLUSETER_DOCUMENT 
    ADD CONSTRAINT RF_CLUSETER_DOCUMENTEID_FK FOREIGN KEY(EID) REFERENCES RF_CLUSTER_EID(EID) ON DELETE CASCADE;    

ALTER TABLE RF_CLUSETER_DOCUMENT 
    ADD CONSTRAINT RF_CLUSETER_DOCUMENT_FK FOREIGN KEY (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG)  
							  REFERENCES RF_ANALASYS_CLUSTER (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG)  
    ON DELETE CASCADE 
;	

CREATE TABLE RF_CLUSTER_ASJC( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL , 
     UPDATE_FLAG	INTEGER NOT NULL,
     ASJC CHAR (4)  NOT NULL , 
     TYPE CHAR (1) 
);
ALTER TABLE RF_CLUSTER_ASJC 
    ADD CONSTRAINT TABLE_12_PK PRIMARY KEY ( SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG, ASJC) ;
    
CREATE TABLE RF_CLUSTER_INFO( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL ,
     UPDATE_FLAG	INTEGER NOT NULL,
     DATA	CLOB NOT NULL
);
ALTER TABLE RF_CLUSTER_INFO 
    ADD CONSTRAINT RF_CLUSTER_INFO1_PK PRIMARY KEY ( SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG) ;


CREATE TABLE RF_CLUSTER_DOMESTIC( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL , 
     UPDATE_FLAG	INTEGER NOT NULL,
     EID VARCHAR2 (12)  NOT NULL
);

ALTER TABLE RF_CLUSTER_DOMESTIC 
    ADD CONSTRAINT RF_CLUSTER_DOMESTIC_PK PRIMARY KEY (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG, EID) ;
    
CREATE TABLE RF_CLUSTER_KEYWORD( 
     SEQ INTEGER  NOT NULL , 
     CONSECUTIVE_NUMBER INTEGER  NOT NULL , 
     UPDATE_FLAG	INTEGER NOT NULL,
     KEYWORD VARCHAR2 (255)  NOT NULL,
     CNT INTEGER NOT NULL
);

-- 2013년 9월 추가 - 불용어 사전 관리 테이블
CREATE TABLE RF_CLUSTER_STOP_WORD( 
     SEQ INTEGER  NOT NULL , 
     KEYWORD VARCHAR2 (255)  NOT NULL
);

ALTER TABLE RF_CLUSTER_STOP_WORD 
    ADD CONSTRAINT RF_CLUSTER_STOP_WORD_PK PRIMARY KEY (SEQ, KEYWORD);
    
DROP SEQUENCE RF_CLUSTER_STOP_WORD_SEQ;
CREATE SEQUENCE RF_CLUSTER_STOP_WORD_SEQ 
increment by 1
start with 1
nomaxvalue
nocycle
nocache
ORDER;


ALTER TABLE RF_CLUSTER_KEYWORD 
    ADD CONSTRAINT RF_CLUSTER_KEYWORD_PK PRIMARY KEY (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG, KEYWORD) ;
    
ALTER TABLE RF_CLUSTER_DOMESTIC 
    ADD CONSTRAINT RF_CLUSTER_DOMESTICEID_FK FOREIGN KEY(EID) REFERENCES RF_CLUSTER_EID(EID) ON DELETE CASCADE;
	
ALTER TABLE RF_CLUSTER_DOMESTIC 
    ADD CONSTRAINT RF_CLUSTER_DOMESTIC_FK FOREIGN KEY (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG) 
						    REFERENCES RF_ANALASYS_CLUSTER (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG)  
    ON DELETE CASCADE 
;

	
ALTER TABLE RF_ANALYSIS_ASJC 
    ADD CONSTRAINT RF_ANALYSIS_ASJC_FK FOREIGN KEY(SEQ) REFERENCES RF_ANALYSIS(SEQ) ON DELETE CASCADE;


ALTER TABLE RF_CLUSTER_ASJC 
    ADD CONSTRAINT RF_CLUSTER_ASJC_FK FOREIGN KEY (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG) 
    						REFERENCES RF_ANALASYS_CLUSTER (SEQ, CONSECUTIVE_NUMBER, UPDATE_FLAG)
    ON DELETE CASCADE 
;




DROP SEQUENCE RF_ANALYSIS_OPTION_SEQ_SEQ;
CREATE SEQUENCE RF_ANALYSIS_OPTION_SEQ_SEQ
increment by 1
start with 1
nomaxvalue
nocycle
nocache
ORDER ;

DROP SEQUENCE RF_ANLAYSIS_SEQ_SEQ;
CREATE SEQUENCE RF_ANLAYSIS_SEQ_SEQ 
increment by 1
start with 1
nomaxvalue
nocycle
nocache
ORDER ;

INSERT INTO RF_ANALYSIS_OPTION VALUES (
	RF_ANALYSIS_OPTION_SEQ_SEQ.nextval, 
	'{"maxClusterSize":"50","analysisType":"KC","minClusterSize":"5","thresholdCut":"5","simility":"co","threshold":"0.01"}',
	'admin',
	CURRENT_DATE
);
commit;