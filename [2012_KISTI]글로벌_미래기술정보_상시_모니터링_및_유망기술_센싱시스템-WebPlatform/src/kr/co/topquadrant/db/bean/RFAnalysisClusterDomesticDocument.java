package kr.co.topquadrant.db.bean;

public class RFAnalysisClusterDomesticDocument {

	int seq, consecutiveNumber;
	/**
	 * �� ���̵�
	 */
	String eid;
	/**
	 * �����
	 */
	String affilation;
	/**
	 * ���ڸ�.
	 */
	String author;

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getConsecutiveNumber() {
		return consecutiveNumber;
	}

	public void setConsecutiveNumber(int consecutiveNumber) {
		this.consecutiveNumber = consecutiveNumber;
	}

	public String getEid() {
		return eid;
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getAffilation() {
		return affilation;
	}

	public void setAffilation(String affilation) {
		this.affilation = affilation;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}
}
