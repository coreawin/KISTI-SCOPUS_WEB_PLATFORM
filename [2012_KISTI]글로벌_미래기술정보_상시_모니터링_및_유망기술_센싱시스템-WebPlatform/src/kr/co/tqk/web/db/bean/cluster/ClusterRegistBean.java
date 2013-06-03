package kr.co.tqk.web.db.bean.cluster;

import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

public class ClusterRegistBean {

	float threshold;
	int seq, maxClusterCnt, minClusterCnt, docCnt, totalDocCnt;
	String userId, title, description, filename;
	Timestamp registDate;

	public int getSeq() {
		return UtilString.nullCkeck(seq);
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public float getThreshold() {
		return UtilString.nullCkeck(threshold);
	}

	public void setThreshold(float threshold) {
		this.threshold = threshold;
	}

	public int getMaxClusterCnt() {
		return UtilString.nullCkeck(maxClusterCnt);
	}

	public void setMaxClusterCnt(int maxClusterCnt) {
		this.maxClusterCnt = maxClusterCnt;
	}

	public int getMinClusterCnt() {
		return UtilString.nullCkeck(minClusterCnt);
	}

	public void setMinClusterCnt(int minClusterCnt) {
		this.minClusterCnt = minClusterCnt;
	}

	public String getUserId() {
		return UtilString.nullCkeck(userId);
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTitle() {
		return UtilString.nullCkeck(title);
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return UtilString.nullCkeck(description);
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getFilename() {
		return UtilString.nullCkeck(filename);
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public Timestamp getRegistDate() {
		return registDate;
	}

	public void setRegistDate(Timestamp registDate) {
		this.registDate = registDate;
	}

	public int getDocCnt() {
		return UtilString.nullCkeck(docCnt);
	}

	public void setDocCnt(int docCnt) {
		this.docCnt = docCnt;
	}

	public int getTotalDocCnt() {
		return UtilString.nullCkeck(totalDocCnt);
	}

	public void setTotalDocCnt(int totalDocCnt) {
		this.totalDocCnt = totalDocCnt;
	}

}
