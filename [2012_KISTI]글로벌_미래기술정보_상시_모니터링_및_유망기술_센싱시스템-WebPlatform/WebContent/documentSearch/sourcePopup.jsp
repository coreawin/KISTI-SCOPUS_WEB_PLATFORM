<%kr.co.tqk.web.util.RequestUtil baseRequest = new kr.co.tqk.web.util.RequestUtil(request);%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.SourceDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%
	
	String search  = baseRequest.getParameter("find_name", "");
    String firstWindow="";

	LinkedList<SourceDao> list = new LinkedList<SourceDao>();
		
	if(search==null){   
		//검색하지 않았을 경우. 
		firstWindow="no";
	}else{
		//검색하였을 경우.	
		firstWindow="yes";
		list =SearchHandler.selectSourceSearch(search);
	}	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>SCOPUS 정보 검색 플랫폼 - Search Source Title</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>

<script>

function searchCountry(){
	form=document.getElementById("frm");
	form.action="sourcePopup.jsp";
	form.submit();
}

function forwardParent(){
	form = document.getElementById("frm");
	opener.source_add(form.Source_id.value);
}


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
                        	<div><h1 class="tit_txt_3">Search Source Title</h1></div>

                       	 	<div class="viewA">
                          	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="저널 선택 테이블">
                                            <tr>
                                                <td height="35" valign="middle" class="txt"> 
													<input type="text" id="find_name" name="find_name" class="input_txt"  value="<%=search%>"/>
													<input type="button" class="bt5" value="Search"  onclick="javascript:searchCountry();"/>
													ex) *science : prefix search, science* : postfix search
												</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
													<%
													if("no".equals(firstWindow.trim())){
														
													}else if("yes".equals(firstWindow.trim())){ %>
														<select id="Source_id" name="Source_id" size='13' style="width: 100%; overflow: auto; " multiple onchange="javascript:forwardParent();" > 
													<%
													for(SourceDao dao :  list) {
													%>
														 <option style="height:50px;" value="<%=dao.getSource_id()+";"+dao.getSource_title() %>" title="<%=dao.getSource_title()%>">(<%=dao.getSource_id() %>) &nbsp;&nbsp; <%=dao.getSource_title() %></option>
													<%}
													}%>
														</select>
                                                  </td>
                                            </tr>
											<tr><td><br>
														<input type="button"  class="bt5" value="Close" onclick="javascript:self.close();" >
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

