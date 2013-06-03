<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.SortedMap"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="kr.co.tqk.web.util.UserUsePlatformDefinition"%>
<%@page import="kr.co.tqk.web.db.dao.UserUsePlatformDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<%
	String userID = baseRequest.getParameter("userID", null);
	String year = baseRequest.getParameter("year", String.valueOf(Calendar.getInstance().get(Calendar.YEAR)));
	int actionType = baseRequest.getInteger("actionType", UserUsePlatformDefinition.ACTION_SEARCHING);
	
	List<UserBean> userList = UserDao.selectAll();
	Map<String, UserBean> beanMap = new HashMap<String, UserBean>();
	for(UserBean ub : userList){
		beanMap.put(ub.getId(), ub);
	}
	
	LinkedHashMap<String, SortedMap<String, Integer>> result = UserUsePlatformDao.statics(userID, actionType, false, null);
	int startYear = 2011;
	int lastYear = Integer.parseInt(year); 
	
	for(String _id : result.keySet()){
		SortedMap<String, Integer> tmp = result.get(_id);
		for(String y : tmp.keySet()){
			int l = Calendar.getInstance().get(Calendar.YEAR);
			try{
				l = Integer.parseInt(y);
			}catch(NumberFormatException e){
				continue;
			}
			if(startYear > l){
				startYear = l;
			}
			if(lastYear < l){
				lastYear = l;
			}
		}
	}

%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 연도별 이용 현황</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<link href="<%=contextPath %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<script type="text/javascript">
function viewMonth(){
	var form = document.getElementById("searchForm");
	form.action="./usePlatformMonth.jsp";
	form.submit();
}
</script>
</head>

<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <jsp:include page="../inc/topArea.jsp">
    	<jsp:param value="<%=TOP_MENU_MANAGE %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_USER_USING %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
	    	<%
				String menuTerm = "사용자 이용 현황 (연도별 이용 현황)";
			%>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            <form name="searchForm" id="searchForm" method="get">
            
            <div id="search_choice1">
            <table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table1_bt" border="0" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                                <td class="txt" style="text-align: left">
                                	<input type="button" value="월별 현황 보기" class="bt5"  onclick="javascript:viewMonth();"/> 
                                </td>
                                <td> 	
                                	User ID : <input type="text" class="input_txt" name="userID" maxlength="16" value="<%=userID==null?"":userID%>"/> 
                                	<input type="button" class="bt5" value="Search" title="Search" alt="Search" onclick="submit();"/>
                                </td>
                            </tr>
                  		</table></td>
             	</tr>
                <tr>
       	  		 	<td height="1" bgcolor="#a5b8ff"></td>
   	  		 	</tr>
       	  		<tr>
       	  		 	<td valign="top" align="left">
                    	<table class="Table2_bt" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                             	<td class="txt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<select name="year" onchange="submit();" style="font-family: 맑은 고딕; !important;">
								<%
									for(int _year = lastYear ; _year >= startYear ; _year--){
										out.println("<option value=\""+_year+"\" "+ (Integer.parseInt(year)==_year?"selected":"") +">"+_year+"년</option>");
									}
								%>
                             		</select> 
                             		<select name="actionType" onchange="submit();" style="font-family: 맑은 고딕; !important;">
                             			<option value="<%= UserUsePlatformDefinition.ACTION_EXPORT%>" <%=actionType==UserUsePlatformDefinition.ACTION_EXPORT?"selected":"" %>>사용자 검색 논문 다운로드 이용 현황</option>
                             			<option value="<%= UserUsePlatformDefinition.ACTION_LOGIN%>" <%=actionType==UserUsePlatformDefinition.ACTION_LOGIN?"selected":"" %>>사용자 시스템 로그인 이용 현황</option>
                             			<option value="<%= UserUsePlatformDefinition.ACTION_SEARCHING%>" <%=actionType==UserUsePlatformDefinition.ACTION_SEARCHING?"selected":"" %>>사용자 검색 이용 현황</option>
                             		</select>
								</td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            </div></form><br />
            
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="Table5">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5">
                            <caption>사용자 이용 현황 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th style="padding:2px 2px 2px 2px;">User ID</th>
                                <%
                                	for(int index=startYear ; index<= lastYear; index++){
                                		out.println("<th style=\"padding:2px 2px 2px 2px;\">"+index+"년</th>");
                                	}
                               		out.println("<th style=\"padding:2px 2px 2px 2px;\">Total</th>");
                                %>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                            	String bgcolor = "";
                            	int cnt=0;
                            	
                            	if(result.size()==0){
                            		out.println("<tr height=\"30\" "+bgcolor+">");
                            		out.println("<td colspan=\"14\"><b>"+userID+"</B>로 검색된 사용자가 존재하지 않거나 해당기간의 데이터가 존재하지 않습니다.</td>");
                            		out.println("</tr>");
                            	}
                            	
                            	for(String _userID : result.keySet()){
                            		UserBean ub = beanMap.get(_userID.trim());
                            		if(ub==null){
                            			continue;
                            		}
                            		out.println("<tr height=\"30\" "+bgcolor+">");
                            		if(cnt % 2 == 0){
                            			bgcolor = "bgcolor=\"#f4f8fa\"";
                            		}else{
                            			bgcolor = "";
                            		}
	                            	String title = "";
	                            	String name = "";
                            		
                            		name = " (" + ub.getNames() +")";
                            		String email = ub.getEmail();
                            		String department = ub.getDepartment();
                            		title = ub.getNames() +"\n" + email +"\n" + department;
                            		out.println("<td class=\"tipTipClass\" title=\""+title+"\">"+_userID + name+"</td>");
                            		SortedMap<String, Integer> data = result.get(_userID);
                            		for(int index=startYear ; index<= lastYear; index++){
                            			if(data.get(String.valueOf(index))==null){
		                            		out.println("<td>0</td>");
                            			}else{
		                            		out.println("<td>"+data.get(String.valueOf(index))+"</td>");
                            			}
                            		}
	                            		out.println("<td>"+data.get("TOTAL")+"</td>");
                            		out.println("</tr>");
                            		cnt++;
                            	}
                            %>
                            </tbody>
                        </table></td>
             	</tr>
            </table>
            </div>
            
            <div class="num">
			</div><br />
            
            <!-- 
            <div id="Graph">
            <table class="graph" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td align="center">그래프</td>
   	  		 	</tr>
            </table>
            </div>
             -->      
 	 	</div>
    </div>
    <!--contents_area-->
    
     <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area--> 
</div>
</body>
</html>
    