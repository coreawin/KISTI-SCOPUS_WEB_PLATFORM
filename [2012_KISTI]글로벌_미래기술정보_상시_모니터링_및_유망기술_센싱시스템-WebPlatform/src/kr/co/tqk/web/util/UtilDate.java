package kr.co.tqk.web.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class UtilDate {

	/**
	 * 2011�� 11�� 23�� 12:12:11 �ʿ� ���� ���·� ��¥�� ��ȯ�Ѵ�.
	 * @return
	 */
	public static String getDateFormate(Date date) {
		String pattern = "yyyy�� MM�� dd��(E) HH:mm:ss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern, new Locale("ko", "KOREA"));
		String s = formatter.format(date);
		return s;
	}
	
	/**
	 * 2011�� 11�� 23�� 12:12:11 �ʿ� ���� ���·� ��¥�� ��ȯ�Ѵ�.
	 * @return
	 */
	public static String getTimestampFormat(Timestamp t) {
		if(t==null) return "";
		String pattern = "yyyyMMdd";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern, new Locale("ko", "KOREA"));
		String s = formatter.format(t);
		return s;
	}
	
	public static String getTimestampFormat(Timestamp t, String pattern) {
		if(t==null) return "";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern, new Locale("ko", "KOREA"));
		String s = formatter.format(t);
		return s;
	}
}
