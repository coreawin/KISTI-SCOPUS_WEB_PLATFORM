<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
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
try{
	int currentPage = baseRequest.getInteger("currentPage",1);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchTerm = baseRequest.getParameter("searchTerm", "");
	searchTerm = searchTerm.replaceAll(",","\\\\,").replaceAll("&","\\\\&").replaceAll("=","\\\\=").replaceAll(":","\\\\:");
	String searchRule = baseRequest.getParameter("searchRule", "");
	String se2 = baseRequest.getParameter("se2", "");
	String sort = baseRequest.getParameter("sort", "");
	//sort
	//30 : doc count
	String se = "";
	String ft = "";
	String[] rules = searchRule.split("&");

	for(int i=0;i<rules.length;i++){
		if(rules[i].startsWith("se=")){
			se = rules[i].substring(3);
		}else if(rules[i].startsWith("ft=")){
			ft = rules[i].substring(3);
		} 
	}
	
	String ra = "";

	if("31".equals(sort)){
                ra = "doc_count:asc";
        }else {
                ra = "doc_count:desc";
        }	
	int iTotalTotal = 0;
	String cn = "scopus";
	if(se.length() == 0)
	    se = "{org_name:AND("+searchTerm+"):1:32}";

	if(se2.length() == 0)
		se2 = "{org_name:AND("+searchTerm+"):1:32}";

	String fl = "afid,org_name,country,doc_count";
	String sn = ((currentPage - 1) * viewData + 1) + "";
	String gr = "country:freq:freq_desc:50";
	
	LinkedHashSet<String> eidSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(eidSet==null)eidSet = new LinkedHashSet<String>(); 

	String ud = "";
	if(searchTerm != null && searchTerm.length() > 0)
		ud = "keyword:"+searchTerm;
 

	//1. 기관검색
	JSONObject jsonobj = null;
	ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
	nvps.add(new BasicNameValuePair("cn", "affiliation"));
	nvps.add(new BasicNameValuePair("se", se));
	nvps.add(new BasicNameValuePair("fl", fl));
	nvps.add(new BasicNameValuePair("sn", sn));
	nvps.add(new BasicNameValuePair("ln", viewData+""));
	nvps.add(new BasicNameValuePair("ud", ud));
	nvps.add(new BasicNameValuePair("ft", ft));
	nvps.add(new BasicNameValuePair("ra", ra));
	nvps.add(new BasicNameValuePair("gr", gr));
	nvps.add(new BasicNameValuePair("timeout", "60"));


	//2. 통계검색
	JSONObject jsonobj2 = null;
	ArrayList<NameValuePair> nvps2 = new ArrayList<NameValuePair>();
	nvps2.add(new BasicNameValuePair("cn", "affiliation"));
	nvps2.add(new BasicNameValuePair("se", se2));
	nvps2.add(new BasicNameValuePair("fl", "afid"));
	nvps2.add(new BasicNameValuePair("sn", "1"));
	nvps2.add(new BasicNameValuePair("ln", "1"));
	nvps2.add(new BasicNameValuePair("gr", gr));
	nvps2.add(new BasicNameValuePair("ft", ft));
	nvps2.add(new BasicNameValuePair("timeout", "60"));

	//Declare for fastcatSearchURL : /common/common.jsp
	if(searchTerm.length() > 0){
		System.out.println("affiliation.jsp " + searchTerm +"\t" + searchTerm.length());
		jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);
		//jsonobj2 = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps2);
	}


	//System.out.println("searchTerm="+searchTerm+"<br>");
	System.out.println("=================catAffilation.jsp");
	System.out.println("searchRule="+searchRule);
	//System.out.println("se2="+se2+"<br>");
	//System.out.println("ra="+ra+", "+sort);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - Affiliation Search</title>
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
		form.searchRule.value = "se={org_name:AND("+searchText+"):1:32}";
		form.action="./catAffilation.jsp";
		form.submit();
	}
}

function searchWithAfid(afid) {
	//alert("TODO 수정필요!!");
	//var form = document.getElementById("parameter");
	//form.ft.value = "afid:match:"+afid;
	//form.action="./catAffilationDetail.jsp";
	//form.submit();
	var form = document.getElementById("parameter");
        form.searchTerm.value="";
        form.searchRule.value="se={afid:"+afid+"}";
        form.currentPage.value="1";
        form.action="./catresult.jsp";
        form.submit();
}


function enterCheck2() {
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
                //alert("Input search term please;");
                document.getElementById("searchTermInResult").focus();
                return;
        }
        //form.searchRule.value = "se={<%=se%>}AND{org_name:"+st+"}";
        form.searchRule.value = "se=<%=se.substring(0,se.length()-2)%> "+st+")}";
	form.currentPage.value = "1";
        form.searchTerm.value+=" "+st;
        form.action="./catAffilation.jsp";
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

function limitOrExclude(operation) {
	var searchRuleParamStr = ""; 
	/*
	 * 검색식을 세팅하기 위해 결과내 검색에서 항목 선택시 해당항목을 임시적으로
	 * 저장하는 변수.
	 */
	var form = document.getElementById("parameter");
	var searchRule = form.searchRule.value;
	var filter = "";
	var e = document.countryForm.elements.length;
	var cnt = 0;
	var ft = "<%=ft %>";
	var se = "<%=se %>";
	var hasFilter = false;

	if (ft != "") {
		hasFilter = true;
	}

	//1. country
	var flag = false;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.countryForm.elements[cnt].checked) {
			flag = true;
		}
	}
	
	if (flag) {
		filter += "country:"+operation+":";
		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.countryForm.elements[cnt].checked) {
				filter += document.countryForm.elements[cnt].value + ";";
			}
		}
		
		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		//filter += ",";
	}

	
	if (hasFilter)
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + ft + ","
				+ filter;
	else
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + filter;

	form.action = "./catAffilation.jsp";
	form.submit();
}


function limit()
{
	var searchRuleParamStr = ""; /* 검색식을 세팅하기 위해 결과내 검색에서 항목 선택시 해당항목을 임시적으로 저장하는 변수.*/
	var form = document.getElementById("parameter");
	var searchRule = form.searchRule.value;
	var flag = false;
	var filter = "";1
	var e= document.countryForm.elements.length;
	var cnt=0;
	var ft = "<%=ft %>";
	var se = "<%=se %>";
	var hasFilter = false;
        
	if(ft != ""){
		hasFilter = true;
	}

	for(cnt=0;cnt<e;cnt++){
		if(document.countryForm.elements[cnt].checked){
			flag = true;
		}
	}
	
	if(flag){
		filter += "country:match:";
		searchRuleParamStr = "";
		for(cnt=0;cnt<e;cnt++){
			if(document.countryForm.elements[cnt].checked){
			 filter += document.countryForm.elements[cnt].value+";";
			 searchRuleParamStr += document.countryForm.elements[cnt].value+" ";
			}
		}

		if(filter.substring(filter.length-1) == ";"){
			filter = filter.substring(0,filter.length-1); 
		}
	  
	}
	  
	if(hasFilter)
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + ft + "," + filter;
	else
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + filter;
	//alert(form.searchRule.value);
	form.action="./catAffilation.jsp";
	form.submit();
}



function exclude(){
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

	for(cnt=0;cnt<e;cnt++){
		if(document.countryForm.elements[cnt].checked){
			flag = true;
		}
	}

	if(flag){
		filter += "country:exclude:";
		for(cnt=0;cnt<e;cnt++){
			if(document.countryForm.elements[cnt].checked){
				filter += document.countryForm.elements[cnt].value+";";
			}
		}
		if(filter.substring(filter.length-1) == ";"){
			filter = filter.substring(0,filter.length-1); 
		}
	}

	//submit search form  asjccode:match:2200
	var form = document.getElementById("parameter");
	
	if(hasFilter)
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + ft + "," + filter;
	else
		form.searchRule.value = "se=" + jQuery.trim(se) + "&ft=" + filter;

	form.action="./catAffilation.jsp";
	form.submit();
}

function sortSearch(sortType){
        var form = document.getElementById("parameter");
        form.sort.value = sortType;
        form.action="./catAffilation.jsp";
        form.submit();
}

$(document).ready(function() {
	$(".tipTipClass").tipTip({maxWidth: "auto", edgeOffset: 10});
	$(".bt2").tipTip({maxWidth: "auto", edgeOffset: 10});
	/*
	$('img[name*=Folding]').each(function(){
		 var name = $(this).attr("name").split("_");
		 $(this).click(function() {
			jQuery("#StaticsContentsView_"+name[1]+" tbody").toggle(); 
			toggleImage($(this));
			return false;
		});
	});
	*/
	
	$('img[name*=Folding]').each(function(){
		 var name = $(this).attr("name").split("_");
		 $(this).click(function() {
			jQuery("#morespanid_"+name[1]).text("more...");
			jQuery("#morespan_"+name[1]).hide();
			jQuery("#StaticsContentsView_"+name[1]+" tbody").toggle(); 
			toggleImage($(this));
			return false;
		});
	});
	
	$('span[name*=morespan_]').each(function(){
		 var name = $(this).attr("name");
		 $(this).click(function() {
			jQuery("#"+name).toggle();
			if($(this).text()=="folding..."){
				$(this).text("more...");
			}else{
				$(this).text("folding...");
			}
			return false;
		});
	});
	
	$("#historySearchRuleAll").click(function() {
        if ($("#historySearchRuleAll:checked").length > 0) {
            $("input[name=historySearchRule]:checkbox:not(checked)").attr("checked", "checked");
            $("input[name=historySearchRule]:checkbox:disabled").attr("checked", "");
        } else {
            $("input[name=historySearchRule]:checkbox:checked").attr("checked", "");
        }
    });
});

function toggleImage(jQueryObj){
	var imgSrc = jQueryObj.attr("src");
	if(imgSrc=="<%=request.getContextPath()%>/images/nn_search_arrow01.gif"){
		jQueryObj.attr("src", "<%=request.getContextPath()%>/images/nn_search_arrow02.gif"); 
	}else{
		jQueryObj.attr("src", "<%=request.getContextPath()%>/images/nn_search_arrow01.gif");
	}
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
    	<jsp:param value="<%=SUB_MENU_AFFILATION_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
			<% String menuTerm = "Affiliation Search"; %>
		<%@include file="../common/quickSearch.jsp" %>	
		</div>

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
	                    	<table class="Table8" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블">
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt2" style="padding:5px 5px 5px 10px; text-align:left;"><strong>Affilation Name : </strong>
										<input type="text" id="searchTerm" name="searchTerm" size="95%" class='input_txt1 tipTipClass' title="검색어를 입력하세요." value="<%= searchTerm%>" onkeypress="javascript:enterCheck2();" />
	                                	<!-- input type="checkbox" class="tipTipClass" id="exactMatchCheck" name="exactMatchCheck" title="정확히 매치된 기관 이름만을 검색합니다." style="text-align:right;" alt="Show exact matches only"/> Show exact matches only -->
	                                	<input type="button" class="bt5" value="Search" title="저자이름을 검색합니다." alt="Search" onclick="javsscript:search();"/>
									</td>
	                            </tr>
	                  		</table>
                  		</form>
                  	</td>
             	</tr>
				<tr>
       	  		 	<td height="10"></td>
   	  		 	</tr>
            </table>
	 	 	</div>
<%
	JSONArray resultArr = null;
        String bgColor = "";
        int realSize = 0;
        String time = "0ms";
        if(jsonobj != null && jsonobj.getInt("status") == 0){
                iTotalTotal = jsonobj.getInt("total_count");
                realSize = jsonobj.getInt("count");
                time = jsonobj.getString("time");
        }
%>            
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
                                                        <td>&nbsp;Search <%=sn%> ~ <%=Integer.parseInt(sn) + realSize -1%> / Total : <%=iTotalTotal%> (<%=time%>)</td>
                                                        <td align="right">
                                                        	Sort by
                                                        	<select name="sortBy" id="sortBy" onchange="sortSearch(this.options[this.options.selectedIndex].value)">
                                                            	<option value="30" <%="30".equals(sort)?"selected":"" %>>-　Document Count DESC　-</option>
                                                            	<option value="31" <%="31".equals(sort)?"selected":"" %>>-　Document Count ASC　-</option>
                                                        	</select>
                                                        </td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5">
                                        <caption>검색 결과 테이블</caption>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <th width="25%" style="padding:5px 5px 5px 5px; text-align:left; ">Affilation ID</th>
			                                    <th width="45%" style="padding:5px 5px 5px 5px; text-align:left; ">Affilation Name</th>
			                                    <th width="15%" style="padding:5px 5px 5px 5px; text-align:left; ">Country Code</th>
			                                    <th width="15%" style="padding:2px 2px 2px 2px;">Documents</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<% 

	if(jsonobj != null && jsonobj.getInt("status") == 0){
        iTotalTotal = jsonobj.getInt("total_count");
        resultArr = jsonobj.getJSONArray("result");
        
		if(resultArr != null && iTotalTotal > 0){
			int cnt = 0;
			for (int j=0;j<resultArr.length();j++) {
				JSONObject o = resultArr.getJSONObject(j);
				String afid = o.getString("afid");
				String org_name = o.getString("org_name");
				String country = o.getString("country");
				String doc_count = o.getString("doc_count");
				
				String[] orgNameList = org_name.split("\n");

				int AFF_LIST_MAX = 3;
				String afName = "";

				if(orgNameList.length > AFF_LIST_MAX){
					String tmp = searchTerm.split(" ")[0];
					int[] selection = new int[AFF_LIST_MAX];
					int m = 0;
					for(int k=0; k < orgNameList.length; k++){
						if(orgNameList[k].indexOf(tmp) != -1 && m <AFF_LIST_MAX){
							selection[m++] = k;
						}
					}
					
					//나머지 selection배열에 0부터 채워주는데, 이미 selection에 들어가 있는 숫자는 채우지 않는다.
					for(;m < selection.length;m++){
						for(int k=0;k < orgNameList.length;k++){
							for(int p=0; p < m; p++){
								if(selection[p] != k){
									selection[m++] = k;
									break;
								}
							}

							if(m == selection.length)
								break;
						}
					}

					for(int k =0;k < selection.length;k++){
						afName +=orgNameList[selection[k]];
						if(k < selection.length - 1){
							afName += "<br>";
						}
					}
				}else{
					afName = org_name.replaceAll("\n","<br>");
				}

				//country 변환
				country = country.replaceAll("\n","<br>");
				String bgcolor = "";
				if(cnt++ % 2 == 0){
					bgcolor="bgcolor='#f4f8fa'";
				}else{
					bgcolor="";
				}
%>
					<tr <%=bgcolor %>>
						<td style="padding:5px 5px; color:#005eac; text-align:left; vertical-align: top;"><%=afid%></td>
						<td style="padding:5px 5px; color:#005eac; text-align:left; vertical-align: top;"><%=afName%></td>
						<td style="padding:5px 5px; color:#2a87d5; text-align:left; vertical-align: top;"><%=country%></td>
						<td style="padding:5px 5px; color:#2a87d5; text-align:center; vertical-align: top;"><%=doc_count%></td>
					</tr>
<%
			}//for (int j=((currentPage-1)*viewData);j<groupIndex;j++) {
		}else{//if(groupResultArr != null){
			out.println("<tr>");
			out.println("<td colspan='4' style='padding:5px 5px; color:#2a87d5; text-align:center; vertical-align: top;'><b>검색 결과가 존재하지 않습니다.<b></td>");
			out.println("</tr>");
		}
	}else{// jsonobj.getInt("status") == 0
		out.println("<tr>");
		out.println("<td colspan='4' style='padding:5px 5px; color:#2a87d5; text-align:center; vertical-align: top;'><b>검색 결과를 표시하기 위해서는 검색을 하셔야 합니다.<b></td>");
		out.println("</tr>");
	}
%>
                                        </tbody>
                                    </table>
                                    <br/>
											．
											<jsp:include page="../common/paging.jsp" flush="true">
												<jsp:param value="./catAffilation.jsp" name="url"/>
												<jsp:param value="<%=searchTerm %>" name="searchTerm"/>
												<jsp:param value="<%=searchRule %>" name="searchRule"/>
												<jsp:param value="<%=iTotalTotal %>" name="totalSize"/>
												<jsp:param value="<%=currentPage %>" name="currentPage"/>
												<jsp:param value="<%=viewData %>" name="viewData"/>
												<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
											</jsp:include>
                                    </td>
                                <td width="17%" valign="top">
                                
<!-- 결과내 재검색을 위한 하단 버튼 표시 Start -->                                 
                                    <table class="Table13" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td height="55" class="tit">
                                                    <%
                                                       	out.println("<div>Search within results</div>");
                                                        if(iTotalTotal!=0){
                                                    		out.println("<input type='text' id='searchTermInResult' name='searchTermInResult' class='input_txt1' size='15'/>");
                                                    		out.println("<input type='button' value='Search' class='bt1'  onclick='javascript:searchInResult();'/>");
                                                        	
                                                        }else{
                                                        	out.println("&nbsp;");
                                                        }
                                                    %>
														</td>
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
                                                        <td height="55" class="tit">
                                                    <%
                                                        if(iTotalTotal!=0){
                                                        	out.println("<strong>Refine results</strong><br />");
                                                    		out.println("<input type='button' value='Limit to' class='bt1'  onclick='javascript:limitOrExclude(\"match\");'/>");
                                                    		out.println("<input type='button' value='Exclude' class='bt1'  onclick='javascript:limitOrExclude(\"exclude\");'/>");
                                                        	
                                                        }else{
                                                        	out.println("&nbsp;");
                                                        }
                                                    %>
														</td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>
<!-- 결과내 재검색을 위한 하단 버튼 표시 End--> 

<!-- 통계 항목 Start -->
<%
if(jsonobj != null && jsonobj.getInt("status") == 0 ){
	JSONArray groupResultArr = null;
	try{
		groupResultArr = jsonobj.getJSONArray("group_result");
	}catch(org.json.JSONException je){
		//ingore
	}
	if(groupResultArr != null){
		
		/*항목에 표시하는 타이틀 명*/
		String titleName = "Title name";
		
		/*limit, exclude와 같은 결과내 재검색을 위함 Form name*/
		String formName  = "";
		
		/* 부가정보 */
		Map<String, String> descriptionMapData =  null;
		
		/*한번에 보여줄 통계 갯수.*/
		int groupCount = 7;
		for (int i=0;i<groupResultArr.length();i++) {
			JSONArray arr = groupResultArr.getJSONArray(i);
			descriptionMapData =  new HashMap<String, String>();
			if(i==0){
				titleName = "Country";
				formName = "countryForm";
				descriptionMapData = DescriptionCode.getCountryType();
			}else{
				continue;
			}
%>
		   <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="StaticsContentsView_<%=i%>">
				<caption>검색 테이블</caption>
				<thead>
					<tr bgcolor="#c0defa">
						<td scope="col" class="tit"><%=titleName %></td>
						<td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" name="Folding_<%=i %>" style="cursor:pointer;"/></td>
				 </tr>
				 <tr>
					<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
				</tr>
				</thead>
				<form id="<%=formName %>" name="<%=formName%>">
				<tbody>
<%

			   //HashMap<String, String> descSourceType = DescriptionCode.getSourceTypeDescription();
			   for (int j=0;j<arr.length();j++) {
				JSONObject o = arr.getJSONObject(j);
				String key = o.getString("key");
				String freq = o.getString("freq");
				String desc = key;
				
				if(descriptionMapData.containsKey(key.toLowerCase())){
					desc = descriptionMapData.get(key.toLowerCase());
				}
				if(descriptionMapData.containsKey(key.toUpperCase())){
					desc = descriptionMapData.get(key.toUpperCase());
				}
				
				if(j==groupCount && arr.length() > groupCount){
					//continue;
					out.println("<tr><td colspan='2' style='padding:0px 0px 0px 5px;text-align: right;'><span id='morespanid_"+i+"' name=\"morespan_"+i+"\" style='cursor:pointer;'>more..</span></td></tr>");
					out.println("<tr width='100%'><td colspan='2' width='100%' ><table cellspacing='0' cellpadding='0' border='0' width='100%' id=\"morespan_"+i+"\" style='display:none'>");
					//out.println("<span id=\"more_"+i+"\" style=\"display:none;\">");
				}
%>
					<tr  class="tipTipClass" title="<%=desc%>">
						<td style="padding:0px 0px 0px 5px;font-family:'맑은 고딕','Trebuchet MS'">
							<input name="check1" id='<%=key%>' type="checkbox" value="<%=key%>"/>
								<%=desc.length() > 14 ? desc.substring(0,14):desc %>
						</td>
						<td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=freq%>)</td>
					</tr>
<%
				}  //for
				if(arr.length() > groupCount){
					out.println("</table></td></tr>");
				}
%>
				</tbody>
				</form>
			</table>
                        
<% 
			} //for (int i=0;i<groupResultArr.length();i++) {
	} //if(groupResultArr != null){
}
%>
<!-- 통계 항목 End -->

<!-- 결과내 재검색을 위한 하단 버튼 표시 Start -->
			<table class="Table13_1" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr bgcolor="#ecf8ff">
								<td height="55" class="tit">
							<%
								if(iTotalTotal!=0){
									out.println("<input type='button' value='Limit to' class='bt1'  onclick='javascript:limit();'/>");
									out.println("<input type='button' value='Exclude' class='bt1'  onclick='javascript:exclude();'/>");
									
								}else{
									out.println("&nbsp;");
								}
							%>
								</td>
							</tr>
						</table></td>
				</tr>
				<tr>
					<td height="1" bgcolor="#a5b8ff"></td>
				</tr>
			</table>
<!-- 결과내 재검색을 위한 하단 버튼 표시 End-->                                    
                                   </td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            </div>
 	 	</div>
    </div>
    <!--contents_area-->
    
    <form id="viewDocumentParameterForm" method="get">
    	<input type="hidden" name="eid"/>
    </form>
    
   <form id="parameter" method="post">
    	<input type="hidden" name="se" value="<%=se%>" />
    	<input type="hidden" name="fl" value="<%=fl%>" />
    	<input type="hidden" name="sn" value="<%=sn%>" />
    	<input type="hidden" name="ln" value="<%=viewData %>" />
    	<input type="hidden" name="gr" value="<%=gr%>" />
    	<input type="hidden" name="ft" value="<%=ft%>" />
    	<input type="hidden" name="ud" value="<%=ud%>" />
    	<input type="hidden" name="searchTerm" value="<%=searchTerm%>" />
		<input type="hidden" name="searchRule" value="<%=searchRule %>" />
    	<input type="hidden" name="url" value="./searchAffiliation.jsp"/>
		<input type="hidden" name="currentPage" value="<%=currentPage%>"/>
		<input type="hidden" name="totalSize" value="<%=iTotalTotal%>"/>
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
<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>

