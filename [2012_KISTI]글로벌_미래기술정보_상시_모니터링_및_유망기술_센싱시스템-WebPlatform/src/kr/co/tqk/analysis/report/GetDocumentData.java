package kr.co.tqk.analysis.report;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;

import kr.co.tqk.db.ConnectionFactory;

import org.apache.commons.collections.map.MultiValueMap;

public class GetDocumentData {
	
	public static void main(String[] args) throws SQLException{
		LinkedHashSet<String> eSet = new LinkedHashSet<String>();
		eSet.add("33847724345");
		eSet.add("13844281243");
		eSet.add("33646419005");
		eSet.add("33751229268");
		eSet.add("31044452879");
		GetDocumentData gdd = new GetDocumentData(eSet);
		HashMap<String, DocumentBean> dbSet = gdd.getDocumentInfo();
		for(String eid : dbSet.keySet()){
			DocumentBean db = dbSet.get(eid);
			MultiValueMap mvmDB = db.getKoreaOrgAndAuthorNameInfo();
			for(Object okey : mvmDB.keySet()){
				System.out.print(okey +"\t");
				List<String> list = (List<String>)mvmDB.get(okey);
				for(String s : list){
					System.out.print("("+ s + ")");
				}
				System.out.println();
			}
		}
	}

	LinkedHashSet<String> eidSet = null;
	Connection conn = null;
	ConnectionFactory cf = ConnectionFactory.getInstance();
	
	public GetDocumentData(LinkedHashSet<String> eidSet) {
		this.eidSet = eidSet;
	}
	
	public GetDocumentData(Connection conn, LinkedHashSet<String> eidSet) {
		this.conn = conn;
		this.eidSet = eidSet;
	}

	public HashMap<String, DocumentBean> getDocumentInfo() throws SQLException {
		/*
		 * 문서의 기본 정보를 얻어오는 쿼리
		 */
		String documentQuery = "select eid, title, abstract, publication_year, ref_count, cit_count, source_title from SCOPUS_DOCUMENT d, SCOPUS_SOURCE_INFO s where eid = ? and d.source_id = s.source_id";

		/*
		 * 문서의 한국 기관 정보를 얻어오는 쿼리
		 */
		String koreaOrgQuery = "select distinct aa.eid, country_code, org_name, AUTHOR_NAME,DELEGATE_AUTHOR_NAME  ";
		koreaOrgQuery += " from ";
		koreaOrgQuery += "    (select eid, country_code, org_name from SCOPUS_AFFILATION_GROUP  where eid=?) aa, ";
		koreaOrgQuery += "     scopus_author aut, ";
		koreaOrgQuery += "     scopus_author_group grp ";
		koreaOrgQuery += " where ";
		koreaOrgQuery += " grp.eid = aa.eid and ";
		koreaOrgQuery += " grp.author_seq = aut.author_seq ";

		Connection _conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		HashMap<String, DocumentBean> data = new LinkedHashMap<String, DocumentBean>();
		try {
			if(conn==null){
				conn = cf.getConnection();
			}
			
			if(conn.isClosed()){
				conn = cf.getConnection();
			}
			
			psmt = conn.prepareStatement(documentQuery);
			int cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				while (rs.next()) {
					String title = rs.getString("TITLE");
					String abs = readClob(rs.getClob("ABSTRACT"));
					String publicationYear = rs.getString("PUBLICATION_YEAR");
					String sourceTitle = rs.getString("source_title");
					int referenceCount = rs.getInt("REF_COUNT");
					int citationCount = rs.getInt("CIT_COUNT");

					DocumentBean bean = new DocumentBean();
					bean.setEid(eid);
					bean.setTitle(title);
					bean.setAbs(abs);
					bean.setReferenceCount(referenceCount);
					bean.setPublicationYear(publicationYear);
					bean.setCitationCount(citationCount);
					bean.setSourceTitle(sourceTitle);
					data.put(eid, bean);
				}
				rs.close();
				if (cnt != 0 && cnt % 100 == 0) {
					System.out.println("문서 기본 정보 수집 진행율 " + (cnt) + " / "
							+ eidSet.size());
				}
				cnt++;
			}
			psmt.close();

			psmt = conn.prepareStatement(koreaOrgQuery);
			HashMap<String, MultiValueMap> tmpOrgMap = new HashMap<String, MultiValueMap>();
			MultiValueMap mvm = null;
			cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(1, eid);
				rs = psmt.executeQuery();
				while (rs.next()) {
					String countryCode = rs.getString("country_code");
					String orgName = rs.getString("org_name");
					String authorName = rs.getString("AUTHOR_NAME");
					String delegateName = rs.getString("DELEGATE_AUTHOR_NAME");
					if (tmpOrgMap.containsKey(eid)) {
						mvm = tmpOrgMap.get(eid);
					} else {
						mvm = new MultiValueMap();
					}
					mvm.put(orgName +":" + countryCode, authorName + ":" + delegateName);
					tmpOrgMap.put(eid, mvm);
				}
				rs.close();
				
				if (cnt != 0 && cnt % 100 == 0) {
					System.out.println("문서 국가 정보 수집 진행율 " + (cnt) + " / "
							+ eidSet.size());
				}
				cnt++;
			}
			psmt.close();
			for (String eid : tmpOrgMap.keySet()) {
				mvm = tmpOrgMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setKoreaOrgAndAuthorNameInfo(mvm);
					data.put(eid, bean);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
			if (_conn != null)
				_conn.close();
		}
		return data;
	}

	public String readClob(Clob lob) throws SQLException, IOException {
		StringBuffer sb = new StringBuffer();
		if (lob != null) {
			BufferedReader strDd = new BufferedReader(lob.getCharacterStream());
			String sLineData = null;
			int i = 0;
			while (true) {
				sLineData = strDd.readLine();
				if (sLineData == null)
					break;
				if (i != 0)
					sb.append("\r\n");
				sb.append(sLineData);
				i++;
			}
		} else {
			sb.append("");
		}
		return sb.toString();
	}

}
