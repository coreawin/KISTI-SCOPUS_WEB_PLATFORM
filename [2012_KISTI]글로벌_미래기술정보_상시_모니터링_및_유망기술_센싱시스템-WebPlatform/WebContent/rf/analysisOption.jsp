<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.util.JSONUtils"%>
<%@page import="kr.co.tqk.web.util.UtilDate"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysisOption"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
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


	IResearchFrontDao dao = new ResearchFrontDAO();
	List<RFAnalysisOption> list = dao.selectAnalysisOptionALL();
	RFAnalysisOption option = new RFAnalysisOption();
	if(list.size()>0){
		option = list.get(0);
	}
	
	Map optionValue = (Map)JSONObject.toBean(JSONObject.fromObject(option.getContentsJson()), Map.class);
	
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - Research Front Analysis Setting</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		//문서가 준비되었을때
		
	});

	function saveOption(){
		var form = document.getElementById("frm");
		form.action = "analysisOptionAddProc.jsp";
		form.method = "POST";
		form.submit();
	}
	
	function checkInsertValue(value, regex){
		re
		var regObject = new RegExp(regexPattern, value);
		result = pattern.test(fieldValue);
		alert(regObject);
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
    	<jsp:param value="<%=SUB_MENU_USER_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<% String menuTerm = "Research Front (Analysis Setting)"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
			
            <div>
            <form name="frm" id="frm" method="post">
            <table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td colspan="3" style="padding:2px 2px 2px 2px;">
                    	<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" >Option</span>
                    </td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;" width="40%">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;" width="20%">Date</td>
                    <td style="padding:2px 5px 2px 5px;"  width="40%">
                    	<%= UtilDate.getTimestampFormat(option.getReg_date(), "yyyy-MM-dd HH:mm") %>
                    </td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;">Threshold</td>
                    <td style="padding:2px 5px 2px 5px;"><input type="text" name="threshold" maxlength="10" style="width: 30%;" value="<%=optionValue.get("threshold")%>"/></td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;" >Decimal Place</td>
                    <td style="padding:2px 5px 2px 5px;"><input type="text" name="thresholdCut" maxlength="10" style="width: 30%;" value="<%=optionValue.get("thresholdCut")%>"/></td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;">Maximum Cluster Size</td>
                    <td style="padding:2px 5px 2px 5px;"><input type="text" name="maxClusterSize" maxlength="5" style="width: 30%;" value="<%=optionValue.get("maxClusterSize")%>"/></td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;">Minimum Cluster Size</td>
                    <td style="padding:2px 5px 2px 5px;"><input type="text" name="minClusterSize" maxlength="5" style="width: 30%;" value="<%=optionValue.get("minClusterSize")%>"/></td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;">Similarity Measure</td>
                    <td style="padding:2px 5px 2px 5px;">
                    	<select name="simility">
                    		<option value="co">코사인 계수</option>
                    		<option value="ii">Inclusion Index 계수</option>
                    	</select>
					</td>
                </tr>
       	  		<tr height="40">
       	  			<td style="padding:2px 5px 2px 20px; text-align: right;">.</td>
                    <td style="padding:2px 5px 2px 20px; text-align: center;">Citation Approach</td>
                    <td style="padding:2px 5px 2px 5px;">
                    	<select name="analysisType">
                    		<option value="BC" <%=("BC".equals(optionValue.get("analysisType"))?"selected":"")%>>BC</option>
                    		<option value="CC" <%=("CC".equals(optionValue.get("analysisType"))?"selected":"")%>>CC</option>
                    		<option value="KC" <%=("KC".equals(optionValue.get("analysisType"))?"selected":"")%>>KC</option>
                    		<option value="KC-Prime" <%=("KC-Prime".equals(optionValue.get("analysisType"))?"selected":"")%>>KC-Prime</option>
                    	</select>
                    </td>
                </tr>
                
       	  		<tr height="60">
                    <td colspan="3" style="padding:2px 17px 2px 20px; text-align: right; vertical-align: middle;">
                        <div id="submit">
							<input type="button" value="Save setting" class="bt4" title="클러스터를 등록합니다." onclick="javascript:saveOption();">
                        </div>
                    </td>
                </tr>
            </table> 
            </form>
            <!-- 
            <table class="Table3" border="0" cellpadding="0" cellspacing="0" height="372">
       	  		<tr>
                    <td colspan="2" style="padding:2px 2px 2px 2px;">
                    	<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" >Info</span>
                    </td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="130"><b>최근 수정일</b></b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>임계치</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>임계치 소수점 컷</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>최대 클러스터 사이즈</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>최소 클러스터 사이즈</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>유사도 계수</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"><b>분석 유형</b></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
       	  		<tr height="60">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100"></td>
                    <td style="padding:2px 5px 2px 5px;"></td>
                </tr>
            </table> 
             -->
            </div>
            
 	 	</div>
    </div>
    <form id="parameter" method="post">
    	<input type="hidden" name="removeIDs" />
    	<input type="hidden" name="selectID" />
    	<input type="hidden" name="selectAuth" />
    	<input type="hidden" name="searchAuthType" />
    	<input type="hidden" name="searchID" />
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>