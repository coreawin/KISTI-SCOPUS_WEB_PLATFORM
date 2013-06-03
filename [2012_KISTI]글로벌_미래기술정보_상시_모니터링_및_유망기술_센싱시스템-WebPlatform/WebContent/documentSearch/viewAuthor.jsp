<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.web.db.bean.CitationBean"%>
<%@page import="kr.co.tqk.web.db.bean.ReferenceBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.CitationDao"%>
<%@page import="kr.co.tqk.web.db.dao.ReferenceDao"%>
<%@page import="kr.co.tqk.web.db.bean.AuthorInfoBean"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.web.db.dao.AuthorInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	String authorSeq = baseRequest.getParameter("authorSeq", "0");
	String authorID = baseRequest.getParameter("authorID", "0");

	HashSet<AuthorInfoBean> resultList = AuthorInfoDao.searchAuthorIDInfo(authorID);
	
	String authorName = null;
	String authorNameAddition = null;
	String afid = null;
	String dftid = null;
	String orgName = null;
	String countryCode = null;
	HashSet<String> eidSet = new HashSet<String>();
	for(AuthorInfoBean sdBean : resultList){
		authorName = sdBean.getAuthorName();
		if(!"".equals(sdBean.getDelegateAuthorName().trim()))
			authorNameAddition = sdBean.getDelegateAuthorName();
		if(!"".equals(sdBean.getAuthorID().trim()))
			authorID = sdBean.getAuthorID();
		if(!"".equals(sdBean.getAfid().trim()))
			afid = sdBean.getAfid();
		if(!"".equals(sdBean.getDftid().trim()))
			dftid = sdBean.getDftid();
		if(!"".equals(sdBean.getOrgName().trim()))
			orgName = sdBean.getOrgName();
		if(!"".equals(sdBean.getCountryCode().trim()))
			countryCode = sdBean.getCountryCode();
		eidSet.add(sdBean.getEid());
	}
	StringBuffer eidSearchRule = new StringBuffer();
	for(String e : eidSet){
		eidSearchRule.append(e);
		eidSearchRule.append(" ");
	}
	
	LinkedList<ReferenceBean> refList = ReferenceDao.getScopusReference(eidSet);
	StringBuffer refSB = new StringBuffer();
	for(ReferenceBean rb : refList){
		refSB.append(rb.getRefEid());
		refSB.append(" ");
	}
	
	LinkedList<CitationBean> citList = CitationDao.getScopusCitation(eidSet);
	StringBuffer citSB = new StringBuffer();
	for(CitationBean cb : citList){
		citSB.append(cb.getCitEid());
		citSB.append(" ");
	}
	
	Map<String, String> countryDescriptionMap = DescriptionCode.getCountryType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 저자 보기</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<script type="text/javascript">

function searchEID(){
	var form = document.getElementById("parameter");
	form.searchRule.value='se={eid:<%=eidSearchRule.toString()%>)}';
	form.command.value = "listEID";
	form.action="./catresult.jsp";
	form.submit();
}

function searchRefCit(type){
	var form = document.getElementById("parameter");
	if(type=='REFL'){
		if(<%=refSB.toString().trim().length() < 1 %>){
			alert("조회 가능한 참조 정보가 존재하지 않습니다.\n관련 데이터가 존재하지 않아 조회할 수 없습니다.");
			return
		}
		form.searchRule.value = 'se={eid:<%=refSB.toString().trim()%>}';
		form.command.value = "listEID";
	}else{
		if(<%=citSB.toString().trim().length() < 1 %>){
			alert("조회 가능한 인용 정보가 존재하지 않습니다.\n관련 데이터가 존재하지 않아 조회할 수 없습니다.");
			return
		}
		form.command.value = "listEID";
		form.searchRule.value = 'se={eid:<%=citSB.toString().trim()%>}';
	}
	form.action="./catresult.jsp";
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
			<% String menuTerm = "저자 검색 결과"; %>
	    		<%@include file="../common/quickSearch.jsp" %>
			</div>
			<!-- 
			<table class="search" border="0" cellpadding="0" cellspacing="0" style="margin:15px 0px 0px 15px;">
            	<tr>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_L.gif" /></td>
                    <td width="53%" align="left" class="tit">저자 검색 결과</td>
                 	<td width="47%" align="right" class="e-tit">Quick Search : <input type="" id="" class="input_txt" name="" maxlength="10" /> <input type="submit" value="Search" title="Search" alt="Search" />　</td>
                    <td valign="top"><img src="<%=contextPath %>/images/nn_search_bg_R.gif" /></td>
                </tr>
            </table>
             --> 
            </br>
            <div id="search_result">
            <table width="100%" class="Table12" border="0" summary="저자 검색 결과 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<caption>저자 검색 결과 테이블</caption>
                <tbody>
                	<tr>
                        <td colspan="2" class="txt3">Personal</td>
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">Name</td>
                        <td><%=authorName +" (" + (authorNameAddition==null?"":authorNameAddition) +")"%></td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Author ID</td>
                        <td><%=authorID %> <a href="https://www.scopus.com/authid/detail.url?authorId=<%=authorID%>" target="_blank"><img src="<%=contextPath %>/images/nn_search_arrow03.gif" border="0"/></a></td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Affiliation</td>
                        <td><%=orgName==null?"":orgName %></td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Country Code</td>
                        <td><%=countryCode==null?"": countryCode + " - " + UtilString.nullCkeck(countryDescriptionMap.get(countryCode))  %></td>     
                    </tr>
                    <tr>
                        <td colspan="2" class="txt3">Research</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Document</td>
                        <td class="txt5"><a href="javascript:searchEID();"><%=eidSet.size() %></a></td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">References</td>
                        <td class="txt5"><a href="javascript:searchRefCit('REFL');"><%=refList.size() %></a></td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Citations</td>
                        <td class="txt5"><a href="javascript:searchRefCit('CITL');"><%=citList.size() %></a></td>     
                    </tr>
                </tbody>
		    </table> 
            </div>      
 	 	</div>
    </div>
    <!--contents_area-->
    <form id="parameter" method="post">
    	<input type="hidden" name="searchRule"/>
    	<input type="hidden" name="command"/>
    	<input type="hidden" name="currentPage" value="1"/>
    </form>
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area--> 
</div>
</body>
</html>
