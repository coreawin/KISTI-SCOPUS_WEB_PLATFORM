/**
 * 
 */
package kr.co.tqk.web.util;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import kr.co.topquadrant.util.MapValueSort;

/**
 * @author coreawin
 * @sinse 2012. 8. 6.
 * @version 1.0
 * 
 *          <pre>
 * 2012. 8. 6. : ���� �ۼ�
 * </pre>
 */
public class InfoStack {

	/**
	 * @author coreawin
	 * @sinse 2012. 8. 6.
	 * @version 1.0
	 * <pre>
	 * 2012. 8. 6. : ���� �ۼ�
	 * </pre>
	 */
	public enum InfoStackType{
		AUTHOR_NAME_FREQ, AUTHOR_NAME, AFFILATION_NAME, AFFILATION_NAME_FREQ, SOURCE_TITLE, SOURCE_TITLE_FREQ;
	}
	
	private static final int MAX_SIZE = 200;

	/**
	 * <ID, �̸�> ������ �����ϴ� �����ʹ� MAX_SIZE���� ���ؼ� �����ȴ�.<br>
	 * MAX_SIZE�� �ʰ��ϴ� ���� �����ʹ� �������� �ʴ´�.<br>
	 */
	public static void manageMap(Map<String, String> dataInfoMap, Map<String, Integer> dataInfoFreqMap) {
		LinkedHashMap<String, String> valueSortedMap = null;
		if(dataInfoMap==null) dataInfoMap = new HashMap<String, String>();
		if(dataInfoFreqMap==null) dataInfoFreqMap = new HashMap<String, Integer>();
		if (dataInfoMap.size() > MAX_SIZE) {
			valueSortedMap = (LinkedHashMap) MapValueSort.sortByValue2(dataInfoFreqMap);
		} else {
			return;
		}
		while (dataInfoMap.size() > MAX_SIZE) {
			Set<String> set = valueSortedMap.keySet();
			String authorID = null;
			for (Object k : set) {
				authorID = String.valueOf(k);
				valueSortedMap.remove(k);
				break;
			}
			if (authorID == null)
				break;
			dataInfoMap.remove(authorID);
		}
	}

	/**
	 * dataInfoMap �����Ϳ� ���ԵǾ� ���� �ʴ� �����͸� �����´�.<br>
	 * 
	 * @param dataInfoMap
	 *            ���� ������
	 * @param dataSet
	 *            ���� �����Ϳ��� ������ �����͵��� ��.
	 * @return
	 */
	public static Set<String> getNotInclude(Map<String, String> dataInfoMap, Set<String> dataSet) {
		Set<String> notIncludeAuthor = new HashSet<String>();
		if(dataInfoMap==null) dataInfoMap = new HashMap<String, String>();
		for (String k : dataSet) {
			if (!dataInfoMap.containsKey(k)) {
				notIncludeAuthor.add(k);
			}
		}
		return notIncludeAuthor;
	}

	/**
	 * ���ο� �����͸� ����Ѵ�. <br>
	 * 
	 * @param dataInfoMap
	 *            ���� ������.
	 * @param key
	 * 
	 * @param value
	 */
	public static void registerKeyValue(Map<String, String> dataInfoMap, String key, String value) {
		if(dataInfoMap==null) dataInfoMap = new HashMap<String, String>();
		if (!dataInfoMap.containsKey(key)) {
			dataInfoMap.put(key, value);
		}
	}

	/**
	 * ���� �����Ϳ��� Key�� �ش��ϴ� Value�� �����´�.<br>
	 * �ش� key�� ���� ���� �󵵼��� 1�����Ѵ�.<br>
	 * 
	 * @param dataInfoMap
	 *            ���� ������
	 * @param dataInfoFreqMap
	 *            ���� �������� �󵵼� ���� ������.
	 * @param key
	 * 
	 * @return
	 */
	public static String getValue(Map<String, String> dataInfoMap, Map<String, Integer> dataInfoFreqMap, String key) {
		String result = "";
		if(dataInfoMap==null) dataInfoMap = new HashMap<String, String>();
		if(dataInfoFreqMap==null) dataInfoFreqMap = new HashMap<String, Integer>();
		try {
			result = dataInfoMap.get(key);
			int feq = 1;
			if (dataInfoFreqMap.containsKey(key)) {
				feq = dataInfoFreqMap.get(key) + 1;
			}
			dataInfoFreqMap.put(key, feq);
		} finally {

		}

		return result;
	}

}
