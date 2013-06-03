package kr.co.topquadrant.db.bean;

public class RFAnalysisClusterASJC {

	int seq;
	int consecutiveNumber;
	/**
	 * ASJC 코드
	 */
	String asjc;
	/**
	 * 타입
	 */
	String type;

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

	public String getAsjc() {
		return asjc;
	}

	public void setAsjc(String asjc) {
		this.asjc = asjc;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}
