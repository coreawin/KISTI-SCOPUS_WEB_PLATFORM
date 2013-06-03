<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.SourceTypeDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>SCOPUS 정보 검색 플랫폼 - 국가 검색</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />

<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery.js"></script>
<link href="<%=contextPath %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>

<script type="text/javascript" >

var currentDate = new Date();

function PopupWindow(pageName) {
	var cw=640;
	var ch=400;
	var sw=screen.availWidth;
	var sh=screen.availHeight;
	var px=Math.round((sw-cw)/2);
	var py=Math.round((sh-ch)/2);
	window.open(pageName,"","left="+px+",top="+py+",width="+cw+",height="+ch+",toolbar=no,menubar=no,status=yes,resizable=no,scrollbars=yes");
}

var addRowIndexCount = 0;
function addRow(){
	var rows=jQuery("#addTable tr");
	var index = addRowIndexCount++;
	jQuery("#addTable").append(
	 "<tr id=\"dynamicRow_"+index+"\">"
	+"	<td bgcolor=\"#f2f2f2\" height=\"2\"></td>"
	+"</tr>"
	+"<tr id=\"dynamicForm_"+index+"\">"
	+"	<td bgcolor=\"#d9dce1\" class=\"txt3\">"
	+"		<select name=\"searchTermBoolean\" id=\"searchTermBoolean\" style=\"width:85px;\">"
	+"			<option value='AND' selected >AND</option>"
	+"			<option value='OR'>OR</option>"
	+"		</select>"
	+"		<input type=\"text\" id=\"searchTerm\" size='100' class='input_txt1' title='검색어를 입력하세요.' name=\"searchTerm\" />&nbsp;&nbsp;in"
	+"		<select name=\"searchOption\">"
	+"			<option value=\"title,abs,keyword,authorname,affiliation,doi,sourcetitle\">All Field</option>"
	+"			<option value=\"title,abs,keyword\" selected=\"selected\">Article Title + Abstract + Keyword</option>"
	+"			<option value=\"title\">Article Title</option>"
	+"			<option value=\"authorname\">Author Name</option>"
	+"			<option value=\"affiliation\">Affilation Name</option>"
	+"			<option value=\"doi\">DOI</option>"
	+"			<option value=\"abs\">Abstract</option>"
	+"			<option value=\"keyword\">Keyword</option>"
	+"			<option value=\"sourcetitle\">Source Title</option>"
	+"		</select>"
	+"		<a href=\"javascript:deleteRow('"+index+"');\"><img src=\"../images/nn_search_close.gif\" alt=\"rowDelete\" border=\"0\" valign=\"middle\"/></a>"
	+"	</td>"
	+"</tr>"
	);
}

function deleteRow(index){
	var row=jQuery("#dynamicRow_"+index);
	row.remove();
	row=jQuery("#dynamicForm_"+index);
	row.remove();
}

function openAddSearch(obj,obj2){
	document.getElementById(obj2).value="";
	if(document.getElementById(obj).style.display=="none"){
		document.getElementById(obj).style.display="";
	}else{
		document.getElementById(obj).style.display="none";
	}
}


function openAddSearch_type(){
	var form = document.getElementById("frm");
	var ck=form.source_type_ck;
	for(var i=0;i<ck.length;i++){
		ck[i].checked=false;
	}
	if(document.getElementById('openSourceType').style.display=="none"){
		document.getElementById('openSourceType').style.display="";
	}else{
		document.getElementById('openSourceType').style.display="none";
	}
}


function country_add(val){
	var form = document.getElementById("frm");
	selectAddOption(form.sele_country, val);
}
function selectAddOption(obj, val){
	var tmp=val.split(";");
	var value=tmp[0];
	var content="("+tmp[0]+") "+tmp[1];
	var ck=true;
	var new_option = new Option(content, value);

	if(obj.length == 0){
		if(value != "") {
			obj.options.add(new_option,0);
		}
	}else{
		for(var i=0;i<obj.length;i++){
			obj.options[i].seleted=true;
			if(obj.options[i].value==tmp[0]){
				ck=false;
				break;
			}
		}	
		if(ck==true){
			obj.options.add(new_option,0);
		}
	}	
}

function selectlist_del(srcList){
	for( var i =0; i < srcList.options.length ; i++ ) { 
		if ( srcList.options[i] != null && ( srcList.options[i].selected == true ) )	{
			srcList.options[i] = null;
		}
	}
}

function selectlist_all_del(srcList){
	for( var i = srcList.options.length ; i >= 0; i-- ) { 
		srcList.options[i] = null;
	}
}

function yearInit(obj, startYear, endYear, selectedYear){
	for(var i= obj.length-1 ; i>=0 ; i--){
		obj.options[i] = null;
	}
	var idx = 0;
	for(var i= endYear ; i >= startYear  ; i--){
		obj.options[idx] = new Option(i, i);
		if(i==selectedYear){
			obj.options[idx].selected = "selected";
		}
		idx++;
	}
}

function changeYear(selObj){
	var selectedYear = selObj.value;
	var endYear = $("#end_year").get(0).value;
	if(endYear < selectedYear){
		endYear = currentDate.getFullYear();
	}
	yearInit($("#end_year").get(0), selObj.value, currentDate.getFullYear(), endYear);
}

function search(){
	var form = document.getElementById("frm");
	var searchTerm = "";
	var searchOption = "";
	var searchTermBoolean = "";
	var isSuccess = true;
	var isInputSearchTerm = false;
	
	var searchTerms = $("input:text[name=\"searchTerm\"]");
	
	searchTerms.each(function(){
		if(jQuery.trim($(this).val())==""){
			//$(this).val("");
			//alert("검색어를 입력해 주세요.");
			//$(this).focus();
			//isSuccess = false;
			//return false;
		}else{
			isInputSearchTerm = true;
			searchTerm += jQuery.trim($(this).val()) +"`";
		}
	});
	
	if(!isSuccess) return;
	
	var searchOptions = $("select[name=\"searchOption\"] option:selected");
	searchOptions.each(function(){
		searchOption += $(this).val() +"`";
	});
	
	var searchTermBooleans = $("select[name=\"searchTermBoolean\"] option:selected");
	searchTermBooleans.each(function(){
		searchTermBoolean += $(this).val() +"`";
	});
	
	var searchTermValues = searchTerm.split("`");
	var searchOptionValues = searchOption.split("`");
	var searchTermBooleanValues = searchTermBoolean.split("`");
	
	var searchRule = "";
	var filterRule = "";
	
	for(var idx=0; idx<searchTerms.length-1; idx++){
		if(searchTermValues.length > 1 && idx > 0 ){
			searchRule += searchTermBooleanValues[idx-1];
		}
		searchRule += "{"+searchOptionValues[idx] + ":" + searchTermValues[idx] + "}";
	}

	

	//대문자변환 
	writeObj = document.getElementById("country_text");
	writeObj.value = writeObj.value.toUpperCase();
	
	if(isInputSearchTerm){
		if($("input:checked[name=\"publicationChecked\"]").length>0){
                filterRule += "pubyear:section:" + form.first_year.value+"~"+form.end_year.value;
        	}
		filterRule = makeSelectObjFilterRule(document.getElementById("sele_country"), writeObj, "COUNTRY", filterRule );
	}else{
		//검색어가 없다면 국가를 se로 검색한다.
		searchRule = makeSelectObjSearchRule(document.getElementById("sele_country"), writeObj, "COUNTRY");
		filterRule = "";
		if($("input:checked[name=\"publicationChecked\"]").length>0){
                filterRule += "pubyear:section:" + form.first_year.value+"~"+form.end_year.value;
        	}
	}
	
	if(jQuery.trim(document.getElementById("sele_country"))=='' || jQuery.trim(writeObj)==''){
		alert("국가검색에서는 국가코드를 반드시 입력하셔야 합니다.");
		return;
	}
	

	//키워드가 없을 경우에 대한 처리입니다.
        if(searchRule.charAt(searchRule.indexOf("(")+1) == ")"){
           var firstFilter = "";
            if(filterRule == ""){
                      alert("검색어를 입력하거나 조건을 선택해주세요.");
                      isSuccess = false;
                      return false;
            }else{
                if(filterRule.indexOf(",") > 0){
                  firstFilter = filterRule.substring(0,filterRule.indexOf(","));
                  filterRule = filterRule.substring(filterRule.indexOf(",")+1);
                }else{
                  firstFilter = filterRule;
                  filterRule = "";
                }

            }
           var filterElems = firstFilter.split(":");
           if(firstFilter.indexOf(":section:") != -1){
                searchRule = "{"+filterElems[0]+":EXT["+filterElems[2]+"]}";
           }else{
                searchRule = "{"+filterElems[0]+":OR("+filterElems[2].replace(new RegExp(";","gm")," ")+")}";
           }
        }
	
	form.searchRule.value= "se="+searchRule+"&ft="+filterRule;
	//alert(form.searchRule.value);
	form.action="./catresult.jsp";
	form.submit();
}

function makeSelectObjFilterRule(obj, writeObj, title, searchRule) {
	var rule = "";
	var value = jQuery.trim(writeObj.value);
	var values = value.split(" ");
	var valueMap = new Object();

	if (obj.length > 0) {
		rule = title + ":match:";
		for ( var i = 0; i < obj.length; i++) {
			var term = jQuery.trim(obj.options[i].value);
			valueMap[term] = term;
			rule += term;
			if (i < obj.length - 1)
				rule += ";";
		}
		if (value != "") {
			for ( var i = 0; i < values.length; i++) {
				if (valueMap[values[i]] == null) {
					rule += values[i];
				}
				if (i < values.length - 1)
					rule += ";";
			}
		}
		rule = jQuery.trim(rule);
	} else {
		if ("" != value) {
			rule = title + ":match:";
			for ( var i = 0; i < values.length; i++) {
				rule += values[i] + ";";
			}
			rule = jQuery.trim(rule);
		}
	}
	rule = jQuery.trim(rule);

	if ("" != rule) {
		if ("" != searchRule) {
			searchRule += ",";
		}
		searchRule += rule;
	}
	return searchRule;
}
function makeSelectObjSearchRule(obj, writeObj, title) {
	var termList = "";
	var value = jQuery.trim(writeObj.value);
	var values = value.split(" ");
	var valueMap = new Object();

	if (obj.length > 0) {
		for ( var i = 0; i < obj.length; i++) {
			var term = jQuery.trim(obj.options[i].value);
			valueMap[term] = term;
			termList += term;
			if (i < obj.length - 1)
				termList += " ";
		}
		if (value != "") {
			termList += " ";
			for ( var i = 0; i < values.length; i++) {
				if (valueMap[values[i]] == null) {
					termList += values[i];
				}
				if (i < values.length - 1)
					termList += " ";
			}
		}
		termList = jQuery.trim(termList);
	} else {
		if ("" != value) {
			for ( var i = 0; i < values.length; i++) {
				termList += values[i] + " ";
			}
			termList = jQuery.trim(termList);
		}
	}

	return "{"+title+":OR("+termList+")}";
}

$(document).ready(function() {
	yearInit($("#first_year").get(0), 1996, currentDate.getFullYear(), 2001);
	changeYear($("#first_year").get(0));
	
	$(".tipTipClass").tipTip({maxWidth: "auto", edgeOffset: 10});
	$(".bt2").tipTip({maxWidth: "auto", edgeOffset: 10});
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
    	<jsp:param value="<%=SUB_MENU_COUNTRY_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
			<div id="search">
			<% String menuTerm = "국가 검색"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            
            <form name="frm" id="frm" method="post">
            	<input type="hidden" name="deleteSearchRuleSeqs"/>
            	<input type="hidden" name="goPage"/>
            	<input type="hidden" name="searchRule"/>
            	<input type="hidden" name="insertSearchRule" value="true"/>
            <div id="search_choice1">
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
						<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블"  id="addTable"> 
							<tr id="test0">
								<td bgcolor="#d9dce1" class="txt2" style="padding:5px 5px 5px 10px;text-align:left;"><strong>Search for</strong> : 
									<input type="text" id="searchTerm" name="searchTerm" size='100' class='input_txt1 tipTipClass' title="검색어를 입력하세요." >&nbsp;&nbsp;in
									<select name="searchOption">
										<option value="title,abs,keyword,authorname,affiliation,doi,sourcetitle">All Field</option>
										<option value="title,abs,keyword" selected="selected">Article Title + Abstract + Keyword</option>
										<option value="title">Article Title</option>
										<option value="authorname">Author Name</option>
										<option value="affiliation">Affilation Name</option>
										<!--option value="issn">ISSN</option-->
										<option value="doi">DOI</option>
										<option value="abs">Abstract</option>
										<option value="keyword">Keyword</option>
										<option value="sourcetitle">Source Title</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
             	</tr>
       	  		<tr>
       	  		 	<td height="10"></td>
   	  		 	</tr>
                <tr>
       	  		 	<td height="1" bgcolor="#a5b8ff"></td>
   	  		 	</tr>
       	  		<tr>
       	  		 	<td valign="top">
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색선택 테이블">
                            <tr>
                                <td width="170"><strong>Limit to : Date Range</strong></td>
                             	<td width="467">
                             		<input type="checkbox" id="publicationChecked" name="publicationChecked" title="선택하면 선택된 연도 기간에 발행된 논문 검색 결과를 확인할 수 있습니다." class="tipTipClass"/> Published
                                    <select id="first_year" onchange="javascript:changeYear(this);"></select> to
                                    <select id="end_year"></select>
                                </td>
                             	<td width="303" align="right">
                             		<a href="javascript:addRow();" class='tipTipClass' title="검색단어를 추가로 입력할 수 있습니다.">
                             		<img src="<%=contextPath %>/images/nn_search_pluse.gif" align="absmiddle" alt="+"/> <span class="bt">Add Search Field</span></a>　l
									<input type="button"  title="현재 조건으로 검색합니다." class="bt5 tipTipClass" value="Search" title="Search" alt="Search" onclick="javascript:search();"/>
								</td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table> 
	 	 	</div>
            
            <div id="search_choice2">
			 <table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="국가별 테이블">
                            <tr>
                                <td height="25" class="txt">국가별
									<input type="button" value="국가 선택" class="bt1 tipTipClass" onclick="javascript:PopupWindow('./sourceCountryPopup.jsp');" title="버튼을 선택하여 국가코드명을 검색할 수 있습니다." ></td>
                           	</tr>
                            <tr  id="openCountry" >
                           	 	<td colspan="2">
                           	 		<select id="sele_country" name="sele_country" multiple size="5" style="width:930px"></select>
							    </td>
                            </tr>
                            <tr>
                             	<td colspan="2" height="35" align="right">
                              		<div id="submit">
										<input type="button" class='bt2' title="선택하여 등록된 데이터를 전부 삭제합니다." value="전체삭제" onclick="javascript:selectlist_all_del(this.form.sele_country);">
										<input type="button" class='bt2' title="선택한 데이터를 삭제합니다." value="삭제" onclick="javascript:selectlist_del(this.form.sele_country);">
                                    </div></td>
                         	</tr>
                            <tr>
                             	<td colspan="2" class="txt2" >사용자 직접 입력
                             		<img src='../images/system_question_alt_02.png'
                             			class='tipTipClass' title="국가 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." 
                             			style="vertical-align: middle;" border='0'/> 
                             		<input type="text" id="country_text" name="country_text" size='140' class='input_txt1'/>
                             	</td>
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
