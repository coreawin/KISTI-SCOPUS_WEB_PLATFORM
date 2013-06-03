package kr.co.tqk.analysis.util;

import java.text.DecimalFormat;

public class NumberFormatUtil {

	/**
	 * 소수점자리수를 표현한다.
	 * 
	 * @param num
	 *            원본 데이터
	 * @param cnt
	 *            소수점 표현 자리수.
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
	 * 숫자를 소숫점 형태로 변환한다.<br>
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
	 * 숫자를 소숫점 형태로 변환한다.<br>
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
