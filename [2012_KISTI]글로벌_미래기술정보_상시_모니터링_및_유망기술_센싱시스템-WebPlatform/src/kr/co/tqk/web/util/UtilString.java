package kr.co.tqk.web.util;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class UtilString {

	/**
	 * null 문자열이든 null 이면 빈문자열을 리턴한다.
	 * 
	 * @param str
	 * @param isTrim
	 *            str.trim()여부
	 * @return
	 */
	public static String nullCkeck(String str, boolean isTrim) {
		String result = str;
		if (str == null)
			return "";

		if ("null".equalsIgnoreCase(str.trim())) {
			result = " ";
		}

		return isTrim ? result.trim() : result;
	}

	/**
	 * null 문자열이든 null 이면 한칸띄워진 문자를 리턴한다.
	 * 
	 * @param str
	 * @param isTrim
	 *            str.trim()여부
	 * @return
	 */
	public static String nullCkeck(String str) {
		return nullCkeck(str, false);
	}

	/**
	 * @param v
	 * @return
	 */
	public static int nullCkeck(int v) {
		try {
			Integer.parseInt(String.valueOf(v));
			return v;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * @param v
	 * @return
	 */
	public static float nullCkeck(float v) {
		try {
			Float.parseFloat(String.valueOf(v));
			return v;
		} catch (Exception e) {
			return 0;
		}
	}

	/**
	 * Where 조건식을 만든다.
	 * 
	 * @param set
	 * @param isOrCondition
	 *            true이면 or 조건으로 만들고 false이면 and 조건으로 만든다.
	 * @return
	 */
	public static String whereContidion(Set<String> set, boolean isOrCondition) {
		StringBuffer whereCondition = new StringBuffer();
		for (int idx = 0; idx < set.size(); idx++) {
			if (idx == 0) {
				whereCondition.append(" (");
			}
			if ((set.size() - 1) == idx) {
				whereCondition.append(" eid=? ");
			} else {
				if (isOrCondition) {
					whereCondition.append(" eid=? or ");
				} else {
					whereCondition.append(" eid=? and ");
				}
			}
		}
		whereCondition.append(" ) ");
		return whereCondition.toString();
	}

	public static void main(String[] args) {
		Set<String> set = new HashSet<String>();
		set.add("ABB");
		set.add("CDD");
		set.add("QWE");
		System.out.println(UtilString.whereINContidion(set));
	}

	public static String whereINContidion(Set<String> set) {
		StringBuffer whereCondition = new StringBuffer();
		int idx = 0;
		whereCondition.append(" ( ");
		for (String s : set) {
			whereCondition.append("?");
			if ((set.size() - 1) != idx++) {
				whereCondition.append(",");
			}
		}
		whereCondition.append(" ) ");
		return whereCondition.toString();
	}

	/**
	 * Where 조건식을 만든다.
	 * 
	 * @param set
	 * @param isOrCondition
	 *            true이면 or 조건으로 만들고 false이면 and 조건으로 만든다.
	 * @return
	 */
	public static String whereContidionSetData(Set<String> set, String column, boolean isOrCondition) {
		StringBuffer whereCondition = new StringBuffer();
		int idx = 0;
		for (String d : set) {
			if (idx == 0) {
				whereCondition.append(" (");
			}
			if ((set.size() - 1) == idx) {
				whereCondition.append(" ");
				whereCondition.append(column);
				whereCondition.append("='");
				whereCondition.append(d);
				whereCondition.append("' ");
			} else {
				if (isOrCondition) {
					whereCondition.append(" ");
					whereCondition.append(column);
					whereCondition.append("='");
					whereCondition.append(d);
					whereCondition.append("' or");
				} else {
					whereCondition.append(" ");
					whereCondition.append(column);
					whereCondition.append("='");
					whereCondition.append(d);
					whereCondition.append("' and");
				}
			}
			idx++;
		}
		whereCondition.append(" ) ");
		return whereCondition.toString();
	}

	/**
	 * Where 조건식을 만든다.
	 * 
	 * @param set
	 * @param columnName
	 *            조건 컬럼 명.
	 * @param isOrCondition
	 *            true이면 or 조건으로 만들고 false이면 and 조건으로 만든다.
	 * @return
	 */
	public static String whereContidion(Set<String> set, String columnName, boolean isOrCondition) {
		StringBuffer whereCondition = new StringBuffer();
		for (int idx = 0; idx < set.size(); idx++) {
			if (idx == 0) {
				whereCondition.append(" (");
			}
			if ((set.size() - 1) == idx) {
				whereCondition.append(" ");
				whereCondition.append(columnName);
				whereCondition.append("=?");
				whereCondition.append(" ");
			} else {
				if (isOrCondition) {
					whereCondition.append(" ");
					whereCondition.append(columnName);
					whereCondition.append("=? or ");
				} else {
					whereCondition.append(" ");
					whereCondition.append(columnName);
					whereCondition.append("=? and ");
				}
			}
		}
		whereCondition.append(" ) ");
		return whereCondition.toString();
	}

	public static Timestamp nullCkeck(Timestamp insertTime) {
		return insertTime;
	}

	public static HashMap<String, String> nullCkeck(HashMap<String, String> countryType) {
		return new HashMap<String, String>();
	}

}
