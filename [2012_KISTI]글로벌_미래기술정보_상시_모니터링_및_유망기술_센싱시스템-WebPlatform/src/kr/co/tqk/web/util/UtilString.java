package kr.co.tqk.web.util;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class UtilString {

	/**
	 * null ���ڿ��̵� null �̸� ���ڿ��� �����Ѵ�.
	 * 
	 * @param str
	 * @param isTrim
	 *            str.trim()����
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
	 * null ���ڿ��̵� null �̸� ��ĭ����� ���ڸ� �����Ѵ�.
	 * 
	 * @param str
	 * @param isTrim
	 *            str.trim()����
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
	 * Where ���ǽ��� �����.
	 * 
	 * @param set
	 * @param isOrCondition
	 *            true�̸� or �������� ����� false�̸� and �������� �����.
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
	 * Where ���ǽ��� �����.
	 * 
	 * @param set
	 * @param isOrCondition
	 *            true�̸� or �������� ����� false�̸� and �������� �����.
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
	 * Where ���ǽ��� �����.
	 * 
	 * @param set
	 * @param columnName
	 *            ���� �÷� ��.
	 * @param isOrCondition
	 *            true�̸� or �������� ����� false�̸� and �������� �����.
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
