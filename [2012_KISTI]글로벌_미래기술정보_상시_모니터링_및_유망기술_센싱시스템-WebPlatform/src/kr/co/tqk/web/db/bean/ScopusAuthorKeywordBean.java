package kr.co.tqk.web.db.bean;

import java.util.LinkedHashSet;

/**
 * ���� Ű����
 * 
 * @author ������
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
