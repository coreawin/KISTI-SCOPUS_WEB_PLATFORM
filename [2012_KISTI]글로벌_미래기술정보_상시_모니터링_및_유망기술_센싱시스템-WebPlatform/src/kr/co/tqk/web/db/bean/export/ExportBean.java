package kr.co.tqk.web.db.bean.export;

import java.util.HashMap;
import java.util.Map;

import kr.co.tqk.web.db.DescriptionCode;
import kr.co.tqk.web.db.dao.export.ExportField;
import kr.co.tqk.web.util.UtilString;

/**
 * 데이터 익스포트용 Bean <br>
 * 
 * author_ : 저자정보 변수 <br>
 * source_ : 출처정보 변수<br>
 * corr_ : 교신저자 정보 변수<br>
 * 
 * @author 정승한
 * 
 */
public class ExportBean {

	String eid, title, abstractTitle, year, doi, authorKeyword, indexKeyword, asjcCode, citationList, referenceList, refCitList, citation_type,
			author_authorName, author_affiliation_info, author_email, author_country, author_affiliation, affiliation_country, source_sourceTitle,
			source_volumn, source_issue, source_page, source_type, source_publisher, source_country, source_pissn, source_eissn, corr_authorName, corr_country,
			corr_email, corr_affilation;

	int numberOfCitation, numberOfReference;

	Map<ExportField, Boolean> exportField = new HashMap<ExportField, Boolean>();

	public ExportBean(String eid) {
		this.eid = eid;
	}

	public ExportBean(String eid, Map<ExportField, Boolean> exportField) {
		this.eid = eid;
		this.exportField = exportField;
	}

	private String checkField(ExportField field, String s) {
		if (exportField.containsKey(field)) {
			boolean isExport = exportField.get(field);
			if (!isExport) {
				return "";
			}
		}
		return UtilString.nullCkeck(s);
	}
	
	private int checkField(ExportField field, int s) {
		if (exportField.containsKey(field)) {
			boolean isExport = exportField.get(field);
			if (!isExport) {
				return 0;
			}
		}
		return UtilString.nullCkeck(s);
	}

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public String getRefCitList() {
		return checkField(ExportField.CITATION, refCitList);
//		return UtilString.nullCkeck(refCitList);
	}

	public void setRefCitList(String refCitList) {
		this.refCitList = refCitList;
	}

	public String getTitle() {
//		return UtilString.nullCkeck(title);
		return checkField(ExportField.TITLE, title);
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAbstractTitle() {
//		return UtilString.nullCkeck(abstractTitle);
		return checkField(ExportField.ABSTRACT, abstractTitle);
	}

	public void setAbstractTitle(String abstractTitle) {
		this.abstractTitle = abstractTitle;
	}

	public String getYear() {
//		return UtilString.nullCkeck(year);
		return checkField(ExportField.YEAR, year);
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getDoi() {
//		return UtilString.nullCkeck(doi);
		return checkField(ExportField.DOI, doi);
	}

	public void setDoi(String doi) {
		this.doi = doi;
	}

	public String getAuthorKeyword() {
//		return UtilString.nullCkeck(authorKeyword);
		return checkField(ExportField.KEYWORD, authorKeyword);
	}

	public void setAuthorKeyword(String authorKeyword) {
		this.authorKeyword = authorKeyword;
	}

	public String getIndexKeyword() {
//		return UtilString.nullCkeck(indexKeyword);
		return checkField(ExportField.INDEX_KEYWORD, indexKeyword);
	}

	public void setIndexKeyword(String indexKeyword) {
		this.indexKeyword = indexKeyword;
	}

	public String getAsjcCode() {
//		return UtilString.nullCkeck(asjcCode);
		return checkField(ExportField.ASJC, asjcCode);
	}

	public void setAsjcCode(String asjcCode) {
		this.asjcCode = asjcCode;
	}

	public String getCitationList() {
//		return UtilString.nullCkeck(citationList);
		return checkField(ExportField.CITATION, citationList);
	}

	public void setCitationList(String citationList) {
		this.citationList = citationList;
	}

	public String getReferenceList() {
//		return UtilString.nullCkeck(referenceList);
		return checkField(ExportField.REFERENCE, referenceList);
	}

	public void setReferenceList(String referenceList) {
		this.referenceList = referenceList;
	}

	public String getAuthor_authorName() {
//		return UtilString.nullCkeck(author_authorName);
		return checkField(ExportField.AUTHOR_NAME, author_authorName);
	}

	public void setAuthor_authorName(String author_authorName) {
		this.author_authorName = author_authorName;
	}

	public String getAuthor_email() {
//		return UtilString.nullCkeck(author_email);
		return checkField(ExportField.AUTHOR_EMAIL, author_email);
	}

	public void setAuthor_email(String author_email) {
		this.author_email = author_email;
	}

	public String getAuthor_country() {
//		return UtilString.nullCkeck(author_country);
		return checkField(ExportField.AUTHOR_COUNTRYCODE, author_country);
	}

	public void setAuthor_country(String author_country) {
		this.author_country = author_country;
	}

	public String getAuthor_affilation() {
//		return UtilString.nullCkeck(author_affiliation);
		return checkField(ExportField.AFFILIATION_NAME, author_affiliation);
	}

	public void setAuthor_affilation(String author_affilation) {
		this.author_affiliation = author_affilation;
	}

	public String getSource_sourceTitle() {
//		return UtilString.nullCkeck(source_sourceTitle);
		return checkField(ExportField.SOURCE_SOURCETITLE, source_sourceTitle);
	}

	public void setSource_sourceTitle(String source_sourceTitle) {
		this.source_sourceTitle = source_sourceTitle;
	}

	public String getSource_volumn() {
//		return UtilString.nullCkeck(source_volumn);
		return checkField(ExportField.SOURCE_VOLUMN, source_volumn);
	}

	public void setSource_volumn(String source_volumn) {
		this.source_volumn = source_volumn;
	}

	public String getSource_issue() {
//		return UtilString.nullCkeck(source_issue);
		return checkField(ExportField.SOURCE_ISSUE, source_issue);
	}

	public void setSource_issue(String source_issue) {
		this.source_issue = source_issue;
	}

	public String getSource_page() {
//		return UtilString.nullCkeck(source_page);
		return checkField(ExportField.SOURCE_PAGE, source_page);
	}

	public void setSource_page(String source_page) {
		source_page = UtilString.nullCkeck(source_page);
		source_page = source_page.replaceAll("null", "");
		this.source_page = source_page;
	}

	public String getSource_type() {
//		return UtilString.nullCkeck(source_type);
		return checkField(ExportField.SOURCE_TYPE, source_type);
	}

	public void setSource_type(String source_type) {
		this.source_type = source_type;
	}

	public String getSource_publisher() {
//		return UtilString.nullCkeck(source_publisher);
		return checkField(ExportField.SOURCE_PUBLICSHERNAME, source_publisher);
	}

	public void setSource_publisher(String source_publisher) {
		this.source_publisher = source_publisher;
	}

	public String getSource_country() {
//		return UtilString.nullCkeck(source_country);
		return checkField(ExportField.SOURCE_COUNTRY, source_country);
	}

	public void setSource_country(String source_country) {
		this.source_country = source_country;
	}

	public String getSource_pissn() {
//		return UtilString.nullCkeck(source_pissn);
		return checkField(ExportField.SOURCE_PISSN, source_pissn);
	}

	public void setSource_pissn(String source_pissn) {
		this.source_pissn = source_pissn;
	}

	public String getSource_eissn() {
//		return UtilString.nullCkeck(source_eissn);
		return checkField(ExportField.SOURCE_EISSN, source_eissn);
	}

	public void setSource_eissn(String source_eissn) {
		this.source_eissn = source_eissn;
	}

	public String getCorr_authorName() {
//		return UtilString.nullCkeck(corr_authorName);
		return checkField(ExportField.CORR_AUTHORNAME, corr_authorName);
	}

	public void setCorr_authorName(String corr_authorName) {
		this.corr_authorName = corr_authorName;
	}

	public String getCorr_country() {
//		return UtilString.nullCkeck(corr_country);
		return checkField(ExportField.CORR_COUNTRYCODE, corr_country);
	}

	public void setCorr_country(String corr_country) {
		this.corr_country = corr_country;
	}

	public String getCorr_email() {
//		return UtilString.nullCkeck(corr_email);
		return checkField(ExportField.CORR_EMAIL, corr_email);
	}

	public void setCorr_email(String corr_email) {
		this.corr_email = corr_email;
	}

	public String getCorr_affilation() {
//		return UtilString.nullCkeck(corr_affilation);
		return checkField(ExportField.CORR_AFFILIATION, corr_affilation);
	}

	public void setCorr_affilation(String corr_affilation) {
		this.corr_affilation = corr_affilation;
	}

	public int getNumberOfCitation() {
//		return UtilString.nullCkeck(numberOfCitation);
		return checkField(ExportField.NUMBER_CITATION, numberOfCitation);
	}

	public void setNumberOfCitation(int numberOfCitation) {
		this.numberOfCitation = numberOfCitation;
	}

	public int getNumberOfReference() {
//		return UtilString.nullCkeck(numberOfReference);
		return checkField(ExportField.NUMBER_REFERENCE, numberOfReference);
	}

	public void setNumberOfReference(int numberOfReference) {
		this.numberOfReference = numberOfReference;
	}

	public String getAuthor_affilation_info() {
//		return author_affiliation_info;
		return checkField(ExportField.AUTHOR_AUTHORINFO, author_affiliation_info);
	}

	public void setAuthor_affilation_info(String author_affilation_info) {
		this.author_affiliation_info = author_affilation_info;
	}

	public String getAffiliation_country() {
//		return UtilString.nullCkeck(affiliation_country);
		return checkField(ExportField.AFFILIATION_COUNTRY, affiliation_country);
	}

	public void setAffiliation_country(String affiliation_country) {
		this.affiliation_country = affiliation_country;
	}

	public String getCitation_type() {
		if (citation_type != null) {
			String v = String.valueOf(DescriptionCode.getCitationType().get(citation_type.trim().toLowerCase()));
			return checkField(ExportField.CITATION_TYPE, v);
		} else {
			return checkField(ExportField.CITATION_TYPE, citation_type);
		}
	}

	public void setCitation_type(String citation_type) {
		this.citation_type = citation_type;
	}

}
