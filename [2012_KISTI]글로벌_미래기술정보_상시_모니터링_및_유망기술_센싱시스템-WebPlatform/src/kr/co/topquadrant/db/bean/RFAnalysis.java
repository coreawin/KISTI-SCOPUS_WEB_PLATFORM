package kr.co.topquadrant.db.bean;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import kr.co.topquadrant.db.mybatis.MyBatisParameter;

public class RFAnalysis {

	int seq, totalCount, totalPage;
	int update_flag;
	String showMirian = "";
	String title, description, add_science = MyBatisParameter.R, add_nature = MyBatisParameter.R, reg_user, mod_user;
	Timestamp reg_date_first, mod_date;

	private List<String> asjcList = new ArrayList<String>();

	public int getSeq() {
		return seq;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAdd_science() {
		return add_science;
	}

	public void setAdd_science(String add_science) {
		this.add_science = add_science;
	}

	public String getAdd_nature() {
		return add_nature;
	}

	public void setAdd_nature(String add_nature) {
		this.add_nature = add_nature;
	}

	public String getReg_user() {
		return reg_user;
	}

	public void setReg_user(String reg_user) {
		this.reg_user = reg_user;
	}

	public String getMod_user() {
		return mod_user;
	}

	public void setMod_user(String mod_user) {
		this.mod_user = mod_user;
	}

	public void setREG_DATE(Timestamp rEG_DATE) {
		reg_date_first = rEG_DATE;
	}

	public void setMOD_DATE(Timestamp mOD_DATE) {
		mod_date = mOD_DATE;
	}

	public List<String> getAsjcList() {
		return asjcList;
	}

	public void setAsjcList(List<String> asjcList) {
		this.asjcList = asjcList;
	}

	public void setAsjcCode(String asjc) {
		this.asjcList.add(asjc);
	}

	public Timestamp getReg_date_first() {
		return reg_date_first;
	}

	public String getReg_date_firstString() {
		if (getReg_date_first() == null) {
			return "";
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(getReg_date_first());
	}

	public void setReg_date_first(Timestamp reg_date_first) {
		this.reg_date_first = reg_date_first;
	}

	public Timestamp getMod_date() {
		return mod_date;
	}

	public String getMod_dateString() {
		if (getMod_date() == null) {
			return "";
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(getMod_date());
	}

	public void setMod_date(Timestamp mod_date) {
		this.mod_date = mod_date;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getUpdate_flag() {
		return update_flag;
	}

	public void setUpdate_flag(int update_flag) {
		this.update_flag = update_flag;
	}

	public String getShowMirian() {
		return showMirian;
	}

	public void setShowMirian(String showMirian) {
		this.showMirian = showMirian;
	}

}
