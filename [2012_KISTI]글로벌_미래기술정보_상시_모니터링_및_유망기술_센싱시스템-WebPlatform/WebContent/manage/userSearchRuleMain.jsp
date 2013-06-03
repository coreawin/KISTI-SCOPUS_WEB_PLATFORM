<%@page import="kr.co.tqk.web.DWPIQueryConverter"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize",UserDao.selectAll().size());
	int viewData = baseRequest.getInteger("viewData",10);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	
	LinkedList<UserSearchRuleBean> usrDao = UserSearchRuleDao.selectPagingAll(userBean.getId(), currentPage, viewData);
	totalSize = UserSearchRuleDao.select(userBean.getId()).size();
	
	LinkedHashMap<Integer, UserSearchRuleBean> selectUsrSearchBeanMap
	= (LinkedHashMap<Integer, UserSearchRuleBean>) session.getAttribute(userBean.getId() + "_selectSearchRule");
	
	if(selectUsrSearchBeanMap==null){
		selectUsrSearchBeanMap = new LinkedHashMap<Integer, UserSearchRuleBean>();
	}
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - Search History</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script src="<%=contextPath%>/js/tqk/hashset.js" type="text/javascript"></script>

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
            $("input[name=historySearchRule]:checkbox:disabled").removeAttr("checked");
        } else {
            $("input[name=historySearchRule]:checkbox:checked").removeAttr("checked");
        }
        
        var eidList = "";
        $('input[name=historySearchRule]:checkbox').each(function() {
        	var seq = $(this).attr("value");
    		var checked = $(this).attr("checked");
    		var searchRule = $("#sendSearchRule_"+seq).attr("value");
				$.ajax({
				  type: 'POST',
				  url: '../ajax/selectSearchRuleCheckAjax.jsp?seq='+seq+'&checked='+checked+'&searchRule='+searchRule,
				  success: successHandling
				});
        });
    });
	
	$("input[name=historySearchRule]:checkbox").click(function() {
		if($("input[name=historySearchRule]:checkbox:checked").length == $("input[name=historySearchRule]").length){
			$("#historySearchRuleAll").attr("checked", "checked");
		}else{
			$("#historySearchRuleAll").removeAttr("checked");
		}
		var seq = $(this).attr("value");
		var checked = $(this).attr("checked");
		var searchRule = $("#sendSearchRule_"+seq).attr("value");
			$.ajax({
			  type: 'POST',
			  url: '../ajax/selectSearchRuleCheckAjax.jsp?seq='+seq+'&checked='+checked+'&searchRule='+searchRule,
			  success: successHandling
			});
    });
	
	if($("input[name=historySearchRule]:checked").length == $("input[name=historySearchRule]").length){
		$("#historySearchRuleAll").attr("checked", "checked");
	}else{
		$("#historySearchRuleAll").removeAttr("checked");
	}
	
	<%
	for(UserSearchRuleBean b : selectUsrSearchBeanMap.values()){
		String s = b.getSeq()+"|true|"+b.getSearchRule();
		out.println("successHandling('"+s+"');");
	}
	%>
	
});

	function selectInit(){
		$('#selectSearchRuleTable').find("tr:gt(0)").remove();
		
		$.ajax({
		  type: 'POST',
		  url: '../ajax/selectSearchRuleCheckAjax.jsp?allRemove=true'
		});
		
		$('input[name=historySearchRule]:checkbox').each(function() {
    		$(this).attr("checked", false);
        });
		
		$('#mergeSearchRule').removeAttr("value");
		
	}
	
	var mergeSearchRule = "";
	
	function replaceAll(str, searchStr, replaceStr) {
		while (str.indexOf(searchStr) != -1) {
			str = str.replace(searchStr, replaceStr);
		}
		return str;
	}
	
	Array.prototype.unique = function(){
     var a = {};
     for(var i=0; i <this.length; i++){
      if(typeof a[this[i]] == "undefined")
       a[this[i]] = 1;
     }
     this.length = 0;
     for(var i in a)
      this[this.length] = i;
     return this;
    }
	
	Array.prototype.contains = function(v){
		for(var i=0; i <this.length; i++){
			if(this[i] == v) return true;
		}
		return false;
    }
	
	function mergeRule(booleanType) {
		var checkObjs = document.getElementsByName("historySearchRule");
		var delimeter = "@";
		var merge = "";
		var rule = [];
		var ruleCnt = 0;
		var filters = [];
		var filterCnt = 0;
		
		var checkCnt = 0;
		for(var i = 0; i<checkObjs.length ; i++){
			var obj = checkObjs[i];
			var check = obj.checked;
			if(check){
				checkCnt++;
			}
		}
		var runCheckCnt = 1;
		for(var i = 0; i<checkObjs.length ; i++){
			var obj = checkObjs[i];
			var seq = obj.value;
			var check = obj.checked;
			if(check){
				var searchRule = document.getElementById("sendSearchRule_"+seq).value;
				var datas = searchRule.split(" ");
				for(var j=0; j< datas.length ; j++){
					var field = jQuery.trim(datas[j]);
					field = replaceAll(field, "=,", "=");
					if(field.indexOf("@") == 0){
						//filter 필터는 무조건 and검색
						filters[filterCnt++] = field;
					}else{
						rule[ruleCnt++] = field;
					}
				}
				if(checkCnt!=runCheckCnt){
					rule[ruleCnt++] = delimeter;
				}
				runCheckCnt++;
			}
		}
		//rule.unique();
		filters.unique();
		
		//var firstCondition = false;
		for(var i =0; i<rule.length; i++){
			var r = jQuery.trim(rule[i]);
			if(r=="") continue;
			//alert("r : " +rule[i] +"<= \t =>" + (!firstCondition) && (r=="or" || r=="and"));
			//if((firstCondition==false) && (r=="or" || r=="and")){
			//	firstCondition = true;
				//continue;
			//}
			
			if(r==delimeter){
				merge += " " + booleanType +" ";
				continue;
			}

			//if(r=="or" || r=="and"){
				merge += " " + r + " ";
			//	continue;
			//}else{
			//	merge += r;
			//}
			
			
		}
		merge += " ";
		
		for(var i =0; i<filters.length; i++){
			if(jQuery.trim(filters[i])=="") continue;
			merge += filters[i] + " ";
		}
		mergeSearchRuleView(merge);
		
		/*
		$.ajax({
		  type: 'POST',
		  url: '../ajax/mergeSearchRule.jsp?booleanType=' + booleanType,
		  success: mergeSearchRuleView
		});
		*/
		
	}
	
	function mergeSearchRuleView(data) {
		$('#mergeSearchRule').attr("value", jQuery.trim(data));
	}
	
	function successHandling(data) {
		var data = jQuery.trim(data);
		var datas = data.split("|");
		var seq = datas[0];
		var checked = datas[1];
		var searchRule = datas[2];
		if(checked=="true"){
			$('#selectSearchRuleTable').append("<tr id='selectSearchRuleTable_"+seq+"' height='25'><td>"+seq+"</td><td style='text-align:left;'>"+searchRule+"</td></tr>");
		}else{
			$("#selectSearchRuleTable_"+seq).remove();
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
    	<jsp:param value="<%=SUB_MENU_DOCUMENT_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
			<div id="search">
				<% String menuTerm = userBean.getId() + "'s Search History"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
			<br>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5" style="table-layout:fixed;whitespace:wrap;word-wrap:break-word">
                            <caption>History 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th width="50"  style="padding:2px 2px 2px 2px;"><input name="historySearchRuleAll" id="historySearchRuleAll" type="checkbox" value="1" /></th>
                                    <th width="50" style="padding:2px 2px 2px 2px;">No</th>
                                    <th width="150" style="padding:2px 2px 2px 2px;">Date</th>
                                    <th width="100" style="padding:2px 2px 2px 2px;">Results</th>
                                    <th  style="padding:2px 2px 2px 2px;">Query</th>
                                </tr>
                            </thead>
                            <tbody>
<%
	int cnt= 0;
	
	if(usrDao.size()==0){
%>
 								<tr bgcolor="#f4f8fa" height='35'>
                                 	<td colspan="5">금일 검색한 검색식이 존재하지 않습니다.</td>
                       	 	 	</tr>
<%		
	}
	
	for(UserSearchRuleBean usrBean : usrDao){
		String bgcolor = "";
		if(cnt % 2 == 0){
			bgcolor="bgcolor='#f4f8fa'";
		}else{
			bgcolor="";
		}
		String searchRule = usrBean.getSearchRule();
		if(searchRule.startsWith("se=") || searchRule.startsWith("ft=")){
			searchRule = new DWPIQueryConverter().convToDQuery(searchRule);
		}
%>                            
                                <tr height="30" <%=bgcolor %>>
                                 	<td scope="row"><input name="historySearchRule" 
                                 		id="check1" type="checkbox" 
                                 		value="<%=usrBean.getSeq() %>" 
                                 		<%--=selectUsrSearchBeanMap.containsKey(usrBean.getSeq())?"checked":"" --%>/>
                                 		<input type="hidden" id="sendSearchRule_<%=usrBean.getSeq()%>" value="<%= usrBean.getSearchRule()%>"/>
                                 	</td>
                                 	<td scope="row"><%=usrBean.getSeq() %></td>
                                    <td  ><%=usrBean.getInsertDate() %></td>
                                 	<td  style="color:#2a87d5; text-align:center;"><%=NumberFormatUtil.getDecimalFormat(usrBean.getSearchCount()) %></td>
                                    <td style="color:#005eac; text-align:left;"><a href="javascript:research('sendSearchRule_<%=usrBean.getSeq()%>');"><%=usrBean.getSearchRule().replaceAll("\\\\:",":").replaceAll("\\\\,",",").replaceAll("\\\\&","&").replaceAll("\\\\=","=") %></a></td>
                       	 	 	</tr>
<%
		cnt++;
	}
%>
                            </tbody>
                        </table></td>
             	</tr>
            </table>
           	<jsp:include page="../common/paging.jsp" flush="true">
           		<jsp:param value="userSearchRuleMain.jsp" name="url"/>
           		<jsp:param value="<%=totalSize %>" name="totalSize"/>
           		<jsp:param value="<%=currentPage %>" name="currentPage"/>
           		<jsp:param value="<%=viewData %>" name="viewData"/>
           		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
           	</jsp:include>
            <table class="Table_bt" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td align="left">
                    	<div id="submit">
                        	<input type="button" class="bt5" value="Delete" title="SearchRuleDelete" alt="SearchRuleDelete" onclick="javascript:deleteSearchRule();"/>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <BR>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table id="selectSearchRuleTable" cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5" style="table-layout:fixed;whitespace:wrap;word-wrap:break-word">
                            <caption>선택된 검색식 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th width="50" style="padding:2px 2px 2px 2px;">No</th>
                                    <th style="padding:2px 2px 2px 2px;">Combine queries</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table></td>
             	</tr>
            </table>
            <table class="Table_bt" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td align="right">
                    	<div id="submit">
                        	<input type="button" class="bt5" value="OR Combination" title="선택된 검색식을 OR 조건으로 합칩니다." alt="SearchRuleDelete" onclick="javascript:mergeRule('or');"/>
                        	<input type="button" class="bt5" value="AND Combination" title="선택된 검색식을 AND 조건으로 합칩니다." alt="SearchRuleDelete" onclick="javascript:mergeRule('and');"/>
                        	<input type="button" class="bt5" value="Clear All" title="선택된 검색식을 초기화합니다." alt="SearchRuleDelete" onclick="javascript:selectInit();"/>
                        </div></td>
                </tr>
            </table>
            <form method="post" action="../documentSearch/catresult.jsp" id="frm">
	            <input type="hidden" name="insertSearchRule" value="true"/>
	            <table width="100%" border="0" cellpadding="0" cellspacing="0">
	                <tr height="60">
	                    <td>
	                    	<textarea rows='10' style="width: 100%;" cols="10" id="mergeSearchRule" name="searchRule"></textarea>    
	                    </td>
	             	</tr>
	            </table>
	            <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색 테이블">
	            	<tr>
	                    <td width="303" align="right"><input type="submit" value="Search" title="Search" alt="Search" class="bt5" /></td>
	                </tr>
	            </table>
	        </form>
            </div>
 	 	</div>
    </div>
    <form method="post" id="parameter">
		<input type="hidden" name="insertSearchRule" value="false"/>
		<input type="hidden" name="deleteSearchRuleSeqs"/>
		<input type="hidden" name="searchRule"/>
		<input type="hidden" name="goPage" value="/manage/userSearchRuleMain.jsp"/>
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>