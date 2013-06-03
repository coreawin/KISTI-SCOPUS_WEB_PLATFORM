<%@page import="kr.co.tqk.web.util.RequestUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	final String USER_SESSION = "USER_SESSION";

	final int TOP_MENU_MANAGE = 100;
	final int SUB_MENU_USER_MANAGE = 10;
	final int SUB_MENU_USER_USING = 20;
	final int SUB_MENU_DOCUMENT_MANAGE = 30;
	final int SUB_MENU_DIC_MANAGE = 40;
	
	final int TOP_MENU_SEARCH = 10;
	final int SUB_MENU_DOCUMENT_SEARCH = 100;
	final int SUB_MENU_AUTHOR_SEARCH = 200;
	final int SUB_MENU_AFFILATION_SEARCH = 300;
	final int SUB_MENU_BOOLEAN_SEARCH = 400;
	final int SUB_MENU_COUNTRY_SEARCH = 500;
	
	final int TOP_MENU_CLUSTER = 30;
	final int SUB_MENU_CLUSTER_MAIN = 310;
	final int SUB_MENU_CLUSTER_REPORT = 320;
	final int SUB_MENU_CLUSTER_VISUAL = 330;
	
	RequestUtil baseRequest = new RequestUtil(request);

	String contextPath = request.getContextPath();
	/*
	final String TEMPORARY_SAVE_PATH = "/data/home/scopus/jsphome/cluster/tmp/";
	String modelPath = "/data/home/scopus/jsphome/models/";
	String tmpSavePath = "/data/home/scopus/jsphome/tmp/";
	*/
	final String TEMPORARY_SAVE_PATH = "j://Distribution/KISTI_Scopus_WebPlatform_Distribution/tmp/";
	String modelPath = "j://Distribution/KISTI_Scopus_WebPlatform_Distribution/models/";
	String tmpSavePath = TEMPORARY_SAVE_PATH;
	
	String currentDir = request.getRequestURI();
	
	//String fastcatSearchURL = "http://192.168.0.60:9090/search/json";
	//String fastcatSearchLiveURL = "http://192.168.0.60:9090/search/isAlive";
	String fastcatSearchURL = "http://203.250.228.166:9090/search/json";
	String fastcatSearchLiveURL = "http://203.250.228.166:9090/search/isAlive";
	//String fastcatSearchURL = "http://topquadrant.iptime.org:9090/search/json";

	//System.out.println("======================>> " + fastcatSearchURL +"\t\t");
%>
