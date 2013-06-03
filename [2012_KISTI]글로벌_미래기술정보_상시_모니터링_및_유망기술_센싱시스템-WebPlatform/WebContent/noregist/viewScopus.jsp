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
<%@include file="../common/common.jsp" %>
<%
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
<style type="text/css">
	h1, h2, h3, h4, h5, h6 {font-family:Arial Unicode MS, Arial,'Verdana', 'Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande";}
	.scopus_hr hr {display:'';}
	.scopus_color_deepskyblue {color:dodgerblue ;}
	.scopus_super {font-family:Arial Unicode MS, Arial,'Verdana','Arial', 'Verdana', 'Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:10px; vertical-align: super;}
	.scopus_title {font-family:Arial Unicode MS, Arial,'Arial', 'Verdana', 'Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:20px; font-weight: bold; color: #0156AA; }
	.scopus_subtitle {font-family:Arial Unicode MS, Arial,'Arial', 'Verdana', 'Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:16px; color:dimgray ; }
	.scopus_h3 {font-family:Arial Unicode MS, Arial,'Verdana','Arial', 'Verdana', 'Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:12px; font-weight: normal; }
	.scopus_description_title {font-family:Arial Unicode MS, Arial, 'Arial', 'Verdana','Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:12px; font-weight: bold; color:#333333}
	.scopus_description {font-family:Arial Unicode MS, Arial,'Verdana', 'Arial', 'Verdana','Helvetica', 'sans-serif', "Malgun Gothic" "맑은 고딕", "AppleGothic", "Lucida Grande"; font-size:11px; font-weight: normal;}
	a:link, a:visited  { color:dodgerblue; text-decoration:none; }
	a:hover, a:active  { color:dodgerblue; text-decoration:none; }
</style>
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
    <jsp:include page="./topAreaNoLink.jsp">
    	<jsp:param value="false" name="showMenu"/>
    </jsp:include>
    <br>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content2">
        
	    	<div id="search">
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
            
            <table class='sdBase' width="100%" border="0" summary="검색 결과 테이블" cellpadding="0" cellspacing="0" width="960" style="margin-left:20px; margin-right: -20px">
            	<tr height="30">
            		<td>
						<a href="javascript:history.back(-1);"><span title="Back to results" class="padding0">Back to results</span></a>
						<br>
						<%
							if(!"".equalsIgnoreCase(sdBean.getDOI().trim())){
						%>
							<a href="http://dx.doi.org/<%=sdBean.getDOI()%>" target="_blank"><img src="../images/doi.png" border="0" height="15"/></a>
						<%
							}
						%>
						</br>
	            		<hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			
            			<span style="margin-right: 50px;">
            				<div class="scopus_h3 scopus_color_deepskyblue"><%=ssiBean.getTitle()==null?"":ssiBean.getTitle() %></div></span>
						
						<div class="scopus_description">
							<%=sdBean.getVolumn()==null?"":"Volumn " + sdBean.getVolumn() + ", " %>
							<%=sdBean.getIssue()==null?"":"Issue " + sdBean.getIssue() + ", " %>
							<%=sdBean.getPublicationYear()==null?"":sdBean.getPublicationYear() + ", " %>
							<%=sdBean.getPage()==null?"":"Pages " + sdBean.getPage() %>
						</div>
						<hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			<div class="scopus_title"">
            				<%=sdBean.getTitle()==null?"":sdBean.getTitle() %>
						</div>
						<%
							int affiliactionCnt = 0;
							Map<String, String> affiliationAlphabet = new HashMap<String, String>();
							LinkedHashMap<String, String> authorAlphabet = new LinkedHashMap<String, String>();
							for(AffilationBean e :affilationList){
								String alph = null;
								if(!affiliationAlphabet.containsKey(e.getAfid() + e.getDftid())){
									alph = DescriptionCode.ALPHABET[affiliactionCnt++];
									affiliationAlphabet.put(e.getAfid() + e.getDftid(), alph);
								}else{
									alph = affiliationAlphabet.get(e.getAfid() + e.getDftid());
								}
								for(AuthorBean bean : e.getAuthorList()){
									if(authorAlphabet.containsKey(bean.getAuthorID())){
										String tm = authorAlphabet.get(bean.getAuthorID());
										alph = tm + alph;
									}
									authorAlphabet.put(bean.getAuthorID(), alph);
								}
							}
							out.println("<p>");
							for(AffilationBean e :affilationList){
								for(AuthorBean bean : e.getAuthorList()){
									if(authorAlphabet.containsKey(bean.getAuthorID())){
										out.println("<span class='scopus_h3 scopus_color_deepskyblue'>");
										out.println("<a href=\"javascript:searchAuthorInfo('"+bean.getAuthorSeq()+"','"+bean.getAuthorID()+"')\">");
										out.println(AuthorNameCleansing.cleansing(bean.getAuthorName()));
										out.println("</a></span>");
										out.println("<span class='scopus_super'>");
										out.println(authorAlphabet.remove(bean.getAuthorID()));
										out.println("</span>");
										if(!"".equals(bean.getEmail().trim())){
											out.println("<a href=\"mailto:"+bean.getEmail().trim()+"\">");
											out.println("<img src=\"../images/scopusView/mailclosed.png\" width='12' height=12'>");
											out.println("</a>");
										}
										if(corresBean!=null){
											if(corresBean.getAuthor()!=null){
												if(corresBean.getAuthor().getAuthorName()!=null && bean.getAuthorName()!=null){
													if(corresBean.getAuthor().getAuthorName().trim().equalsIgnoreCase(bean.getAuthorName().trim())){
														out.println("<img src=\"../images/scopusView/user.png\" width='12' height=12' title='Correspond Author'");
														out.println(",&nbsp;&nbsp;");
													}
												}
											}
										}
										out.println(",&nbsp;&nbsp;");
									}
								}
							}
							out.println("</p>");
							for(AffilationBean e :affilationList){
								String affiliation = e.getDelegateOrgName();
								String cc = e.getCountryCode();
								out.println("<div>");
								out.println("<span class='scopus_super'>");
								out.println(affiliationAlphabet.get(e.getAfid() + e.getDftid()));
								out.println("</span> ");
								out.println(" <span class='scopus_description'>");
								out.println(affiliation);
								out.println(", ");
								out.println(cc==null?"":DescriptionCode.getCountryType().get(cc));
								out.println("</span>");
								out.println("</div>");
							}
						%>
						<br>
						<hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			<div class="scopus_subtitle"">Author keywords</div><p></p>
						<div class="" style="margin-left: 100"> 
							<%
	                        	for(String keyword : sakBean.getKeywordList()){
	                        		out.println(keyword);
	                        		out.println("; " );
	                        	}
								if(sakBean.getKeywordList().size()==0){
									out.println("[No Author keywords available]");
								}
	                        %>
                        </div>
                        <hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			<div class="scopus_subtitle"">Indexed keywords</div><p></p>
						<div class="" style="margin-left: 100"> 
							 <%
	                        	for(String type : sikBean.getIndexKeywordMap().keySet()){
	                        		for(String keyword : sikBean.getIndexKeywordMap().get(type)){
		                        		out.println(keyword +" ; ");
	                        		}
	                        	}
								 if(sikBean.getIndexKeywordMap().size()==0){
									out.println("[No Indexed keywords available]");
								}
	                        %>
                        </div>
                        <hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			<span class="scopus_description_title"">PISSN</span>: <span class="scopus_description"><%=ssiBean.getPissn() %></span>&nbsp;&nbsp;&nbsp;&nbsp;
            			<span class="scopus_description_title"">EISSN</span>: <span class="scopus_description"><%=ssiBean.getEissn() %></span>&nbsp;&nbsp;&nbsp;&nbsp;
            			<span class="scopus_description_title"">Source Type</span>: <span class="scopus_description"><%=ssiBean.getType() %></span>&nbsp;&nbsp;&nbsp;&nbsp; <br>
            			
            			<!-- <span class="scopus_description_title"">Original language</span>: <span class="scopus_description"><%=ssiBean.getEissn() %></span>&nbsp;&nbsp;&nbsp;&nbsp; -->
            			<span class="scopus_description_title"">DOI</span>: <span class="scopus_description"><%=sdBean.getDOI() %></span>&nbsp;&nbsp;&nbsp;&nbsp;
            			<span class="scopus_description_title"">Document Type</span>: <span class="scopus_description"><%="".equals(sdBean.getCitationType())?"":UtilString.nullCkeck(citationTypeMap.get(sdBean.getCitationType().toLowerCase()))%> </span>
            			<hr></hr>
            		</td>
            	</tr>
            	<tr>
            		<td>
            			<p>
            			<div class="scopus_subtitle"">References (<%=refList.size() %>)</div>
            			</p>
            			<p>
				            <table width="100%" border="0" cellpadding="0" cellspacing="0">
				                <tbody>
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
											rIssue = sdbRBean.getIssue();
											rVolumn = sdbRBean.getVolumn();
											doi = "null".equals(sdbRBean.getDOI())?"":sdbRBean.getDOI() ;
										}
										if("".equals(rTitle.trim())){
											rTitle = rBean.getText();
										}
								%>
				                    <tr>
				                    	<td height="60" width="40" valign="top"><span class="scopus_h3"><%=rBeanIndex++ %></span></td>
				                     	<td colspan="3" valign="top" style="line-height:2.3em">
				                     	<%
				                     		if(sdbRBean!=null){
				                     	%>
				                     		<a href="./viewScopus.jsp?eid=<%=rBean.getRefEid()%>">
					                     		<span class="scopus_h3"><%=rTitle %></span>
				                     		</a>
										<%
				                     		}else{
				                     			out.println("<span class=\"scopus_h3 scopus_color_deepskyblue\">");
				                     			out.println("<a href=\"https://www.scopus.com/record/display.url?eid=2-s2.0-"+rBean.getRefEid()+"&origin=resultslist\" target=\"_blank\">");
				                     			out.println(rTitle);
				                     			out.println("</a>");
				                     			out.println("</span>");
				                     		}
										%>                     		
				                     		<br />
				                     		<span class="scopus_description">
				                     			(<%=rYear %>) 
				                     			<i><%=rBean.getSourceTitle() %></i>, 
				                     			<%="".equals(rIssue.trim())?"":rIssue %>
				                     			<%="".equals(rVolumn.trim())?"":"("+rVolumn+")," %> 
				                     			<%=rPage.trim().length() < 2?"":"pp. "+rPage %> 
				                     		</span><br/> 
				                     		<%=doi %>
				                     	</td>     
				                    </tr>
								<%						
										
									}
								%>                    
				                </tbody>
						    </table>            			
            			</p>
            			<hr></hr>
            		</td>
            	</tr>
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
    <jsp:include page="./bottomArea.jsp"/>
    <!--footer_area-->   
</div>

</body>
</html>
