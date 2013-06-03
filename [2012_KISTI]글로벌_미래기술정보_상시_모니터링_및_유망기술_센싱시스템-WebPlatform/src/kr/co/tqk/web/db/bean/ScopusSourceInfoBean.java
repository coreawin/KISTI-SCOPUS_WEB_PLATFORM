package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 저널 정보.
 * 
 * @author 정승한
 * 
 */
public class ScopusSourceInfoBean {

	String sourceID, title, pissn, eissn, type, publisherName, country;

	public String getSourceID() {
		return UtilString.nullCkeck(sourceID);
	}

	public void setSourceID(String sourceID) {
		this.sourceID = sourceID;
	}

	public String getTitle() {
		return UtilString.nullCkeck(title);
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPissn() {
		return UtilString.nullCkeck(pissn);
	}

	public void setPissn(String pissn) {
		this.pissn = pissn;
	}

	public String getEissn() {
		return UtilString.nullCkeck(eissn);
	}

	public void setEissn(String eissn) {
		this.eissn = eissn;
	}

	public String getType() {
		return UtilString.nullCkeck(type);
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPublisherName() {
		return UtilString.nullCkeck(publisherName);
	}

	public void setPublisherName(String publisherName) {
		this.publisherName = publisherName;
	}

	public String getCountry() {
		return UtilString.nullCkeck(country);
	}

	public void setCountry(String country) {
		this.country = country;
	}

}
