package kr.co.tqk.web.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.CitationBean;
import kr.co.tqk.web.util.UtilString;

/**
 * SCOPUS_CITATION table
 * 
 * @author 정승한
 * 
 */
public class CitationDao {

	/**
	 * SCOPUS_CITATION 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<CitationBean> getScopusCitation(String eid) {
		LinkedList<CitationBean> result = new LinkedList<CitationBean>();
		CitationBean bean = null;
		String query = "select EID, CIT_EID from SCOPUS_CITATION where EID=?";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, eid);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new CitationBean();
				bean.setEid(eid);
				bean.setCitEid(rs.getString("CIT_EID"));
//				bean.setPublicationYear(rs.getString("PUBLICATION_YEAR"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * SCOPUS_CITATION 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<CitationBean> getScopusCitation(
			HashSet<String> eidSet) {
		LinkedList<CitationBean> result = new LinkedList<CitationBean>();
		if(eidSet.size()==0) return result;
		CitationBean bean = null;
		String query = "select EID, CIT_EID from SCOPUS_CITATION where eid in " + UtilString.whereINContidion(eidSet);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		LinkedHashMap<String, CitationBean> citMap = new LinkedHashMap<String, CitationBean>();
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			int idx = 1;
			for (String eid : eidSet) {
				psmt.setString(idx++, eid);
			}
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new CitationBean();
				bean.setEid(rs.getString("EID"));
				bean.setCitEid(rs.getString("CIT_EID"));
				citMap.put(bean.getCitEid(), bean);
			}

			for (String citID : citMap.keySet()) {
				result.add(citMap.get(citID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}
	
}
