package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.AffilationBean;
import kr.co.tqk.web.db.bean.AuthorBean;
import kr.co.tqk.web.db.bean.CorrespondAuthorBean;
import kr.co.tqk.web.db.bean.ReferenceBean;
import kr.co.tqk.web.db.bean.ScopusASJCBean;
import kr.co.tqk.web.db.bean.ScopusAuthorKeywordBean;
import kr.co.tqk.web.db.bean.ScopusDocumentBean;
import kr.co.tqk.web.db.bean.ScopusIndexKeywordBean;
import kr.co.tqk.web.db.bean.ScopusSourceInfoBean;
import kr.co.tqk.web.util.UtilSQL;

public class DocumentInfoDao {

	ConnectionFactory cf = ConnectionFactory.getInstance();
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	String eid = null;

	public DocumentInfoDao(String _eid) throws SQLException {
		this.eid = _eid;
	}

	/**
	 * SCOPUS_DOCUMENT 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public ScopusDocumentBean getScopusDocument() {
		ScopusDocumentBean bean = null;
		String query = "select * from SCOPUS_DOCUMENT where EID=? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ScopusDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setAbs(rs.getString("ABSTRACT"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setPublicationMonth(rs.getString("PUBLICATION_MONTH"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setPage(rs.getString("PAGE"));
				bean.setSourceID(rs.getString("SOURCE_ID"));
				bean.setDOI(rs.getString("DOI"));
				bean.setCitationType(rs.getString("CITATION_TYPE"));
				bean.setRefCount(rs.getInt("REF_COUNT"));
				bean.setCitCount(rs.getInt("CIT_COUNT"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * SCOPUS_DOCUMENT 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public ScopusDocumentBean getScopusDocument(Connection conn, String eid) {
		ScopusDocumentBean bean = null;
		String query = "select * from SCOPUS_DOCUMENT where EID=? ";
		try {
			psmt = conn.prepareStatement(query);
			psmt.setString(1, eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ScopusDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setAbs(rs.getString("ABSTRACT"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setPublicationMonth(rs.getString("PUBLICATION_MONTH"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setPage(rs.getString("PAGE"));
				bean.setSourceID(rs.getString("SOURCE_ID"));
				bean.setCitationType(rs.getString("CITATION_TYPE"));
				bean.setDOI(rs.getString("DOI"));
				bean.setRefCount(rs.getInt("REF_COUNT"));
				bean.setCitCount(rs.getInt("CIT_COUNT"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt);
		}
		return bean;
	}

	/**
	 * SCOPUS_DOCUMENT 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public LinkedList<ScopusDocumentBean> getScopusDocuments(Connection conn, Set<String> eids) {
		LinkedList<ScopusDocumentBean> beans = new LinkedList<ScopusDocumentBean>();
		String query = "select * from SCOPUS_DOCUMENT where EID in (%s)  ";
		try {
			psmt = conn.prepareStatement(UtilSQL.makeQuery(query, eids.size()));
			int idx = 1;
			for (String eid : eids) {
				psmt.setString(idx++, eid);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				ScopusDocumentBean bean = new ScopusDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setAbs(rs.getString("ABSTRACT"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setPublicationMonth(rs.getString("PUBLICATION_MONTH"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setPage(rs.getString("PAGE"));
				bean.setSourceID(rs.getString("SOURCE_ID"));
				bean.setCitationType(rs.getString("CITATION_TYPE"));
				bean.setDOI(rs.getString("DOI"));
				bean.setRefCount(rs.getInt("REF_COUNT"));
				bean.setCitCount(rs.getInt("CIT_COUNT"));
				beans.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt);
		}
		return beans;
	}

	/**
	 * 저자 키워드
	 * 
	 * @return
	 */
	public ScopusAuthorKeywordBean getScopusAuthorKeyword() {
		ScopusAuthorKeywordBean bean = new ScopusAuthorKeywordBean();
		String query = "select eid, keyword from SCOPUS_AUTHOR_KEYWORD where EID=? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean.addKeyword(rs.getString("KEYWORD"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
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
		String query = "select eid, type, keyword from SCOPUS_INDEX_KEYWORD where EID=? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			bean.setEid(this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean.insertIndexKeyword(rs.getString("type"), rs.getString("KEYWORD"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * 저자 키워드
	 * 
	 * @return
	 */
	public ScopusSourceInfoBean getScopusSourceInfo(String sourceID) {
		ScopusSourceInfoBean bean = new ScopusSourceInfoBean();
		String query = "select * from SCOPUS_SOURCE_INFO where SOURCE_ID = ? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, sourceID);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ScopusSourceInfoBean();
				bean.setSourceID(sourceID);
				bean.setTitle(rs.getString("SOURCE_TITLE"));
				bean.setPissn(rs.getString("P_ISSN"));
				bean.setEissn(rs.getString("E_ISSN"));
				bean.setType(rs.getString("SOURCE_TYPE"));
				bean.setPublisherName(rs.getString("PUBLISHER_NAME"));
				bean.setCountry(rs.getString("COUNTRY"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
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
		String query = "select eid, ca.asjc_code, description from SCOPUS_CLASSIFICATION_ASJC ca, SCOPUS_ASJC asjc "
				+ "	where ca.asjc_code = asjc.asjc_code and EID=? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean.addAsjc(rs.getString("asjc_code"), rs.getString("description"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * 논문의 기관 및 국가, 저장 정보를 리턴한다.
	 * 
	 * @return
	 */
	public LinkedList<AffilationBean> getScopusAffilationAndAuthorInfo() {
		LinkedList<AffilationBean> affilationList = new LinkedList<AffilationBean>();
		AffilationBean affilationBean = null;
		AuthorBean authorBean = null;

		try {
			// String query = "	select * " + "	from SCOPUS_AFFILATION_GROUP "
			// + "	where EID = ? " + "	order by GROUP_SEQUENCE ";
			// @MODIFY 정제된 기관명으로 수정 2012-08-16
			String query = ""
					+ " SELECT eid, ag.afid, group_sequence, dftid, org_name, ka.AFFILATION AS delegate_org_name, ka.COUNTRY_CODE"
					+ " FROM SCOPUS_AFFILATION_GROUP ag, SCOPUS_KISTI_AFFILIATION ka"
					+ " WHERE ag.afid = ka.afid and eid in (?)" + " ORDER BY group_sequence";

			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			SortedMap<Integer, AffilationBean> tmpDataMap = new TreeMap<Integer, AffilationBean>();
			while (rs.next()) {
				affilationBean = new AffilationBean(rs.getString("EID"));
				int gs = rs.getInt("GROUP_SEQUENCE");
				affilationBean.setGroupSequence(gs);
				affilationBean.setAfid(rs.getString("AFID"));
				affilationBean.setDftid(rs.getString("DFTID"));
				affilationBean.setOrgName(rs.getString("ORG_NAME"));
				affilationBean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
				affilationBean.setCountryCode(rs.getString("COUNTRY_CODE"));
				tmpDataMap.put(gs, affilationBean);
			}
			query = "	select EID, authorGroup.GROUP_SEQUENCE, "
					+ "	RANKING, AUTHOR.AUTHOR_SEQ, AUTHOR.AUTHOR_ID, AUTHOR_NAME, DELEGATE_AUTHOR_NAME, AUTHOR.EMAIL"
					+ "	from " + "		SCOPUS_AUTHOR_GROUP authorGroup, " + "		SCOPUS_AUTHOR author" + "	 where "
					+ "		authorGroup.AUTHOR_SEQ = author.AUTHOR_SEQ " + "		and EID=? "
					+ "	order by authorGroup.GROUP_SEQUENCE ";

			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				int gs = rs.getInt("GROUP_SEQUENCE");
				affilationBean = tmpDataMap.remove(gs);
				if (affilationBean != null) {
					authorBean = new AuthorBean();
					authorBean.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
					authorBean.setAuthorID(rs.getString("AUTHOR_ID"));
					authorBean.setAuthorName(rs.getString("AUTHOR_NAME"));
					authorBean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
					authorBean.setEmail(rs.getString("EMAIL"));
					authorBean.setRanking(rs.getInt("RANKING"));
					affilationBean.addAuthor(authorBean);
					tmpDataMap.put(gs, affilationBean);
				}
			}
			for (AffilationBean e : tmpDataMap.values()) {
				affilationList.add(e);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return affilationList;
	}

	/**
	 * SCOPUS_CORRESPOND_AUTHOR 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public CorrespondAuthorBean getScopusCorrespondAuthor() {
		CorrespondAuthorBean bean = null;
		AuthorBean authorBean = null;
		String query = "select ca.eid, ca.author_seq, ca.organization, ca.email, ca.country_code, author_id, author_name, delegate_author_name"
				+ "	from SCOPUS_CORRESPOND_AUTHOR ca, SCOPUS_AUTHOR a"
				+ "	where "
				+ "	ca.author_seq = a.author_seq"
				+ "	and EID=? ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new CorrespondAuthorBean();
				bean.setEid(rs.getString("EID"));
				bean.setOrganization(rs.getString("organization"));
				bean.setCountryCode(rs.getString("COUNTRY_CODE"));
				authorBean = new AuthorBean();
				authorBean.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
				authorBean.setAuthorID(rs.getString("AUTHOR_ID"));
				authorBean.setAuthorName(rs.getString("AUTHOR_NAME"));
				authorBean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
				authorBean.setEmail(rs.getString("EMAIL"));
				bean.setAuthor(authorBean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
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
		String query = "select * " + "	from SCOPUS_REFERENCE"
				+ "	where EID = ? order by  title asc, text ASC, publication_year desc ";
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, this.eid);
			rs = psmt.executeQuery();
			LinkedHashMap<String, ReferenceBean> refSet = new LinkedHashMap<String, ReferenceBean>();
			while (rs.next()) {
				bean = new ReferenceBean(this.eid);
				bean.setRefEid(rs.getString("REF_EID"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setText(rs.getString("TEXT"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setSourceTitle(rs.getString("SOURCE_TITLE"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setFirstPage(rs.getString("FIRSTPAGE"));
				bean.setLastPage(rs.getString("LASTPAGE"));
				refSet.put(bean.getRefEid(), bean);
			}

			if(refSet.size() > 0){
				LinkedList<ScopusDocumentBean> list = getScopusDocuments(conn, refSet.keySet());
				for(ScopusDocumentBean sdBean : list){
					bean = refSet.get(sdBean.getEid());
					bean.setDocumentBean(sdBean);
					result.add(bean);
				}
			}
//			for (String eid : refSet.keySet()) {
//				ScopusDocumentBean sdBean = getScopusDocument(conn, eid);
//				bean = refSet.get(eid);
//				bean.setDocumentBean(sdBean);
//				result.add(bean);
//			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

}
