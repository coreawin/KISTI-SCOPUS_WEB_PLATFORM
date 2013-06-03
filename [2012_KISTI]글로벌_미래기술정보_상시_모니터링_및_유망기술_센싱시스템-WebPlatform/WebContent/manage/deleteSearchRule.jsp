<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<script>
<%
	String id = baseRequest.getParameter("deleteSearchRuleSeqs", "");
	String goPage = baseRequest.getParameter("goPage", "/manage/userManageMain.jsp");
	String[] seq = id.split(" ");
	try{
		UserSearchRuleDao.delete(seq);
		out.println("alert(\"검색식 정보가 삭제되었습니다.\")");
		out.println("location.href=\""+request.getContextPath()+goPage + "\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>