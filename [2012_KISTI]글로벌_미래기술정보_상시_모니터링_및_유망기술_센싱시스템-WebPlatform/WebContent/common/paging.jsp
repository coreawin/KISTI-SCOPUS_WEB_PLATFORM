<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./common.jsp" %>
<%
	
	String url = baseRequest.getParameter("url",null);
	String searchAuthType = baseRequest.getParameter("searchAuthType", UserAuthEnum.AUTH_ALL.getAuth());
	
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize",0);
	int viewData = baseRequest.getInteger("viewData",10);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchText = baseRequest.getParameter("searchText", null);
	String searchRule = baseRequest.getParameter("searchRule", null);
	String command = baseRequest.getParameter("command", null);
	String sort = baseRequest.getParameter("sort", "desc");
	
	
	String orderColumn = baseRequest.getParameter("orderColumn", "ID");
	String orderType = baseRequest.getParameter("orderType", "desc");
	
	if(command!=null){
		if("listRef".equalsIgnoreCase(command) || "listCit".equalsIgnoreCase(command)){
			command = "listEID";
		}
	}
	
	String searchTerm=baseRequest.getParameter("searchTerm","");
	String divClass=baseRequest.getParameter("divClass","num1");
	
	int startPage = currentPage==1?1:((currentPage-1)/pagingSize)*pagingSize+1;
	int lastPage = totalSize / viewData;

	if(totalSize % viewData > 0 ){
		lastPage++;

	}
	int endPage = ((currentPage-1)/pagingSize)*pagingSize+pagingSize;
	
	if(endPage > lastPage){
		endPage = lastPage;
	} 
	
%>

<script language="JavaScript">

	function paging(currentPage){		
		var formName = document.pagingForm;
		formName.currentPage.value = currentPage;
		formName.action="<%=url%>";
		formName.submit();
	}
	
</script>
<div class="<%= divClass%>">
<%	
		if(totalSize!=0){
			if(lastPage > pagingSize ){
				out.println("<a href=\"javascript:paging('1');\">");
				out.println("<img src=\""+contextPath+"/images/nn_ar_left_01.gif\" />");
				out.println("</a> ");
				out.println("<a href=\"javascript:paging('"+((startPage-pagingSize)<0?1:(startPage-pagingSize))+"');\">");
				out.println("<img src=\""+contextPath+"/images/nn_ar_left.gif\" />");
				out.println("</a> | ");
			}
			
			for(int pageNum=startPage; pageNum<=endPage; pageNum++){
				if(currentPage == pageNum){
					out.println("<span class=\"now\">"+pageNum+"</span>");
					if(pageNum<lastPage){
						out.println(" | ");
					}
				}else if(pageNum < lastPage){
					out.println("<a href=\"javascript:paging('"+pageNum+"');\">");
					out.println(pageNum);
					out.println("</a>");
					
					if(pageNum==lastPage){
						out.println("");
					}
					else{
						out.println(" | ");
					}
				}else if(pageNum == lastPage){
					//System.out.println("3");
					out.println("<a href=\"javascript:paging('"+pageNum+"');\">");
					out.println(pageNum);
					out.println("</a>");
				}
			}
			if(lastPage > pagingSize && endPage < lastPage){
				out.println("<a href=\"javascript:paging('"+((endPage+1)>lastPage?lastPage:(endPage+1))+"');\">");	
				out.println("<img src=\""+contextPath+"/images/nn_ar_right.gif\" />");
				out.println("</a> ");
				out.println("<a href=\"javascript:paging('"+lastPage+"');\">");
				out.println("<img src=\""+contextPath+"/images/nn_ar_right_01.gif\" />");
				out.println("</a>");
			}
		}
%>
</div>
<form name="pagingForm" method="post">		
	<input type="hidden" name="url"/>
	<input type="hidden" name="searchAuthType" value="<%=searchAuthType%>"/>
	<input type="hidden" name="searchTerm" value="<%=searchTerm%>"/>
	<input type="hidden" name="searchRule" value="<%=searchRule%>"/>
	<input type="hidden" name="command" value="<%=command%>"/>
	<input type="hidden" name="currentPage"/>
	<input type="hidden" name="searchText" value="<%=searchText%>"/>
	<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
	<input type="hidden" name="viewData" value="<%=viewData%>"/>
	<input type="hidden" name="pagingSize"  value="<%=pagingSize%>"/>
	<input type="hidden" name="orderColumn" value="<%=orderColumn%>"/>
    <input type="hidden" name="orderType" value="<%=orderType%>" />
	<input type="hidden" value="<%=sort%>" name="sort"/>	
</form>
