package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * 문서 세부 정보 보기
 * 
 * @author 정승한
 * 
 */
public class ScopusDocumentBean {

	String eid, title, abs, publicationYear, publicationMonth, volumn, issue,
			page, sourceID, DOI, citationType;
	
	public String getCitationType() {
		return UtilString.nullCkeck(citationType);
	}

	public void setCitationType(String citationType) {
		this.citationType = citationType;
	}

	int refCount, citCount;

	public int getRefCount() {
		return refCount;
	}

	public void setRefCount(int refCount) {
		this.refCount = refCount;
	}

	public int getCitCount() {
		return citCount;
	}

	public void setCitCount(int citCount) {
		this.citCount = citCount;
	}

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getTitle() {
		return UtilString.nullCkeck(title);
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAbs() {
		return UtilString.nullCkeck(abs);
	}

	public void setAbs(String abs) {
		this.abs = abs;
	}

	public String getPublicationYear() {
		return UtilString.nullCkeck(publicationYear);
	}

	public void setPublicationYear(String publicationYear) {
		this.publicationYear = publicationYear;
	}

	public String getPublicationMonth() {
		return UtilString.nullCkeck(publicationMonth);
	}

	public void setPublicationMonth(String publicationMonth) {
		this.publicationMonth = publicationMonth;
	}

	public String getVolumn() {
		return UtilString.nullCkeck(volumn);
	}

	public void setVolumn(String volumn) {
		this.volumn = volumn;
	}

	public String getIssue() {
		return UtilString.nullCkeck(issue);
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public String getPage() {
		return UtilString.nullCkeck(page);
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getSourceID() {
		return UtilString.nullCkeck(sourceID);
	}

	public void setSourceID(String sourceID) {
		this.sourceID = sourceID;
	}

	public String getDOI() {
		return UtilString.nullCkeck(DOI);
	}

	public void setDOI(String dOI) {
		DOI = dOI;
	}

}
