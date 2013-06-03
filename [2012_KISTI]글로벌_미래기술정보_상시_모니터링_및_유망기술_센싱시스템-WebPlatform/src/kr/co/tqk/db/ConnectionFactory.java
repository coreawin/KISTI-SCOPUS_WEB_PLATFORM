package kr.co.tqk.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * 이 클래스는 기본적으로 WAS에서 설정되는 DataSource를 활용한다.<br>
 * DB 접속 정보는 DataSource에서 참고한다.<br>
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
			// 톰캣을 위한 데이터 소스
//			envContext = (Context) initContext.lookup(JNDI_CONNECT_NAME);
//			ds = (DataSource) envContext.lookup(connectDatasourceName);
			// JEUS를 위한 데이터 소스
			ds = (DataSource) initContext.lookup("scopus");
			
		} catch (Exception e) {
			System.out
					.println("현 시스템은 WAS의 JNDI를 활용한 데이터베이스 커넥션이 설정되어 있지 않아 자체 설정을 사용합니다.");
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
	 * 싱글톤을 위한 인스턴스 반환 메소드<br>
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
	 * DB에 접속할 커넥션을 얻어온다.<br>
	 * 
	 * 반드시 이 클래스를 통해 사용후 Connection 객체를 닫아야 한다.<br>
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
			throw new SQLException("Connection을 얻지 못했습니다.관련 구성 설정을 확인해 주세요.");
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
