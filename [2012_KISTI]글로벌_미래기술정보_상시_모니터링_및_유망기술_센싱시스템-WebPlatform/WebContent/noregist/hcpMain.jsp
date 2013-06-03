<%@page import="kr.co.topquadrant.db.bean.HCPYearInfo"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.io.ObjectOutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="kr.co.topquadrant.db.bean.HCP"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.topquadrant.db.mybatis.HCPParameter"%>
<%@page import="kr.co.topquadrant.db.dao.HCPDao"%>
<%@page import="kr.co.topquadrant.db.dao.IHCPDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<%@include file="./commonNoregist.jsp" %>
<%
	int currentYear = GregorianCalendar.getInstance().get(GregorianCalendar.YEAR);
	double ranking = Double.parseDouble(baseRequest.getParameter("ranking", "0.01"));
	int startYear = baseRequest.getInteger("startYear", currentYear-5);
	int endYear = baseRequest.getInteger("endYear", currentYear-1);
	String largeAsjc = baseRequest.getParameter("largeAsjc", "1000,1100,1300,1500,1600,1700,2100,2200,2300,2400,2500,2600,3000,3100");
	
	Map<String, String> asjcKorea = DescriptionCode.getAsjcTypeKoreaDescription();
	long currentTime = System.currentTimeMillis();
	
	IHCPDao hcpdao = new HCPDao();
	List<HCPYearInfo> yearInfo = hcpdao.selectHCPYearInfo();
	int jqGridStartYear = startYear;
	int jqGridEndYear = endYear;
	
	for(HCPYearInfo yi : yearInfo){
		jqGridEndYear = Math.max(jqGridEndYear, yi.getPublication_year());
		jqGridStartYear = Math.min(jqGridStartYear, yi.getPublication_year());
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - HCP</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jquery.ui/1.7.3/css/redmond/jquery-ui-1.7.3.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/css/ui.jqgrid.css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/searchFilter.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/ui.multiselect.css" />
<style type="text/css">
	td.fcell {position:relative;left:expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:100;}
	th.fcell {position:relative;left:expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:100;}
	tr.fcellTop {position:relative;top:expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:3;}
	.ui-slider {z-index: 10;}
	
	.checkbox, .radio {
		width: 10px;
		height: 10px;
		padding: 0 5px 0 0;
		background: url(../images/checkbox.png) no-repeat;
		display: block;
		clear: left;
		float: left;
	}
</style>
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

<script src="<%=contextPath%>/js/tqk/hashset.js" type="text/javascript"></script>
<script src="<%=contextPath%>/module/jqgrid/src/grid.treegrid.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=contextPath%>/module/FilamentGroup_selectToUISlider/js/jquery-ui-1.7.1.custom.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/module/FilamentGroup_selectToUISlider/js/selectToUISlider.jQuery.js"></script>
<link rel="Stylesheet" href="<%=contextPath%>/module/FilamentGroup_selectToUISlider/css/ui.slider.extras.css" type="text/css" />

<script type="text/javascript" src="<%=contextPath%>/module/dropdown-check-list.1.4/ui.dropdownchecklist-1.4-min.js"></script>
<link rel="Stylesheet" href="<%=contextPath%>/module/dropdown-check-list.1.4/ui.dropdownchecklist.themeroller.css" type="text/css" />

<script type="text/javascript" src="<%=contextPath%>/module/jquery.ui/1.7.3/js/ui.progressbar.min.js"></script>

<script type="text/javascript">

function makeColumnIDModel(){
	var obj = new Object();
	obj.width = 280;
	obj.index='Subject Area';
	obj.name='Subject Area';
	obj.sortable = false;
	obj.frozen = true;
	obj.formatter = titleFormat;
	return obj;
}

function makeColumnModel(hidden, name){
	var obj = new Object();
	obj.width = 60;
	obj.hidden = hidden;
	if(name.indexOf("doc")!=-1){
		obj.align="left";
		obj.formatter = docSearch;
	}else{
		obj.align="right";
		obj.name = name;
		obj.formatter = integer;
	}
	obj.sortable = false;
	obj.resizable = false;
	return obj;
}

function makeGroupHeader(year){
	var obj = new Object();
	obj.startColumnName = "total"+year;
	obj.align="right";
	obj.numberOfColumns = 3;
	obj.titleText = "<center>" + year + "</center>";
	return obj;
}
function checkBox(obj, e){
	 e = e||event;/* get IE event ( not passed ) */
	 e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
}

var endYear = Number(<%=jqGridEndYear%>);
var startYear = Number(<%=startYear%>);

$(document).ready(function() {
    //var endYear = new Date().getFullYear();
    var colNameArray = [];
	var cnt =0;
	colNameArray[cnt++] = "Subject Area";
	for(var year=1995 ;year<=endYear; year++){
		colNameArray[cnt++] = "<em>Total</em>";
		colNameArray[cnt++] = "<span style=\"text-align:left; !important;\"><input type=\"checkbox\" name=\"CHeader"+year+"\" value=\""+year+"\" disabled id=\"CHeader"+year+"\" onclick=\"javascript:checkBox(this, event);\">&nbsp;<em><%=(int)(ranking*100)%>%</em></span>";
		colNameArray[cnt++] = "<em>Threshold</em>";
	}
	
	var groupHeaderCnt = 0;
	var groupHeaderData = [];
	
	var colsCnt = 0;
	var colsModelData = [];
	colsModelData[colsCnt++] = makeColumnIDModel();
	
	for(var year=1995 ;year<=endYear; year++){
		var hidden = true;
		if(year >= <%=startYear%> && year <= <%=endYear%>){
			hidden = false;
			groupHeaderData[groupHeaderCnt++] = makeGroupHeader(year);
		}
		if("<%=ranking%>"=="0.01"){
			colsModelData[colsCnt++] = makeColumnModel(hidden, "total"+year);
			colsModelData[colsCnt++] = makeColumnModel(hidden, "doc"+year);
			colsModelData[colsCnt++] = makeColumnModel(hidden,"");
		}else{
			colsModelData[colsCnt++] = makeColumnModel(true, "total"+year);
			colsModelData[colsCnt++] = makeColumnModel(hidden, "doc"+year);
			colsModelData[colsCnt++] = makeColumnModel(true,"");
		}
	}
    $("#tableList").jqGrid({ 
		//url: 'asjc.json', 
		url: '<%=serviceURL%>/hcp/hcpMainData.jsp?ranking=<%=ranking%>&largeAsjc=<%=largeAsjc%>', 
		datatype: 'json', 
		mtype: 'POST',
		formatter : {
		     integer : {thousandsSeparator: ",", defaultValue: '0'}
		},
		colNames: colNameArray, 
		colModel: colsModelData, 
		treeGridModel: 'adjacency', 
		width: '960',
		height:'400',
		pager: "#pager",
		treeGrid: true, 
		shrinkToFit: false, 
		ExpandColClick: true, 
		ExpandColumn: 'Subject Area',
		gridComplete: function() {
		   	jQuery("#tableList").jqGrid('setGroupHeaders', {useColSpanStyle: true, groupHeaders:groupHeaderData});
		    jQuery("#tableList").jqGrid('setFrozenColumns');
		    /*each doc checkbox click*/
		    registEventClickCheckBox();
		},
		caption: "HCP Table"
	});
    
    $("#tableList").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:false,refresh:false});
    $('select#startYearS, select#endYearS').selectToUISlider({
		labels: 7
	});
    
    $("#largeAsjcS").dropdownchecklist( {
	    icon: { placement: 'right', toOpen: 'ui-icon-circle-triangle-s', toClose: 'ui-icon-circle-triangle-n'},  
    	emptyText: "Select Main Field ", maxDropHeight: 300, width : 400
    });
    
});

function textWrap(rowId, tv, rawObject, cm, rdata) {
	return 'style="white-space: normal;"'; 
}

function docSearch(cellValue, options, rowObject){
	var datas = cellValue.split(";");
	var asjc = datas[0];
	var cnt = datas[1];
	var year = datas[2];
	if(cnt){
		if(cnt == 0) return 0;
		var html = "<input type=\"checkbox\" name=\"Doc"+asjc+"\" id=\"Doc"+year+asjc+"\" value=\""+asjc+"@"+year+"\" onclick=\"javascript:clickDoc(this);\"> ";
		
		if(String(rowObject).indexOf("Total")!=-1){
			html = "<input type=\"checkbox\" name=\"DocTotal"+year+"\" id=\"DocTotal"+year+asjc+"\" value=\""+asjc+"@"+year+"\" onclick=\"javascript:clickDocTotal(this);\"> ";
			return html + addCommas(cnt);
		}
		if(cnt > 1000){
			return html + "<a href=\"javascript:searchDocument('"+asjc+"','"+year+"');\">" + addCommas(cnt) +"</a>";
		}else{
			return html + "<a href=\"javascript:searchDocument('"+asjc+"','"+year+"');\">" + cnt +"</a>";
		}
	}else{
		return 0;
	}
}

function titleFormat(cellValue, options, rowObject){
	var rowData = String(rowObject).replace(cellValue,"");
	var datas = rowData.split(",");
	var asjc = datas[2].split(";")[0];
	var largeAsjc = asjc.substring(0, 2);
	var html = "";
	if(cellValue.indexOf("Total")!=-1){
		html = "<input type=\"checkbox\" name=\"RHeaderTotal"+largeAsjc+"\" id=\"RHeaderTotal"+asjc+"\" value=\""+asjc+"\" onclick=\"javascript:checkBox(this, event);\">&nbsp;&nbsp;";
	}else{
		html = "<input type=\"checkbox\" name=\"RHeader"+largeAsjc+"\" id=\"RHeader"+asjc+"\" value=\""+asjc+"\" onclick=\"javascript:checkBox(this, event);\">&nbsp;&nbsp;";
	}
	return html + cellValue;
}

/**
 * new
 */
function searchSelectedDocuments(){
	/* 검색 대상 항목에 대한 체크 */
	checkedEidList = new HashSet();
	var checkList = "";
	$("input[name^=Doc]:checkbox").each(function() {
		if(this.name.indexOf("Total")!=-1){
			return;
		}
		if(this.checked){
			var ovalues = this.value.split("@");
			var year = ovalues[1];
			if(year >= Number(<%=startYear%>) && year <= Number(<%=endYear%>)){
				checkList += this.value+"_";
			}
		}
	});
	ajaxSelectedDocuments(checkList);
}

function ajaxSelectedDocuments(datas){
	$.ajax({
		type: "POST",
		url: "<%=serviceURL%>/hcp/getEidData.jsp",
		data: "datas="+datas+"&ranking=<%=ranking%>",
		beforeSend: function(xhr){
			var name = "HCPSEARCH_<%=currentTime%>";
			var spec = "width=1200,height=800,status=no,resizable=yes,scrollbars=yes";
			var url = "<%=serviceURL%>/noregist/blank.jsp";
			var wopen = window.open(url,name,spec, true);
			var form = document.getElementById("searchParameter");
			form.target = "HCPSEARCH_<%=currentTime%>";
			wopen.focus();
		},
		success: function(msg){
			var eidList = jQuery.trim(msg);
			searchRefCit(eidList);
		}
	});
	
}

function integer(cellValue, options, rowObject){
	return addCommas(cellValue);
}

function addCommas(nStr){
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2 +"&nbsp;";
}

function searchRange(){
	var form=document.getElementById("parameter");
	form.startYear.value = jQuery("select#startYearS").val();
	form.endYear.value = jQuery("select#endYearS").val();
	form.ranking.value = jQuery("select#rankingS").val();
	form.largeAsjc.value = jQuery("select#largeAsjcS").val();
	form.action="<%=serviceURL%>/noregist/hcpMain.jsp";
	form.submit();
}

function searchDocument(asjc, year){
	$.ajax({
		type: "POST",
		url: "<%=serviceURL%>/hcp/getEidData.jsp",
		data: "asjc="+asjc+"&year="+year+"&ranking=<%=ranking%>",
		beforeSend: function(xhr){
			var form = document.getElementById("searchParameter");
			/*
			form.target = "HCPSEARCH_<%=currentTime%>";
			form.action="<%=serviceURL%>/noregist/blank.jsp";
			form.submit();
			*/
			var name = "HCPSEARCH_<%=currentTime%>";
			var spec = "width=1200,height=800,status=no,resizable=yes,scrollbars=yes";
			var url = "<%=serviceURL%>/noregist/blank.jsp";
			var wopen = window.open(url,name,spec, true);
			var form = document.getElementById("searchParameter");
			form.target = "HCPSEARCH_<%=currentTime%>";
			wopen.focus();
		},
		success: function(msg){
			var eidList = jQuery.trim(msg);
			//$("#progressbar").progressbar({ value: 100 });
			searchRefCit(eidList);
			//$('#tableList').trigger("reloadGrid");
		}
	});
	
}

function searchRefCit(eidList){
	var form = document.getElementById("searchParameter");
	form.target = "HCPSEARCH_<%=currentTime%>";
	form.searchRule.value="se={eid:"+eidList+"}";
	form.action="<%=serviceURL%>/noregist/catresult.jsp";
	form.submit();
}

var cache = new Array();

function registEventClickCheckBox(){
	//console.time("registEventClickCheckBox");
	/*header checkbox click*/
    $('input[name^="CHeader"]:checkbox').click(function() {
    	//console.time("CHeader Click");
    	var parent = this;
    	var name = parent.name;
    	var year = parent.value;
    	//선택된 항목의 전체 row를 살핀다.
    	////console.log("Doc"+asjc.substring(0,2));
   		var objs = $("input[id^='Doc"+year+"']:checkbox");
   		for(var i =0 ; i<objs.length; i++){
   			var obj = objs[i];
   			var values = obj.value.split("@");
   			var asjc = values[0];	
   			//선택된 항목의 세부 분야를 살핀다.
   			setCheckboxChecked("id", "Doc"+year+asjc.substring(0,2), parent.checked);
   			//선택된 항목의 세부 분야 Total을 살핀다.
   			var subID = "Doc"+year+asjc.substring(0,2);
   			var checkName = "DocTotal"+year+asjc.substring(0,2)+"00";
   			setCheckedDomID(getCheckBoxCountInfoJQuery("id", subID), checkName);
   			//한 Row를 살핀다.
			checkName = "RHeader"+asjc;
			setCheckedDomID(_getDomCheckBoxCountInfo("Doc" + asjc), checkName);
   			
			//해당 분야의 Subject Area가 모두 선택되었는지 살핀다.
			checkName = "RHeaderTotal"+asjc.substring(0,2)+"00";
			setCheckedDomID(_getDomCheckBoxCountInfo("RHeader" + asjc.substring(0,2)), checkName);
   		}
   		//console.timeEnd("CHeader Click");
    });
	
	/*Total ASJC Row select*/
    $('input[name^="RHeader"]:checkbox').click(function() {
    	//console.time("RHeader Click");
    	var parent = this;
    	var asjc = parent.value;
    	var name = this.name;
    	if(name.indexOf("Total")!=-1){
    		return;
    	}
    	setCheckboxChecked("name", "Doc"+asjc, parent.checked);
    	
    	for(var year = Number(<%=startYear%>) ; year <= Number(<%=endYear%>) ; year++){
    		//선택된 항목의 세부 분야 Total을 살핀다.
   			var subID = "Doc"+year+asjc.substring(0,2);
   			var checkName = "DocTotal"+year+asjc.substring(0,2)+"00";
   			setCheckedDomID(getCheckBoxCountInfoJQuery("id", subID), checkName);
   			//한 Row를 살핀다.
			checkName = "RHeader"+asjc;
			setCheckedDomID(_getDomCheckBoxCountInfo("Doc" + asjc), checkName);
   			
			//해당 분야의 Subject Area가 모두 선택되었는지 살핀다.
			checkName = "RHeaderTotal"+asjc.substring(0,2)+"00";
			setCheckedDomID(_getDomCheckBoxCountInfo("RHeader" + asjc.substring(0,2)), checkName);
    	}
    	//console.timeEnd("RHeader Click");
    });
    
    $('input[name^="RHeaderTotal"]:checkbox').click(function() {
    	//console.time("RHeaderTotal Click");
    	var parent = this;
    	var asjc = parent.value;
    	setCheckboxChecked("name", "Doc"+asjc.substring(0,2), parent.checked);
    	for(var year = Number(<%=startYear%>) ; year <= Number(<%=endYear%>) ; year++){
    		//선택된 항목의 세부 분야 Total을 살핀다.
   			var subID = "Doc"+year+asjc.substring(0,2);
   			var checkName = "DocTotal"+year+asjc.substring(0,2)+"00";
   			setCheckedDomID(getCheckBoxCountInfoJQuery("id", subID), checkName);
   			
   			//선택된 항목의 연도 전체 column을 살핀다.
   			checkName = "CHeader"+year;
   			setCheckedDomID(_getDomCheckBoxCountInfo("DocTotal" + year), checkName);
    	}
    	//setCheckboxChecked("name", "RHeader"+asjc.substring(0,2), parent.checked);
    	var objs = $("input[name^='RHeader"+asjc.substring(0,2)+"']:checkbox");
    	if(objs){
    		for(var i = 0; i<objs.length ; i++){
    			var obj = objs[i];
    			obj.checked = parent.checked;
    		}
    	}
    	//console.timeEnd("RHeaderTotal Click");
    });
    //console.timeEnd("registEventClickCheckBox");
}

/**
 * new
 */
function _getDomCheckBoxCountInfo(name){
	////console.time("_getDomCheckBoxCountInfo");
	var result = [];
	var totalObjCnt = 0;
	var totalCheckedCnt = 0;
	var objs = document.getElementsByName(name);
	if(objs){
		for(var i = 0; i<objs.length ; i++){
			var obj = objs[i];
			var values = obj.value.split("@");
			if(values.length == 1){
				if(obj.checked){
					totalCheckedCnt++;
				}
				totalObjCnt++;
			}else{
				var year = Number(values[1]);
				if(year >=Number(<%=startYear%>) && year <= Number(<%=endYear%>)){
					if(obj.checked){
						totalCheckedCnt++;
					}
					totalObjCnt++;
				}
			}
		}
	}
	result["TOTAL"] = totalObjCnt;
	result["CHECKED"] = totalCheckedCnt;
	cache["result"+name] = result;
	//console.log("_getDomCheckBoxCountInfo >> " + name +"]" + totalObjCnt + ":" + totalCheckedCnt);
	////console.timeEnd("_getDomCheckBoxCountInfo");
	return result;
}

/**
 * new
 */
function _checkedDomName(name, total, checkCnt){
	if(total!=0){
		if(total == checkCnt){
			document.getElementByName(name).checked = true;
		}else{
			document.getElementByName(name).checked = false;
		}
	}
}

/**
 * new
 */
function _checkedDomName(name, checked){
	var objs = document.getElementByName(name);
	if(objs){
		for(var i=0; i<objs.length ; i++){
			var obj = objs[i];		
			obj.checked = checked;
		}
	}
}

/**
 * new
 */
function _checkedDomId(id, total, checkCnt){
	if(total!=0){
		if(total == checkCnt){
			document.getElementById(id).checked = true;
		}else{
			document.getElementById(id).checked = false;
		}
	}
}

/**
 * new 
 */
function setCheckedDomID(_result, checkName){
	////console.time("setCheckedDomID");
	var cntTotal = _result["TOTAL"];
	var cntChecked = _result["CHECKED"];
	_checkedDomId(checkName, cntTotal, cntChecked);
	////console.timeEnd("setCheckedDomID");
}

/**
 * new
 */
function getCheckBoxCountInfoJQuery(elementName, name){
	//console.time("getCheckBoxCountInfo");
	var result = [];
	var totalObjCnt = 0;
	var totalCheckedCnt = $("input["+elementName+"^="+name+"]:checkbox:checked").length;
	if(cache[name]){
		totalObjCnt = cache[name];
	}else{
		totalObjCnt = $("input["+elementName+"^="+name+"]:checkbox").length;
		cache[name] = totalObjCnt;
	}
	result["TOTAL"] = totalObjCnt;
	result["CHECKED"] = totalCheckedCnt;
	cache["result"+name] = result;
	//console.log("getCheckBoxCountInfoJQuery >> " + totalObjCnt + ":" + totalCheckedCnt);
	//console.timeEnd("getCheckBoxCountInfo");
	return result;
}


/**
 *	new 포함된 메서드 성능향상 완료. 
 * 	complete 1/5
 */
function clickDoc(obj){
	//console.time("clickDoc");
	var name = obj.name;
	var values = obj.value.split("@");
	var asjc = values[0];	
	var year = values[1];
	
	//선택된 항목의 전체 row를 살핀다.
	var checkName = "RHeader"+asjc;
	setCheckedDomID(_getDomCheckBoxCountInfo(name), checkName);
	
	//선택된 항목의 분야에 해당하는 전체 column을 살핀다.
	checkName = "DocTotal"+year+asjc.substring(0,2)+"00";
	setCheckedDomID(getCheckBoxCountInfoJQuery("id", "Doc" + year+asjc.substring(0,2)), checkName);
	
	//선택된 항목의 연도 전체 column을 살핀다.
	checkName = "CHeader"+year;
	setCheckedDomID(_getDomCheckBoxCountInfo("DocTotal" + year), checkName);
	
	//해당 분야의 Subject Area가 모두 선택되었는지 살핀다.
	checkName = "RHeaderTotal"+asjc.substring(0,2)+"00";
	setCheckedDomID(_getDomCheckBoxCountInfo("RHeader" + asjc.substring(0,2)), checkName);
  	//console.timeEnd("clickDoc");
}



/**
 * new 각 연도의 분야별 doc 항목을 선택했을때 발생한다.
 * complete 2/5
 */
function clickDocTotal(obj){
	//console.time("clickDocTotal");
	// name=\"DocTotal"+year+"\" id=\"DocTotal"+year+asjc+"\" value=\""+asjc+"@"+year+"\"
	var name = obj.name;
	var values = obj.value.split("@");
	var asjc = values[0];	
	var year = values[1];
	
	//선택된 항목의 세부 분야를 전체 선택한다.
	setCheckboxChecked("id", "Doc"+year+asjc.substring(0,2), obj.checked);
	
	//선택된 항목의 전체 row를 살핀다.
	checkName = "RHeader"+asjc;
	//console.log("Doc"+asjc.substring(0,2));
	for(var year = Number(<%=startYear%>) ; year <= Number(<%=endYear%>) ; year++){
		var objs = $("input[id^='Doc"+year+asjc.substring(0,2)+"']:checkbox");
		for(var i =0 ; i<objs.length; i++){
			var obj = objs[i];
			var ovalues = obj.value.split("@");
			var oasjc = ovalues[0];	
			var checkName = "RHeader"+oasjc;
			//console.log(year + ": => " + obj.name + "====" + obj.id);
			setCheckedDomID(_getDomCheckBoxCountInfo(obj.name), checkName);
		}
		//선택된 항목의 연도 전체 column을 살핀다.
		checkName = "CHeader"+year;
		setCheckedDomID(_getDomCheckBoxCountInfo("DocTotal" + year), checkName);
	}
	
	//해당 분야의 Subject Area가 모두 선택되었는지 살핀다.
	checkName = "RHeaderTotal"+asjc.substring(0,2)+"00";
	setCheckedDomID(_getDomCheckBoxCountInfo("RHeader" + asjc.substring(0,2)), checkName);
	
	//console.timeEnd("clickDocTotal");
}

/**
 * new
 */
function setCheckboxChecked(elementName, name, checked){
	//var objs = document.getElementsByName(name);
	var objs = $("input["+elementName+"^='"+name+"']:checkbox");
	if(objs){
		for(var i = 0; i<objs.length ; i++){
			var obj = objs[i];
			var values = obj.value.split("@");
			var year = values[1];
			if(year >= Number(<%=startYear%>) && year <= Number(<%=endYear%>)){
				obj.checked = checked;
			}
		}
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
	<jsp:include page="./topArea.jsp">
    	<jsp:param value="<%=TOP_MENU_MANAGE %>" name="TOP_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<% String menuTerm = "HCP"; %>
	    		<%@include file="./titleBar.jsp" %>
			</div>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                	<td>
                        <table cellspacing="5" cellpadding="5" border="0" width="100%">
                        	<tr>
			                    <td class="txt1" style="text-align: left;">
			                    	<select id="largeAsjcS" multiple="multiple">
			                    		<%
			                    			Set<String> asjcSet = asjcKorea.keySet();
			                    		
			                    			for(String asjc : asjcSet){
			                    				if(asjc.substring(2,4).indexOf("00")!=-1){
			                    					String selected = "";
													if(largeAsjc.indexOf(asjc)!=-1){
														selected = "selected=\"selected\"";													
													}
													out.println("<option value=\""+asjc+"\" "+selected+" >"+asjcKorea.get(asjc) + " ("+ asjc+ ")"+"</option>");
			                    				}
			                    			}
			                    		%>
							        </select>
			                    </td>
			                    <td class="txt2" style="text-align: right">
			                    	<label>Publication Year:</label>
			                    </td>
			                    <td width="300" class="txt2" style="text-align: right">
									<fieldset>
										<select name="startYearS" id="startYearS" style="display: none;">
										<%
											for(int year=1995 ; year<= currentYear ; year++){
												String selected = "";
												if(year==startYear){
													selected = "selected=\"selected\"";													
												}
												out.println("<option value=\""+year+"\" "+selected+" >"+year+"년</option>");
											}
										%>
										</select>
										<select name="endYearS" id="endYearS" style="display: none;">
										<%
											for(int year=1995 ; year<= currentYear ; year++){
												String selected = "";
												if(year==endYear){
													selected = "selected=\"selected\"";													
												}
												out.println("<option value=\""+year+"\" "+selected+" >"+year+"년</option>");
											}
										%>
										</select>
									</fieldset>
			                    </td>
			                    <td width="110" class="txt2" style="text-align: right; vertical-align: bottom;">
									Top : 
									<select name="rankingS" id="rankingS">
										<%
											for(double i=0.01d; i<=0.1d ; i=i+0.02d){
												String selected = "";
												if(i==ranking){
													selected = "selected=\"selected\"";													
												}
												int percent = (int)(i * 100);
												if(percent==9) {
													i = 0.1d;
													percent=10;
												}
												
												out.println("<option value=\""+i+"\" "+selected+" >"+(percent)+"%</option>");
											}
										%>
									</select>
			                    </td>
							</tr>
                        	<tr>
                        		<td class="txt1" style="text-align: left;">
                        			<img src="../images/legend.png" border="0" style="text-align: left; vertical-align: middle;"> Unit : Total: 논문편수, <%=(int)(ranking*100)%>%: 논문편수, Threshold: 피인용 횟수
			                    </td>
                        		<td class="txt1" style="text-align: left;">
			                    </td>
			                    <td class="txt1" style="text-align: left;">
			                    </td>
			                    <td valign="bottom" style="text-align: right">
									<input type="button" class="bt5 tipTipClass" value="Search"  onclick="javascript:searchRange();" title="설정 연도로 데이터를 조회합니다."/>
			                    </td>
							</tr>
                        </table>
                    </td>
             	</tr>
                <tr>
                    <td>
                        <table id="tableList" cellspacing="0" cellpadding="0" border="0" width="100%"></table>
                   		<div id="pager"></div>
                   		<span style="font-family:'맑은 고딕'; text-align: left; padding-left: 5px;padding-bottom: 10px;">* 이 정보는 Elsevier사의 SCOPUS DB에서 KISTI가 분석하여 추출한 것입니다.</span>
                    </td>
             	</tr>
            </table>
            </div>
            
            <br>            
            <div style="text-align: right">
            	<input type="button" class="bt5 tipTipClass" value="Search by Selected Documents"  onclick="javascript:searchSelectedDocuments();" title="선택한 항목의 논문 검색 결과를 볼 수 있습니다."/>
            </div>
 	 	</div>
    </div>
    
    <form id="parameter" method="get">
    	<input type="hidden" name="startYear" id="startYearForm" value="<%=startYear %>" />
    	<input type="hidden" name="endYear" id="endYearForm" value="<%=endYear %>"/>
    	<input type="hidden" name="ranking" id="rankingForm" value="<%=ranking%>"/>
    	<input type="hidden" name="largeAsjc" id="largeAsjcForm" value="<%=largeAsjc%>"/>
    </form>
    
    <form id="searchParameter" method="post">
    	<input type="hidden" name="searchTerm" value="" />
    	<input type="hidden" name="searchRule"/>
    	<input type="hidden" name="currentPage" value="1"/>
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <!-- jsp:include page="./bottomArea.jsp"/-->
    <!--footer_area-->    
</div>
</body>
</html>
