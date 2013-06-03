package kr.co.tqk.web.db.bean;

import java.util.LinkedHashMap;

/**
 * ASJC ÄÚµå
 * 
 * @author Á¤½ÂÇÑ
 * 
 */
public class ScopusASJCBean {

	String eid;

	public ScopusASJCBean(String _eid) {
		this.eid = _eid;
	}

	LinkedHashMap<String, String> asjcSet = new LinkedHashMap<String, String>();

	public void addAsjc(String asjc, String desc) {
		asjcSet.put(asjc, desc);
	}

	public LinkedHashMap<String, String> getAsjcSet() {
		return asjcSet;
	}
}
