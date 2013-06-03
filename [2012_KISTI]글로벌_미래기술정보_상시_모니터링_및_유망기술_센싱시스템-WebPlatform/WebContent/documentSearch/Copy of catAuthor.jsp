<%@page import="kr.co.tqk.web.db.bean.AuthorInfoBean"%>
<%@page import="java.sql.Connection"%>
<%@page import="kr.co.tqk.db.ConnectionFactory"%>
<%@page import="kr.co.tqk.web.db.dao.AuthorInfoDao"%>
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
<%@include file="../common/auth.jsp" %>   
<%
	int groupCount = 10;
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", 0);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchTerm = baseRequest.getParameter("searchTerm", "");
	String searchRule = baseRequest.getParameter("searchRule", "");
	
	String sort = baseRequest.getParameter("sort", "desc");
	/* LinkedList<AuthorSearchResultBean> asrBeanList = SearchDocument.searchAuthor(searchRule, currentPage, viewData);
	if(!"".equals(searchTerm)){
		totalSize = SearchDocument.getTotalSearchResultCount();
	} */
	String se = "";
        String ft = "";
        String[] rules = searchRule.split("&");
	String fields = "title,abs,authorkeyword,indexkeyword";

        for(int i=0;i<rules.length;i++){
            if(rules[i].startsWith("se=")){
                se = rules[i].substring(3);
            }else if(rules[i].startsWith("ft=")){
                ft = rules[i].substring(3);
            } 
        }       

	
	int iTotalTotal = 0;
	String cn = "kisti";
	if(se.length() == 0)
	    se = "{authorname:"+searchTerm+"}";
	String fl = "eid";
	String sn = "1";//""+((currentPage-1)*20+1);//"1";
	String gr = "asjc:freq:freq_desc,pubyear:freq:key_desc,country:freq:freq_desc,sourceid:freq:freq_desc,sourcetype:freq:key_asc,authorid:freq:freq_"+sort;
	LinkedHashSet<String> eidSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(eidSet==null)eidSet = new LinkedHashSet<String>(); 

	 String ud = "";
        if(searchTerm != null && searchTerm.length() > 0)
            ud = "keyword:"+searchTerm;
 
	 JSONObject jsonobj = null;
	 ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
		nvps.add(new BasicNameValuePair("cn", cn));
		nvps.add(new BasicNameValuePair("se", se));
		nvps.add(new BasicNameValuePair("fl", fl));
		nvps.add(new BasicNameValuePair("sn", sn));
		nvps.add(new BasicNameValuePair("ln", "1"));
		nvps.add(new BasicNameValuePair("gr", gr));
		nvps.add(new BasicNameValuePair("ud", ud));
		nvps.add(new BasicNameValuePair("ft", ft));
		nvps.add(new BasicNameValuePair("timeout", "60"));

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
		form.searchRule.value = "se={authorname:"+searchText+"}";
		form.action="./catAuthor.jsp";
		form.submit();
	}
}

function searchWithAuthorid(authorid) {
        var form = document.getElementById("parameter");
        form.ft.value = "authorid:match:"+authorid;
        form.action="./catAuthorDetail.jsp";
        form.submit();
}


function enterCheck() {
	getEvent=event.keyCode;
	if (getEvent == "13") {			
		search();
		return;
	}
}

function searchInResult(){
        var form = document.getElementById("parameter");
        var st = jQuery.trim(document.getElementById("searchTermInResult").value);
        if(""==st){
                alert("Input search term please;");
                document.getElementById("searchTermInResult").focus();
                return;
        }
        form.searchRule.value = "se={<%=se%>}AND{<%=fields%>:"+st+"}";
        form.currentPage.value = "1";
        form.searchTerm.value+=" "+st;
        form.action="./catAuthor.jsp";
        form.submit();
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
        var ft = "<%=ft %>";
        var se = "<%=se %>";
        var hasFilter = false;
        
        if(ft != ""){
            hasFilter = true;
        }

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
	  //alert("filter=>"+filter +"\nsearchRule=>"+searchRule);
          //submit search form  asjccode:match:2200

        if(hasFilter)
            form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + ft + "," + filter;
        else
            form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + filter;
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
	var ft = "<%=ft %>";
        var se = "<%=se %>";
        var hasFilter = false;
        
        if(ft != ""){
            hasFilter = true;
        }

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
	  //alert(filter);
	  //submit search form  asjccode:match:2200
	var form = document.getElementById("parameter");
	
	if(hasFilter)
            form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + ft + "," + filter;
        else
            form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + filter;
        form.action="./catAuthor.jsp";
        form.submit();
}

function sortSearch(sortType){
        var form = document.getElementById("parameter");
        form.sort.value = sortType;
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
                    <td> <!-- "<span class="txt3">나노</span>" 키워드로 검색한 결과입니다.  --></td>
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
                                <td height="25" class="txt">
                                	<%
                                		if(!"".equalsIgnoreCase(searchRule.trim())){
											out.println(searchRule + " search result : " + jsonobj.getJSONArray("group_result").getJSONArray(5).length());                                			
                                		}
                                	%>
                                </td>
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
                                                        	<select name="sortBy" id="sortBy" onchange="sortSearch(this.options[this.options.selectedIndex].value)">
                                                            	<!--<option value="20">-　Author Name (A-Z)　-</option>
                                                            	<option value="20">-　Author Name (Z-A)　-</option>
                                                            	<option value="20">-　Affilation (A-Z)　-</option>
                                                            	<option value="20">-　Country (A-Z)　-</option>-->
                                                            	<option value="desc" <%="desc".equals(sort)?"selected":"" %>>-　Document Count DESC　-</option>
                                                            	<option value="asc" <%="asc".equals(sort)?"selected":"" %>>-　Document Count ASC　-</option>
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
                                                <th width="200" style="padding:2px 2px 2px 2px;">Author ID</th>
			                                    <th width="200" style="padding:2px 2px 2px 2px;">Author</th>
			                                    <th style="padding:2px 2px 2px 2px;">Affiliation</th>
			                                    <th width="100" style="padding:2px 2px 2px 2px;">Country</th>
			                                    <th width="100" style="padding:2px 2px 2px 2px;">Documents</th>
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

if(groupResultArr != null){

		JSONArray arr = groupResultArr.getJSONArray(5);
		int groupIndex = Math.min(arr.length(),viewData*currentPage);
		totalSize = arr.length();
		ConnectionFactory cf  = ConnectionFactory.getInstance();
		Connection conn = cf.getConnection();
		int cnt = 0;
		for (int j=((currentPage-1)*viewData);j<groupIndex;j++) {
			JSONObject o = arr.getJSONObject(j);
			String authorID = o.getString("key");
			HashSet<AuthorInfoBean> authorSet = AuthorInfoDao.searchAuthorIDInfo(conn, authorID);
			HashSet<String> countryCodeSB = new HashSet<String>();
			HashSet<String> authorNameSB = new HashSet<String>();
			HashSet<String> affilationSB = new HashSet<String>();
			
			for(AuthorInfoBean aiBean : authorSet){
				String a = aiBean.getCountryCode().trim();
				if(!"".equals(a)){
					if(countryCodeSB.size()==3) continue;
					countryCodeSB.add(a);
				}
				a = aiBean.getAuthorName().trim();
				if(!"".equals(a)){
					if(authorNameSB.size()==3) continue;
					authorNameSB.add(a);
				}
				a = aiBean.getOrgName().trim();
				if(!"".equals(a)){
					if(affilationSB.size()==3) continue;
					affilationSB.add(a);
				}
				
			}
			String bgcolor = "";
			if(cnt++ % 2 == 0){
				bgcolor="bgcolor='#f4f8fa'";
			}else{
				bgcolor="";
			}
%>
                       	 	 	<tr <%=bgcolor %>>
                                 	<td style="color:#005eac; text-align:center; vertical-align: top;"><a href="./viewAuthor.jsp?authorID=<%=authorID%>"><%=authorID%></a></td>
									<td scope="row" style="padding:5px 5px; color:#005eac; text-align:right; vertical-align: top;"><a href="./viewAuthor.jsp?authorID=<%=authorID%>"><%=authorNameSB.size()==0?"":authorNameSB.toString().replaceAll(",","<BR>").replaceAll("\\[","").replaceAll("\\]","")%></a></td>
                                 	<td style="padding:5px 5px; text-align:left; vertical-align: top;"><%=affilationSB.size()==0?"":affilationSB.toString().replaceAll(",","<BR>").replaceAll("\\[","").replaceAll("\\]","")%></td>
                                    <td style="color:#2a87d5; text-align:center; vertical-align: top;"><%=countryCodeSB.size()==0?"":countryCodeSB.toString().replaceAll(",","<BR>").replaceAll("\\[","").replaceAll("\\]","")%></td>
								    <td style="color:#2a87d5; text-align:center; vertical-align: top;"><a href='javascript:searchWithAuthorid(<%=o.getString("key")%>);'><%=o.getString("freq")%></a></td>
                       	 	 	</tr>
<%
	}
		conn.close();
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
														<input type="text" id="searchTermInResult" name="searchTermInResult" size="15" value="" class="input_txt1"> <input type="button" value="Search" id="" name="" class="bt1"  onclick="searchInResult()"></td>
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
groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                                        			if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
                        					//if(j>=10){
                        					//	continue;
                        					//}
								if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
					groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                                        if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
					groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
                                        if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
				groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
        if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
	groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
	groupCount = 10;
                                        for (int j=0;j<arr.length();j++) {
                        					JSONObject o = arr.getJSONObject(j);
                        					//out.print(o.getString("key")+"("+o.getString("freq")+")");
if("".equals(o.getString("key"))){
                                                                        groupCount++;
                                                                        continue;
                                                                }
                                                                if(j>=groupCount){
                                                                        break;
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
						           		<jsp:param value="catAuthor.jsp" name="url"/>
						           		<jsp:param value="<%=searchTerm %>" name="searchTerm"/>
						           		<jsp:param value="<%=searchRule %>" name="searchRule"/>
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
	<input type="hidden" name="sort"  value="<%=sort%>"/>
    </form>
    
   <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->   
</div>
</body>
</html>

<%!
public JSONObject searchWithId(String id){
         JSONObject jsonobj = null; 
         ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
                nvps.add(new BasicNameValuePair("cn", "author"));
                nvps.add(new BasicNameValuePair("se", "{author_id:"+id+":100:15}"));
                nvps.add(new BasicNameValuePair("fl", "author_id,author_name,org_name,country_code"));
                nvps.add(new BasicNameValuePair("sn", "1"));
                nvps.add(new BasicNameValuePair("ln", "1"));
         
                jsonobj = FastCatSearchUtil.requestURL("http://192.168.0.60:9090/search/json", nvps);
//System.out.println("jsonobj =>>"+jsonobj);
                return jsonobj;
}
%>

