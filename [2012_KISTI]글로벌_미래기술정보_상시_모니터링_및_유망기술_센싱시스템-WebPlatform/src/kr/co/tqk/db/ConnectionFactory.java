package kr.co.tqk.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * �� Ŭ������ �⺻������ WAS���� �����Ǵ� DataSource�� Ȱ���Ѵ�.<br>
 * DB ���� ������ DataSource���� �����Ѵ�.<br>
 * 
 * @author neon
 * 
 */
public class ConnectionFactory {

	private Context initContext = null;
	private Context envContext = null;
	private DataSource ds = null;

	private static final String JNDI_CONNECT_NAME = "java:/comp/env";
	private static String connectDatasourceName = "jdbc/SCOPUS_DB";
	private static ConnectionFactory instance;

	private ConnectionFactory connectionFactoryInstance = null;
	private ConnectionFactoryBak connectionFactoryBackInstance = null;

	private ConnectionFactory() {
		try {
			initContext = new InitialContext();
			// ��Ĺ�� ���� ������ �ҽ�
//			envContext = (Context) initContext.lookup(JNDI_CONNECT_NAME);
//			ds = (DataSource) envContext.lookup(connectDatasourceName);
			// JEUS�� ���� ������ �ҽ�
			ds = (DataSource) initContext.lookup("scopus");
			
		} catch (Exception e) {
			System.out
					.println("�� �ý����� WAS�� JNDI�� Ȱ���� �����ͺ��̽� Ŀ�ؼ��� �����Ǿ� ���� �ʾ� ��ü ������ ����մϴ�.");
			ds = null;
			try {
				connectionFactoryBackInstance = ConnectionFactoryBak
						.getInstance();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}

	/**
	 * �̱����� ���� �ν��Ͻ� ��ȯ �޼ҵ�<br>
	 * 
	 * @return
	 */
	public static synchronized ConnectionFactory getInstance() {
		if (instance == null) {
			instance = new ConnectionFactory();
		}
		return instance;
	}

	/**
	 * DB�� ������ Ŀ�ؼ��� ���´�.<br>
	 * 
	 * �ݵ�� �� Ŭ������ ���� ����� Connection ��ü�� �ݾƾ� �Ѵ�.<br>
	 * 
	 * @return java.sql.Connection
	 * @throws SQLException
	 */
	public Connection getConnection() throws SQLException {
		Connection conn = null;
		if (ds != null) {
			conn = ds.getConnection();
		} else {
			conn = connectionFactoryBackInstance.getConnection();
		}
		if (conn == null)
			throw new SQLException("Connection�� ���� ���߽��ϴ�.���� ���� ������ Ȯ���� �ּ���.");
		conn.setAutoCommit(false);
		return conn;
	}

	public void close(Connection conn) throws SQLException {
		if (conn != null) {
			conn.close();
		}
	}

	public void release(ResultSet rs, PreparedStatement psmt, Connection conn) {
		if (rs != null)
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		if (psmt != null)
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		if (conn != null)
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
	}

	public void release(ResultSet rs, PreparedStatement psmt) {
		if (rs != null)
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		if (psmt != null)
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}

	public void release(PreparedStatement psmt, Connection conn) {
		if (psmt != null)
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		if (conn != null)
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
}
