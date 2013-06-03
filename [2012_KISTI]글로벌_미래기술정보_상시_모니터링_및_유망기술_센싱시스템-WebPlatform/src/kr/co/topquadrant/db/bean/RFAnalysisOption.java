package kr.co.topquadrant.db.bean;

import java.sql.Timestamp;

public class RFAnalysisOption {

	int seq;
	String contentsJson, reg_user;
	Timestamp reg_date;

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public String getContentsJson() {
		return contentsJson;
	}

	public void setContentsJson(String contentsJson) {
		this.contentsJson = contentsJson;
	}

	public String getReg_user() {
		return reg_user;
	}

	public void setReg_user(String reg_user) {
		this.reg_user = reg_user;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

}
