<%@page import="java.sql.Timestamp"%>
<%@page import="kr.co.tqk.web.util.UtilDate"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportText"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportInfoDao"%>
<%@page import="kr.co.tqk.web.db.bean.export.ExportInfoBean"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportDocument"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportCluster"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportExcelJXL"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="org.apache.http.NameValuePair"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.util.UtilSearchParameter"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportExcel"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.sql.Connection"%><%@page import="kr.co.tqk.db.ConnectionFactory"%><%@ page language="java" contentType="text/html; charset=UTF-8" session="true" pageEncoding="UTF-8"%><%@include file="./common.jsp" %><%
try{	
	HashMap<String, String> searchParameter = UtilSearchParameter.getSearchParameter(baseRequest);
	Object sessionObj = session.getAttribute(session.getId() + "_EXPORT_INFO");
	String info = "";
	if(sessionObj!=null){
		info = ((ExportInfoBean)sessionObj).getContents();
	}
	if(info.indexOf("javascript:download")!=-1){
		session.removeAttribute(session.getId() + "_EXPORT_INFO");
	}
	int selectDocSize = baseRequest.getInteger("selectDocSize", 0);
	
	String exportFormat = request.getParameter("exportFormat");
	
	String userID = request.getParameter("userID");
	String sessionID = request.getParameter("sessionID");
	
	String checkList = request.getParameter("checkList");
	int data_range = baseRequest.getInteger("data_range", 0);
	LinkedHashSet<String> eidSet = new LinkedHashSet<String>();
	LinkedList<LinkedHashSet<String>> eidList = new LinkedList<LinkedHashSet<String>>();
	int downloadNumber = 0;
	boolean searchSuccess = true;
	if(session.getAttribute("EXPORT_SESSION_ID")==null){
		if(data_range < 0){
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Collection document eid  0/"+downloadNumber));
			eidSet = (LinkedHashSet<String>)session.getAttribute(userID + "_selectDocSet");
			eidList.add(eidSet);
			downloadNumber = eidSet.size();
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Collection document eid  "+downloadNumber+"/"+downloadNumber));
			ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Collection document eid  "+downloadNumber+"/"+downloadNumber);
		}else{
			int totalSize = baseRequest.getInteger("totalSize", 1);
			int startNumber = baseRequest.getInteger("startNumber", 1);
			int endNumber = baseRequest.getInteger("endNumber", 1);
			downloadNumber = (endNumber-startNumber)+1;
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Collection document eid  0/"+downloadNumber));
			ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Collection document eid  0/"+downloadNumber);
			int divisionCnt = 1000;
			
			if(endNumber < startNumber + divisionCnt){
				divisionCnt = endNumber-startNumber + 1;
			}
			while(true){
				System.out.println(startNumber +"\t" + endNumber +"\t" + divisionCnt);
				session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Collection document eid "+(downloadNumber - (endNumber - startNumber))+"/"+downloadNumber));
				ExportInfoDao.mergeInto(
						sessionID + "_EXPORT_INFO", 
						"Collection document eid "+(downloadNumber - (endNumber - startNumber))+"/"+downloadNumber);
				searchParameter.put("sn", String.valueOf(startNumber));
				searchParameter.put("ln", String.valueOf(divisionCnt));
				searchParameter.put("fl", "eid");
				searchParameter.put("gr", "");
				searchParameter.put("timeout", "60");
				ArrayList<NameValuePair> searchValue = UtilSearchParameter.getSearchEngineParameter(searchParameter);
				JSONObject jsonObject = FastCatSearchUtil.requestURL(fastcatSearchURL, searchValue);
				eidSet = new LinkedHashSet<String>();
				//System.out.println("status " + jsonObject.getInt("status"));
				//System.out.println("time " + jsonObject.getString("time"));
				if(jsonObject.getInt("status") == 0){
					JSONArray resultArr = null;
					try{
						resultArr = jsonObject.getJSONArray("result");
					}catch(Exception e){
						break;
					}
					if(resultArr==null) break;
					for (int i=0;i<resultArr.length();i++) {
						JSONObject jsonrecord = resultArr.getJSONObject(i);
						String eid = jsonrecord.getString("eid");
						eidSet.add(eid);
						if(eidSet.size()==200){
							eidList.add(eidSet);
							eidSet = new LinkedHashSet<String>();
						}
					}
					eidList.add(eidSet);
					startNumber += divisionCnt;
					
				}else{
					System.out.println("search err");
					searchSuccess = false;
					break;
				}
				if(endNumber < startNumber + divisionCnt){
					divisionCnt = endNumber - startNumber + 1;
				}
				
				if(startNumber > endNumber) {
					System.out.println("startNumber > endNumber " + (startNumber) +"\t" + endNumber );
					break;
				}
				if(divisionCnt==0) {
					System.out.println("divisionCnt==0 " + (startNumber) +"\t" + endNumber );
					break;
				}
			}
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Collection document eid Complete."));
			ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Collection document eid Complete.");
		}
		System.out.println("새로운 데이터를 다운로드 받는다.");
		session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Export for ready."));
		ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Export for ready.");
		HashSet<String> selectedCheck = new HashSet<String>();
		//System.out.println(checkList);
		for(String check : checkList.split(";")){
			selectedCheck.add(check);
		}
		ExportDocument exportDocument = null;
		String downloadFileName = "";
		if(!searchSuccess) throw new Exception("검색엔진을 통해 데이터를 제대로 가져오지 못했습니다.");
		
		String fileName = UtilDate.getTimestampFormat(new Timestamp(System.currentTimeMillis()), "yyyyMMdd_hhmmss");
		if("cluster".equals(exportFormat)){
			downloadFileName = fileName +".cluster.txt";
			exportDocument = new ExportCluster(tmpSavePath + downloadFileName);
		}else if("text".equals(exportFormat)){
			downloadFileName = fileName +".mini.txt";
			System.out.println("selectedCheck ");
			exportDocument = new ExportText(tmpSavePath+downloadFileName, selectedCheck);
		}else{
			downloadFileName = fileName +".xlsx";
			exportDocument = new ExportExcelJXL(modelPath + "ExportBasicFormat.xlsx", tmpSavePath + downloadFileName, selectedCheck);
		}
		//세션당 중복요청을 방지하기 위함.
		//session.setAttribute("EXPORT_SESSION_ID", sessionID);
		//System.out.println("exportFormat " + exportFormat);
		//System.out.println("sessionID " + sessionID);
		
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		try{
			conn = cf.getConnection();
			int cnt = 0;
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... 0/"+ downloadNumber));
			ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... 0/"+ downloadNumber);
			System.out.println(sessionID + " export... 0/"+ downloadNumber);
			for(LinkedHashSet<String> set : eidList){
				cnt += set.size();
				exportDocument.exportData(conn, set);
				session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... "+(cnt)+"/"+ downloadNumber));
				ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... "+(cnt)+"/"+ downloadNumber);
				System.out.println(sessionID + " export... "+(cnt)+"/"+ downloadNumber);
			}
			//System.out.println("export Complete!!");
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>"));
			ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>");
		}catch(Exception e){
			e.printStackTrace();
			out.println(e.getMessage());
			System.out.println(e.getMessage());
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean(e.getMessage()));
		}finally{
			exportDocument.close();
			//session.removeAttribute("EXPORT_SESSION_ID");
			//ExportInfoDao.remove(sessionID + "_EXPORT_INFO");
			cf.close(conn);
		}
	}else{
		//이미 해당 세션으로 export가 진행중이다.
		out.println("이미 export가 진행중.");
		System.out.println("이미 export가 진행중.");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
