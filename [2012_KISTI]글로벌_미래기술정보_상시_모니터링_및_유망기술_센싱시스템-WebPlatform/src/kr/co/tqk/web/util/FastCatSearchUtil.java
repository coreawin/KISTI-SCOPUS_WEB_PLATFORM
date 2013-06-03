package kr.co.tqk.web.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
import org.json.JSONException;
import org.json.JSONObject;

public class FastCatSearchUtil {

	/**
	 * FastCat 검색.
	 * 
	 * @param url
	 *            검색 주소.
	 * @param nvps
	 *            검색 파라미터
	 * @return
	 */
	public static JSONObject requestURL(String url, List<NameValuePair> nvps) {
		JSONObject jsonobj = null;
		HttpClient httpclient = new DefaultHttpClient();
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		HttpPost httpost = new HttpPost(url);
		try {
			 httpost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));
			String responseBody = httpclient.execute(httpost, responseHandler);
			jsonobj = new JSONObject(responseBody);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}finally{
			if(httpclient != null){
				httpclient.getConnectionManager().shutdown();
			}
		}
		return jsonobj;
	}

	/**
	 * 검색서버의 동작 유무를 확인한다. <br>
	 * 동작하지 않으면 false, 동작하면 true를 리턴한다.
	 * 
	 * @param url
	 *            검색서버의 검색 결과 요청 URL
	 * @return
	 */
	public static boolean requestSearchEngineALive(String url) {
		HttpClient httpclient = new DefaultHttpClient();
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		HttpPost httpost = new HttpPost(url);
		try {
			httpclient.execute(httpost, responseHandler);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}finally{
			if(httpclient != null){
				httpclient.getConnectionManager().shutdown();
			}
		}
		return true;
	}
	
	public static void main(String[] args){
		System.out.println(FastCatSearchUtil.requestSearchEngineALive("http://203.250.228.166:9090/search/isAlive"));
	}

}
