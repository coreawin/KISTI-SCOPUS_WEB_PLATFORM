<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<script>
<%
	String selectID = baseRequest.getParameter("selectID", "");
	try{
		UserDao.modifyPWD(selectID);
		out.println("alert(\""+selectID+"의 비밀번호가 초기화 되었습니다.\")");
		out.println("location.href=\""+request.getContextPath()+"/manage/userManageMain.jsp\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>