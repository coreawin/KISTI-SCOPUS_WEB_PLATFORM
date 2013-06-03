package kr.co.tqk.web.db.dao.export;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.export.ExportInfoBean;

public class ExportInfoDao {

	/**
	 * 로그 정보를 가져온다.
	 * 
	 * @param ids
	 *            아이디
	 * @return UserBean
	 */
	public static ExportInfoBean select(String ids) {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from EXPORT_LOG where ids=?";
		ExportInfoBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, ids);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ExportInfoBean(rs.getString("CONTENTS"));
				bean.setIds(ids);
				bean.setINSERT_DATE(rs.getTimestamp("INSERT_DATE"));
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * 로그 정보를 수정한다.
	 * 
	 * @param idㄴ
	 *            아이디
	 * @param contents
	 *            로그 내용
	 * @throws SQLException
	 */
	public static void modify(String ids, String contents) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "update EXPORT_LOG set CONTENTS = ? where IDS=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, contents);
			psmt.setString(2, ids);
			psmt.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * 로그 정보를 갱신한다.
	 * 
	 * @param idㄴ
	 *            아이디
	 * @param contents
	 *            로그 내용
	 * @throws SQLException
	 */
	public static void mergeInto(String ids, String contents)
			throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		StringBuffer query = new StringBuffer();
		query.append(" MERGE INTO EXPORT_LOG S ");
		query.append(" USING DUAL ");
		query.append(" ON (S.IDS=?) ");
		query.append(" WHEN MATCHED THEN ");
		query.append(" UPDATE SET S.CONTENTS = ? ");
		query.append(" WHEN NOT MATCHED THEN ");
		query.append(" INSERT (IDS, CONTENTS, INSERT_DATE) values (?, ?, CURRENT_DATE) ");

		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, ids);
			psmt.setString(2, contents);
			psmt.setString(3, ids);
			psmt.setString(4, contents);
			psmt.execute();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * 로그 정보를 갱신한다.
	 * 
	 * @param idㄴ
	 *            아이디
	 * @param contents
	 *            로그 내용
	 * @throws SQLException
	 */
	public static void mergeInto(Connection conn, String ids, String contents)
			throws SQLException {
		PreparedStatement psmt = null;
		StringBuffer query = new StringBuffer();
		query.append(" MERGE INTO EXPORT_LOG S ");
		query.append(" USING DUAL ");
		query.append(" ON (S.IDS=?) ");
		query.append(" WHEN MATCHED THEN ");
		query.append(" UPDATE SET S.CONTENTS = ? ");
		query.append(" WHEN NOT MATCHED THEN ");
		query.append(" INSERT (IDS, CONTENTS, INSERT_DATE) values (?, ?, CURRENT_DATE) ");

		try {
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, ids);
			psmt.setString(2, contents);
			psmt.setString(3, ids);
			psmt.setString(4, contents);
			psmt.execute();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (psmt != null)
				psmt.close();
		}
	}

	/**
	 * 로그 정보를 삭제한다.
	 * 
	 * @param ids
	 *            아이디
	 * @throws SQLException
	 */
	public static void remove(String ids) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "delete from EXPORT_LOG where IDS=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, ids);
			psmt.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

}
