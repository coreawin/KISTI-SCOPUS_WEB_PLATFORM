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
	 * �ٽɳ��� ����.
	 */
	int documentCount = 0;
	/**
	 * �ٽɳ� ��տ���.
	 */
	float averagePubYearDocument = 0f;
	/**
	 * �ٽɳ��� �ο�� ��տ���.
	 */
	float averagePubYearCiationDoc = 0f;

	/**
	 * �ٽɳ� SCOPUS ���� (eid, title)
	 */
	Map<String, String> documentTitles = new LinkedHashMap<String, String>();
	/**
	 * �ٽɳ� SCOPUS ���࿬�� (eid, publication_year)
	 */
	Map<String, Integer> documentPubYear = new LinkedHashMap<String, Integer>();
	/**
	 * �ο�� SCOPUS ���࿬�� (cit_eid, publication_year)
	 */
	Map<String, Integer> documentCitationPubYear = new LinkedHashMap<String, Integer>();
	/**
	 * �ٽɳ��� ���ο���� (eid, ref_eid count)
	 */
	Map<String, Integer> documentReferenceCount = new LinkedHashMap<String, Integer>();
	/**
	 * �ٽɳ��� �ο���� (eid, cit_eid count)
	 */
	Map<String, Integer> documentCitationCount = new LinkedHashMap<String, Integer>();

	/**
	 * �з��ڵ� ���� (asjc����, %��)
	 */
	Map<String, Float> asjcInfo = new LinkedHashMap<String, Float>();

	/**
	 * ��з��ڵ� ���� (asjc����, %��)
	 */
	Map<String, Float> largeAsjcInfo = new LinkedHashMap<String, Float>();

	/**
	 * Ű���� ���� (keyword����, ��)
	 */
	Map<String, Integer> keywordInfo = new LinkedHashMap<String, Integer>();

	/**
	 * ������ ���� (eid, title)
	 */
	Map<String, String> koreaDocumentEidSet = new LinkedHashMap<String, String>();
	
	/**
	 * �� �м� ��� ������.<OPTIONAL>
	 */
	int totalAnaylsysDocument = 0;
	
	/**
	 * �ٽɳ��� ���ο��
	 */
	int referenceCount = 0;

	/**
	 * �ٽɳ��� �ο��
	 */
	int citationCount = 0;

	/**
	 * �ٽɳ� �� ���ο��
	 */
	float referencePerCount = 0;

	/**
	 * �ٽɳ� �� �ο��
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
	 * �ٽɳ��� ���ο���� ����.<br>
	 * �����͸� �����Ҷ� referenceCount ���� ������ �ԷµǾ�� �� �޼ҵ带 ���� ���� �ο���� ���� ���� �켱������
	 * ����ȴ�.<br>
	 * 
	 * @return
	 */
	public Map<String, Integer> getDocumentReferenceCountLinked() {
		return this.documentReferenceCount;
	}

	/**
	 * �ٽɳ��� ���ο���� ����.<br>
	 * �����Ͱ� ���ö� referenceCount ���� ������ �ԷµǾ�� �Ѵ�.<br>
	 */
	public void setDocumentReferenceCountLinked(String documentID, int referenceCount) {
		this.documentReferenceCount.put(documentID, referenceCount);
	}

	/**
	 * �ٽɳ��� �ο���� ����.<br>
	 * �����͸� �����Ҷ� citationCount�� ���� ������ �ԷµǾ�� �� �޼ҵ带 ���� ���� �ο���� ���� ���� �켱������
	 * ����ȴ�.<br>
	 * 
	 * @return
	 */
	public Map<String, Integer> getDocumentCitationCountLinked() {
		return this.documentCitationCount;
	}

	/**
	 * �ٽɳ��� �ο���� ����.<br>
	 * �����Ͱ� ���ö� citationCount�� ���� ������ �ԷµǾ�� �Ѵ�.<br>
	 */
	public void setDocumentCitationCountLinked(String documentID, int citationCount) {
		this.documentCitationCount.put(documentID, citationCount);
	}

	/**
	 * �ٽɳ��� ���ο��
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
	 * �ٽɳ��� �� �ο��.
	 * 
	 * @return
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public float getReferenceCountPerDocument() throws NumberFormatException, Exception {
		return Float.parseFloat(String.valueOf(getDocumentReferenceCount())) / Float.parseFloat(String.valueOf(getDocumentCount()));
	}

	/**
	 * �ٽɳ��� ��.
	 * 
	 * @return
	 * @throws Exception
	 *             Ŭ������ ����� ���� ���� �ٽɳ�����, title�� ���� �ٽɳ����� ��ġ���� ������ �߻�.
	 */
	public int getDocumentCount() throws Exception {
		if (documentCount != getDocumentList().size())
			throw new Exception("������ ��ġ���� �ʽ��ϴ�.");
		return documentCount;
	}

	/**
	 * �ٽɳ��� ��.
	 */
	public void setDocumentCount(int documentCount) {
		this.documentCount = documentCount;
	}

	/**
	 * �ٽɳ��� ��տ���.
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
	 * �ٽɳ� ���࿬�� ��Ȳ
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
	 * �Ǽ��� ��ϵ� ���� ����~�ְ� ���� ������ �����͸� ��´�.
	 * 
	 * @param yearMapData
	 *            ������ �Ǽ��� ��ϵ� ������.
	 * @param minYear
	 *            �Ǽ��� ��ϵ� ���� ����
	 * @param maxYear
	 *            �Ǽ��� ��ϵ� �ְ� ����.
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
	 * �ٽɳ��� �ο�� ���࿬�� ��Ȳ
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
	 * �ٽɳ��� �ο���� ��տ���.
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
	 * �з��� �󵵼� ������ �����Ѵ�.
	 * 
	 * @return
	 */
	public Map<String, Float> getAsjcInfo() {
		return asjcInfo;
	}

	/**
	 * ��з��� �󵵼� ������ �����Ѵ�.
	 * 
	 * @return
	 */
	public Map<String, Float> getLargeAsjcInfo() {
		return largeAsjcInfo;
	}

	/**
	 * Ű���� �󵵼� ������ �����Ѵ�.
	 * 
	 * @return
	 */
	public Map<String, Integer> getKeywordInfo() {
		return this.keywordInfo;
	}

	/**
	 * �з������� �Է��Ѵ�.<br>
	 * �з������� �Էµ� ������� ����ȴ�.<br>
	 * 
	 * @param k
	 *            �з�����
	 * @param v
	 *            �з����� �󵵼�
	 */
	public void setAsjcInfo(String k, float v) {
		asjcInfo.put(k, v);
	}

	/**
	 * ��з������� �Է��Ѵ�.<br>
	 * ��з������� �Էµ� ������� ����ȴ�.<br>
	 * 
	 * @param k
	 *            ��з�����
	 * @param v
	 *            ��з����� �󵵼�
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
