package kr.co.tqk.web.db.bean.cluster;

import kr.co.tqk.web.util.UtilString;

public class ClusterDataBean {

	public final static String ISDEL_TYPE_N = "N";
	public final static String ISDEL_TYPE_T = "Y";

	int seq, clusterRegistSeq;
	String clusterKey, eids, isdel;

	public int getClusterRegistSeq() {
		return UtilString.nullCkeck(clusterRegistSeq);
	}

	public void setClusterRegistSeq(int clusterRegistSeq) {
		this.clusterRegistSeq = clusterRegistSeq;
	}

	public String getClusterKey() {
		return UtilString.nullCkeck(clusterKey);
	}

	public void setClusterKey(String clusterKey) {
		this.clusterKey = clusterKey;
	}

	public String getEids() {
		return UtilString.nullCkeck(eids);
	}

	public void setEids(String eids) {
		this.eids = eids;
	}

	public String getIsdel() {
		return UtilString.nullCkeck(isdel);
	}

	public void setIsdel(String isdel) {
		this.isdel = isdel;
	}

	public int getSeq() {
		return UtilString.nullCkeck(seq);
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

}
