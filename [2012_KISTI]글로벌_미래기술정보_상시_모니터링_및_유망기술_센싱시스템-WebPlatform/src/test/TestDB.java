package test;

import java.util.Map;

import kr.co.tqk.web.db.dao.ScopusTypeDao;

public class TestDB {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		Map<String, String> result = ScopusTypeDao.getKistiAffiliation();
		for(String s : result.keySet()){
			System.out.println(s +"\t" + result.get(s));
		}

	}

}
