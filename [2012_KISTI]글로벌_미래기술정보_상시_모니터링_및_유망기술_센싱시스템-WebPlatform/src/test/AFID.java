/**
 * 
 */
package test;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.util.UtilSQL;

/**
 * @author coreawin
 * @sinse 2012. 10. 11. 
 * @version 1.0
 * @history 2012. 10. 11. : 최초 작성 <br>
 *
 */
public class AFID {
	
	public static List<Set<String>> fileRead() throws Exception{
		List<Set<String>> result = new ArrayList<Set<String>>();
		Set<String> set = new HashSet<String>();
		BufferedReader br = new BufferedReader(new FileReader("j:\\afids.txt"));
		String line = "";
		int cnt = 0;
		while((line = br.readLine())!=null){
			if(cnt > 500){
				result.add(set);
				set = new HashSet<String>();
				cnt = 0;
			}
			set.add(line.trim());
			cnt++;
		}
		result.add(set);
		return result;
	}
	
	public static void main(String[] args) throws Exception{
		List<Set<String>> list = fileRead();
		System.out.println(list.size());
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * from");
		sb.append(" (SELECT AFID, COUNTRY_CODE, COUNT(country_code) AS cnt"); 
		sb.append(" FROM SCOPUS_AFFILATION_GROUP ");
		sb.append(" WHERE AFID in (%s)");
		sb.append(" GROUP BY AFID, COUNTRY_CODE) r");
		sb.append(" WHERE ROWNUM < 10 and cnt > 0");
		sb.append(" ORDER BY afid, r.cnt DESC");
		
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		BufferedWriter bw = new BufferedWriter(new FileWriter("j:\\afid_country.txt"));
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			for(Set<String> set : list){
				String query = UtilSQL.makeQuery(sb.toString(), set.size());
				System.out.println(set.size());
				System.out.println(query);
				psmt = conn.prepareStatement(query);
				int idx = 1;
				for(String s : set){
					psmt.setString(idx++, s);
				}
				rs = psmt.executeQuery();
				System.out.println("쿼리 결과 retrieve");
				while(rs.next()){
					String afid = rs.getString(1);
					String country_code = rs.getString(2);
					int cnt = rs.getInt(3);
					bw.append(afid);
					bw.append(",");
					bw.append(country_code);
					System.out.println(afid +"\t" + country_code);
					bw.append(",");
					bw.append(String.valueOf(cnt));
					bw.append("\n");
				}
				System.out.println("file flush");
				bw.flush();
				psmt.clearParameters();
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(rs, psmt, conn);
			if(bw!=null){
				bw.flush();
				bw.close();
			}
		}
	}

}
