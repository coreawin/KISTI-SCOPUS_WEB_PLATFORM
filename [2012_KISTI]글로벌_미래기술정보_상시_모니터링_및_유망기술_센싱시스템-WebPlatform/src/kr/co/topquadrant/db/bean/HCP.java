package kr.co.topquadrant.db.bean;

import java.io.Serializable;

/**
 * HCP 분석 테이블을 Select전용 Bean class.
 * 
 * @author 정승한
 * 
 */
public class HCP implements Serializable {

	private static final long serialVersionUID = 104424550221564700L;

	String publication_year, asjc_code;
	int document_count = 0 , threshold = 0 , total= 0, ranking=0;

	public String getPublication_year() {
		return publication_year;
	}

	public void setPublication_year(String publication_year) {
		this.publication_year = publication_year;
	}

	public String getAsjc_code() {
		return asjc_code;
	}

	public void setAsjc_code(String asjc_code) {
		this.asjc_code = asjc_code;
	}

	public int getDocument_count() {
		return document_count;
	}

	public void setDocument_count(int document_count) {
		this.document_count = document_count;
	}

	public int getThreshold() {
		return threshold;
	}

	public void setThreshold(int threshold) {
		this.threshold = threshold;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

}
