<%@page import="java.util.LinkedHashSet"%>
<%@page import="kr.co.tqk.web.util.MapUtil"%>
<%@page import="java.util.SortedMap"%>
<%@page import="kr.co.tqk.analysis.report.DocumentBean"%>
<%@page import="kr.co.tqk.analysis.report.ReportBean"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.analysis.report.GetReportData"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterRegistBean"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterDataBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
try{
	
	final String SESSION_CLUSTER_SEQ = userBean.getId() + "CLUSTER_SEQ";
	final String SESSION_CLUSTER_DATA = userBean.getId() + "CLUSTER_DATA";
	
	
	int selectSeq = baseRequest.getInteger("selectSeq", 21);
	String clusterKey = baseRequest.getParameter("clusterKey", null);
	LinkedList<ClusterDataBean> cdbList = null;
	int selectClusterDataSeq = -1;
	String selectClusterIsDel = ClusterDataBean.ISDEL_TYPE_N;
	if(selectSeq == -1){
		LinkedList<ClusterRegistBean> crbList = ClusterDao.selectClusterRegiAll(userBean.getId());
		selectSeq = crbList.get(0).getSeq();
	}else{
		if(session.getAttribute(SESSION_CLUSTER_SEQ)==null){
			session.setAttribute(SESSION_CLUSTER_SEQ, selectSeq);
		}
		
		int sessionClusterKey = (Integer)session.getAttribute(SESSION_CLUSTER_SEQ);
		if(selectSeq == sessionClusterKey){
			cdbList = (LinkedList<ClusterDataBean>)session.getAttribute(SESSION_CLUSTER_DATA);
		}
	}
	if(cdbList == null){
		cdbList = ClusterDao.selectClusterDataAll(selectSeq);
		session.setAttribute(SESSION_CLUSTER_SEQ, selectSeq);
		session.setAttribute(SESSION_CLUSTER_DATA, cdbList);
	}

%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nano</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.simplemodal.1.4.1.min.js"></script>
<script type="text/javascript">
function viewReport(){
	var form = document.getElementById("clusterReportForm");
	if(form.clusterKey){
		//$('#report').html("<center><img src=\"../images/writeBook.gif\"/></center>");
		form.action = "./clusterReport.jsp";
		form.submit();
	}else{
		alert("등록된 분석식이 없어 보고서 생성을 할수 없습니다.");
		return;
	}
}

function deleteClusterKey(){
	var form = document.getElementById("clusterReportForm");
	if(form.clusterKey){
		if(form.clusterKey.value!=-1){
			if(confirm(form.clusterKey.value + " 를 정말 삭제하시겠습니까? ")){
				form.pageUrl.value= "./clusterReport.jsp";
				form.action = "./clusterDataDeleteProc.jsp";
				form.submit();
			}
		}else{
			alert("Select Cluster No please.");
			return;
		}
	}else{
		alert("등록된 분석식이 없습니다.");
		return;
	}
}

function modifyIsDel(seq, value){
	var form = document.getElementById("clusterReportForm");
	if(form.clusterKey){
		if(form.clusterKey.value!=-1){
			if(confirm(form.clusterKey.value + " 를 관심 클러스터로 표시하겠습니까? ")){
				form.pageUrl.value= "./clusterReport.jsp";
				form.isDel.value= value;
				form.action = "./clusterDataIsDelModifyProc.jsp";
				form.submit();
			}
		}else{
			alert("Select Cluster No please.");
			return;
		}
	}else{
		alert("등록된 분석식이 없습니다.");
		return;
	}
}

function wordExport(){		
	var tbName = "report";
	var tbody = $('#' + tbName) ;		
	var form=document.getElementById("parameter");		
	form.action="<%=request.getContextPath()%>/rtfservlet";
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
    	<jsp:param value="<%=TOP_MENU_CLUSTER %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_CLUSTER_REPORT %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%" align="left" class="tit">분석 보고서</td>
                    <td width="45%" align="right"></td>
                </tr>
            </table> 
			</div>
			
			<div id="search_choice1">
            <form method="get" id="clusterReportForm" name="clusterReportForm">
            	<input type="hidden" name="selectSeq" value="<%=selectSeq %>" />
            	<input type="hidden" name="pageUrl"/>
            	<input type="hidden" name="isDel"/>
            	<input type="hidden" name="selectClusterDataSeq" value="<%=selectClusterDataSeq%>"/>
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
	                    	<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center">
	                            <tr>
	                                <td width="140" bgcolor="#d9dce1" class="txt1"  style="padding:5px 10px;text-align:right;"><strong>Select Cluster No.</strong></td>
	                                <td width="800" bgcolor="#d9dce1">
<%
	if(cdbList.size()!=0){
%>	                                
	                                	<select id="clusterKey" name="clusterKey">
	                                		<option value="-1">====== Cluster No. ======</option>
<%
		HashSet<String> set = null;
		for(ClusterDataBean cdbBean : cdbList){
			set = MapUtil.converHashSet(cdbBean.getEids().split(","));
			String optionClass = "";
			if(ClusterDataBean.ISDEL_TYPE_T.equalsIgnoreCase(cdbBean.getIsdel())){
				optionClass = "class=\"c1\" ";
			}
			if(cdbBean.getClusterKey().equalsIgnoreCase(clusterKey)){
				selectClusterIsDel = cdbBean.getIsdel();
				selectClusterDataSeq = cdbBean.getSeq();
				out.println("<option "+optionClass+" selected=\"selected\" value = \""+cdbBean.getClusterKey()+"\">");
			}else{
				out.println("<option "+optionClass+" value = \""+cdbBean.getClusterKey()+"\">");
			}
			String isDel = cdbBean.getIsdel();
			if(isDel.equals(ClusterDataBean.ISDEL_TYPE_N)){
				out.println("[" + cdbBean.getClusterKey() + "]\t핵심 논문수 : " + set.size() +" 개");
			}else{
				out.println("[" + cdbBean.getClusterKey() + "]\t핵심 논문수 : " + set.size() +" 개");
			}
			out.println("</option>");
		}
%>
	                                	</select>
<%
	}else{
		out.println("등록된 분석이 없습니다.");
	}
%>	                                	
	                                </td>
	                            </tr>
	                  		</table>
                  		</td>
             	</tr>
             	<tr>
                    <td class="txt1" style="padding:5px 10px;text-align:right;">
<%
						if(clusterKey!=null){
%>                    
                    	<button type="button" onclick="javascript:deleteClusterKey();" class="bt5" >현재의 Cluster No.<%=clusterKey!=null?" ["+clusterKey+"] ":"" %>삭제하기</button>
                    	&nbsp;
<%
				if(ClusterDataBean.ISDEL_TYPE_T.equalsIgnoreCase(selectClusterIsDel)){
%>
<!-- 
                    	<button type="button" onclick="javascript:modifyIsDel('<%=selectClusterDataSeq%>', '<%=ClusterDataBean.ISDEL_TYPE_N %>');" class="bt5" >주요 관심 클러스터  표시 제거</button>
                    	&nbsp;
                    	 -->
<%					
				}else{
%>                    
<!-- 
                    	<button type="button" onclick="javascript:modifyIsDel('<%=selectClusterDataSeq%>', '<%=ClusterDataBean.ISDEL_TYPE_T %>');" class="bt5" >주요 관심 클러스터로 표시</button>
                    	&nbsp;
                    	 -->
<%
				}
%>	
                    	<button type="button" onclick="javascript:wordExport();" class="bt5" >보고서 MS-Word 출력</button>
<%
						}
%>                    	
                    	&nbsp;
                    	<button type="button" onclick="javascript:viewReport();" class="bt5" >보고서 생성</button>
                    </td>
                </tr>
            </table>
            </form> 
	 	 	</div><br />

            <div id="report">
<%
	if(clusterKey!=null){
		clusterKey = clusterKey.trim();
		LinkedList<ClusterDataBean> cdBList = ClusterDao.selectClusterDataAll(selectSeq, clusterKey);
		HashSet<String> set = new HashSet<String>();
		if(cdBList.size() > 0){
			ClusterDataBean cdb = cdBList.get(0);
			set = MapUtil.converHashSet(cdb.getEids().split(","));
		}
		GetReportData grd = new GetReportData(set);
		ReportBean rb = grd.getReportData();
%>            
            <table class="ct" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td>
                        <table class="Table12" border="0" cellpadding="0" cellspacing="0" summary="분석 보고서 테이블">
                        	<tr>
                                <td class="txt3">과학기술 계량정보분석을 통한 유망연구영역 분석</td>
                                <td class="txt4">일련번호</td>
                                <td class="txt3_1"><%=clusterKey %></td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                	<table class="Table13" border="0" cellpadding="0" cellspacing="0" align="center">
                                        <tr>
                                            <td class="txt4">연구분야</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">대분류</td>
                                            <td><%=rb.getAsjcLargeList()
											.toString().replaceAll("\\{", "")
											.replaceAll("\\}", "")
											.replaceAll("\\, ", "\r\n") %></td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">분류코드<br />(%,빈도)</td>
                                            <td><%=rb.getAsjcList()
											.toString().replaceAll("\\{", "")
											.replaceAll("\\}", "")
											.replaceAll("\t", " ")
											.replaceAll("\\, ", "\r\n") %></td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">통계정보</td>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                                    <tr>
                                                        <td>핵심논문수</td>
                                                        <td>핵심논문피인용수</td>
                                                        <td>핵심 논문당 피인용수</td>
                                                        <td>핵심논문평균연도</td>
                                                        <td>인용논문평균연도</td>
                                                    </tr>
                                                    <tr>
                                                        <td><%=String.valueOf(rb
                												.getDocumentCount()) %></td>
                                                        <td><%=String.valueOf(rb
                												.getCitationCount()) %></td>
                                                        <td><%=rb
        												.getCitationCountPerDocument() %></td>
                                                        <td><%=rb
        												.getAveragePublicationYear() %></td>
                                                        <td><%=rb
        												.getAverageCitationPublicationYear() %></td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">핵심키워드</td>
                                            <td><%=rb.getKeywordList()
											.toString().replaceAll("\\{", "")
											.replaceAll("\\}", "")
											.replaceAll("\t", " ")
											.replaceAll("\\, ", "\r\n") %>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">핵심논문</td>
                                            <td>
										<%
											for (DocumentBean db : rb.getDocumentList()) {
												out.println("("
														+ db.getCitationCount()
														+ ")["
														+ db.getEid()
														+ "-"
														+ db.getTitle().replaceAll(
																"\t", " ") + "] <br/>");
											}
																							
										%>                                            
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">국내현황</td>
                                            <td>
                                            <%
                                            String[] orgNames = rb.getKoreaOrgNameList().split("`");
                                            out.println("<b>국내연구기관</b> <br/>");
                                            LinkedHashSet<String> dataSet = new LinkedHashSet<String>();
                                            for(String a : orgNames){
                                            	a = a.trim();
                                            	if("".equals(a)) continue;
                                            	String v = a.split(":")[1];
                                            	if(!dataSet.contains(v)){
	                                            	out.println(v +"<br/>");
	                                            	dataSet.add(v);
                                            	}
                                            }
                                            out.println("<b>논문리스트</b> <br/>");
                                            for(String a : orgNames){
                                            	a = a.trim();
                                            	if("".equals(a)) continue;
                                            	String v = a.split(":")[0];
                                            	if(!dataSet.contains(v)){
	                                            	out.println(v +"<br/>");
	                                            	dataSet.add(v);
                                            	}
                                            }
                                            
                                            %>
                                            <%--=rb.getKoreaOrgNameList().replaceAll("\\{", "")
											.replaceAll("\\}", "")
											.replaceAll("\t", " ")
											.replaceAll("\\`", "\r\n") --%>&nbsp;
											
											</td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">발생연도현황</td>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                            	<%
                                            	SortedMap<Integer, Integer>  pyInfoMap = rb.getPublicationYearInfo();
                                            	
                                            		out.println("<tr>");
                                            		for(Integer year : pyInfoMap.keySet()){
	                                            		out.println("<td>");
	                                            		out.println(year);
	                                            		out.println("</td>");
                                            		}
                                            		out.println("</tr>");
                                            		out.println("<tr>");
                                            		for(Integer year : pyInfoMap.keySet()){
	                                            		out.println("<td>");
	                                            		out.println(pyInfoMap.get(year));
	                                            		out.println("</td>");
                                            		}
                                            		out.println("</tr>");
                                            	%>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">인용논문<br />발행연도현황</td>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                                   <%
                                            	SortedMap<Integer, Integer>  ciInfoMap = rb.getCitationPublicationYearInfo();
                                            		out.println("<tr>");
                                            		for(Integer year : ciInfoMap.keySet()){
	                                            		out.println("<td>");
	                                            		out.println(year);
	                                            		out.println("</td>");
                                            		}
                                            		out.println("</tr>");
                                            		out.println("<tr>");
                                            		for(Integer year : ciInfoMap.keySet()){
	                                            		out.println("<td>");
	                                            		out.println(ciInfoMap.get(year));
	                                            		out.println("</td>");
                                            		}
                                            		out.println("</tr>");
                                            	%>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">연구영역명</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="txt4">연구영역의<br />개요</td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td class="txt4" >기타의견</td>
                                            <td>&nbsp; </td>
                                        </tr>
                                    </table></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
<%
	}
%>             
            </div>    
 	 	</div>
    </div>
    <!--contents_area-->
    <form id="parameter" method="post">
    	<input type="hidden" name="htmlData" />
    	<input type="hidden" name="selectSeq" value="<%=selectSeq%>" />
    	<input type="hidden" name="clusterKey" value="<%=clusterKey%>" />
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