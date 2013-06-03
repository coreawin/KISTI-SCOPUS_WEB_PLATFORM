package kr.co.tqk.web.db.bean.mgr;

import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

/**
 * 유저 이용현황 정보
 * 
 * @author 정승한
 * 
 */
public class UserUsePlatformBean {

	String userID;
	int seq, useType;
	Timestamp insertTime;

	/**
	 * @return 사용자 ID
	 */
	public String getUserID() {
		return UtilString.nullCkeck(userID);
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * @return DB 시퀀스 번호
	 */
	public int getSeq() {
		return UtilString.nullCkeck(seq);
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	/**
	 * 
	 * @return 이용 현황 플래그
	 */
	public int getUseType() {
		return UtilString.nullCkeck(useType);
	}

	public void setUseType(int useType) {
		this.useType = useType;
	}

	/**
	 * @return 입력 시간
	 */
	public Timestamp getInsertTime() {
		return UtilString.nullCkeck(insertTime);
	}

	public void setInsertTime(Timestamp insertTime) {
		this.insertTime = insertTime;
	}

}
