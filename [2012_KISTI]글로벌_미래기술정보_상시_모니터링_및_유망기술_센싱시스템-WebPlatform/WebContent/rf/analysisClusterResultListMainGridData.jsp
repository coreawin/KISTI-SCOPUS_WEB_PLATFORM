<%@page import="java.text.DateFormat"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysisCluster"%><%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%><%@page import="kr.co.tqk.web.util.RequestUtil"%><%@page import="java.util.LinkedList"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashMap"%><%@page import="net.sf.json.JSONArray"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%><%@page import="java.util.List"%><%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%><%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
	String contextPath = request.getContextPath();
	RequestUtil baseRequest = new RequestUtil(request);
	int seq = baseRequest.getInteger("seq", -1);
	int update_flag = baseRequest.getInteger("update_flag", -1);

	String sort = baseRequest.getParameter("sord", "desc"); /*정렬자 asc, desc*/
	int pageNumber = baseRequest.getInteger("page", 1); /*페이징 번호*/
	String search = baseRequest.getParameter("_search");/*검색 여부 true, false*/
	String searchOper = baseRequest.getParameter("searchOper");/*검색 연산자*/
	String searchString = baseRequest.getParameter("searchString");/*검색어*/
	String searchField = baseRequest.getParameter("searchField");/*검색 칼럼 항목*/
	String sidx = baseRequest.getParameter("sidx", "DOCUMNET_COUNT"); /*선택된 칼럼 항목*/
	String nd = baseRequest.getParameter("nd");/*현재 시간. long형*/
	int rowsNumber = baseRequest.getInteger("rows", 10);/*현재 출력중인 row수*/
	
	if(sidx!=null){
		if(sidx.startsWith("mod")){
			sidx = "reg_date";
		}
	}
	for(Object k : request.getParameterMap().keySet()){
		Object o = request.getParameterMap().get(k);
		String[] s = (String[])o;
		for(String v : s){
			System.out.println(k + "\t" + v);
		}
	}
	
	MyBatisParameter mbp = new MyBatisParameter();
	mbp.setSeq(seq);
	mbp.setRequestPage(pageNumber);
	mbp.setUpdate_flag(update_flag);
	mbp.setRows(rowsNumber);
	mbp.setOrderColumn(sidx);
	mbp.setSord(sort);
	mbp.setSearchString(searchString);
	mbp.setSearchOper(searchOper);
	mbp.setSearchField(searchField);
	
	IResearchFrontDao dao = new ResearchFrontDAO();
	List<RFAnalysisCluster> list = dao.selectAllAnalysisCluster(mbp);
	/*
	for(RFAnalysisCluster rc : list){
		out.println(rc.getClusterNO());
		out.println("<hr>");
	}
	*/
	HashMap<String, Object> keyValue = new HashMap<String, Object>();
	int total = 0;
	int records = 0;
	if(list.size()>0){
		total = list.get(0).getTotalPage();
		records = list.get(0).getTotalCount();
	}
	keyValue.put("page",pageNumber);
	keyValue.put("total", total);
	keyValue.put("records", records);
	keyValue.put("rows",list);
	
	GsonBuilder gb = new GsonBuilder();
	gb.setDateFormat("yyyy-MM-dd");
	Gson g = gb.create();
	out.println(g.toJson(keyValue));
	
%>