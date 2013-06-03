<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<script>
<%
	String selectID = baseRequest.getParameter("selectID", "");
	String selectAuth = baseRequest.getParameter("selectAuth", "");
	try{
		UserDao.modifyAuth(selectID, selectAuth);
		out.println("alert(\""+selectID+"의 권한이 변경되었습니다.\")");
		out.println("location.href=\""+request.getContextPath()+"/manage/userManageMain.jsp\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>