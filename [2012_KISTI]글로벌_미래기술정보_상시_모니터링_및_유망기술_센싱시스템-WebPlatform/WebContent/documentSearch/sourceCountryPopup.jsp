<%kr.co.tqk.web.util.RequestUtil baseRequest = new kr.co.tqk.web.util.RequestUtil(request);%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.SourceCountryDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%
	
	String search  = baseRequest.getParameter("find_name", null);
	String firstVal = baseRequest.getParameter("firstVal", null);
	String forwardCountry =  baseRequest.getParameter("forwardCountry",null);
	
	String[] con_code={};
	
	if(forwardCountry != null){
		con_code=forwardCountry.split(",");
	}
	LinkedList<SourceCountryDao> list = new LinkedList<SourceCountryDao>();
	if(firstVal==null){
		if(search==null){   
			//검색하지 않았을 경우. 
			list =SearchHandler.selectCountry();
		}else{
			//검색하였을 경우.	
			list =SearchHandler.selectCountrySearch(search);
		}
	}else{
		list =SearchHandler.selectCountry();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>SCOPUS 정보 검색 플랫폼 - Search Country Code</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>
<link href="<%=request.getContextPath() %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath() %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<script>

function searchCountry(){
	form=document.getElementById("frm");
	form.action="sourceCountryPopup.jsp"
	form.submit();
}

function searchCountryFirst(){
	form=document.getElementById("frm");
	form.firstVal.value="first";
	form.action="sourceCountryPopup.jsp"
	form.submit();
}

function forwardParent(){
	form = document.getElementById("frm");
	opener.country_add(form.country_code.value);
}

$(document).ready(function() {
	$(".tipTipClass").tipTip({maxWidth: "auto", edgeOffset: 10, maxWidth: "200px"});
});

</script>

<link href="<%=request.getContextPath() %>/css/nano_style.css" rel="stylesheet" type="text/css" />

</head>

<body style="background:#FFFFFF;">
<form name="frm" id="frm" method="post">
	<input type="hidden" id="firstVal"  name="firstVal" />
	

<div id="content_popup">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="640" cellpadding="0" cellspacing="0">
					<tr>
						<td background="../images/nn_search_popup_bg.gif" width="640" height="17"></td>
				 	</tr>
					<tr>
					 	<td>
                        	<div><h1 class="tit_txt_3"> Search Country Code <img src='../images/system_question_alt_02.png'
                             			class='tipTipClass' title="검색어를 입력하면 해당 검색어로 국가 코드가 검색되며, 검색어를 입력하지 않고 검색하면 전체 국가 코드가 목록에 나타납니다." 
                             			style="vertical-align: middle;" border='0'/></h1> </div>

                       	 	<div class="viewA">
                          	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="국가 선택 테이블">
                                            <tr>
                                                <td height="35" valign="middle" class="txt"> 
												<input type="text" id="find_name" name="find_name" class="input_txt"  maxlength="15" />
												<input type="button" class="bt5 tipTipClass" value="Search" onclick="javascript:searchCountry();" title="검색어를 입력하면 해당 검색어로 국가 코드가 검색되며, 검색어를 입력하지 않고 검색하면 전체 국가 코드가 목록에 나타납니다."/>
												</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
												<select id="country_code" name="country_code" size=10 style="width:500px" multiple onchange="javascript:forwardParent();">
													<%
														for(SourceCountryDao dao :  list) {
													%>
													   <option value="<%=dao.getCountry_code()+";"+dao.getCountry_name() %>">(<%=dao.getCountry_code() %>) &nbsp;&nbsp; <%=dao.getCountry_name() %></option>
													<%} %>
													</select>
                                                  </td>
                                            </tr>
											<tr><td><br>
														<input type="button" class="bt5" value="Close" onclick="javascript:self.close();" >
											</td></tr>
                                        </table></td>
                                </tr>
                            </table>
                     		</div>
				 	</tr>
				</table></td>
		</tr>
	</table>
</div>
</form>
</body>

</html>

