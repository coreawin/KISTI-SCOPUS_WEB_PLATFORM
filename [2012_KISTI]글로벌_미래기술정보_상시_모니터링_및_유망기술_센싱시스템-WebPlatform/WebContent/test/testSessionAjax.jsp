<%@page import="java.util.Date"%><%@page import="kr.co.tqk.web.util.UtilDate"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
	session.setAttribute("A", UtilDate.getDateFormate(new Date()) +" _날짜값");
%>