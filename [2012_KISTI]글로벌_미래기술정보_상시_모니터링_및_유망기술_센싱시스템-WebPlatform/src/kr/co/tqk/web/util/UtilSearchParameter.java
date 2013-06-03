package kr.co.tqk.web.util;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

/**
 * �˻��Ķ���Ϳ� ���� ��ƿ Ŭ����
 * 
 * @author ������
 * 
 */
public class UtilSearchParameter {

	/**
	 * �˻������� �˻� �Ķ���͸� HashMap���·� ��ȯ�Ѵ�.<br>
	 * 
	 * @param baseRequest
	 * @return
	 */
	public static HashMap<String, String> getSearchParameter(
			RequestUtil baseRequest) {
		HashMap<String, String> result = new HashMap<String, String>();
		result.put("cn", baseRequest.getParameter("cn", ""));
		result.put("se", baseRequest.getParameter("se", ""));
		result.put("fl", baseRequest.getParameter("fl", ""));
		result.put("sn", baseRequest.getParameter("sn", ""));
		result.put("ln", baseRequest.getParameter("ln", ""));
		result.put("gr", baseRequest.getParameter("gr", ""));
		result.put("ra", baseRequest.getParameter("ra", ""));
		result.put("ft", baseRequest.getParameter("ft", ""));
		result.put("ht", baseRequest.getParameter("ht", ""));
		result.put("ud", baseRequest.getParameter("ud", ""));
		return result;
	}

	public static ArrayList<NameValuePair> getSearchEngineParameter(
			RequestUtil baseRequest) {
		return getSearchEngineParameter(getSearchParameter(baseRequest));
	}

	public static ArrayList<NameValuePair> getSearchEngineParameter(
			HashMap<String, String> parameter) {
		ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
		for(String key : parameter.keySet()){
			nvps.add(new BasicNameValuePair(key, parameter.get(key)));
		}
		return nvps;
	}

}
