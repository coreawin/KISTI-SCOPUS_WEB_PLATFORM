package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 교신저자
 * 
 * @author 정승한
 * 
 */
public class CorrespondAuthorBean {

	AuthorBean author;
	String eid, organization, countryCode;

	public AuthorBean getAuthor() {
		return author;
	}

	public void setAuthor(AuthorBean author) {
		this.author = author;
	}

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getOrganization() {
		return UtilString.nullCkeck(organization);
	}

	public void setOrganization(String organization) {
		this.organization = organization;
	}

	public String getCountryCode() {
		return UtilString.nullCkeck(countryCode);
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

}
