package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import kr.co.topquadrant.util.AuthorNameCleansing;
import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.AuthorInfoBean;
import kr.co.tqk.web.util.InfoStack;
import kr.co.tqk.web.util.UtilSQL;

/**
 * 저자와 관련된 테이블을 핸들링한다.
 * 
 * @author 정승한
 * 
 */
public class AuthorInfoDao {

	/**
	 * 저자 정보를 검색한다.<br>
	 * 
	 * @param authorSeq
	 *            저자 시쿼스 번호.
	 * @return
	 * @throws SQLException
	 */
	public static HashSet<AuthorInfoBean> searchAuthorInfo(String authorSeq) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		AuthorInfoBean bean = null;

		HashSet<AuthorInfoBean> result = new HashSet<AuthorInfoBean>();
		HashSet<String> eidSet = new HashSet<String>();

		try {
			StringBuffer query = new StringBuffer();
			query.append(" select afg.EID, afg.GROUP_SEQUENCE, AFID, DFTID, ORG_NAME, COUNTRY_CODE, DELEGATE_ORG_NAME, RANKING, AUTHOR_ID, AUTHOR_NAME, DELEGATE_AUTHOR_NAME, EMAIL ");
			query.append(" from SCOPUS_AFFILATION_GROUP afg, SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a");
			query.append(" where afg.EID = ag.EID and afg.GROUP_SEQUENCE = ag.GROUP_SEQUENCE and ag.AUTHOR_SEQ = a.AUTHOR_SEQ and ag.AUTHOR_SEQ = ?");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, authorSeq);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new AuthorInfoBean();
				bean.setEid(rs.getString("EID"));
				int gs = rs.getInt("GROUP_SEQUENCE");
				bean.setGroupSequence(gs);
				bean.setAfid(rs.getString("AFID"));
				bean.setDftid(rs.getString("DFTID"));
				bean.setOrgName(rs.getString("ORG_NAME"));
				bean.setCountryCode(rs.getString("COUNTRY_CODE"));
				bean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
				bean.setRanking(rs.getInt("RANKING"));
				bean.setAuthorID(rs.getString("AUTHOR_ID"));
				bean.setAuthorName(rs.getString("AUTHOR_NAME"));
				bean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
				bean.setEmail(rs.getString("EMAIL"));
				eidSet.add(bean.getEid());
				result.add(bean);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * 저자 정보를 검색한다.<br>
	 * 
	 * @param authorSeq
	 *            저자 시쿼스 번호.
	 * @return
	 * @throws SQLException
	 */
	public static HashSet<AuthorInfoBean> searchAuthorIDInfo(String authorID) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		AuthorInfoBean bean = null;

		HashSet<AuthorInfoBean> result = new HashSet<AuthorInfoBean>();
		HashSet<String> eidSet = new HashSet<String>();

		try {
			StringBuffer query = new StringBuffer();
			query.append(" select /*+ use_nl(afg) use_nl(ag) use_nl(a)*/ afg.EID, afg.GROUP_SEQUENCE, AFID, DFTID, ORG_NAME, COUNTRY_CODE, DELEGATE_ORG_NAME, RANKING, AUTHOR_ID, AUTHOR_NAME, DELEGATE_AUTHOR_NAME, EMAIL ");
			query.append(" from SCOPUS_AFFILATION_GROUP afg, SCOPUS_AUTHOR_GROUP ag, (select * from SCOPUS_AUTHOR where AUTHOR_ID=?) a");
			query.append(" where afg.EID = ag.EID and afg.GROUP_SEQUENCE = ag.GROUP_SEQUENCE and ag.AUTHOR_SEQ = a.AUTHOR_SEQ");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, authorID);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new AuthorInfoBean();
				bean.setEid(rs.getString("EID"));
				int gs = rs.getInt("GROUP_SEQUENCE");
				bean.setGroupSequence(gs);
				bean.setAfid(rs.getString("AFID"));
				bean.setDftid(rs.getString("DFTID"));
				bean.setOrgName(rs.getString("ORG_NAME"));
				bean.setCountryCode(rs.getString("COUNTRY_CODE"));
				bean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
				bean.setRanking(rs.getInt("RANKING"));
				bean.setAuthorID(rs.getString("AUTHOR_ID"));
				bean.setAuthorName(rs.getString("AUTHOR_NAME"));
				bean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
				bean.setEmail(rs.getString("EMAIL"));
				eidSet.add(bean.getEid());
				result.add(bean);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * 저자 정보를 검색한다.<br>
	 * 
	 * @param authorSeq
	 *            저자 시쿼스 번호.
	 * @return
	 * @throws SQLException
	 */
	public static HashSet<AuthorInfoBean> searchAuthorIDInfo(Connection conn, String authorID) throws SQLException {
		PreparedStatement psmt = null;
		ResultSet rs = null;

		AuthorInfoBean bean = null;

		HashSet<AuthorInfoBean> result = new HashSet<AuthorInfoBean>();
		HashSet<String> eidSet = new HashSet<String>();

		try {
			StringBuffer query = new StringBuffer();
			query.append(" select /*+ use_nl(afg) use_nl(ag) use_nl(a)*/ afg.EID, afg.GROUP_SEQUENCE, AFID, DFTID, ORG_NAME, COUNTRY_CODE, DELEGATE_ORG_NAME, RANKING, AUTHOR_ID, AUTHOR_NAME, DELEGATE_AUTHOR_NAME, EMAIL ");
			query.append(" from SCOPUS_AFFILATION_GROUP afg, SCOPUS_AUTHOR_GROUP ag, SCOPUS_AUTHOR a");
			query.append(" where afg.EID = ag.EID and afg.GROUP_SEQUENCE = ag.GROUP_SEQUENCE and ag.AUTHOR_SEQ = a.AUTHOR_SEQ and AUTHOR_ID = ?");
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, authorID);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new AuthorInfoBean();
				bean.setEid(rs.getString("EID"));
				int gs = rs.getInt("GROUP_SEQUENCE");
				bean.setGroupSequence(gs);
				bean.setAfid(rs.getString("AFID"));
				bean.setDftid(rs.getString("DFTID"));
				bean.setOrgName(rs.getString("ORG_NAME"));
				bean.setCountryCode(rs.getString("COUNTRY_CODE"));
				bean.setDelegateOrgName(rs.getString("DELEGATE_ORG_NAME"));
				bean.setRanking(rs.getInt("RANKING"));
				bean.setAuthorID(rs.getString("AUTHOR_ID"));
				bean.setAuthorName(rs.getString("AUTHOR_NAME"));
				bean.setDelegateAuthorName(rs.getString("DELEGATE_AUTHOR_NAME"));
				bean.setEmail(rs.getString("EMAIL"));
				eidSet.add(bean.getEid());
				result.add(bean);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (psmt != null) {
				psmt.close();
			}
		}

		return result;
	}

	public static void main(String[] args) throws SQLException {
		// HashSet<AuthorInfoBean> aiBeanSet =
		// AuthorInfoDao.searchAuthorIDInfo("6505552500");
		// for (AuthorInfoBean b : aiBeanSet) {
		// System.out.println(b.getAuthorID());
		// System.out.println(b.getAuthorName());
		// System.out.println(b.getOrgName());
		// }
		Set<String> authorIDs = new HashSet<String>();
		authorIDs.add("1111");
		authorIDs.add("222");
		authorIDs.add("2222");

		StringBuffer query = new StringBuffer();
		query.append(" SELECT MIN(author_seq), author_id, MAX(author_name),  MIN(delegate_author_name), MAX(email) ");
		query.append(" FROM SCOPUS_AUTHOR WHERE author_id IN (%s) ");
		query.append(" GROUP BY author_id ");

		System.out.println(UtilSQL.makeQuery(query.toString(), authorIDs.size()));
	}

}
