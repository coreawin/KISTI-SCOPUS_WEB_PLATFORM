package kr.co.tqk.web.db.bean;

import java.util.HashMap;
import java.util.HashSet;

import kr.co.tqk.web.util.UtilString;

public class ScopusIndexKeywordBean {
	String eid;

	public String getEid() {
		return UtilString.nullCkeck(eid);
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public HashMap<String, HashSet<String>> getIndexKeywordMap() {
		return indexKeywordMap;
	}

	HashMap<String, HashSet<String>> indexKeywordMap = new HashMap<String, HashSet<String>>();

	public void insertIndexKeyword(String type, String keyword) {
		HashSet<String> keywords = null;
		if (indexKeywordMap.get(type) == null) {
			keywords = new HashSet<String>();
		} else {
			keywords = indexKeywordMap.get(type);
		}
		keywords.add(keyword);
		indexKeywordMap.put(type, keywords);
	}
}
