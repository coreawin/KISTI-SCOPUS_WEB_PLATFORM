<%@page import="kr.co.tqk.web.db.bean.AuthorBean"%>
<%@page import="kr.co.tqk.web.db.bean.AuthorSearchResultBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.SearchDocument"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>   
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", 0);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchTerm = baseRequest.getParameter("searchTerm", "");
	String searchRule = baseRequest.getParameter("searchRule", "");
	
	LinkedList<AuthorSearchResultBean> asrBeanList = SearchDocument.searchAuthor(searchRule, currentPage, viewData);
	if(!"".equals(searchTerm)){
		totalSize = SearchDocument.getTotalSearchResultCount();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 저자 검색</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function search(){
	var form = document.getElementById("parameter");
	var searchText = form.searchTerm.value;
	//var exactMatch = form.exactMatchCheck.checked;
	var exactMatch = false;
	
	if(searchText == ""){
		alert("검색어를 입력해 주세요.");
		form.searchText.focus();
		return;
	}else{
		form.searchRule.value = "AU-"+exactMatch+"("+searchText+")";
		form.action="./searchAuthor.jsp";
		form.submit();
	}
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
                    	<form id="parameter" method="get">
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
	String bgColor = "";
	AuthorBean aBean = null;
	if(asrBeanList.size()==0 && !"".equalsIgnoreCase(searchTerm)){	
%>
								<tr <%=bgColor%>>
                                 	<td colspan="4"> <b><%=searchTerm %></b>로 검색한 데이터가 없습니다.</td>
                       	 	 	</tr>
<%
	}
	for(AuthorSearchResultBean sdBean: asrBeanList){
		if("".equals(bgColor)){
			bgColor = "bgcolor=\"#f4f8fa\"";
		}else{
			bgColor = "";
		}
		aBean = sdBean.getAuthorBean();
%>
                       	 	 	<tr>
                                 	<td style="padding:5px 5px; text-align:left;"><a href="./viewAuthor.jsp?authorSeq=<%=aBean.getAuthorSeq()%>"><%=aBean.getAuthorID() %></a></td>
                                 	<td scope="row" style="padding:5px 5px; color:#005eac; text-align:left;"><a href="./viewAuthor.jsp?authorSeq=<%=aBean.getAuthorSeq()%>"><%=aBean.getAuthorName() + " - " + aBean.getDelegateAuthorName()%></a></td>
                                 	<td style="padding:5px 5px; text-align:left;"><%=sdBean.getOrgName() %></td>
                                    <td style="color:#2a87d5; text-align:center;"><%=sdBean.getCountryCode() %></td>
                                    <td style="color:#2a87d5; text-align:center;"><%=aBean.getEidCnt() %></td>
                       	 	 	</tr>
<%
	}
%>
                                        </tbody>
                                    </table>
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
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table6" id="asjcStaticsContents">
                                        <caption>검색 테이블</caption>
                                        <colgroup>
                                            <col width="80%" span="1">
                                        </colgroup>
                                        <thead>
                                            <tr bgcolor="#c0defa">
                                                <td scope="col" class="tit">ASJC</td>
                                                <td scope="col" class="tit1"><img src="<%=contextPath %>/images/nn_search_arrow01.gif" border="0" id="asjcFolding"/></td>
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
