<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.io.File"%>
<%@page import="kr.co.tqk.web.util.UtilSearchParameter"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.SortedMap"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" session="true"  contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int totalSize = baseRequest.getInteger("totalSize",0);
	String searchRule = baseRequest.getParameter("searchRule",null);
	String searchTerm = baseRequest.getParameter("searchTerm",null);
	HashSet<String> selectDocSet = (HashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	if(selectDocSet==null) selectDocSet = new HashSet<String>();
	HashMap<String, String> searchParameter = UtilSearchParameter.getSearchParameter(baseRequest);
	//out.println(searchParameter);
	
	Calendar prevMon = Calendar.getInstance();
	prevMon.add(Calendar.MONTH , -1);
	long prev1Month = prevMon.getTime().getTime();

	for(File f : new File(tmpSavePath).listFiles()){
		if(f.length()==0){
			f.delete();
			continue;
		}
		
		long d = f.lastModified();
		if(prev1Month >= d)
			f.delete();
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - Export</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/alphanumeric.js"></script>
<script type="text/javascript">
var popupwin;
function PopupWindow(pageName) {
	var cw=640;
	var ch=150;
	var sw=screen.availWidth;
	var sh=screen.availHeight;
	var px=Math.round((sw-cw)/2);
	var py=Math.round((sh-ch)/2);
	return window.open(pageName,"exportProcPopup","left="+px+",top="+py+",width="+cw+",height="+ch+",toolbar=no,menubar=no,status=yes,resizable=no,scrollbars=yes");
}

function exportPopup(){
	var form = document.getElementById("exportParameter");
	
	if($("#selectDocument").attr("checked")){
		if(<%=selectDocSet.size()%>==0){
			alert("선택된 문서가 존재하지 않습니다.");
			return;
		}
	}
	
	if($("#searchResultRange").attr("checked")){
		if(<%=totalSize%>==0){
			alert("검색된 문서가 존재하지 않습니다.");
			return;
		}
		var startNum = document.getElementById("start_data_range");
		var endNum = document.getElementById("end_data_range");

		if($(":radio[name=exportType]").attr("value")=='excel'){

			if(<%=userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth())%> || <%=userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_POWER.getAuth())%>){
				
			}else{
				if((parseInt(endNum.value) - parseInt(startNum.value)) > 10000){
					alert("최대 다운로드 갯수는 10,000개 입니다.");
					startNum.focus();
					return;
				}
			}
		}
		if(Number(startNum.value) > Number(endNum.value)){
			alert("Number in field 'From' is not correct");
			startNum.focus();
			return;
		}
		
		if(Number(startNum.value) > <%=totalSize%>){
			alert("Number in field 'From' is not correct");
			startNum.focus();
			return;
		}
		
		if(Number(endNum.value) > <%=totalSize%>){
			alert("Number in field 'To' is not correct");
			endNum.value = <%=totalSize%>
			endNum.focus();
			return;
		}
	}
	if(!popupwin){
		popupwin = PopupWindow("");
	}else{
		popupwin.close();
		popupwin = PopupWindow("");
	}
	form.action = "<%=request.getContextPath()%>/common/exportProc.jsp"; // '팝업주소.jsp' 를 form1이 실행될 action 으로 지정한다.
	form.target = "exportProcPopup"; // 이 부분이 핵심! 열어놓은 빈 창(mypop)을 form1이 날아갈 target으로 정한다.
	form.submit(); // target에 쏜다.
}

$(document).ready(function() {
	//필드 체크박스 시나리오.완성 - 절대 field의 체크박스의 name과 id는 수정하지 않는다.
    $("#allCheck").click(function() {
        if ($("#allCheck:checked").length > 0) {
            $("input[name*=_CHECK]:checkbox:not(checked)").attr("checked", "checked");
            $("input[name*=_CHECK]:checkbox:disabled").removeAttr("checked");
        } else {
            $("input[name*=_CHECK]:checkbox:checked").removeAttr("checked");
        }
    });
	/*
    $("input[name=exportType]:radio").click(function() {
    	var value = $(this).attr("value");
    	if(value=="cluster"){
    		 $("#cluster_data_type_selection").show();
    	}else{
    		 $("#cluster_data_type_selection").hide();
    	}
    });
 	$("#cluster_data_type_selection").hide();
    */
    
    $("input[name*=_CHECK]").click(function() {
    	var name = $(this).attr("name");
    	if(name.indexOf("-ALL")==-1){
    		if($("input[name="+name+"]:checked").length == $("input[name="+name+"]").length){
    			$("input[name="+name+"-ALL]").attr("checked", "checked");
    		}else{
    			$("input[name="+name+"-ALL]").removeAttr("checked");
    		}
    	}
    	if($("input[name*=_CHECK-ALL]:checked").length == $("input[name*=_CHECK-ALL]").length){
			$("#allCheck").attr("checked", "checked");
		}else{
			$("#allCheck").removeAttr("checked");
		}
    });
    
    $('input[name*=_data_range]').focus(function() {
   		$('#searchResultRange').attr("checked", "checked");
   	});
    
    $("input[name*=_CHECK-ALL]").click(function() {
    	var name = $(this).attr("name").split("-");
        if ($("#"+name[0]+"-ALL:checked").length > 0) {
            $("input[name="+name[0]+"]:checkbox:not(checked)").attr("checked", "checked");
            $("input[name="+name[0]+"]:checkbox:disabled").removeAttr("checked");
        } else {
            $("input[name="+name[0]+"]:checkbox:checked").removeAttr("checked");
        }
    });
    
    //숫자만 입력
    jQuery("input[name*=_data_range]:text").css("ime-mode", "disabled"); //한글 입력 방지
    jQuery("input[name*=_data_range]:text").numeric();
    
    $("input[name=exportType]:radio").click(function() {
    	var id = $(this).attr("id");
    	if(id == "excelType"){
	   		$("input:checkbox").each(function() {
	   			$(this).attr("disabled", false);
	   		  });
    	}else if(id == "textType"){
    		$("input:checkbox").each(function() {
    			$(this).attr("disabled", false);
	   			$(this).attr("checked", "checked");
	   		  });
    	} else{
    		$("input:checkbox").each(function() {
    			$(this).attr("disabled", true);
    		});
    	}
    	$("input[name=eid]:checkbox").attr("disabled", true);
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
    	<jsp:param value="<%=SUB_MENU_DOCUMENT_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%" align="left" class="tit">
                    	<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" ><img alt="" src="../images/001_40.png" align="bottom" width="16" height="16">
                    		Export
                    	</span>
                    </td>
                    <td width="45%" align="right" class="e-tit"></td>
                </tr>
            </table> 
			</div>

			<form id="exportParameter" method="post">
				<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
				<input type="hidden" name="selectDocSize" value="<%=selectDocSet.size()%>"/>
				<input type="hidden" name="cn" value="<%=searchParameter.get("cn") %>" />
		    	<input type="hidden" name="se" value="<%=searchParameter.get("se").replaceAll("\"", "&quot;") %>" />
		    	<input type="hidden" name="fl" value="<%=searchParameter.get("fl") %>" />
		    	<input type="hidden" name="sn" value="<%=searchParameter.get("sn") %>" />
		    	<input type="hidden" name="ln" value="<%=searchParameter.get("ln") %>" />
		    	<input type="hidden" name="gr" value="<%=searchParameter.get("gr") %>" />
		    	<input type="hidden" name="ra" value="<%=searchParameter.get("ra") %>" />
		    	<input type="hidden" name="ft" value="<%=searchParameter.get("ft") %>" />
		    	<input type="hidden" name="ht" value="<%=searchParameter.get("ht") %>" />
		    	<input type="hidden" name="ud" value="<%=searchParameter.get("ud") %>" />
            <div id="Export_list">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="txt1">
                                                        	<img alt="" src="../images/001_25.png" align="middle" width="12" height="12"> Export format
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table class="Table1_6" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td valign="top">
                                                            <table class="Table1_4" border="0" cellpadding="0" cellspacing="0" align="center" summary="Export 화면 테이블">
                                                            <!-- 
                                                                <tr>
                                                                    <td valign="middle" class="txt3"> <input id="textType" type="radio" name="exportType" value="text" /> Text</td>
                                                                </tr>
                                                             -->
                                                                <tr>
                                                                    <td valign="middle" class="txt3"> <input id="excelType" type="radio" name="exportType" value="excel" checked="checked"/> <b>MS-Excel (.xlsx)</b> 　for MS Excel 2007 spreadsheets</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt3"> <input id="textType" type="radio" name="exportType" value="text" /> <b>Text (.txt)</b>　This file can be used in the cluster tool (Mini Version).</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt3"> <input id="staticsType" type="radio" name="exportType" value="cluster" /> <b>Cluster Analytics</b>　for Cluster Analytics (fixed set of fields) </td>
                                                                </tr>
                                                                <!-- 
                                                                <tr id="cluster_data_type_selection">
                                                                    <td valign="middle" align="right" class="txt3" style="text-align:right;">
                                                                    	<input id="chk1" type="radio" name="cluster_data_type" value="R" checked="checked"/>서지결합법
                                                                    	<input id="chk1" type="radio" name="cluster_data_type" value="C" /> 동시인용분석
                                                                    	<input id="chk1" type="radio" name="cluster_data_type" value="K" /> KISTI Coupling
                                                                    </td>
                                                                </tr>
                                                                 -->
                                                            </table></td>
                                                    </tr>
                                                </table></td>
                                            <td valign="top">
                                            	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="txt1"><img alt="" src="../images/001_25.png" align="middle" width="12" height="12"> Documents to export (Max 10,000)</td>
                                                    </tr>
                                                </table>
                                                <%
                                                	boolean isSelected = false;
                                                	if(selectDocSet.size() > 0){
                                                		isSelected = true;
                                                	}
                                                %>
                                                <table class="Table1_7" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td valign="top">
                                                            <table class="Table1_5" border="0" cellpadding="0" cellspacing="0" align="center" summary="Export 화면 테이블">
                                                                <tr>
                                                                    <td valign="middle" class="txt3">
                                                                    	<input id="searchResultRange" type="radio" name="data_range" value="<%=totalSize %>" <%=!isSelected?"checked='checked'":"" %>/> Search result (<%=NumberFormatUtil.getDecimalFormat(totalSize)%>) 
                                                                    	<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From <input type="text" id="start_data_range" size="10" name="start_data_range" value="1"/> to 
			                                                        	<input type="text" id="end_data_range" size="10" name="end_data_range" value="<%=totalSize > 10000 ? 10000 : totalSize %>"/>
			                                                        	　
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt3">
                                                                    	<input id="selectDocument" type="radio" name="data_range" <%=isSelected?"checked='checked'":"" %> value="-1"/> Selected documents (<%=selectDocSet.size() %>) 
                                                                    </td>
                                                                </tr>
                                                            </table></td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                        
                                        <tr>
                                        	<td colspan="2">
	                                        	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">
                                                    <tr>
                                                        <td class="txt1"><img alt="" src="../images/001_25.png" align="middle" width="12" height="12"> Fields to export</td>
                                                    </tr>
                                                </table>
                                            	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="Export 화면 테이블">
                                                    <tr>
                                                    	<td>　<a href="#"><strong><input name="allCheck" id="allCheck" type="checkbox" value="ALL" /> ALL </strong></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">
                                                            <table class="Table1_3" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td valign="middle" class="txt1"> <input name="BASIC_CHECK-ALL" id="BASIC_CHECK-ALL" type="checkbox" value="-1" /> 논문기본정보</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="eid" type="checkbox" value="EID" disabled="disabled" checked="checked"/> eid</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="TITLE" /> title</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="ABSTRACT" /> Abstract</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="YEAR" /> year</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="DOI" /> DOI</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="KEYWORD" /> Author keyword</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="INDEX_KEYWORD" /> Index keyword</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="ASJC" /> ASJC code</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="NUMBER_CITATION" /> Number of Citation</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="CITATION" /> Citation List (EID) </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="NUMBER_REFERENCE" /> Number of Reference</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="REFERENCE" /> Reference List (EID)</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="BASIC_CHECK" type="checkbox" value="CITATION_TYPE" /> Document Type</td>
                                                                </tr>
                                                            </table></td>
                                                        <td valign="top">
                                                        	<table class="Table1_3" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td valign="middle" class="txt1"> <input name="AUTHOR_CHECK-ALL" id="AUTHOR_CHECK-ALL" type="checkbox" value="-1" /> 부가정보</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AUTHOR_AUTHORINFO" /> 저자기관국가통합정보</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AUTHOR_NAME" /> 저자이름</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AUTHOR_EMAIL" /> 저자이메일</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AUTHOR_COUNTRYCODE" /> 저자국가</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AFFILIATION_NAME" /> 기관정보</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="AUTHOR_CHECK" type="checkbox" value="AFFILIATION_COUNTRY" /> 기관국가</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" height="110" class="txt2"></td>
                                                                </tr>
                                                            </table></td>
                                                        <td valign="top">
                                                        	<table class="Table1_3" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td valign="middle" class="txt1"> <input name="SOUCRCE_CHECK-ALL" id="SOUCRCE_CHECK-ALL"  type="checkbox" value="-1" /> 출처정보</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_SOURCETITLE" /> Source</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_VOLUMN" /> Volumn</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_ISSUE" /> Issue</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_PAGE" /> Page</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_TYPE" /> Source-Type</td>
                                                                <tr>
                                                                <!-- 
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_PUBLICSHERNAME" /> Publisher name</td>
                                                                <tr>
                                                                 -->
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_COUNTRY" /> Country</td>
                                                                <tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_PISSN" /> p-issn</td>
                                                                <tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="SOUCRCE_CHECK" type="checkbox" value="SOURCE_EISSN" /> e-issn</td>
                                                                <tr>
                                                                <tr>
                                                                    <td valign="middle" height="23" class="txt2"></td>
                                                                <tr>
                                                            </table></td>
                                                        <td valign="top">
                                                        	<table class="Table1_3" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td valign="middle" class="txt1"> <input name="CORRES_CHECK-ALL" id="CORRES_CHECK-ALL" type="checkbox" value="-1" /> 교신저자</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="CORRES_CHECK" type="checkbox" value="CORR_AUTHORNAME" /> 저자명</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="CORRES_CHECK" type="checkbox" value="CORR_COUNTRYCODE" /> Country-code</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="CORRES_CHECK" type="checkbox" value="CORR_EMAIL" /> email</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" class="txt2"> <input name="CORRES_CHECK" type="checkbox" value="CORR_AFFILIATION" /> 기관명</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle" height="130" class="txt2"></td>
                                                                <tr>
                                                            </table></td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                    </table>
                                                <table class="Table1_2" border="0" cellpadding="0" cellspacing="0" align="right">
                                                    <tr>
                                                        <td colspan="2" height="35" align="right">
                                                            <div id="submit">
                                                                <button type="button" class="bt5" onclick="javascript:exportPopup();">Export</button>
                                                            </div></td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                    </table>
                         </tr>
                        </table></td>
             	</tr>
            </table>
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
