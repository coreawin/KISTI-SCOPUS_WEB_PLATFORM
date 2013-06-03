<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="org.apache.commons.lang.NumberUtils"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.topquadrant.util.MapValueSort"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.topquadrant.db.bean.ClusterDocument"%>
<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>    
<%
	String param = baseRequest.getParameter("param");
	List<ClusterDocument> list = new LinkedList<ClusterDocument>();

	if(param!=null){
		String[] paramsArray = param.split(";");
		
		IResearchFrontDao dao = new ResearchFrontDAO();
		for(String paramInfo : paramsArray){
			String[] params = paramInfo.split("_");
			int seq = Integer.parseInt(params[0]);
			int consecutiveNumber = Integer.parseInt(params[1]);
			int updateFlag = Integer.parseInt(params[2]);
			MyBatisParameter mbp = new MyBatisParameter();
			mbp.setSeq(seq);
			mbp.setConsecutiveNumber(consecutiveNumber);
			mbp.setUpdate_flag(updateFlag);
			list.add(dao.getClusterResultInfo(mbp));
		}
	}
	UserBean userBean = (UserBean)session.getAttribute(USER_SESSION);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/../images/favicon.ico" />
<!-- link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" / -->
<script src="<%=contextPath%>/js/mouseForbid.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<style type="text/css">
body {
	font: normal 12px auto 'Trebuchet MS', 'Malgun Gothic',
	color: #4f6b72;
	/*background: #E6EAE9;*/
}

a {
	color: #c75f3e;
}

#mytable {
	padding: 0;
	margin: 0;
}
#exportHeaderTable tr td{}

caption {
	padding: 0 0 5px 0;
	width: 700px;	 
	font: italic 11px 'Trebuchet MS', 'Malgun Gothic';
	text-align: right;
}

th {
	font: bold 14px 'Trebuchet MS', 'Malgun Gothic';
	color: #4f6b72;
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	border-top: 1px solid #C1DAD7;
	/*letter-spacing: 2px;
	text-transform: uppercase;*/
	text-align: center;
	padding: 6px 6px 6px 12px;
	background-color:#CAE8EA;
	/*background: #CAE8EA url(../images/bg_header.jpg) no-repeat;*/
}

th.nobg {
	border-top: 0;
	border-left: 0;
	border-right: 1px solid #C1DAD7;
	background: none;
}

td {
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	background: #fff;
	padding: 6px 6px 6px 12px;
	color: #4f6b72;
	font: 12px 'Trebuchet MS', 'Malgun Gothic';
}


td.alt {
	background: #F5FAFA;
	color: #797268;
}

th.spec {
	border-left: 1px solid #C1DAD7;
	border-top: 0;
	text-align: left;
	/*background: #fff url(../images/bullet1.gif) no-repeat;*/
	background-color:#fff;
	font: bold 12px 'Trebuchet MS', 'Malgun Gothic';
}

th.specalt {
	border-left: 1px solid #C1DAD7;
	border-top: 0;
	text-align: left;
	/*background: #f5fafa url(../images/bullet2.gif) no-repeat;*/
	background-color:#f5fafa;
	font: bold 12px 'Trebuchet MS', 'Malgun Gothic';
	color: #797268;
}

td.specalt {
	border-top: 0;
	text-align: center;
	font: 12px 'Trebuchet MS', 'Malgun Gothic';
	background: #f5fafa;
}

</style>
<script type="text/javascript">
	function viewScopus(eid){
		var url = "./viewScopus.jsp?eid="+eid;
		var name = "viewScopus";
		var spec = "width=1200,height=800,status=no,resizable=yes,scrollbars=yes";
		var wopen = window.open(url,name,spec, true);
		wopen.focus();
	}
</script>
<title>SCOPUS 정보 검색 플랫폼 - View Cluster Detail Info</title>
</head>
<body>
<table id="excel" cellpadding="0" cellspacing="0" border="0"  width="100%">
<%
	for(ClusterDocument cd : list){
		String checkedSeq = cd.getSeq() +"_" + cd.getConsecutiveNumber() +"_"+cd.getUpdateFlag();
%>
	<tr>
		<td>
			<table id="mytable" cellpadding="0" cellspacing="0" border="0" align="left" width="100%">
				<tr>
					<th class="specalt" colspan="3" style="text-align: center; !important">과학기술 계량정보분석을 통한 유망연구영역 분석</th>
					<th class="specalt">분석 일련번호</th>
					<td><%=cd.getClusterID()%></td>
				</tr>
			</table>		
			<br><br>
			<table id="mytable" cellpadding="0" cellspacing="0" border="0" align="left" width="100%">
				<tr>
					<th rowspan="10" width="5%" align="center">통<br></br>계<br></br>자<br></br>료</th>
					<th align="center" width="22%" class="specalt">연구분야</th>
					<td colspan="3" width="73%">#</td>
				</tr>
				<tr>
					<th scope="row" align="center" class="spec">대분류</th>
					<td colspan="3"><%out.println(printKeyValue(cd.getLargeAsjcInfo(), true)); %></td>
				</tr>
				<tr>
					<th scope="row" align="center" class="specalt">분류코드 (%빈도)</th>
					<td colspan="3"><%out.println(printKeyValue(cd.getAsjcInfo(), true)); %></td>
				</tr>
				<tr>
					<th scope="row" align="center" class="spec">기본정보</th>
					<td colspan="3">
						<table cellpadding="0" cellspacing="0" border="0" align="left" width="100%">
							<tr align="center">
								<td class="specalt">핵심논문수</td>
								<td class="specalt">핵심논문<br>피인용수</td>
								<td class="specalt">핵심논문당<br>피인용수</td>
								<td class="specalt">핵심논문<br>평균연도</td>
								<td class="specalt">인용논문<br>평균연도</td>
							</tr>
							<tr align="center">
								<td><%=cd.getDocumentCount() %></td>
								<td><%=cd.getDocumentReferenceCount() %></td>
								<td><%=NumberFormatUtil.getDecimalFormat(cd.getReferenceCountPerDocument(), 2)  %></td>
								<td><%=NumberFormatUtil.getDecimalFormat(cd.getAveragePubYearDocument(), 2) %></td>
								<td><%=NumberFormatUtil.getDecimalFormat(cd.getAveragePubYearCiationDoc(), 2) %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th scope="row" align="center" class="specalt">핵심키워드</th>
					<td colspan="3"><%out.println(printKeyword(cd.getKeywordInfo(), 10)); %></td>
				</tr>
				<tr>
					<th scope="row" align="center" class="spec">핵심논문</th>
					<td colspan="3"><%out.println(printDocTitleTable(cd.getDocumentList(), cd.getDocumentCitationCountLinked(), cd.getDocumentList().size(), userBean)); %></td>
				</tr>
				<!-- 
				<tr>
					<th scope="row" align="center" class="specalt">Top 논문</th>
					<td colspan="3"></td>
				</tr>
				 -->
				<tr>
					<th scope="row" align="center" class="spec">국내현황</th>
					<td colspan="3"><%out.println(printDocTitleTable(cd.getKoreaDocumentEidSet(), cd.getDocumentCitationCountLinked(), cd.getKoreaDocumentEidSet().size(), userBean)); %></td>
				</tr>
				<tr>
					<th scope="row" align="center" class="specalt">핵심논문 발행연도 현황</th>
					<td colspan="3"><%=mapToTable(cd.getStaticsPubYear()) %></td>
				</tr>
				<tr>
					<th scope="row" align="center" class="spec">인용논문 발행연도 현황</th>
					<td colspan="3"><%=mapToTable(cd.getStaticsCitationPubYear()) %></td>
				</tr>
			</table>
		</td>
	</tr>
<%
	}
%>
</table>
</body>
</html>

<%!
	private String mapToTable(Map<Integer, Integer> data){
		StringBuffer sb = new StringBuffer();
		sb.append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"left\" width=\"100%\">");
		Set<Integer> set = data.keySet();
		sb.append("<tr align=\"center\">");
		for(Integer s : set){
			sb.append("<td  class=\"specalt\">");
			sb.append(s);
			sb.append("</td>");
		}
		sb.append("<td  class=\"specalt\">total</td>");
		sb.append("</tr>");
		
		sb.append("<tr align=\"center\">");
		int sum = 0;
		for(Integer s : set){
			sum += data.get(s);
			sb.append("<td>");
			sb.append(data.get(s));
			sb.append("</td>");
		}
		sb.append("<td>"+sum+"</td>");
		sb.append("</tr>");
		sb.append("</table>");
		return sb.toString();
	}

	private <K, V> String printKeyValue(Map<K, V> data, boolean valueDataPercent){
		StringBuffer sb = new StringBuffer();
		Set<K> set = data.keySet();
		int cnt = 0;
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMaximumFractionDigits(2);
		for(K k : set){
			V v = data.get(k);
			sb.append(k);
			sb.append(" : ");
			if(v instanceof Float){
				Float f = (Float)v;
				sb.append(nf.format(f));
				if(valueDataPercent){
					sb.append("%");
				}
			}else{
				sb.append(v);
			}
			sb.append("<br>");
			cnt++;
		}
		return sb.toString();
	}
	
	StringBuffer keywordSB = new StringBuffer();
	private String printKeyword(Map<String, Integer> keywordMap, int topIndex){
		keywordSB.setLength(0);
		keywordMap = MapValueSort.topValueData(keywordMap, topIndex);
		Set<String> keywordSet = keywordMap.keySet();
		int cnt = 0;
		for (String kw : keywordSet) {
			keywordSB.append(kw.trim());
			keywordSB.append("(");
			keywordSB.append(keywordMap.get(kw));
			keywordSB.append(")");
			if ((keywordSet.size() - 1 != cnt)) {
				keywordSB.append("; ");
			}
			cnt++;
		}
		return keywordSB.toString();
	}
	
	StringBuffer topDocumentSB = new StringBuffer();
	private String printTopDocument(Map<String, Integer> citationDocInfoMap, Map<String, String> docTitleInfoMap, int topIndex){
		topDocumentSB.setLength(0);
		Set<String> eidSet = citationDocInfoMap.keySet();
		int cnt = 0;
		for (String eid : eidSet) {
			topDocumentSB.append(eid.trim());
			topDocumentSB.append(" : ");
			topDocumentSB.append(docTitleInfoMap.get(eid));
			if (cnt < topIndex ) {
				topDocumentSB.append("<hr> ");
			}
			if(cnt == topIndex){
				break;
			}
			cnt++;
		}
		return topDocumentSB.toString();
	}
	
	private String printTopDocumentTable(Map<String, Integer> citationDocInfoMap, Map<String, String> docTitleInfoMap, int topIndex, UserBean userBean){
		topDocumentSB.setLength(0);
		Set<String> eidSet = citationDocInfoMap.keySet();
		int cnt = 0;
		
		topDocumentSB.append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"left\" width=\"100%\">");
		for (String eid : eidSet) {
			if(cnt == topIndex){
				break;
			}
			topDocumentSB.append("<tr align=\"center\">");
			topDocumentSB.append("<td>");
			topDocumentSB.append((cnt+1));
			topDocumentSB.append("</td>");
			topDocumentSB.append("<td><a href=\"javascript:viewScopus('"+eid.trim()+"');\" >");
			topDocumentSB.append(eid.trim());
			topDocumentSB.append("</a></td>");
			/*
			topDocumentSB.append("<td>");
			topDocumentSB.append(citationDocInfoMap.get(eid));
			topDocumentSB.append("</td>");
			*/
			topDocumentSB.append("<td align=\"left\">");
			topDocumentSB.append(docTitleInfoMap.get(eid).trim());
			topDocumentSB.append("</td>");
			topDocumentSB.append("</tr>");
			cnt++;
		}
		topDocumentSB.append("</table>");
		return topDocumentSB.toString();
	}
	
	
	private String printDocTitleTable(Map<String, String> docTitleInfoMap, Map<String, Integer> citationMapInfo, int topIndex, UserBean userBean){
		topDocumentSB.setLength(0);
		Set<String> eidSet = docTitleInfoMap.keySet();
		if(citationMapInfo!=null){
			eidSet = citationMapInfo.keySet();
		}
		int cnt = 0;
		topDocumentSB.append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"left\" width=\"100%\">");
		for (String eid : eidSet) {
			if(!docTitleInfoMap.containsKey(eid)) continue;
			topDocumentSB.append("<tr align=\"center\">");
			topDocumentSB.append("<td>");
			topDocumentSB.append((cnt+1));
			topDocumentSB.append("</td>");
			topDocumentSB.append("<td><a href=\"javascript:viewScopus('"+eid.trim()+"');\" >");
			topDocumentSB.append(eid.trim());
			topDocumentSB.append("</a>");
			topDocumentSB.append("</td>");
			topDocumentSB.append("<td align=\"left\">");
			topDocumentSB.append("<small>("+ citationMapInfo.get(eid)+")</small>&nbsp;");
			topDocumentSB.append(docTitleInfoMap.get(eid).trim());
			topDocumentSB.append("</td>");
			topDocumentSB.append("</tr>");
			if(cnt == topIndex){
				break;
			}
			cnt++;
		}
		topDocumentSB.append("</table>");
		return topDocumentSB.toString();
	}
	
%>