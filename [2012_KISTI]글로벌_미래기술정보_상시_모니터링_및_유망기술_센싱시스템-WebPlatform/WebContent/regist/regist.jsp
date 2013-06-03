<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SCOPUS 정보 검색 플랫폼 - 플랫폼 회원 가입</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<link type="text/css" href="<%=contextPath%>/module/menu/style3/menu.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/module/menu/style3/menu.js"></script>

<script type="text/javascript">

	function navigateLogin(){
		location.href="../login.jsp";
	}
	
	function regist(){
		if(check()){
			var form = document.getElementById("frm");
			form.action="./registProc.jsp";
			form.submit();
		}else{
			return;
		}
	}
	
	function check(){
		var form = document.getElementById("frm");
		if(form.id.value==""){
			alert("ID를 입력하세요");
			form.id.focus();
			return false;			
		}
		if(form.name.value==""){
			alert("이름을 입력하세요");
			form.name.focus();
			return false;			
		}
		if(form.pwd.value==""){
			alert("비밀번호를 입력하세요");
			form.pwd.focus();
			return false;		
		}
		
		if(form.pwdV.value==""){
			alert("비밀번호를 다시한번 입력해주세요.");
			form.pwdV.focus();
			return false;		
		}
		
		if(form.pwdV.value!=form.pwd.value){
			alert("입력된 비밀번호가 서로 다릅니다.\n비밀번호를 확인해 주세요.");
			form.pwdV.value = "";
			form.pwdV.focus();
			return false;		
		}
		
		if(form.email.value==""){
			alert("이메일을 입력해주세요.");
			form.email.focus();
			return false;		
		}
		
		if(!isValidEmailAddress(form.email.value)){
			alert("유효한 이메일이 아닙니다.");
			form.email.focus();
			return false;		
		}
		
		if(form.department.value==""){
			alert("부서정보를 입력해주세요.");
			form.department.focus();
			return false;		
		}
		
		return true;
	}
	
	function isValidEmailAddress(emailAddress) {
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
		return pattern.test(emailAddress);
	}
	


</script>

</head>

<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <div id="top_area">       
    	 	
        <div id="header" style="z-index: 1000000">
        <h1><a href="#"><img src="<%=contextPath%>/images/nn_toplogo.gif" alt="Nano - logo" align="top" /></a></h1>
            <ul id="tnb">
            	<li> </li>
				<li> </li>
                <li><a href="<%=contextPath%>/login.jsp">LOG-IN</a></li>
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
                    	<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" ><img alt="" src="../images/001_40.png" align="bottom" width="16" height="16">
                    		회원 가입
                    	</span>
                    </td>
                    <td width="45%"></td>
                </tr>
            </table> 
			</div>
            
            <div id="LOGIN">
            <form id="frm" method="post">
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td>
                    	<div class="sign" style="margin:20px 0px 20px 0px">
                            <ul>
                                <li>ID<span style="text-align:left; padding:0px 0px 0px 95px;">
                                    <input type="text" id="id" class="input_txt" name="id" maxlength="16"/></span></li>
                                <li>NAME<span style="text-align:left; padding:0px 0px 0px 72px;">
                                    <input type="text" id="name" class="input_txt" name="name" maxlength="128" /></span></li>
                                <li>Password<span style="text-align:left; padding:0px 0px 0px 52px;">
                                    <input type="password" id="pwd" class="input_txt" name="pwd" maxlength="16" /></span></li>
                                <li>Password 확인<span style="text-align:left; padding:0px 0px 0px 24px;">
                                    <input type="password" id="pwdV" class="input_txt" name="pwdV" maxlength="16" /></span></li>
                                <li>E-Mail<span style="text-align:left; padding:0px 0px 0px 70px;">
                                    <input type="text" id="email" class="input_txt" name="email" maxlength="128" /></span></li>
                                <li>Department<span style="text-align:left; padding:0px 0px 0px 40px;">
                                    <input type="text" id="department" class="input_txt" name="department" maxlength="128" /></span></li>
                                <li> ※ 2012-09-01부터 신규 가입자는 관리자의 승인이 있어야 본 서비스를 이용할 수 있습니다.   
                                </li>
                            </ul>          
                        </div></td>
             	</tr>
            </table> 
            </form>
	 	 	</div>
		    <div class="sign" align="center" style="margin:10px 0px 20px 0px">
		    	<ul>
		            <li>
		            	<br>
		            	<button type="submit" id="" name="" class="bt4" onclick="javascript:regist();">Register</button> 
		            	<button type="submit" id="" name="" class="bt4" onclick="javascript:navigateLogin();">Login Page</button>
		            </li>
		        </ul>           
		    </div>
 	 	</div>
    </div>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->     
</div>
</body>
</html>
