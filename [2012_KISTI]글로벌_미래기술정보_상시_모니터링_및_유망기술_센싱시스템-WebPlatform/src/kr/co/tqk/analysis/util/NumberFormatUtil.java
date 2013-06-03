package kr.co.tqk.analysis.util;

import java.text.DecimalFormat;

public class NumberFormatUtil {

	/**
	 * �Ҽ����ڸ����� ǥ���Ѵ�.
	 * 
	 * @param num
	 *            ���� ������
	 * @param cnt
	 *            �Ҽ��� ǥ�� �ڸ���.
	 * @return
	 */
	public static String getDecimalFormat(float num, int cnt) {
		String pattern = "########";
		if (cnt > 0) {
			pattern += ".";
		}
		for (int idx = 0; idx < cnt; idx++) {
			pattern += "#";
		}
		DecimalFormat format = new DecimalFormat(pattern);
		return format.format(num);
	}
	
	public static String getDecimalFormat(int num) {
		String pattern = "##,###,###,###";
		DecimalFormat format = new DecimalFormat(pattern);
		return format.format(num);
	}

	/**
	 * ���ڸ� �Ҽ��� ���·� ��ȯ�Ѵ�.<br>
	 * 
	 * @param value
	 * @return
	 */
	public static float convertNumberPointFormat(float value, int pointCnt) {

		String pattern = "###,###,###";
		for (int idx = 0; idx < pointCnt; idx++) {
			if (idx == 0)
				pattern += ".";
			pattern += "#";
		}
		DecimalFormat df = new DecimalFormat(pattern);
		return Float.parseFloat(df.format(value));
	}

	/**
	 * ���ڸ� �Ҽ��� ���·� ��ȯ�Ѵ�.<br>
	 * 
	 * @param value
	 * @return
	 */
	public static double convertNumberPointFormat(double value, int pointCnt) {

		String pattern = "###,###,###";
		for (int idx = 0; idx < pointCnt; idx++) {
			if (idx == 0)
				pattern += ".";
			pattern += "#";
		}
		DecimalFormat df = new DecimalFormat(pattern);
		return Double.parseDouble(df.format(value));
	}

}
