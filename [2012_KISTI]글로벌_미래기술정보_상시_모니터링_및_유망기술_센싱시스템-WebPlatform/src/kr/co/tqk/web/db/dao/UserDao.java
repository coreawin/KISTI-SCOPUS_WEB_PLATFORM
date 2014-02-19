package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

import kr.co.diquest.util.SHAEncrypt;
import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.UserBean;
import kr.co.tqk.web.util.UserAuthDefinition;
import kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum;

/**
 * ���� ���� DB �ڵ鸵.
 * 
 * @author ������
 * 
 */
/**
 * @author ������
 * 
 */
public class UserDao {

	/**
	 * �α����� �Ѵ�.
	 * 
	 * @param id
	 *            ���̵�
	 * @param pwd
	 *            ��ȣ
	 * @return null�� �ƴϸ� �α��� ����.
	 * @throws SQLException
	 */
	public static UserBean login(String id, String pwd) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from USER_INFO where id=? and NPWD=?";
		UserBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, id.trim());
			psmt.setString(2, SHAEncrypt.getEncrypt(pwd.trim()));
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * ����� ������ �����´�.
	 * 
	 * @param id
	 *            ���̵�
	 * @return UserBean
	 */
	public static UserBean select(String id) {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from USER_INFO where id=?";
		UserBean bean = null;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, id);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * ��� ������� ������ �����´�.
	 * 
	 * @return UserBean
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAll() throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = "select * from USER_INFO order by ID";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}

	/**
	 * ��� ������� ������ ����¡ �� �����´�.
	 * 
	 * @param pageNumber
	 *            ���� ������ ��ȣ
	 * @param viewDataCount
	 *            �� ȭ�鿡 ������ ������ ����
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAll(int pageNumber,
			int viewDataCount, String orderColumn, String orderType) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select * from ( "
				+ "	select rownum as rnum, A.* from ("
				+ "		select * from USER_INFO " + makeOrdering(orderColumn, orderType) +"	) A where rownum <= ?"
				+ ") where rnum >= ? ";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setInt(1, (pageNumber * viewDataCount));
			psmt.setInt(2, (pageNumber - 1) * viewDataCount + 1);

			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}
	
	/**
	 * ��� ������� ������ ����¡ �� �����´�.
	 * 
	 * @param pageNumber
	 *            ���� ������ ��ȣ
	 * @param viewDataCount
	 *            �� ȭ�鿡 ������ ������ ����
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAll(int pageNumber,
			int viewDataCount, String auth, String orderColumn, String orderType) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select * from ( "
			+ "	select rownum as rnum, A.* from ("
			+ "		select * from USER_INFO where AUTH=? " + makeOrdering(orderColumn, orderType) +" ) A where rownum <= ?"
			+ ") where rnum >= ? ";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, auth);
			psmt.setInt(2, (pageNumber * viewDataCount));
			psmt.setInt(3, (pageNumber - 1) * viewDataCount + 1);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}
	
	/**
	 * Ư�� ������ ���� ����� ���� �����Ѵ�.
	 * 
	 * @param auth
	 *  ����
	 * @return
	 * @throws SQLException
	 */
	public static int selectAuthCnt(String auth) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select count(ID) from USER_INFO where AUTH=? ";
		int result = 0;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, auth);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				result = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}
	
	/**
	 * Ư�� ������ ���� ����ڸ� �����Ѵ�.
	 * 
	 * @param auth
	 *            ���� �ڵ�.
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAuth(String auth) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select * from USER_INFO where AUTH=? ";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, auth);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}
	
	public static int selectSearchTermCnt(String searchTerm) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select count(ID) from USER_INFO where lower(id) like ? or lower(names) like ? or lower(EMAIL) like ? or lower(DEPARTMENT) like ? ";
		int result = 0;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(2, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(3, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(4, "%"+searchTerm.toLowerCase()+"%");
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				result = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}
	
	public static int selectSearchTermCnt(String auth, String searchTerm) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select count(ID) from USER_INFO where (lower(id) like ? or lower(names) like ? or lower(EMAIL) like ? or lower(DEPARTMENT) like ?) and auth=? ";
		int result = 0;
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(2, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(3, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(4, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(5, auth);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				result = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}
	
	/**
	 * ��� ������� ������ ����¡ �� �����´�.
	 * 
	 * @param pageNumber
	 *            ���� ������ ��ȣ
	 * @param viewDataCount
	 *            �� ȭ�鿡 ������ ������ ����
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAll(String searchTerm, int pageNumber,
			int viewDataCount, String orderColumn, String orderType) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String query = " select * from ( "
			+ "	select rownum as rnum, A.* from ("
			+ "		select * from USER_INFO where (lower(id) like ? or lower(names) like ? or lower(EMAIL) like ? or lower(DEPARTMENT) like ?) " + makeOrdering(orderColumn, orderType) +") A where rownum <= ? "
			+ ") where rnum >= ? ";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(2, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(3, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(4, "%"+searchTerm.toLowerCase()+"%");
			psmt.setInt(5, (pageNumber * viewDataCount));
			psmt.setInt(6, (pageNumber - 1) * viewDataCount + 1);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}
	
	private static String makeOrdering(String orderColumn, String orderType){
		String order = "";
		if(orderColumn!=null){
			if(orderType==null){
				orderType = "desc";
			}
			order = " order by " + orderColumn + " " + orderType;
		}
		return order;
	}
	
	/**
	 * ��� ������� ������ ����¡ �� �����´�.
	 * 
	 * @param pageNumber
	 *            ���� ������ ��ȣ
	 * @param viewDataCount
	 *            �� ȭ�鿡 ������ ������ ����
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<UserBean> selectAll(int pageNumber,
			int viewDataCount, String auth, String searchTerm, String orderColumn, String orderType) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		
		
		String query = " select * from ( "
			+ "	select rownum as rnum, A.* from ("
			+ "		select * from USER_INFO where (lower(id) like ? or lower(names) like ? or lower(EMAIL) like ? or lower(DEPARTMENT) like ?) and auth=? " + makeOrdering(orderColumn, orderType) +" ) A where rownum <= ? "
			+ ") where rnum >= ? ";
		UserBean bean = null;
		LinkedList<UserBean> ll = new LinkedList<UserBean>();
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(2, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(3, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(4, "%"+searchTerm.toLowerCase()+"%");
			psmt.setString(5, auth);
			psmt.setInt(6, (pageNumber * viewDataCount));
			psmt.setInt(7, (pageNumber - 1) * viewDataCount + 1);
			
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new UserBean();
				bean.setId(rs.getString("ID"));
				bean.setPwd(rs.getString("NPWD"));
				bean.setNames(rs.getString("NAMES"));
				bean.setEmail(rs.getString("EMAIL"));
				bean.setDepartment(rs.getString("DEPARTMENT"));
				bean.setAuth(rs.getString("AUTH"));
				bean.setRegist(rs.getTimestamp("REGIST_DATE"));
				ll.add(bean);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
		}
		return ll;
	}

	/**
	 * ���ο� ������ ����Ѵ�.
	 * 
	 * @param id
	 *            ���̵�
	 * @param pwd
	 *            ��й�ȣ
	 * @param names
	 *            �̸�
	 * @param email
	 *            �̸���
	 * @param department
	 *            �μ���
	 * @throws SQLException
	 */
	public static void regist(String id, String pwd, String names,
			String email, String department) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "insert into USER_INFO values(?, ?, ?, ?, ?, CURRENT_DATE, ?) ";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, id.trim());
			psmt.setString(2, names.trim());
			psmt.setString(3, email.trim());
			psmt.setString(4, department.trim());
			psmt.setString(5, UserAuthEnum.AUTH_WAITING.getAuth().trim());
			psmt.setString(6, SHAEncrypt.getEncrypt(pwd.trim()));
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
	 * ȸ�� ������ �����Ѵ�.
	 * 
	 * @param id
	 *            ���̵�
	 * @param pwd
	 *            ��й�ȣ
	 * @param names
	 *            �̸�
	 * @param email
	 *            �̸���
	 * @param department
	 *            �μ���
	 * @throws SQLException
	 */
	public static void modifyUserInfo(String id, String pwd, String names,
			String email, String department) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "update USER_INFO set NPWD = ?, NAMES= ?, EMAIL=? , DEPARTMENT=? where ID=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, SHAEncrypt.getEncrypt(pwd));
			psmt.setString(2, names);
			psmt.setString(3, email);
			psmt.setString(4, department);
			psmt.setString(5, id);
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
	 * ������ �����Ѵ�.
	 * 
	 * @param id
	 *            ���̵�
	 * @param auth
	 *            ����
	 * @throws SQLException
	 */
	public static void modifyAuth(String id, String auth) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "update USER_INFO set AUTH = ? where ID=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, auth);
			psmt.setString(2, id);
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
	 * ��й�ȣ�� ���̵�� �ʱ�ȭ �Ѵ�.
	 * 
	 * @param id
	 *            ���̵�
	 * @throws SQLException
	 */
	public static void modifyPWD(String id) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "update USER_INFO set NPWD = ? where ID=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			psmt.setString(1, SHAEncrypt.getEncrypt(id));
			psmt.setString(2, id);
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
	 * ������ �����Ѵ�.
	 * 
	 * @param ids
	 *            ���̵� ���
	 * @throws SQLException
	 */
	public static void deleteUser(String[] ids) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		String query = "delete from USER_INFO where ID=?";
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			psmt = conn.prepareStatement(query);
			for (String id : ids) {
				id = id.trim();
				psmt.setString(1, id);
				psmt.executeUpdate();
			}
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

}
