package kr.co.tqk.web.db.bean;

import kr.co.tqk.web.util.UtilString;

/**
 * Âü°í¹®Çå Á¤º¸.
 * 
 * @author Á¤½ÂÇÑ
 * 
 */
public class ReferenceBean {
	ScopusDocumentBean documentBean;
	String eid, refEid, publicationYear, text, title, sourceTitle, issue,
			volumn, firstPage, lastPage, page;

	public ReferenceBean(String _eid) {
		this.eid = _eid;
	}

	public ScopusDocumentBean getDocumentBean() {
		return documentBean;
	}

	public void setDocumentBean(ScopusDocumentBean documentBean) {
		this.documentBean = documentBean;
	}

	public String getRefEid() {
		return UtilString.nullCkeck(refEid);
	}

	public void setRefEid(String refEid) {
		this.refEid = refEid;
	}

	public String getPublicationYear() {
		return UtilString.nullCkeck(publicationYear);
	}

	public void setPublicationYear(String publicationYear) {
		this.publicationYear = publicationYear;
	}

	public String getText() {
		return UtilString.nullCkeck(text);
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getTitle() {
		return UtilString.nullCkeck(title);
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSourceTitle() {
		return UtilString.nullCkeck(sourceTitle);
	}

	public void setSourceTitle(String sourceTitle) {
		this.sourceTitle = sourceTitle;
	}

	public String getIssue() {
		return UtilString.nullCkeck(issue);
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public String getVolumn() {
		return UtilString.nullCkeck(volumn);
	}

	public void setVolumn(String volumn) {
		this.volumn = volumn;
	}

	public String getFirstPage() {
		return UtilString.nullCkeck(firstPage);
	}

	public void setFirstPage(String firstPage) {
		this.firstPage = firstPage;
	}

	public String getLastPage() {
		return UtilString.nullCkeck(lastPage);
	}

	public void setLastPage(String lastPage) {
		this.lastPage = lastPage;
	}

	public String getPage() {
		return UtilString.nullCkeck(page);
	}

	public void setPage(String page) {
		this.page = page;
	}

}
