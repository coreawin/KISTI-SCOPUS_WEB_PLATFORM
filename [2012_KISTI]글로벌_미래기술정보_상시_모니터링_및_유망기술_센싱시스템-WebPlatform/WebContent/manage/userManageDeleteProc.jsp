<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<script>
<%
	String id = baseRequest.getParameter("removeIDs", "");
	String[] ids = id.split(";");
	try{
		UserDao.deleteUser(ids);
		out.println("alert(\"유저 정보가 삭제되었습니다.\")");
		out.println("location.href=\""+request.getContextPath()+"/manage/userManageMain.jsp\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>