<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterDataBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<script>
<%
	int selectSeq = baseRequest.getInteger("selectSeq", 20);
	String clusterKey = baseRequest.getParameter("clusterKey", null);
	int selectClusterDataSeq = baseRequest.getInteger("selectClusterDataSeq",-1);
	String isDel = baseRequest.getParameter("isDel",ClusterDataBean.ISDEL_TYPE_N);
	
	try{
		System.out.println("isDel  " + isDel);
		System.out.println("selectClusterDataSeq  " + selectClusterDataSeq);
		ClusterDao.updateClusterDataIsDel(selectClusterDataSeq, isDel);
		out.println("alert(\" 클러스터 관심 정보가 수정되었습니다.\")");
	}catch(Exception e){
		e.printStackTrace();
		out.println("alert(\"오류가 발생하였습니다. \\n"+e.getMessage().replaceAll("\\\"", "'").replaceAll("\n","")+"\")");
	} finally{
		out.println("location.href=\"./clusterReport.jsp?selectSeq="+selectSeq+"&clusterKey="+clusterKey+"\"");
	}
%>
</script>
