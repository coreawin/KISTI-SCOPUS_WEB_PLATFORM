<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<%@include file="./commonNoregist.jsp" %>
<%
	int seq = baseRequest.getInteger("seq", -1);
	int update_flag = baseRequest.getInteger("update_flag", -1);
	IResearchFrontDao dao = new ResearchFrontDAO();
	RFAnalysis rfa = dao.selectAnalysis(seq);
	long currentTime = System.currentTimeMillis();
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - Research Front</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jquery.ui/1.7.3/css/redmond/jquery-ui-1.7.3.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/css/ui.jqgrid.css" />

<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/searchFilter.css" />
<link rel="stylesheet" type="text/css" media="screen" href="<%=contextPath%>/module/jqgrid/plugins/ui.multiselect.css" />

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

<script type="text/javascript">

$(document).ready(function() {
	//문서가 준비되었을때
	
    //height: '302',	
    jQuery("#tableList").jqGrid({
    	mtype :  'POST',
    	url:'<%=serviceURL%>/rf/analysisClusterResultListMainGridData.jsp?seq=<%=seq%>&update_flag=<%=update_flag%>',
    	datatype: "json",
    	width: '970',
    	height:'100%',
    	pager : '#pager',
    	jsonReader:{
   		  root: "rows",
   		  page: "page",
   		  total: "total",
   		  records: "records",
   		  repeatitems: false
   		},
   		colNames:['No', 'Research Fronts (Keyword)', 'Core<br>Papers', 'Citations', 'Citations<br>Per Paper', 'Mean<br>Year', 'Date'],
       	colModel:[
			{name:'clusterNO', fixed:true, formatter:'actions', formatoptions:{keys:true}, index:'CONSECUTIVE_NUMBER', width:'90', search:false, align:'left', formatter:checkboxView},			
			{name:'keywordList',index:'KEYWORD', align:'left', sortable: false, formatter:keywordView, cellattr: textWrap},
			{name:'documentCount',index:'DOCUMNET_COUNT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center', formatter:searchDocumentLink},
			{name:'documentReferenceCount',index:'DOCUMENT_REFERENCE_COUNT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center'},
			{name:'referenceCountPerDocument',index:'REFERENCE_COUNT_PER_DOCUMENT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center', formatter:decimalFormat},
			{name:'averagePubYearDocument',index:'AVERAGE_PUB_YEAR_DOCUMENT', fixed:true,width:'60', searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, sortable: true, align:'center', cellattr: textWrap, formatter:decimalFormat},
			{name:'reg_date',index:'REG_DATE', fixed:true,width:'60', align:'center', search:false, sorttype:'date', hidden:true}
       	],
       	sortorder:"desc",
       	shrinkToFit:true,
       	rownumbers: true,
       	scrollrows: true,
       	emptyrecords: "No records to view",
       	viewrecords: true,
       	gridview: true,
		rowNum:10,
   	   	rowList:[10,20,30],
   	 	caption: "(<%=rfa.getTitle()%>) Research Front Results List"
    });
	
    jQuery("#tableList").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:true,refresh:true},{},{},{},{
    	multipleSearch:false,
		caption: "클러스터 분석 항목 검색",
  		Find: "Find",
  		closeAfterSearch:true,
  		closeAfterReset:true,
	 	ResetOnClose:true,
	 	sopt:['cn','eq']
    },{});
});

	function decimalFormat(cellValue, options, rowObject) {
		var decimal = cellValue.toFixed(2);
		return decimal; 
	}
	
	function textWrap(rowId, tv, rawObject, cm, rdata) {
		return 'style="white-space: normal;"'; 
	}
	
	function titleLink(cellValue, options, rowObject){
		var checkedSeq = rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag;
		return "<a href=\"javascript:viewCluster('"+checkedSeq+"');\">" + cellValue +"</a>";
	}
	
	function checkboxView(cellValue, options, rowObject){
		return titleLink(cellValue, options, rowObject);
		//return "<input type='checkbox' name='checkseq' value='"+rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag+"' > "+ titleLink(cellValue, options, rowObject);
	}
	
	
	function asjcView(cellValue, options, rowObject){
		var datas = cellValue.split(",");
		var data = "";
		for(var i=0; i < datas.length ; i++){
			data += datas[i];
			if(i==8 || i==datas.length-1){
				data += " ";
			}else{
				data += ", ";
			}
			if(i == 8) break;
		}
		return data;
	}
	
	function keywordView(cellValue, options, rowObject){
		var datas = cellValue.split(";");
		var keywords = "";
		for(var i=0; i < datas.length ; i++){
			keywords += datas[i];
			if(i==8 || i==datas.length-1){
				keywords += " ";
			}else{
				keywords += "; ";
			}
			if(i == 8) break;
		}
		return keywords;
	}
	
	function dateF(cellValue, options, rowObject){
		alert(rowObject.reg_date);
	}
	
	function viewClusterButton(){
		viewCluster(selectedItem());
	}
	
	function viewCluster(checkedSeq){
		if(jQuery.trim(checkedSeq) == ''){
			alert("선택된 항목이 없습니다.");
			return;
		}else{
			var url = "<%=serviceURL%>/noregist/veCluster.jsp?param="+checkedSeq;
			var name = "veCluster";
			var spec = "width=800,height=600,status=no,resizable=yes,scrollbars=yes";
			var wopen = window.open(url,name,spec, true);
			wopen.focus();
		}
	}
	
	function searchDocumentLink(cellValue, options, rowObject){
		var param = rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag;
		return "<a href=\"javascript:searchDocument('"+param+"');\">" + cellValue +"</a>";
	}
	
	function searchDocument(param){
		$.ajax({
			type: "POST",
			url: "<%=serviceURL%>/rf/getEidData.jsp",
			data: "param="+param,
			beforeSend: function(xhr){
				var form = document.getElementById("searchParameter");
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
				if("error"==eidList){
					alert("조회할 문서정보가 존재하지 않습니다.");
				}else{
					searchRefCit(eidList);
				}
			}
		});
		
	}
	
	function viewList(){
		location.href="<%=serviceURL%>/noregist/analysisMain.jsp";
	}
	
	
	function searchRefCit(eidList){
		var form = document.getElementById("searchParameter");
		form.target = "HCPSEARCH_<%=currentTime%>";
		form.searchRule.value="se={eid:"+eidList+"}";
		form.action="<%=serviceURL%>/noregist/catresult.jsp";
		form.submit();
	}
	
</script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
    height:50px;
    position:relative;
    text-align:center;
    vertical-align:middle;
}

.ui-jqgrid tr.jqgrow td { height: 40px; white-space: normal !important; }
</style>
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
				<% String menuTerm = "Research Front"; %>
	    		<%@include file="./titleBar.jsp" %>
			</div>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                    	<!-- table cellspacing="0" cellpadding="0" border="0" width="100%">
                    		<tr><td>
                    			범례 : CP (Core papers - 핵심 논문수), Cited by (피인용수), MY (mean year for core papers - 평균연도), CPP (Citations per papers - 핵심논문당 피인용수)
                    		</td></tr>
                    	</table -->
                        <table id="tableList" cellspacing="0" cellpadding="0" border="0" width="100%"></table>
                   		<div id="pager"></div>
                   		<br>
                   		<div style="text-align: right">
			            	<input type="button" class="bt5 tipTipClass" value="Research Front Main"  onclick="javascript:viewList();" title="클러스터 분석 목록으로 이동합니다."/>
			            </div>
                    </td>
             	</tr>
            </table>
            </div>
 	 	</div>
    </div>
    <form id="parameter" method="post">
    	<input type="hidden" name="removeIDs" />
    	<input type="hidden" name="selectID" />
    	<input type="hidden" name="selectAuth" />
    	<input type="hidden" name="searchAuthType" />
    	<input type="hidden" name="searchID" />
    </form>
    
    <form id="searchParameter" method="post">
    	<input type="hidden" name="searchTerm" value="" />
    	<input type="hidden" name="searchRule"/>
    	<input type="hidden" name="currentPage" value="1"/>
    </form>
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="./bottomArea.jsp"/>
    <!--footer_area-->    
</div>
</body>
</html>