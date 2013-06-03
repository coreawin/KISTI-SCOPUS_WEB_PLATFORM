<%@page import="java.util.Set"%>
<%@page import="kr.co.topquadrant.db.bean.ClusterDocument"%>
<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.bean.HCPDocument"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.topquadrant.db.mybatis.HCPParameter"%>
<%@page import="kr.co.topquadrant.db.dao.HCPDao"%>
<%@page import="kr.co.topquadrant.db.dao.IHCPDao"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="kr.co.tqk.web.util.RequestUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	RequestUtil baseRequest = new RequestUtil(request);
	String param = baseRequest.getParameter("param", "");
	ClusterDocument cd = null;
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
			cd = dao.getClusterResultInfo(mbp);
			break;
		}
	}
	if(cd!=null){
		StringBuffer sb = new StringBuffer();
		Set<String> set = cd.getDocumentList().keySet();
		for(String s : set){
			sb.append(s);
			sb.append(" ");
		}
		out.println(sb.toString());
	}else{
		out.println("error");
	}
%>