package kr.co.tqk.analysis.report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.util.UtilString;

import org.apache.commons.collections.map.MultiValueMap;

/**
 * @author 정승한
 * 
 */
public class GetReportData {

	public static void main(String[] args) {
		String a = "78650278736,33750373807,0037009752,76349085173,77953081463,";
		// String a =
		// "33748551691,18144386197,49149087559,10644259535,44249083545,47249132510,33745060995,33847764010,69549126510,75149134744";
		HashSet<String> eidSet = new HashSet<String>();
		for (String eid : a.split(",")) {
			eidSet.add(eid.trim());
		}
		// eidSet.add("33646271105");
		// eidSet.add("0037832748");
		// eidSet.add("74849114506");
		// eidSet.add("42649132824");
		// eidSet.add("33846380266");
		// eidSet.add("21244460708");
		// eidSet.add("33947517312");
		GetReportData grd = new GetReportData(eidSet);
	}

	private StringBuffer whereCondition = new StringBuffer();
	private GenerateReportData grd = null;
	private Connection conn = null;

	public GetReportData(HashSet<String> eidSet) {
		for (int idx = 0; idx < eidSet.size(); idx++) {
			if (idx == 0) {
				whereCondition.append(" where (");
			}
			if ((eidSet.size() - 1) == idx) {
				whereCondition.append(" eid=? ");
			} else {
				whereCondition.append(" eid=? or ");
			}
		}
		whereCondition.append(" ) ");
		try {
			grd = new GenerateReportData(getDocumentInfo(eidSet),
					getLargeAsjcInfo());
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public GetReportData(Connection _conn , HashSet<String> eidSet) {
		this.conn = _conn;
		for (int idx = 0; idx < eidSet.size(); idx++) {
			if (idx == 0) {
				whereCondition.append(" where (");
			}
			if ((eidSet.size() - 1) == idx) {
				whereCondition.append(" eid=? ");
			} else {
				whereCondition.append(" eid=? or ");
			}
		}
		whereCondition.append(" ) ");
		try {
			grd = new GenerateReportData(getDocumentInfo(eidSet),
					getLargeAsjcInfo());
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public GetReportData(HashSet<String> eidSet,
			HashMap<String, String> largeAsjcInfo) {
		// TODO Auto-generated constructor stub
	}

	public ReportBean getReportData() {
		return grd.getReportData();
	}

	HashMap<String, String> tmpLargeAsjcDataMap = new HashMap<String, String>();

	/**
	 * 대분류 한국어 정보를 얻어온다.<br>
	 * 
	 * @return
	 */
	public HashMap<String, String> getLargeAsjcInfo() {
		return tmpLargeAsjcDataMap;
	}

	/**
	 * @param eidSet
	 * @throws SQLException
	 */
	public LinkedHashMap<String, DocumentBean> getDocumentInfo(
			HashSet<String> eidSet) throws SQLException {
		LinkedHashMap<String, DocumentBean> data = new LinkedHashMap<String, DocumentBean>();

		/*
		 * 문서의 기본 정보를 얻어오는 쿼리
		 */
		String documentQuery = "select eid, title, publication_year, cit_count from SCOPUS_DOCUMENT "
				+ whereCondition.toString() + "order by cit_count desc";

		Connection _conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			if(conn==null){
				ConnectionFactory cf = ConnectionFactory.getInstance();
				_conn = cf.getConnection();
				conn = _conn;
				System.out.println(" 내부에서 Connection 연결.");
			}
			psmt = conn.prepareStatement(documentQuery);
			int cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			HashSet<String> topCitCountEidList = new HashSet<String>();
			int prevCitationCount = -1;
			while (rs.next()) {
				String eid = rs.getString("EID");
				String title = rs.getString("TITLE");
				String publicationYear = rs.getString("PUBLICATION_YEAR");
				int citationCount = rs.getInt("CIT_COUNT");
				
				if(citationCount >= prevCitationCount){
					topCitCountEidList.add(eid.trim());
					prevCitationCount = citationCount;
				}
				DocumentBean bean = new DocumentBean();
				bean.setEid(eid);
				bean.setTitle(title);
				bean.setPublicationYear(publicationYear);
				bean.setCitationCount(citationCount);
				data.put(eid, bean);
			}
			rs.close();
			psmt.close();

			/*
			 * ASJC 대분류 정보를 얻어오는 쿼리
			 */
			String largeAsjcQuery = "select asjc_code, description from SCOPUS_ASJC_KOREA where ASJC_CODE like '%00'";

			psmt = conn.prepareStatement(largeAsjcQuery);
			rs = psmt.executeQuery();
			while (rs.next()) {
				String asjcCode = rs.getString("asjc_code");
				String description = rs.getString("description");
				tmpLargeAsjcDataMap.put(asjcCode,
						description.replaceAll(" \\(전체\\)", ""));
			}
			rs.close();
			psmt.close();
			/*
			 * 문서의 분류 정보를 얻어오는 쿼리
			 */
			String asjcQuery = "select eid, cls.asjc_code, description from SCOPUS_CLASSIFICATION_ASJC cls, SCOPUS_ASJC_KOREA asjc "
					+ whereCondition.toString()
					+ " and (cls.asjc_code=asjc.asjc_code)";

			psmt = conn.prepareStatement(asjcQuery);
			cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			HashMap<String, HashSet<String>> tmpDataMap = new HashMap<String, HashSet<String>>();
			HashSet<String> tmpDataSet = null;
			while (rs.next()) {
				String eid = rs.getString("EID");
				String asjcCode = rs.getString("asjc_code");
				String description = rs.getString("description");
				if (tmpDataMap.containsKey(eid)) {
					tmpDataSet = tmpDataMap.get(eid);
				} else {
					tmpDataSet = new HashSet<String>();
				}

				tmpDataSet.add(asjcCode + ":" + description);
				tmpDataMap.put(eid, tmpDataSet);
			}
			rs.close();
			psmt.close();

			for (String eid : tmpDataMap.keySet()) {
				tmpDataSet = tmpDataMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setAsjcCodeList(tmpDataSet);
					data.put(eid, bean);
				}
			}

			/*
			 * 문서의 키워드류 정보를 얻어오는 쿼리
			 */
			String keywordQuery = "select eid, keyword from SCOPUS_AUTHOR_KEYWORD "
					+ whereCondition.toString();
			psmt = conn.prepareStatement(keywordQuery);
			cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			tmpDataMap = new HashMap<String, HashSet<String>>();
			while (rs.next()) {
				String eid = rs.getString("EID");
				String keyword = rs.getString("keyword");
				if (tmpDataMap.containsKey(eid)) {
					tmpDataSet = tmpDataMap.get(eid);
				} else {
					tmpDataSet = new HashSet<String>();
				}
				tmpDataSet.add(keyword);
				tmpDataMap.put(eid, tmpDataSet);
			}
			rs.close();
			psmt.close();

			for (String eid : tmpDataMap.keySet()) {
				tmpDataSet = tmpDataMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setKeywordList(tmpDataSet);
					data.put(eid, bean);
				}
			}

			/*
			 * 문서의 인용 정보를 얻어오는 쿼리
			 */
			String citationQuery = "select /*+ ordered use_nl(sc) use_nl(sd) */ sc.eid, sc.cit_eid, sd.publication_year from SCOPUS_CITATION sc, SCOPUS_DOCUMENT sd "
					+ whereCondition.toString().replaceAll("eid", "sc.eid")
					+ " and sc.cit_eid = sd.eid ";
			psmt = conn.prepareStatement(citationQuery);
			cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			HashMap<String, HashMap<String, String>> tmpCitMap = new HashMap<String, HashMap<String, String>>();
			HashMap<String, String> tmpCitDataMap = null;
			// System.out.println(citationQuery);
			while (rs.next()) {
				String eid = rs.getString("EID");
				String cit_eid = rs.getString("cit_eid");
				String publication_year = rs.getString("publication_year");
				// System.out.println(eid +"\t" + cit_eid +"\t" +
				// publication_year);
				if (tmpCitMap.containsKey(eid)) {
					tmpCitDataMap = tmpCitMap.get(eid);
				} else {
					tmpCitDataMap = new HashMap<String, String>();
				}
				tmpCitDataMap.put(cit_eid, publication_year);
				tmpCitMap.put(eid, tmpCitDataMap);
			}
			rs.close();
			psmt.close();

			for (String eid : tmpCitMap.keySet()) {
				tmpCitDataMap = tmpCitMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setCitationInfo(tmpCitDataMap);
					data.put(eid, bean);
				}
			}

			/*
			 * 문서의 한국 기관 정보를 얻어오는 쿼리
			 */
			String koreaOrgQuery = "select distinct aa.eid, country_code, org_name, AUTHOR_NAME,DELEGATE_AUTHOR_NAME  ";
			koreaOrgQuery += " from ";
			koreaOrgQuery += "    (select eid, country_code, org_name from SCOPUS_AFFILATION_GROUP  "
					+ whereCondition.toString()
					+ " and country_code='KOR' ) aa, ";
			koreaOrgQuery += "     scopus_author aut, ";
			koreaOrgQuery += "     scopus_author_group grp ";
			koreaOrgQuery += " where ";
			koreaOrgQuery += " grp.eid = aa.eid and ";
			koreaOrgQuery += " grp.author_seq = aut.author_seq ";
			koreaOrgQuery += " and country_code ='KOR' ";
			psmt = conn.prepareStatement(koreaOrgQuery);
			cnt = 0;
			for (String eid : eidSet) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			HashMap<String, MultiValueMap> tmpOrgMap = new HashMap<String, MultiValueMap>();
			MultiValueMap mvm = null;

			while (rs.next()) {
				String eid = rs.getString("EID");
				String orgName = rs.getString("org_name");
				String authorName = rs.getString("AUTHOR_NAME");
				String delegateName = rs.getString("DELEGATE_AUTHOR_NAME");
				if (tmpOrgMap.containsKey(eid)) {
					mvm = tmpOrgMap.get(eid);
				} else {
					mvm = new MultiValueMap();
				}
				mvm.put(orgName, authorName + ":" + delegateName);
				tmpOrgMap.put(eid, mvm);
			}
			rs.close();
			psmt.close();
			for (String eid : tmpOrgMap.keySet()) {
				mvm = tmpOrgMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setKoreaOrgAndAuthorNameInfo(mvm);
					data.put(eid, bean);
				}
			}
			
			/*
			 * 인용문서가 가장 많은 문서의 기관 및 국가 정보를 얻어오는 쿼리
			 */
			StringBuffer topCitationEidWhereCondition = new StringBuffer();
			for (int idx = 0; idx < topCitCountEidList.size(); idx++) {
				if (idx == 0) {
					topCitationEidWhereCondition.append(" where (");
				}
				if ((topCitCountEidList.size() - 1) == idx) {
					topCitationEidWhereCondition.append(" eid=? ");
				} else {
					topCitationEidWhereCondition.append(" eid=? or ");
				}
			}
			topCitationEidWhereCondition.append(" ) ");
			String topCitationOrgQuery = "select distinct aa.eid, country_code, org_name, AUTHOR_NAME,DELEGATE_AUTHOR_NAME  ";
			topCitationOrgQuery += " from ";
			topCitationOrgQuery += "    (select eid, country_code, org_name from SCOPUS_AFFILATION_GROUP  "
				+ topCitationEidWhereCondition.toString()
				+ " aa, ";
			topCitationOrgQuery += "     scopus_author aut, ";
			topCitationOrgQuery += "     scopus_author_group grp ";
			topCitationOrgQuery += " where ";
			topCitationOrgQuery += " grp.eid = aa.eid and ";
			topCitationOrgQuery += " grp.author_seq = aut.author_seq ";
			psmt = conn.prepareStatement(topCitationOrgQuery);
			cnt = 0;
			System.out.println(topCitationOrgQuery);
			for (String eid : topCitCountEidList) {
				psmt.setString(++cnt, eid);
			}
			rs = psmt.executeQuery();
			HashMap<String, HashMap<String, String>> tmpTopCitOrgMap = new HashMap<String, HashMap<String, String>>();
			HashMap<String, String> tmpTopCit  = null;
			HashMap<String, String> tmpMap = new HashMap<String, String>();
			while (rs.next()) {
				String eid = rs.getString("EID");
				String orgName = rs.getString("org_name");
//				String authorName = rs.getString("AUTHOR_NAME");
//				String delegateName = rs.getString("DELEGATE_AUTHOR_NAME");
				String countryCode = rs.getString("COUNTRY_CODE");
				if (tmpOrgMap.containsKey(eid)) {
					mvm = tmpOrgMap.get(eid);
				} else {
					mvm = new MultiValueMap();
				}
				tmpMap.put(orgName, UtilString.nullCkeck(countryCode, true));
				tmpTopCitOrgMap.put(eid, tmpMap);
			}
			rs.close();
			psmt.close();
			for (String eid : tmpTopCitOrgMap.keySet()) {
				tmpTopCit = tmpTopCitOrgMap.get(eid);
				DocumentBean bean = data.get(eid);
				if (bean != null) {
					bean.setTopCitationCountOrgAndAuthorNameInfo(tmpTopCit);
					data.put(eid, bean);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.exit(-1);
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
}
