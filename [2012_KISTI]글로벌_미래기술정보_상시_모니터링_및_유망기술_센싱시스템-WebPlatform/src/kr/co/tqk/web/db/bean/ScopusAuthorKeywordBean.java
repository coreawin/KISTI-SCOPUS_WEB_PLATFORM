package kr.co.tqk.web.db.bean;

import java.util.LinkedHashSet;

/**
 * 저자 키워드
 * 
 * @author 정승한
 * 
 */
public class ScopusAuthorKeywordBean {

	LinkedHashSet<String> keywordList = new LinkedHashSet<String>();

	public void addKeyword(String keyword) {
		keywordList.add(keyword);
	}

	public LinkedHashSet<String> getKeywordList() {
		return keywordList;
	}
}
