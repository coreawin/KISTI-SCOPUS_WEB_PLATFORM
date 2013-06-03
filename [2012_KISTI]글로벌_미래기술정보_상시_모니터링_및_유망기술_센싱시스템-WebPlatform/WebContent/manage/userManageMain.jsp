<%@page import="kr.co.tqk.web.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", UserDao.selectAll().size());
	int viewData = baseRequest.getInteger("viewData",15);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	String searchSelectID = baseRequest.getParameter("searchAuthType", UserAuthEnum.AUTH_ALL.getAuth());
	String searchTerm = baseRequest.getParameter("searchTerm");
	
	String orderColumn = baseRequest.getParameter("orderColumn", "ID");
	String orderType = baseRequest.getParameter("orderType", "desc");
	
	System.out.println("orderColumn " + orderColumn);
	System.out.println("orderType " + orderType);
		
	int waitingIdCnt = UserDao.selectAuthCnt(UserAuthEnum.AUTH_WAITING.getAuth());
	LinkedList<UserBean> list = null;
	if(searchTerm!=null){
		if(UserAuthEnum.AUTH_ALL.getAuth().equals(searchSelectID)){
			list = UserDao.selectAll(searchTerm, currentPage, viewData, orderColumn, orderType);
			totalSize = UserDao.selectSearchTermCnt(searchTerm);
		}else{
			list = UserDao.selectAll(currentPage, viewData, searchSelectID, searchTerm, orderColumn, orderType);
			totalSize = UserDao.selectSearchTermCnt(searchSelectID, searchTerm);
		}
	}else{
		searchTerm = "";
		if(UserAuthEnum.AUTH_ALL.getAuth().equals(searchSelectID)){
			list = UserDao.selectAll(currentPage, viewData, orderColumn, orderType);
		}else{
			list = UserDao.selectAll(currentPage, viewData, searchSelectID, orderColumn, orderType);
			totalSize = UserDao.selectAuthCnt(searchSelectID);
		}
	}
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - 회원 관리</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath()%>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function initPwd(selID){
	
	if(selID=='super'){
		alert("설정할 수 없습니다.");
		return;
	}
	
	if(confirm(selID+ "님의 비밀번호를 초기화하시겠습니까?")){
		var form = document.getElementById("parameter");
		form.selectID.value = selID;
		form.action="./userManageInitPwd.jsp";
		form.submit();
	}
}

function changeAuth(selID, currentAuth){
	if(selID=='super'){
		alert("설정할 수 없습니다.");
		return;
	}
	if($("#selAuth_"+selID+" option:selected").val() != currentAuth){
		if(confirm(selID+ "님의 현재 권한을 " + $("#selAuth_"+selID+" option:selected").text() + "로 변경하시겠습니까? ")){
			var form=document.getElementById("parameter");
			form.selectID.value = selID;
			form.selectAuth.value = $("#selAuth_"+selID+" option:selected").val();
			form.action="./userManageChangeAuth.jsp";
			form.submit();
		}
	}else{
		alert("현재 " + $("#selAuth_"+selID+" option:selected").text() + " 권한을 가지고 있어 변경하려는 권한과 일치합니다.");
	}
}

function removeUser(){
	var form=document.getElementById("parameter");
	var ckeckedIDList = "";
	$("input[name=userCheck]:checkbox").each(
			function() {
				var checked = $(this).attr("checked"); // 체크된 값만을 불러 들인다.
				//console.log(checked +"---"+ this.value);
				if(checked){
					ckeckedIDList += this.value +";";
				}
			}
		);
	//console.log("ckeckedIDList " + ckeckedIDList);
	ckeckedIDList = ckeckedIDList.substr(0, (ckeckedIDList.length-1));
	if(""!=ckeckedIDList){
		if(confirm("선택하신 사용자를 정말 삭제하시겠습니까?")){
			form.removeIDs.value = ckeckedIDList;
			form.action="./userManageDeleteProc.jsp";
			form.submit();
		}
	}else{
		alert("선택된 사용자가 없습니다.");
	}
}

function searchSelectAuthType(selObj){
	searchSelectAuthList(selObj.value);
}

function ordering(column, type){
	var form=document.getElementById("parameter");
	form.orderColumn.value = column;
	form.orderType.value = type;
	form.action="./userManageMain.jsp";
	form.submit();
}

function searchSelectAuthList(value){
	var form=document.getElementById("parameter");
	form.searchAuthType.value = value;
	form.action="./userManageMain.jsp";
	form.submit();
}

function search(){
	var form = document.getElementById("parameter");
	form.searchAuthType.value = document.getElementById("searchSelectAuthType").value;
	form.searchTerm.value = document.getElementById("searchInputID").value;
	form.action="./userManageMain.jsp";
	form.submit();
}

$(document).ready(function() {
	//문서가 준비되었을때
	
	//체크박스가 체크되면 모든 체크박스를 체크한다.
    $("#ckeckAll").click(function() {
        if ($("#ckeckAll:checked").length > 0) {
            $("input:checkbox:not(checked)").attr("checked", "checked");
            $("input:checkbox:disabled").removeAttr("checked");
        } else {
            $("input:checkbox:checked").removeAttr("checked");
        }
    });
});

function searchEnterCheck() {
	getEvent=event.keyCode;
	if (getEvent == "13") {			
		search();
	}
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
			<%
				String menuTerm = "회원 관리";
			%>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				
                <%	
                	if(waitingIdCnt!=0){
                %>
                <tr>
                    <td align="right" colspan="2">
                    	<font color="red" style="font-family: 맑은 고딕">현재 <a href="javascript:searchSelectAuthList('<%=UserAuthEnum.AUTH_WAITING.getAuth()%>');"><%=NumberFormatUtil.getDecimalFormat(waitingIdCnt) %>명</a>의 승인대기 사용자가 존재합니다.</font>
                    </td>
                </tr>
                <%
                	}
                %>
                <tr>
                    <td style="font-family: 맑은 고딕;text-align: left" width="200">
                    	<span style="text-align: left">&nbsp;&nbsp;총 <%= NumberFormatUtil.getDecimalFormat(totalSize) %>명이 조회되었습니다.</span>
                    </td>
                    <td style="font-family: 맑은 고딕;text-align: right">
	                    	권한별 보기 : 
	                    	<select name="searchSelectAuthType" id="searchSelectAuthType" onchange="javascript:searchSelectAuthType(this);" style="font-family: 맑은 고딕">
	                    		<option value="<%=UserAuthEnum.AUTH_ALL.getAuth()%>" <%=searchSelectID.equals(UserAuthEnum.AUTH_ALL.getAuth())?"selected":""%>>전체 보기</option>
	                    		<option value="<%=UserAuthEnum.AUTH_SUPER.getAuth()%>" <%=searchSelectID.equals(UserAuthEnum.AUTH_SUPER.getAuth())?"selected":""%>>관리자만 보기</option>
	                    		<option value="<%=UserAuthEnum.AUTH_GENERAL.getAuth()%>" <%=searchSelectID.equals(UserAuthEnum.AUTH_GENERAL.getAuth())?"selected":""%>>일반 사용자만 보기</option>
	                    		<option value="<%=UserAuthEnum.AUTH_POWER.getAuth()%>" <%=searchSelectID.equals(UserAuthEnum.AUTH_POWER.getAuth())?"selected":""%>>파워 사용자만 보기</option>
	                    		<option value="<%=UserAuthEnum.AUTH_WAITING.getAuth()%>" <%=searchSelectID.equals(UserAuthEnum.AUTH_WAITING.getAuth())?"selected":""%>>승인대기 사용자만 보기</option>
	                    	</select>
	                    	&nbsp;&nbsp;&nbsp;&nbsp;
	                    	회원 검색 : <input type="text" size='40' id='searchInputID' value='<%=searchTerm%>' onkeypress="javascript:searchEnterCheck();"/>
	                    	<input type="button" class="bt5" value="Search" title="현재 조건으로 검색합니다." alt="Search" onclick="javascript:search();"/>
                    </td>
                </tr>
            </table>
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
                                    <th width="120" scope="col" style="padding:2px 2px 2px 2px;"><%=ordering("회원ID", "ID", orderColumn, orderType) %></th>
                                    <th width="100" scope="col" style="padding:2px 2px 2px 2px;"><%=ordering("Name", "NAMES", orderColumn, orderType) %> </th>
                                    <th width="180" scope="col" style="padding:2px 2px 2px 2px;"><%=ordering("E-mail", "EMAIL", orderColumn, orderType) %> </th>
                                    <th width="250" scope="col" style="padding:2px 2px 2px 2px;"><%=ordering("Department", "DEPARTMENT", orderColumn, orderType) %> </th>
                                    <th width="80" scope="col" style="padding:2px 2px 2px 2px;">권한 타입</th>
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
			bgColor = "bgcolor=\"#e4e8ea\"";
		}else{
			bgColor = "";
		}
%>
                                <tr <%=bgColor%>>
                                 	<td height="27" scope="row"><input name="userCheck" id="check1" type="checkbox" value="<%=ub.getId()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_SUPER.getAuth())?"disabled":""%>/></td>
                                    <td style="text-align: center"><%=ub.getId()%></td>
                                 	<td style="text-align: left"><%=ub.getNames()%></td>
                                    <td style="text-align: left"><%=ub.getEmail()%></td>
                                    <td style="text-align: left"><%=ub.getDepartment()%></td>
                                 	<td><select name="selAuth_<%=ub.getId()%>" id="selAuth_<%=ub.getId()%>" style="font-family: 맑은 고딕">
                                        	<option value="<%=UserAuthEnum.AUTH_WAITING.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_WAITING.getAuth())?"selected=\"selected\"":""%>>승인대기</option>
                                        	<option value="<%=UserAuthEnum.AUTH_GENERAL.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_GENERAL.getAuth())?"selected=\"selected\"":""%>>일반</option>
                                        	<option value="<%=UserAuthEnum.AUTH_POWER.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_POWER.getAuth())?"selected=\"selected\"":""%>>파워</option>
                                        	<option value="<%=UserAuthEnum.AUTH_SUPER.getAuth()%>" <%=ub.getAuth().equals(UserAuthEnum.AUTH_SUPER.getAuth())?"selected=\"selected\"":""%>>관리자</option>
                                    	</select></td>
                                    <td  style="text-align: center;">
                                    	<button type="button" id="" name="" class="bt5" title="사용자의 권한을 설정합니다." onclick="javascript:changeAuth('<%=ub.getId()%>', '<%=ub.getAuth()%>');">권한변경</button>
                                    	&nbsp;
                                    	<button type="button" id="" name="" class="bt5" title="비번을 아이디와 동일한 값으로 변경합니다." onclick="javascript:initPwd('<%=ub.getId()%>');">비번초기화</button>
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
                    	<div id="submit" style="font-family: '맑은 고딕';">
                        	<button type="button" class="bt5" onclick="javascript:removeUser();" title="관리자 권한은 삭제할 수 없습니다.">선택 회원삭제</button>
                        	&nbsp;&nbsp;&nbsp;&nbsp;<%=ordering("[등록일  기준 정렬]", "REGIST_DATE", orderColumn, orderType) %>
                        </div></td>
                </tr>
            </table>
            </div>
            	<jsp:include page="../common/paging.jsp" flush="true">
            		<jsp:param value="userManageMain.jsp" name="url"/>
            		<jsp:param value="<%=searchSelectID%>" name="searchAuthType"/>
            		<jsp:param value="<%=searchTerm%>" name="searchTerm"/>
            		<jsp:param value="<%=totalSize %>" name="totalSize"/>
            		<jsp:param value="<%=currentPage %>" name="currentPage"/>
            		<jsp:param value="<%=viewData %>" name="viewData"/>
            		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
			    	<jsp:param name="orderColumn" value="<%=orderColumn%>"/>
			    	<jsp:param name="orderType" value="<%=orderType%>" />
            	</jsp:include>
 	 	</div>
    </div>
    <form id="parameter" method="post">
    	<input type="hidden" name="removeIDs" />
    	<input type="hidden" name="selectID" value="<%=searchSelectID%>"/>
    	<input type="hidden" name="selectAuth"/>
    	<input type="hidden" name="searchAuthType" value="<%=searchSelectID%>" />
    	<input type="hidden" name="searchTerm" value="<%=searchTerm%>"/>
    	<input type="hidden" name="orderColumn" value="<%=orderColumn%>"/>
    	<input type="hidden" name="orderType" value="<%=orderType%>" />
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>
<%!
	private static String ordering(String fieldName, String currentColumn, String orderColumn, String orderType){
		StringBuffer contents = new StringBuffer();
		if(currentColumn.equals(orderColumn)){
			if("asc".equals(orderType)){
				contents.append("<a href=\"javascript:ordering('"+currentColumn+"', 'desc');\">");
				contents.append(fieldName);
				contents.append(" ▽");
			}else{
				contents.append("<a href=\"javascript:ordering('"+currentColumn+"', 'asc');\">");
				contents.append(fieldName);
				contents.append(" △");
			}
		}else{
			contents.append("<a href=\"javascript:ordering('"+currentColumn+"', 'desc');\">");
			contents.append(fieldName);
		}
		
		contents.append("</a>");
		return contents.toString();
	}

%>