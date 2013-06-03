package kr.co.topquadrant.db.bean;

import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

public class ClusterDocument {

	String clusterID;

	int seq, consecutiveNumber, updateFlag;
	/**
	 * 핵심논문의 개수.
	 */
	int documentCount = 0;
	/**
	 * 핵심논문 평균연도.
	 */
	float averagePubYearDocument = 0f;
	/**
	 * 핵심논문의 인용논문 평균연도.
	 */
	float averagePubYearCiationDoc = 0f;

	/**
	 * 핵심논문 SCOPUS 제목 (eid, title)
	 */
	Map<String, String> documentTitles = new LinkedHashMap<String, String>();
	/**
	 * 핵심논문 SCOPUS 발행연도 (eid, publication_year)
	 */
	Map<String, Integer> documentPubYear = new LinkedHashMap<String, Integer>();
	/**
	 * 인용논문 SCOPUS 발행연도 (cit_eid, publication_year)
	 */
	Map<String, Integer> documentCitationPubYear = new LinkedHashMap<String, Integer>();
	/**
	 * 핵심논문의 피인용논문수 (eid, ref_eid count)
	 */
	Map<String, Integer> documentReferenceCount = new LinkedHashMap<String, Integer>();
	/**
	 * 핵심논문의 인용논문수 (eid, cit_eid count)
	 */
	Map<String, Integer> documentCitationCount = new LinkedHashMap<String, Integer>();

	/**
	 * 분류코드 정보 (asjc정보, %빈도)
	 */
	Map<String, Float> asjcInfo = new LinkedHashMap<String, Float>();

	/**
	 * 대분류코드 정보 (asjc정보, %빈도)
	 */
	Map<String, Float> largeAsjcInfo = new LinkedHashMap<String, Float>();

	/**
	 * 키워드 정보 (keyword정보, 빈도)
	 */
	Map<String, Integer> keywordInfo = new LinkedHashMap<String, Integer>();

	/**
	 * 국내논문 정보 (eid, title)
	 */
	Map<String, String> koreaDocumentEidSet = new LinkedHashMap<String, String>();
	
	/**
	 * 총 분석 대상 문서수.<OPTIONAL>
	 */
	int totalAnaylsysDocument = 0;
	
	/**
	 * 핵심논문의 피인용수
	 */
	int referenceCount = 0;

	/**
	 * 핵심논문의 인용수
	 */
	int citationCount = 0;

	/**
	 * 핵심논문 당 피인용수
	 */
	float referencePerCount = 0;

	/**
	 * 핵심논문 당 인용수
	 */
	float citationPerCount = 0;

	public Map<String, String> getDocumentTitles() {
		return documentTitles;
	}

	public Map<String, Integer> getDocumentCitationCount() {
		return documentCitationCount;
	}

	public int getReferenceCount() {
		Collection<Integer> coll = documentReferenceCount.values();
		int total = 0;
		for(int c : coll){
			total += c;
		}
		this.referenceCount = total;
		return this.referenceCount;
	}

	public int getCitationCount() {
		return citationCount;
	}

	public float getReferencePerCount() throws Exception {
		this.referencePerCount = getReferenceCount() / getDocumentCount();
		return referencePerCount;
	}

	public float getCitationPerCount() {
		return citationPerCount;
	}

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getConsecutiveNumber() {
		return consecutiveNumber;
	}

	public void setConsecutiveNumber(int consecutiveNumber) {
		this.consecutiveNumber = consecutiveNumber;
	}

	public Map<String, String> getDocumentList() {
		return documentTitles;
	}

	public void setDocumentList(String documentID) {
		this.documentTitles.put(documentID, "");
	}

	public void setDocumentList(String documentID, String title) {
		this.documentTitles.put(documentID, title);
	}

	public Map<String, Integer> getDocumentPubYear() {
		return documentPubYear;
	}

	public void setDocumentPubYear(String documentID) {
		this.documentPubYear.put(documentID, 0);
	}

	public void setDocumentPubYear(String documentID, int publicationYear) {
		this.documentPubYear.put(documentID, publicationYear);
	}

	public Map<String, Integer> getDocumentCitationPubYear() {
		return documentCitationPubYear;
	}

	public void setDocumentCitationPubYear(String documentID) {
		this.documentCitationPubYear.put(documentID, 0);
	}

	public void setDocumentCitationPubYear(String documentID, int publicationYear) {
		this.documentCitationPubYear.put(documentID, publicationYear);
	}

	/**
	 * 핵심논문의 피인용논문의 갯수.<br>
	 * 데이터를 구축할때 referenceCount 높은 순으로 입력되어야 이 메소드를 통해 높은 인용수를 갖는 논문이 우선적으로
	 * 검출된다.<br>
	 * 
	 * @return
	 */
	public Map<String, Integer> getDocumentReferenceCountLinked() {
		return this.documentReferenceCount;
	}

	/**
	 * 핵심논문의 피인용논문의 갯수.<br>
	 * 데이터가 들어올때 referenceCount 높은 순으로 입력되어야 한다.<br>
	 */
	public void setDocumentReferenceCountLinked(String documentID, int referenceCount) {
		this.documentReferenceCount.put(documentID, referenceCount);
	}

	/**
	 * 핵심논문의 인용논문의 갯수.<br>
	 * 데이터를 구축할때 citationCount가 높은 순으로 입력되어야 이 메소드를 통해 높은 인용수를 갖는 논문이 우선적으로
	 * 검출된다.<br>
	 * 
	 * @return
	 */
	public Map<String, Integer> getDocumentCitationCountLinked() {
		return this.documentCitationCount;
	}

	/**
	 * 핵심논문의 인용논문의 갯수.<br>
	 * 데이터가 들어올때 citationCount가 높은 순으로 입력되어야 한다.<br>
	 */
	public void setDocumentCitationCountLinked(String documentID, int citationCount) {
		this.documentCitationCount.put(documentID, citationCount);
	}

	/**
	 * 핵심논문의 피인용수
	 * 
	 * @return
	 */
	public int getDocumentReferenceCount() {
		Collection<Integer> vs = documentReferenceCount.values();
		int count = 0;
		for (Integer s : vs) {
			count += s;
		}
		return count;
	}

	/**
	 * 핵심논문당 피 인용수.
	 * 
	 * @return
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public float getReferenceCountPerDocument() throws NumberFormatException, Exception {
		return Float.parseFloat(String.valueOf(getDocumentReferenceCount())) / Float.parseFloat(String.valueOf(getDocumentCount()));
	}

	/**
	 * 핵심논문의 수.
	 * 
	 * @return
	 * @throws Exception
	 *             클러스터 계산을 통해 구한 핵심논문수와, title을 구한 핵심논문수가 일치하지 않을때 발생.
	 */
	public int getDocumentCount() throws Exception {
		if (documentCount != getDocumentList().size())
			throw new Exception("논문수가 일치하지 않습니다.");
		return documentCount;
	}

	/**
	 * 핵심논문의 수.
	 */
	public void setDocumentCount(int documentCount) {
		this.documentCount = documentCount;
	}

	/**
	 * 핵심논문의 평균연도.
	 * 
	 * @return
	 */
	public float getAveragePubYearDocument() {
		Set<String> s = documentTitles.keySet();
		int sumPubYear = 0;
		for (String eid : s) {
			if (documentPubYear.containsKey(eid)) {
				sumPubYear += documentPubYear.get(eid);
			} else {
				sumPubYear += 0;
			}
		}
		averagePubYearDocument = Float.parseFloat(String.valueOf(sumPubYear)) / documentTitles.size();
		return averagePubYearDocument;
	}

	/**
	 * 핵심논문 발행연도 현황
	 */
	public SortedMap<Integer, Integer> getStaticsPubYear() {
		SortedMap<Integer, Integer> result = createDefaultStaticsPubYear();
		Collection<Integer> vs = documentPubYear.values();
		int maxYear = 1996;
		int minYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
		for (Integer year : vs) {
			if (year == 0)
				continue;
			if (minYear > year.intValue()) {
				minYear = year.intValue();
			}
			if (maxYear < year.intValue()) {
				maxYear = year.intValue();
			}
			int cnt = 0;
			if (result.containsKey(year)) {
				cnt = result.get(year);
				result.put(year, ++cnt);
			} else {
				result.put(year, 1);
			}
		}
		return removeKeyData(result, minYear, maxYear);
	}

	/**
	 * 건수가 기록된 최저 연도~최고 연도 사이의 데이터만 담는다.
	 * 
	 * @param yearMapData
	 *            연도별 건수가 기록된 데이터.
	 * @param minYear
	 *            건수가 기록된 최저 연도
	 * @param maxYear
	 *            건수가 기록된 최고 연도.
	 */
	private SortedMap<Integer, Integer> removeKeyData(Map<Integer, Integer> yearMapData, int minYear, int maxYear) {
		SortedMap<Integer, Integer> result = new TreeMap<Integer, Integer>();
		Set<Integer> set = yearMapData.keySet();
		for (Integer i : set) {
			if (i < minYear || i > maxYear) {
			} else {
				result.put(i, yearMapData.get(i));
			}
		}
		return result;
	}

	/**
	 * 핵심논문의 인용논문 발행연도 현황
	 */
	public SortedMap<Integer, Integer> getStaticsCitationPubYear() {
		SortedMap<Integer, Integer> result = createDefaultStaticsPubYear();
		Collection<Integer> vs = documentCitationPubYear.values();
		int maxYear = 1996;
		int minYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
		for (Integer year : vs) {
			if (year == 0)
				continue;
			if (minYear > year.intValue())
				minYear = year.intValue();
			if (maxYear < year.intValue())
				maxYear = year.intValue();
			int cnt = 0;
			if (result.containsKey(year)) {
				cnt = result.get(year);
				result.put(year, ++cnt);
			} else {
				result.put(year, 1);
			}
		}
		return removeKeyData(result, minYear, maxYear);
	}

	private SortedMap<Integer, Integer> createDefaultStaticsPubYear() {
		SortedMap<Integer, Integer> result = new TreeMap<Integer, Integer>();
		int startYear = 1996;
		int currentYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
		while (startYear <= currentYear) {
			result.put(startYear, 0);
			startYear++;
		}
		return result;
	}

	/**
	 * 핵심논문의 인용논문의 평균연도.
	 * 
	 * @return
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public float getAveragePubYearCiationDoc() throws NumberFormatException, Exception {
		Set<String> s = documentCitationPubYear.keySet();
		int sumPubYear = 0;
		for (String eid : s) {
			sumPubYear += documentCitationPubYear.get(eid);
		}
		averagePubYearCiationDoc = Float.parseFloat(String.valueOf(sumPubYear)) / Float.parseFloat(String.valueOf(s.size()));
		return averagePubYearCiationDoc;
	}

	/**
	 * 분류별 빈도수 정보를 리턴한다.
	 * 
	 * @return
	 */
	public Map<String, Float> getAsjcInfo() {
		return asjcInfo;
	}

	/**
	 * 대분류별 빈도수 정보를 리턴한다.
	 * 
	 * @return
	 */
	public Map<String, Float> getLargeAsjcInfo() {
		return largeAsjcInfo;
	}

	/**
	 * 키워드 빈도수 정보를 리턴한다.
	 * 
	 * @return
	 */
	public Map<String, Integer> getKeywordInfo() {
		return this.keywordInfo;
	}

	/**
	 * 분류정보를 입력한다.<br>
	 * 분류정보는 입력된 순서대로 저장된다.<br>
	 * 
	 * @param k
	 *            분류정보
	 * @param v
	 *            분류정보 빈도수
	 */
	public void setAsjcInfo(String k, float v) {
		asjcInfo.put(k, v);
	}

	/**
	 * 대분류정보를 입력한다.<br>
	 * 대분류정보는 입력된 순서대로 저장된다.<br>
	 * 
	 * @param k
	 *            대분류정보
	 * @param v
	 *            대분류정보 빈도수
	 */
	public void setLargeAsjcInfo(String k, float v) {
		largeAsjcInfo.put(k, v);
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}

	public String getClusterID() {
		return clusterID;
	}

	public void setClusterID(String clusterID) {
		this.clusterID = clusterID;
	}

	public Map<String, String> getKoreaDocumentEidSet() {
		return koreaDocumentEidSet;
	}

	public void setKoreaDocumentEidSet(Map<String, String> koreaDocumentEidSet) {
		this.koreaDocumentEidSet = koreaDocumentEidSet;
	}

	public int getTotalAnaylsysDocument() {
		return totalAnaylsysDocument;
	}

	public void setTotalAnaylsysDocument(int totalAnaylsysDocument) {
		this.totalAnaylsysDocument = totalAnaylsysDocument;
	}

}
