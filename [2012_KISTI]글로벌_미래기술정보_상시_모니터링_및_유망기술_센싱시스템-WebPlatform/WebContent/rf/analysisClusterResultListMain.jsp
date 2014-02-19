<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
	int seq = baseRequest.getInteger("seq", -1);
	int update_flag = baseRequest.getInteger("update_flag", -1);
	IResearchFrontDao dao = new ResearchFrontDAO();
	RFAnalysis rfa = dao.selectAnalysis(seq);
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - Research Front</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath()%>/images/favicon.ico" />
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
	$("input[name=userCheck]").each(
			function() {
				var checked = $(this).attr("checked"); // 체크된 값만을 불러 들인다.
				var disabled = $(this).attr("disabled"); // 
				if(checked==true && disabled==false){
					ckeckedIDList += this.value +";";
				}
			}
		);
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
	var form=document.getElementById("parameter");
	form.searchAuthType.value = selObj.value;
	form.action="./userManageMain.jsp";
	form.submit();
}

function search(){
	var form = document.getElementById("parameter");
	form.searchAuthType.value = document.getElementById("searchSelectAuthType").value;
	form.searchID.value = document.getElementById("searchInputID").value;
	form.action="./userManageMain.jsp";
	form.submit();
}

$(document).ready(function() {
	//문서가 준비되었을때
	//체크박스가 체크되면 모든 체크박스를 체크한다.
    $("#ckeckAll").click(function() {
        if ($("#ckeckAll:checked").length > 0) {
            $("input:checkbox:not(checked)").attr("checked", "checked");
            $("input:checkbox:disabled").attr("checked", "");
        } else {
            $("input:checkbox:checked").attr("checked", "");
        }
    });
	
    //height: '302',	
    jQuery("#tableList").jqGrid({
    	mtype :  'POST',
    	url:'./analysisClusterResultListMainGridData.jsp?seq=<%=seq%>&update_flag=<%=update_flag%>',
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
			{name:'clusterNO', fixed:true, formatter:'actions', formatoptions:{keys:true}, index:'CONSECUTIVE_NUMBER', width:'90', height:'50', search:false, align:'left', formatter:checkboxView},			
			{name:'keywordList',index:'KEYWORD', align:'left', sortable: false, formatter:keywordView, cellattr: textWrap},
			{name:'documentCount',index:'DOCUMNET_COUNT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center', formatter:searchDocumentLink},
			{name:'documentReferenceCount',index:'DOCUMENT_REFERENCE_COUNT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center'},
			{name:'referenceCountPerDocument',index:'REFERENCE_COUNT_PER_DOCUMENT', fixed:true, searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, width:'70', sortable: true, align:'center', formatter:decimalFormat},
			{name:'averagePubYearDocument',index:'AVERAGE_PUB_YEAR_DOCUMENT', fixed:true,width:'60', searchoptions:{sopt:['eq', 'lt','le','gt','ge']}, sortable: true, align:'center', cellattr: textWrap, formatter:decimalFormat},
			{name:'reg_date',index:'REG_DATE', fixed:true,width:'60', align:'center', search:false, height:'60', sorttype:'date', hidden:true}
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

	
	function textWrap(rowId, tv, rawObject, cm, rdata) {
		return 'style="white-space: normal;"'; 
	}
	
	function decimalFormat(cellValue, options, rowObject) {
		var decimal = cellValue.toFixed(2);
		return decimal; 
	}
	
	function titleLink(cellValue, options, rowObject){
		var checkedSeq = rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag;
		return "<a href=\"javascript:viewCluster('"+checkedSeq+"');\">" + cellValue +"</a>";
	}
	
	function checkboxView(cellValue, options, rowObject){
		return "<input type='checkbox' name='checkseq' value='"+rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag+"' > "+ titleLink(cellValue, options, rowObject);
	}
	
	function selectedItem(){
		var checkedSeq = "";
		$("input[name=checkseq]").each(function() {
			var value = $(this).attr("value");
			var checked = $(this).attr("checked");
			if(checked){
				checkedSeq += value +";";
			}
	    });
		return checkedSeq;
	} 
	
	function deleteCluster(){
		var checkedSeq = selectedItem();
		if(jQuery.trim(checkedSeq) == ''){
			alert("선택된 항목이 없습니다.");
			return;
		}
		if(confirm("선택된 항목을 정말 삭제하시겠습니까?")){
			$.ajax({
				type: "POST",
				url: "./analysisClusterResultDeleteProc.jsp",
				data: { param: checkedSeq }
				}).done(function( msg ) {
					alert( "선택 항목이 삭제되었습니다.");
					$("#tableList").trigger("reloadGrid");
				});
			 
		}else{
			return;
		}
	}
	function exportCluster(){
		var checkedSeq = selectedItem();
		if(jQuery.trim(checkedSeq) == ''){
			alert("선택된 항목이 없습니다.");
			return;
		}
		if(confirm("선택된 항목에 대한 클러스터 결과를 Export 하시겠습니까?")){
			var url = "./excelDownload.jsp?param="+checkedSeq;
			var name = "excelDownload";
			var spec = "width=0,height=0";
			var wopen = window.open(url,name,spec, true);
			wopen.focus();
		}else{
			return;
		}
		
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
			var url = "./veCluster.jsp?param="+checkedSeq;
			var name = "veCluster";
			var spec = "width=800,height=600,status=no,resizable=yes,scrollbars=yes";
			window.open(url,name,spec, true);
		}
	}
	
	function searchDocumentLink(cellValue, options, rowObject){
		var param = rowObject.seq+"_" + rowObject.consecutiveNumber+"_" + rowObject.updateFlag;
		return "<a href=\"javascript:searchDocument('"+param+"');\">" + cellValue +"</a>";
	}
	
	function searchDocument(param){
		$.ajax({
			type: "POST",
			url: "./getEidData.jsp",
			data: "param="+param,
			beforeSend: function(xhr){
				var form = document.getElementById("searchParameter");
				form.target = "HCPSEARCH";
				form.action="../common/blank.jsp";
				form.submit();
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
		location.href="./analysisMain.jsp";
		
	}
	
	
	function searchRefCit(eidList){
		var form = document.getElementById("searchParameter");
		form.target = "HCPSEARCH";
		form.searchRule.value="se={eid:"+eidList+"}";
		form.action="../documentSearch/catresult.jsp";
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
	<jsp:include page="../inc/topAreaNoJQuerytLink.jsp">
    	<jsp:param value="<%=TOP_MENU_MANAGE %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_USER_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<%
				String menuTerm = "Research Front";
			%>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
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
			            	<input type="button" class="bt5 tipTipClass" value="view cluster info"  onclick="javascript:viewClusterButton();" title="분석된 클러스터에 대한 상세정보를 확인합니다."/>
			            	<input type="button" class="bt5 tipTipClass" value="selected item export"  onclick="javascript:exportCluster();" title="선택한 클러스터 분석 결과를 export 합니다."/>
			            	<%
			            		if(UserAuthEnum.AUTH_SUPER.getAuth().equals(userBean.getAuth())){
			            	%>
			            		<input type="button" class="bt5 tipTipClass" value="selected item delete"  onclick="javascript:deleteCluster();" title="선택한 클러스터 분석 결과를 삭제합니다."/>
			            	<%
					            }
			            	%>
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
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>