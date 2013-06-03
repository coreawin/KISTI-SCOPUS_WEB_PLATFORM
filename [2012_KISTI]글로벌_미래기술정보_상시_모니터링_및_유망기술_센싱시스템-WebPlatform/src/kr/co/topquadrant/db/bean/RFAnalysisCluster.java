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
	 * 페이징 전체 로우 갯수
	 */
	int totalCount;
	/**
	 * 전체 페이지 수.
	 */
	int totalPage;
	/**
	 * 핵심논문 수
	 */
	int documentCount;
	/**
	 * 핵심논문의 참조논문 수
	 */
	int documentReferenceCount;
	/**
	 * 핵심논문당 참조논문 수
	 */
	float referenceCountPerDocument;
	/**
	 * 핵심논문의 평균연도
	 */
	float averagePubYearDocument;
	/**
	 * 핵심논문이 인용하는 논문의 평균연도
	 */
	float averagePubYearCitationDocument;
	/**
	 * 업데이트 플래그
	 */
	int updateFlag;
	/**
	 * 등록일
	 */
	Timestamp reg_date;

	/**
	 * JSON 데이터.
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

		// ajax상에서 json으로 변경시 불필요한 데이터의 통신을 막기위해 이 항목을 빈문자열로 처리한다.
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
