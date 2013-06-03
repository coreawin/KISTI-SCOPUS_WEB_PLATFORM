<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="kr.co.tqk.web.db.dao.export.ExportInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" session="true"  pageEncoding="UTF-8"%>
<%@page import="kr.co.tqk.web.db.bean.export.ExportInfoBean"%>
<%@page import="kr.co.tqk.web.util.UtilDate"%>
<%@page import="java.util.Date"%>
<%
try{
	String sessionID = request.getParameter("sessionID");
	//String sessionID = session.getId();
	Object obj = session.getAttribute(sessionID + "_EXPORT_INFO");
	Object time = session.getAttribute(sessionID + "_EXPORT_TIME");
	if(time==null){
		time = System.currentTimeMillis();
		session.setAttribute(sessionID + "_EXPORT_TIME", time);
	}
	long startTime = ((Long)time).longValue();
	long currentTime = System.currentTimeMillis();

	Date d = new Date(currentTime - startTime);
	Calendar c = Calendar.getInstance();
	c.setTime(d);
	int hour = 0;
	int min = c.get(Calendar.MINUTE);
	int sec = c.get(Calendar.SECOND);
	
	String elapsedTime = "경과시간 " + ((hour!=0)? hour +"시":"") + ((min!=0)? min +"분":"") + ((sec!=0)? sec +"초":"");
	
	String info = "Export processing...";
//	if(obj instanceof ExportInfoBean){
//		ExportInfoBean eiBean = (ExportInfoBean)obj;
//		info = eiBean.getContents();
//	}else{
//		if(obj!=null){
//			info = (String)obj;
//		}else{
			ExportInfoBean eiBean = ExportInfoDao.select(sessionID+"_EXPORT_INFO");
			
			if(eiBean != null){
				info = eiBean.getContents();
			}
//}
//}
//	System.out.println("[" + UtilDate.getDateFormate(new Date())  + "]\t" + info);
	out.println("[" + elapsedTime  + "]\t" + info);
	//out.println("[" + UtilDate.getDateFormate(new Date())  + "]\t" + info);
}catch(Exception e){
	e.printStackTrace();
}
%>
