<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SCOPUS 정보 검색 플랫폼 - 사용자 정보 수정</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/<%=contextPath%>/js/common.jsp"></script>
<script src="<%=contextPath%>/module/jqgrid/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript">

	function goSeachDocument(){
		var form = document.getElementById("frm");
		form.action="../documentSearch/searchDocument.jsp";
		form.submit();
	}
	
	function modify(){
		if(check()){
			var form = document.getElementById("frm");
			form.action="./userInfoModifyProc.jsp";
			form.submit();
		}else{
			return;
		}
	}
	
	function check(){
		var form = document.getElementById("frm");
		
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
    <jsp:include page="../inc/topArea.jsp"/>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%" align="left" class="tit">
          				<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" ><img alt="" src="../images/001_40.png" align="bottom" width="16" height="16">
                    		회원 정보 수정
                    	</span>          
                    </td>
                    <td width="45%"></td>
                </tr>
            </table> 
			</div>
            
            <div id="LOGIN">
            <form id="frm" method="post">
            	<input type="hidden" name="id" value="<%=userBean.getId()%>"/>
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td>
                    	<div class="sign" style="margin:20px 0px 20px 0px">
                            <ul>
                                <li>ID<span style="text-align:left; padding:0px 0px 0px 95px;">
                                    <%=userBean.getId() %></span></li>
                                <li>NAME<span style="text-align:left; padding:0px 0px 0px 72px;">
                                    <input type="text" id="name" class="input_txt" name="name" maxlength="128" value="<%=userBean.getNames()%>"/></span></li>
                                <li>Password<span style="text-align:left; padding:0px 0px 0px 52px;">
                                    <input type="password" id="pwd" class="input_txt" name="pwd" maxlength="16" value="<%=userBean.getPwd()%>"/></span></li>
                                <li>Password 확인<span style="text-align:left; padding:0px 0px 0px 24px;">
                                    <input type="password" id="pwdV" class="input_txt" name="pwdV" maxlength="16" /></span></li>
                                <li>E-Mail<span style="text-align:left; padding:0px 0px 0px 70px;">
                                    <input type="text" id="email" class="input_txt" name="email" maxlength="128" value="<%=userBean.getEmail()%>"/></span></li>
                                <li>Department<span style="text-align:left; padding:0px 0px 0px 40px;">
                                    <input type="text" id="department" class="input_txt" name="department" maxlength="128" value="<%=userBean.getDepartment()%>"/></span></li>
                            </ul>          
                        </div></td>
             	</tr>
            </table> 
            </form>
	 	 	</div>
            
            <div class="sign" align="center" style="margin:10px 0px 20px 0px">
            	<ul>
                    <li>
                    	<button type="submit" id="" name="" class="bt4" onclick="javascript:modify();">회원정보 수정</button> 
                    	<button type="submit" id="" name="" class="bt4" onclick="javascript:goSeachDocument();">취소 (논문 검색 화면으로..)</button>
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
