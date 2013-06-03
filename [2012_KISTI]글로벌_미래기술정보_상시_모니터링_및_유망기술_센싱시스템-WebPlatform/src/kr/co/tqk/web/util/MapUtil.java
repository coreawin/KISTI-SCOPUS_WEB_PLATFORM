package kr.co.tqk.web.util;

import java.util.HashSet;

public class MapUtil {

	/**
	 * @param data
	 * @return
	 */
	public static HashSet<String> converHashSet(String[] data){
		HashSet<String> result = new HashSet<String>();
		for(String v : data){
			v = v.trim();
			if("".equals(v)) continue;
			result.add(v);
		}
		return result;
	}
}
