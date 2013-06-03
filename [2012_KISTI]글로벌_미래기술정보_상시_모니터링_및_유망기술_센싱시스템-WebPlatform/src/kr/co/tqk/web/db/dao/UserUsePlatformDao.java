package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.mgr.UserUsePlatformBean;
import kr.co.tqk.web.util.UserUsePlatformDefinition;

public class UserUsePlatformDao {

	static final String TABLE_NAME = "USER_USE_PLATFORM";

	/**
	 * 금일 로그인을 했나?
	 * 
	 * @param userID
	 *            사용자 아이디.
	 * @return
	 * @throws SQLException
	 */
	public static boolean isNowDateLogin(Connection conn, String userID)
			throws SQLException {
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from "
				+ TABLE_NAME
				+ " where USER_ID = ? and USE_TYPE= ? and TO_CHAR(INSERT_DATE, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD') ";
		boolean isNowDateLogin = false;
		try {
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);
			psmt.setInt(2, UserUsePlatformDefinition.ACTION_LOGIN);

			rs = psmt.executeQuery();
			while (rs.next()) {
				isNowDateLogin = true;
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
		}
		return isNowDateLogin;
	}

	public static LinkedList<UserUsePlatformBean> selectPagingAll(
			String userID, int pageNumber, int viewDataCount) {
		LinkedList<UserUsePlatformBean> result = new LinkedList<UserUsePlatformBean>();
		UserUsePlatformBean bean = null;
		String query = "" + "	select * from ("
				+ "		select rounum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, USE_TYPE, INSERT_DATE from "
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
				bean = new UserUsePlatformBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(userID);
				bean.setUseType(rs.getInt("USE_TYPE"));
				bean.setInsertTime(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserUsePlatformBean> select(String userID) {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from " + TABLE_NAME
				+ " where USER_ID = ? order by INSERT_DATE desc";
		LinkedList<UserUsePlatformBean> result = new LinkedList<UserUsePlatformBean>();
		UserUsePlatformBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserUsePlatformBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(rs.getString("USER_ID"));
				bean.setUseType(rs.getInt("USE_TYPE"));
				bean.setInsertTime(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	public static LinkedList<UserUsePlatformBean> selectPagingAll(
			String userID, int useType, int pageNumber, int viewDataCount) {
		LinkedList<UserUsePlatformBean> result = new LinkedList<UserUsePlatformBean>();
		UserUsePlatformBean bean = null;
		String query = "" + "	select * from ("
				+ "		select rounum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, USE_TYPE, INSERT_DATE from "
				+ TABLE_NAME
				+ " where USER_ID=? and USE_TYPE=? order by SEQ DESC"
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
			psmt.setInt(2, useType);
			psmt.setInt(3, (pageNumber * viewDataCount));
			psmt.setInt(4, (pageNumber - 1) * viewDataCount + 1);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserUsePlatformBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserID(userID);
				bean.setUseType(rs.getInt("USE_TYPE"));
				bean.setInsertTime(rs.getTimestamp("INSERT_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	private static SortedMap<String, Integer> createInitYearStatics() {
		SortedMap<String, Integer> result = new TreeMap<String, Integer>();
		for (int index = 2011; index <= Calendar.getInstance().get(
				Calendar.YEAR); index++) {
			result.put(String.valueOf(index), 0);
		}
		return result;
	}

	private static SortedMap<String, Integer> createInitMonthStatics(String year) {
		SortedMap<String, Integer> result = new TreeMap<String, Integer>();
		for (int index = 1; index <= 12; index++) {
			if (index < 10) {
				result.put(year + "0" + String.valueOf(index), 0);
			} else {
				result.put(year + String.valueOf(index), 0);
			}
		}
		return result;
	}

	/**
	 * 월별 통계.
	 * 
	 * @param userID
	 * @param useType
	 * @param distinct
	 * @param year
	 * @throws SQLException
	 */
	public static LinkedHashMap<String, SortedMap<String, Integer>> statics(String userID,
			int useType, boolean distinct, String year) throws SQLException {
		StringBuffer query = new StringBuffer();
		LinkedHashMap<String, SortedMap<String, Integer>> staticsResult = new LinkedHashMap<String, SortedMap<String,Integer>>();
		if (year == null) {
			// 연도별 통계
			query.append("	select ");
			if (distinct)
				query.append("	distinct ");
			query.append("	user_id, NVL(TO_CHAR(insert_date, 'YYYY'), 'TOTAL') as title, COUNT(seq) as cnt from  ");
			query.append(TABLE_NAME);
			query.append("	where USE_TYPE=?");
			if (userID!=null)
				query.append("	and user_id=?");
			query.append("	group by ROLLUP(user_id, TO_CHAR(insert_date, 'YYYY')) ");
			query.append("	order by user_id, title");
		} else {
			// 월별 통계
			query.append("	select ");
			if (distinct)
				query.append("	distinct ");
			query.append("	user_id, NVL(TO_CHAR(insert_date, 'YYYYMM'), 'TOTAL') as title, COUNT(seq) as cnt from  ");
			query.append(TABLE_NAME);
			query.append("	where USE_TYPE=? AND TO_CHAR(insert_date, 'YYYY') = ? ");
			if (userID!=null)
				query.append("	AND user_id=?");
			query.append("	group by ROLLUP(user_id, TO_CHAR(insert_date, 'YYYYMM')) ");
			query.append("	order by user_id, title");
		}

		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, useType);
			if (year != null) {
				psmt.setString(2, year);
				if (userID!=null){
					psmt.setString(3, userID);
				}
			}else{
				if (userID!=null){
					psmt.setString(2, userID);
				}
			}
			rs = psmt.executeQuery();
			SortedMap<String, Integer> tmp = null;
			while (rs.next()) {
				String _id = rs.getString("user_id");
				if(_id==null) continue;
				if(staticsResult.containsKey(_id)){
					tmp = staticsResult.get(_id);
				}else{
					if (year == null) {
						tmp = createInitYearStatics();
					}else{
						tmp = createInitMonthStatics(year);
					}
				}
				tmp.put(rs.getString("title"), rs.getInt("cnt"));
				staticsResult.put(_id, tmp);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return staticsResult;
	}

	/**
	 * 연도별 통계.
	 * 
	 * @param userID
	 * @param useType
	 * @param distinct
	 * @throws SQLException
	 */
	public static LinkedHashMap<String, SortedMap<String, Integer>> statics(String userID,
			int useType, boolean distinct) throws SQLException {
		return statics(userID, useType, distinct, null);
	}

	/**
	 * 특정일 시간대별 통계.
	 * 
	 * @param userID
	 * @param useType
	 * @param distinct
	 */
	public static void staticsTime(String userID, int useType,
			boolean distinct, String year, String month, String date) {

	}

	/**
	 * 특정월간 시간대별 통계.
	 * 
	 * @param userID
	 * @param useType
	 * @param distinct
	 */
	public static void staticsTime(String userID, int useType,
			boolean distinct, String year, String month) {

	}

	/**
	 * 특정연간 시간대별 통계.
	 * 
	 * @param userID
	 * @param useType
	 * @param distinct
	 */
	public static void staticsTime(String userID, int useType,
			boolean distinct, String year) {

	}

	public static void insert(String userID, int useType) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "insert into "
				+ TABLE_NAME
				+ " values(USER_USE_PLATFORM_SEQUENCE.nextVal, ?, ?, CURRENT_DATE) ";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			if (useType == UserUsePlatformDefinition.ACTION_LOGIN) {
				if (isNowDateLogin(conn, userID)) {
					return;
				}
			}

			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID);
			psmt.setInt(2, useType);
			psmt.execute();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	public static void main(String[] args) throws SQLException {
		// UserUsePlatformDao.insert("neon",
		// UserUsePlatformDefinition.ACTION_LOGIN);
		// UserUsePlatformDao.insert("neon", UserUsePlatformDefinition);
		// UserUsePlatformDao.insert("neon", UserUsePlatformDefinition);
		// UserUsePlatformDao.insert("neon", UserUsePlatformDefinition);
		// UserUsePlatformDao.insert("neon", UserUsePlatformDefinition);
		// UserUsePlatformDao.insert("neon",
		// UsePlatformDefinition.ACTION_EXPORT);
		// UserUsePlatformDao.insert("neon",
		// UsePlatformDefinition.ACTION_EXPORT);

		// TODO 연도별, 월별, 일별 통계 쿼리
		// TODO 한 아이디에 대한 통계 지원
		// TODO 전체 아이디에 대한 개별 통계 지원.

		System.out.println(UserUsePlatformDao.statics(null,
				UserUsePlatformDefinition.ACTION_SEARCHING, false));
		System.out.println(UserUsePlatformDao.statics(null,
				UserUsePlatformDefinition.ACTION_LOGIN, false, null));
		System.out.println(UserUsePlatformDao.statics(null,
				UserUsePlatformDefinition.ACTION_EXPORT, false, 2011 + ""));
	}

}
