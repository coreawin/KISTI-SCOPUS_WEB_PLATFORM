<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<script>
<%
	String id = baseRequest.getParameter("id","");
	String name = baseRequest.getParameter("name","");
	String pwd = baseRequest.getParameter("pwd","");
	String email = baseRequest.getParameter("email","");
	String department = baseRequest.getParameter("department","");
	
	try{
		UserDao.modifyUserInfo(id, pwd, name, email, department);
		UserBean bean = UserDao.select(id);
		session.setAttribute(USER_SESSION, bean);
		out.println("alert(\"회원정보가 수정되었습니다.\")");
		out.println("location.href=\""+request.getContextPath()+"/regist/userInfoModify.jsp\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}

%>
</script>