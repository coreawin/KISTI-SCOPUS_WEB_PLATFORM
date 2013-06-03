<%@page import="java.util.LinkedList"%>
<%@page import="java.util.LinkedHashMap"%><%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%><%@page import="java.util.LinkedHashSet"%><%@page import="java.util.HashSet"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@include file="../common/auth.jsp" %><%
	String booleanType = baseRequest.getParameter("booleanType");
    if(booleanType==null){
    	out.println("false");
    }else{
    	LinkedHashMap<Integer, UserSearchRuleBean> usrBeanMap
		= (LinkedHashMap<Integer, UserSearchRuleBean>) session.getAttribute(userBean.getId() + "_selectSearchRule");
    	if(usrBeanMap==null){
	    	out.println("false");
    	}
   		StringBuffer se = new StringBuffer();
   		StringBuffer ft = new StringBuffer();
   		int cnt = 0;
   		LinkedList<String> seList = new LinkedList<String>();
    	for(UserSearchRuleBean b : usrBeanMap.values()){
    		String s= b.getSearchRule();
			try{
				if(s.indexOf("ft=")!=-1){
					String fts = s.substring(s.indexOf("ft=")+3, s.length());
					ft.append(fts);
					if(fts.length()>3){
						ft.append(",");
					}
				}
				if(s.indexOf("se={")!=-1){
					seList.add(s.substring(s.indexOf("se={")+3, s.indexOf("&")));
				}
			}catch(StringIndexOutOfBoundsException e){
				try{
					if(s.indexOf("se={")!=-1){
						seList.add(s.substring(s.indexOf("se={")+3, s.indexOf("ft")));
					}
				}catch(StringIndexOutOfBoundsException ie){
					if(s.indexOf("se={")!=-1){
						seList.add(s.substring(s.indexOf("se={")+3, s.length()));
					}
				}
			}
    		cnt++;
    	}
    	int i = 0;
    	for(String s : seList){
    		if(i>=1 && seList.size() > 1){
    			se.insert(0, "{");
    			se.append(booleanType);
    			se.append(s);
    			se.append("}");
    		}else{
    			se.append(s);
    		}
    		i++;
    	}
   		if(se.length() > 0 ){
    		out.print("se=");
    		out.print(se.toString());
   		}
   		if(ft.length() > 0 ){
    		out.print("&ft=");
    		out.print(ft.toString().substring(0, ft.length()-1));
   		}
    }
	
%>
