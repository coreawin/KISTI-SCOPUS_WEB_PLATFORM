<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.HashSet"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>]<%@include file="../common/auth.jsp" %><%
    
    try{
	//String eid = baseRequest.getParameter("eid");
	String parameter = baseRequest.getParameter("parameter");
	//boolean checked = baseRequest.getBoolean("checked", false);
	System.out.println("selecte doc parameter " + parameter );
	LinkedHashSet<String> selectDocSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(selectDocSet==null){
		selectDocSet = new LinkedHashSet<String>();
	}
	StringTokenizer st = new StringTokenizer(parameter,";");
	while(st.hasMoreTokens()){
		String document = st.nextToken();
		String[] info = document.split("_");
		String id = info[0];
		int selected = Integer.parseInt(info[1]);
		if(selected == 1){
			selectDocSet.add(id);
		}else{
			selectDocSet.remove(id);
		}
	}
	System.out.println("==================================================");
	System.out.println(selectDocSet);
	session.setAttribute(userBean.getId() + "_selectDocSet", selectDocSet);
    }catch(Exception e){
    	e.printStackTrace();
    }
	/*
	if(eid!=null){
		if(selectDocSet==null){
			selectDocSet = new LinkedHashSet<String>();
		}
		if(checked){
			for(String e : eid.split("\\;")){
				e = e.trim();
				if(!"".equalsIgnoreCase(e)){
					selectDocSet.add(e);
				}
			}
		}else{
			for(String e : eid.split("\\;")){
				e = e.trim();
				if(!"".equalsIgnoreCase(e)){
					selectDocSet.remove(e);
				}
			}
		}
	}
	    */
%>