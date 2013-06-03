<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<script>
<%
	String pageUrl = baseRequest.getParameter("pageUrl", "./clusterReport.jsp");
	String clusterKey = baseRequest.getParameter("clusterKey", null);
	int selectSeq = baseRequest.getInteger("selectSeq", 20);
	
	try{
		ClusterDao.deleteClusterData(selectSeq, clusterKey);
		out.println("alert(\" 관련 클러스터번호가 삭제되었습니다.\")");
	}catch(Exception e){
		e.printStackTrace();
		out.println("alert(\"오류가 발생하였습니다. \\n"+e.getMessage().replaceAll("\\\"", "'").replaceAll("\n","")+"\")");
	} finally{
		out.println("location.href=\""+pageUrl+"\"");
	}
%>
</script>
