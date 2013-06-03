<%@page import="java.util.LinkedHashMap"%><%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%><%@page import="java.util.LinkedHashSet"%><%@page import="java.util.HashSet"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@include file="../common/auth.jsp" %><%
	String seq = baseRequest.getParameter("seq");
	boolean checked = baseRequest.getBoolean("checked", false);
	boolean allRemove = baseRequest.getBoolean("allRemove", false);
	String searchRule = baseRequest.getParameter("searchRule");
	String ft = baseRequest.getParameter("ft");
	if(ft!=null){
		searchRule += "&ft=" + ft;
	}
	
	LinkedHashMap<Integer, UserSearchRuleBean> usrBeanSet
		= (LinkedHashMap<Integer, UserSearchRuleBean>) session.getAttribute(userBean.getId() + "_selectSearchRule");
	
	if(allRemove){
		session.setAttribute(userBean.getId() + "_selectSearchRule", new LinkedHashMap<Integer, UserSearchRuleBean>());	
	}else{
		if(seq!=null){
			seq = seq.trim();
			int sequence = -1;
			try{
				sequence = Integer.parseInt(seq);
			}catch(NumberFormatException ne){
				
			}
			if(sequence!=-1){
				if(usrBeanSet==null){
					usrBeanSet = new LinkedHashMap<Integer, UserSearchRuleBean>();
				}
				if(checked){
					if(usrBeanSet.containsKey(sequence) == false){
						UserSearchRuleBean bean = new UserSearchRuleBean();
						bean.setSeq(sequence);
						bean.setSearchRule(searchRule);
						usrBeanSet.put(sequence, bean);
					}
					
				}else{
					if(usrBeanSet.containsKey(sequence) == true){
						usrBeanSet.remove(sequence);
					}
				}
			    System.out.println("_selectSearchRule " + usrBeanSet.size());
				session.setAttribute(userBean.getId() + "_selectSearchRule", usrBeanSet);	
			}
			out.println(sequence + "|" + checked +"|" + searchRule);
		}
	}
%>