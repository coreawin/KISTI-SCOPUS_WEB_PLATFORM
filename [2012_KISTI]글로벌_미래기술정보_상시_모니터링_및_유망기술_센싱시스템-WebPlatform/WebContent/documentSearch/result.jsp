<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.SortedMap"%>
<%@page import="kr.co.tqk.web.db.bean.AuthorBean"%>
<%@page import="kr.co.tqk.web.db.bean.SearchResultDocumentBean"%>
<%@page import="kr.co.tqk.web.db.SearchDocument"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", 1200);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	String searchRule = baseRequest.getParameter("searchRule",null);
	String searchTerm = baseRequest.getParameter("searchTerm",null);
	System.out.println("searchRule " + searchRule);
	System.out.println("searchTerm " + searchTerm);
	
	LinkedList<SearchResultDocumentBean> resultList = SearchDocument.search(searchRule, searchTerm, currentPage, viewData);
	totalSize = SearchDocument.getTotalSearchResultCount();
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nano</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function goDocumentInfo(eid){
	var form = document.getElementById("viewDocumentParameterForm"); 
	form.eid.value = eid;
	form.action="./viewDocument.jsp";
	form.submit();
}

function goAuthorInfo(authorSeq){
	var form = document.getElementById("parameter");
	form.authorSeq.value = authorSeq;
	form.action="./viewAuthor.jsp";
	form.submit();
}


function searchRefCit(type, eid){
	var form = document.getElementById("parameter");
	if(type=='REFL'){
		form.searchRule.value="REFL("+eid+")";
	}else{
		form.searchRule.value="CITL("+eid+")";
	}
	form.currentPage.value="1";
	form.action="./result.jsp";
	form.submit();
}

function exportDoc(){
	var form = document.getElementById("parameter");
	form.action="./export.jsp";
	form.submit();
}

$(document).ready(function() {
	//문서가 준비되었을때
	//체크박스가 체크되면 모든 체크박스를 체크한다.
    $("#ckeckAll").click(function() {
        if ($("#ckeckAll:checked").length > 0) {
            $("input:checkbox:not(checked)").attr("checked", "checked");
            $("input:checkbox:disabled").attr("checked", "");
        } else {
            $("input:checkbox:checked").attr("checked", "");
        }
    });
});

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
    	<jsp:param value="<%=SUB_MENU_USER_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0" style="margin:15px 0px 0px 15px;">
            	<tr>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_L.gif" /></td>
                    <td width="53%" align="left" class="tit">논문 검색</td>
                 	<td width="47%" align="right" class="e-tit">Quick Search : <input type="" id="" class="input_txt" name="" maxlength="10" /> <input type="submit" value="Search" title="Search" alt="Search" /></td>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_R.gif" /></td>
                </tr>
            </table> 
			</div>

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
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="txt">Document Result : <%=NumberFormatUtil.getDecimalFormat(totalSize ) %></td>
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
                                                        <td><a href="#"><img src="<%=contextPath %>/images/nn_search_result_bt01.gif" /></a><a href="#"><img src="<%=contextPath %>/images/nn_search_result_bt02.gif" /></a><a href="#"><img src="<%=contextPath %>/images/nn_search_result_bt03.gif" /></a></td>
                                                        <td align="right">
                                                        	Sort by
                                                        	<select name="sortBy" id="sortBy">
                                                            	<option value="20">-　Date (Newest)　-</option>
                                                            	<option value="20">-　Date (Oldest)　-</option>
                                                            	<option value="40">-　Citations Count　-</option>
                                                            	<option value="40">-　Reference Count 　-</option>
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
                                                <th scope="col" width="10" style="padding:2px 2px 2px 2px;"><input name="ckeckAll" id="ckeckAll" type="checkbox" value="1" title="현재 페이지의 논문을 전체 선택합니다."/></th>
                                                <th scope="col" style="padding:2px 2px 2px 2px;">Document Title</th>
                                                <th scope="col" width="25%" style="padding:2px 2px 2px 2px;">Author Name</th>
                                                <th scope="col" width="65" style="padding:2px 2px 2px 2px;">Date</th>
                                                <th scope="col" width="65" style="padding:2px 2px 2px 2px;">References</th>
                                                <th scope="col" width="65" style="padding:2px 2px 2px 2px;">Citations</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
	String bgColor = "";
	for(SearchResultDocumentBean sdBean: resultList){
		if("".equals(bgColor)){
			bgColor = "bgcolor=\"#f4f8fa\"";
		}else{
			bgColor = "";
		}
		LinkedList<AuthorBean> authorBeanList = sdBean.getAuthorInfo();
		SortedMap<Integer, AuthorBean> authorRank = new TreeMap<Integer, AuthorBean>();
		for(AuthorBean ab : authorBeanList){
			authorRank.put(ab.getRanking(), ab);
		}
		StringBuffer authorSb = new StringBuffer();
		for(AuthorBean ab : authorBeanList){
			
		}
		for(int rank : authorRank.keySet()){
			AuthorBean ab = authorRank.get(rank);
			authorSb.append("<a href=\"javascript:goAuthorInfo('"+ab.getAuthorSeq()+"');\"><span class=\"txt3\">");
			authorSb.append(ab.getAuthorName());
			authorSb.append("</span></a>");
			authorSb.append(", ");
		}
		if(authorSb.length() > 0){
			authorSb.substring(0, authorSb.length()-2);
		}
%>                                        
                                            <tr <%=bgColor%>>
												<td width="10" scope="row" style="padding:5px 5px;"><input name="selectDoc" id="selectDoc" type="checkbox" value="1" /></td>
                                                <td style="padding:5px 5px; text-align:left;"><a href="./viewDocument.jsp?eid=<%=sdBean.getEid()%>"><span class="txt4"><%=sdBean.getTitle() %></a></td>
                                                <td style="padding:5px 5px; text-align:left;"><%=authorSb.toString() %></td>
                                                <td><%="null".equalsIgnoreCase(sdBean.getPublicationYear())?".":sdBean.getPublicationYear() %></td>
                                                <td style="color:#005eac;"><a href="javascript:searchRefCit('REFL','<%=sdBean.getEid()%>');"><%=sdBean.getRef_count() %></a></td>
                                                <td style="color:#005eac;"><a href="javascript:searchRefCit('CITL','<%=sdBean.getEid()%>');"><%=sdBean.getCit_count() %></a></td>
                                            </tr>
<%
	}
%>
                                        </tbody>
                                    </table>
                                    <br/>
											Display <select name="select" id="select">
							                        	<option value="20">-　20개씩 보기　-</option>
							                        	<option value="40">-　40개씩 보기　-</option>
							                        </select>
							                results per page.
                                    <jsp:include page="../common/paging.jsp" flush="true">
						           		<jsp:param value="result.jsp" name="url"/>
						           		<jsp:param value="<%=searchTerm %>" name="searchTerm"/>
						           		<jsp:param value="<%=searchRule %>" name="searchRule"/>
						           		<jsp:param value="<%=totalSize %>" name="totalSize"/>
						           		<jsp:param value="<%=currentPage %>" name="currentPage"/>
						           		<jsp:param value="<%=viewData %>" name="viewData"/>
						           		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
						           	</jsp:include>  
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
														<input type="button" value="Limit to" id="" name="" class="bt1"  onclick=""> <input type="button" value="Exclude" id="" name="" class="bt1"  onclick=""></td>
                                                    </tr>
                                         		</table></td>
                                        </tr>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Year</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Author Name</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">ASJC</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Source Title</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Keyword</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Affilation</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Country</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">Source Type</td>
                                                <td scope="col" class="tit1"><a href="#"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" alt="" /></a></td>
                                         </tr>
                                         <tr>
                                        	<td height="1"  colspan="2" bgcolor="#a5b8ff"></td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2011</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2010</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2009</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2008</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                            <tr>
                                                <td style="padding:0px 0px 0px 5px;"><input name="check1" id="check1" type="checkbox" value="1" />2007</td>
                                                <td style="color:#005eac; text-align:right; padding:0px 5px 0px 0px;">(4,900)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <table class="Table13_1" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td height="55" class="tit">
														<input type="button" value="Limit to" id="" name="" class="bt1"  onclick=""> <input type="button" value="Exclude" id="" name="" class="bt1"  onclick=""><br /></td>
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
 	 	</div>
    </div>
    <!--contents_area-->
    
    <form id="viewDocumentParameterForm" method="get">
    	<input type="hidden" name="eid"/>
    </form>
    <form id="parameter" method="post">
    	<input type="hidden" name="authorSeq"/>
    	<input type="hidden" name="searchTerm" value="<%=searchTerm %>" />
    	<input type="hidden" name="searchRule" value="<%=searchRule %>" />
    	<input type="hidden" name="url" value="result.jsp"/>
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
