package kr.co.tqk.analysis.report;

import java.util.HashMap;
import java.util.HashSet;

import kr.co.tqk.web.util.UtilString;

import org.apache.commons.collections.map.MultiValueMap;

/**
 * @author Á¤½ÂÇÑ
 * 
 */
public class DocumentBean {

	public String getAbs() {
		return abs;
	}

	public void setAbs(String abs) {
		this.abs = abs;
	}

	public int getReferenceCount() {
		return referenceCount;
	}

	public void setReferenceCount(int referenceCount) {
		this.referenceCount = referenceCount;
	}

	public void setPublicationYear(int publicationYear) {
		this.publicationYear = publicationYear;
	}

	String eid, title, abs, sourceTitle, clusterKeyNo;

	public String getClusterKeyNo() {
		return UtilString.nullCkeck(clusterKeyNo);
	}

	public void setClusterKeyNo(String clusterKeyNo) {
		this.clusterKeyNo = clusterKeyNo;
	}

	public String getSourceTitle() {
		return sourceTitle;
	}

	public void setSourceTitle(String sourceTitle) {
		this.sourceTitle = sourceTitle;
	}

	int citationCount, referenceCount, publicationYear;
	HashSet<String> keywordList;
	HashSet<String> asjcCodeList;
	HashMap<String, String> citationInfo;
	MultiValueMap koreaOrgAndAuthorNameInfo;
	HashMap<String, String> topCitationCountOrgAndAuthorNameInfo;

	public MultiValueMap getKoreaOrgAndAuthorNameInfo() {
		return koreaOrgAndAuthorNameInfo;
	}

	public void setKoreaOrgAndAuthorNameInfo(
			MultiValueMap koreaOrgAndAuthorNameInfo) {
		this.koreaOrgAndAuthorNameInfo = koreaOrgAndAuthorNameInfo;
	}
	
	public HashMap<String, String> getTopCitationCountOrgAndAuthorNameInfo() {
		return topCitationCountOrgAndAuthorNameInfo;
	}
	
	public void setTopCitationCountOrgAndAuthorNameInfo(
			HashMap<String, String> topCitationCountOrgAndAuthorNameInfo) {
		this.topCitationCountOrgAndAuthorNameInfo = topCitationCountOrgAndAuthorNameInfo;
	}

	public HashMap<String, String> getCitationInfo() {
		return citationInfo;
	}

	public void setCitationInfo(HashMap<String, String> citationInfo) {
		this.citationInfo = citationInfo;
	}

	public String getEid() {
		return eid;
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		if (title == null)
			title = "";
		this.title = title;
	}

	public int getPublicationYear() {
		return publicationYear;
	}

	public void setPublicationYear(String publicationYear) {
		if (publicationYear == null)
			publicationYear = "";
		try {
			this.publicationYear = Integer.parseInt(publicationYear);
		} catch (Exception e) {
			this.publicationYear = 0;
		}
	}

	public int getCitationCount() {
		return citationCount;
	}

	public void setCitationCount(int citationCount) {
		this.citationCount = citationCount;
	}

	public HashSet<String> getKeywordList() {
		return keywordList;
	}

	public void setKeywordList(HashSet<String> keywordList) {
		this.keywordList = keywordList;
	}

	public HashSet<String> getAsjcCodeList() {
		return asjcCodeList;
	}

	public void setAsjcCodeList(HashSet<String> asjcCodeList) {
		this.asjcCodeList = asjcCodeList;
	}
}
