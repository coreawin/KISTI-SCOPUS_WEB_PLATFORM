<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>	
<%@include file="../common/auth.jsp" %>
<%
	String authNaming = userBean.getAuth();
	if(authNaming.equalsIgnoreCase(UserAuthEnum.AUTH_GENERAL.getAuth())){
		authNaming = "일반";
	}else if(authNaming.equalsIgnoreCase(UserAuthEnum.AUTH_POWER.getAuth())){
		authNaming = "파워";
	}else if(authNaming.equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth())){
		authNaming = "관리자";
	}else{
		authNaming = "개발자";
	}
%>
<!-- 
<script src="<%=contextPath%>/module/jqgrid/js/jquery-1.7.2.min.js" type="text/javascript"></script>
 -->
<link type="text/css" href="<%=contextPath%>/module/menu/style3/menu.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/module/menu/style3/menu.js"></script>
<!-- script src="<%=contextPath%>/js/mouseForbid.js" type="text/javascript"></script -->
<div id="top_area" >       
        <div id="header">
        <h1><a href="<%=contextPath%>/"><img src="<%=contextPath%>/images/nn_toplogo.gif" alt="Nano - logo" align="top"/></a></h1>
            <ul id="tnb">
            	<li style="font-family: 맑은 고딕; !important; vertical-align: bottom;"> <small>FastCat Search Engine : <%=FastCatSearchUtil.requestSearchEngineALive(fastcatSearchLiveURL)?"<font color='green'>Running</font>":"<font color='red'>Stop!!</font>"%></small>&nbsp;|&nbsp;</li>
            	<li style="font-family: 맑은 고딕; !important;"> <%=userBean.getId() + " ("+userBean.getNames() + "&nbsp-" + authNaming +")"%> | </li>
				<li style="font-family: 맑은 고딕; !important;">　<a href="<%=contextPath%>/regist/userInfoModify.jsp">회원정보수정</a> | </li>
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
 </div>