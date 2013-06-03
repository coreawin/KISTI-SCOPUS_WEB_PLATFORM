package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * ÀÎ¿ë¹®Çå Á¤º¸.
 * 
 * @author Á¤½ÂÇÑ
 * 
 */
public class CitationBean {

	String eid, publicationYear, citEid;

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getPublicationYear() {
		return UtilString.nullCkeck(publicationYear);
	}

	public void setPublicationYear(String publicationYear) {
		this.publicationYear = publicationYear;
	}

	public String getCitEid() {
		return UtilString.nullCkeck(citEid);
	}

	public void setCitEid(String citEid) {
		this.citEid = citEid;
	}

}
