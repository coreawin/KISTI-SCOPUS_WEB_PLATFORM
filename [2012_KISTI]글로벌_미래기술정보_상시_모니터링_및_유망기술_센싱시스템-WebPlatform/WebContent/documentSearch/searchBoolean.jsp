<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	LinkedList<UserSearchRuleBean> usrDao = UserSearchRuleDao.selectToday(userBean.getId());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - Advanced Search</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery.js"></script>
<script>
function research(objID){
	//이미 했던 검색을 검색식으로만 재실행.
	var form = document.getElementById("frm");
	form.insertSearchRule.value = false;
	form.searchRule.value = $("#"+objID).attr("value");
	form.action="./catresult.jsp";
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
		var form = document.getElementById("frm");
		form.deleteSearchRuleSeqs.value = checkedSearchRule;
		form.goPage.value = "/documentSearch/searchBoolean.jsp";
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
    	<jsp:param value="<%=TOP_MENU_SEARCH %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_BOOLEAN_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<% String menuTerm = "Advanced Search"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
			
            <form method="post" action="./catresult.jsp" id="frm">
            <input type="hidden" name="insertSearchRule" value="true"/>
            <input type="hidden" name="deleteSearchRuleSeqs"/>
            <input type="hidden" name="goPage"/>
            <input type="hidden" name="advanceRule" value="true"/>
	    	<div id="search_choice2">
	    	<table class="Table9" border="0" cellpadding="0" cellspacing="0" style="font-family: 맑은 고딕; !important;">
   	  		 	<tr>
                    <td valign="top" align="left">
                    	<span style="margin: 10px 0px 0px 10px;">
	                    	ex)  oled.ti : scopus TITLE 항목에 대해 oled 키워드로 검색한다. 
                    	</span>
                    </td>
                    <td valign="top" align="right">
                    	<span style="margin: 10px 0px 0px 10px;">
	                    	<!-- a href="../models/fastcatScopusSearchRule.pdf" target="_blank"><u><b>View the manual&nbsp;</b></u></a>&nbsp;&nbsp;&nbsp; -->
                    	</span>
                    </td>
                </tr>
   	  		 	<tr>
                    <td valign="top" colspan='2'>
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                           	 	<td colspan="2">
                           	 		<textarea name="searchRule" rows="7" cols="153" title="" id="searchRule"></textarea></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색 테이블">
            	<tr>
                    <td width="303" align="right"><input type="submit" value="Search" title="Search" alt="Search" class="bt5" /></td>
                </tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="Table5" >
            	<tr>
                    <td height='35' class="txt1" style="text-align: left">검색식 작성방법</td>
                </tr>
                <tr>
                    <td style="text-align: left;width: 53%;vertical-align: text-top;">
                    	<B>&nbsp;&nbsp;1. 단일필드 단일키워드 검색</B><BR> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색키워드.필드명.<BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) oled.ti.<BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) not oled.ti.<BR>
						<B>&nbsp;&nbsp;2. 단일필드 복합키워드 검색(키워드간 AND관계)</B><BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(키워드1 키워드2 … ).필드명<BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) (oled tech).ti.<BR>
						<B>&nbsp;&nbsp;3. 복합필드 복합키워드 검색(필드간은 OR관계, 키워드간은 AND관계)</B><BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(키워드1 키워드2 … ).필드1,필드2.<BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) (oled tech).ti,ab,kw.<BR>
						<B>&nbsp;&nbsp;4. 확장검색 </B><BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색키워드*.필드명.<BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) (oled* tech*).ti.<BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;* 확장검색시 키워드뒤에 "*"를 붙여주며, prefix 검색으로 동작한다. </B><BR>
						<B>&nbsp;&nbsp;5. Boolean필드 Boolean키워드 검색 </B><BR>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(키워드1 키워드2 …).필드1,필드2…. [and|or|not] (키워드1 키워드2 …).필드1,필드2….<BR>
						<B>&nbsp;&nbsp;예) (oled tech).ti. (ips display).abs,kw. </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(oled tech).ti. and (ips display).ab,kw. </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(oled tech).ti. or (ips display).ab,kw. </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(oled tech).ti. not (ips display).ab,kw. </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;* 검색식간 boolean 생략시 AND로 동작하고, 키워드간은 항상 AND로 동작한다.  </B><BR></BR>
                    </td>
                    <td style="text-align: left;width: 47%;" valign="top">
                    	<B>[필드명]</B><BR>
						<B>&nbsp;&nbsp;검색필드 = 필드설명.</B></BR>
                    	<B>&nbsp;&nbsp;ti = title</B><BR> 
                    	<B>&nbsp;&nbsp;au = author name</B><BR> 
                    	<B>&nbsp;&nbsp;kw = keyword</B><BR> 
                    	<B>&nbsp;&nbsp;ab = abstract</B><BR> 
                    	<B>&nbsp;&nbsp;pby = publication year</B><BR> 
                    	<B>&nbsp;&nbsp;asjc = asjc code</B><BR> 
                    	<B>&nbsp;&nbsp;country = country code (3 letter code - USA, KOR)</B><BR></BR> 
						
                    	<B>[필터 형식]</B><BR> 
                    	<B>&nbsp;&nbsp;1. 필터 형식</B><BR> 
						<B>&nbsp;&nbsp;예) @필드 [오퍼레이션] 파라미터</B><BR>
                    	<B>&nbsp;&nbsp;&nbsp;&nbsp;A. @country=CHN</B><BR> 
						<B>&nbsp;&nbsp;&nbsp;&nbsp;B. @country=CHN,KOR</B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;C. @pubyear>=2005<=2011</B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;D. @country=CHN,KOR @pubyear>=2005<=2011 </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;E. @country!=USA @pubyear<=2010 (공백으로 여러필드에 대한 필터를 적용)</B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* 지원오퍼레이션 4가지 : >=, <=, =, != </B><BR>
						<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(>, <는 공식지원하지 않으나, 사용시 >=, <= 와 동일하게 동작한다.  </B><BR></BR>
                    </td>
                </tr>
            </table>
            
			<div id="History">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="Table5" >
            	<tr height='35'>
                    <td class="txt1" style="text-align: left">Today's Search History</td>
                </tr>
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="Table5" style="table-layout:fixed;whitespace:wrap;word-wrap:break-word">
                            <caption>History 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                    <th width="50"  style="padding:2px 2px 2px 2px;"><input name="historySearchRuleAll" id="historySearchRuleAll" type="checkbox" value="1" /></th>
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
 								<tr>
                                 	<td colspan="4">금일 검색한 검색식이 존재하지 않습니다.</td>
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
%>                            
                                <tr height="30" <%=bgcolor %>>
                                 	<td scope="row">
                                 		<input name="historySearchRule" id="check1" type="checkbox" value="<%=usrBean.getSeq() %>" />
                                 		<input type="hidden" id="sendSearchRule_<%=usrBean.getSeq()%>" value="<%=usrBean.getSearchRule()%>"/>
                                 	</td>
                                    <td  ><%=usrBean.getInsertDate() %></td>
                                 	<td  style="color:#2a87d5; text-align:center;"><%=NumberFormatUtil.getDecimalFormat(usrBean.getSearchCount()) %></td>
                                    <td style="color:#005eac; text-align:left;">
                                    	<a href="javascript:research('sendSearchRule_<%=usrBean.getSeq()%>');"><%=usrBean.getSearchRule().replaceAll("\\\\:",":").replaceAll("\\\\,",",").replaceAll("\\\\&","&").replaceAll("\\\\=","=") %></a>
                                    </td>
                       	 	 	</tr>
                                    
<%
		cnt++;
	}
%>
                            </tbody>
                        </table></td>
             	</tr>
            </table>
            
            <table width="100%" class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색 테이블">
            	<tr>
                    <td width="100%" align="right"><input type="button" class="bt5" value="Delete" title="SearchRuleDelete" alt="SearchRuleDelete" onclick="javascript:deleteSearchRule();"/></td>
                </tr>
            </table>
            </div>


          
	 	 	</div>
	 	 	</form>
		</div>
    </div>
    <!--contents_area-->
    
     <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>
