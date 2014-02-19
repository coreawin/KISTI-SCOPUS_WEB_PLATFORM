<%@page import="java.net.URLEncoder"%>
<%@page import="kr.co.tqk.web.FullTextJSON"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="com.google.common.reflect.TypeToken"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="org.apache.http.client.ResponseHandler"%>
<%@page import="org.apache.http.client.methods.HttpPost"%>
<%@page import="org.apache.http.impl.client.BasicResponseHandler"%>
<%@page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@page import="org.apache.http.client.HttpClient"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/linkInfo.jsp" %>    
<%
try{
	String doi = request.getParameter("doi");
	if(doi==null){
		out.println("");
	}else{
		String ndslURL = apiURL + "?keyValue="+apiID+"&returnType="+apiReturnType+"&version=3.0&Target=A&callback=aa&id=doi:"+URLEncoder.encode(doi,"UTF-8");
		String deeplink = FullTextJSON.request(ndslURL);
		System.out.println("ndslURL : " + ndslURL);
		//System.out.println(doi +"==> " + deeplink);
		out.println(deeplink);
	}
}catch(Exception e){
	e.printStackTrace();
}

%>
