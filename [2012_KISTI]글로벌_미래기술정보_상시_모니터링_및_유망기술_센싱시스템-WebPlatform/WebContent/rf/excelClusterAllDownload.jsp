<%@page import="kr.co.topquadrant.db.bean.RFAnalysisOption"%>
<%@page import="kr.co.topquadrant.util.MapValueSort"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.google.common.collect.Collections2"%>
<%@page import="org.apache.commons.collections.map.MultiValueMap"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="kr.co.topquadrant.db.bean.ClusterResultSummary"%>
<%@page import="kr.co.topquadrant.db.bean.ClusterDocument"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%><%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysisCluster"%><%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.lang.reflect.Type"%><%@page import="com.google.common.reflect.TypeToken"%><%@page import="kr.co.tqk.web.db.bean.UserBean"%><%@page import="kr.co.topquadrant.db.mybatis.HCPParameter"%><%@page import="kr.co.topquadrant.db.bean.HCP"%><%@page import="kr.co.topquadrant.db.dao.HCPDao"%><%@page import="kr.co.topquadrant.db.dao.IHCPDao"%><%@page import="kr.co.topquadrant.util.HCPTree"%><%@page import="java.util.HashSet"%><%@page import="java.util.Set"%><%@page import="kr.co.topquadrant.util.MakeHCPTree"%><%@page import="com.google.gson.Gson"%><%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%><%@page import="kr.co.tqk.web.util.RequestUtil"%><%@page import="net.sf.json.JSONArray"%><%@page import="java.util.List"%><%@page contentType="application/vnd.ms-excel; charset=UTF-8" %><%
	RequestUtil baseRequest = new RequestUtil(request);
	
	int seq = baseRequest.getInteger("seq", -1);
	int updateFlag = baseRequest.getInteger("updateFlag", -1);
	
	IResearchFrontDao irfd = new ResearchFrontDAO();
	List<RFAnalysisOption> optionList = irfd.selectAnalysisOptionALL();
	RFAnalysisOption option = null;
	if(optionList.size() > 0){
		option = optionList.get(0);
	}
	
	MyBatisParameter parameter = new MyBatisParameter();
	parameter.setSeq(seq);
	parameter.setUpdate_flag(updateFlag);
	
	List<ClusterResultSummary> acList = irfd.selectAllAnaylsisClusterSeq(parameter);
	
	String strClient = request.getHeader("user-agent"); 
	if( strClient.indexOf("MSIE 5.5") != -1 ) { 
		// explorer 5.5 버전 비교
		response.setHeader("Content-Disposition", "inline; filename=researchFront_"+seq+".xls"); 
		response.setHeader("Content-Description", "JSP Generated Data");
	} else {
		response.setHeader("Content-Disposition", "attachment; filename=researchFront_"+seq+".xls"); 
		response.setHeader("Content-Description", "JSP Generated Data");
	}
	
	TreeMap<Integer, Integer> clusterCounting = new TreeMap<Integer, Integer>();
	Map<String, Integer> asjcCounting = new HashMap<String, Integer>();
	
%>
<html> 
<head> 
<style type="text/css"> 
th {background-color: fuchsia; background: olive;} 
table {font-family:'Trebuchet MS',"Malgun Gothic" "맑은 고딕"; font-size: x-small;  text-align: left;}
td {text-align: left; vertical-align: top; vertical-align: text-top;}
</style> 
</head> 
<body> 
<table border="1">
<%
	/*make header*/
	out.println("<tr>");
	out.println("	<th width='80'>No</th>");
	out.println("	<th width='250'>대분류</th>");
	out.println("	<th width='250'>분류코드</th>");
	out.println("	<th width='70'>핵심논문수</th>");
	out.println("	<th width='70'>핵심논문 피인용수</th>");
	out.println("	<th width='70'>핵심논문당 피인용수</th>");
	out.println("	<th width='70'>인용논문 평균연도</th>");
	out.println("	<th width='300'>핵심키워드</th>");
	out.println("	<th width='400'>핵심논문</th>");
	out.println("	<th width='300'>국내현황</th>");
	out.println("	<th width='70'>발행연도현황</th>");
	out.println("	<th width='70'>인용논문 발행연도현황</th>");
	out.println("</tr>");
	
	int documentCountTotal = 0; /*핵심논문의 총 갯수.*/ 
	int minClusterSize = Integer.MAX_VALUE; /*Min 군집 갯수.*/ 
	int maxClusterSize = Integer.MIN_VALUE; /*Max 군집 갯수.*/
	int totalAnaylsysDocument = 0; /*분석 대상 총 논문 수.*/
	
	for(ClusterResultSummary crs : acList){
		int documentCnt = crs.getDocumentCount();
		int documentCntV = 0;
		if(clusterCounting.containsKey(documentCnt)){
			documentCntV = clusterCounting.get(documentCnt);
		}
		clusterCounting.put(documentCnt, documentCntV+1);
		
		ClusterDocument cd = new Gson().fromJson(crs.getJson(), ClusterDocument.class);
		totalAnaylsysDocument = cd.getTotalAnaylsysDocument();
		
		if(cd!=null){
			if(minClusterSize > crs.getDocumentCount()){
				minClusterSize = crs.getDocumentCount();
			}
			
			if(maxClusterSize < crs.getDocumentCount()){
				maxClusterSize = crs.getDocumentCount();
			}
			
			documentCountTotal+= cd.getDocumentCount();
			
			Set<String> asjcSet = cd.getAsjcInfo().keySet();
			
			for(String asjc : asjcSet){
				int asjcCnt = 0;
				if(asjcCounting.containsKey(asjc)){
					asjcCnt = asjcCounting.get(asjc);
				}
				asjcCounting.put(asjc, asjcCnt+1);
			}
			
			out.println("<tr height='200'>");
			out.println("	<td valign='top'>"+cd.getClusterID()+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getLargeAsjcInfo())+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getAsjcInfo())+"</td>");
			out.println("	<td valign='top'>"+cd.getDocumentCount()+"</td>");
			out.println("	<td valign='top'>"+cd.getDocumentReferenceCount()+"</td>");
			out.println("	<td valign='top'>"+cd.getReferenceCountPerDocument()+"</td>");
			out.println("	<td valign='top'>"+cd.getAveragePubYearDocument()+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getKeywordInfo())+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getDocumentList(), true)+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getKoreaDocumentEidSet(), true)+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getStaticsPubYear())+"</td>");
			out.println("	<td valign='top'>"+printKeyValue(cd.getStaticsCitationPubYear())+"</td>");
			out.println("</tr>");
		}
	}
	
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] 클러스터 분석 방법 : "+(option!=null?option.getContentsJson():"")+"</td>");
	out.println("</tr>");
	
	Set<Integer> clusterCountingSet = clusterCounting.descendingKeySet();
	for(Integer clusterCount : clusterCountingSet){
		out.println("<tr>");
		out.println("	<td colspan='12'>[Cluster개수 통계 Info] "+clusterCount +":" + clusterCounting.get(clusterCount)+"</td>");
		out.println("</tr>");
	}
	
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] 분석 대상 총 논문의 갯수 : "+totalAnaylsysDocument+"</td>");
	out.println("</tr>");
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] Cluster Count : "+acList.size()+"</td>");
	out.println("</tr>");
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] 핵심 논문의 갯수 : "+documentCountTotal+"</td>");
	out.println("</tr>");
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] Max 군집 갯수 : "+maxClusterSize+"</td>");
	out.println("</tr>");
	out.println("<tr>");
	out.println("	<td colspan='12'>[Info] Min 군집 갯수 : "+minClusterSize+"</td>");
	out.println("</tr>");
	
	Map<String, Integer> asjcInfoMap = MapValueSort.sortByValue(asjcCounting);
	Set<String> asjcSet = asjcInfoMap.keySet();
	for(String asjc : asjcSet){
		out.println("<tr>");
		out.println("	<td colspan='12'>[Info] 분류정보 : "+asjc+":"+asjcInfoMap.get(asjc)+"</td>");
		out.println("</tr>");
	}
	
	
	
	
	
%> 
</table> 
</body> 
</html>
<%!
private <K, V> String printKeyValue(Map<K, V> data){
	return printKeyValue(data, false);
}
private <K, V> String printKeyValue(Map<K, V> data, boolean wordWrap){
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
		}else{
			sb.append(v);
		}
		if(cnt!=set.size()-1){
			sb.append("<br style=\"mso-data-placement:same-cell;\">");
			if(wordWrap){
				sb.append("<br style=\"mso-data-placement:same-cell;\">");
			}
		}
		cnt++;
	}
	return sb.toString();
}

%>