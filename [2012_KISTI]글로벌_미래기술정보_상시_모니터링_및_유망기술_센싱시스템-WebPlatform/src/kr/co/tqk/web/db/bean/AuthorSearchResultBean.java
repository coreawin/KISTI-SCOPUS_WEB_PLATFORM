package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 저자 검색시 리턴되는 결과물을 담는다.
 * 
 * @author 정승한
 * 
 */
public class AuthorSearchResultBean {
	int authorSeq = 0;
	String authorID, afid, dftid, orgName, countryCode, delegateOrgName;
	AuthorBean authorBean = null;

	public String getAuthorID() {
		return UtilString.nullCkeck(authorID);
	}

	public void setAuthorID(String authorID) {
		this.authorID = authorID;
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

	public AuthorBean getAuthorBean() {
		return authorBean;
	}

	public void setAuthorBean(AuthorBean authorBean) {
		this.authorBean = authorBean;
	}

	public int getAuthorSeq() {
		return UtilString.nullCkeck(authorSeq);
	}

	public void setAuthorSeq(int authorSeq) {
		this.authorSeq = authorSeq;
	}

}
