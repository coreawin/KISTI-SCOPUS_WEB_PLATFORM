<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%><%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%><%@page import="kr.co.topquadrant.db.bean.RFAnalysisOption"%><%@page import="net.sf.json.JSONObject"%><%@page import="java.util.HashMap"%><%@page import="java.util.Map"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@include file="../common/auth.jsp" %>
<script>
<%
boolean unauthorized = false;

if(userBean==null) {unauthorized = true;};
if(!userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth())){
	unauthorized = true;
}
if(unauthorized){
	out.println("<script>");
	out.println("alert('해당 페이지로의 접근 권한이 없습니다.');");
	out.println("location.href=\"./analysisMain.jsp\";");
	out.println("</script>");
}
	Map parameterMap = request.getParameterMap();
	Map<String, String> param = new HashMap<String, String>();
	
	for(Object key : parameterMap.keySet()){
		String[] values = (String[])parameterMap.get(key);
		if(values.length > 0){
			param.put(String.valueOf(key), values[0]);
		}
	}
	String json = JSONObject.fromObject(param).toString();

	RFAnalysisOption option = new RFAnalysisOption();
	option.setReg_user(userBean.getId());
	option.setContentsJson(json);
	
	try{
		IResearchFrontDao dao = new ResearchFrontDAO();
		dao.insertAnalysisOption(option);
		out.println("alert(\"분석조건이 저장되었습니다..\")");
		out.println("location.href=\""+request.getContextPath()+"/rf/analysisOption.jsp\";");
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>