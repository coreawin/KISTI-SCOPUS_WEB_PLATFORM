package kr.co.topquadrant.db.bean;

import java.sql.Timestamp;

public class ClusterResultSummary {
	int seq;
	int consecutiveNumber;
	int documentCount;
	int documentReferenceCount;
	float referenceCountPerDocument;
	float averagePubYearDocument;
	float averagePubYearCitationDocument;
	Timestamp reg_date;
	int updateFlag;
	String clusterNO;
	String json;

	public ClusterResultSummary(int seq, int consecutiveNumber) {
		this.seq = seq;
		this.consecutiveNumber = consecutiveNumber;
	}
	
	public ClusterResultSummary() {
	}

	public int getDocumentCount() {
		return documentCount;
	}

	public void setDocumentCount(int documentCount) {
		this.documentCount = documentCount;
	}

	public int getDocumentReferenceCount() {
		return documentReferenceCount;
	}

	public void setDocumentReferenceCount(int documentReferenceCount) {
		this.documentReferenceCount = documentReferenceCount;
	}

	public float getReferenceCountPerDocument() {
		return referenceCountPerDocument;
	}

	public void setReferenceCountPerDocument(float referenceCountPerDocument) {
		this.referenceCountPerDocument = referenceCountPerDocument;
	}

	public float getAveragePubYearDocument() {
		return averagePubYearDocument;
	}

	public void setAveragePubYearDocument(float averagePubYearDocument) {
		this.averagePubYearDocument = averagePubYearDocument;
	}

	public float getAveragePubYearCitationDocument() {
		return averagePubYearCitationDocument;
	}

	public void setAveragePubYearCitationDocument(float averagePubYearCitationDocument) {
		this.averagePubYearCitationDocument = averagePubYearCitationDocument;
	}

	public Timestamp getRegDate() {
		return reg_date;
	}

	public void setRegDate(Timestamp regDate) {
		this.reg_date = regDate;
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}

	public int getSeq() {
		return seq;
	}

	public int getConsecutiveNumber() {
		return consecutiveNumber;
	}

	public String getJson() {
		return json;
	}

	public void setJson(String json) {
		this.json = json;
	}

	public Timestamp getReg_Date() {
		return reg_date;
	}

	public void setReg_Date(Timestamp reg_Date) {
		this.reg_date = reg_Date;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public void setConsecutiveNumber(int consecutiveNumber) {
		this.consecutiveNumber = consecutiveNumber;
	}

	public String getClusterNO() {
		return clusterNO;
	}

	public void setClusterNO(String clusterNO) {
		this.clusterNO = clusterNO;
	}

}
