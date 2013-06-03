<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.tqk.web.util.RequestUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	RequestUtil baseRequest = new RequestUtil(request);
	int seq = baseRequest.getInteger("seq", -1);
	String showMirian = baseRequest.getParameter("showMirian", "N");
	
	IResearchFrontDao dao = new ResearchFrontDAO();
	MyBatisParameter mbp = new MyBatisParameter();
	mbp.setSeq(seq);
	mbp.setShowMirian(showMirian);
	dao.updateShowMirian(mbp);
%>