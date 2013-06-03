<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="org.apache.http.*"%>
<%@ page import="org.apache.http.client.*"%>
<%@ page import="org.apache.http.client.entity.*"%>
<%@ page import="org.apache.http.client.methods.*"%>
<%@ page import="org.apache.http.impl.client.*"%>
<%@ page import="org.apache.http.impl.client.*"%>
<%@ page import="org.apache.http.message.*"%>
<%@ page import="org.apache.http.protocol.HTTP"%>
<%@ page import="org.apache.http.params.*"%>
<%@include file="../common/auth.jsp" %>   
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", 0);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchTerm = baseRequest.getParameter("searchTerm", "");
	String searchRule = baseRequest.getParameter("searchRule", "");
	
	/* LinkedList<AuthorSearchResultBean> asrBeanList = SearchDocument.searchAuthor(searchRule, currentPage, viewData);
	if(!"".equals(searchTerm)){
		totalSize = SearchDocument.getTotalSearchResultCount();
	} */
	
	int iTotalTotal = 0;
	String cn = "author";
	String se = "{author_id:"+searchTerm+"}";
	String fl = "author_id,author_name,index_name,email,doc_count,_score_";
	String sn = ""+((currentPage-1)*20+1);//"1";//""+((currentPage-1)*20+1);//"1";
	String gr = "";//"asjc:freq:freq_desc,pubyear:freq:key_desc,country:freq:freq_desc,sourceid:freq:freq_desc,sourcetype:freq:key_asc,authorid:freq:freq_desc";
	String ft = baseRequest.getParameter("ft", "");
	if(searchRule.startsWith("authorid"))
                ft = searchRule;
	LinkedHashSet<String> eidSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(eidSet==null)eidSet = new LinkedHashSet<String>(); 
	
	 String ud = "keyword:"+searchTerm;
	 
	 JSONObject jsonobj = null;
	 ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
		nvps.add(new BasicNameValuePair("cn", cn));
		nvps.add(new BasicNameValuePair("se", se));
		nvps.add(new BasicNameValuePair("fl", fl));
		nvps.add(new BasicNameValuePair("sn", sn));
		nvps.add(new BasicNameValuePair("ln", String.valueOf(viewData)));
		nvps.add(new BasicNameValuePair("gr", gr));
		nvps.add(new BasicNameValuePair("ud", ud));
		nvps.add(new BasicNameValuePair("ft", ft));

		//Declare for fastcatSearchURL : /common/common.jsp
	
		jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nano</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function search(){
	var form = document.getElementById("parameter");
	var formTmp = document.getElementById("parameterForm");
	var searchText = formTmp.searchTerm.value;
	//var exactMatch = form.exactMatchCheck.checked;
	var exactMatch = false;
 	form.ft.value = "";	
	if(searchText == ""){
		alert("검색어를 입력해 주세요.");
		form.searchText.focus();
		return;
	}else{
		form.searchTerm.value = searchText;
		form.searchRule.value = "AU-"+exactMatch+"("+searchText+")";
		form.action="./catAuthor.jsp";
		form.submit();
	}
}

function searchWithAuthorid(authorid) {
        var form = document.getElementById("parameter");
        form.ft.value = "authorid:match:"+authorid;
        form.action="./catAuthor.jsp";
        form.submit();
}


function enterCheck() {
	getEvent=event.keyCode;
	if (getEvent == "13") {			
		search();
		return;
	}
}

function toggleImage(jQueryObj){
	var imgSrc = jQueryObj.attr("src");
	if(imgSrc=="../images/nn_search_arrow01.gif"){
		jQueryObj.attr("src", "../images/nn_search_arrow02.gif"); 
	}else{
		jQueryObj.attr("src", "../images/nn_search_arrow01.gif");
	}
}

jQuery(document).ready(function(){
	$('#asjcFolding').click(function() {
		jQuery("#asjcStaticsContents tbody").toggle(); 
		toggleImage($(this));
		return false;
	});
});

function limit()
{
	var searchRuleParamStr = ""; /* 검색식을 세팅하기 위해 결과내 검색에서 항목 선택시 해당항목을 임시적으로 저장하는 변수.*/
	var form = document.getElementById("parameter");
	var searchRule = form.searchRule.value;
	
	var flag = false;
	var filter = "";
	var e= document.countryForm.elements.length;
	  var cnt=0;

	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.countryForm.elements[cnt].checked){
	     	flag = true;
	    }
	  }
	  if(flag){
	  filter += "country:match:";
	  searchRuleParamStr = "";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.countryForm.elements[cnt].checked){
	     filter += document.countryForm.elements[cnt].value+";";
	     searchRuleParamStr += document.countryForm.elements[cnt].value+" ";
	    }
	  }
	  if(searchRuleParamStr!=""){
		  searchRule = includeReWriteSearchRule(searchRule, /COUNTRY\(.*?\)/, "COUNTRY", searchRuleParamStr);
	  }
	  
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  
	  
	  filter += ",";
	  }

	  flag = false;
	  e= document.yearForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.yearForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "pubyear:match:";
	   searchRuleParamStr = "";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.yearForm.elements[cnt].checked){
	     filter += document.yearForm.elements[cnt].value+";";
	     searchRuleParamStr += document.yearForm.elements[cnt].value+" ";
	    }
	  }
	  if(searchRuleParamStr!=""){
		  searchRule = includeReWriteSearchRule(searchRule, /PUBYEAR\(.*?\)/, "PUBYEAR", searchRuleParamStr);
	  }
	  
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	 flag = false; 
	  e= document.asjcForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.asjcForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "asjc:match:";
	   
	  searchRuleParamStr = ""; 
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.asjcForm.elements[cnt].checked){
	     filter += document.asjcForm.elements[cnt].value+";";
	     searchRuleParamStr +=document.asjcForm.elements[cnt].value+" ";
	    }
	  }
	  if(searchRuleParamStr!=""){
		  searchRule = includeReWriteSearchRule(searchRule, /ASJC\(.*?\)/, "ASJC", searchRuleParamStr);
	  }
	  
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  flag = false;
	  e= document.sourceTypeForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.sourceTypeForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "sourcetype:match:";
	   searchRuleParamStr = "";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.sourceTypeForm.elements[cnt].checked){
	     filter += document.sourceTypeForm.elements[cnt].value+";";
	     searchRuleParamStr += document.sourceTypeForm.elements[cnt].value+" ";
	    }
	  }
	  if(searchRuleParamStr!=""){
		  searchRule = includeReWriteSearchRule(searchRule, /SOURCETYPE\(.*?\)/, "SOURCETYPE", searchRuleParamStr);
	  }
	  
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  flag = false;
	  e= document.sourceIdForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.sourceIdForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "sourceid:match:";
	  
	   searchRuleParamStr = "";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.sourceIdForm.elements[cnt].checked){
	     filter += document.sourceIdForm.elements[cnt].value+";";
	     searchRuleParamStr += document.sourceIdForm.elements[cnt].value+" ";
	    }
	  }
	  if(searchRuleParamStr!=""){
		  searchRule = includeReWriteSearchRule(searchRule, /SOURCE\(.*?\)/, "SOURCE", searchRuleParamStr);
	  }
	  
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  filter = filter.substring(0,filter.length-1);
	  alert(filter +"\n"+searchRule);
	  //submit search form  asjccode:match:2200
	
	form.searchRule.value = jQuery.trim(searchRule);
	form.ft.value=filter;
	form.action="./catAuthor.jsp";
	form.submit();
}

function includeReWriteSearchRule(searchRule, reg, searchTypeName, replaceStr){
	return searchRule.replace(reg, searchTypeName + "("+jQuery.trim(replaceStr)+")");

function includeReWriteSearchRule(searchRule, reg, searchTypeName, replaceStr){
	return searchRule.replace(reg, searchTypeName + "("+jQuery.trim(replaceStr)+")");
}}

function exclude()
{
var flag = false;
	var filter = "";
	var e= document.countryForm.elements.length;
	  var cnt=0;

	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.countryForm.elements[cnt].checked){
	     	flag = true;
	    }
	  }
	  if(flag){
	  filter += "country:exclude:";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.countryForm.elements[cnt].checked){
	     filter += document.countryForm.elements[cnt].value+";";
	    }
	  }
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  
	  
	  filter += ",";
	  }

	  flag = false;  
	  e= document.yearForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.yearForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "pubyear:exclude:";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.yearForm.elements[cnt].checked){
	     filter += document.yearForm.elements[cnt].value+";";
	    }
	  }
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  flag = false;
	  e= document.asjcForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.asjcForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "asjc:exclude:";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.asjcForm.elements[cnt].checked){
	     filter += document.asjcForm.elements[cnt].value+";";
	    }
	  }
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  flag = false;
	  e= document.sourceTypeForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.sourceTypeForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "sourcetype:exclude:";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.sourceTypeForm.elements[cnt].checked){
	     filter += document.sourceTypeForm.elements[cnt].value+";";
	    }
	  }
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  flag = false;
	  e= document.sourceIdForm.elements.length;
	   cnt=0;
	   for(cnt=0;cnt<e;cnt++)
		  {
		    if(document.sourceIdForm.elements[cnt].checked){
		     	flag = true;
		    }
		  }
	   if(flag){
	   filter += "sourceid:exclude:";
	  for(cnt=0;cnt<e;cnt++)
	  {
	    if(document.sourceIdForm.elements[cnt].checked){
	     filter += document.sourceIdForm.elements[cnt].value+";";
	    }
	  }
	  if(filter.substring(filter.length-1) == ";"){
		  filter = filter.substring(0,filter.length-1); 
	  }
	  filter += ",";
	   }
	  
	  filter = filter.substring(0,filter.length-1);
	  alert(filter);
	  //submit search form  asjccode:match:2200
	var form = document.getElementById("parameter");
	form.ft.value=filter;
	form.action="./catAuthor.jsp";
	form.submit();
}
</script>
</head>

<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <jsp:include page="../inc/topArea.jsp">
    	<jsp:param value="<%=TOP_MENU_SEARCH %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_AUTHOR_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0" style="margin:15px 0px 0px 15px;">
            	<tr>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_L.gif" /></td>
                    <td width="53%" align="left" class="tit">저자 검색</td>
                 	<td width="47%" align="right" class="e-tit">&nbsp;</td>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_R.gif" /></td>
                </tr>
            </table> 
			</div>
<%
JSONArray resultArr = null;
JSONArray groupResultArr = null;
        String bgColor = "";
if(jsonobj.getInt("status") == 0)
	totalSize = jsonobj.getInt("total_count");


%>
            <div id="search_ment">
            <table class="Table1_1" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td> <!-- "<span class="txt3">나노</span>" 키워드로 검색한 결과입니다.  --><%=searchRule %></td>
                </tr>
            </table>
            </div>
            
            <div id="search_choice2">
			<table class="Table" border="0" cellpadding="0" cellspacing="0" style="margin-left:15px">
				<tr>
                    <td valign="top">
                    	<form id="parameterForm" method="get">
    						<input type="hidden" name="searchRule"/>
	                    	<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블">
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt">
	                                	<strong style="text-align:left;">Author Name : </strong><input type="text" id="searchTerm" name="searchTerm" size="95%" value="<%= searchTerm%>" onkeypress="javascript:enterCheck();" />
	                                	<input type="checkbox" id="exactMatchCheck" name="exactMatchCheck" title="Show exact matches only" style="text-align:right;" alt="Show exact matches only"/> Show exact matches only
	                                	 <input type="button" class="bt5" value="Search" title="Search" alt="Search" onclick="javsscript:search();"/>
									</td>
	                            </tr>
	                            <!-- 
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt" style="padding:5px 10px;text-align:right;">
										<input type="button" class="bt5" value="Search" title="Search" alt="Search" onclick="javsscript:search();"/>
									</td>
	                            </tr>
	                             -->
	                  		</table>
                  		</form>
                  	</td>
             	</tr>
       	  		<tr>
                    <td valign="top">
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="25" class="txt">"<%=searchTerm %>" search result : <%=totalSize %></td>
                           	</tr>
                        </table></td>
   	  		 	</tr>
            </table>
	 	 	</div>
            
            <div id="search_result">
			<table class="Table8" border="0" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<tr>
                    <td valign="top">
                    	<table class="Table9" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="83%" valign="top">
                                    <table class="Table10" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td>&nbsp;</td>
                                                        <td align="right">
                                                        	Sort by
                                                        	<select name="sortBy" id="sortBy">
                                                            	<option value="20">-　Author Name (A-Z)　-</option>
                                                            	<option value="20">-　Author Name (Z-A)　-</option>
                                                            	<option value="20">-　Affilation (A-Z)　-</option>
                                                            	<option value="20">-　Country (A-Z)　-</option>
                                                            	<option value="40">-　Document Count DESC　-</option>
                                                            	<option value="40">-　Document Count ASC　-</option>
                                                        	</select>
                                                        </td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5">
                                        <caption>검색 결과 테이블</caption>
                                        <colgroup>
                                            <col width="3%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <th style="padding:2px 2px 2px 2px;">Author ID</th>
			                                    <th width="25%" style="padding:2px 2px 2px 2px;">Author</th>
			                                    <th width="55%" style="padding:2px 2px 2px 2px;">Affiliation</th>
			                                    <th width="50" style="padding:2px 2px 2px 2px;">Country</th>
			                                    <th width="50" style="padding:2px 2px 2px 2px;">Doc_cnt</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
if(jsonobj.getInt("status") == 0){
        iTotalTotal = jsonobj.getInt("total_count");
//      totalSize = iTotalTotal;
        resultArr = jsonobj.getJSONArray("result");
        try{
        groupResultArr = jsonobj.getJSONArray("group_result");
        }catch(Exception e){

        }

if(iTotalTotal  > 0){
//if(groupResultArr != null){

//		JSONArray arr = groupResultArr.getJSONArray(5);
//		int groupIndex = Math.min(arr.length(),viewData*currentPage);
//		totalSize = arr.length();
//		for (int j=((currentPage-1)*viewData);j<groupIndex;j++) {
//			JSONObject o = arr.getJSONObject(j);
for (int i=0;i<resultArr.length();i++) {
			JSONObject jsonrecord = resultArr.getJSONObject(i);
%>
                       	 	 	<tr>
                                 	<td style="padding:5px 5px; text-align:left;"><a href="./viewAuthor.jsp?authorSeq="><%=jsonrecord.getString("authorid")%></a></td>
                                 	<td scope="row" style="padding:5px 5px; color:#005eac; text-align:left;"><a href="./viewAuthor.jsp?authorSeq="><%=jsonrecord.getString("authorname")%></a></td>
                                 	<td style="padding:5px 5px; text-align:left;"><%=jsonrecord.getString("affiliation")%></td>
                                    <td style="color:#2a87d5; text-align:center;"><%=jsonrecord.getString("country")%></td>
                                    <td style="color:#2a87d5; text-align:center;">1</td>
                       	 	 	</tr>
<%
	}
	}
}
%>
                                        </tbody>
                                    </table>
                                    </td>
                                <td width="17%" valign="top">
                                    <table class="Table13" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td height="55" class="tit"><strong>Search within results</strong><br /> 
														<input type="text" id="searchTerm" name="searchTerm" size="15" value="Search" class="input_txt1"> <input type="button" value="Search" id="" name="" class="bt1"  onclick=""></td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                        <tr>
                                        	<td height="1" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td height="55" class="tit"><strong>Refine results</strong><br />
														<input type="button" value="Limit to" id="" name="" class="bt1" onclick="limit();"> <input type="button" value="Exclude" id="" name="" class="bt1"  onclick="exclude();"></td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>



                                    <table class="Table13_1" border="0" cellpadding="0" cellspacing="0">
<%                                       
	if(groupResultArr != null){
			for (int i=0;i<groupResultArr.length();i++) {
				JSONArray arr = groupResultArr.getJSONArray(i);
			
				
			

%>

<% 
if(i == 1){
%>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_YEAR">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Year</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_YEAR" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="yearForm" name="yearForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					if(j>=10){
                        						continue;
                        					}                   				
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
  <% 
if(i == 7){
%>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_AUTHORNAME">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Author Name</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_AUTHORNAME" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="authorNameForm" name="authorNameForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value=<%=o.getString("key")%> /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 0){
%>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_ASJC">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">ASJC</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_ASJC" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
	                                        <form id="asjcForm" name="asjcForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value=<%=o.getString("key")%> /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 8){
%>
                                   <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_SOURCETITLE">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Source Title</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_SOURCETITLE" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="sourceTitleForm" name="sourceTitleForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 9){
%>
                                   <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_KEYWORD">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">ASJC</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_KEYWORD" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="keywordForm" name="keywordForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 3){
%>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_SOURCEID">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Source ID</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_SOURCEID" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="sourceIdForm" name="sourceIdForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 2){
%>
                                   <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_COUNTRY">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Country</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_COUNTRY" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form name="countryForm">
                                        <%
                                        int index = 0;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					
                        				if(!"".equals(o.getString("key")) || o.getString("key") == null){
											index++;                        					
                        					if(index>10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>'  type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                        }
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
<% 
if(i == 4){
%>
                                   <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_SOURCETYPE">
                                        <caption>검색 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
	                                         	<td scope="col" class="tit">Source Type</td>
	                                            <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_SOURCETYPE" style="cursor:pointer;"/></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <form id="sourceTypeForm" name="sourceTypeForm">
                                        <%
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                        					if(j>=10){
                        						continue;
                        					}
                                        %>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id='<%=o.getString("key")%>' type="checkbox" value='<%=o.getString("key")%>' /><%=o.getString("key")%></td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=o.getString("freq")%>)</td>
                                            </tr>
                                            <%
                                        }  
                                            %>
                                            </form>
                                        </tbody>
                                    </table>
                        <%
}
                        
                        %>
                        
                        
<% 
			}
	}
%>

<table class="Table13_1" border="0" cellpadding="0" cellspacing="0">
<tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td height="55" class="tit">
	<input type="button" value="Limit to" id="" name="" class="bt1"  onclick="limit();"> <input type="button" value="Exclude" id="" name="" class="bt1"  onclick="exclude();"><br /></td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                        <tr>
                                        	<td height="1" bgcolor="#a5b8ff"></td>
                                        </tr>
                                    </table></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            </div>
								<jsp:include page="../common/paging.jsp" flush="true">
						           		<jsp:param value="catAuthorDetail.jsp" name="url"/>
						           		<jsp:param value="<%=searchTerm %>" name="searchTerm"/>
						           		<jsp:param value="<%=ft%>" name="searchRule"/>
						           		<jsp:param value="<%=totalSize %>" name="totalSize"/>
						           		<jsp:param value="<%=currentPage %>" name="currentPage"/>
						           		<jsp:param value="<%=viewData %>" name="viewData"/>
						           		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
						           	</jsp:include>      
 	 	</div>
    </div>
    <!--contents_area-->
    <form id="viewDocumentParameterForm" method="get">
    	<input type="hidden" name="eid"/>
    </form>
   <form id="parameter" method="post">
	<input type="hidden" name="cn" value="<%=cn%>" />
    	<input type="hidden" name="se" value="<%=se%>" />
    	<input type="hidden" name="fl" value="<%=fl%>" />
    	<input type="hidden" name="sn" value="<%=sn%>" />
    	<input type="hidden" name="ln" value="<%=viewData %>" />
    	<input type="hidden" name="gr" value="<%=gr%>" />
    	<input type="hidden" name="ft" value="<%=ft%>" />
    	<input type="hidden" name="ud" value="<%=ud%>" />
    	<input type="hidden" name="authorSeq"/>
    	<input type="hidden" name="searchTerm" value="<%=searchTerm%>" />
	<input type="hidden" name="searchRule" value="<%=searchRule %>" />
    	<input type="hidden" name="url" value="./searchAuthor.jsp"/>
	<input type="hidden" name="currentPage" value="<%=currentPage%>"/>
	<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
	<input type="hidden" name="viewData" value="<%=viewData%>"/>
	<input type="hidden" name="pagingSize"  value="<%=pagingSize%>"/>
    </form>
    
   <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->   
</div>
</body>
</html>
<%!

public JSONObject request_url(String url,List<NameValuePair> nvps){
	 	System.out.println(url);
	 	JSONObject jsonobj = null;
		HttpClient httpclient = new DefaultHttpClient();
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		HttpPost httpost = new HttpPost(url);

		try {
			httpost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));
			
			String responseBody = httpclient.execute(httpost,responseHandler);
			jsonobj = new JSONObject(responseBody);
			HttpParams params = httpclient.getParams();
			HttpConnectionParams.setConnectionTimeout(params, 500000);
			HttpConnectionParams.setSoTimeout(params, 500000);      	
      
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 return jsonobj;
 }

%>

