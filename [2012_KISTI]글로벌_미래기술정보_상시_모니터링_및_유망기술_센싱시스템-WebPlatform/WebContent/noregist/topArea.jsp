<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>	
<%@include file="../common/common.jsp" %>
<%@include file="./commonNoregist.jsp" %>
<%
	String hcp = "active";
	String rf = "";
	if(request.getRequestURL().indexOf("hcpMain.jsp")==-1){
		rf = hcp;
		hcp = "";
	}
%>

<link href="<%=contextPath%>/css/cssmenu/menu_assets/styles.css" rel="stylesheet" type="text/css">
<div id='cssmenu' style="font-family:맑은 고딕;">
<ul>
   <li class='<%=hcp%>'><a href='<%=serviceURL%>/noregist/hcpMain.jsp'><span>HCP</span></a></li>
   <li class='<%=rf%>'><a href='<%=serviceURL%>/noregist/analysisMain.jsp'><span>Research Front</span></a></li>
</ul>
</div>
<script src="<%=contextPath%>/js/mouseForbid.js" type="text/javascript"></script>
