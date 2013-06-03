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
public class SourceID {
	
	public static List<Set<String>> fileRead() throws Exception{
		List<Set<String>> result = new ArrayList<Set<String>>();
		Set<String> set = new HashSet<String>();
		BufferedReader br = new BufferedReader(new FileReader("j:\\sourceID.txt"));
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
		String delim = "`";
		List<Set<String>> list = fileRead();
		System.out.println(list.size());
		StringBuffer sb = new StringBuffer();
		sb.append(" SELECT * "); 
		sb.append(" FROM SCOPUS_SOURCE_info ");
		sb.append(" WHERE SOURCE_ID in (%s)");
		
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		BufferedWriter bw = new BufferedWriter(new FileWriter("j:\\sourceIDResult.txt"));
		try {
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			bw.append("SOURCE_ID");
			bw.append(delim);
			bw.append("SOURCE_TITLE");
			bw.append(delim);
			bw.append("P_ISSN");
			bw.append(delim);
			bw.append("E_ISSN");
			bw.append("\n");
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
					String SOURCE_ID = rs.getString("SOURCE_ID");
					String SOURCE_TITLE = rs.getString("SOURCE_TITLE");
					String P_ISSN = rs.getString("P_ISSN");
					String E_ISSN = rs.getString("E_ISSN");
					bw.append(SOURCE_ID);
					bw.append(delim);
					bw.append(SOURCE_TITLE);
					bw.append(delim);
					bw.append(P_ISSN);
					bw.append(delim);
					bw.append(E_ISSN);
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
