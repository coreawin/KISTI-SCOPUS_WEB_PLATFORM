package kr.co.topquadrant.db.bean;

import java.sql.Timestamp;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import kr.co.topquadrant.util.MapValueSort;

import com.google.gson.Gson;

public class RFAnalysisCluster {

	int seq;
	int consecutiveNumber;

	/**
	 * ����¡ ��ü �ο� ����
	 */
	int totalCount;
	/**
	 * ��ü ������ ��.
	 */
	int totalPage;
	/**
	 * �ٽɳ� ��
	 */
	int documentCount;
	/**
	 * �ٽɳ��� ������ ��
	 */
	int documentReferenceCount;
	/**
	 * �ٽɳ��� ������ ��
	 */
	float referenceCountPerDocument;
	/**
	 * �ٽɳ��� ��տ���
	 */
	float averagePubYearDocument;
	/**
	 * �ٽɳ��� �ο��ϴ� ���� ��տ���
	 */
	float averagePubYearCitationDocument;
	/**
	 * ������Ʈ �÷���
	 */
	int updateFlag;
	/**
	 * �����
	 */
	Timestamp reg_date;

	/**
	 * JSON ������.
	 */
	String json;

	String clusterNO;

	String keywordList;
	String largeASJC;
	String asjc;

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getConsecutiveNumber() {
		return consecutiveNumber;
	}

	public void setConsecutiveNumber(int consecutiveNumber) {
		this.consecutiveNumber = consecutiveNumber;
	}

	public int getDocumentCount() {
		return documentCount;
	}

	public void setDocumentCount(int documentCount) {
		this.documentCount = documentCount;
	}

	public int getDocumentReferenceCount() {
		return documentReferenceCount;
	}

	public void setDocumentReferenceCount(int documentReferenceCount) {
		this.documentReferenceCount = documentReferenceCount;
	}

	public float getAveragePubYearDocument() {
		return averagePubYearDocument;
	}

	public void setAveragePubYearDocument(float averagePubYearDocument) {
		this.averagePubYearDocument = averagePubYearDocument;
	}

	public float getAveragePubYearCitationDocument() {
		return averagePubYearCitationDocument;
	}

	public void setAveragePubYearCitationDocument(float averagePubYearCitationDocument) {
		this.averagePubYearCitationDocument = averagePubYearCitationDocument;
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

	public float getReferenceCountPerDocument() {
		return referenceCountPerDocument;
	}

	public void setReferenceCountPerDocument(float referenceCountPerDocument) {
		this.referenceCountPerDocument = referenceCountPerDocument;
	}

	public String getJson() {
		return json;
	}

	public void setJson(String json) {
		this.json = json;
		ClusterDocument cd = new Gson().fromJson(this.json, ClusterDocument.class);
		largeASJC = "";
		// SortedSet<String> largeASJCKey = new
		// TreeSet<String>(cd.getLargeAsjcInfo().keySet());
		Set<String> largeASJCKey = cd.getLargeAsjcInfo().keySet();
		int cnt = 0;
		Pattern p = Pattern.compile(".*?(?=\\()");
		for (String asjc : largeASJCKey) {
			Matcher m = p.matcher(asjc);
			while (m.find()) {
				largeASJC += m.group().trim();
				if ((largeASJCKey.size() - 1 == cnt)) {
					largeASJC += "";
				} else {
					largeASJC += ",";
				}
				break;
			}
			cnt++;
		}
		Map<String, Integer> keywordMapData = cd.getKeywordInfo();
		keywordMapData = MapValueSort.topValueData(keywordMapData, 10);

		Set<String> keywordSet = keywordMapData.keySet();
		cnt = 0;
		keywordList = "";
		for (String kw : keywordSet) {
			keywordList += kw.trim();
			if ((keywordSet.size() - 1 == cnt)) {
				keywordList += "";
			} else {
				keywordList += ";";
			}
			cnt++;
		}

		// ajax�󿡼� json���� ����� ���ʿ��� �������� ����� �������� �� �׸��� ���ڿ��� ó���Ѵ�.
		this.json = "";
	}

	public String getKeywordList() {
		return keywordList;
	}

	public String getLargeASJC() {
		return largeASJC;
	}

	public String getAsjc() {
		return asjc;
	}

	public String getClusterNO() {
		return clusterNO;
	}

	public void setClusterNO(String clusterNO) {
		this.clusterNO = clusterNO;
	}

}
