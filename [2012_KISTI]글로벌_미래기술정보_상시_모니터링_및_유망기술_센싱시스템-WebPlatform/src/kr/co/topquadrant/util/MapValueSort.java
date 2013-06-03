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
 * Map Collection�� Value�� �������� ��Ʈ�Ѵ�.
 * 
 * @author ������
 * 
 */
public class MapValueSort {

	/**
	 * 
	 * Map �����͸� Value�� �������� �����Ѵ�.<br>
	 * 
	 * @param map
	 *            Value�� �������� ��Ʈ�Ѵ�.
	 * @return Value�� �������� ��Ʈ�� ���
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
	 * Value�� �������� ������ �� topRanking ��ŭ�� �����͸��� �����Ѵ�. <br>
	 * Value�� Integer���ΰ�츸 ����� ����<br>
	 * �����ϰ�� ��� ������ �������� ������<BR>
	 * VALUE�� 1�� ��� ��� ������ ������ �������� ����.<BR>
	 * 
	 * @param map
	 *            ������
	 * @param topRanking
	 *            ���� Ranking <br>
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
