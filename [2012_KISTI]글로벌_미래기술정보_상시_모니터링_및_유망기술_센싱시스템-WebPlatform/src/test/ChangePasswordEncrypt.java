package test;

import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.LinkedList;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.UserBean;
import kr.co.tqk.web.db.dao.UserDao;

public class ChangePasswordEncrypt {
	
	public static void main(String[] args) throws SQLException{
		Connection conn = null;
		PreparedStatement psmt = null;
		try{

//			LinkedList<UserBean> list = UserDao.selectAll();

//			FileOutputStream fos = new FileOutputStream("./userinfo.ser");
//			ObjectOutputStream oos = new ObjectOutputStream(fos);
//			oos.writeObject(list);
//			oos.flush();
//			oos.close();
//			fos.close();
			
			FileInputStream fis = new FileInputStream("./userinfo.ser");
			ObjectInputStream ois = new ObjectInputStream(fis);
			LinkedList<UserBean> list = (LinkedList<UserBean>) ois.readObject();
			
			for(UserBean ub : list){
				System.out.println(ub.getId() +"\t" + ub.getPwd());
			}
			System.out.println(list.size());
			
			
//			conn  = ConnectionFactory.getInstance().getConnection();
//			String updateQuery = "update USER_INFO set NPWD=? where ID=?";
//			psmt = conn.prepareStatement(updateQuery);
//			for(UserBean ub : list){
//				psmt.clearParameters();
//				psmt.setString(1, SHAEncrypt.getEncrypt(ub.getPwd().trim()));
//				psmt.setString(2, ub.getId());
//				psmt.addBatch();
//			}
//			psmt.executeBatch();
//			conn.commit();
			UserBean ub = UserDao.login("neon", "neon");
			System.out.println(ub);
			System.out.println("¿Ï·á" + conn);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnectionFactory.getInstance().close(conn);
		}
	}

}
