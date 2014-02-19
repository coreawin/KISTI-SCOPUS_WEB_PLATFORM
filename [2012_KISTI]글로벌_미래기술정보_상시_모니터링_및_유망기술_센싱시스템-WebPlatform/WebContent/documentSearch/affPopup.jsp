<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.json.JSONArray"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="org.apache.http.message.BasicNameValuePair"%>
<%@page import="org.apache.http.NameValuePair"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.SourceDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%@include file="../common/auth.jsp" %>
<%
	String searchTerm = baseRequest.getParameter("searchTerm", "");
	searchTerm = searchTerm.replaceAll(",","\\\\,").replaceAll("&","\\\\&").replaceAll("=","\\\\=").replaceAll(":","\\\\:");
	
	//1. 기관검색
	JSONObject jsonobj = null;
	ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
	nvps.add(new BasicNameValuePair("cn", "affiliation"));
	nvps.add(new BasicNameValuePair("se", "{org_name:AND("+searchTerm+"):1:32}"));
	nvps.add(new BasicNameValuePair("fl", "afid,org_name,country,doc_count"));
	nvps.add(new BasicNameValuePair("sn", String.valueOf(1)));
	nvps.add(new BasicNameValuePair("ln", String.valueOf(500)));
	nvps.add(new BasicNameValuePair("ft", ""));
	nvps.add(new BasicNameValuePair("timeout", "60"));
	
	if(searchTerm.length() > 0){
		System.out.println("affPopup.jsp " + searchTerm +"\t" + searchTerm.length());
		jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);
	}

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
<title>SCOPUS 정보 검색 플랫폼 - Search Affiliation</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>

<script>

function searchCountry(){
	var form=document.getElementById("frm");
	var search_result =document.getElementById("search_result");
	search_result.innerHTML = "<center>searching...</center>";
	form.action="affPopup.jsp";
	form.submit();
}

function forwardParent(){
	var form = document.getElementById("frm");
	opener.affid_add(form.aff_id.value);
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
                        	<div><h1 class="tit_txt_3">Search Affiliation</h1></div>

                       	 	<div class="viewA">
                          	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="기관명 선택 테이블">
                                            <tr>
                                                <td height="35" valign="middle" class="txt"> 
													<input type="text" id="searchTerm" name="searchTerm" class="input_txt"  value="<%=searchTerm%>"/>
													<input type="button" class="bt5" value="Search"  onclick="javascript:searchCountry();"/>
													ex) *science : prefix search, science* : postfix search
												</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                	<div id="search_result">
													<%
													if("no".equals(firstWindow.trim())){
													}else if("yes".equals(firstWindow.trim())){ %>
														<select id="aff_id" name="aff_id" size='13' style="width: 100%; overflow: auto; " multiple onchange="javascript:forwardParent();" > 
													<%
													if(jsonobj != null && jsonobj.getInt("status") == 0){
												        int iTotalTotal = jsonobj.getInt("total_count");
												        JSONArray resultArr = jsonobj.getJSONArray("result");
												        if(resultArr != null && iTotalTotal > 0){
															int cnt = 0;
															for (int j=0;j<resultArr.length();j++) {
																JSONObject o = resultArr.getJSONObject(j);
																String afid = o.getString("afid");
																String org_name = o.getString("org_name");
																String country = o.getString("country");
																String doc_count = o.getString("doc_count");
													%>
														 <option style="height:50px;" value="<%=afid+";"+org_name %>" title="<%=org_name%>"><%=afid%>, (<%=org_name %>) &nbsp;&nbsp; <%=country %></option>
													<%
															}
												        }
													}
													}
													%>
														</select>
														</div>
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

