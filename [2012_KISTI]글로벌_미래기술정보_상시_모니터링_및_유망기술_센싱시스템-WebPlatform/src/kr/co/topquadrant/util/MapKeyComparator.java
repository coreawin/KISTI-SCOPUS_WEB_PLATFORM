package kr.co.topquadrant.util;

import java.util.Comparator;
import java.util.SortedMap;
import java.util.TreeMap;

public class MapKeyComparator<T> implements Comparator<T> {
	boolean isDesc = false;

	public MapKeyComparator(boolean isDesc) {
		this.isDesc = isDesc;
	}

	public MapKeyComparator() {
		
	}

	public int compare(T o1, T o2) {
		if(isDesc){
		}
		return 0;
	}

}
