<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.tqk.web.mail.MailSender"%>
<%@page import="java.text.DateFormat"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="org.apache.commons.mail.HtmlEmail"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./common/common.jsp" %>
<%@include file="./common/settingMail.jsp" %>    
<%
try{
String id = baseRequest.getParameter("id","guest");
String name = baseRequest.getParameter("name","게스트");
String pwd = baseRequest.getParameter("pwd","게스트");
String email = baseRequest.getParameter("email","");
String department = baseRequest.getParameter("department","게스트 부서.");

//String[] receiveMails = new String[]{"coreawin@gmail.com", "coreawin@topquadrant.co.kr"};
//String[] receiveNames = new String[]{"gmail.com", "topquadrant.co.kr"};

List<UserBean> sbs = UserDao.selectAuth(UserAuthEnum.AUTH_SUPER.getAuth());
String[] receiveMails = new String[sbs.size()];
String[] receiveNames = new String[sbs.size()];
for(int i=0; i<sbs.size();i++){
	receiveMails[i] = sbs.get(i).getEmail().trim();
	receiveNames[i] = sbs.get(i).getNames().trim();
	out.println(receiveNames[i] +"__ " + receiveMails[i] +"<BR>");
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

out.println("메일이 성공적으로 보내졌습니다.");
}catch(Exception e){
	e.printStackTrace();
	out.println(e.getMessage());
}
%>
<%!
/**
 * 보내는 메일 내용을 HTML형식으로 채운다.
 * 
 * @param id
 *            가입자 ID
 * @param name
 *            가입자명
 * @param email
 *            가입자 이메일
 * @param department
 *            가입자 기타 정보
 * @param date
 *            가입일.
 * @return
 */
public String getHTMLContents(String id, String name, String email, String department, String date) {
	StringBuffer sb = new StringBuffer();
	sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
	sb.append("<html><head>");
	sb.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
	sb.append("<title>SCOPUS 정보검색 플랫폼</title>");
	sb.append("</head><body>");
	sb.append("다음 사용자가 <a href=\"http://scopus.kisti.re.kr\">http://scopus.kisti.re.kr</a> 사이트에 가입하셨습니다. <br>");
	sb.append("이 메일을 받으신 분은 scopus 정보검색 플랫폼의 관리자입니다.<br>");
	sb.append("Administrator 메뉴를 통해 해당 사용자의 사이트 사용유무를 결정해 주세요.<br>");
	sb.append("<hr>");
	sb.append("<b>ID</b> : " + id + " <br>");
	sb.append("<b>Name</b> : " + name + " <br>");
	sb.append("<b>E-Mail</b> : " + email + " <br>");
	sb.append("<b>Department</b> : " + department + " <br>");
	sb.append("<hr>");
	sb.append("<b>요청일</b> : " + date + " <br>");
	sb.append("</body><hr></html>");

	return sb.toString();
}
%>