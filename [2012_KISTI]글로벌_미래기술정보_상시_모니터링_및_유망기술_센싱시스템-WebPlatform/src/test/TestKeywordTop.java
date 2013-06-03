package test;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import kr.co.topquadrant.util.MapValueSort;

public class TestKeywordTop {

	public static void main(String[] args) {
		Map<String, Integer> data = new HashMap<String, Integer>();
		data.put("a", 10);
		data.put("b", 8);
		data.put("c", 6);
		data.put("d", 5);
		data.put("e", 4);
		data.put("f", 3);
		data.put("g", 3);
		data.put("h", 3);
		data.put("i", 3);
		data.put("j", 3);
		data.put("k", 3);
		data.put("l", 3);
		data.put("m", 3);
		data.put("n", 3);
		data.put("o", 1);
		data.put("p", 1);
		data.put("q", 1);
		data = MapValueSort.sortByValue(data);
		Set<String> set = data.keySet();
		int cnt = 0;
		int vt = 0;
		Map<String, Integer> nd = new HashMap<String, Integer>();
		for(String k : set){
			int v = data.get(k);
			if(cnt >= 10 && (v!=vt)){
				break;
			}
			if(cnt >= 10 && vt==1 && v==1){
				break;
			}
			nd.put(k, v);
			vt = v;
			cnt++;
		}
		
		
		System.out.println(MapValueSort.sortByValue(nd));

	}
}
