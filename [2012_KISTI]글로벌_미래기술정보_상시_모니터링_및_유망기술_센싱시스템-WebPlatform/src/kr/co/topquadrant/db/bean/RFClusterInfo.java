package kr.co.topquadrant.db.bean;

/**
 * RF_CLUSTER_INFO 테이블 대응.<br>
 * 
 * @author 정승한
 * 
 */
public class RFClusterInfo {
	int seq;
	int consecutiveNumber;
	int updateFlag;
	String data;

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

	/**
	 * JSON 형식의 데이터를 리턴한다.
	 * @return
	 */
	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}
}
