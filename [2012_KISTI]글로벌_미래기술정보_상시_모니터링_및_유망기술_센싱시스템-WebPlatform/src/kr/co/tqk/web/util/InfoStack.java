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
 * 2012. 8. 6. : 최초 작성
 * </pre>
 */
public class InfoStack {

	/**
	 * @author coreawin
	 * @sinse 2012. 8. 6.
	 * @version 1.0
	 * <pre>
	 * 2012. 8. 6. : 최초 작성
	 * </pre>
	 */
	public enum InfoStackType{
		AUTHOR_NAME_FREQ, AUTHOR_NAME, AFFILATION_NAME, AFFILATION_NAME_FREQ, SOURCE_TITLE, SOURCE_TITLE_FREQ;
	}
	
	private static final int MAX_SIZE = 200;

	/**
	 * <ID, 이름> 정보를 관리하는 데이터는 MAX_SIZE값에 의해서 관리된다.<br>
	 * MAX_SIZE를 초과하는 양의 데이터는 보관하지 않는다.<br>
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
	 * dataInfoMap 데이터에 포함되어 있지 않는 데이터만 가져온다.<br>
	 * 
	 * @param dataInfoMap
	 *            원본 데이터
	 * @param dataSet
	 *            원본 데이터에서 참조할 데이터들의 셋.
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
	 * 새로운 데이터를 등록한다. <br>
	 * 
	 * @param dataInfoMap
	 *            원본 데이터.
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
	 * 원본 데이터에서 Key에 해당하는 Value를 가져온다.<br>
	 * 해당 key에 대한 선택 빈도수가 1증가한다.<br>
	 * 
	 * @param dataInfoMap
	 *            원본 데이터
	 * @param dataInfoFreqMap
	 *            원본 데이터의 빈도수 정보 데이터.
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
