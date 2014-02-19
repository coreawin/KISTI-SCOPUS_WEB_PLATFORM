package test;

import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.util.MakeHCPTree;
import kr.co.tqk.db.ConnectionFactory;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class TestHCP {

	public static List<HCP> getHCP() {
		List<HCP> r = new LinkedList<HCP>();
		String query = "select " + "asjc_code," + "PUBLICATION_YEAR," + "total," + "document_count," + "threshold" + " from SCOPUS_TOP_ASJCMIN_CIT_3";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				HCP h = new HCP();
				h.setAsjc_code(rs.getString("asjc_code"));
				h.setPublication_year(rs.getString("PUBLICATION_YEAR"));
				h.setTotal(rs.getInt("total"));
				h.setDocument_count(rs.getInt("document_count"));
				h.setThreshold(rs.getInt("threshold"));
				r.add(h);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return r;
	}

	public static void main(String[] args) {
		List<HCP> data = TestHCP.getHCP();
		for (HCP h : data) {
			//System.out.println(h.getAsjc_code() + "\t" + h.getTotal() +"\t" + h.getPublication_year());
		}
		
		String dataJson =new Gson().toJson(data);
		Type typeOfT = new TypeToken<List<HCP>>(){}.getType();
		List<HCP> hcpList = new Gson().fromJson(dataJson, typeOfT);

		for (HCP h : hcpList) {
			System.out.println(h.getAsjc_code() + "\t" + h.getTotal() +"\t" + h.getPublication_year());
		}
		
		MakeHCPTree t = new MakeHCPTree(hcpList);
	}

}
