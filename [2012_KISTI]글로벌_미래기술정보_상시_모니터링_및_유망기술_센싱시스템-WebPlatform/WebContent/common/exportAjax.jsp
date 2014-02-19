<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="kr.co.tqk.web.util.UtilDate"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportText"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportInfoDao"%>
<%@page import="kr.co.tqk.web.db.bean.export.ExportInfoBean"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportDocument"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportDocumentSax"%>
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
	Logger logger = LoggerFactory.getLogger(getClass());
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
	LinkedHashMap<String, String> xmlDatas = new LinkedHashMap<String, String>(); 
	LinkedHashMap<String, String> citXmlDatas = new LinkedHashMap<String, String>();
	
	LinkedList<LinkedHashSet<String>> eidList = new LinkedList<LinkedHashSet<String>>();
	
	int downloadNumber = 0;
	boolean searchSuccess = true;
	if(session.getAttribute("EXPORT_SESSION_ID")==null){
		ExportDocumentSax exportDocument = null;
		String downloadFileName = "";
		int totalSize = baseRequest.getInteger("totalSize", 1);
		int startNumber = baseRequest.getInteger("startNumber", 1);
		int endNumber = baseRequest.getInteger("endNumber", 1);
		int divisionCnt = 100;
		if(data_range < 0){
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export documents  0/"+downloadNumber));
			eidSet = (LinkedHashSet<String>)session.getAttribute(userID + "_selectDocSet");
			eidList.add(eidSet);
			downloadNumber = eidSet.size();
			startNumber = 1;
			endNumber =downloadNumber;
			String se = "{eid:(";
			for(String eid : eidSet){
				se += eid +" ";
			}
			se += ")}";
			searchParameter.put("se", se);
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export documents  "+downloadNumber+"/"+downloadNumber));
			ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "export documents  "+downloadNumber+"/"+downloadNumber);
		}else{
			downloadNumber = (endNumber-startNumber)+1;
			//session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export documents  0/"+downloadNumber));
			//ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "export documents  0/"+downloadNumber);
			if(endNumber < startNumber + divisionCnt){
				divisionCnt = endNumber-startNumber + 1;
			}
			logger.debug("새로운 데이터를 다운로드 받는다.");
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Export for ready."));
			ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Export for ready.");
		}
		HashSet<String> selectedCheck = new HashSet<String>();
		logger.debug(checkList);
		for(String check : checkList.split(";")){
			selectedCheck.add(check);
		}
		String fileName = UtilDate.getTimestampFormat(new Timestamp(System.currentTimeMillis()), "yyyyMMdd_HHmmss");
		logger.debug("selectedCheck " + selectedCheck);
		if("cluster".equals(exportFormat)){
			downloadFileName = fileName +".cluster.txt";
			exportDocument = new ExportCluster(tmpSavePath + downloadFileName);
		}else if("text".equals(exportFormat)){
			downloadFileName = fileName +".mini.txt";
			logger.debug("selectedCheck ");
			exportDocument = new ExportText(tmpSavePath+downloadFileName, selectedCheck);
		}else{
			downloadFileName = fileName +".xlsx";
			exportDocument = new ExportExcelJXL(modelPath + "ExportBasicFormat.xlsx", tmpSavePath + downloadFileName, selectedCheck);
		}
		logger.debug("downloadFileName " + downloadFileName);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		try{
			conn = cf.getConnection();
			int cnt = 0;
			while(true){
				logger.debug(startNumber +"\t" + endNumber +"\t" + divisionCnt);
				session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export documents "+(downloadNumber - (endNumber - startNumber))+"/"+downloadNumber));
				ExportInfoDao.mergeInto(
						sessionID + "_EXPORT_INFO", 
						"export documents "+(downloadNumber - (endNumber - startNumber))+"/"+downloadNumber);
				searchParameter.put("sn", String.valueOf(startNumber));
				searchParameter.put("ln", String.valueOf(divisionCnt));
				searchParameter.put("fl", "eid,xml,xmlcitedby");
				searchParameter.put("gr", "");
				searchParameter.put("timeout", "60");
				ArrayList<NameValuePair> searchValue = UtilSearchParameter.getSearchEngineParameter(searchParameter);
				JSONObject jsonObject = FastCatSearchUtil.requestURL(fastcatSearchURL, searchValue);
				eidSet = new LinkedHashSet<String>();
				//logger.debug("status " + jsonObject.getInt("status"));
				//logger.debug("time " + jsonObject.getString("time"));
				if(jsonObject.getInt("status") == 0){
					JSONArray resultArr = null;
					try{
						resultArr = jsonObject.getJSONArray("result");
					}catch(Exception e){
						break;
					}
					if(resultArr==null) break;
					xmlDatas.clear();
					citXmlDatas.clear();
					//logger.debug("검색 요청");
					for (int i=0;i<resultArr.length();i++) {
						JSONObject jsonrecord = resultArr.getJSONObject(i);
						String eid = jsonrecord.getString("eid");
						String xml = jsonrecord.getString("xml").trim();
						String xmlcitedby = jsonrecord.getString("xmlcitedby").trim();
						xmlDatas.put(eid, xml);
						citXmlDatas.put(eid, xmlcitedby);
						/*
						eidSet.add(eid);
						if(eidSet.size()==200){
							eidList.add(eidSet);
							eidSet = new LinkedHashSet<String>();
						}
						*/
					}
					
					try{
						//logger.debug("검색 결과를 export합니다.");
						//session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... 0/"+ downloadNumber));
						//ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... 0/"+ downloadNumber);
						logger.debug(sessionID + " export... 0/"+ downloadNumber);
						//for(LinkedHashSet<String> set : eidList){
						cnt += xmlDatas.size();
						
						//logger.debug(" export... " + xmlDatas.size());
						exportDocument.exportData(xmlDatas, citXmlDatas);
						//session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... "+(cnt)+"/"+ downloadNumber));
						//ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... "+(cnt)+"/"+ downloadNumber);
						//logger.debug(sessionID + " export... "+(cnt)+"/"+ downloadNumber);
						//}
						//logger.debug("export Complete!!");
					}catch(Exception e){
						e.printStackTrace();
						//out.println(e.getMessage());
						logger.debug(e.getMessage());
						session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean(e.getMessage()));
					}
					
					//eidList.add(eidSet);
					startNumber += divisionCnt;
					
				}else{
					logger.debug("search err");
					searchSuccess = false;
					break;
				}
				
				if(endNumber < startNumber + divisionCnt){
					divisionCnt = endNumber - startNumber + 1;
				}
				
				if(startNumber > endNumber) {
					logger.debug("startNumber > endNumber " + (startNumber) +"\t" + endNumber );
					break;
				}
				if(divisionCnt==0) {
					logger.debug("divisionCnt==0 " + (startNumber) +"\t" + endNumber );
					break;
				}
				
			//session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export documents Complete."));
			//ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "export documents Complete.");
		}
		session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>"));
		ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>");
		logger.debug("export Complete!!");
	}catch(Exception e){
		e.printStackTrace();
		//out.println(e.getMessage());
		//logger.debug(e.getMessage());
		session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean(e.getMessage()));
	}finally{
		exportDocument.close();
		cf.close(conn);
	}
		/*
		logger.debug("새로운 데이터를 다운로드 받는다.");
		session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("Export for ready."));
		ExportInfoDao.mergeInto(sessionID + "_EXPORT_INFO", "Export for ready.");
		HashSet<String> selectedCheck = new HashSet<String>();
		logger.debug(checkList);
		for(String check : checkList.split(";")){
			selectedCheck.add(check);
		}
		ExportDocumentSax exportDocument = null;
		String downloadFileName = "";
		if(!searchSuccess) throw new Exception("검색엔진을 통해 데이터를 제대로 가져오지 못했습니다.");
		
		String fileName = UtilDate.getTimestampFormat(new Timestamp(System.currentTimeMillis()), "yyyyMMdd_hhmmss");
		if("cluster".equals(exportFormat)){
			downloadFileName = fileName +".cluster.txt";
			exportDocument = new ExportCluster(tmpSavePath + downloadFileName);
		}else if("text".equals(exportFormat)){
			downloadFileName = fileName +".mini.txt";
			logger.debug("selectedCheck ");
			exportDocument = new ExportText(tmpSavePath+downloadFileName, selectedCheck);
		}else{
			
			downloadFileName = fileName +".xlsx";
			exportDocument = new ExportExcelJXL(modelPath + "ExportBasicFormat.xlsx", tmpSavePath + downloadFileName, selectedCheck);
		}
		logger.debug("downloadFileName " + downloadFileName);
		*/
		//세션당 중복요청을 방지하기 위함.
		//session.setAttribute("EXPORT_SESSION_ID", sessionID);
		//logger.debug("exportFormat " + exportFormat);
		//logger.debug("sessionID " + sessionID);
		/*
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		try{
			conn = cf.getConnection();
			int cnt = 0;
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... 0/"+ downloadNumber));
			ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... 0/"+ downloadNumber);
			logger.debug(sessionID + " export... 0/"+ downloadNumber);
			for(LinkedHashSet<String> set : eidList){
				cnt += set.size();
				exportDocument.exportData(xmlDatas, citXmlDatas);
				session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export... "+(cnt)+"/"+ downloadNumber));
				ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export... "+(cnt)+"/"+ downloadNumber);
				logger.debug(sessionID + " export... "+(cnt)+"/"+ downloadNumber);
			}
			//logger.debug("export Complete!!");
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean("export Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>"));
			ExportInfoDao.mergeInto(conn, sessionID + "_EXPORT_INFO", "export Complete!!! <b><a href=\"javascript:download('"+downloadFileName+"','"+tmpSavePath+"')\" ><img src=\"../images/001_53.png\" border=\"0\" width=\"18\" height=\"18\"/></a></b>");
		}catch(Exception e){
			e.printStackTrace();
			out.println(e.getMessage());
			logger.debug(e.getMessage());
			session.setAttribute(sessionID + "_EXPORT_INFO", new ExportInfoBean(e.getMessage()));
		}finally{
			exportDocument.close();
			//session.removeAttribute("EXPORT_SESSION_ID");
			//ExportInfoDao.remove(sessionID + "_EXPORT_INFO");
			cf.close(conn);
		}
		*/
	//	}
	}else{
		//이미 해당 세션으로 export가 진행중이다.
		out.println("이미 export가 진행중.");
		logger.debug("이미 export가 진행중.");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
