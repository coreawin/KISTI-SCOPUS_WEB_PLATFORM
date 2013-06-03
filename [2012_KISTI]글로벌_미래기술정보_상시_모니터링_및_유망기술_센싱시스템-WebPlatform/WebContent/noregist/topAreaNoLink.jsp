<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>	
<%
	boolean showMenu = baseRequest.getBoolean("showMenu", false);
%>
<script src="<%=contextPath%>/js/mouseForbid.js" type="text/javascript"></script>
<link type="text/css" href="<%=contextPath%>/module/menu/style3/menu.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/module/menu/style3/menu.js"></script>
<div id="top_area" style="font-family:맑은 고딕;">       
	<div id="header" style="z-index: 1000000">
		<h1><a href="<%=contextPath%>/"><img src="<%=contextPath%>/images/nn_toplogo.gif" alt="Nano - logo" align="top" /></a></h1>
		<ul id="tnb">
			<li></li>
			<li></li>
			<li></li>
		</ul>
	</div>
	<%if(showMenu){ %>
		</br>
        <div id="menu">
			<ul>
			</ul>
		</div>
	<%} %>
    <div id="copyright"><!-- 이게 있어야 상단에 no back link가 생기지 않는다.  --><a href="http://apycom.com/"></a></div>
 </div>
