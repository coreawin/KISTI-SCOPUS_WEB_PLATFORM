package kr.co.tqk.web.db.bean.cluster;

import kr.co.tqk.web.util.UtilString;

import org.apache.commons.collections.map.MultiKeyMap;

public class ClusterSimilityDataBean {

	int clusterRegistSeq;
	MultiKeyMap keyMap = new MultiKeyMap();

	public int getClusterRegistSeq() {
		return UtilString.nullCkeck(clusterRegistSeq);
	}

	public void setClusterRegistSeq(int clusterRegistSeq) {
		this.clusterRegistSeq = clusterRegistSeq;
	}

	/**
	 * @param word1
	 * @param word2
	 * @return -1 이면 해당 값에 대한 유사도 계수가 존재 하지 않음.
	 */
	public float getSimility(String word1, String word2) {
		float simility = -1;
		String v = (String) keyMap.get(word1, word2);
		if (v == null) {
			v = (String) keyMap.get(word2, word1);
		}
		if (v != null) {
			try {
				simility = Float.parseFloat(v);
			} catch (NumberFormatException nfe) {
				// ignore;
				simility = -1;
			}
		}
		return simility;
	}

	public void addSimilityData(String word1, String word2, String simility) {
		keyMap.put(word1, word2, simility);
	}

	public MultiKeyMap getKeyMap() {
		return keyMap;
	}

}
