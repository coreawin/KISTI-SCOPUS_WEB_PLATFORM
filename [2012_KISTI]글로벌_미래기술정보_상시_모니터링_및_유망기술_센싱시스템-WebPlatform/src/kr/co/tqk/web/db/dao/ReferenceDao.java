package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.ReferenceBean;
import kr.co.tqk.web.util.UtilString;

/**
 * SCOPUS_REFERENCE table
 * 
 * @author 정승한
 * 
 */
public class ReferenceDao {

	/**
	 * SCOPUS_REFERENCE 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ReferenceBean> getScopusReference(String eid) {
		LinkedList<ReferenceBean> result = new LinkedList<ReferenceBean>();
		ReferenceBean bean = null;
		String query = "select * " + "	from SCOPUS_REFERENCE"
				+ "	where EID=?";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, eid);
			rs = psmt.executeQuery();
			LinkedHashMap<String, ReferenceBean> refSet = new LinkedHashMap<String, ReferenceBean>();
			while (rs.next()) {
				bean = new ReferenceBean(eid);
				bean.setRefEid(rs.getString("REF_EID"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setText(rs.getString("TEXT"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setSourceTitle(rs.getString("SOURCE_TITLE"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setFirstPage(rs.getString("FIRSTPAGE"));
				bean.setLastPage(rs.getString("LASTPAGE"));
				refSet.put(bean.getRefEid(), bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * SCOPUS_REFERENCE 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ReferenceBean> getScopusReference(HashSet<String> eidSet) {
		LinkedList<ReferenceBean> result = new LinkedList<ReferenceBean>();
		if(eidSet.size()==0) return result;
		ReferenceBean bean = null;
		String query = "select *  from SCOPUS_REFERENCE where eid in " + UtilString.whereINContidion(eidSet);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		LinkedHashMap<String, ReferenceBean> refMap = new LinkedHashMap<String, ReferenceBean>();
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			int idx = 1;
			for (String eid : eidSet) {
				psmt.setString(idx++, eid);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ReferenceBean(rs.getString("EID"));
				bean.setRefEid(rs.getString("REF_EID"));
				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				bean.setText(rs.getString("TEXT"));
				bean.setTitle(rs.getString("TITLE"));
				bean.setSourceTitle(rs.getString("SOURCE_TITLE"));
				bean.setIssue(rs.getString("ISSUE"));
				bean.setVolumn(rs.getString("VOLUMN"));
				bean.setFirstPage(rs.getString("FIRSTPAGE"));
				bean.setLastPage(rs.getString("LASTPAGE"));
				refMap.put(bean.getRefEid(), bean);
			}

			for (String refID : refMap.keySet()) {
				result.add(refMap.get(refID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

}
