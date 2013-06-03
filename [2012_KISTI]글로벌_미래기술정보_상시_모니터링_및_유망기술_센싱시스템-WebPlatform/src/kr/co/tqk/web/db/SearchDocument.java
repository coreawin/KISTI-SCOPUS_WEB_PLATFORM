package kr.co.tqk.web.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Set;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.MakeSearchRule;
import kr.co.tqk.web.db.bean.AuthorBean;
import kr.co.tqk.web.db.bean.AuthorSearchResultBean;
import kr.co.tqk.web.db.bean.SearchResultDocumentBean;
import kr.co.tqk.web.util.UtilString;

/**
 * 논문을 검색한다.<br>
 * 
 * @author 정승한
 * 
 */
public class SearchDocument {

	private static int totalSearchResultCount = 0;

	/**
	 * 검색식을 통해 논문을 검색한다.
	 * 
	 * @param searchRule
	 *            검색식.
	 * @param currentPage
	 *            현재 페이지 번호
	 * @param viewDataCount
	 *            한 화면에 보여질 데이터 개수
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<SearchResultDocumentBean> search(
			String searchRule, int currentPage, int viewDataCount)
			throws SQLException {
		LinkedList<SearchResultDocumentBean> result = null;
		if (searchRule.startsWith("CITL")) {
			// 인용문건 검색.
			result = searchCitationDocument(searchRule
					.replaceAll("CITL\\(", "").replaceAll("\\)", ""),
					currentPage, viewDataCount);
		} else if (searchRule.startsWith("REFL")) {
			// 인용문건 검색.
			result = searchReferenceDocument(
					searchRule.replaceAll("REFL\\(", "").replaceAll("\\)", ""),
					currentPage, viewDataCount);
		} else if (searchRule.startsWith("EIDL")) {
			// 고유 아이디로 문건 검색.
			result = searchDocument(
					MakeSearchRule.makeGetEIDQuery(searchRule.replaceAll(
							"EIDL\\(", "").replaceAll("\\)", "")), currentPage,
					viewDataCount);
		} else {
			result = searchDocument(MakeSearchRule.makeSearchQuery(searchRule),
					currentPage, viewDataCount);
		}
		return result;
	}
	
	/**
	 * 검색식을 통해 논문을 검색한다.
	 * 
	 * @param searchRule
	 *            검색식.
	 * @param currentPage
	 *            현재 페이지 번호
	 * @param viewDataCount
	 *            한 화면에 보여질 데이터 개수
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<SearchResultDocumentBean> search(
			String searchRule, String searchTerm, int currentPage, int viewDataCount)
			throws SQLException {
		LinkedList<SearchResultDocumentBean> result = null;
		if (searchRule.startsWith("CITL")) {
			// 인용문건 검색.
			result = searchCitationDocument(searchRule
					.replaceAll("CITL\\(", "").replaceAll("\\)", ""),
					currentPage, viewDataCount);
		} else if (searchRule.startsWith("REFL")) {
			// 인용문건 검색.
			result = searchReferenceDocument(
					searchRule.replaceAll("REFL\\(", "").replaceAll("\\)", ""),
					currentPage, viewDataCount);
		} else if (searchRule.startsWith("EIDL")) {
			// 고유 아이디로 문건 검색.
			result = searchDocument(
					MakeSearchRule.makeGetEIDQuery(searchRule.replaceAll(
							"EIDL\\(", "").replaceAll("\\)", "")), currentPage,
							viewDataCount);
		} else {
			result = searchDocument(MakeSearchRule.makeSearchQuery(searchRule),searchTerm,
					currentPage, viewDataCount);
		}
		return result;
	}

	private static LinkedList<SearchResultDocumentBean> searchDocument(
			String[] querys, String searchTerm, int currentPage,
			int viewDataCount) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		LinkedList<SearchResultDocumentBean> result = new LinkedList<SearchResultDocumentBean>();
		HashMap<String, SearchResultDocumentBean> tmpMap = new HashMap<String, SearchResultDocumentBean>();
		SearchResultDocumentBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(querys[0]);
			psmt.setString(1, searchTerm);
			rs = psmt.executeQuery();
			while (rs.next()) {
				setTotalSearchResultCount(rs.getInt(1));
			}
			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(querys[1]);
			psmt.setString(1, searchTerm);
			psmt.setInt(2, (currentPage * viewDataCount));
			psmt.setInt(3, (currentPage - 1) * viewDataCount + 1);
			System.out.println(querys[1]);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new SearchResultDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setRef_count(rs.getInt("REF_COUNT"));
				bean.setCit_count(rs.getInt("CIT_COUNT"));
				tmpMap.put(bean.getEid(), bean);
			}
			rs.close();
			String query = " select distinct ag.author_seq, ranking, author_id, author_name, delegate_author_name, email"
					+ " from SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a "
					+ " where ag.author_seq=a.author_seq and eid = ?";

			psmt = conn.prepareStatement(query);
			AuthorBean ab = null;
			LinkedList<AuthorBean> authorBeanList = null;
			for (String eid : tmpMap.keySet()) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				authorBeanList = new LinkedList<AuthorBean>();
				while (rs.next()) {
					ab = new AuthorBean();
					ab.setAuthorID(rs.getString("AUTHOR_ID"));
					ab.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
					ab.setRanking(rs.getInt("RANKING"));
					ab.setAuthorName(rs.getString("AUTHOR_NAME"));
					ab.setEmail(rs.getString("EMAIL"));
					authorBeanList.add(ab);
				}
				bean = tmpMap.get(eid);
				bean.setAuthorInfo(authorBeanList);
				bean = tmpMap.put(eid, bean);

				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * 저자를 검색한다.
	 * 
	 * @param searchRule
	 * @param currentPage
	 * @param viewDataCount
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<AuthorSearchResultBean> searchAuthor(
			String searchRule, int currentPage, int viewDataCount)
			throws SQLException {
		LinkedList<AuthorSearchResultBean> result = new LinkedList<AuthorSearchResultBean>();
		if (searchRule.startsWith("AU-")) {
			// 저자명 검색.
			searchRule = searchRule.substring(3);
			boolean exactMatch = false;
			if (searchRule.startsWith("true")) {
				exactMatch = true;
				searchRule = searchRule.substring(4);
			} else {
				searchRule = searchRule.substring(5);
			}
			result = searchAuthor(
					MakeSearchRule.makeAuthorSearchQuery(
							searchRule.replaceAll("\\(", "").replaceAll("\\)",
									""), exactMatch), currentPage,
					viewDataCount);
		}
		return result;
	}

	/**
	 * eidList들의 인용 문헌들을 가져온다.<br>
	 * 
	 * @param eidList
	 * @param currentPage
	 * @param viewDataCount
	 * @throws SQLException
	 */
	private static LinkedList<SearchResultDocumentBean> searchCitationDocument(
			String eidList, int currentPage, int viewDataCount)
			throws SQLException {
		Set<String> eidSet = new HashSet<String>();
		for (String eid : eidList.split(" ")) {
			eid = eid.trim();
			if ("".equals(eid))
				continue;
			eidSet.add(eid);
		}
		String whereCondition = UtilString.whereContidion(eidSet, true);
		String query = ""
				+ "	SELECT *"
				+ "		From"
				+ "			(Select /*+ INDEX_DESC(A INDEX_DOCUMENT_CIT_COUNT) */ ROWNUM as rnum, A.* FROM"
				+ "				( select * from scopus_document where eid IN"
				+ "					(select distinct cit_eid from SCOPUS_CITATION where "
				+ whereCondition + "					)" + "				  order by cit_count desc"
				+ "				) A" + "		where rownum <= ?" + "	)"
				+ "	where rnum >= ? ";

		String countQuery = "" + "	SELECT count(eid)" + "		From"
				+ "			(Select ROWNUM as rnum, A.eid FROM"
				+ "				( select eid from scopus_document where eid IN"
				+ "					(select distinct cit_eid from SCOPUS_CITATION where "
				+ whereCondition + "					)" +
				// "				  order by cit_count desc" +
				"				) A" + "	)";

		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		LinkedList<SearchResultDocumentBean> result = new LinkedList<SearchResultDocumentBean>();
		HashMap<String, SearchResultDocumentBean> tmpMap = new HashMap<String, SearchResultDocumentBean>();
		SearchResultDocumentBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(countQuery);
			int psmtIndex = 1;
			for (String eid : eidSet) {
				psmt.setString(psmtIndex++, eid);
			}

			rs = psmt.executeQuery();
			while (rs.next()) {
				setTotalSearchResultCount(rs.getInt(1));
				break;
			}
			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(query);
			psmtIndex = 1;
			for (String eid : eidSet) {
				psmt.setString(psmtIndex++, eid);
			}
			psmt.setInt(psmtIndex++, (currentPage * viewDataCount));
			psmt.setInt(psmtIndex++, (currentPage - 1) * viewDataCount + 1);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new SearchResultDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setRef_count(rs.getInt("REF_COUNT"));
				bean.setCit_count(rs.getInt("CIT_COUNT"));
				tmpMap.put(bean.getEid(), bean);
			}
			rs.close();
			query = " select distinct ag.author_seq, ranking, author_id, author_name, delegate_author_name, email"
					+ " from SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a "
					+ " where ag.author_seq=a.author_seq and eid = ?";

			psmt = conn.prepareStatement(query);
			AuthorBean ab = null;
			LinkedList<AuthorBean> authorBeanList = null;
			for (String eid : tmpMap.keySet()) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				authorBeanList = new LinkedList<AuthorBean>();
				while (rs.next()) {
					ab = new AuthorBean();
					ab.setAuthorID(rs.getString("AUTHOR_ID"));
					ab.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
					ab.setRanking(rs.getInt("RANKING"));
					ab.setAuthorName(rs.getString("AUTHOR_NAME"));
					ab.setEmail(rs.getString("EMAIL"));
					authorBeanList.add(ab);
				}
				bean = tmpMap.get(eid);
				bean.setAuthorInfo(authorBeanList);
				bean = tmpMap.put(eid, bean);

				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * eidList들의 참고 문헌들을 가져온다.<br>
	 * 
	 * @param eidList
	 * @param currentPage
	 * @param viewDataCount
	 * @throws SQLException
	 */
	private static LinkedList<SearchResultDocumentBean> searchReferenceDocument(
			String eidList, int currentPage, int viewDataCount)
			throws SQLException {
		Set<String> eidSet = new HashSet<String>();
		for (String eid : eidList.split(" ")) {
			eid = eid.trim();
			if ("".equals(eid))
				continue;
			eidSet.add(eid);
		}
		String whereCondition = UtilString.whereContidion(eidSet, true);
		String query = ""
				+ "	SELECT *"
				+ "		From"
				+ "			(Select /*+ INDEX_DESC(A INDEX_DOCUMENT_CIT_COUNT) */ ROWNUM as rnum, A.* FROM"
				+ "				( select * from scopus_document where eid IN"
				+ "					(select distinct ref_eid from SCOPUS_REFERENCE where "
				+ whereCondition + "					)" + "				  order by cit_count desc"
				+ "				) A" + "		where rownum <= ?" + "	)"
				+ "	where rnum >= ? ";

		String countQuery = "" + "	SELECT count(eid)" + "		From"
				+ "			(Select ROWNUM as rnum, A.eid FROM"
				+ "				( select eid from scopus_document where eid IN"
				+ "					(select distinct ref_eid from SCOPUS_REFERENCE where "
				+ whereCondition + "					)" +
				// "				  order by cit_count desc" +
				"				) A" + "	)";

		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		LinkedList<SearchResultDocumentBean> result = new LinkedList<SearchResultDocumentBean>();
		HashMap<String, SearchResultDocumentBean> tmpMap = new HashMap<String, SearchResultDocumentBean>();
		SearchResultDocumentBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(countQuery);
			int psmtIndex = 1;
			for (String eid : eidSet) {
				psmt.setString(psmtIndex++, eid);
			}

			rs = psmt.executeQuery();
			while (rs.next()) {
				setTotalSearchResultCount(rs.getInt(1));
				break;
			}
			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(query);
			psmtIndex = 1;
			for (String eid : eidSet) {
				psmt.setString(psmtIndex++, eid);
			}
			psmt.setInt(psmtIndex++, (currentPage * viewDataCount));
			psmt.setInt(psmtIndex++, (currentPage - 1) * viewDataCount + 1);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new SearchResultDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setRef_count(rs.getInt("REF_COUNT"));
				bean.setCit_count(rs.getInt("CIT_COUNT"));
				tmpMap.put(bean.getEid(), bean);
			}
			rs.close();
			query = " select distinct ag.author_seq, ranking, author_id, author_name, delegate_author_name, email"
					+ " from SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a "
					+ " where ag.author_seq=a.author_seq and eid = ?";

			psmt = conn.prepareStatement(query);
			AuthorBean ab = null;
			LinkedList<AuthorBean> authorBeanList = null;
			for (String eid : tmpMap.keySet()) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				authorBeanList = new LinkedList<AuthorBean>();
				while (rs.next()) {
					ab = new AuthorBean();
					ab.setAuthorID(rs.getString("AUTHOR_ID"));
					ab.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
					ab.setRanking(rs.getInt("RANKING"));
					ab.setAuthorName(rs.getString("AUTHOR_NAME"));
					ab.setEmail(rs.getString("EMAIL"));
					authorBeanList.add(ab);
				}
				bean = tmpMap.get(eid);
				bean.setAuthorInfo(authorBeanList);
				bean = tmpMap.put(eid, bean);

				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * 일반 검색.
	 * 
	 * @param query
	 *            SQL로 변환된 검색식
	 * @param currentPage
	 *            현재 페이지 번호
	 * @param viewDataCount
	 *            한 화면에 보여지는 개수.
	 * @return
	 * @throws SQLException
	 */
	private static LinkedList<SearchResultDocumentBean> searchDocument(
			String querys[], int currentPage, int viewDataCount)
			throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		LinkedList<SearchResultDocumentBean> result = new LinkedList<SearchResultDocumentBean>();
		HashMap<String, SearchResultDocumentBean> tmpMap = new HashMap<String, SearchResultDocumentBean>();
		SearchResultDocumentBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(querys[0]);
			rs = psmt.executeQuery();
			while (rs.next()) {
				setTotalSearchResultCount(rs.getInt(1));
			}
			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(querys[1]);
			psmt.setInt(1, (currentPage * viewDataCount));
			psmt.setInt(2, (currentPage - 1) * viewDataCount + 1);
			System.out.println(querys[1]);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new SearchResultDocumentBean();
				bean.setEid(rs.getString("EID"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setRef_count(rs.getInt("REF_COUNT"));
				bean.setCit_count(rs.getInt("CIT_COUNT"));
				tmpMap.put(bean.getEid(), bean);
			}
			rs.close();
			String query = " select distinct ag.author_seq, ranking, author_id, author_name, delegate_author_name, email"
					+ " from SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a "
					+ " where ag.author_seq=a.author_seq and eid = ?";

			psmt = conn.prepareStatement(query);
			AuthorBean ab = null;
			LinkedList<AuthorBean> authorBeanList = null;
			for (String eid : tmpMap.keySet()) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				authorBeanList = new LinkedList<AuthorBean>();
				while (rs.next()) {
					ab = new AuthorBean();
					ab.setAuthorID(rs.getString("AUTHOR_ID"));
					ab.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
					ab.setRanking(rs.getInt("RANKING"));
					ab.setAuthorName(rs.getString("AUTHOR_NAME"));
					ab.setEmail(rs.getString("EMAIL"));
					authorBeanList.add(ab);
				}
				bean = tmpMap.get(eid);
				bean.setAuthorInfo(authorBeanList);
				bean = tmpMap.put(eid, bean);

				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * 저자 검색.
	 * 
	 * @param query
	 *            SQL로 변환된 검색식
	 * @param currentPage
	 *            현재 페이지 번호
	 * @param viewDataCount
	 *            한 화면에 보여지는 개수.
	 * @return
	 * @throws SQLException
	 */
	private static LinkedList<AuthorSearchResultBean> searchAuthor(
			String querys[], int currentPage, int viewDataCount)
			throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		LinkedList<AuthorSearchResultBean> result = new LinkedList<AuthorSearchResultBean>();
		AuthorSearchResultBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(querys[0]);
			rs = psmt.executeQuery();
			while (rs.next()) {
				setTotalSearchResultCount(rs.getInt(1));
			}
			rs.close();
			psmt.close();

			psmt = conn.prepareStatement(querys[1]);
			psmt.setInt(1, (currentPage * viewDataCount));
			psmt.setInt(2, (currentPage - 1) * viewDataCount + 1);

			LinkedHashMap<Integer, AuthorBean> authorMap = new LinkedHashMap<Integer, AuthorBean>();
			AuthorBean ab = null;
			rs = psmt.executeQuery();
			while (rs.next()) {
				ab = new AuthorBean();
				ab.setAuthorSeq(rs.getInt("AUTHOR_SEQ"));
				ab.setAuthorID(rs.getString("AUTHOR_ID"));
				ab.setAuthorName(rs.getString("AUTHOR_NAME"));
				ab.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
				ab.setEmail(rs.getString("EMAIL"));
				ab.setEidCnt(rs.getInt("EID_COUNT"));
				authorMap.put(ab.getAuthorSeq(), ab);
			}
			rs.close();
			StringBuffer querySB = new StringBuffer();
			querySB.append(" select /*+ use_nl(sa) use_nl(ag) */ * from SCOPUS_AUTHOR_GROUP sa, SCOPUS_AFFILATION_GROUP ag ");
			querySB.append(" where sa.EID = ag.EID and sa.GROUP_SEQUENCE = ag.GROUP_SEQUENCE and AUTHOR_SEQ=? ");
			psmt = conn.prepareStatement(querySB.toString());
			for (int authorSeq : authorMap.keySet()) {
				psmt.setInt(1, authorSeq);
				rs = psmt.executeQuery();
				while (rs.next()) {
					bean = new AuthorSearchResultBean();
					bean.setAuthorSeq(authorSeq);
					bean.setCountryCode(rs.getString("COUNTRY_CODE"));
					bean.setOrgName(rs.getString("ORG_NAME"));
					bean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
					bean.setAfid(rs.getString("AFID"));
					bean.setDftid(rs.getString("DFTID"));
				}
				bean.setAuthorBean(authorMap.get(authorSeq));
				result.add(bean);
				rs.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * 직전에 검색된 모든 검색결과값을 가져온다.
	 * 
	 * @return
	 */
	public synchronized static int getTotalSearchResultCount() {
		return totalSearchResultCount;
	}

	private synchronized static void setTotalSearchResultCount(int cnt) {
		totalSearchResultCount = cnt;
	}

}
