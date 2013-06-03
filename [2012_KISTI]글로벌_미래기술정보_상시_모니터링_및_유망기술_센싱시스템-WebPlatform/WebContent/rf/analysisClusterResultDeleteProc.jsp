<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%><%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysisOption"%><%@page import="net.sf.json.JSONObject"%><%@page import="java.util.HashMap"%><%@page import="java.util.Map"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@include file="../common/auth.jsp" %>
<%
	boolean unauthorized = false;
	
	if(userBean==null) {unauthorized = true;};
	if(!userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth())){
		unauthorized = true;
	}
	if(unauthorized){
		out.println("<script>");
		out.println("alert('해당 페이지로의 접근 권한이 없습니다.');");
		out.println("location.href=\"./analysisMain.jsp\";");
		out.println("</script>");
	}
	String deleteParameter = baseRequest.getParameter("param", "");
	//System.out.println("delete proc " + deleteParameter);
	try{
		IResearchFrontDao dao = new ResearchFrontDAO();
		String[] datas = deleteParameter.split(";");
		if(datas==null) return;
		for(String data : datas){
			String[] seqs = data.split("_");
			if(seqs == null) continue;
			if(seqs.length != 3) continue;
			dao.deleteAnalysis(Integer.parseInt(seqs[0]), Integer.parseInt(seqs[1]) , Integer.parseInt(seqs[2]));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>