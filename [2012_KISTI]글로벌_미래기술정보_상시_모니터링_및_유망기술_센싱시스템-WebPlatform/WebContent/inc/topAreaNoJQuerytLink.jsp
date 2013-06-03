<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>	
<%@include file="../common/auth.jsp" %>

<link type="text/css" href="<%=contextPath%>/module/menu/style3/menu.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/module/menu/style3/menu.js"></script>
<div id="top_area">       
        <div id="header">
        <h1><a href="<%=contextPath%>/"><img src="<%=contextPath%>/images/nn_toplogo.gif" alt="Nano - logo" align="top"/></a></h1>
            <ul id="tnb">
            	<li style="font-family: 맑은 고딕; !important; vertical-align: bottom;"> <small>FastCat Search Engine : <%=FastCatSearchUtil.requestSearchEngineALive(fastcatSearchLiveURL)?"<font color='green'>Running</font>":"<font color='red'>Stop!!</font>"%></small>&nbsp;|&nbsp;</li>
            	<li style="font-family: 맑은 고딕; !important;"> <%=userBean.getId() + " ("+userBean.getNames()+")"%> l </li>
				<li style="font-family: 맑은 고딕; !important;">　<a href="<%=contextPath%>/regist/userInfoModify.jsp">회원정보수정</a> l </li>
                <li style="font-family: 맑은 고딕; !important;">　<a href="<%=contextPath%>/logout.jsp">LOG-OUT</a></li>
            </ul>
        </div><br>
		<div id="menu">
			<ul class="menu">
				<li><a href="<%=contextPath%>/documentSearch/searchDocument.jsp" class="parent"><span>Search</span></a>
					<div><ul>
						<li><a href="<%=contextPath%>/documentSearch/searchDocument.jsp"><span>Document Search</span></a></li>
						<li><a href="<%=contextPath%>/documentSearch/catAuthor.jsp"><span>Author search</span></a></li>
						<li><a href="<%=contextPath%>/documentSearch/catAffilation.jsp"><span>Affiliation search</span></a></li>
					</ul></div>
				</li>
				<li><a href="<%=contextPath%>/documentSearch/searchBoolean.jsp"><span>Advanced Search</span></a>	</li>
				<li><a href="<%=contextPath%>/manage/userSearchRuleMain.jsp"><span>Search History</span></a></li>
				<li><a href="<%=contextPath%>/hcp/hcpMain.jsp"><span>HCP</span></a></li>
				<li><a href="<%=contextPath%>/rf/analysisMain.jsp"><span>Research Front</span></a>
					<div><ul>
						<li><a href="<%=contextPath%>/rf/analysisMain.jsp"><span>Research Front</span></a></li>
					<%
						if(UserAuthEnum.AUTH_SUPER.getAuth().equals(userBean.getAuth())){
					%>
						<li><a href="<%=contextPath%>/rf/analysisOption.jsp"><span>Cluster Analysis Setting</span></a></li>
					<%
						}
					%>
					</ul></div>
				</li>
				<%
					if(UserAuthEnum.AUTH_SUPER.getAuth().equals(userBean.getAuth())){
				%>
				<li class="last"><a href="<%=contextPath%>/manage/userManageMain.jsp" class="parent"><span>Administrator</span></a>
					<div><ul>
						<li><a href="<%=contextPath%>/manage/userManageMain.jsp"><span>회원관리</span></a></li>
						<li><a href="<%=contextPath%>/manage/usePlatformMonth.jsp" class="parent"><span>사용자 이용현황</span></a>
							<div><ul>
								<li><a href="<%=contextPath%>/manage/usePlatformYear.jsp"><span>연도별 이용 현황</span></a></li>
								<li><a href="<%=contextPath%>/manage/usePlatformMonth.jsp"><span>월별 이용 현황</span></a></li>
							</ul></div>
						</li>
					</ul></div>
				</li>
				<%
                	}
				%>
			</ul>
		</div>
		<div id="copyright"><!-- 이게 있어야 상단에 no back link가 생기지 않는다.  --><a href="http://apycom.com/"></a></div>
		<%--
		<div id="gnb">
        	<ul>
            	<li id="gnb01"><a href="<%=contextPath%>/documentSearch/searchDocument.jsp"><%=subMenu==SUB_MENU_DOCUMENT_SEARCH?"<span class=\"c2\">":"" %>논문검색<%=subMenu==SUB_MENU_DOCUMENT_SEARCH?"</span>":"" %></a></li>
                <li id="gnb02"><a href="<%=contextPath%>/documentSearch/searchNation.jsp"><%=subMenu==SUB_MENU_COUNTRY_SEARCH?"<span class=\"c2\">":"" %>국가검색<%=subMenu==SUB_MENU_COUNTRY_SEARCH?"</span>":"" %></a></li>
				<li id="gnb03"><a href="<%=contextPath%>/documentSearch/catAuthor.jsp"><%=subMenu==SUB_MENU_AUTHOR_SEARCH?"<span class=\"c2\">":"" %>저자검색<%=subMenu==SUB_MENU_AUTHOR_SEARCH?"</span>":"" %></a></li>
                <li id="gnb04"><a href="<%=contextPath%>/documentSearch/catAffilation.jsp"><%=subMenu==SUB_MENU_AFFILATION_SEARCH?"<span class=\"c2\">":"" %>기관검색<%=subMenu==SUB_MENU_AFFILATION_SEARCH?"</span>":"" %></a></li>
                <li id="gnb05"><a href="<%=contextPath%>/documentSearch/searchBoolean.jsp"><%=subMenu==SUB_MENU_BOOLEAN_SEARCH?"<span class=\"c2\">":"" %>고급검색<%=subMenu==SUB_MENU_BOOLEAN_SEARCH?"</span>":"" %></a></li>
                <li id="gnb09"><img src="<%=contextPath %>/images/nn_search_topmenu_img.gif"/></li>
                <li id="gnb06"><a href="<%=contextPath%>/manage/userSearchRuleMain.jsp"><%=subMenu==SUB_MENU_DOCUMENT_MANAGE?"<span class=\"c2\">":"" %>검색식관리<%=subMenu==SUB_MENU_DOCUMENT_MANAGE?"</span>":"" %></a></li>
				<%
                if(DefUtil.AUTH_SUPER.equals(userBean.getAuth())){
                %>
				<li id="gnb07"><a href="<%=contextPath%>/manage/userManageMain.jsp"><%=subMenu==SUB_MENU_USER_MANAGE?"<span class=\"c2\">":"" %>회원관리
				<%=subMenu==SUB_MENU_USER_MANAGE?"</span>":"" %></a></li>
                <li id="gnb08"><a href="<%=contextPath%>/manage/usePlatformMonth.jsp"><%=subMenu==SUB_MENU_USER_USING?"<span class=\"c2\">":"" %>사용자이용현황<%=subMenu==SUB_MENU_USER_USING?"</span>":"" %></a></li>
                <%	
                }
                %>
			</ul>    
       	</div>
       	 --%>
 </div>
