<%@page import="kr.co.tqk.web.util.InfoStack"%>
<%@page import="kr.co.tqk.web.db.dao.ScopusTypeDao"%>
<%@page import="kr.co.tqk.web.util.InfoStack.InfoStackType"%>
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

	Map<String, String> sourceTitleMap = (Map<String, String>)application.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE));
	Map<String, Integer> sourceTitleFreqMap = (Map<String, Integer>)application.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ));
	
	Map<String, String> affilationNameMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME));
	Map<String, Integer> affilationNameFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME_FREQ));
	
	if(sourceTitleMap==null) sourceTitleMap = new HashMap<String, String>();
	if(sourceTitleFreqMap==null) sourceTitleFreqMap = new HashMap<String, Integer>();
	if(affilationNameMap==null) affilationNameMap = new HashMap<String, String>();
	if(affilationNameFreqMap==null) affilationNameFreqMap = new HashMap<String, Integer>();
	

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
	System.out.println("catAuthor : " + searchRule);
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
	    se = "{author_name,index_name:AND("+searchTerm+"):1:32}";

	if(se2.length() == 0)
	    se2 = "{authorname:AND("+searchTerm+"):1:32}";

	String fl = "author_id,author_name,index_name,email,doc_count";
	String sn = ((currentPage - 1) * viewData + 1) + "";
	String gr = "pubyear:freq:key_desc:50,afid:freq:freq_desc:50,asjc:freq:freq_desc:50,sourceid:freq:freq_desc:50,country:freq:freq_desc:50";
	LinkedHashSet<String> eidSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(eidSet==null)eidSet = new LinkedHashSet<String>(); 

	 String ud = "";
        if(searchTerm != null && searchTerm.length() > 0)
            ud = "keyword:"+searchTerm;

	//1. 저자검색
	JSONObject jsonobj = null;
	ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
	nvps.add(new BasicNameValuePair("cn", "author"));
	nvps.add(new BasicNameValuePair("se", se));
	nvps.add(new BasicNameValuePair("fl", fl));
	nvps.add(new BasicNameValuePair("sn", sn));
	nvps.add(new BasicNameValuePair("ln", viewData+""));
	nvps.add(new BasicNameValuePair("ud", ud));
	nvps.add(new BasicNameValuePair("ft", ft));
	nvps.add(new BasicNameValuePair("ra", ra));
	nvps.add(new BasicNameValuePair("timeout", "60"));


	//2. 통계검색
	JSONObject jsonobj2 = null;
	ArrayList<NameValuePair> nvps2 = new ArrayList<NameValuePair>();
	nvps2.add(new BasicNameValuePair("cn", cn));
	nvps2.add(new BasicNameValuePair("se", se2));
	nvps2.add(new BasicNameValuePair("fl", "eid"));
	nvps2.add(new BasicNameValuePair("sn", "1"));
	nvps2.add(new BasicNameValuePair("ln", "1"));
	nvps2.add(new BasicNameValuePair("gr", gr));
	nvps2.add(new BasicNameValuePair("ft", ft));
	nvps2.add(new BasicNameValuePair("timeout", "60"));

	//Declare for fastcatSearchURL : /common/common.jsp
	if(searchTerm.length() > 0){
		jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);
		jsonobj2 = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps2);
	}
/*
	System.out.println("searchTerm="+searchTerm+"<br>");
	System.out.println("searchRule="+searchRule+"<br>");
	System.out.println("se2="+se2+"<br>");
	System.out.println("ra="+ra+", "+sort);
*/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - Author Search</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function searchAuthor(){
	var form = document.getElementById("parameter");
	var formTmp = document.getElementById("parameterForm");
	var searchText = formTmp.searchTerm.value;
	//var exactMatch = form.exactMatchCheck.checked;
	var exactMatch = false;
 	form.ft.value = "";	
	if(searchText == null || searchText == ""){
		alert("검색어를 입력해 주세요.");
		formTmp.searchTerm.focus();
		return;
	}else{
		form.method = "POST";
		form.searchTerm.value = searchText;
		form.searchRule.value = "se={author_name,index_name:AND("+searchText+":1:32)}";
		form.action="./catAuthor.jsp";
		form.submit();

	}
}

function searchWithAuthorid(authorid) {
	//alert("TODO 수정필요!!");
	//var form = document.getElementById("parameter");
	//form.detail.value = "{author_id:"+authorid+"}";
	//form.action="./catAuthor.jsp";
	//form.submit();
	var form = document.getElementById("parameter");
        form.searchTerm.value="";
        form.searchRule.value="se={authorid:"+authorid+":1:32}";
        form.currentPage.value="1";
        form.action="./catresult.jsp";
        form.submit();
}


function enterCheck2() {
	getEvent=event.keyCode;
	if (getEvent == "13") {			
		searchAuthor();
		//return false;
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
        //form.searchRule.value = "se={<%=se%>}AND{author_name,index_name:AND("+st+")}";
        form.searchRule.value = "se=<%=se.substring(0,se.length()-2)%> "+st+")}";
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

function sortSearch(sortType){
        var form = document.getElementById("parameter");
        form.sort.value = sortType;
        form.action="./catAuthor.jsp";
        form.submit();
}

function hiddenT(ids){
	jQuery("#"+ids).toggle(); 
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
	});*/
	
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
    	<jsp:param value="<%=SUB_MENU_AUTHOR_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
			<% String menuTerm = "Author Search"; %>
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
                    	<form name="parameterForm" id="parameterForm" method="get">
    						<input type="hidden" name="searchRule"/>
	                    	<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블">
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt2" style="padding:5px 5px 5px 10px; text-align:left;"><strong>Author Name : </strong>
										<input type="text" id="searchTerm" name="searchTerm" size="95%" class='input_txt1 tipTipClass' title="검색어를 입력하세요." value="<%=searchTerm%>" onkeypress="javascript:enterCheck2();" />
	                                	<!-- input type="checkbox" class="tipTipClass" id="exactMatchCheck" name="exactMatchCheck" title="정확히 매치된 저자 이름만을 검색합니다." style="text-align:right;" alt="Show exact matches only"/> Show exact matches only -->
	                                	<input type="button" class="bt5" value="Search" title="저자이름을 검색합니다." alt="Search" onclick="javascript:searchAuthor();"/>
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
                    <td  valign="top">
                    	<table class="Table9" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="83%" valign="top">
                                    <table class="Table10" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td>&nbsp;Search <%=sn%> ~ <%=Integer.parseInt(sn) + realSize - 1%> / Total : <%=iTotalTotal%> (<%=time%>)</td>
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
                                                <th width="15%" style="padding:5px 5px 5px 5px; text-align:left; ">Author ID</th>
			                                    <th width="25%" style="padding:5px 5px 5px 5px; text-align:left; ">Author Name</th>
												<th width="25%" style="padding:5px 5px 5px 5px; text-align:left; ">Index Name</th>
			                                    <th width="25%" style="padding:5px 5px 5px 5px; text-align:left; ">Author Email</th>
			                                    <th width="10%" style="padding:2px 2px 2px 2px;">Documents</th>
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
				String author_id = o.getString("author_id");
				String author_name = o.getString("author_name");
				String index_name = o.getString("index_name");
				String email = o.getString("email");
				String doc_count = o.getString("doc_count");
				String emailStr = "";
			 	if(email != null){	
					String[] emails = email.split("&#13;&#10;");
					for(int idx=0; idx<emails.length ; idx++){
				   		emailStr += emails[idx] + "<br>";
				   		if(idx>=8) break;
					}
				}

				String authorStr = "";
				if(author_name == null){
					author_name = "";
				}else{
					String[] author_names = author_name.split("&#13;&#10;");
					
					for(int idx=0; idx<author_names.length ; idx++){
						if(author_names[idx].trim().equals("")) continue;
						authorStr += author_names[idx].trim();
						if(idx % 2 ==1 && idx!=0){
							authorStr += " <br> ";
						}else{
							authorStr += "&nbsp;/&nbsp;";
						}
					}
				}
				
				String indexName = "";
				if(index_name == null){
					index_name = "";
				}else{
					String[] index_names = index_name.split("&#13;&#10;");
					for(int idx=0; idx<index_names.length ; idx++){
						if(index_names[idx].trim().equals("")) continue;
						indexName += index_names[idx].trim();
						if(idx % 2 ==1 && idx!=0){
							indexName += " <br> ";
						}else{
							indexName += "&nbsp;/&nbsp;";
						}
					}
				}
				
				if(index_name == null){
					index_name = "";

				}
				
				if(author_id == null){
					author_id = "";
				}
				if(doc_count == null){
					doc_count = "";
				}
				String bgcolor = "";
				if(cnt++ % 2 == 0){
					bgcolor="bgcolor='#f4f8fa'";
				}else{
					bgcolor="";
				}
			//	System.out.println(doc_count+"&&&&&&&&&&&&&&&");
%>
					<tr <%=bgcolor %>>
						<td style="padding:5px 5px; color:#005eac; text-align:left; vertical-align: top;"><a href="./viewAuthor.jsp?authorID=<%=author_id%>"><%=author_id%></a></td>
						<td style="padding:5px 5px; color:#005eac; text-align:left; vertical-align: top;"><a href="./viewAuthor.jsp?authorID=<%=author_id%>"><%=authorStr%></a></td>
						<td style="padding:5px 5px; color:#005eac; text-align:left; vertical-align: top;"><a href="./viewAuthor.jsp?authorID=<%=author_id%>"><%=indexName%></a></td>
						<td style="padding:5px 5px; color:#2a87d5; text-align:left; vertical-align: top;"><%=emailStr%></td>
						<td style="padding:5px 5px; color:#2a87d5; text-align:center; vertical-align: top;"><a href='javascript:searchWithAuthorid(<%=author_id%>);'><%=doc_count%></a></td>
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
												<jsp:param value="./catAuthor.jsp" name="url"/>
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
                                                  
														</td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>
<!-- 결과내 재검색을 위한 하단 버튼 표시 End--> 

<!-- 통계 항목 Start -->
<%
if(jsonobj2 != null && jsonobj2.getInt("status") == 0 && iTotalTotal > 0){
	JSONArray groupResultArr = null;
	try{
		groupResultArr = jsonobj2.getJSONArray("group_result");
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
				titleName = "Year";
				formName = "yearForm";
			}else if(i==1){			
				titleName = "Affiliation";
				formName = "afidForm";
				descriptionMapData = new HashMap<String, String>();
				for (int j = 0; j < arr.length(); j++) {
					if (j > 50) {
					}
					JSONObject o = arr.getJSONObject(j);
					String key = o.getString("key");
				}
				descriptionMapData = new HashMap<String, String>();
				Set<String> afidSet = new HashSet<String>();
				for (int j = 0; j < arr.length(); j++) {
					if (j > 50) {
					}
					JSONObject o = arr.getJSONObject(j);
					String key = o.getString("key");
					afidSet.add(key.trim());
				}
				descriptionMapData = ScopusTypeDao.getAffiliationNameDescription(affilationNameMap, affilationNameFreqMap, afidSet);
			}else if(i==2){
				titleName = "ASJC Code";
				formName = "asjcForm";
				descriptionMapData = DescriptionCode.getAsjcTypeKoreaDescription();
			}else if(i==3){
				titleName = "Source Title";
				formName = "sourceIdForm";
				descriptionMapData = new HashMap<String, String>();
					Set<String> sourceIDSet = new HashSet<String>();
					for (int j = 0; j < arr.length(); j++) {
						if (j > 50) {
						}
						JSONObject o = arr.getJSONObject(j);
						String key = o.getString("key");
						sourceIDSet.add(key.trim());
					}
					descriptionMapData = ScopusTypeDao.getSourceDescription(sourceTitleMap,
							sourceTitleFreqMap, sourceIDSet);
			}else if(i==4){
				titleName = "Country";
				formName = "countryForm";
				descriptionMapData = DescriptionCode.getCountryType();
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
				
				if (i == 3) {
					//Source ID 인경우.
					String sourceTitle = InfoStack.getValue(sourceTitleMap, sourceTitleFreqMap, key.trim());
					desc = sourceTitle == null ? key : sourceTitle;
				} else {
					if(descriptionMapData.containsKey(key.toLowerCase())){
						desc = descriptionMapData.get(key.toLowerCase());
					}
					if(descriptionMapData.containsKey(key.toUpperCase())){
						desc = descriptionMapData.get(key.toUpperCase());
					}
				}
				
				if(j==groupCount && arr.length() > groupCount){
					//continue;
					out.println("<tr><td colspan='2' style='padding:0px 0px 0px 5px;text-align: right;'><span id='morespanid_"+i+"' name=\"morespan_"+i+"\" style='cursor:pointer;'>more..</span></td></tr>");
						out.println("<tr width='100%'><td colspan='2' width='100%' ><table cellspacing='0' cellpadding='0' border='0' width='100%' id=\"morespan_"+i+"\" style='display:none'>");
				}
%>
					<tr  class="tipTipClass" title="<%=desc%>">
						<td style="padding:0px 0px 0px 5px;font-family:'맑은 고딕','Trebuchet MS'">
								<%=desc.length() > 14 ? desc.substring(0,14):desc %>
						</td>
						<td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(<%=freq%>)</td>
					</tr>
<%
				}  
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
    
   <form name="parameter" id="parameter" method="post">
    	<input type="hidden" name="se" value="<%=se%>" />
    	<input type="hidden" name="fl" value="<%=fl%>" />
    	<input type="hidden" name="sn" value="<%=sn%>" />
    	<input type="hidden" name="ln" value="<%=viewData %>" />
    	<input type="hidden" name="gr" value="<%=gr%>" />
    	<input type="hidden" name="ft" value="<%=ft%>" />
    	<input type="hidden" name="ud" value="<%=ud%>" />
    	<input type="hidden" name="searchTerm" value="<%=searchTerm%>" />
		<input type="hidden" name="searchRule" value="<%=searchRule %>" />
    	<input type="hidden" name="url" value="./searchAuthor.jsp"/>
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
	application.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE), sourceTitleMap);
	application.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ), sourceTitleFreqMap);
	}catch(Exception e){	
		e.printStackTrace();
	}
%>
