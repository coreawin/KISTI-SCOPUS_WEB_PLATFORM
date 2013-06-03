package kr.co.tqk.web.util;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;


/**
 * 
 * ���? Request�� ��ȯ�ϱ� '�� /ƿ Ŭ����.
 * 
 * @author neon
 */
public class RequestUtil extends HttpServletRequestWrapper {
	/**
	 * ����
	 * 
	 * @param request
	 *            HttpServletRequest
	 */
	public RequestUtil(HttpServletRequest request) {
		super(request);
		try {
			//request.setCharacterEncoding("euc-kr"); 
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			// ignore
		}
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; ��´�.
	 * 
	 * @param pName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; ��´�.
	 */
	public String getParameter(String pName, String defaultValue) {
		String value = getParameter(pName);
		if (value != null)
			value.trim();
		return (value == null || "".equals(value) || "null".equals(value) ? defaultValue
				: value);
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; ��´�.
	 * 
	 * @param pName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; ��´�.
	 */
	public String[] getParameterValues(String pName, String[] defaultValue) {
		String[] values = getParameterValues(pName);
		return (values == null || values.length == 0 ? defaultValue : values);
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; Boolean Ÿ��8�� ��´�.
	 * 
	 * @param sName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; Boolean Ÿ��8�� ��´�.
	 */
	public boolean getBoolean(String sName, boolean defaultValue) {
		String value = getParameter(sName);
		if (null == value || "".equals(value)) {
			return defaultValue;
		}
		value = value.trim().toUpperCase();
		boolean retr;
		if (value.equals("TRUE") || value.equals("ON") || value.equals("1")) {
			retr = true;
		} else if (value.equals("FALSE") || value.equals("OFF")
				|| value.equals("0")) {
			retr = false;
		} else {
			retr = defaultValue;
		}
		return retr;
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; Integer ��8�� ��´�.
	 * 
	 * @param sName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; Integer ��8�� ��´�.
	 */
	public int getInteger(String sName, int defaultValue) {
		String value = getParameter(sName);
		if (null == value || "".equals(value)) {
			return defaultValue;
		} else {
			return Integer.parseInt(value);
		}
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; Long Ÿ��8�� ��´�.
	 * 
	 * @param sName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; Long Ÿ��8�� ��´�.
	 */
	public long getLong(String sName, long defaultValue) {
		String value = getParameter(sName);
		if (null == value || "".equals(value)) {
			return defaultValue;
		} else {
			return Long.parseLong(value);
		}
	}

	/**
	 * ��۵Ǵ� �Ķ���� ��; Char Ÿ��8�� ��´�.
	 * 
	 * @param sName
	 *            �Ķ���� �̸�
	 * @param defaultValue
	 *            �Ķ���Ͱ� x������ ��; ��� ��d�� ��.
	 * @return ��۵Ǵ� �Ķ���� ��; Char Ÿ��8�� ��´�.
	 */
	public char getCharacter(String sName, char defaultValue) {
		String value = getParameter(sName);
		if (null == value || "".equals(value)) {
			return defaultValue;
		} else {
			return value.charAt(0);
		}
	}

	/**
	 * Context��; ������ URL �ּҸ� ��´�.
	 * 
	 * @return Context��; ������ URL �ּ�
	 */
	public String getRequestContextURL() {
		String servletPath = getServletPath();
		StringBuffer sb = getRequestURL();
		sb.delete(sb.length() - servletPath.length(), sb.length());
		return sb.toString();
	}
}
