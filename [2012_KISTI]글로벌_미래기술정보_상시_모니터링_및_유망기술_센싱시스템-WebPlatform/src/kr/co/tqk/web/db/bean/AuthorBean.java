package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 저자 정보를 담는다.
 * 
 * @author 정승한
 * 
 */
public class AuthorBean {
	String authorID, authorName, email, delegateAuthorName;
	int authorSeq, ranking, eidCnt;

	public int getRanking() {
		return ranking;
	}

	public void setRanking(int ranking) {
		this.ranking = ranking;
	}

	public int getAuthorSeq() {
		return authorSeq;
	}

	public void setAuthorSeq(int authorSeq) {
		this.authorSeq = authorSeq;
	}

	public String getAuthorID() {
		return UtilString.nullCkeck(authorID);
	}

	public void setAuthorID(String authorID) {
		this.authorID = authorID;
	}

	public String getAuthorName() {
		return UtilString.nullCkeck(authorName);
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	public String getEmail() {
		return UtilString.nullCkeck(email);
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getDelegateAuthorName() {
		return UtilString.nullCkeck(delegateAuthorName);
	}

	public void setDelegateAuthorName(String delegateAuthorName) {
		this.delegateAuthorName = delegateAuthorName;
	}

	public int getEidCnt() {
		return UtilString.nullCkeck(eidCnt);
	}

	public void setEidCnt(int eidCnt) {
		this.eidCnt = eidCnt;
	}

}
