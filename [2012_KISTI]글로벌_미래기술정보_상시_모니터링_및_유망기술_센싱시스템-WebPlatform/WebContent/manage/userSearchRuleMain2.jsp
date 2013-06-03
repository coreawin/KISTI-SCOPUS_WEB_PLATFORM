<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", UserDao.selectAll().size());
	int viewData = baseRequest.getInteger("viewData",10);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	LinkedList<UserSearchRuleBean> usrDao = UserSearchRuleDao.selectPagingAll(userBean.getId(), currentPage, viewData);
	totalSize = UserSearchRuleDao.select(userBean.getId()).size();
	
	String searchSelectID = baseRequest.getParameter("searchAuthType", UserAuthEnum.AUTH_WAITING.getAuth());
	String searchID = baseRequest.getParameter("searchID");
	
	LinkedList<UserBean> list = null;
	if(searchID!=null){
		if(UserAuthEnum.AUTH_ALL.getAuth().equals(searchSelectID)){
	list = UserDao.selectAll(searchID, currentPage, viewData);
	totalSize = UserDao.selectSearchTermCnt(searchID);
		}else{
	list = UserDao.selectAll(currentPage, viewData, searchSelectID, searchID);
	totalSize = UserDao.selectSearchTermCnt(searchSelectID, searchID);
		}
	}else{
		searchID = "";
		if(UserAuthEnum.AUTH_ALL.getAuth().equals(searchSelectID)){
	list = UserDao.selectAll(currentPage, viewData);
		}else{
	list = UserDao.selectAll(currentPage, viewData, searchSelectID);
	totalSize = UserDao.selectAuthCnt(searchSelectID);
		}
	}
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - 검색식 관리</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath()%>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function research(objID){
	//이미 했던 검색을 검색식으로만 재실행.
	var form = document.getElementById("parameter");
	form.searchRule.value = $("#"+objID).attr("value");
	form.action="../documentSearch/catresult.jsp";
	form.submit();
}

function deleteSearchRule(){
	var checkedSearchRule = "";
	$('input[name=historySearchRule]:checkbox').each(function() {
    	var value = $(this).attr("value");
		var checked = $(this).attr("checked");
		if(checked){
			checkedSearchRule += value + " ";
		}
    });
	
	if(confirm("선택한 검색식이 삭제됩니다.\n이대로 진행하시겠습니까?")){
		var form = document.getElementById("parameter");
		form.deleteSearchRuleSeqs.value = checkedSearchRule;
		form.action="../manage/deleteSearchRule.jsp";
		form.submit();
	}else{
		return;
	}
}

$(document).ready(function() {
	$("#historySearchRuleAll").click(function() {
        if ($("#historySearchRuleAll:checked").length > 0) {
            $("input[name=historySearchRule]:checkbox:not(checked)").attr("checked", "checked");
            $("input[name=historySearchRule]:checkbox:disabled").attr("checked", "");
        } else {
            $("input[name=historySearchRule]:checkbox:checked").attr("checked", "");
        }
    });
	
});


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
    	<jsp:param value="<%=SUB_MENU_DOCUMENT_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
				<%
					String menuTerm = userBean.getId() + "'s hisoty search";
				%>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            
            <div>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5">
                            <caption>회원정보 리스트 테이블</caption>
                            <colgroup>
                                <col width="3%" span="1">
                            </colgroup>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th scope="col" style="padding:2px 2px 2px 2px;"><input name="check1" id="ckeckAll" type="checkbox" title="관리자를 제외한 회원을 모두 선택합니다."/></th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">회원ID</th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">Name</th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">E-mail</th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">Department</th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">권한 타입</th>
                                    <th scope="col" style="padding:2px 2px 2px 2px;">action</th>
                                </tr>
                            </thead>
                            <tbody>
<%
	String bgColor = "";
	if(list.size()==0){
%>
								<tr bgcolor="#f4f8fa" height='35'>
									<td align='center' colspan='7'> 검색하고자 하는 조건의 회원이 존재하지 않습니다. </td>
								</tr>
<%
	}
	for(UserBean ub: list){
		if("".equals(bgColor)){
	bgColor = "bgcolor=\"#f4f8fa\"";
		}else{
	bgColor = "";
		}
%>
                                <tr height="30" <%=bgColor%>>
                                 	<td height="27" scope="row"><input name="userCheck" id="check1" type="checkbox" value="<%=ub.getId()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_SUPER.getAuth())?"disabled":""%>/></td>
                                    <td><%=ub.getId()%></td>
                                 	<td><%=ub.getNames()%></td>
                                    <td><%=ub.getEmail()%></td>
                                    <td><%=ub.getDepartment()%></td>
                                 	<td><select name="selAuth_<%=ub.getId()%>" id="selAuth_<%=ub.getId()%>">
                                        	<option value="<%=UserAuthEnum.AUTH_GENERAL.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_GENERAL.getAuth())?"selected=\"selected\"":""%>>일반</option>
                                        	<option value="<%=UserAuthEnum.AUTH_SUPER.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_SUPER.getAuth())?"selected=\"selected\"":""%>>관리자</option>
                                    	</select></td>
                                    <td>
                                    	<button type="button" id="" name="" class="bt2" title="사용자의 권한을 설정합니다." onclick="javascript:changeAuth('<%=ub.getId()%>', '<%=ub.getAuth()%>');">권한변경</button>
                                    	&nbsp;
                                    	<button type="submit" id="" name="" class="bt2" title="비번을 아이디와 동일한 값으로 변경합니다." onclick="javascript:initPwd('<%=ub.getId()%>');">비번초기화</button>
                                    </td>
                       	 	 	</tr>
<%		
	}
%>                            
                            </tbody>
                        </table></td>
             	</tr>
            </table>
            <table class="Table_bt" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td align="left">
                    	<div id="submit">
                        	<button type="button" class="bt2" onclick="javascript:removeUser();" title="관리자 권한은 삭제할 수 없습니다.">선택한 회원삭제</button>
                        </div></td>
                </tr>
            </table>
            </div>
            
            	<jsp:include page="../common/paging.jsp" flush="true">
            		<jsp:param value="userManageMain.jsp" name="url"/>
            		<jsp:param value="<%=totalSize %>" name="totalSize"/>
            		<jsp:param value="<%=currentPage %>" name="currentPage"/>
            		<jsp:param value="<%=viewData %>" name="viewData"/>
            		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
            	</jsp:include>
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