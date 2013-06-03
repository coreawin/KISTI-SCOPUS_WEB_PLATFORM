package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 저자 상세보기를 위한 저자 Bean
 * 
 * @author 정승한
 * 
 */
public class AuthorInfoBean {
	String eid, author_seq, afid, dftid, orgName, countryCode, delegateOrgName,
			authorID, authorName, delegateAuthorName, email;
	int groupSequence, ranking;

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getAuthor_seq() {
		return UtilString.nullCkeck(author_seq);
	}

	public void setAuthor_seq(String author_seq) {
		this.author_seq = author_seq;
	}

	public String getAfid() {
		return UtilString.nullCkeck(afid);
	}

	public void setAfid(String afid) {
		this.afid = afid;
	}

	public String getDftid() {
		return UtilString.nullCkeck(dftid);
	}

	public void setDftid(String dftid) {
		this.dftid = dftid;
	}

	public String getOrgName() {
		return UtilString.nullCkeck(orgName);
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getCountryCode() {
		return UtilString.nullCkeck(countryCode);
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

	public String getDelegateOrgName() {
		return UtilString.nullCkeck(delegateOrgName);
	}

	public void setDelegateOrgName(String delegateOrgName) {
		this.delegateOrgName = delegateOrgName;
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

	public String getDelegateAuthorName() {
		return UtilString.nullCkeck(delegateAuthorName);
	}

	public void setDelegateAuthorName(String delegateAuthorName) {
		this.delegateAuthorName = delegateAuthorName;
	}

	public String getEmail() {
		return UtilString.nullCkeck(email);
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getGroupSequence() {
		return UtilString.nullCkeck(groupSequence);
	}

	public void setGroupSequence(int groupSequence) {
		this.groupSequence = groupSequence;
	}

	public int getRanking() {
		return UtilString.nullCkeck(ranking);
	}

	public void setRanking(int ranking) {
		this.ranking = ranking;
	}
}