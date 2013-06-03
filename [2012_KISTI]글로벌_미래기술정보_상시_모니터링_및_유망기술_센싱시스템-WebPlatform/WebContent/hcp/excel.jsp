<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.db.dao.SourceTypeDao"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.lang.reflect.Type"%><%@page import="com.google.common.reflect.TypeToken"%><%@page import="kr.co.tqk.web.db.bean.UserBean"%><%@page import="kr.co.topquadrant.db.mybatis.HCPParameter"%><%@page import="kr.co.topquadrant.db.bean.HCP"%><%@page import="kr.co.topquadrant.db.dao.HCPDao"%><%@page import="kr.co.topquadrant.db.dao.IHCPDao"%><%@page import="kr.co.topquadrant.util.HCPTree"%><%@page import="java.util.HashSet"%><%@page import="java.util.Set"%><%@page import="kr.co.topquadrant.util.MakeHCPTree"%><%@page import="com.google.gson.Gson"%><%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%><%@page import="kr.co.tqk.web.util.RequestUtil"%><%@page import="net.sf.json.JSONArray"%><%@page import="java.util.List"%><%@page contentType="application/vnd.ms-excel; charset=UTF-8" %><%
	String contextPath = request.getContextPath();
	RequestUtil baseRequest = new RequestUtil(request);
	
	String strClient = request.getHeader("user-agent"); 
	if( strClient.indexOf("MSIE 5.5") != -1 ) { 
		// explorer 5.5 버전 비교
		response.setHeader("Content-Disposition", "inline; filename=hcp.xls"); 
		response.setHeader("Content-Description", "JSP Generated Data");
	} else {
		response.setHeader("Content-Disposition", "attachment; filename=hcp.xls"); 
		response.setHeader("Content-Description", "JSP Generated Data");
	}

	int currentYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
	double ranking = Double.parseDouble(baseRequest.getParameter("ranking", "0.01"));
	int startYear = baseRequest.getInteger("startYear", currentYear-5);
	int endYear = baseRequest.getInteger("endYear", currentYear);
	String largeAsjc = baseRequest.getParameter("largeAsjc", "");
	boolean externalUse = baseRequest.getBoolean("externalUse", true);
	
	for(Object k : request.getParameterMap().keySet()){
		Object o = request.getParameterMap().get(k);
		String[] s = (String[])o;
		for(String v : s){
			System.out.println(k + "\t" + v);
		}
	}
	IHCPDao dao = new HCPDao();
	HCPParameter param = new HCPParameter();
	param.setRanking(ranking);
	
	List<HCP> hcpList = null;
	
	UserBean userBean = (UserBean)session.getAttribute("USER_SESSION");
	if(userBean!=null){
		String sessionKey = userBean.getId() + ranking ;
		String dataJson = (String)session.getAttribute(sessionKey);
		if(dataJson==null){
			List<HCP> data = dao.selectHCPAllData(param);
			dataJson =new Gson().toJson(data); 
			session.setAttribute(userBean.getId() + ranking, dataJson);
		}
		Type typeOfT = new TypeToken<List<HCP>>(){}.getType();
		hcpList = new Gson().fromJson(dataJson, typeOfT);
	}else{
		hcpList = dao.selectHCPAllData(param);
	}
	
	MakeHCPTree t = new MakeHCPTree(hcpList);
	Set<String> largeAsjcSet = new HashSet<String>();
	String[] laArray = largeAsjc.split(",");
	for(String la : laArray){
		if(la.trim().equals("")){
			continue;
		}
		largeAsjcSet.add(la);
	}
	List<HCPTree> list = t.makeTreeData(largeAsjcSet);
	
	Map<String, String> asjcKor = DescriptionCode.getAsjcTypeKoreaDescription();
%>
<html> 
<head> 
<style type="text/css"> 
th {font-family:맑은 고딕; background-color: fuchsia; background: fuchsia;} 
td {font-family:맑은 고딕;}
</style> 
</head> 
<body> 
<table border="1">
<%
	/*make header*/
	out.println("<tr>");
	out.println("	<th rowspan='2' bgcolor='#98DFFF'><b>ASJC</b></th>");
	for(int year = startYear; year <= endYear ; year++){
		if(externalUse){
			if(ranking!=0.01){
				out.println("	<th colspan='1' bgcolor='#98DFFF'><b>"+year+"</b></th>");
				continue;
			}
		}
		out.println("	<th colspan='3' bgcolor='#98DFFF'><b>"+year+"</b></th>");
	}
	out.println("</tr>");
	out.println("<tr>");
	for(int year = startYear; year <= endYear ; year++){
		if(externalUse){
			if(ranking!=0.01){
				out.println("	<th width='100' bgcolor='#98DFFF'><b>doc</b></th>");
				continue;
			}
		}
		out.println("	<th width='100' bgcolor='#98DFFF'><b>Total</b></th>");
		out.println("	<th width='100' bgcolor='#98DFFF'><b>"+(int)(ranking*100)+"%</b></th>");
		out.println("	<th width='100' bgcolor='#98DFFF'><b>Threshold</b></th>");
	}
	out.println("</tr>");
	
	/*make body*/
	int firstYear = 1995;
	for(HCPTree tree : list){
		String id = tree.getId();
		id  = id.substring(0, 2) + "00";
		if(largeAsjcSet.size() != 0){
			if(!largeAsjcSet.contains(id)){
				continue;
			}
		}
		out.println("<tr>");
		List<String> cellDataList = tree.getCellData();
		int startIdx = (startYear - firstYear)*3 + 1;
		int endIdx = ((endYear - startYear))*3 + startIdx + 2;
		int externalUseIdx = startIdx + 1;
		out.println("<td bgcolor='#98DFFF'><b>");			
		if(tree.getId().indexOf("TOTAL")!=-1){
			String code = tree.getId().split("_")[0].trim();
			out.println(code + " TOTAL - "  + asjcKor.get(code));			
		}else{
			out.println(tree.getId() +" - " + asjcKor.get(tree.getId().trim()));			
		}
		out.println("</b></td>");			
		for(int idx = startIdx; idx<=endIdx; idx++){
			String cell = cellDataList.get(idx);
			if(cell.indexOf(";")!=-1){
				cell = cell.split(";")[1];
			}
			if(externalUse){
				if(ranking!=0.01){
					if(externalUseIdx == idx){
						externalUseIdx += 3;
						out.println("<td>");
						out.println(cell);
						out.println("</td>");
					}
					continue;
				}
			}
			out.println("<td>");
			out.println(cell);
			out.println("</td>");			
		}
		out.println("</tr>");
	}
%> 
</table> 
</body> 
</html>