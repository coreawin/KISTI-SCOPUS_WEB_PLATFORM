package kr.co.tqk.web.db.bean;

import java.util.LinkedList;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.web.util.UtilString;

public class AffilationBean {

	String eid;
	int groupSequence;
	String orgName, countryCode, afid, dftid, delegateOrgName;
	SortedMap<Integer, AuthorBean> authorRankingMap = new TreeMap<Integer, AuthorBean>();

	public AffilationBean(String eid) {
		this.eid = eid;
	}

	public String getEid() {
		return eid;
	}

	public int getGroupSequence() {
		return groupSequence;
	}

	public void setGroupSequence(int groupSequence) {
		this.groupSequence = groupSequence;
	}

	public void addAuthor(AuthorBean e) {
		authorRankingMap.put(e.getRanking(), e);
	}

	public LinkedList<AuthorBean> getAuthorList() {
		LinkedList<AuthorBean> authorList = new LinkedList<AuthorBean>();
		for (AuthorBean e : authorRankingMap.values()) {
			authorList.add(e);
		}

		return authorList;
	}

	public String getOrgName() {
		return UtilString.nullCkeck(orgName);
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getCountryCode() {
		return UtilString.nullCkeck(countryCode);
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

	public String getAfid() {
		return UtilString.nullCkeck(afid);
	}

	public void setAfid(String afid) {
		this.afid = afid;
	}

	public String getDftid() {
		return UtilString.nullCkeck(dftid);
	}

	public void setDftid(String dftid) {
		this.dftid = dftid;
	}

	public String getDelegateOrgName() {
		return UtilString.nullCkeck(delegateOrgName);
	}

	public void setDelegateOrgName(String delegateOrgName) {
		this.delegateOrgName = delegateOrgName;
	}

	public SortedMap<Integer, AuthorBean> getAuthorRankingMap() {
		return authorRankingMap;
	}

	public void setAuthorRankingMap(
			SortedMap<Integer, AuthorBean> authorRankingMap) {
		this.authorRankingMap = authorRankingMap;
	}

}
