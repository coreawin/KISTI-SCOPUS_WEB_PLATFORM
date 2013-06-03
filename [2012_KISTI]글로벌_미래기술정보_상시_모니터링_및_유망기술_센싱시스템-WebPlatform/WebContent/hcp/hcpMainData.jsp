<%@page import="java.lang.reflect.Type"%>
<%@page import="com.google.common.reflect.TypeToken"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.topquadrant.db.mybatis.HCPParameter"%>
<%@page import="kr.co.topquadrant.db.bean.HCP"%>
<%@page import="kr.co.topquadrant.db.dao.HCPDao"%>
<%@page import="kr.co.topquadrant.db.dao.IHCPDao"%>
<%@page import="kr.co.topquadrant.util.HCPTree"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="kr.co.topquadrant.util.MakeHCPTree"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.tqk.web.util.RequestUtil"%><%@page import="java.util.LinkedList"%><%@page import="net.sf.json.JSONObject"%><%@page import="java.util.HashMap"%><%@page import="net.sf.json.JSONArray"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%><%@page import="java.util.List"%><%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%><%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
	String contextPath = request.getContextPath();
	RequestUtil baseRequest = new RequestUtil(request);

	double ranking = Double.parseDouble(baseRequest.getParameter("ranking", "0.01"));
	String largeAsjc = baseRequest.getParameter("largeAsjc", "");
	/*
	for(Object k : request.getParameterMap().keySet()){
		Object o = request.getParameterMap().get(k);
		String[] s = (String[])o;
		for(String v : s){
			System.out.println(k + "\t" + v);
		}
	}
	*/
	IHCPDao dao = new HCPDao();
	HCPParameter param = new HCPParameter();
	param.setRanking(ranking);
	System.out.println("==> " + param.getTableRanking());
	System.out.println("==> " + param.getRanking());
	
	List<HCP> hcpList = null;
	
	UserBean userBean = (UserBean)session.getAttribute("USER_SESSION");
	String sessionKey = String.valueOf(ranking);
	if(userBean!=null){
		sessionKey = userBean.getId() + String.valueOf(ranking) ;
	}
	
	String dataJson = (String)session.getAttribute(sessionKey);
	if(dataJson==null){
		List<HCP> data = dao.selectHCPAllData(param);
		dataJson =new Gson().toJson(data); 
		session.setAttribute(sessionKey, dataJson);
	}
	Type typeOfT = new TypeToken<List<HCP>>(){}.getType();
	hcpList = new Gson().fromJson(dataJson, typeOfT);
	/*
	if(userBean!=null){
		String sessionKey = userBean.getId() + ranking ;
		String dataJson = (String)session.getAttribute(sessionKey);
		if(dataJson==null){
			List<HCP> data = dao.selectHCPAllData(param);
			dataJson =new Gson().toJson(data); 
			session.setAttribute(userBean.getId() + ranking, dataJson);
		}
		Type typeOfT = new TypeToken<List<HCP>>(){}.getType();
		hcpList = new Gson().fromJson(dataJson, typeOfT);
	}else{
		hcpList = dao.selectHCPAllData(param);
	}
	*/
	MakeHCPTree t = new MakeHCPTree(hcpList);
	Set<String> largeAsjcSet = new HashSet<String>();
	String[] laArray = largeAsjc.split(",");
	for(String la : laArray){
		if(la.trim().equals("")){
			continue;
		}
		largeAsjcSet.add(la);
	}
	List<HCPTree> list = t.makeTreeData(largeAsjcSet);
	HashMap<String, Object> keyValue = new HashMap<String, Object>();
	keyValue.put("page",1);
	keyValue.put("total",1);
	keyValue.put("records",1);
	keyValue.put("rows",list);
	out.println(new Gson().toJson(keyValue));
%>