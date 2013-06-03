<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<%@include file="./commonNoregist.jsp" %>
<%
	String msg = baseRequest.getParameter("msg", "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SCOPUS 정보 검색 플랫폼 - 페이지 전환중입니다.</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<link type="text/css" href="<%=contextPath%>/module/menu/style3/menu.css" rel="stylesheet" />

</head>

<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <div id="top_area">       
        <div id="header" style="z-index: 1000000">
        <h1><a href="#"><img src="<%=serviceURL%>/images/nn_toplogo.gif" alt="Nano - logo" align="top" /></a></h1>
            <ul id="tnb">
            	<li> </li>
				<li> </li>
                <li></li>
            </ul>
        </div></br>
        <div id="menu">
			<ul>
			</ul>
		</div>
        <div id="copyright"><!-- 이게 있어야 상단에 no back link가 생기지 않는다.  --><a href="http://apycom.com/"></a></div>
	</div>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
		<div id="content">
	    	<div id="search">
			<table border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%">
                    </td>
                    <td width="45%"></td>
                </tr>
            </table> 
			</div>
            
			<table border="0" cellpadding="0" cellspacing="0" align="center" width="100%">
       	  		<tr>
                    <td align="center" style="font-family: '맑은 고딕';"><br></br><h2 style="font-family: '맑은 고딕';">조회한 데이터 정보를 수집하고 있습니다. 잠시만 기다려 주세요</h2>
                    <br><img src="<%=serviceURL%>/images/loading_bar2.gif"/></br></td>
             	</tr>
            </table> 
		    <div class="sign" align="center" style="margin:10px 0px 20px 0px">
		    	<ul>
		            <li>
		            </li>
		         </ul>           
		    </div>
 	 	</div>
    </div>
    <!--contents_area-->
    
   <!--footer_area-->
    <!-- jsp:include page="./bottomArea.jsp"/-->
    <!--footer_area-->      
</div>
</body>
</html>
