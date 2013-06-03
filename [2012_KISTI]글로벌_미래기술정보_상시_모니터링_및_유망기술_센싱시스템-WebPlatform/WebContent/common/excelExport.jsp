<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=UTF-8">
<%
	request.setCharacterEncoding("UTF-8");
	String fileName = request.getParameter("fileName");
	if(fileName==null) fileName = "default.xls";
	String staticTableBodyValue = request.getParameter("staticTableBodyValue");
	response.setHeader("Content-Type", "application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment;filename="+fileName+";");
	response.setHeader("Content-Description", "JSP Generated Data");
	out.println("<table border=\"1\">");
	out.println(staticTableBodyValue);
	out.println("</table>");
%>