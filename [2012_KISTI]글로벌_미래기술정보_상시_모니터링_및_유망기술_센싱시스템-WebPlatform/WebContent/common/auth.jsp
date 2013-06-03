<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./common.jsp" %>      
<%
	UserBean userBean = (UserBean)session.getAttribute(USER_SESSION);
	if(userBean==null){
		if(request.getRequestURL().indexOf("http://localhost")!=-1){
			//로컬작업시 권한 체크 하지 않는다.
			userBean = new UserBean();
			userBean.setId("local test");
			userBean.setPwd("1111");
			userBean.setNames("local test");
			userBean.setAuth(UserAuthEnum.AUTH_SUPER.toString());
		}else{
			out.println("<script>");
			out.println("	alert(\"로그인을 해주세요.\");");
			out.println("	location.href=\"../login.jsp\"; ");
			out.println("</script>");
			return;
		}
	}
	//if(currentDir.indexOf("catresult.jsp")==-1){
	//	session.removeAttribute(userBean.getId() + "_selectDocSet");
	//}
%>