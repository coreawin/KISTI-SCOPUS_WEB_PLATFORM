<%@page import="kr.co.tqk.web.db.dao.export.ExportInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String sessionID = request.getParameter("sessionID");
	if(sessionID!=null){
		//System.out.println("다운로드 세션을 종료합니다. " + sessionID);
		out.println(" ");
		ExportInfoDao.remove(sessionID + "_EXPORT_INFO");
		session.removeAttribute(sessionID + "_EXPORT_INFO");
	}
%>