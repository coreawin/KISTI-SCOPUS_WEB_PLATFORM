package kr.co.tqk.web.db.bean.mgr;

import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

/**
 * ���� �̿���Ȳ ����
 * 
 * @author ������
 * 
 */
public class UserUsePlatformBean {

	String userID;
	int seq, useType;
	Timestamp insertTime;

	/**
	 * @return ����� ID
	 */
	public String getUserID() {
		return UtilString.nullCkeck(userID);
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * @return DB ������ ��ȣ
	 */
	public int getSeq() {
		return UtilString.nullCkeck(seq);
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	/**
	 * 
	 * @return �̿� ��Ȳ �÷���
	 */
	public int getUseType() {
		return UtilString.nullCkeck(useType);
	}

	public void setUseType(int useType) {
		this.useType = useType;
	}

	/**
	 * @return �Է� �ð�
	 */
	public Timestamp getInsertTime() {
		return UtilString.nullCkeck(insertTime);
	}

	public void setInsertTime(Timestamp insertTime) {
		this.insertTime = insertTime;
	}

}
