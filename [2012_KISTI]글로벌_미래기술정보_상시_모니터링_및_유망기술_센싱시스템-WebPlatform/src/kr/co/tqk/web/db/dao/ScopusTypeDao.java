package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.topquadrant.util.AuthorNameCleansing;
import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.util.InfoStack;
import kr.co.tqk.web.util.UtilSQL;

/**
 * SCOPUS 데이터의 Type table 정보를 가져오는 클래스.
 * 
 * @author 정승한
 * 
 */
public class ScopusTypeDao {

	/**
	 * SCOPUS_CITATION_TYPE 테이블에서 전체 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static SortedMap<String, String> getCitationTypeList() {
		SortedMap<String, String> result = new TreeMap<String, String>();
		String query = "select CITATION_TYPE, DESCRIPTION from SCOPUS_CITATION_TYPE";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				result.put(rs.getString("CITATION_TYPE").trim(), rs.getString("DESCRIPTION"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * SCOPUS_SOURCE_TYPE 테이블에서 전체 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static SortedMap<String, String> getSourceTypeList() {
		SortedMap<String, String> result = new TreeMap<String, String>();
		String query = "select CODE, DESCRIPTION from SCOPUS_SOURCE_TYPE";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				result.put(rs.getString("CODE"), rs.getString("DESCRIPTION"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * SCOPUS_COUNTRY_CODE_NEW 테이블에서 전체 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static HashMap<String, String> getCountryCodeDescription() {
		HashMap<String, String> result = new HashMap<String, String>();
		String query = "select * from SCOPUS_COUNTRY_CODE";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				result.put(rs.getString(1).toUpperCase().trim(), rs.getString(2).trim());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	static final String koreaDescriptionTable = "SCOPUS_ASJC_KOREA";
	static final String engDescriptionTable = "SCOPUS_ASJC";

	/**
	 * ASJC 디스크립션 정보를 가져온다.
	 * 
	 * @param isKorea
	 *            true이면 한국어 디스크립션을 가져온다.<br>
	 *            false이면 영문 디스크립션.
	 * @return
	 */
	public static Map<String, String> getAsjcDescription(boolean isKorea) {
		Map<String, String> result = new TreeMap<String, String>();
		String tableName = koreaDescriptionTable;
		if (!isKorea) {
			tableName = engDescriptionTable;
		}
		String query = "select * from " + tableName;
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				result.put(rs.getString(1).trim(), rs.getString(2).trim());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * 통계 정보에서 저자 이름을 검색한다.<br>
	 * 
	 * @param authorIDs
	 * @return
	 * @throws SQLException
	 */
	public static Map<String, String> getAuthorNameDescription(Map<String, String> authorNameMap,
			Map<String, Integer> authorNameFreqMap, Set<String> authorIDs) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		InfoStack.manageMap(authorNameMap, authorNameFreqMap);
		
		authorIDs = InfoStack.getNotInclude(authorNameMap, authorIDs);
		if (authorIDs.size() < 1)
			return authorNameMap;


		Map<String, String> data = new HashMap<String, String>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			StringBuffer query = new StringBuffer();
			query.append(" SELECT MIN(author_seq), AUTHOR_ID, MAX(author_name) as AUTHOR_NAME,  MIN(delegate_author_name), MAX(email) ");
			query.append(" FROM SCOPUS_AUTHOR WHERE author_id IN (%s) ");
			query.append(" GROUP BY author_id ");
			psmt = conn.prepareStatement(UtilSQL.makeQuery(query.toString(), authorIDs.size()));
			int preparedIdx = 1;
			for (String authorID : authorIDs) {
				psmt.setString(preparedIdx++, authorID);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				String authorID = rs.getString("AUTHOR_ID");
				String authorName = rs.getString("AUTHOR_NAME");
				if (authorID == null)
					continue;
				InfoStack.registerKeyValue(authorNameMap, authorID.trim(), AuthorNameCleansing.cleansing(authorName));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return authorNameMap;
	}
	
	/**
	 * 통계 정보에서 기관 이름을 검색한다.<br>
	 * 
	 * @param affiliationIDs
	 * @return
	 * @throws SQLException
	 */
	public static Map<String, String> getAffiliationNameDescription(Map<String, String> affiliationNameMap,
			Map<String, Integer> affiliationNameFreqMap, Set<String> affiliationIDs) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		InfoStack.manageMap(affiliationNameMap, affiliationNameFreqMap);
		
		affiliationIDs = InfoStack.getNotInclude(affiliationNameMap, affiliationIDs);
		if (affiliationIDs.size() < 1)
			return affiliationNameMap;
		

		List<Set<String>> afidSets = new ArrayList<Set<String>>();

		if(affiliationIDs.size() > 500){
			
			Set<String> tmp = new HashSet<String>();
			
			int count = 0;
			for(String s : affiliationIDs){
				tmp.add(s);
				if(count==500){
					afidSets.add(tmp);
					tmp = new HashSet<String>();
					count = 0;
				}
				count++;
			}
			if(tmp.size() > 0){
				afidSets.add(tmp);
			}
		}else{
			afidSets.add(affiliationIDs);
		}
//		Map<String, String> data = new HashMap<String, String>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			StringBuffer query = new StringBuffer();
			query.append(" SELECT afid, affilation ");
			query.append(" FROM SCOPUS_KISTI_AFFILIATION WHERE afid IN (%s) ");
			
			for(Set<String> afidSet : afidSets){
				psmt = conn.prepareStatement(UtilSQL.makeQuery(query.toString(), afidSet.size()));
				int preparedIdx = 1;
				for (String afid : afidSet) {
					psmt.setString(preparedIdx++, afid);
				}
				rs = psmt.executeQuery();
				while (rs.next()) {
					String afid = rs.getString("afid");
					String affiliation = rs.getString("affilation");
					if (afid == null)
						continue;
					InfoStack.registerKeyValue(affiliationNameMap, afid.trim(), AuthorNameCleansing.cleansing(affiliation));
				}
				rs.close();
				psmt.clearParameters();
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return affiliationNameMap;
	}

	/**
	 * 통계 정보에서 사용할 Source의 title 정보를 가져온다.
	 * 
	 * @param sourceTitleMap
	 *            출처 정보 데이터
	 * @param sourceTitleFreqMap
	 *            출처 정보 조회 데이터.
	 * @param sourceIDs
	 *            새롭게 조회할 출처 정보 ID
	 * @return
	 * @throws SQLException
	 */
	public static Map<String, String> getSourceDescription(Map<String, String> sourceTitleMap,
			Map<String, Integer> sourceTitleFreqMap, Set<String> sourceIDs) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		sourceIDs = InfoStack.getNotInclude(sourceTitleMap, sourceIDs);
		if (sourceIDs.size() < 1)
			return sourceTitleMap;

		InfoStack.manageMap(sourceTitleMap, sourceTitleFreqMap);

		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			StringBuffer query = new StringBuffer();
			query.append(" SELECT source_id, MAX(source_title) AS source_title FROM SCOPUS_SOURCE_INFO WHERE source_id IN (%s) group by source_id ");
			psmt = conn.prepareStatement(UtilSQL.makeQuery(query.toString(), sourceIDs.size()));
			int preparedIdx = 1;
			for (String sourceID : sourceIDs) {
				psmt.setString(preparedIdx++, sourceID);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				String sourceID = rs.getString("source_id");
				String sourceTitle = rs.getString("source_title");
				if (sourceID == null)
					continue;
				InfoStack.registerKeyValue(sourceTitleMap, sourceID.trim(), sourceTitle);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return sourceTitleMap;
	}
}
