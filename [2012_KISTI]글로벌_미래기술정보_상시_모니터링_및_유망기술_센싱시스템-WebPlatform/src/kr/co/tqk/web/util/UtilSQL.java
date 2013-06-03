/**
 * 
 */
package kr.co.tqk.web.util;

import java.util.Collections;

/**
 * @author coreawin
 * @sinse 2012. 8. 6.
 * @version 1.0
 * <pre>
 * 2012. 8. 6. : 최초 작성
 * </pre>
 */
public class UtilSQL {
	
	/**
	 * @param length
	 * @return
	 */
	public static String preparePlaceHolders(int length) {
		StringBuilder builder = new StringBuilder(length * 2 - 1);
		for (int i = 0; i < length; i++) {
			if (i > 0)
				builder.append(',');
			builder.append('?');
		}
		return builder.toString();
	}

	/**
	 * @param query
	 * @param length
	 * @return
	 */
	public static String makeQuery(String query, int length) {
		return String.format(query, preparePlaceHolders(length));
	}

}
