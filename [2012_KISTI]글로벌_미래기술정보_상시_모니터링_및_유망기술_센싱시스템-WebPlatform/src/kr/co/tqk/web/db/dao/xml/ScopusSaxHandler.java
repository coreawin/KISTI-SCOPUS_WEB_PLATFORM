package kr.co.tqk.web.db.dao.xml;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class ScopusSaxHandler extends DefaultHandler {
	private static Logger logger = LoggerFactory.getLogger(ScopusSaxHandler.class);

	private final String multiValueDelimiter = ";";
	private ScopusXMLData data = new ScopusXMLData();
	// private ScopusXMLData data = ScopusXMLData.getInstance();
	private static StringBuilder currValue;
	private static String str0;
	private static String str1;

	public ScopusXMLData getData() {
		return data;
	}

	private boolean in_0 = false;
	private boolean in_1 = false;
	private boolean authorKeywords = false;
	private boolean in_3 = false;
	private boolean in_4 = false;
	private boolean authorKeyword = false;
	private boolean in_6 = false;
	private boolean in_7 = false;
	private boolean indexKeyword = false;
	private boolean author_group = false;
	private boolean author = false;
	private boolean author_email = false;
	private boolean affiliation = false;
	private boolean in_10 = false;
	private boolean in_11 = false;
	private boolean aff_organization = false;
	private boolean in_13 = false;
	private boolean in_14 = false;
	private boolean in_15 = false;
	private boolean in_16 = false;
	private boolean in_17 = false;
	private boolean reference_TAG = false;
	private boolean in_19 = false;
	private boolean source = false;
	private boolean sourceissn = false;
	private boolean sourceessn = false;
	private boolean sourcevolisspag = false;

	private boolean correspondence = false;
	private boolean correspondenceAff = false;

	public ScopusSaxHandler() {
		if (currValue == null) {
			currValue = new StringBuilder();
		} else {
			currValue.setLength(0);
		}
		if (str0 == null) {
			str0 = new String();
		} else {
			str0 = "";
		}
		if (str1 == null) {
			str1 = new String();
		} else {
			str1 = "";
		}
		data = new ScopusXMLData();
		data.clear();
	}

	private static String nullCheck(String src, String defaultValue) {
		if (src == null) {
			return defaultValue;
		} else {
			return src.trim();
		}
	}

	private static String nullCheck(String src) {
		return nullCheck(src, "");
	}

	int authorCnt = 0;
	String authorCountry = "";
	String afid = null;

	// xocs:meta 0
	// xocs:eid 1
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		author_email = false;
		affiliation = false;
		aff_organization = false;
		if (qName.equalsIgnoreCase("xocs:meta")) {
			in_0 = true;
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("xocs:eid")) {
			in_1 = true;
		} else if (qName.equalsIgnoreCase("author-keywords")) {
			authorKeywords = true;
		} else if (qName.equalsIgnoreCase("citation-info")) {
			in_3 = true;
		} else if (qName.equalsIgnoreCase("head")) {
			in_4 = true;
		} else if (qName.equalsIgnoreCase("author-keyword")) {
			currValue.setLength(0);
			authorKeyword = true;
		} else if (qName.equalsIgnoreCase("titletext")) {
			currValue.setLength(0);
			in_6 = true;
		} else if (qName.equalsIgnoreCase("ce:para")) {
			currValue.setLength(0);
			in_7 = true;
		} else if (qName.equalsIgnoreCase("descriptors")) {
			// 2013-8-27 swsong 종류구분없이 키워드모두 추출하기로 함. scopus.com과 검색결과가 많이 차이나기
			// 때문.
			// str0 = attributes.getValue("type");
			// if ("CCV".equals(str0) || "FDE".equals(str0) ||
			// "ESD".equals(str0) || "MKW".equals(str0) || "PCV".equals(str0)) {
			indexKeyword = true;
			// }
			// str0 = "";
		} else if (qName.equalsIgnoreCase("mainterm")) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("author-group")) {
			afid = null;
			author_group = true;
			authorCnt = 0;
			authorGivenNameBuf.setLength(0);
			authorIndexNameBuf.setLength(0);
		} else if (qName.equalsIgnoreCase("preferred-name")) {
			in_10 = true;
		} else if (qName.equalsIgnoreCase("ce:indexed-name")) {
			in_11 = true;
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("ce:doi")) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("ce:surname") && in_10) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("ce:given-name") && in_10) {
			currValue.append(" ");
			in_13 = true;
		} else if (qName.equalsIgnoreCase("sourcetitle")) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("classifications")) {
			str0 = attributes.getValue("type");
			if ("ASJC".equals(str0)) {
				in_14 = true;
			} else {
				in_14 = false;
			}
			str0 = "";
		} else if (qName.equalsIgnoreCase("classification") && in_14) {
			in_15 = true;
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("affiliation") && author_group) {
			currValue.setLength(0);
			affOrgBuf.setLength(0);
			affiliation = true;
			authorCountry = nullCheck(attributes.getValue("country"), " ");
			afid = attributes.getValue("afid");
			data.setAffiliation_country(attributes.getValue("country"));
			data.setAfid(afid);
		} else if (qName.equalsIgnoreCase("source")) {
			currValue.setLength(0);
			data.setSource_country(nullCheck(attributes.getValue("country")).toUpperCase());
			data.setSource_type(nullCheck(attributes.getValue("type")));
			data.setSource_id(nullCheck(attributes.getValue("srcid")));
			source = true;
		} else if (qName.equalsIgnoreCase("volisspag")) {
			sourcevolisspag = true;
		} else if (qName.equalsIgnoreCase("voliss") && sourcevolisspag) {
			data.setSource_issue(nullCheck(attributes.getValue("issue")));
			data.setSource_volumn(nullCheck(attributes.getValue("volume")));
		} else if (qName.equalsIgnoreCase("pagerange") && sourcevolisspag) {
			data.setSource_page(nullCheck(attributes.getValue("first")) + "-" + nullCheck(attributes.getValue("last")));
		} else if (qName.equalsIgnoreCase("publicationdate")) {
			in_16 = true;
		} else if (qName.equalsIgnoreCase("year") && in_16) {
			in_17 = true;
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("reference")) {
			reference_TAG = true;
		} else if (qName.equalsIgnoreCase("itemid") && reference_TAG) {
			in_19 = true;
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("bibliography")) {
			data.setRefCount(nullCheck(attributes.getValue("refcount"), "0"));
		} else if (qName.equalsIgnoreCase("author") && author_group) {
			authorCnt += 1;
			author = true;
			str0 = attributes.getValue("seq");
			str1 = attributes.getValue("auid");
			if (str0 == null) {
				str0 = "";
			}
			if (str1 == null) {
				str1 = "";
			}
			data.setAuthorSeq(select(str0.trim(), data.getAuthorSeq()));
			data.setRanking(select(str0.trim(), data.getRanking()));
			data.setAuthorId(select(str1.trim(), data.getAuthorId()));
			str0 = "";
			str1 = "";
		} else if (qName.equalsIgnoreCase("ce:e-address")) {
			currValue.setLength(0);
			String email = nullCheck(attributes.getValue("type"));
			if ("email".equalsIgnoreCase(email)) {
				author_email = true;
			}
		} else if (qName.equalsIgnoreCase("count")) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("eid")) {
			currValue.setLength(0);
		} else if (qName.equalsIgnoreCase("citation-type")) {
			str0 = attributes.getValue("code");
			if (str0 == null) {
				str0 = "";
			}
			data.setCitType(str0.trim());
			str0 = "";
		} else if (qName.equalsIgnoreCase("correspondence")) {
			correspondence = true;
		} else if (correspondence && qName.equalsIgnoreCase("ce:e-address")) {
			currValue.setLength(0);
		} else if (correspondence && qName.equalsIgnoreCase("affiliation")) {
			String cn = attributes.getValue("country");
			if (cn != null) {
				data.setCorr_country(cn.toUpperCase());
			} else {
				data.setCorr_country(" ");
			}
		} else if (correspondence && qName.equalsIgnoreCase("organization")) {
			currValue.setLength(0);
			correspondenceAff = true;
		} else if (qName.equalsIgnoreCase("issn") && source) {
			currValue.setLength(0);
			String type = nullCheck(attributes.getValue("type"));
			// System.out.println("===> type " + type);
			// System.out.println(source);
			if (type.equalsIgnoreCase("print")) {
				sourceissn = true;
			} else if (type.equalsIgnoreCase("electronic")) {
				sourceessn = true;
			}
		}
		// System.out.println(qName + " source " + source);
	}

	private String select(String newVal, String prev) {
		if (newVal == null) {
			newVal = "";
		} else {
			newVal = newVal.trim();
		}

		if (newVal.length() > 0) {
			if (prev == null) {
				return newVal;
			} else {
				prev = prev.trim();
				if ("".equals(prev)) {
					return newVal;
				}
				return prev + multiValueDelimiter + newVal;
			}
		}

		return null;
	}

	public void characters(char[] ch, int start, int length) throws SAXException {
		currValue.append(ch, start, length);
	}

	StringBuffer affOrgBuf = new StringBuffer();
	StringBuffer authorGivenNameBuf = new StringBuffer();
	StringBuffer authorIndexNameBuf = new StringBuffer();

	public void endElement(String uri, String localName, String name) throws SAXException {

		if (name.equalsIgnoreCase("xocs:eid") && in_0) {
			data.setEid(currValue.toString().trim().substring(7));
			in_0 = false;
		} else if (name.equalsIgnoreCase("author-keywords") && authorKeywords) {
			authorKeywords = false;
		} else if (name.equalsIgnoreCase("author-keyword") && authorKeywords) {
			data.setKeyword(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("titletext") && in_6) {
			data.setTitle(select(currValue.toString().trim(), data.getTitle()));
			in_6 = false;
		} else if (name.equalsIgnoreCase("ce:para")) {
			data.setAbstractStr(select(currValue.toString().trim(), data.getAbstractStr()));
			in_7 = false;
		} else if (name.equalsIgnoreCase("mainterm") && indexKeyword) {
			data.setIndexKeyword(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("descriptors") && indexKeyword) {
			indexKeyword = false;
		} else if (name.equalsIgnoreCase("ce:indexed-name") && author_group && !in_10 && in_11) {
			data.setAuthorName(currValue.toString().trim());
			authorIndexNameBuf.append(currValue.toString().trim());
			authorIndexNameBuf.append("|");
//			System.out.println("--> ");
//			System.out.println(currValue.toString().trim());
//			currValue.setLength(0);
			in_11 = false;
		} else if (name.equalsIgnoreCase("preferred-name")) {
			in_10 = false;
		} else if (name.equalsIgnoreCase("organization") && author_group) {
			affOrgBuf.append(currValue);
			affOrgBuf.append(", ");
			currValue.setLength(0);
			aff_organization = false;
		} else if (name.equalsIgnoreCase("ce:doi")) {
			data.setDoi(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("ce:given-name") && in_10 && in_13) {
			data.setDelegateAuthorName(currValue.toString().trim());
			authorGivenNameBuf.append(currValue.toString().trim());
			authorGivenNameBuf.append("|");
			in_13 = false;
		} else if (name.equalsIgnoreCase("sourcetitle")) {
			data.setSource_sourceTitle(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("classification") && in_14 && in_15) {
			in_15 = false;
			data.setAsjcCode(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("year") && in_16 && in_17) {
			in_16 = false;
			in_17 = false;
			data.setPublicationYear(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("itemid") && reference_TAG && in_19) {
			reference_TAG = false;
			in_19 = false;
			// data.setRefEid(select(currValue.toString().trim(),
			// data.getRefEid()));

			data.setRefEid(currValue.toString().trim());
			currValue.setLength(0);
		} else if (name.equalsIgnoreCase("count")) {
			data.setCitCount(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("eid")) {
			String eids = currValue.toString().trim();
			data.setCitEid(eids.substring(eids.lastIndexOf("-") + 1));
			currValue.setLength(0);
			// data.setCitEid(select(currValue.toString().trim().substring(7),
			// data.getCitEid()));

		} else if (name.equalsIgnoreCase("ce:indexed-name") && correspondence) {
			data.setCorr_authorName(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("ce:e-address") && correspondence) {
			data.setCorr_email(currValue.toString().trim());
		} else if (name.equalsIgnoreCase("organization") && correspondenceAff) {
			data.setCorr_affilation(select(currValue.toString().trim(), data.getCorr_affilation()).replaceAll(";", ", "));
		} else if (name.equalsIgnoreCase("issn") && sourceissn) {
			data.setSource_pissn(currValue.toString().trim());
			sourceissn = false;
		} else if (name.equalsIgnoreCase("issn") && sourceessn) {
			data.setSource_eissn(currValue.toString().trim());
			sourceessn = false;
		} else if (name.equalsIgnoreCase("ce:e-address") && author_email) {
			String authorEmail = currValue.toString().trim();
			data.setAuthorEmail(authorEmail);
			author_email = true;
		} else if (name.equalsIgnoreCase("ce:indexed-name") && author_email) {
			data.setSource_eissn(currValue.toString().trim());
			sourceessn = false;
		} else if (name.equalsIgnoreCase("author-group")) {
			author_group = false;
			for (int idx = 0; idx < authorCnt; idx += 1) {
				data.setAuthorCountry(authorCountry);
			}
		} else if (name.equalsIgnoreCase("correspondence")) {
			correspondence = false;
			correspondenceAff = false;
		} else if (name.equalsIgnoreCase("source")) {
			source = false;
			sourcevolisspag = false;
		}

		if (name.equalsIgnoreCase("affiliation") && author_group) {
			if (affOrgBuf.length() > 2) {
				affOrgBuf.deleteCharAt(affOrgBuf.length() - 2);
			}

			data.setOrgName(affOrgBuf.toString());
			StringBuffer authorBuf = authorIndexNameBuf;
			if (authorBuf.length() > 0) {
				authorBuf.deleteCharAt(authorBuf.length() - 1);
			}
			String[] authorNames = authorBuf.toString().split("\\|");
			for (String authorName : authorNames) {
				data.setAuthorInfo(afid, authorName);
			}
		}
		if (author && name.equalsIgnoreCase("author")) {
			if (!author_email) {
				data.setAuthorEmail(" ");
			}
			author = false;
		}
		// System.out.println("END : " + name);
	}

	int cnt = 0;

}
