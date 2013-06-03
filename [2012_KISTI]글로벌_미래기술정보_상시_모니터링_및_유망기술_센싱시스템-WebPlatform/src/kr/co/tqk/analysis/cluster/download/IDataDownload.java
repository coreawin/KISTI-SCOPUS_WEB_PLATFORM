package kr.co.tqk.analysis.cluster.download;

import java.sql.SQLException;
import java.util.Calendar;

public abstract class IDataDownload {

	int dataType = ALL_TYPE;
	int fromYear = 2001;
	int toYear = Calendar.getInstance().get(Calendar.YEAR);
	float ranking = 0.05f;
	String saveFilePath = null;

	/**
	 * �������չ�
	 */
	public static final int REF_TYPE = 0;
	/**
	 * �����ο�м�
	 */
	public static final int CIT_TYPE = 1;
	/**
	 * KISTI-Coupling
	 */
	public static final int ALL_TYPE = 2;

	/**
	 * DB ������ ���� �����͸� �����´�.
	 * 
	 * @throws SQLException
	 */
	abstract public void download() throws SQLException;

	/**
	 * �����͸� �ٿ�ε� ���� ���̺� ��
	 */
	abstract String getDownloadTableName();

	public String getRefQuery() {
		String query = "	"
				+ "	select eid, ref_eid from SCOPUS_REFERENCE where eid in ("
				+ "		select distinct eid from " + getDownloadTableName()
				+ " where (publication_year BETWEEN '" + fromYear + "' and '"
				+ toYear + "' ) and ranking <= '" + ranking
				+ "' and  cit_count > 0 and" + " @ )";
		return query;
	}

	public String getCitQuery() {
		String query = "	"
				+ "	select eid, cit_eid from SCOPUS_CITATION where eid in ("
				+ "		select distinct eid from " + getDownloadTableName()
				+ " where (publication_year BETWEEN '" + fromYear + "' and '"
				+ toYear + "' ) and ranking <= '" + ranking
				+ "' and  cit_count > 0 and" + " @ )";
		return query;
	}

	public String getKistiQuery() {
		String query = "	"
				+ "	select eid, ref_eid from SCOPUS_REFERENCE where eid in ("
				+ "		select distinct eid from " + getDownloadTableName()
				+ " where (publication_year BETWEEN '" + fromYear + "' and '"
				+ toYear + "' ) and ranking <= '" + ranking
				+ "' and  cit_count > 0 and" + " @ ) union all "
				+ "	select eid, cit_eid from SCOPUS_CITATION where eid in ("
				+ "		select distinct eid from " + getDownloadTableName()
				+ " where (publication_year BETWEEN '" + fromYear + "' and '"
				+ toYear + "' ) and ranking <= '" + ranking
				+ "' and  cit_count > 0 and" + " @ )";
		return query;
	}
}
