<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.tqk.web.util.RequestUtil"%><%@include file="../common/auth.jsp" %><%@ page language="java" contentType="text/html; charset=UTF-" pageEncoding="UTF-8"%>
<script>
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
	int seq = baseRequest.getInteger("seq", -1);
	try{
		IResearchFrontDao dao = new ResearchFrontDAO();
		dao.deleteAnalysis(seq);
	}catch(Exception e){
		e.printStackTrace();
	}
%>
</script>
