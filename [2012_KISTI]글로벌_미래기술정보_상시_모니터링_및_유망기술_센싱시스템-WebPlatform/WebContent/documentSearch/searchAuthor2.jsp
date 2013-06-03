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
	
	String searchText = baseRequest.getParameter("searchText", "");
	String searchRule = baseRequest.getParameter("searchRule", "");
	
	LinkedList<AuthorSearchResultBean> asrBeanList = SearchDocument.searchAuthor(searchRule, currentPage, viewData);
	if(!"".equals(searchText)){
		totalSize = SearchDocument.getTotalSearchResultCount();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nano</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function search(){
	var form = document.getElementById("parameter");
	var searchText = form.searchText.value;
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
    
		<div id="content">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%" align="left" class="tit">저자 검색</td>
                    <td width="45%" align="right" class="e-tit"><!-- Quick Search : <input type="" id="" class="input_txt" name="" > <input type="submit" value="Search" title="Search" alt="Search"> --></td>
                </tr>
            </table> 
			</div>
			
            <div id="search_choice1">
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<form id="parameter" method="get">
    						<input type="hidden" name="searchRule"/>
	                    	<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블">
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt">
	                                	<strong style="text-align:left;">Author Name : </strong><input type="text" id="searchText" name="searchText" size="95%" value="<%= searchText%>" onkeypress="javascript:enterCheck();"/>
	                                	<!-- 
	                                	<input type="checkbox" id="exactMatchCheck" name="exactMatchCheck" title="Show exact matches only" style="text-align:right;" alt="Show exact matches only"/> Show exact matches only
	                                	 -->
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
       	  		 	<td height="10"></td>
   	  		 	</tr>
            </table> 
	 	 	</div>
	 	 	
	 	 	<div id="search_choice2">
<%
	if(!"".equalsIgnoreCase(searchText)){
%>	 	 	
			<table class="Table8" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table8_1" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="25" class="txt">"<%=searchText %>" search result : <%=totalSize %></td>
                           	</tr>
                        </table></td>
   	  		 	</tr>
            </table>
	 	 	</div>
            <div id="list">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5">
                            <caption>저자 list 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th style="padding:2px 2px 2px 2px;">Author ID</th>
                                    <th style="padding:2px 2px 2px 2px;">Author</th>
                                    <th width="65%" style="padding:2px 2px 2px 2px;">Affiliation</th>
                                    <th width="50" style="padding:2px 2px 2px 2px;">Country</th>
                                    <th width="50" style="padding:2px 2px 2px 2px;">Doc_cnt</th>
                                </tr>
                            </thead>
                            <tbody>
<%
	String bgColor = "";
	AuthorBean aBean = null;
	if(asrBeanList.size()==0 && !"".equalsIgnoreCase(searchText)){	
%>
								<tr <%=bgColor%>>
                                 	<td colspan="4"> <b><%=searchText %></b>로 검색한 데이터가 없습니다.</td>
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
                        </table></td>
             	</tr>
            </table>
<%
	}
%>
            </div>
            
            <jsp:include page="../common/paging.jsp" flush="true">
           		<jsp:param value="./searchAuthor.jsp" name="url"/>
           		<jsp:param value="<%=searchText %>" name="searchText"/>
           		<jsp:param value="<%=searchRule %>" name="searchRule"/>
           		<jsp:param value="<%=totalSize %>" name="totalSize"/>
           		<jsp:param value="<%=currentPage %>" name="currentPage"/>
           		<jsp:param value="<%=viewData %>" name="viewData"/>
           		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
           	</jsp:include>  
 	 	</div>
    </div>
    
    <form id="parameter" method="post">
    	<input type="hidden" name="authorSeq"/>
    	<input type="hidden" name="searchRule" value="<%=searchRule %>" />
    	<input type="hidden" name="url" value="./searchAuthor.jsp"/>
		<input type="hidden" name="currentPage" value="<%=currentPage%>"/>
		<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
		<input type="hidden" name="viewData" value="<%=viewData%>"/>
		<input type="hidden" name="pagingSize"  value="<%=pagingSize%>"/>	
    </form>
    
    <!--contents_area-->
   <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->  
</div>
</body>
</html>
