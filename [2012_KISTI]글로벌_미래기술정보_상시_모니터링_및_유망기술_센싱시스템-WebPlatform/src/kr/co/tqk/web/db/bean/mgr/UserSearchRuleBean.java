package kr.co.tqk.web.db.bean.mgr;

import java.io.Serializable;
import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

public class UserSearchRuleBean implements Serializable{
	private static final long serialVersionUID = -8199917516609360737L;
	
	int seq, searchCount;
	String userID, searchRule;
	Timestamp insertDate;

	public int getSeq() {
		return UtilString.nullCkeck(seq);
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getSearchCount() {
		return UtilString.nullCkeck(searchCount);
	}

	public void setSearchCount(int searchCount) {
		this.searchCount = searchCount;
	}

	public String getUserID() {
		return UtilString.nullCkeck(userID);
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getSearchRule() {
		return UtilString.nullCkeck(searchRule);
	}

	public void setSearchRule(String searchRule) {
		this.searchRule = searchRule;
	}

	public Timestamp getInsertDate() {
		return insertDate;
	}

	public void setInsertDate(Timestamp insertDate) {
		this.insertDate = insertDate;
	}

}
