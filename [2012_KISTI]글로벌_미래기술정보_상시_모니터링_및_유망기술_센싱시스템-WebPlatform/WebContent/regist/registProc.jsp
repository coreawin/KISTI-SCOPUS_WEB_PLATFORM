<%@page import="java.util.List"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.tqk.web.mail.MailSender"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<%@include file="../common/settingMail.jsp" %>
<script>
<%
	String id = baseRequest.getParameter("id","");
	String name = baseRequest.getParameter("name","");
	String pwd = baseRequest.getParameter("pwd","");
	String email = baseRequest.getParameter("email","");
	String department = baseRequest.getParameter("department","");
	
	try{
		UserBean bean = UserDao.select(id);
		if(bean!=null){
			throw new Exception(id + "는 이미 존재하는 아이디입니다.");
		}
		UserDao.regist(id, pwd, name, email, department);
		try{
			List<UserBean> sbs = UserDao.selectAuth(UserAuthEnum.AUTH_SUPER.getAuth());
			String[] receiveMails = new String[sbs.size()];
			String[] receiveNames = new String[sbs.size()];
			for(int i=0; i<sbs.size();i++){
				receiveMails[i] = sbs.get(i).getEmail();
				receiveNames[i] = sbs.get(i).getNames();
			}
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			new MailSender(smtpHost, 
				receiveMails, 
				receiveNames,
				smtpEmail,
				smtpName,
				name +" " + smtpTitle,
				id,
				name,
				email,
				department,
				df.format(new Date())
			);
		}catch(Exception e){
			e.printStackTrace();
		}
		out.println("alert(\"성공적으로 등록되었습니다. \\\n로그인 페이지로 이동합니다.\")");
		out.println("location.href=\""+request.getContextPath()+"/login.jsp?id="+id+"\";");
		
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}

%>
</script>