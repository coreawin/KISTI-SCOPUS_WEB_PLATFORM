package kr.co.tqk.analysis.cluster.download;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.LinkedHashMap;

import kr.co.tqk.db.ConnectionFactory;

/**
 * 
 * @author Á¤½ÂÇÑ
 * 
 */
public class PIssnDataDownload extends IDataDownload {

	LinkedHashMap<String, String> issnInfo = new LinkedHashMap<String, String>();

	public PIssnDataDownload(int year, float ranking, int _dataType,
			LinkedHashMap<String, String> asjcInfo, String saveFilePath) {
		this(year, Calendar.getInstance().get(Calendar.YEAR), ranking,
				_dataType, asjcInfo, saveFilePath);
	}

	public PIssnDataDownload(int fromYear, int toYear, float ranking,
			int _dataType, LinkedHashMap<String, String> issnInfo,
			String saveFilePath) {
		this.fromYear = fromYear;
		this.toYear = toYear;
		this.ranking = ranking;
		this.issnInfo = issnInfo;
		this.dataType = _dataType;
		this.saveFilePath = saveFilePath;
		File dir = new File(this.saveFilePath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
	}

	public void download() throws SQLException {

		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		BufferedWriter bw = null;
		try {
			ConnectionFactory cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();

			String query = "";
			for (String key : issnInfo.keySet()) {
				String asjcWhereCondition = issnInfo.get(key);
				if (asjcWhereCondition == null)
					continue;
				String fileName = key;
				if (dataType == REF_TYPE) {
					fileName += "_issn_reference_top" + String.valueOf(ranking)
							+ ".txt";
					query = getRefQuery().replaceAll("@", asjcWhereCondition);
				} else if (dataType == CIT_TYPE) {
					fileName += "_issn_citation_top" + String.valueOf(ranking)
							+ ".txt";
					query = getCitQuery().replaceAll("@", asjcWhereCondition);
				} else {
					fileName += "_issn_kisti_top" + String.valueOf(ranking)
							+ ".txt";
					query = getKistiQuery().replaceAll("@", asjcWhereCondition);
				}
				try {
					bw = new BufferedWriter(new FileWriter(new File(
							saveFilePath + fileName)));
				} catch (IOException e) {
					e.printStackTrace();
					continue;
				}

				System.out
						.println("======== Execute ISSN Data Type ========== ");
				psmt = conn.prepareStatement(query);
				rs = psmt.executeQuery();
				int cnt = 0;
				while (rs.next()) {
					String eid = rs.getString(1);
					String cit_ref_eid = rs.getString(2);
					try {
						bw.write(eid + "\t" + cit_ref_eid + "\n");
					} catch (IOException e) {
						e.printStackTrace();
					}
					if (cnt != 0 && cnt % 100000 == 0) {
						System.out.println(key + " : write " + cnt);
					}
					cnt++;
				}
				System.out.println(key + " : write success fileName : "
						+ fileName);
				try {
					bw.flush();
					bw.close();
					bw = null;
				} catch (IOException e) {
					e.printStackTrace();
					continue;
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
			if (conn != null)
				conn.close();
			if (bw != null)
				try {
					bw.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}

	public String getDownloadTableName() {
		return "SCOPUS_TOP_ISSN_CIT";
	}
}
