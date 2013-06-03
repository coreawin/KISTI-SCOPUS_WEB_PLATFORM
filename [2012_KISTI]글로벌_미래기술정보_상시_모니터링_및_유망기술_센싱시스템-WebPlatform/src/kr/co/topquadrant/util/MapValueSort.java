package kr.co.topquadrant.util;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Map Collection의 Value를 기준으로 소트한다.
 * 
 * @author 정승한
 * 
 */
public class MapValueSort {

	/**
	 * 
	 * Map 데이터를 Value를 기준으로 정렬한다.<br>
	 * 
	 * @param map
	 *            Value를 기준으로 소트한다.
	 * @return Value를 기준으로 소트한 결과
	 */
	public static <K, V> Map<K, V> sortByValue(Map<K, V> map) {
		List<K> list = new LinkedList<K>((Collection<? extends K>) map.entrySet());
		Collections.sort(list, new Comparator() {
			public int compare(Object o1, Object o2) {
				return ((Comparable) ((Map.Entry) (o2)).getValue()).compareTo(((Map.Entry) (o1)).getValue());
			}
		});

		Map<K, V> result = new LinkedHashMap<K, V>();
		for (Iterator<K> it = list.iterator(); it.hasNext();) {
			Map.Entry<K, V> entry = (Map.Entry<K, V>) it.next();
			result.put(entry.getKey(), entry.getValue());
		}
		return result;
	}
	
	public static <K, V> Map<K, V> sortByValue2(Map<K, V> map) {
		List<K> list = new LinkedList<K>((Collection<? extends K>) map.entrySet());
		Collections.sort(list, new Comparator() {
			public int compare(Object o1, Object o2) {
				return ((Comparable) ((Map.Entry) (o1)).getValue()).compareTo(((Map.Entry) (o2)).getValue());
			}
		});
		
		Map<K, V> result = new LinkedHashMap<K, V>();
		for (Iterator<K> it = list.iterator(); it.hasNext();) {
			Map.Entry<K, V> entry = (Map.Entry<K, V>) it.next();
			result.put(entry.getKey(), entry.getValue());
		}
		return result;
	}

	/**
	 * Value를 기준으로 정렬한 후 topRanking 만큼의 데이터만을 리턴한다. <br>
	 * Value가 Integer형인경우만 현재는 지원<br>
	 * 동률일경우 모든 동률된 정보까지 가져옴<BR>
	 * VALUE가 1인 경우 모든 동률된 정보는 가져오지 않음.<BR>
	 * 
	 * @param map
	 *            데이터
	 * @param topRanking
	 *            상위 Ranking <br>
	 * @return
	 */
	public static <K, V> Map<K, V> topValueData(Map<K, V> map, int topRanking) {
		Map<K, V> newMap = new HashMap<K, V>(map);
		newMap = MapValueSort.sortByValue(newMap);
		Set<K> set = newMap.keySet();
		int cnt = 0;
		int vt = 0;
		Map<K, V> nd = new LinkedHashMap<K, V>();
		for (K k : set) {
			V v = newMap.get(k);
			if (v instanceof Integer) {
				int vi = (Integer) v;
				if (cnt >= 10 && (vi != vt)) {
					break;
				}
				if (cnt >= 10 && vt == 1 && vi == 1) {
					break;
				}
				nd.put(k, v);
				vt = vi;
			}
			cnt++;
		}
		return nd;
	}
}
