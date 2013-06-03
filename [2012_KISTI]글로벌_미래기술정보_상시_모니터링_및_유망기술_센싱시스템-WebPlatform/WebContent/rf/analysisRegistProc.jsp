<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
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
	String title = baseRequest.getParameter("title");
	String description = baseRequest.getParameter("description");
	String selectedASJCCodes = baseRequest.getParameter("selectedASJCCodes");
	String addScience = baseRequest.getParameter("addScience", MyBatisParameter.N);
	String addNature = baseRequest.getParameter("addNature", MyBatisParameter.N);
	
	//String[] addDoc = baseRequest.getParameterValues("addDoc");
	String[] asjcs = selectedASJCCodes.split(" ");
	
	System.out.println(selectedASJCCodes);
	
	RFAnalysis bean = new RFAnalysis();
	bean.setTitle(title);
	bean.setDescription(description);
	
	bean.setAdd_science(addScience);
	bean.setAdd_nature(addNature);
	
	if(asjcs!=null){
		for(String asjc : asjcs){
			String a = asjc.trim();
			if(!"".equals(a)){
				bean.setAsjcCode(a);
				//System.out.println(a);
			}
		}
	}
	bean.setReg_user(userBean.getId());
	bean.setMod_user(userBean.getId());
	
	try{
		IResearchFrontDao dao = new ResearchFrontDAO();
		dao.insertAnalysis(bean);
		out.println("if(confirm(\"항목이 추가되었습니다. 계속 추가하시겠습니까?\")){");
		out.println("	location.href=\""+request.getContextPath()+"/rf/analysisRegist.jsp\";");
		out.println("}else{");
		out.println("	location.href=\""+request.getContextPath()+"/rf/analysisMain.jsp\";");
		out.println("}");
		
	}catch(Exception e){
		out.println("alert(\""+e.getMessage()+"\")");
		out.println("history.back(-1);");
	}
%>
</script>