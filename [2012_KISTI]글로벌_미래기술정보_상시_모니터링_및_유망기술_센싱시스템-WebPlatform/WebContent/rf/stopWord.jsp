<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - 불용어 설정 화면</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath()%>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jquery.ui/1.7.3/css/redmond/jquery-ui-1.7.3.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/css/ui.jqgrid.css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/searchFilter.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/ui.multiselect.css" />

	<script src="<%=contextPath%>/module/jqgrid/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script>
<script type="text/javascript">
	jQuery.jgrid.no_legacy_api = true;
</script>
<script src="<%=contextPath%>/module/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/plugins/jquery.searchFilter.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/plugins/grid.postext.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/plugins/grid.setcolumns.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/plugins/grid.addons.js" type="text/javascript"></script>

<script type="text/javascript">

	
</script>
</head>
<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
	<jsp:include page="../inc/topAreaNoJQuerytLink.jsp">
    	<jsp:param value="<%=TOP_MENU_MANAGE %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_USER_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<%
				String menuTerm = "Research Front - 불용어 관리";
			%>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                    	<!-- table cellspacing="0" cellpadding="0" border="0" width="100%">
                    		<tr><td>
                    			범례 : CP (Core papers - 핵심 논문수), Cited by (피인용수), MY (mean year for core papers - 평균연도), CPP (Citations per papers - 핵심논문당 피인용수)
                    		</td></tr>
                    	</table -->
                        <table id="tableList" cellspacing="0" cellpadding="0" border="0" width="100%"></table>
                   		<div id="pager"></div>
                   		<br>
                   		<div style="text-align: right">
			            	<input type="button" class="bt5 tipTipClass" value="Research Front Main"  onclick="javascript:viewList();" title="클러스터 분석 목록으로 이동합니다."/>
			            	<input type="button" class="bt5 tipTipClass" value="view cluster info"  onclick="javascript:viewClusterButton();" title="분석된 클러스터에 대한 상세정보를 확인합니다."/>
			            	<input type="button" class="bt5 tipTipClass" value="selected item export"  onclick="javascript:exportCluster();" title="선택한 클러스터 분석 결과를 export 합니다."/>
			            	<%
			            		if(UserAuthEnum.AUTH_SUPER.getAuth().equals(userBean.getAuth())){
			            	%>
			            		<input type="button" class="bt5 tipTipClass" value="selected item delete"  onclick="javascript:deleteCluster();" title="선택한 클러스터 분석 결과를 삭제합니다."/>
			            	<%
					            }
			            	%>
			            </div>
                    </td>
             	</tr>
            </table>
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
    
    <form id="searchParameter" method="post">
    	<input type="hidden" name="searchTerm" value="" />
    	<input type="hidden" name="searchRule"/>
    	<input type="hidden" name="currentPage" value="1"/>
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>