package kr.co.tqk.web.db.dao.export;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;

import kr.co.tqk.web.db.bean.export.ExportBean;
import kr.co.tqk.web.util.UtilString;

/**
 * @author coreawin
 * @since
 * @modify 2012.07.18 where절의 = 쿼리를 in 쿼리로 변경
 * 
 */
public class ExportDao {

	public static final int CLUSTER_DATA_EXPORT = 1;
	public static final int DATA_EXPORT = 100;

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	LinkedHashSet<String> eidSet = null;
	LinkedHashMap<String, ExportBean> exportList = null;
	StringBuffer query = new StringBuffer();
	HashMap<ExportField, Boolean> exportField = null;

	static final String DATA_DELIM = ";";

	/**
	 * 임시 변수용
	 */
	StringBuffer tmpSB = new StringBuffer();
	StringBuffer tmpSB2 = new StringBuffer();
	ExportBean bean = null;

	public ExportDao(Connection conn, LinkedHashSet<String> eidSet, HashMap<ExportField, Boolean> exportField) {
		this(conn, eidSet, exportField, DATA_EXPORT);
	}

	/**
	 * 정보분석 플랫폼에서 데이터를 다운로드 하기 위해서 DB로부터 데이터를 수집하는 클래스이다.
	 * 
	 * @param conn
	 *            DB 커넥션
	 * @param eidSet
	 *            데이터를 다운로드할 문서 ID set
	 * @param exportField
	 *            정보분석 플랫폼에서 선택한 export할 데이터.
	 * @param type
	 *            클러스터 분석 데이터인지, 엑셀 포맷의 분석 데이터인지 다운도르될 데이터의 유형 <BR>
	 * @see ExportDao.CLUSTER_DATA_EXPORT, ExportDao.DATA_EXPORT
	 */
	public ExportDao(Connection conn, LinkedHashSet<String> eidSet, HashMap<ExportField, Boolean> exportField, int type) {
		this.conn = conn;
		this.eidSet = eidSet;
		this.exportField = exportField;
		exportList = new LinkedHashMap<String, ExportBean>();
		try {
			if (type == CLUSTER_DATA_EXPORT) {
				getClusterDocumentData();
			} else {
				getDocumentData();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 계량 분석을 위한 Export 데이터 가져오기.
	 * 
	 * @param conn
	 *            DB 커넥션
	 * @param eidSet
	 *            데이터를 다운로드할 문서 ID set
	 */
	public ExportDao(Connection conn, LinkedHashSet<String> eidSet) {
		this.conn = conn;
		this.eidSet = eidSet;
		exportList = new LinkedHashMap<String, ExportBean>();
		try {
			getAnalysisDocumentData();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private void getClusterDocumentData() throws SQLException {
		getReferenceCitationList();
	}

	/**
	 * 계량 분석시 필요한 데이터만 가져온다.<br>
	 * 
	 * @throws SQLException
	 * @deprecated
	 */
	private void getAnalysisDocumentData() throws SQLException {
		getDocumentBasicInfoNCorrAuthorInfo();
		getCitationList();
		getASJCInfo();
		getAffiliationInfo();
	}

	private void getDocumentData() throws SQLException {
		getDocumentBasicInfoNCorrAuthorInfo();
		if (exportField.get(ExportField.KEYWORD)) {
			getAuthorKeywordInfo();
		}
		if (exportField.get(ExportField.INDEX_KEYWORD)) {
			getIndexKeywordInfo();
		}
		if (exportField.get(ExportField.REFERENCE)) {
			getReferenceList();
		}

		if (exportField.get(ExportField.CITATION)) {
			getCitationList();
		}
		if (exportField.get(ExportField.ASJC)) {
			getASJCInfo();
		}

		if (exportField.get(ExportField.AUTHOR_AUTHORINFO)) {
			getAuthorAffilationCountryInfo();
		}

		if (exportField.get(ExportField.AUTHOR_NAME)) {
			getAuthorNameInfo();
		}
		if (exportField.get(ExportField.AUTHOR_EMAIL)) {
			getAuthorEmailInfo();
		}
		if (exportField.get(ExportField.AUTHOR_COUNTRYCODE)) {
			getAuthorCountryInfo();
		}
		if (exportField.get(ExportField.AFFILIATION_NAME) || exportField.get(ExportField.AFFILIATION_COUNTRY)) {
			getAffiliationInfo();
			// getAuthorAffiliationInfo();
		}

	}

	/**
	 * 저자 기관정보를 가져온다. (저자순서대로 가져온다.) AUTHOR_AUTHORINFO 필드로 대체한다. 2012-09-22
	 */
	private void getAuthorAffiliationInfo() {
		// TODO Auto-generated method stub
		if (true) {
			return;
		}
		// SELECT eid, REPLACE(REPLACE(MAX(dbms_lob.substr(affilation, 4000,
		// 1)), 'null'),',',';') AS affilation
		// FROM
		// (
		// SELECT ag.eid, wm_concat(affilation) OVER(PARTITION BY ag.eid ORDER
		// BY TO_NUMBER(NVL(ranking, 1000))) AS affilation
		// FROM SCOPUS_AUTHOR_GROUP ag, SCOPUS_AFFILATION_GROUP a,
		// SCOPUS_KISTI_AFFILIATION ka
		// WHERE ag.eid = a.eid and a.afid = ka.afid and ag.eid IN
		// ('84860478142', '20044366163')
		// )
		// GROUP BY eid;
	}

	/**
	 * 각저자의 국가 정보를 가져온다. (저자순서대로 가져온다.)
	 * 
	 * @throws SQLException
	 */
	private void getAuthorCountryInfo() throws SQLException {
		query.setLength(0);
		query.append(" SELECT eid, REPLACE(REPLACE(MAX(dbms_lob.substr(country_code, 4000, 1)), 'null'),',',';') AS country_code ");
		query.append(" FROM ");
		query.append(" ( ");
		query.append("		SELECT eid, wm_concat(country_code) OVER(PARTITION BY  eid ORDER BY TO_NUMBER(NVL(ranking, 1000))) AS country_code FROM (  ");
		query.append(" 			SELECT DISTINCT ag.eid, ranking, author_seq, country_code ");
		query.append(" 			FROM (SELECT DISTINCT author_seq, ranking, eid, group_sequence FROM SCOPUS_AUTHOR_GROUP WHERE eid IN (%s)) ag, ");
		query.append(" 				(SELECT * FROM SCOPUS_AFFILATION_GROUP WHERE eid IN (%s))  a ");
		query.append(" 			WHERE ag.eid = a.eid and ag.GROUP_SEQUENCE = a.GROUP_SEQUENCE ");
		query.append(" 		)");
		query.append(" )");
		query.append(" GROUP BY eid");

		try {
			String sql = null;
			try {
				sql = String.format(query.toString(), preparePlaceHolders(eidSet.size()), preparePlaceHolders(eidSet.size()));
			} catch (RuntimeException re) {
				re.printStackTrace();
				return;
			}
			psmt = conn.prepareStatement(sql);
			int cnt = 1;
			for (String eid : eidSet) {
				psmt.setObject(cnt++, eid);
			}
			for (String eid : eidSet) {
				psmt.setObject(cnt++, eid);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				String eid = rs.getString("eid");
				String country = rs.getString("country_code");
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAuthor_country(country);
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}

	}

	/**
	 * 저자 이메일정보를 가져온다. (저자순서대로 가져온다.)
	 */
	private void getAuthorEmailInfo() throws SQLException {
		query.setLength(0);
		query.append(" SELECT eid, REPLACE(REPLACE(MAX(dbms_lob.substr(email, 4000, 1)), 'null'),',',';') AS email ");
		query.append(" FROM ");
		query.append(" ( ");
		query.append(" SELECT  eid, wm_concat(email) OVER(PARTITION BY  eid ORDER BY TO_NUMBER(NVL(ranking, 1000))) AS email");
		query.append(" FROM (SELECT DISTINCT author_seq, ranking, eid FROM SCOPUS_AUTHOR_GROUP) ag, SCOPUS_AUTHOR a ");
		query.append(" WHERE ag.AUTHOR_SEQ = a.AUTHOR_SEQ  and eid IN (%s)");
		query.append(" )");
		query.append(" GROUP BY eid");

		try {
			String sql = null;
			try {
				sql = String.format(query.toString(), preparePlaceHolders(eidSet.size()));
			} catch (RuntimeException re) {
				return;
			}
			psmt = conn.prepareStatement(sql);
			int cnt = 1;
			for (String eid : eidSet) {
				psmt.setObject(cnt++, eid);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				String eid = rs.getString("eid");
				String email = rs.getString("email");
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAuthor_email(email);
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * 저자 이름정보를 가져온다. (저자순서대로 가져온다.)
	 * 
	 * @throws SQLException
	 */
	private void getAuthorNameInfo() throws SQLException {
		query.setLength(0);
		query.append(" SELECT eid, REPLACE(REPLACE(MAX(dbms_lob.substr(author_name, 4000, 1)), 'null'),',',';') AS author_name ");
		query.append(" FROM ");
		query.append(" ( ");
		query.append(" SELECT  eid, wm_concat(author_name) OVER(PARTITION BY  eid ORDER BY TO_NUMBER(NVL(ranking, 10000))) AS author_name");
		query.append(" FROM (SELECT DISTINCT author_seq, ranking, eid FROM SCOPUS_AUTHOR_GROUP) ag, SCOPUS_AUTHOR a ");
		query.append(" WHERE ag.AUTHOR_SEQ = a.AUTHOR_SEQ  and eid IN (%s)");
		query.append(" )");
		query.append(" GROUP BY eid");

		try {
			String sql = null;
			try {
				sql = String.format(query.toString(), preparePlaceHolders(eidSet.size()));
			} catch (RuntimeException re) {
				return;
			}
			psmt = conn.prepareStatement(sql);
			int cnt = 1;
			for (String eid : eidSet) {
				psmt.setObject(cnt++, eid);
			}

			rs = psmt.executeQuery();
			while (rs.next()) {
				String eid = rs.getString("eid");
				String author_name = rs.getString("author_name");
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAuthor_authorName(author_name);
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	private void getAuthorAffilationCountryInfo() throws SQLException {
		query.setLength(0);
		query.append("	SELECT  ag.eid, ag.afid, ag.org_name, COUNTRY_CODE, wm_concat(AUTHOR_NAME) author_name, ");
		query.append("			(SELECT affilation FROM SCOPUS_KISTI_AFFILIATION s WHERE s.afid = ag.afid) AS affiliation,");
		query.append("			(SELECT country_code FROM SCOPUS_KISTI_AFFILIATION s WHERE s.afid = ag.afid) AS country");
		query.append("	FROM");
		query.append("		SCOPUS_AFFILATION_GROUP ag, ");
		query.append("		SCOPUS_AUTHOR_GROUP aug, ");
		query.append("		SCOPUS_AUTHOR au ");
		query.append("	where ag.EID = aug.EID and ag.GROUP_SEQUENCE = aug.GROUP_SEQUENCE and aug.AUTHOR_SEQ = au.author_seq");
		query.append("	AND AG.EID in (%s)  ");
		query.append("	GROUP BY ag.ORG_NAME, ag.afid, COUNTRY_CODE, ag.eid  ");
		try {
			System.out.println("EID SIZE = " + eidSet.size());
			String sql = null;
			try {
				sql = String.format(query.toString(), preparePlaceHolders(eidSet.size()));
			} catch (RuntimeException re) {
				return;
			}
			psmt = conn.prepareStatement(sql);
			int cnt = 1;
			for (String eid : eidSet) {
				psmt.setObject(cnt++, eid);
			}
			rs = psmt.executeQuery();
			tmpSB.setLength(0);
			while (rs.next()) {
				String eid = UtilString.nullCkeck(rs.getString("eid"), true);
				String afid = UtilString.nullCkeck(rs.getString("afid"), true);
				String affiliation = UtilString.nullCkeck(rs.getString("affiliation"), true);
				String country = UtilString.nullCkeck(rs.getString("country"), true);
				String countryCode = UtilString.nullCkeck(rs.getString("COUNTRY_CODE"), true);
				// String org_name =
				// UtilString.nullCkeck(rs.getString("org_name"), true);
				// String countryCode =
				// UtilString.nullCkeck(rs.getString("COUNTRY_CODE"), true);
				String author_name = UtilString.nullCkeck(rs.getString("author_name"), true);
				tmpSB.append(author_name);
				tmpSB.append("(");
				tmpSB.append(affiliation);
				tmpSB.append(")_");
				tmpSB.append("".equals(country) ? countryCode : country);
				tmpSB.append(DATA_DELIM);
				try {
					bean = exportList.get(eid);
					if (bean == null)
						bean = new ExportBean(eid, this.exportField);
					String existInfo = bean.getAuthor_affilation_info();
					if (existInfo != null) {
						tmpSB.append(existInfo);
					}
					bean.setAuthor_affilation_info(UtilString.nullCkeck(tmpSB.toString()));
					exportList.put(eid, bean);
					// System.err.println(eid +"\t" +
					// bean.getAuthor_affilation_info());
					bean = null;
				} catch (NullPointerException ne) {
					System.out.println(eid + "\t");
					System.out.println("\t\t" + tmpSB.toString());
					throw ne;
				} finally {
					tmpSB.setLength(0);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	private void getIndexKeywordInfo() throws SQLException {
		query.setLength(0);
		query.append(" select keyword from SCOPUS_INDEX_KEYWORD where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String keyword = rs.getString("keyword");
					tmpSB.append(keyword);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setIndexKeyword(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * 기관정보만 배치한다.
	 * 
	 * @throws SQLException
	 */
	private void getAffiliationInfo() throws SQLException {
		query.setLength(0);
		query.append(" select org_name, country_code, delegate_org_name from scopus_affilation_group ag");
		query.append(" where eid in (?) ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				tmpSB2.setLength(0);
				while (rs.next()) {
					String org_name = UtilString.nullCkeck(rs.getString("org_name"), true);
					tmpSB.append(org_name);
					tmpSB.append(DATA_DELIM);

					String country_code = UtilString.nullCkeck(rs.getString("country_code"), true);
					tmpSB2.append(country_code);
					tmpSB2.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAuthor_affilation(tmpSB.length() > 0 ? tmpSB.substring(0, tmpSB.length() - 1) : "");
				bean.setAffiliation_country(tmpSB2.length() > 0 ? tmpSB2.substring(0, tmpSB2.length() - 1) : "");
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	private void getASJCInfo() throws SQLException {
		query.setLength(0);
		query.append(" select asjc_code from scopus_classification_asjc where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String asjc_code = rs.getString("asjc_code");
					tmpSB.append(asjc_code);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAsjcCode(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}

	}

	/**
	 * Reference 테이블에서 데이터를 가져온다.
	 * 
	 * @throws SQLException
	 */
	private void getReferenceList() throws SQLException {
		query.setLength(0);
		query.append(" select ref_eid from scopus_reference where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String ref_eid = rs.getString("ref_eid");
					tmpSB.append(ref_eid);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setReferenceList(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * Citation 테이블에서 데이터를 가져온다.
	 * 
	 * @throws SQLException
	 */
	private void getCitationList() throws SQLException {
		query.setLength(0);
		query.append(" select cit_eid from scopus_citation where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String cit_eid = rs.getString("cit_eid");
					tmpSB.append(cit_eid);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setCitationList(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * 인용정보와 참조정보를 가져온다.<br>
	 * 약어는 R-reference, C-citation <br>
	 * 클러스터 분석용 데이터를 생성한다.
	 * 
	 * @throws SQLException
	 */
	private void getReferenceCitationList() throws SQLException {
		query.setLength(0);
		query.append(" select ref_eid as rceid, 'R' as type from scopus_reference where eid = ? ");
		query.append(" union all ");
		query.append(" select cit_eid as rceid, 'C' as type  from scopus_citation where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				psmt.setString(2, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String rceid = rs.getString("rceid");
					String type = rs.getString("type");
					tmpSB.append(rceid);
					tmpSB.append(",");
					tmpSB.append(type);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setRefCitList(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	private void getAuthorKeywordInfo() throws SQLException {
		query.setLength(0);
		query.append(" select keyword from scopus_author_keyword where eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				tmpSB.setLength(0);
				while (rs.next()) {
					String keyword = rs.getString("keyword");
					tmpSB.append(keyword);
					tmpSB.append(DATA_DELIM);
				}
				bean = exportList.get(eid);
				if (bean == null)
					bean = new ExportBean(eid, this.exportField);
				bean.setAuthorKeyword(tmpSB.toString());
				exportList.put(eid, bean);
				bean = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * getDocumentBasicInfoNCorrAuthorInfo()에서 교신저자 정보 추출
	 * 
	 * @throws SQLException
	 */
	private void getCorrespondAuthor() throws SQLException {
		query.setLength(0);
		query.append(" select /*+ use_nl(ca) use_nl(sa) */ eid, organization, ca.email, ca.country_code, author_name ");
		query.append(" from scopus_correspond_author ca, scopus_author sa");
		query.append(" where ca.author_seq = sa.author_seq AND eid = ? ");
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				while (rs.next()) {
					String organization = rs.getString("organization");
					String email = rs.getString("email");
					String country_code = rs.getString("country_code");
					String author_name = rs.getString("author_name");
					bean = exportList.get(eid);
					if (bean == null)
						bean = new ExportBean(eid, this.exportField);
					bean.setCorr_affilation(organization);
					bean.setCorr_authorName(author_name);
					bean.setCorr_country(country_code);
					bean.setCorr_email(email);
					exportList.put(eid, bean);
					bean = null;
					break;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * 문서 기본정보를 가져온다.
	 * 
	 * @throws SQLException
	 */
	private void getDocumentBasicInfoNCorrAuthorInfo() throws SQLException {
		query.setLength(0);
		query.append(" select /*+ use_nl(sd) use_nl(sr) use_nl(ca) use_nl(au) */ ");
		query.append(" sd.eid, title, abstract, publication_year, volumn, issue, page, sd.source_id, doi, ref_count, CITATION_TYPE, cit_count, ");
		query.append(" source_title, p_issn, e_issn, source_type, publisher_name, sr.country, ");
		query.append(" author_id, author_name, ca.organization, ca.email, ca.country_code ");
		query.append(" from SCOPUS_DOCUMENT sd, SCOPUS_SOURCE_INFO sr, SCOPUS_CORRESPOND_AUTHOR ca, SCOPUS_AUTHOR au ");
		query.append(" where sd.source_id = sr.source_id(+) and sd.eid = ca.eid(+) and ca.author_seq = au.author_seq(+) and sd.eid=? ");

		boolean extractCorrespondAuthorInfo = false;
		if (exportField.get(ExportField.CORR_AUTHORNAME) || exportField.get(ExportField.CORR_AFFILIATION) || exportField.get(ExportField.CORR_COUNTRYCODE)
				|| exportField.get(ExportField.CORR_EMAIL)) {
			extractCorrespondAuthorInfo = true;
		}
		try {
			psmt = conn.prepareStatement(query.toString());
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				while (rs.next()) {
					bean = new ExportBean(rs.getString("EID"), this.exportField);
					bean.setTitle(rs.getString("TITLE"));
					bean.setAbstractTitle(rs.getString("abstract"));
					bean.setYear(rs.getString("publication_year"));
					bean.setSource_volumn(rs.getString("volumn"));
					bean.setSource_issue(rs.getString("issue"));
					bean.setSource_page(rs.getString("page"));
					bean.setDoi(rs.getString("doi"));
					bean.setNumberOfReference(rs.getInt("ref_count"));
					bean.setNumberOfCitation(rs.getInt("cit_count"));
					bean.setSource_sourceTitle(rs.getString("source_title"));
					bean.setSource_pissn(rs.getString("p_issn"));
					bean.setSource_eissn(rs.getString("e_issn"));
					bean.setSource_type(rs.getString("source_type"));
					bean.setSource_publisher(rs.getString("publisher_name"));
					bean.setSource_country(rs.getString("country"));
					bean.setCitation_type(rs.getString("CITATION_TYPE"));
					if (extractCorrespondAuthorInfo) {
						bean.setCorr_authorName(rs.getString("author_name"));
						bean.setCorr_affilation(rs.getString("organization"));
						bean.setCorr_email(rs.getString("email"));
						bean.setCorr_country(rs.getString("country_code"));
						exportList.put(bean.getEid(), bean);
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * Db에서 생성한 데이터를 가져온다.
	 * 
	 * @return
	 */
	public LinkedList<ExportBean> getExportData() {
		LinkedList<ExportBean> result = new LinkedList<ExportBean>();
		for (ExportBean eb : exportList.values()) {
			result.add(eb);
		}
		exportList = null;
		return result;
	}

	/**
	 * @param length
	 * @return
	 */
	private static String preparePlaceHolders(int length) {
		if (length < 1) {
			throw new RuntimeException("잘못된 값이 들어왔습니다." + length);
		}
		StringBuilder builder = new StringBuilder(length * 2 - 1);
		for (int i = 0; i < length; i++) {
			if (i > 0)
				builder.append(',');
			builder.append('?');
		}
		return builder.toString();
	}

	public static void main(String[] args) throws Exception {
		StringBuffer query = new StringBuffer();
		query.setLength(0);
		query.append(" SELECT eid, REPLACE(REPLACE(MAX(dbms_lob.substr(country_code, 4000, 1)), 'null'),',',';') AS country_code ");
		query.append(" FROM ");
		query.append(" ( ");
		query.append("		SELECT eid, wm_concat(country_code) OVER(PARTITION BY  eid ORDER BY TO_NUMBER(NVL(ranking, 1000))) AS country_code FROM (  ");
		query.append(" 			SELECT DISTINCT ag.eid, ranking, author_seq, country_code ");
		query.append(" 			FROM (SELECT DISTINCT author_seq, ranking, eid, group_sequence FROM SCOPUS_AUTHOR_GROUP WHERE eid IN (%s)) ag, ");
		query.append(" 				(SELECT * FROM SCOPUS_AFFILATION_GROUP WHERE eid IN (%s))  a ");
		query.append(" 			WHERE ag.eid = a.eid and ag.GROUP_SEQUENCE = a.GROUP_SEQUENCE ");
		query.append(" 		)");
		query.append(" )");
		query.append(" GROUP BY eid");

		LinkedHashSet<String> eidSet = new LinkedHashSet<String>();
		eidSet.add("33744965979");
		eidSet.add("84855495627");
		eidSet.add("84855205387");
		String sql = String.format(query.toString(), preparePlaceHolders(eidSet.size()), preparePlaceHolders(eidSet.size()));
		;
		// System.out.println(sql);

		// ConnectionFactory cf = ConnectionFactory.getInstance();
		// HashMap<String, Boolean> exportSet = new HashMap<String, Boolean>();
		// exportSet.put("KEYWORD", true);
		// exportSet.put("INDEX_KEYWORD", true);
		// exportSet.put("REFERENCE", true);
		// exportSet.put("CITATION", true);
		// exportSet.put("ASJC", true);
		// exportSet.put("AUTHOR_AUTHORNAME", true);
		// exportSet.put("AUTHOR_EMAIL", true);
		// exportSet.put("AUTHOR_COUNTRYCODE", true);
		// exportSet.put("AUTHOR_AFFILIATION", true);
		// exportSet.put("CORR_AUTHORNAME", true);
		// exportSet.put("CORR_COUNTRYCODE", true);
		// exportSet.put("CORR_EMAIL", true);
		// exportSet.put("CORR_AFFILIATION", true);
		// new ExportDao(cf.getConnection(), eidSet, exportSet);
	}

}
