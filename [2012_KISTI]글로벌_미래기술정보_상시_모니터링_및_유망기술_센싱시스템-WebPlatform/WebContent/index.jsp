<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="./common/common.jsp" %>	
<%
	String id = baseRequest.getParameter("id", "");
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SCOPUS 정보 검색 플랫폼 - 시스템 로그인</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

	function setCookie (name, value, expires) {
	  document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
	}
	
	function getCookie(Name) {
	  var search = Name + "="
	  if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
	    offset = document.cookie.indexOf(search)
	    if (offset != -1) { // 쿠키가 존재하면
	      offset += search.length
	      // set index of beginning of value
	      end = document.cookie.indexOf(";", offset)
	      // 쿠키 값의 마지막 위치 인덱스 번호 설정
	      if (end == -1)
	        end = document.cookie.length
	      return unescape(document.cookie.substring(offset, end))
	    }
	  }
	  return "";
	}
	
	function saveid(form) {
	  var expdate = new Date();
	  // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
	  if (document.getElementById("checksaveid").checked)
	    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
	  else
	    expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
	  setCookie("saveid", document.getElementById("id").value, expdate);
	}
	
	function getid(form) {
	  	document.getElementById("checksaveid").checked = ((document.getElementById("id").value = getCookie("saveid")) != "");	  
	}

	function login(){
		var form=document.getElementById("frm");
		if(form.id.value==""){
			alert("ID를 입력하세요");
			form.id.focus();
			return;			
		}
		if(form.pwd.value==""){
			alert("비밀번호를 입력하세요");
			form.pwd.focus();
			return;		
		}
		else{
			if(document.getElementById("checksaveid").checked){
				saveid(form);
			}
			form.action="./loginProc.jsp";
			form.submit();
		}
	}

	function enterCheck() {
		getEvent=event.keyCode;
		if (getEvent == "13") {			
			login();
		}
	}
	
	function setup(){
		if("<%=id%>"==""){
			document.getElementById("id").focus();
		}else{
			document.getElementById("pwd").focus();
		}
		getid(document.getElementById("frm"));
	}
	
	function navigateRegist(){
		location.href="./regist/regist.jsp";
	}

</script>
</head>

<body onload="javascript:setup();">
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <div id="top_area">       
    	 
   <div id="header2">
        <h1><a href="#"><img src="./images/nn_toplogo1.gif" alt="Nano - Scopus" align="top" /></a></h1>
            <!--<ul id="tnb">
                <li><a href="#">LOG-IN</a></li>
            </ul>-->
        </div>    
    </div>
    <!--top_area-->

	<!--contents_area-->
    <div id="container" style="background:url(./images/nn_c_bg.png) repeat-x; height:580px;">
    
		<div id="content2">
        
	    	<div id="login1">
			<form id="frm" method="post">
	    	<table border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                 	<td rowspan="2" valign="top"><img src="./images/nn_login_img01.png" /></td> 
                 	<td width="273" valign="top"><img src="./images/nn_login_img02.png" />
						<div class="sign" style="margin:0px 0px 10px 0px">
                            <ul>
                                <li>ID　　&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="text-align:left;">
                                    <input type="text" id="id" value="<%=id%>" class="input_txt6" name="id" maxlength="16" onkeypress="javascript:enterCheck();" value="neon"/></span></li>
                                <li>Password&nbsp;<span style="text-align:left;">
                                    <input type="password" id="pwd" class="input_txt6" name="pwd" maxlength="16" onkeypress="javascript:enterCheck();"/></span></li>
                            </ul>
                            <ul>
                                <li>　　　　　　<button type="button" id="" name="" class="bt4" onclick="javascript:login();">Log In</button> <button type="button" id="" name="" class="bt4" onclick="javascript:navigateRegist();">Self-Register</button></li>
                            </ul>
                            <ul>
                                <li>　　　　　　<input name="checksaveid" id="checksaveid" type="checkbox" value="1" onclick="javascript:saveid('this.form')"/> ID 저장</li>
                            </ul>          
                        </div>
						
                    	</td>
                    <td width="120" rowspan="2"></td>
             	</tr>
       	  		<tr>
       	  		 	<td valign="top"></td>
                </tr>
                <tr>
                    <td rowspan="2"></td>
             	</tr>
            </table> 
			</form>
 	 	 	</div>
 	 	</div>
    </div>
    <!--contents_area-->
	
	<!--footer_area-->
    <div id="footer">
        <h3 class="footer_logo"><img src="./images/nn_footerlogo.gif" alt="Nano - logo" /></h3><br />
        <address>　　　　　66 hoegiro, Dongdaemun-gu, Seoul, 130-741, Korea　TEL.02.3299.6251　FAX.02.3299.6028<br />
			　　　　　copyright (c) 2011 by KISTI., All rights reserved.</address>
 	</div> 
    <!--footer_area-->   
	
</div>
</body>
</html>