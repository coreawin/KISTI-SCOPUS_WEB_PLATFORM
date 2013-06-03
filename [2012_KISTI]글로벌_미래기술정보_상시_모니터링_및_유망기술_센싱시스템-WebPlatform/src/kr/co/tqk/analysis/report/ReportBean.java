package kr.co.tqk.analysis.report;

import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

import kr.co.tqk.analysis.util.NumberFormatUtil;
import kr.co.tqk.web.util.UtilString;

import org.apache.commons.collections.map.MultiValueMap;

/**
 * ���� ������ �� Ŭ����
 * 
 * @author ������
 * 
 */
public class ReportBean {
	String clusterKey = "";
	String koreaInfo = "";
	String topCitationOrgCountyInfo = "";

	public String getTopCitationOrgCountyInfo() {
		return UtilString.nullCkeck(topCitationOrgCountyInfo);
	}

	public void setTopCitationOrgCountyInfo(String topCitationOrgCountyInfo) {
		this.topCitationOrgCountyInfo = topCitationOrgCountyInfo;
	}

	public String getKoreaInfo() {
		return UtilString.nullCkeck(koreaInfo);
	}

	public void setKoreaInfo(String koreaInfo) {
		this.koreaInfo = koreaInfo;
	}

	public String getClusterKey() {
		return UtilString.nullCkeck(clusterKey);
	}

	public void setClusterKey(String clusterKey) {
		this.clusterKey = clusterKey;
	}

	HashMap<String, String> asjcLargeInfoMap = new HashMap<String, String>();

	public ReportBean() {
		/*
		 * ���࿬�� ��Ȳ������ 2001����� ���� �ý��� �������� 0���� �ʱ�ȭ �Ѵ�.
		 */
		for (int year = 2001; year <= Calendar.getInstance().get(Calendar.YEAR); year++) {
			publicationYearInfo.put(year, 0);
			citataionPublicationYearInfo.put(year, 0);
		}
	}

	/**
	 * 
	 * @param asjcInfo
	 *            ��з� ASJC ����.
	 */
	public ReportBean(HashMap<String, String> asjcInfo) {
		this.asjcLargeInfoMap = asjcInfo;
		/*
		 * ���࿬�� ��Ȳ������ 2001����� ���� �ý��� �������� 0���� �ʱ�ȭ �Ѵ�.
		 */
		for (int year = 2001; year <= Calendar.getInstance().get(Calendar.YEAR); year++) {
			publicationYearInfo.put(year, 0);
			citataionPublicationYearInfo.put(year, 0);
		}
	}

	public void setAsjcLargeInfo(HashMap<String, String> asjcInfo) {
	}

	/**
	 * ������.
	 * 
	 * @author ������
	 * 
	 */
	public static class OrderStringDecending implements Comparator<String> {
		boolean decending = false;

		public OrderStringDecending() {
		}

		public OrderStringDecending(boolean desc) {
			decending = desc;
		}

		public int compare(String o1, String o2) {
			if (decending)
				return o2.compareTo(o1);
			else
				return o1.compareTo(o2);
		}
	}

	static class ValueSortedMap extends TreeMap<String, String> {
		private static final long serialVersionUID = -8401997831909527412L;

		public int compareTo(String o1, String o2) {
			float f1 = Float.parseFloat(get(o1));
			float f2 = Float.parseFloat(get(o2));
			System.out.println(f1 + "\t" + f2);
			if (f1 < f2) {
				return 1;
			} else {
				return -1;
			}
		}
	}

	LinkedList<DocumentBean> documentList = new LinkedList<DocumentBean>();

	/**
	 * �ٽ� ����
	 */
	int documentCount = 0;

	/**
	 * �ٽ� �� ���ο��
	 */
	int citationCount = 0;

	/**
	 * �ٽ� ���� ���ο��
	 */
	float citationCountPerDocument = 0f;

	/**
	 * �ٽɳ� ��� ����
	 */
	float averagePublicationYear = 0f;

	/**
	 * �ٽɳ��� �ο������ ���� ��� ����
	 */
	float averageCitationPublicationYear = 0f;

	/**
	 * ���࿬�� ��Ȳ ����
	 */
	SortedMap<Integer, Integer> publicationYearInfo = new TreeMap<Integer, Integer>();

	LinkedList<Integer> publicationYearInfo_YearList = new LinkedList<Integer>();
	LinkedList<Integer> publicationYearInfo_YearValueList = new LinkedList<Integer>();

	LinkedList<Integer> citationYearInfo_YearList = new LinkedList<Integer>();

	public LinkedList<Integer> getCitationYearInfo_YearList() {
		return citationYearInfo_YearList;
	}

	public void setCitationYearInfo_YearList(
			LinkedList<Integer> citationYearInfo_YearList) {
		this.citationYearInfo_YearList = citationYearInfo_YearList;
	}

	LinkedList<Integer> citationYearInfo_YearValueList = new LinkedList<Integer>();

	public LinkedList<Integer> getCitationYearInfo_YearValueList() {
		return citationYearInfo_YearValueList;
	}

	public void setCitationYearInfo_YearValueList(
			LinkedList<Integer> citationYearInfo_YearValueList) {
		this.citationYearInfo_YearValueList = citationYearInfo_YearValueList;
	}

	public LinkedList<Integer> getPublicationYearInfo_YearList() {
		return publicationYearInfo_YearList;
	}

	public void setPublicationYearInfo_YearList(
			LinkedList<Integer> publicationYearInfo_YearList) {
		this.publicationYearInfo_YearList = publicationYearInfo_YearList;
	}

	public LinkedList<Integer> getPublicationYearInfo_YearValueList() {
		return publicationYearInfo_YearValueList;
	}

	public void setPublicationYearInfo_YearValueList(
			LinkedList<Integer> publicationYearInfo_YearValueList) {
		this.publicationYearInfo_YearValueList = publicationYearInfo_YearValueList;
	}

	/**
	 * �ٽɳ��� �ο��� ������ ���࿬�� ��Ȳ ����
	 */
	SortedMap<Integer, Integer> citataionPublicationYearInfo = new TreeMap<Integer, Integer>();

	/**
	 * 
	 * @return ���࿬�� ����
	 */
	public SortedMap<Integer, Integer> getPublicationYearInfo() {
		MultiValueMap mvm = new MultiValueMap();
		for (DocumentBean bean : documentList) {
			mvm.put(bean.getPublicationYear(), bean.getPublicationYear());
		}
		SortedSet<String> tmpSortedSet = new TreeSet<String>(
				new OrderStringDecending());
		for (Object key : mvm.keySet()) {
			tmpSortedSet.add(mvm.getCollection(key).size() + "_" + key);
		}

		for (String s : tmpSortedSet) {
			String[] data = s.split("_");
			publicationYearInfo.put(Integer.parseInt(data[1]),
					Integer.parseInt(data[0]));
		}
		for (Integer year : publicationYearInfo.keySet()) {
			publicationYearInfo_YearList.add(year);
			publicationYearInfo_YearValueList
					.add(publicationYearInfo.get(year));
		}
		return publicationYearInfo;
	}

	/**
	 * 
	 * @return �ο���鿡 ���� ���࿬�� ����
	 */
	public SortedMap<Integer, Integer> getCitationPublicationYearInfo() {
		MultiValueMap mvm = new MultiValueMap();
		for (DocumentBean bean : documentList) {
			HashMap<String, String> citInfo = bean.getCitationInfo();
			if (citInfo == null)
				continue;
			for (String citEid : citInfo.keySet()) {
				String py = citInfo.get(citEid);
				if (py != null) {
					try {
						int publicationYear = Integer.parseInt(py);
						mvm.put(publicationYear, publicationYear);
					} catch (NumberFormatException ne) {
						// ignore
					}
				}
			}
		}
		SortedSet<String> tmpSortedSet = new TreeSet<String>(
				new OrderStringDecending());
		for (Object key : mvm.keySet()) {
			tmpSortedSet.add(mvm.getCollection(key).size() + "_" + key);
		}

		for (String s : tmpSortedSet) {
			String[] data = s.split("_");
			citataionPublicationYearInfo.put(Integer.parseInt(data[1]),
					Integer.parseInt(data[0]));
		}
		for (Integer year : citataionPublicationYearInfo.keySet()) {
			citationYearInfo_YearList.add(year);
			citationYearInfo_YearValueList.add(citataionPublicationYearInfo
					.get(year));
		}
		return citataionPublicationYearInfo;
	}

	String documentInfo = "";

	/**
	 * ��з� ����
	 */
	LinkedHashMap<String, String> asjcLargeList = new LinkedHashMap<String, String>();

	/**
	 * �з��ڵ� ����
	 */
	LinkedHashMap<String, String> asjcList = new LinkedHashMap<String, String>();

	/**
	 * �ٽ� Ű����
	 */
	LinkedHashMap<String, String> keywordList = new LinkedHashMap<String, String>();

	String keywordListString = "";

	/**
	 * ���� �� ��Ȳ
	 */
	LinkedHashMap<String, String> koreaList = new LinkedHashMap<String, String>();

	/**
	 * ���ο� �� �����͸� �߰��մϴ�.
	 * 
	 * @param o
	 *            DocumentBean
	 */
	public void addDocument(DocumentBean o) {
		documentList.add(o);

		citationCount += o.getCitationCount();
		documentCount = documentList.size();

		try {
			citationCountPerDocument = Float.parseFloat(String
					.valueOf(citationCount)) / documentCount;
		} catch (Exception e) {
			citationCountPerDocument = 0;
		}
	}

	/**
	 * @return �ٽ� ���� ���ο��.
	 */
	public String getCitationCountPerDocument() {
		return NumberFormatUtil.getDecimalFormat(citationCountPerDocument, 4);
	}

	/**
	 * @return korea org name
	 */
	public String getKoreaOrgNameList() {
		StringBuffer sb = new StringBuffer();
		for (DocumentBean bean : documentList) {
			MultiValueMap mvm = bean.getKoreaOrgAndAuthorNameInfo();
			if (mvm == null)
				continue;
			Set<String> set = mvm.keySet();
			for (String orgName : set) {
				sb.append("[" + bean.getEid() + "-" + bean.getTitle() + "]:"
						+ orgName + ":" + mvm.get(orgName).toString());
				sb.append("`");
			}
		}
		return sb.toString();
	}
	
	/**
	 * @return top citation org_countryCode name
	 */
	public String getTopCitationCountOrgAndAuthorNameList() {
		StringBuffer sb = new StringBuffer();
		for (DocumentBean bean : documentList) {
			HashMap<String, String> mvm = bean.getTopCitationCountOrgAndAuthorNameInfo();
			if (mvm == null)
				continue;
			Set<String> set = mvm.keySet();
			for (String orgName : set) {
				sb.append("[" + bean.getEid() + "]:"
						+ orgName + ":" + mvm.get(orgName).toString());
				sb.append("`");
			}
		}
		return sb.toString();
	}

	/**
	 * @return �ٽ� ���� ����.
	 */
	public int getDocumentCount() {
		return documentCount;
	}

	/**
	 * @return �ٽɳ� ���ο��.
	 */
	public int getCitationCount() {
		return citationCount;
	}

	/**
	 * @return �ٽɳ� ��տ���.
	 */
	public String getAveragePublicationYear() {
		float year = 0;
		for (DocumentBean bean : documentList) {
			int py = bean.getPublicationYear();
			if (py != 0) {
				year += py;
			}
		}
		try {
			averagePublicationYear = year / documentList.size();
		} catch (Exception e) {
			averagePublicationYear = 0;
		}
		return NumberFormatUtil.getDecimalFormat(averagePublicationYear, 4);
	}

	/**
	 * @return �ٽɳ��� �ο���鿡 ���� ��տ���.
	 */
	public String getAverageCitationPublicationYear() {
		float year = 0;
		int citationCnt = 0;
		for (DocumentBean bean : documentList) {
			HashMap<String, String> citInfoMap = bean.getCitationInfo();
			if (citInfoMap == null)
				continue;
			for (String cit_eid : citInfoMap.keySet()) {
				String publicationYear = citInfoMap.get(cit_eid);
				try {
					if (publicationYear != null) {
						citationCnt++;
						int py = Integer.parseInt(publicationYear);
						if (py != 0) {
							year += py;
						}
					}
				} catch (Exception ne) {
					continue;
				}
			}

		}
		try {
			averageCitationPublicationYear = year / citationCnt;
		} catch (Exception e) {
			averageCitationPublicationYear = 0;
		}
		return NumberFormatUtil.getDecimalFormat(
				averageCitationPublicationYear, 4);
	}

	/**
	 * �󵵼��� ���� ������ �ٽ� Ű���带 �����Ѵ�.
	 * 
	 * @return �ٽ�Ű����
	 */
	public LinkedHashMap<String, String> getKeywordList() {
		MultiValueMap mvm = new MultiValueMap();
		for (DocumentBean bean : documentList) {
			HashSet<String> keywordSet = bean.getKeywordList();
			if (keywordSet == null)
				continue;
			for (String keyword : keywordSet) {
				mvm.put(keyword, keyword);
			}
		}
		// SortedSet<String> tmpSortedSet = new TreeSet<String>(
		// new OrderStringDecending());
		// for (Object key : mvm.keySet()) {
		// tmpSortedSet.add(mvm.getCollection(key).size() + "_" + key);
		// }
		//
		// for (String s : tmpSortedSet) {
		// String[] data = s.split("_");
		// keywordList.put(data[1], data[0]);
		// }
		//
		// ValueComparator<String, String> comparator = new
		// ValueComparator<String, String>(keywordList);
		// TreeMap<String, String> reverse = new TreeMap<String, String>(new
		// ReverseComparator<String>(comparator));
		// reverse.putAll(keywordList);

		MultiValueMap mvmMap = new MultiValueMap();
		for (Object key : mvm.keySet()) {
			mvmMap.put(mvm.getCollection(key).size(),
					(List<String>) mvm.get(key));
		}

		SortedMap<Integer, List> sortedMap = new TreeMap<Integer, List>(
				Collections.reverseOrder());
		for (Object key : mvmMap.keySet()) {
			sortedMap.put(Integer.parseInt(String.valueOf(key)),
					(List<String>) mvmMap.get(key));
		}
		for (Integer i : sortedMap.keySet()) {
			List<List> list = (List<List>) sortedMap.get(i);
			for (List<String> ll : list) {
				for (String s : ll) {
					keywordList.put(s, String.valueOf(ll.size()));
					break;
				}
			}
		}

		return keywordList;
	}

	/**
	 * @return ������ �����Ѵ�.
	 */
	public LinkedList<DocumentBean> getDocumentList() {
		return documentList;
	}

	/**
	 * @return �з��ڵ�.
	 */
	public LinkedHashMap<String, String> getAsjcList() {

		MultiValueMap mvm = new MultiValueMap();
		int totalASJCCount = 0;
		for (DocumentBean bean : documentList) {
			HashSet<String> asjcSet = bean.getAsjcCodeList();
			if (asjcSet == null)
				continue;
			totalASJCCount += asjcSet.size();
			for (String asjcCode : asjcSet) {
				mvm.put(asjcCode, asjcCode);
			}
		}
		MultiValueMap mvmMap = new MultiValueMap();
		for (Object key : mvm.keySet()) {
			mvmMap.put(mvm.getCollection(key).size(),
					(List<String>) mvm.get(key));
		}

		SortedMap<Integer, List> sortedMap = new TreeMap<Integer, List>(
				Collections.reverseOrder());
		for (Object key : mvmMap.keySet()) {
			sortedMap.put(Integer.parseInt(String.valueOf(key)),
					(List<String>) mvmMap.get(key));
		}
		for (Integer i : sortedMap.keySet()) {
			List<List> list = (List<List>) sortedMap.get(i);
			for (List<String> ll : list) {
				for (String s : ll) {
					float cnt = new Float(ll.size()) / totalASJCCount * 100;
					asjcList.put(s, String.valueOf(NumberFormatUtil
							.convertNumberPointFormat(cnt, 2)));
					break;
				}
			}
		}
		return asjcList;
	}

	/**
	 * @return ��з� �з�����.
	 */
	public LinkedHashMap<String, String> getAsjcLargeList() {

		MultiValueMap mvm = new MultiValueMap();
		int totalASJCCount = 0;
		for (DocumentBean bean : documentList) {
			HashSet<String> asjcSet = bean.getAsjcCodeList();
			if (asjcSet == null)
				continue;
			totalASJCCount += asjcSet.size();
			for (String asjcCode : asjcSet) {
				String largeAsjc = asjcCode.substring(0, 2) + "00";
				mvm.put(largeAsjc, largeAsjc);
			}
		}

		MultiValueMap mvmMap = new MultiValueMap();
		for (Object key : mvm.keySet()) {
			mvmMap.put(mvm.getCollection(key).size(),
					(List<String>) mvm.get(key));
		}

		SortedMap<Integer, List> sortedMap = new TreeMap<Integer, List>(
				Collections.reverseOrder());
		for (Object key : mvmMap.keySet()) {
			sortedMap.put(Integer.parseInt(String.valueOf(key)),
					(List<String>) mvmMap.get(key));
		}
		for (Integer i : sortedMap.keySet()) {
			List<List> list = (List<List>) sortedMap.get(i);
			for (List<String> ll : list) {
				for (String s : ll) {
					float cnt = new Float(ll.size()) / totalASJCCount * 100;
					asjcLargeList.put(s, String.valueOf(NumberFormatUtil
							.convertNumberPointFormat(cnt, 2)));
					break;
				}
			}
		}
		return asjcLargeList;
	}

	private static class ValueComparator<K extends Comparable<K>, V extends Comparable<V>>
			implements Comparator<K> {
		private Map<K, V> map;

		ValueComparator(Map<K, V> map) {
			this.map = map;
		}

		public int compare(K o1, K o2) {
			V v1 = map.get(o1);
			if (v1 == null) {
				return -1;
			}
			int p = v1.compareTo(map.get(o2));
			if (p != 0) {
				return p;
			}
			return o1.compareTo(o2);
		}
	}

	private static class ReverseComparator<T> implements Comparator<T> {
		private Comparator<T> comparator;

		ReverseComparator(Comparator<T> comparator) {
			this.comparator = comparator;
		}

		public int compare(T o1, T o2) {
			return -1 * comparator.compare(o1, o2);
		}
	}

	public String getKeywordListString() {
		return UtilString.nullCkeck(keywordListString);
	}

	public void setKeywordListString(String keywordListString) {
		this.keywordListString = keywordListString;
	}

	public String getDocumentInfo() {
		return UtilString.nullCkeck(documentInfo);
	}

	public void setDocumentInfo(String documentInfo) {
		this.documentInfo = documentInfo;
	}
}
