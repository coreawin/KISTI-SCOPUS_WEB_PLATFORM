<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.util.UserUsePlatformDefinition"%>
<%@page import="kr.co.tqk.web.db.dao.UserUsePlatformDao"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./common/common.jsp" %>
<form name="loginForm" method="POST" action="./login.jsp">
	<input type="hidden" name="pwdPopup" value="true"/>
	<input type="hidden" name="id"/>
</form>

<script>    
<%
	String id = baseRequest.getParameter("id","");
	String pwd = baseRequest.getParameter("pwd","");
	
	UserBean bean = null;
	try{
		bean = UserDao.login(id, pwd);
		if(bean==null){
			throw new Exception("사용자 아이디가 존재하지 않거나 패스워드가 일치하지 않습니다.");
		}else{
			String auth = bean.getAuth();
			System.out.println("auth " + auth);
			if(UserAuthEnum.AUTH_WAITING.getAuth().equalsIgnoreCase(auth)){
				throw new Exception("해당 아이디는 관리자 승인되지 않은 아이디입니다. 관리자의 승인을 얻은 후 이용해 주세요.");
			}
			UserUsePlatformDao.insert(bean.getId(), UserUsePlatformDefinition.ACTION_LOGIN);
			session.setAttribute(USER_SESSION, bean);
		}
		out.println("location.href=\""+request.getContextPath()+"/documentSearch/searchDocument.jsp\";");
	}catch(Exception e){
		//e.printStackTrace();
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
		//out.println("location.href=\""+request.getContextPath()+"/login.jsp\";");
	}
%>
</script>

