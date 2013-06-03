<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Date"%>
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
try{
	int currentYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
	RequestUtil baseRequest = new RequestUtil(request);
	int year = baseRequest.getInteger("year", currentYear);
	double ranking = Double.parseDouble(baseRequest.getParameter("ranking", "0.01"));
	String asjc = baseRequest.getParameter("asjc", "");
	
	String datas = baseRequest.getParameter("datas");
	
	IHCPDao dao = new HCPDao();
	if(datas==null){
		HCPParameter param = new HCPParameter();
		param.setAsjc_code(asjc);
		param.setRanking(ranking);
		param.setPublication_year(String.valueOf(year));
		
		List<HCPDocument> hdList = dao.selectHCPDocument(param);
		StringBuffer sb = new StringBuffer();
		for(HCPDocument doc : hdList){
			sb.append(doc.getEid());
			sb.append(" ");
		}
		System.out.println(new Date() +" : " + hdList.size());
		out.println(sb.toString());
	}else{
		//1202@2007_1203@2007_1204@2007_1205@2008_1206@2009_
		String[] values = datas.split("_");
		Set<String> set = new HashSet<String>();
		for(String vs : values){
			String[] value = vs.split("@");
			HCPParameter param = new HCPParameter();
			param.setAsjc_code(value[0]);
			param.setRanking(ranking);
			param.setPublication_year(String.valueOf(value[1]));
			List<HCPDocument> hdList = dao.selectHCPDocument(param);
			for(HCPDocument doc : hdList){
				set.add(doc.getEid());
			}
		}
		
		for(String s : set){
			out.print(s);
			out.print(" ");
		}
	}
	
}catch(Exception e){
	e.printStackTrace();
	
}
%>