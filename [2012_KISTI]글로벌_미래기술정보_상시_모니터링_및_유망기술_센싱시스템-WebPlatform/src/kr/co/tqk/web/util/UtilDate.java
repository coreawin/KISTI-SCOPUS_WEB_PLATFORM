package kr.co.tqk.web.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class UtilDate {

	/**
	 * 2011년 11월 23일 12:12:11 초와 같은 형태로 날짜를 반환한다.
	 * @return
	 */
	public static String getDateFormate(Date date) {
		String pattern = "yyyy년 MM월 dd일(E) HH:mm:ss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern, new Locale("ko", "KOREA"));
		String s = formatter.format(date);
		return s;
	}
	
	/**
	 * 2011년 11월 23일 12:12:11 초와 같은 형태로 날짜를 반환한다.
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
