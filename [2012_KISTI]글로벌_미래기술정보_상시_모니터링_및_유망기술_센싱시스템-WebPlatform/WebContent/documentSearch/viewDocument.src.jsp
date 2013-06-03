<%@page import="kr.co.topquadrant.util.AuthorNameCleansing"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.web.db.bean.ScopusIndexKeywordBean"%>
<%@page import="kr.co.tqk.web.db.dao.CitationDao"%>
<%@page import="kr.co.tqk.web.db.bean.CitationBean"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.web.db.bean.ReferenceBean"%>
<%@page import="kr.co.tqk.web.db.bean.ScopusSourceInfoBean"%>
<%@page import="kr.co.tqk.web.db.bean.CorrespondAuthorBean"%>
<%@page import="kr.co.tqk.web.db.bean.AuthorBean"%>
<%@page import="kr.co.tqk.web.db.bean.AffilationBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="kr.co.tqk.web.db.bean.ScopusASJCBean"%>
<%@page import="kr.co.tqk.web.db.bean.ScopusAuthorKeywordBean"%>
<%@page import="kr.co.tqk.web.db.bean.ScopusDocumentBean"%>
<%@page import="kr.co.tqk.web.db.dao.DocumentInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
try{
	String eid = baseRequest.getParameter("eid", null);
	if(eid==null){
		out.println();
		return;
	}
	
	DocumentInfoDao did = new DocumentInfoDao(eid);
	ScopusDocumentBean sdBean = did.getScopusDocument();
	if(sdBean==null){
		sdBean = new ScopusDocumentBean();
	}
	ScopusAuthorKeywordBean sakBean = did.getScopusAuthorKeyword();
	ScopusASJCBean asjcBean = did.getScopusASJC();
	LinkedList<AffilationBean> affilationList = did.getScopusAffilationAndAuthorInfo();
	CorrespondAuthorBean  corresBean = did.getScopusCorrespondAuthor();
	ScopusSourceInfoBean ssiBean = did.getScopusSourceInfo(sdBean.getSourceID());
	ScopusIndexKeywordBean sikBean = did.getScopusIndexKeyword();
	
	LinkedList<ReferenceBean> refList = did.getScopusReference();
	
	
	StringBuffer refSB = new StringBuffer();
	for(ReferenceBean rb : refList){
		refSB.append(rb.getRefEid());
		refSB.append(" ");
	}
	
	LinkedList<CitationBean> citList = CitationDao.getScopusCitation(eid);
	StringBuffer citSB = new StringBuffer();
	for(CitationBean cb : citList){
		citSB.append(cb.getCitEid());
		citSB.append(" ");
	}
	
	Map<String, String> countryDescriptionMap = DescriptionCode.getCountryType();
	countryDescriptionMap.put("", "");
	Map<String, String> asjcKorDescriptionMap = DescriptionCode.getAsjcTypeKoreaDescription();
	Map<String, String> citationTypeMap = DescriptionCode.getCitationType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 논문 보기</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<script type="text/javascript">


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
		form.searchRule.value = 'se={eid:<%=citSB.toString().trim()%>}';
		form.command.value = "listEID";
	}
	form.action="./catresult.jsp";
	form.submit();
}

function searchAuthorInfo(authorSeq, authorID){
	var form = document.getElementById("parameter");
	form.authorSeq.value=authorSeq;
	form.authorID.value=authorID;
	form.action="./viewAuthor.jsp";
	form.submit();
}

$(document).ready(function() {
	$(".tipTipClass").tipTip({maxWidth: "auto", edgeOffset: 10});
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
    	<jsp:param value="<%=SUB_MENU_DOCUMENT_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
			<% String menuTerm = "View Scopus Document"; %>
	    		<%@include file="../common/quickSearch.jsp" %>
			</div>
            
            <div id="search_result">
            <!-- 
			<table class="Table1_2" border="0" cellpadding="0" cellspacing="0" align="center">
            	<tr>
                    <td colspan="2" height="35" align="right">
                        <div id="submit">
                        	<button type="submit" id="" name="" class="bt2" >Download</button>
                        </div></td>
                </tr>
            </table>
             -->
            <%= "".equals(sdBean.getEid().trim())?"<h2 align='center'>데이터가 존재하지 않습니다.</h2><h3 align='center'>(현재 SCOPUS 데이터를 Update하는 중 이거나 데이터가 누락되었을 수 있습니다. 관리자에게 문의하세요)</h3>":"" %>
            <table width="100%" class="Table12" border="0" summary="검색 결과 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<caption>검색 결과 테이블</caption>
                <tbody>
                 	<tr>
                        <td colspan="5" class="txt3_1" style="text-align: left">Document Info </td>
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">EID</td>
                        <td colspan="4"><strong><%=sdBean.getEid() %></strong></td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">Title</td>
                        <td colspan="4"><strong><%=sdBean.getTitle() %></strong>&nbsp;</td>                                    
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Abstract</td>
                        <td colspan="4"><%=sdBean.getAbs() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Year</td>
                        <td colspan="4"><%=sdBean.getPublicationYear() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">DOI</td>
                        <td colspan="4"><%=sdBean.getDOI() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Author Keyword</td>
                        <td colspan="4">
                        <%
                        	for(String keyword : sakBean.getKeywordList()){
                        		out.println(keyword);
                        		out.println("; " );
                        	}
                        
                        %>&nbsp;
                        </td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Index Keyword</td>
                        <td colspan="4">
                        <%
                        	for(String type : sikBean.getIndexKeywordMap().keySet()){
                        		//out.println(type + " : <br><small>");
                        		for(String keyword : sikBean.getIndexKeywordMap().get(type)){
                        			//out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	                        		out.println(keyword +" ; ");
                        		}
                        		//out.println("</small>");
                        	}
                        
                        %>&nbsp;
                        </td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Citations</td>
                        <td colspan="4" class="txt5"><a href="javascript:searchRefCit('CITL');"><%=sdBean.getCitCount() %></a></td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Referenses</td>
                        <td colspan="4" class="txt5"><a href="javascript:searchRefCit('REFL');"><%=sdBean.getRefCount() %></a></td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Citation Type</td>
                        <td colspan="4" ><%="".equals(sdBean.getCitationType())?"":sdBean.getCitationType().toLowerCase() +" - " %> <%=UtilString.nullCkeck(citationTypeMap.get(sdBean.getCitationType().toLowerCase())) %></td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">ASJC</td>
                        <td colspan="4">
                        <%
                        LinkedHashMap<String, String> asjcMap = asjcBean.getAsjcSet();
                        for(String asjcCode : asjcMap.keySet()){
                        	out.println("<span class='tipTipClass' title='"+asjcCode +" : " + asjcKorDescriptionMap.get(asjcCode)+"'>");
							out.println("("+ asjcCode + ") " + asjcMap.get(asjcCode) + "; ");                        	
                        	out.println("</span>");
                        }
                        %>
                        </td>     
                    </tr>
                </tbody>
		    </table>
            
            <table width="100%" class="Table12" border="0" summary="교신저자 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<caption>교신저자 테이블</caption>
                <tbody>
                    <tr>
                        <td colspan="4" class="txt3_1" style="text-align: left">Correspond Author Info</td>
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">Author Name</td>
                        <td colspan="3"><%=corresBean==null?"":corresBean.getAuthor().getAuthorName() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Country_code</td>
                        <td colspan="3"><%=corresBean==null?"":corresBean.getCountryCode() %>&nbsp;<%=corresBean==null?"":" - " + UtilString.nullCkeck(countryDescriptionMap.get(corresBean.getCountryCode()))  %></td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Email</td>
                        <td colspan="3"><%=corresBean==null?"":corresBean.getAuthor().getEmail() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Organization</td>
                        <td colspan="3"><%=corresBean==null?"":corresBean.getOrganization() %>&nbsp;</td>     
                    </tr>
                </tbody>
		    </table>
            <table width="100%" class="Table12" border="0" summary="출처정보 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<caption>출처정보 테이블</caption>
                <tbody>
                    <tr>
                        <td colspan="4" class="txt3_1" style="text-align: left">Source Info</td>
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">Source id</td>
                        <td colspan="3"><%=sdBean.getSourceID() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" width="120" style="padding:5px 10px;text-align:right;">Source</td>
                        <td colspan="3"><%=ssiBean.getTitle() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Volumn</td>
                        <td colspan="3"><%=sdBean.getVolumn() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Issue</td>
                        <td colspan="3"><%=sdBean.getIssue() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Page</td>
                        <td colspan="3"><%=sdBean.getPage() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Source_type</td>
                        <td colspan="3"><%=ssiBean.getType() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">Publisher_name</td>
                        <td colspan="3"><%=ssiBean.getPublisherName() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">country</td>
                        <td colspan="3"><%=ssiBean.getCountry() %>&nbsp;</td>     
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">P_ISSN</td>
                        <td colspan="3"><%=ssiBean.getPissn() %>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="txt4" style="padding:5px 10px;text-align:right;">E_ISSN</td>
                        <td colspan="3"><%=ssiBean.getEissn() %>&nbsp;</td>     
                    </tr>
                </tbody>
		    </table>
		     <table width="100%" class="Table12" border="0" summary="저자정보 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
             	<caption>Author Info</caption>
                <tbody>
                    <tr>
                        <td colspan="5" class="txt3_1" style="text-align: left">Author Infor</td>
                    </tr>
                    <tr>
                        <td class="txt4">Rank</td>
                        <td class="txt4">Author Name</td>
                        <td class="txt4">E-Mail</td>                                    
                        <td class="txt4">Country</td>
                        <td class="txt4">Organization</td>
                    </tr>
					<%
						String bgColor = "#f4f8fa";
						for(AffilationBean e :affilationList){
							if("".equals(bgColor)){
								bgColor = "bgcolor=\"#f4f8fa\"";
							}else{
								bgColor = "";
							}
							boolean newAffilation = true;
							String rowspan = e.getAuthorList().size()==0?"1":e.getAuthorList().size() + "";
					%>
                    <tr <%=bgColor%>>
                     <%
                     		for(AuthorBean abe : e.getAuthorList()){
                     			String spanF = "";
                     			String spanL = "";
                     			if(!newAffilation){
                     				out.println("<tr "+bgColor+">");
                     			}
                     			if(abe.getRanking()==1 || abe.getRanking()==2 || abe.getRanking()==3){
                     				spanF = "<B>";
                     				spanL = "</B>";
                     			}
					%>
		                        <td width="60" class="txt6"><%=spanF%><%=abe.getRanking() %><%=spanL%></td>
		                        <td style="padding:5px 5px; text-align:left;" width="170" class="txt5_1"><%=spanF%><a href="javascript:searchAuthorInfo('<%=abe.getAuthorSeq()%>','<%=abe.getAuthorID() %>');"><%=AuthorNameCleansing.cleansing(abe.getAuthorName()) %> : <%="null".equalsIgnoreCase(abe.getDelegateAuthorName())?" ":abe.getDelegateAuthorName() %></a><%=spanL%></td>
		                        <td style="padding:5px 5px; text-align:left;" width="170" class="txt6"><%="null".equalsIgnoreCase(abe.getEmail())?" ":abe.getEmail() %>&nbsp;</td>                                    
					<%          
                     			if(newAffilation){
					%>
		                        <td width="50" rowspan="<%=rowspan %>" class="txt6 tipTipClass" title="<%=countryDescriptionMap.get(e.getCountryCode())%>"><%=e.getCountryCode() %>&nbsp;</td>
		                        <td rowspan="<%=rowspan %>" class="txt5_1" style="text-align:left;">[<%=e.getAfid()%>] <%=e.getOrgName() %>&nbsp;</td>
					<%                     				
                     			}
									out.println("</tr>");
								newAffilation = false;
                     		}
                     %>   
					<%							
						}
					%>                    
                </tbody>
            </table>
            <table width="100%" class="Table12" border="0" summary="참고문헌 테이블" cellpadding="0" cellspacing="0" style="margin-left:15px">
            	<caption>참고문헌 테이블</caption>
                <tbody>
                    <tr>
                        <td colspan="4" class="txt3_1" style="text-align: left">References Info (<%=refList.size() %>)</td>
                    </tr>
				<%
					int rBeanIndex = 1;
					for(ReferenceBean rBean : refList){
						ScopusDocumentBean sdbRBean = rBean.getDocumentBean();
						String rPage = rBean.getFirstPage() +"-" + rBean.getLastPage();
						String rYear = rBean.getPublicationYear();
						String rTitle = rBean.getTitle();
						String rIssue = rBean.getIssue();
						String rVolumn = rBean.getVolumn();
						String doi = "";
						if(sdbRBean!=null){
							rPage = sdbRBean.getPage();
							rYear = sdbRBean.getPublicationYear();
							if("".equals(rTitle.trim())){
								rTitle = sdbRBean.getTitle();
							}
							rIssue = sdbRBean.getIssue();
							rVolumn = sdbRBean.getVolumn();
							doi = "null".equals(sdbRBean.getDOI())?"":sdbRBean.getDOI() ;
						}
				%>
                    <tr>
                    	<td class="txt4" width="40"><%=rBeanIndex++ %></td>
                     	<td colspan="3">
                     		<small>[<%=rBean.getRefEid()%>]</small>
                     	<%
                     		if(sdbRBean!=null){
                     	%>
                     		<a href="./viewDocument.jsp?eid=<%=rBean.getRefEid()%>">
	                     		<%=rTitle %>
                     		</a>
						<%
                     		}else{
                     			out.println("<a href=\"https://www.scopus.com/record/display.url?eid=2-s2.0-"+rBean.getRefEid()+"&origin=resultslist\" target=\"_blank\">");
                     			out.println(rTitle);
                     			out.println("</a>");
                     		}
						%>                     		
                     		<br />
                     		(<%=rYear %>) <%=rBean.getSourceTitle() %>, <%=rIssue %> (<%=rVolumn %>), pp.<%=rPage %> <br/> 
                     		<%=doi %>
                     	</td>     
                    </tr>
				<%						
						
					}
				%>                    
                </tbody>
		    </table>
		   
            </div><br />      
 	 	</div>
    </div>
    <!--contents_area-->
     <form id="parameter" method="post">
    	<input type="hidden" name="searchRule"/>
    	<input type="hidden" name="authorSeq"/>
    	<input type="hidden" name="command"/>
    	<input type="hidden" name="authorID"/>
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