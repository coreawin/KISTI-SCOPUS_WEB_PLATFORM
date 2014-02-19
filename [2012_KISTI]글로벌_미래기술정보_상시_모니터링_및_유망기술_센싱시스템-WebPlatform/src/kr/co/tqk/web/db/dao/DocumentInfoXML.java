package kr.co.tqk.web.db.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.web.db.DescriptionCode;
import kr.co.tqk.web.db.bean.AffilationBean;
import kr.co.tqk.web.db.bean.AuthorBean;
import kr.co.tqk.web.db.bean.CorrespondAuthorBean;
import kr.co.tqk.web.db.bean.ReferenceBean;
import kr.co.tqk.web.db.bean.ScopusASJCBean;
import kr.co.tqk.web.db.bean.ScopusAuthorKeywordBean;
import kr.co.tqk.web.db.bean.ScopusDocumentBean;
import kr.co.tqk.web.db.bean.ScopusIndexKeywordBean;
import kr.co.tqk.web.db.bean.ScopusSourceInfoBean;
import kr.co.tqk.web.db.bean.export.ExportBean;
import kr.co.tqk.web.db.dao.xml.ScopusXMLData;
import kr.co.tqk.web.db.dao.xml.XMLSaxParser;
import kr.co.tqk.web.util.FastCatSearchUtil;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

public class DocumentInfoXML {
	String eid = null;
	String xml = null;
	String citxml = null;
	String searchURL = null;
	String collectionName = null;
	ScopusXMLData xmld = null;
	ExportBean exportBean = null;

	public DocumentInfoXML(String _eid, String searchURL, String collectionName) throws Exception {
		this.eid = _eid;
		this.searchURL = searchURL;
		this.collectionName = collectionName;
		this.search();
		this.parse();
	}

	private void parse() throws Exception {
		XMLSaxParser parser = XMLSaxParser.getInstance();
		try {
			this.xmld = parser.parse(xml);
			ScopusXMLData citXmld = parser.parse(citxml);
			this.exportBean = parser.convertExportBean(xmld, citXmld);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	private void search() throws Exception {
		JSONObject jsonobj = null;
		JSONArray resultArr = null;
		ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
		nvps.add(new BasicNameValuePair("cn", collectionName));
		nvps.add(new BasicNameValuePair("se", "{eid:" + this.eid + ":1:32}"));
		nvps.add(new BasicNameValuePair("fl", "xml, citxml"));
		nvps.add(new BasicNameValuePair("sn", "1"));
		nvps.add(new BasicNameValuePair("ln", String.valueOf(1)));
		nvps.add(new BasicNameValuePair("gr", ""));
		nvps.add(new BasicNameValuePair("ft", ""));
		nvps.add(new BasicNameValuePair("ht", ""));
		nvps.add(new BasicNameValuePair("ud", ""));
		nvps.add(new BasicNameValuePair("timeout", "10000"));
		jsonobj = FastCatSearchUtil.requestURL(this.searchURL, nvps);
		if (jsonobj == null) {
			throw new Exception("검색 엔진의 검색결과를 받아올 수 없습니다.");
		} else {
			int totalSize = 0;
			if (jsonobj.getInt("status") == 0) {
				try {
					totalSize = jsonobj.getInt("total_count");
					resultArr = jsonobj.getJSONArray("result");
					for (int i = 0; i < resultArr.length(); i++) {
						JSONObject jsonrecord = resultArr.getJSONObject(i);
						this.xml = jsonrecord.getString("xml");
						this.citxml = jsonrecord.getString("citxml");
					}
				} catch (Exception e) {
					e.printStackTrace();
					throw e;
				}
			}
		}
	}

	/**
	 * SCOPUS_DOCUMENT 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public ScopusDocumentBean getScopusDocument() {
		ScopusDocumentBean bean = new ScopusDocumentBean();
		bean.setEid(xmld.getEid());
		bean.setTitle(xmld.getTitle());
		bean.setAbs(xmld.getAbstractStr());
		bean.setPublicationYear(xmld.getPublicationYear());
		// bean.setPublicationMonth(xmld.get rs.getString("PUBLICATION_MONTH"));
		bean.setVolumn(xmld.getSource_volumn());
		bean.setIssue(xmld.getSource_issue());
		bean.setPage(xmld.getSource_page());
		bean.setSourceID(xmld.getSource_id());
		bean.setDOI(xmld.getDoi());
		String citType = xmld.getCitType();
		String ct = DescriptionCode.getCitationType().get(citType);
		if (ct == null) {
			ct = citType;
		}
		bean.setCitationType(ct);
		bean.setRefCount(Integer.parseInt(xmld.getRefCount()));
		bean.setCitCount(Integer.parseInt(xmld.getCitCount()));
		return bean;
	}

	/**
	 * 저자 키워드
	 * 
	 * @return
	 */
	public ScopusAuthorKeywordBean getScopusAuthorKeyword() {
		ScopusAuthorKeywordBean bean = new ScopusAuthorKeywordBean();
		Set<String> ks = xmld.getKeyword();
		for (String k : ks) {
			bean.addKeyword(k);
		}
		return bean;
	}

	/**
	 * 인덱스 키워드
	 * 
	 * @return
	 */
	public ScopusIndexKeywordBean getScopusIndexKeyword() {
		ScopusIndexKeywordBean bean = new ScopusIndexKeywordBean();
		Set<String> ks = xmld.getIndexKeyword();
		for (String k : ks) {
			bean.insertIndexKeyword("XML", k);
		}
		return bean;
	}

	/**
	 * 저자 키워드
	 * 
	 * @return
	 */
	public ScopusSourceInfoBean getScopusSourceInfo() {
		ScopusSourceInfoBean bean = DescriptionCode.getSourceInfo().get(xmld.getSource_id());
		if (bean == null) {
			bean = new ScopusSourceInfoBean();
			bean.setSourceID(xmld.getSource_id());
		}
		return bean;
	}

	/**
	 * 저자 키워드
	 * 
	 * @return
	 */
	public ScopusASJCBean getScopusASJC() {
		ScopusASJCBean bean = new ScopusASJCBean(this.eid);
		Set<String> ks = xmld.getAsjcCode();
		Map<String, String> asjcDesc = DescriptionCode.getAsjcTypeKoreaDescription();
		for (String k : ks) {
			bean.addAsjc(k, asjcDesc.get(k.trim()));
		}
		return bean;
	}

	/**
	 * 논문의 기관 및 국가, 저장 정보를 리턴한다.
	 * 
	 * @return
	 */
	public LinkedList<AffilationBean> getScopusAffilationAndAuthorInfo() {

//		Set<String> afidSet = xmld.getAfid();
//		xmld.getAuthorName()
//		Map<String, String> affMap = DescriptionCode.getAffiliationName();
//		for (String afid : afidSet) {
//			String afnames = null;
//			if (affMap.containsKey(afid)) {
//				String afname = null;
//				String cn = null;
//				afnames = affMap.get(afid);
//				String[] afnamess = afnames.split("\\|");
//				afname = afnamess [0];
//				if(afnamess.length>1){
//					cn = afnamess[1];
//				}
//			}
//
//		}
//
//		// ===========================================================================
		LinkedList<AffilationBean> affilationList = new LinkedList<AffilationBean>();
//		AffilationBean affilationBean = null;
//		AuthorBean authorBean = null;
//
//		Map<String, String> affNameMaps = DescriptionCode.getAffiliationName();
//
//		xmld.getAffiliation_country();
//		try {
//			// String query = "	select * " + "	from SCOPUS_AFFILATION_GROUP "
//			// + "	where EID = ? " + "	order by GROUP_SEQUENCE ";
//			// @MODIFY 정제된 기관명으로 수정 2012-08-16
//			String query = "" + " SELECT eid, ag.afid, group_sequence, dftid, org_name, ka.AFFILATION AS delegate_org_name, ka.COUNTRY_CODE"
//					+ " FROM SCOPUS_AFFILATION_GROUP ag, SCOPUS_KISTI_AFFILIATION ka" + " WHERE ag.afid = ka.afid and eid in (?)" + " ORDER BY group_sequence";
//
//			conn = cf.getConnection();
//			psmt = conn.prepareStatement(query);
//			psmt.setString(1, this.eid);
//			rs = psmt.executeQuery();
//			SortedMap<Integer, AffilationBean> tmpDataMap = new TreeMap<Integer, AffilationBean>();
//			while (rs.next()) {
//				affilationBean = new AffilationBean(rs.getString("EID"));
//				int gs = rs.getInt("GROUP_SEQUENCE");
//				affilationBean.setGroupSequence(gs);
//				affilationBean.setAfid(rs.getString("AFID"));
//				affilationBean.setDftid(rs.getString("DFTID"));
//				affilationBean.setOrgName(rs.getString("ORG_NAME"));
//				affilationBean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
//				affilationBean.setCountryCode(rs.getString("COUNTRY_CODE"));
//				tmpDataMap.put(gs, affilationBean);
//			}
//			query = "	select EID, authorGroup.GROUP_SEQUENCE, "
//					+ "	RANKING, AUTHOR.AUTHOR_SEQ, AUTHOR.AUTHOR_ID, AUTHOR_NAME, DELEGATE_AUTHOR_NAME, AUTHOR.EMAIL" + "	from "
//					+ "		SCOPUS_AUTHOR_GROUP authorGroup, " + "		SCOPUS_AUTHOR author" + "	 where " + "		authorGroup.AUTHOR_SEQ = author.AUTHOR_SEQ "
//					+ "		and EID=? " + "	order by authorGroup.GROUP_SEQUENCE ";
//
//			rs.close();
//			psmt.close();
//
//			psmt = conn.prepareStatement(query);
//			psmt.setString(1, this.eid);
//			rs = psmt.executeQuery();
//			while (rs.next()) {
//				int gs = rs.getInt("GROUP_SEQUENCE");
//				affilationBean = tmpDataMap.remove(gs);
//				if (affilationBean != null) {
//					authorBean = new AuthorBean();
//					authorBean.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
//					authorBean.setAuthorID(rs.getString("AUTHOR_ID"));
//					authorBean.setAuthorName(rs.getString("AUTHOR_NAME"));
//					authorBean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
//					authorBean.setEmail(rs.getString("EMAIL"));
//					authorBean.setRanking(rs.getInt("RANKING"));
//					affilationBean.addAuthor(authorBean);
//					tmpDataMap.put(gs, affilationBean);
//				}
//			}
//			for (AffilationBean e : tmpDataMap.values()) {
//				affilationList.add(e);
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		} finally {
//			cf.release(rs, psmt, conn);
//		}
		return affilationList;
	}

	/**
	 * SCOPUS_CORRESPOND_AUTHOR 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public CorrespondAuthorBean getScopusCorrespondAuthor() {
		CorrespondAuthorBean bean = new CorrespondAuthorBean();
		bean.setEid(xmld.getEid());
		bean.setOrganization(xmld.getCorr_affilation());
		bean.setCountryCode(xmld.getCorr_country());
		AuthorBean authorBean = new AuthorBean();
		authorBean.setAuthorName(xmld.getCorr_authorName());
		authorBean.setEmail(xmld.getCorr_email());
		authorBean.setCountryCode(xmld.getCorr_country());
		bean.setAuthor(authorBean);

		/*
		 * String id = xmld.getAuthorId(); String seq = xmld.getAuthorSeq();
		 * String name = exportBean.getAuthor_authorName(); String email =
		 * exportBean.getAuthor_email(); String[] ids = id.split(";"); String[]
		 * seqs = seq.split(";"); String[] names = name.split(";"); String[]
		 * emails = email.split(";"); for (int idx = 0; idx < id.length(); idx
		 * += 1) { String _id = ids[idx]; String _seq = seqs[idx]; String _name
		 * = names[idx]; String _email = emails[idx]; AuthorBean authorBean =
		 * new AuthorBean(); try {
		 * authorBean.setAuthorSeq(Integer.parseInt(_seq)); } catch
		 * (NumberFormatException e) { authorBean.setAuthorSeq(-1); }
		 * authorBean.setAuthorID(_id); authorBean.setAuthorName(_name);
		 * authorBean.setDelegateAuthorName(_name); authorBean.setEmail(_email);
		 * bean.setAuthor(authorBean); }
		 */
		return bean;
	}

	/**
	 * SCOPUS_REFERENCE 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public LinkedList<ReferenceBean> getScopusReference() {
		LinkedList<ReferenceBean> result = new LinkedList<ReferenceBean>();
		ReferenceBean bean = null;
		String query = "select * from SCOPUS_REFERENCE" + "	where EID = ? order by publication_year desc, title asc, text ASC";
//		try {
//			conn = cf.getConnection();
//			psmt = conn.prepareStatement(query);
//			psmt.setString(1, this.eid);
//			rs = psmt.executeQuery();
//			LinkedHashMap<String, ReferenceBean> refSet = new LinkedHashMap<String, ReferenceBean>();
//			while (rs.next()) {
//				bean = new ReferenceBean(this.eid);
//				bean.setRefEid(rs.getString("REF_EID"));
//				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
//				bean.setText(rs.getString("TEXT"));
//				bean.setTitle(rs.getString("TITLE"));
//				bean.setSourceTitle(rs.getString("SOURCE_TITLE"));
//				bean.setIssue(rs.getString("ISSUE"));
//				bean.setVolumn(rs.getString("VOLUMN"));
//				bean.setFirstPage(rs.getString("FIRSTPAGE"));
//				bean.setLastPage(rs.getString("LASTPAGE"));
//				refSet.put(bean.getRefEid(), bean);
//			}
//
//			if (refSet.size() > 0) {
//				LinkedList<ScopusDocumentBean> list = getScopusDocuments(conn, refSet.keySet());
//				Map<String, ScopusDocumentBean> maps = new HashMap<String, ScopusDocumentBean>();
//				for (ScopusDocumentBean sdBean : list) {
//					maps.put(sdBean.getEid(), sdBean);
//				}
//
//				for (ReferenceBean rb : refSet.values()) {
//					ScopusDocumentBean sdBean = maps.get(rb.getRefEid());
//					if (sdBean != null) {
//						rb.setDocumentBean(sdBean);
//					}
//					result.add(rb);
//				}
//			}
//
//			// for (String eid : refSet.keySet()) {
//			// ScopusDocumentBean sdBean = getScopusDocument(conn, eid);
//			// bean = refSet.get(eid);
//			// bean.setDocumentBean(sdBean);
//			// result.add(bean);
//			// }
//
//		} catch (SQLException e) {
//			e.printStackTrace();
//		} finally {
//			cf.release(rs, psmt, conn);
//		}

		return result;
	}

}
