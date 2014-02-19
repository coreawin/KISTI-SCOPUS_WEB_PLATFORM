package kr.co.tqk.web.db.dao.xml;

import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import kr.co.tqk.web.db.DescriptionCode;

public class ScopusXMLData {

	public static final String AUTHOR_NAME_REGEX = "\\.\\s{1,}";

	public ScopusXMLData() {
	}

	static Map<String, String> affNameMaps = DescriptionCode.getAffiliationName();

	// private static ScopusXMLData instance = new ScopusXMLData();

	// public static ScopusXMLData getInstance() {
	// return instance;
	// }

	private String eid;

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
		this.title = title;
	}

	public String getAbstractStr() {
		return abstractStr;
	}

	public void setAbstractStr(String abstractStr) {
		this.abstractStr = abstractStr;
	}

	public Set<String> getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		if (keyword != null && keyword.length() > 0) {
			this.keyword.add(keyword);
		}
	}

	public Set<String> getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		if (orgName != null && orgName.length() > 0) {
			this.orgName.add(orgName);
		}
	}

	public String getDoi() {
		return doi;
	}

	public void setDoi(String doi) {
		this.doi = doi;
	}

	StringBuffer buf = new StringBuffer();

	public Set<String> getAsjcCode() {
		return this.asjcCode;
	}

	public void setAsjcCode(String asjcCode) {
		if (asjcCode != null && asjcCode.length() > 0) {
			this.asjcCode.add(asjcCode);
		}
	}

	public String getPublicationYear() {
		return publicationYear;
	}

	public void setPublicationYear(String publicationYear) {
		this.publicationYear = publicationYear;
	}

	public String getRefEid() {
		return refEid;
	}

	public Set<String> getRefEids() {
		return refEids;
	}

	public String getRefCitList(Set<String> refs, Set<String> cits) {
		buf.setLength(0);
		for (String r : refs) {
			buf.append(r);
			buf.append(",R;");
		}
		for (String r : cits) {
			buf.append(r);
			buf.append(",C;");
		}
		if (buf.length() > 0) {
			buf.deleteCharAt(buf.length() - 1);
		}
		return buf.toString();
	}

	public void setRefEid(String eid) {
		if (eid != null && eid.length() > 0) {
			this.refEids.add(eid);
		}
		// this.refEid = refEid;
	}

	public String getRefCount() {
		return refCount;
	}

	public void setRefCount(String refCount) {
		this.refCount = refCount;
	}

	public String getAuthorSeq() {
		return authorSeq;
	}

	public void setAuthorSeq(String authorSeq) {
		this.authorSeq = authorSeq;
	}

	public String getAuthorId() {
		return authorId;
	}

	public void setAuthorId(String authorId) {
		this.authorId = authorId;
	}

	public String getRanking() {
		return ranking;
	}

	public void setRanking(String ranking) {
		this.ranking = ranking;
	}

	public String getCitCount() {
		return citCount;
	}

	public void setCitCount(String citCount) {
		this.citCount = citCount;
	}

	public Set<String> getAfid() {
		return afid;
	}

	public void setAfid(String afid) {
		if (afid != null && afid.length() > 0) {
			this.afid.add(afid);
		}
	}

	public String getCitEid() {
		return citEid;
	}

	public Set<String> getCitEids() {
		return citEids;
	}

	public void setCitEid(String eid) {
		if (eid != null && eid.length() > 0) {
			this.citEids.add(eid);
		}
	}

	public String getCitType() {
		return citType;
	}

	public void setCitType(String citType) {
		this.citType = citType;
	}

	private String title;
	private String abstractStr;
	private Set<String> keyword;
	private Set<String> indexKeyword;
	private Set<String> orgName;
	private String doi;
	private Set<String> asjcCode;
	// private Set<String> countryCode;

	private String publicationYear;
	private String refEid;
	private String refCount = "0";
	private String authorSeq;
	private String authorId;
	private String ranking;
	private String citCount = "0";
	private Set<String> afid;
	private String citEid;

	private Set<String> citEids;
	private Set<String> refEids;

	private String citType;

	private List<String> authorName;
	private List<String> delegateAuthorName;
	private List<String> authorCountry;
	private List<String> authorEmail;

	private String corr_authorName, corr_country, corr_email, corr_affilation;
	private String source_sourceTitle, source_type, source_id, source_volumn, source_issue, source_page, source_publisher, source_country, source_pissn,
			source_eissn;
	private List<String> affiliation_country;
	private Map<String, LinkedHashSet<String>> author_info;

	public void clear() {
		title = "";
		abstractStr = "";
		keyword = new LinkedHashSet<String>();
		indexKeyword = new LinkedHashSet<String>();

		refEids = new HashSet<String>();
		citEids = new HashSet<String>();

		doi = "";

		authorName = new LinkedList<String>();
		delegateAuthorName = new LinkedList<String>();
		authorCountry = new LinkedList<String>();
		authorEmail = new LinkedList<String>();

		source_sourceTitle = "";
		asjcCode = new LinkedHashSet<String>();
		source_type = "";
		source_id = "";
		publicationYear = "";
		refEid = "";
		refCount = "0";
		authorSeq = "";
		authorId = "";
		ranking = "";
		citCount = "0";
		afid = new LinkedHashSet<String>();
		citEid = "";
		orgName = new LinkedHashSet<String>();
		affiliation_country = new LinkedList<String>();
		author_info = new LinkedHashMap<String, LinkedHashSet<String>>();

		corr_authorName = "";
		corr_country = "";
		corr_email = "";
		corr_affilation = "";

		source_sourceTitle = "";
		source_type = "";
		source_id = "";
		source_volumn = "";
		source_issue = "";
		source_page = "";
		source_publisher = "";
		source_country = "";
		source_pissn = "";
		source_eissn = "";
	}

	public Set<String> getIndexKeyword() {
		return indexKeyword;
	}

	public void setIndexKeyword(String src) {
		if (src != null && src.length() > 0) {
			this.indexKeyword.add(src);
		}
	}

	public String getCorr_authorName() {
		return corr_authorName;
	}

	public String getCorr_country() {
		return corr_country;
	}

	public String getCorr_email() {
		return corr_email;
	}

	public String getCorr_affilation() {
		return corr_affilation;
	}

	public void setCorr_authorName(String corr_authorName) {
		if (corr_authorName != null) {
			this.corr_authorName = corr_authorName.replaceAll(AUTHOR_NAME_REGEX, ".").replaceAll("-", "");
		}
	}

	public void setCorr_country(String corr_country) {
		this.corr_country = corr_country;
	}

	public void setCorr_email(String corr_email) {
		this.corr_email = corr_email;
	}

	public void setCorr_affilation(String corr_affilation) {
		this.corr_affilation = corr_affilation;
	}

	public String getSource_sourceTitle() {
		return source_sourceTitle;
	}

	public void setSource_sourceTitle(String source_sourceTitle) {
		this.source_sourceTitle = source_sourceTitle;
	}

	public String getSource_type() {
		return source_type;
	}

	public void setSource_type(String source_type) {
		this.source_type = source_type;
	}

	public String getSource_id() {
		return source_id;
	}

	public void setSource_id(String source_id) {
		this.source_id = source_id;
	}

	public String getSource_volumn() {
		return source_volumn;
	}

	public void setSource_volumn(String source_volumn) {
		this.source_volumn = source_volumn;
	}

	public String getSource_issue() {
		return source_issue;
	}

	public void setSource_issue(String source_issue) {
		this.source_issue = source_issue;
	}

	public String getSource_page() {
		return source_page;
	}

	public void setSource_page(String source_page) {
		this.source_page = source_page;
	}

	public String getSource_publisher() {
		return source_publisher;
	}

	public void setSource_publisher(String source_publisher) {
		this.source_publisher = source_publisher;
	}

	public String getSource_country() {
		return source_country;
	}

	public void setSource_country(String source_country) {
		this.source_country = source_country;
	}

	public String getSource_pissn() {
		return source_pissn;
	}

	public void setSource_pissn(String source_pissn) {
		this.source_pissn = source_pissn;
	}

	public String getSource_eissn() {
		return source_eissn;
	}

	public void setSource_eissn(String source_eissn) {
		this.source_eissn = source_eissn;
	}

	public List<String> getAffiliation_country() {
		return affiliation_country;
	}

	public void setAffiliation_country(String affCn) {
		if (affCn != null && affCn.length() > 0) {
			this.affiliation_country.add(affCn);
		}
	}

	public List<String> getAuthorCountry() {
		return authorCountry;
	}

	public void setAuthorCountry(String src) {
		if (src != null && src.length() > 0) {
			this.authorCountry.add(src);
		}
	}

	public List<String> getAuthorEmail() {
		return authorEmail;
	}

	public void setAuthorEmail(String src) {
		if (src != null) {
			this.authorEmail.add(src);
		}
	}

	public void setAuthorName(String src) {
		if (src != null) {
			this.authorName.add(src.replaceAll(AUTHOR_NAME_REGEX, ".").replaceAll("-", ""));
		}
	}

	public void setDelegateAuthorName(String src) {
		if (src != null) {
			this.delegateAuthorName.add(src.replaceAll(AUTHOR_NAME_REGEX, ".").replaceAll("-", ""));
		}
	}

	public void setAuthorInfo(String afid, String authorName) {
		if (afid == null)
			afid = "0";
		LinkedHashSet<String> data = author_info.get(afid);
		if (data == null) {
			data = new LinkedHashSet<String>();
		}
		data.add(authorName.replaceAll(AUTHOR_NAME_REGEX, ".").replaceAll("-", ""));
		author_info.put(afid, data);
	}

	public String getAuthorInfo() {
		// Fujita K.,Ishikawa T.,Tsutsui T.(Kyushu University)_JPN;
		StringBuffer buf = new StringBuffer();
		Set<String> afids = author_info.keySet();
		for (String afid : afids) {
			LinkedHashSet<String> authorNames = author_info.get(afid);
			for (String authorName : authorNames) {
				buf.append(authorName);
				buf.append(",");
			}
			if (buf.length() > 0) {
				buf.deleteCharAt(buf.length() - 1);
			}
			String value = affNameMaps.get(afid);
			String afName = "";
			String cn = "";
			if (value != null) {
				String[] vs = value.split("\\|");
				afName = vs[0];
				if (vs.length > 1) {
					cn = vs[1];
				}
			}
			buf.append("(");
			buf.append(afName);
			buf.append(")_");
			buf.append(cn);
			buf.append(";");
		}
		if (buf.length() > 0) {
			buf.deleteCharAt(buf.length() - 1);
		}
		return buf.toString();
	}

	public List<String> getAuthorName() {
		return authorName;
	}

	public List<String> getDelegateAuthorName() {
		return delegateAuthorName;
	}
}
