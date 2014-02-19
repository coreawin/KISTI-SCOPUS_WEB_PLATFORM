<%@page import="kr.co.tqk.web.util.InfoStack.InfoStackType"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.web.FilterSearchRule"%>
<%@page import="kr.co.tqk.web.MakeSearchRule"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.util.SearchParamSessionMap"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.db.dao.ScopusTypeDao"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.db.bean.mgr.UserSearchRuleBean"%>
<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.SourceTypeDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	try{
		
	Map<String, String> sourceTitleMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE));
	Map<String, Integer> sourceTitleFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ));
		
		
	String searchTerm=baseRequest.getParameter("searchTerm","");
	LinkedList<SourceTypeDao> list = new LinkedList<SourceTypeDao>();
	
	list = SearchHandler.selectSourceType();
	int currentPage = baseRequest.getInteger("currentPage",1);
	LinkedList<UserSearchRuleBean> usrDao = UserSearchRuleDao.selectToday(userBean.getId());
	int totalSize = baseRequest.getInteger("totalSize", usrDao.size());
	int viewData = baseRequest.getInteger("viewData",10);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	String searchRule=baseRequest.getParameter("searchRule","");
	
	boolean searchInit = baseRequest.getBoolean("searchInit", false);
	
	if(searchInit){
		session.removeAttribute("SEARCH_FORM");
		searchTerm = "";
	}
	SearchParamSessionMap spsm = (SearchParamSessionMap)session.getAttribute("SEARCH_FORM");
		
	String searchOption = "";
	String sele_asjc = "";
	String insertSearchRule = "";
	String country_text = "";
	String source_text = "";
	String ASJC_text = "";
	
	String filterASJC = "";
	String filterSOURCEID = "";
	String filterCOUNTRY = "";
	String filterSourceType = "";
	String filterCitType = "";
	FilterSearchRule fsr = new FilterSearchRule();
	String[] filterASJCs = null;
	String[] filterCountrys = null;
	String[] filterSourceTitles = null;
	Set<String> sourceTypeSet = new HashSet<String>();
	Set<String> citationTypeSet = new HashSet<String>();
	if(spsm!=null){
		HashMap searchFormParameterMap = spsm.getMap();
		String[] tmp;
		tmp = (String[])searchFormParameterMap.get("searchTerm");
		if(tmp!=null){
			searchTerm = UtilString.nullCkeck(tmp[0]);
		}
		tmp = (String[])searchFormParameterMap.get("searchOption");
		if(tmp!=null){
			searchOption = UtilString.nullCkeck(tmp[0],true);
		}
		System.out.println("searchOption " + searchOption);
		tmp = (String[])searchFormParameterMap.get("insertSearchRule");
		if(tmp!=null){
			insertSearchRule = UtilString.nullCkeck(tmp[0]);
		}
		tmp = (String[])searchFormParameterMap.get("country_text");
		if(tmp!=null){
			country_text = UtilString.nullCkeck(tmp[0]);
		}
		tmp = (String[])searchFormParameterMap.get("ASJC_text");
		if(tmp!=null){
			ASJC_text = UtilString.nullCkeck(tmp[0]);
		}
		tmp = (String[])searchFormParameterMap.get("source_text");
		if(tmp!=null){
			source_text = UtilString.nullCkeck(tmp[0]);
		}
		tmp = (String[])searchFormParameterMap.get("searchRule");
		if(tmp!=null){
			searchRule = UtilString.nullCkeck(tmp[0]);
			fsr = MakeSearchRule.extractSearchRuleFilter(searchRule);
			filterASJC = UtilString.nullCkeck(fsr.getValue("ASJC"));
			filterSOURCEID = UtilString.nullCkeck(fsr.getValue("SOURCEID"));
			filterCOUNTRY = UtilString.nullCkeck(fsr.getValue("COUNTRY"));
			filterSourceType = UtilString.nullCkeck(fsr.getValue("sourcetype"));
			filterCitType = UtilString.nullCkeck(fsr.getValue("cittype"));
			
			filterASJCs = searchFormFilter(filterASJC, ASJC_text, DescriptionCode.getAsjcTypeEngDescription());
			filterCountrys = searchFormFilter(filterCOUNTRY, country_text, DescriptionCode.getCountryType());
			filterSourceTitles = searchFormFilter(filterSOURCEID, source_text, sourceTitleMap);
			
			String[] fsts = filterSourceType.split(";");
			for(String st : fsts){
				sourceTypeSet.add(st);
			}
			String[] fcts = filterCitType.split(";");
			for(String fc : fcts){
				citationTypeSet.add(fc);
			}
		}
	}
	
	session.removeAttribute(userBean.getId() + "_selectDocSet");
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>SCOPUS 정보 검색 플랫폼 - Document Search</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery.js"></script>
<link href="<%=contextPath %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>

<script type="text/javascript" >

function searchFormSetting(){
	<%
		if(filterASJCs!=null){
			for(String asjc : filterASJCs){
				out.println("asjc_add('"+asjc+"');");
			}
		}
		if(filterCountrys!=null){
			for(String c : filterCountrys){
				out.println("country_add('"+c+"');");
			}
		}
		if(filterSourceTitles!=null){
			for(String s : filterSourceTitles){
				out.println("source_add('"+s+"');");
			}
		}
		
		String pubyears = fsr.getValue("pubyear");
		if(pubyears!=null){
			String[] yeara = pubyears.split("~");
			out.println("changeYearInit($(\"#first_year\").get(0), "+yeara[0]+", "+yeara[1]+");");
		}
	%>
}

var currentDate = new Date();

function PopupWindow(pageName) {
	var cw=640;
	var ch=400;
	var sw=screen.availWidth;
	var sh=screen.availHeight;
	var px=Math.round((sw-cw)/2);
	var py=Math.round((sh-ch)/2);
	window.open(pageName,"","left="+px+",top="+py+",width="+cw+",height="+ch+",toolbar=no,menubar=no,status=yes,resizable=yes,scrollbars=yes");
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
	+"                      <option value='NOT'>NOT</option>"
	+"		</select>"
	+"		<input type=\"text\" id=\"searchTerm\" size='100' class='input_txt1 tipTipClass' title='검색어를 입력하세요.' name=\"searchTerm\" />&nbsp;&nbsp;in"
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
	+"		<a href=\"javascript:deleteRow('"+index+"');\"><img src=\"../images/nn_search_close.gif\" alt=\"rowDelete\" border=\"0\" valign=\"middle\" class='tipTipClass' title='' /></a>"
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

function openAddSearch_source(obj,obj2,obj3,obj4){
	var div=document.getElementById(obj3);
	
	if(document.getElementById(obj).style.display=="none"){
		document.getElementById(obj).style.display="";
	}else{
		document.getElementById(obj2).value="";
		document.getElementById(obj4).value="";
		div.innerHTML="";
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

function country_add(val){
	var form = document.getElementById("frm");
	selectAddOption(form.sele_country, val);
}

function source_add(val){
	var form = document.getElementById("frm");
	selectAddOption(form.sele_source, val);
}

function asjc_add(val){
	var form = document.getElementById("frm");
	selectAddOption(form.sele_asjc, val);
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

function changeYearInit(selObj, startYear, endYear){
	for(var idx=0;  idx < selObj.length ; idx++){
		var o = selObj.options[idx];
		if(o.value ==startYear){
			o.selected = "selected";
		}
	}
	yearInit($("#end_year").get(0), startYear, currentDate.getFullYear(), endYear);
}

function search(){

	var form = document.getElementById("frm");
	var searchTerm = "";
	var searchOption = "";
	var searchTermBoolean = "";
	var isSuccess = true;
	
	var searchTerms = $("input:text[name=\"searchTerm\"]");
	searchTerms.each(function(){
		if(jQuery.trim($(this).val())!=""){
			searchTerm += jQuery.trim($(this).val()) +"`";
		}
	});
	
	searchTerm = searchTerm.split(":").join("\\:");
	searchTerm = searchTerm.split(",").join("\\,");
	searchTerm = searchTerm.split("&").join("\\&");
	searchTerm = searchTerm.split("=").join("\\=");
	searchTerm = jQuery.trim(searchTerm);
	
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
	
	var searchTermCount = searchTermValues.length;

	for(var idx=0; idx < searchTermCount - 2 ; idx++){
		searchRule += "{";
	}	
	
	for(var idx=0; idx < searchTermCount - 1 ; idx++){
		if(searchTermCount > 1 && idx > 0 ){
			if(idx-1 > 0){
				searchRule += "}";
			}
			searchRule += searchTermBooleanValues[idx-1];
		}
		searchRule += "{"+searchOptionValues[idx] + ":" + searchTermValues[idx] + ":1:103}";	
	}
	if(searchTermCount-1 > 1){
		searchRule += "}";	
	}

	
	if($("input:checked[name=\"publicationChecked\"]").length>0){
		filterRule += "pubyear:section:" + form.first_year.value+"~"+form.end_year.value;
		//searchRule = makeSearchRule(searchRule, year);
	}

	filterRule = makeSelectObjSearchRule(document.getElementById("sele_asjc"), document.getElementById("ASJC_text"), "ASJC", filterRule );
	filterRule = makeSelectObjSearchRule(document.getElementById("sele_country"), document.getElementById("country_text"), "COUNTRY", filterRule );
	filterRule = makeSelectObjSearchRule(document.getElementById("sele_source"), document.getElementById("source_text"), "SOURCEID", filterRule );

	var sourceTypeSelected = "";
	$("input[name=source_type_ck]").each(function() {
		var value = $(this).attr("value");
		var checked = $(this).attr("checked");
		if(checked){
			sourceTypeSelected += value +";";
		}
    });
	if(sourceTypeSelected!=""){
		if(filterRule == ""){
			filterRule += "sourcetype:match:"+sourceTypeSelected.substr(0, sourceTypeSelected.length-1);
		}else{
			filterRule += ",sourcetype:match:"+sourceTypeSelected.substr(0, sourceTypeSelected.length-1);
		}
	}
	
	var citationTypeSelected = "";
	$("input[name=citation_type_ck]").each(function() {
		var value = $(this).attr("value");
		var checked = $(this).attr("checked");
		if(checked){
			citationTypeSelected += value +";";
		}
    });
	if(citationTypeSelected!=""){
		if(filterRule == ""){
			filterRule += "cittype:match:"+citationTypeSelected.substr(0, citationTypeSelected.length-1);
		}else{
			filterRule += ",cittype:match:"+citationTypeSelected.substr(0, citationTypeSelected.length-1);
		}
	}

	//키워드가 없을 경우에 대한 처리입니다. 
	if(searchTerm.length == 0){
		 if(filterRule == ""){
            alert("검색어를 입력하거나 조건을 선택해주세요.");
            isSuccess = false;
            return false;
	    }
		/*
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
		searchRule = "{"+filterElems[0]+":EXT["+jQuery.trim(filterElems[2])+"]}";
           }else{
		searchRule = "{"+filterElems[0]+":OR("+jQuery.trim(filterElems[2].replace(new RegExp(";","gm")," "))+")}";
	   } 
	   */
		form.searchRule.value= "ft="+filterRule;
	}else{
		form.searchRule.value= "se="+searchRule+"&ft="+filterRule;
	}
	if(window.console) console.log("searchDocument.jsp : " + searchRule);
	//console.log("searchDocument.jsp : " + searchRule);
	//alert(form.searchRule.value);
	form.action="./catresult.jsp";
	form.submit();
}

function makeSelectObjSearchRule(obj, writeObj, title, searchRule){
	var rule = "";
	var value = jQuery.trim(writeObj.value);
	if(value!=""){
		value = " " + value;
	}
	if(title=='COUNTRY'){
		value = value.toUpperCase();
	}
	var values = value.split(" ");
	var valueMap = new Object();
	
	if(obj.length >0){
		rule = title+":match:";
		for(var i=0;i<obj.length;i++){
			var term = jQuery.trim(obj.options[i].value);
			valueMap[term] = term;
			rule += term;
			if(i<obj.length - 1)
				rule += ";";
		}
		if(value!=""){
			for(var i=0 ; i<values.length ; i++){
				if(valueMap[values[i]]==null){
					rule += values[i];
				}
				if(i<values.length - 1)
					rule += ";";
			}
		}
		rule = jQuery.trim(rule);
	}else{
		if("" != value){
			rule = title+":match:";
			for(var i=0 ; i<values.length ; i++){
				rule += values[i] + ";";
			}
			rule = jQuery.trim(rule);
		}
	}
	rule = jQuery.trim(rule);

 	if("" != rule){
            if("" != searchRule){
                    searchRule += ",";
            }
            searchRule += rule;
    }
    return searchRule;
}


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
		form.goPage.value = "/documentSearch/searchDocument.jsp";
		form.action="../manage/deleteSearchRule.jsp";
		form.submit();
	}else{
		return;
	}
}

$(document).ready(function() {
	yearInit($("#first_year").get(0), 1996, currentDate.getFullYear(), 2001);
	changeYear($("#first_year").get(0));
	
	$(".tipTipClass").tipTip({maxWidth: "auto", edgeOffset: 10});
	$(".bt2").tipTip({maxWidth: "auto", edgeOffset: 10});
	
	$("#historySearchRuleAll").click(function() {
        if ($("#historySearchRuleAll:checked").length > 0) {
            $("input[name=historySearchRule]:checkbox:not(checked)").attr("checked", "checked");
            $("input[name=historySearchRule]:checkbox:disabled").attr("checked", "");
        } else {
            $("input[name=historySearchRule]:checkbox:checked").attr("checked", "");
        }
    });
	
	searchFormSetting();
});

function searchFormReset(){
	var form = document.getElementById("frm");
	form.searchInit.value = "true";
	form.action="./searchDocument.jsp";
	form.submit();
}

function fnMore(_id){
	var data = document.getElementById("_more_"+_id);
	var btnLabel = document.getElementById("_more_buttn_label_"+_id);
	if (data.style.display == 'none') {
		data.style.display = '';
		btnLabel.innerText = "close";
	} else {
		data.style.display = 'none';
		btnLabel.innerText = "more";
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
    	<jsp:param value="<%=TOP_MENU_SEARCH %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_DOCUMENT_SEARCH %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
		<div id="content">
			<div id="search">
				<% String menuTerm = "Document Search"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
            <form name="frm" id="frm" method="post">
            	<input type="hidden" name="searchInit" value="false"/>
            	<input type="hidden" name="searchMain" value="true"/>
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
									<input type="text" id="searchTerm" value="<%=searchTerm %>" name="searchTerm" size='100' class='input_txt1 tipTipClass' title="검색어를 입력하세요." >&nbsp;&nbsp;in
									<select name="searchOption">
										<option value="eid-title-abs-keyword-authorname-affiliation-doi-sourcetitle"  <%=(searchOption.equals("eid,title,abs,keyword,authorname,affiliation,doi,sourcetitle")?"selected=\"selected\"":"") %>>All Field</option>
										<option value="eid" <%=(searchOption.equals("eid")?"selected=\"selected\"":"") %>>EID</option>
										<option value="title,abs,keyword" <%=(searchOption.equals("title,abs,keyword") || searchOption.equals("")?"selected=\"selected\"":"") %>>Article Title + Abstract + Keyword</option>
										<option value="title" <%=(searchOption.equals("title")?"selected=\"selected\"":"") %>>Article Title</option>
										<option value="authorname" <%=(searchOption.equals("authorname")?"selected=\"selected\"":"") %>>Author Name</option>
										<option value="affiliation" <%=(searchOption.equals("affiliation")?"selected=\"selected\"":"") %>>Affilation Name</option>
										<!--option value="issn">ISSN</option-->
										<option value="doi" <%=(searchOption.equals("doi")?"selected=\"selected\"":"") %>>DOI</option>
										<option value="abs" <%=(searchOption.equals("abs")?"selected=\"selected\"":"") %>>Abstract</option>
										<option value="keyword" <%=(searchOption.equals("keyword")?"selected=\"selected\"":"") %>>Keyword</option>
										<option value="sourcetitle" <%=(searchOption.equals("sourcetitle")?"selected=\"selected\"":"") %>>Source Title</option>
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
                                <td width="170"><b>Limit to : Date Range</b></td>
                             	<td width="467">
                             		<input type="checkbox" id="publicationChecked" name="publicationChecked" title="선택하면 선택된 연도 기간에 발행된 논문 검색 결과를 확인할 수 있습니다." class="tipTipClass" <%=pubyears==null?"":"checked='checked'" %>/> Published
                                    <select id="first_year" onchange="javascript:changeYear(this);"></select> to
                                    <select id="end_year"></select>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                             		<!-- input type="checkbox" id="pluralChecked" name="pluralChecked" title="입력된 영문 검색어의 단수,복수형 검색 기능을 지원합니다." class="tipTipClass" checked="checked" disabled="disabled"/> Include plural nouns -->
                                </td>
                             	<td width="303" align="right">
                             		<a href="javascript:addRow();" class='tipTipClass' title="검색단어를 추가로 입력할 수 있습니다.">
                             		<img src="<%=contextPath %>/images/nn_search_pluse.gif" align="absmiddle" alt="+"/> <span class="bt">Add Search Field</span></a>　l
									<input type="button" class="bt5 tipTipClass" value="Reset" title="검색 조건을 초기화 합니다." alt="Search Init" onclick="javascript:searchFormReset();"/>
									<input type="button" class="bt5 tipTipClass" value="Search" title="현재 조건으로 검색합니다." alt="Search" onclick="javascript:search();"/>
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
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="ASJC 분류별 테이블">
                            <tr>
                                <td height="25" valign="middle" class="txt">ASJC Code <input type="button" value="Select ASJC Code" id="" name="" class="bt1 tipTipClass" title="버튼을 선택하여 ASJC 코드를 검색할 수 있습니다." onclick="javascript:PopupWindow('./ASJCPopup.jsp');"></td>
                           	</tr>
                            <tr id="openASJC">
                           	 	<td colspan="2">
                           	 		<select id="sele_asjc" name="sele_asjc" multiple size="5" style="width:930px">
									</select>
							    </td>
                            </tr>
                            <tr>
                             	<td colspan="2" height="35" align="right">
                              		<div id="submit">
										<input type="button" class="bt2" title="선택하여 등록된 데이터를 전부 삭제합니다." value="Delete All" onclick="javascript:selectlist_all_del(this.form.sele_asjc);">
										<input type="button" class="bt2" title="선택한 데이터를 삭제합니다." value="Delete" onclick="javascript:selectlist_del(this.form.sele_asjc);">
                                    </div></td>
                         	</tr>
                            <tr>
                             	<td colspan="2" class="txt2" >Enter ASJC Code
                             		<img src='../images/system_question_alt_02.png'
                             			class='tipTipClass' title="ASJC 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." 
                             			style="vertical-align: middle;" border='0'/> 
                             			<input type="text" id="ASJC_text" name="ASJC_text" size='140' class='input_txt1' value="<%=ASJC_text%>"></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table2" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table2_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="국가별 테이블" height="200">
                            <tr>
                                <td height="25" class="txt">Country <input type="button" value="Select Country" class="bt1 tipTipClass" title="버튼을 선택하여 국가를 검색할 수 있습니다." onclick="javascript:PopupWindow('./sourceCountryPopup.jsp');"  ></td>
                           	</tr>
                            <tr  id="openCountry" >
                           	 	<td colspan="2">
                           	 		<select id="sele_country" name="sele_country" multiple size="5" style="width:440px">
									</select>
							    </td>
                            </tr>
                            <tr>
                             	<td colspan="2" height="35" align="right">
                              		<div id="submit">
										<input type="button" class="bt2" title="선택하여 등록된 데이터를 전부 삭제합니다." value="Delete All" onclick="javascript:selectlist_all_del(this.form.sele_country);">
										<input type="button" class="bt2" title="선택한 데이터를 삭제합니다." value="Delete" onclick="javascript:selectlist_del(this.form.sele_country);">
                                    </div></td>
                         	</tr>
                            <tr>
                             	<td colspan="2" class="txt2" >Enter Country Code
                             		<img src='../images/system_question_alt_02.png'
                             			class='tipTipClass' title="국가 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." 
                             			style="vertical-align: middle;" border='0'/> 
                             			<input type="text"  id="country_text" name="country_text" size='50' class='input_txt1' value="<%=country_text%>"/></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table3" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table3_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="출처 타입별 테이블"  height="200">
                            <tr>
                                <td height="25" class="txt">Source Type </td>
                           	</tr>
                            <tr>
                           	 	<td colspan="2">
                           	    	<div class="Table4">
									
											<%
												for(SourceTypeDao dao : list){
													String checked = "";
		                       	    				if(sourceTypeSet.contains(dao.getCode().toUpperCase())){
		                       	    					checked = "checked='checked'";
		                       	    				}
											%> 
													<input type="checkbox" id="source_type_ck" name="source_type_ck" value="<%=dao.getCode().toUpperCase() %>" <%=checked %>> <%=dao.getDescription() %><br>
											<%
												}
											%>
	
                                    </div>
							   </td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="Citation Type별 테이블">
                            <tr>
                                <td height="25" valign="middle" class="txt">Document Type</td>
                           	</tr>
                            <tr>
                           	 	<td colspan="2">
                           	    	<div class="Table4" style="width: 100%">
                           	    		<table>
		                       	    		<%
		                       	    			Map<String, String> citationTypeMap = ScopusTypeDao.getCitationTypeList();
		                       	    			int cellCount = 5;
		                       	    			int citationTRCnt = 0;
		                       	    			for(String key : citationTypeMap.keySet()){
		                       	    				if(citationTRCnt!=0 && citationTRCnt % cellCount ==0 ){
		                       	    					out.println("</tr>");
		                       	    					citationTRCnt = 0;
		                       	    				}
		                       	    				
		                       	    				String value = citationTypeMap.get(key);
		                       	    				if(citationTRCnt==0 || citationTRCnt % cellCount ==0){
		                       	    					out.println("<tr>");
		                       	    				}
		                       	    				out.println("<td width='"+(100/cellCount)+"%'>");
		                       	    				String checked = "";
		                       	    				if(citationTypeSet.contains(key.toUpperCase())){
		                       	    					checked = "checked='checked'";
		                       	    				}
		                       	    				out.println("<input type='checkbox' id='citation_type_ck' name='citation_type_ck' value='"+key.toUpperCase()+"' "+checked+"> " + value);
		                       	    				out.println("</td>");
		                       	    				citationTRCnt++;
		                       	    			}
		                       	    			
		                       	    			if((citationTRCnt-1) % cellCount !=0){
		                       	    				for(int i=0; i<citationTRCnt-1; i++){
		                       	    					out.println("<td>&nbsp;</td>");
		                       	    				}
	                       	    					out.println("</tr>");
		                       	    			}
		                       	    		%>
                           	    		</table>
                                    </div>
							   </td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table6" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
                    	<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="저널별 테이블">
                            <tr>
                                <td height="25" class="txt">Source Title <input type="button" value="Select Source Title" class="bt1 tipTipClass" title="버튼을 선택하여 저널명을 검색할 수 있습니다." onclick="javascript:PopupWindow('./sourcePopup.jsp');"></td>
                           	</tr>
                            <tr id="openSource">
                           	 	<td colspan="2">
                           	 		<select id="sele_source" name="sele_source" multiple size="5" style="width:930px">
									</select>
							    </td>
                            </tr>
                            <tr>
                             	<td colspan="2" height="35" align="right">
                              		<div id="submit">
                                        <input type="button" class="bt2" title="선택하여 등록된 데이터를 전부 삭제합니다." value="Delete All" onclick="javascript:selectlist_all_del(this.form.sele_source);">
										<input type="button" class="bt2" title="선택한 데이터를 삭제합니다." value="Delete" onclick="javascript:selectlist_del(this.form.sele_source);">
                                    </div></td>
                         	</tr>
                            <tr>
                             	<td colspan="2" class="txt2" >Enter Source Title
                             		<img src='../images/system_question_alt_02.png'
                             			class='tipTipClass' title="저널 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." 
                             			style="vertical-align: middle;" border='0'/> 
                             			<input type="text"  id="source_text" name="source_text"  size='140' class='input_txt1' value="<%=source_text%>"/></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색 테이블">
            	<tr>
                    <td width="303" align="right"><input type="button" class="bt5 tipTipClass" title="현재 조건으로 검색합니다." value="Search" alt="Search" onclick="javascript:search();"/></td>
                </tr>
            </table>
	 	 	</div>
            
            <div id="History">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="Table5" >
            	<tr>
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
                                 	<td scope="row"><input name="historySearchRule" id="check1" type="checkbox" value="<%=usrBean.getSeq() %>" /></td>
                                    <td><%=usrBean.getInsertDate() %></td>
                                 	<td  style="color:#2a87d5; text-align:center;"><%=NumberFormatUtil.getDecimalFormat(usrBean.getSearchCount()) %></td>
                                    <td style="color:#005eac; text-align:left;">
                                    	<a href="javascript:research('sendSearchRule_<%=usrBean.getSeq()%>');" class="tipTipClass" title="선택된 검색식으로 논문 검색을 진행합니다.">
                                    		<%
											String searchRules = usrBean.getSearchRule().replaceAll("\\\\:",":").replaceAll("\\\\,",",").replaceAll("\\\\&","&").replaceAll("\\\\=","=").replaceAll("\"","&quot;");
											if(searchRules.length() > 512){
												out.print(searchRules.substring(0, 512));
												out.print("<span id='_more_"+usrBean.getSeq()+"' style='display:none;'>");
												out.print(searchRules.substring(512, searchRules.length()));
												out.print("</span>");
												out.print("<a href=\"javascript:fnMore('"+usrBean.getSeq()+"');\"><span id=\"_more_buttn_label_"+usrBean.getSeq()+"\">more</span></a>");
											}else{
												out.println(searchRules);
											}
											%>
                                    		
                                    	</a>
                                    	<input type="hidden" id="sendSearchRule_<%=usrBean.getSeq()%>" value="<%=usrBean.getSearchRule()%>"/>
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
            
            <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="검색 테이블">
            	<tr>
                    <td width="303" align="right"><input type="button" class="bt5 tipTipClass" title="선택되어진 검색식을 영구적으로 삭제합니다." value="Delete"  alt="SearchRuleDelete" onclick="javascript:deleteSearchRule();"/></td>
                </tr>
            </table>
            
            </div>
            </form>
            <!-- 
            <jsp:include page="../common/paging.jsp" flush="true">
           		<jsp:param value="result.jsp" name="url"/>
           		<jsp:param value="<%=searchTerm %>" name="searchTerm"/>
           		<jsp:param value="<%=searchRule %>" name="searchRule"/>
           		<jsp:param value="<%=totalSize %>" name="totalSize"/>
           		<jsp:param value="<%=currentPage %>" name="currentPage"/>
           		<jsp:param value="<%=viewData %>" name="viewData"/>
           		<jsp:param value="<%=pagingSize %>" name="pagingSize"/>
           	</jsp:include>
           	 -->     
 	 	</div>
    </div>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->   
</div>
</body>
</html>
<%
	session.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE), sourceTitleMap);
	session.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ), sourceTitleFreqMap);
}catch(Exception e){
	e.printStackTrace();
}
%>
<%!
	protected String[] searchFormFilter(String optionData, String textData, Map<String, String>  descriptionMap){
		optionData = optionData.replaceAll(";", " ").replaceAll(textData.trim(), "");
		String[] results = optionData.split(" ");
		for(int i=0; i<results.length; i++){
			String v = results[i].trim();
			if(descriptionMap!=null){
				results[i] = v + ";" + descriptionMap.get(v);
			}else{
				results[i] = v + ";";
			}
		}
		return results;
	}
%>