package kr.co.tqk.web.db.bean;

import java.util.LinkedList;

import kr.co.tqk.web.util.UtilString;

/**
 * 논문이 검색된 결과를 나타낸다.<br>
 * 
 * @author 정승한
 * 
 */
public class SearchResultDocumentBean {

	private String eid, title, sourceTitle, publicationYear;
	int cit_count, ref_count;
	LinkedList<AuthorBean> authorInfo = new LinkedList<AuthorBean>();

	public LinkedList<AuthorBean> getAuthorInfo() {
		return authorInfo;
	}

	public void setAuthorInfo(LinkedList<AuthorBean> authorInfo) {
		this.authorInfo = authorInfo;
	}

	public int getCit_count() {
		return cit_count;
	}

	public void setCit_count(int cit_count) {
		this.cit_count = cit_count;
	}

	public int getRef_count() {
		return ref_count;
	}

	public void setRef_count(int ref_count) {
		this.ref_count = ref_count;
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

	public String getSourceTitle() {
		return UtilString.nullCkeck(sourceTitle);
	}

	public void setSourceTitle(String sourceTitle) {
		this.sourceTitle = sourceTitle;
	}

	public String getPublicationYear() {
		return UtilString.nullCkeck(publicationYear);
	}

	public void setPublicationYear(String publicationYear) {
		this.publicationYear = publicationYear;
	}
}
