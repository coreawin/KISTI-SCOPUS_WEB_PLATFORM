package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.LinkedList;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean;
import kr.co.tqk.web.util.UtilDate;

/**
 * 사용자 검색식 정보
 * 
 * @author 정승한
 * 
 */
public class UserSearchRuleDao {

	static final String TABLE_NAME = "USER_SEARCHRULE";

	public static LinkedList<UserSearchRuleBean> select(String userID) {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from " + TABLE_NAME
				+ " where USER_ID = ? order by INSERT_DATE desc";
		LinkedList<UserSearchRuleBean> result = new LinkedList<UserSearchRuleBean>();
		UserSearchRuleBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserSearchRuleBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setSearchRule(rs.getString("SEARCHRULE"));
				bean.setSearchCount(rs.getInt("SEARCHCOUNT"));
				bean.setInsertDate(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserSearchRuleBean> selectToday(String userID) {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from "
				+ TABLE_NAME
				+ " where USER_ID = ? and TO_CHAR(INSERT_DATE, 'YYYYMMDD') = TO_CHAR(?, 'YYYYMMDD') order by INSERT_DATE desc";
		LinkedList<UserSearchRuleBean> result = new LinkedList<UserSearchRuleBean>();
		UserSearchRuleBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);
			psmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserSearchRuleBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setSearchRule(rs.getString("SEARCHRULE"));
				bean.setSearchCount(rs.getInt("SEARCHCOUNT"));
				bean.setInsertDate(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserSearchRuleBean> selectPagingAll(String userID,
			int pageNumber, int viewDataCount) {
		LinkedList<UserSearchRuleBean> result = new LinkedList<UserSearchRuleBean>();
		UserSearchRuleBean bean = null;
		String query = ""
				+ "	select * from ("
				+ "		select rownum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, SEARCHRULE, SEARCHCOUNT, INSERT_DATE from "
				+ TABLE_NAME + " where USER_ID=?  order by SEQ DESC"
				+ "		) A where rownum <=? "
				+ "	) where rnum >= ? order by SEQ desc ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID.trim());
			psmt.setInt(2, (pageNumber * viewDataCount));
			psmt.setInt(3, (pageNumber - 1) * viewDataCount + 1);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserSearchRuleBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setSearchRule(rs.getString("SEARCHRULE"));
				bean.setSearchCount(rs.getInt("SEARCHCOUNT"));
				bean.setInsertDate(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserSearchRuleBean> selectPagingAll(String userID,
			Timestamp t, int pageNumber, int viewDataCount) {
		LinkedList<UserSearchRuleBean> result = new LinkedList<UserSearchRuleBean>();
		UserSearchRuleBean bean = null;
		String query = ""
				+ "	select * from ("
				+ "		select rownum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, SEARCHRULE, SEARCHCOUNT, INSERT_DATE from "
				+ TABLE_NAME
				+ " where USER_ID=? and TO_CHAR(INSERT_DATE, 'YYYYMMDD') = ? order by SEQ DESC"
				+ "		) A where rownum <=? "
				+ "	) where rnum >= ? order by SEQ desc ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID.trim());
			psmt.setString(2, UtilDate.getTimestampFormat(t));
			psmt.setInt(3, (pageNumber * viewDataCount));
			psmt.setInt(4, (pageNumber - 1) * viewDataCount + 1);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserSearchRuleBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setSearchRule(rs.getString("SEARCHRULE"));
				bean.setSearchCount(rs.getInt("SEARCHCOUNT"));
				bean.setInsertDate(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserSearchRuleBean> selectPagingAll(String userID,
			Timestamp startT, Timestamp endT, int pageNumber, int viewDataCount) {
		LinkedList<UserSearchRuleBean> result = new LinkedList<UserSearchRuleBean>();
		UserSearchRuleBean bean = null;
		String query = ""
				+ "	select * from ("
				+ "		select rownum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, SEARCHRULE, SEARCHCOUNT, INSERT_DATE from "
				+ TABLE_NAME
				+ " where USER_ID=? and (TO_CHAR(INSERT_DATE, 'YYYYMMDD') BETWEEN ? and ? order by SEQ DESC"
				+ "		) A where rownum <=? "
				+ "	) where rnum >= ? order by SEQ desc ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID.trim());
			psmt.setString(2, UtilDate.getTimestampFormat(startT));
			psmt.setString(3, UtilDate.getTimestampFormat(endT));
			psmt.setInt(4, (pageNumber * viewDataCount));
			psmt.setInt(5, (pageNumber - 1) * viewDataCount + 1);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserSearchRuleBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setSearchRule(rs.getString("SEARCHRULE"));
				bean.setSearchCount(rs.getInt("SEARCHCOUNT"));
				bean.setInsertDate(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static void insert(String userID, String searchRule,
			int searchResultCount) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "insert into "
				+ TABLE_NAME
				+ " values(USER_SEARCHRULE_SEQUENCE.nextVal, ?, ?, ?, CURRENT_DATE) ";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);
			psmt.setString(2, searchRule);
			psmt.setInt(3, searchResultCount);
			psmt.execute();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	public static void delete(String[] seqID) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "delete from " + TABLE_NAME + " where seq = ?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			for (String seq : seqID) {
				seq = seq.trim();
				if ("".equals(seq))
					continue;
				try {
					psmt.setInt(1, Integer.parseInt(seq));
					psmt.execute();
				} catch (NumberFormatException ne) {
					continue;
				}
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	public static void main(String[] args) throws SQLException {
		UserSearchRuleDao.insert("neon", "all(nano)", 456);
	}

}
