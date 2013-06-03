<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<script>
<%
	String selectSeqList = baseRequest.getParameter("selectSeq","");
	String[] selectSeq = selectSeqList.split(";");
	
	try{
		ArrayList<Integer> list = new ArrayList<Integer>();
		for(String seq : selectSeq){
			seq = seq.trim();
			if("".equals(seq)) continue;
			list.add(Integer.parseInt(seq));
		}
		ClusterDao.deleteClusterAll(list);
		out.println("alert(\" 관련 클러스터 정보가 삭제되었습니다.\")");
	}catch(Exception e){
		e.printStackTrace();
		out.println("alert(\"오류가 발생하였습니다. \\n"+e.getMessage().replaceAll("\\\"", "'").replaceAll("\n","")+"\")");
	} finally{
		out.println("location.href=\"./clusterReg.jsp\"");
	}
%>
</script>
