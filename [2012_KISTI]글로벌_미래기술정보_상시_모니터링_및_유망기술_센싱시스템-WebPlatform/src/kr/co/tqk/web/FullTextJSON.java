/**
 * 
 */
package kr.co.tqk.web;

import kr.co.tqk.web.util.UtilString;

import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import com.google.gson.Gson;

/**
 * @author coreawin
 * @sinse 2012. 10. 23.
 * @version 1.0
 * @history 2012. 10. 23. : 최초 작성 <br>
 * 
 */
public class FullTextJSON {

//	Map<String, String> resultSummary;
//
//	public Map<String, String> getResultSummary() {
//		return resultSummary;
//	}

	public class JournalInfo {
		String deeplink;

		public String getDeepLink() {
			return deeplink;
		}
	}

	public class OutputDataInfo {
//		JournalInfo journalInfo;
		JournalInfo articleInfo;
//
//		public JournalInfo getJournalInfo() {
//			return journalInfo;
//		}
//
		public JournalInfo getArticleInfo() {
			return articleInfo;
		}
	}

	OutputDataInfo[] outputData;

	public OutputDataInfo[] getOutputData() {
		return outputData;
	}

	public static void main(String[] args) {
		String url = "http://openapi.ndsl.kr/linkResolver.do?keyValue=02285882&returnType=json&version=3.0&Target=A&callback=aa&id=doi:10.1016%2Fj.ijheatfluidflow.2005.02.004";
		request(url);
	}

	public static String request(String url) {
		HttpClient httpclient = new DefaultHttpClient();
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		HttpPost httpost = new HttpPost(url);
		String deeplink = "";
		try {
			String responseBody = httpclient.execute(httpost, responseHandler).trim();
			if (responseBody.length() > 3) {
				try{
					responseBody = responseBody.substring(responseBody.indexOf("{"), responseBody.lastIndexOf("}") + 1);
				}catch(Exception e){
					//ignore
					return "";
				}
			}
			System.out.println(responseBody);
			Gson g = new Gson();
			FullTextJSON f = g.fromJson(responseBody.trim(), FullTextJSON.class);
			OutputDataInfo[] infos = f.getOutputData();
			for (OutputDataInfo odi : infos) {
				deeplink = UtilString.nullCkeck(odi.getArticleInfo().getDeepLink(), true);
//				if ("".equals(deeplink)) {
//					for (JournalInfo ai : odi.getArticleInfo()) {
//						deeplink = UtilString.nullCkeck(ai.getDeepLink(), true);
//						if (!"".equals(deeplink)) {
//							break;
//						}
//					}
//				}
				if (!"".equals(deeplink)) {
					break;
				}
			}
			System.out.println(deeplink);
			if (deeplink == null) {
				deeplink = "";
			} else {
				deeplink.trim();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (httpclient != null) {
				httpclient.getConnectionManager().shutdown();
			}
		}
		return UtilString.nullCkeck(deeplink, true);
	}

}
