<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.tqk.web.util.UserAuthDefinition.UserAuthEnum"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<title>SCOPUS 정보 검색 플랫폼 - Research Front</title>
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
    	url:'./analysisMainGridData.jsp',
    	datatype: "json",
    	width: '960',
    	height:'100%',
    	jsonReader:{
     		root: "rows",
     		page: "page",
     		total: "total",
     		records: "records",
			repeatitems: false
		},
    	pager : '#pager',
       	colNames:['No', 'Mirian Service(YES OR NO)', 'Title', 'ASJC Code', 'Description', 'Science', 'Nature', 'Date', 'Update', 'Export'],
       	colModel:[
			{name:'seq', index:'SEQ', hidden:true},
			{name:'showMirian',index:'SHOW_MIRIAN', width:'50', align:'center', formatter:mirianLink},
			{name:'title', index:'title', search:true, align:'left', formatter:titleLink, cellattr: textWrap},
			{name:'asjcList',label:'asjcList', search:false, searchoptions:{sopt:['cn']}, align:'left', sortable: false, jsonmap:"asjcList",
		          formatter: function (cellvalue) {
		              return cellvalue.join(" ");
		          }, cellattr: textWrap},
			{name:'description',index:'DESCRIPTION', searchoptions:{sopt:['cn']}, sortable: false, align:'left', cellattr: textWrap},
			{name:'add_science',index:'ADD_SCIENCE', stype:'select', searchoptions:{sopt:['eq'], value:"Y:Y;N:N"}, width:'40', align:'center'},
			{name:'add_nature',index:'ADD_NATURE', stype:'select', searchoptions:{sopt:['eq'], value:"Y:Y;N:N", attr:{title:'Select Science'}}, width:'40', align:'center'},
			{name:'reg_date_first',index:'REG_DATE_FIRST', width:'60', align:'center', sorttype:'date'},
			{name:'update_flag',index:'update_flag', width:'30', align:'center', sortable: false,},
			{name:'excelExport',width:'60', align:'center', formatter:makeAction, sortable : false}
       	],		
       	sortorder:"desc",
       	shrinkToFit:true,
       	rownumbers: true,
       	gridview: true,
		rowNum:10,
   	   	rowList:[10,20,30],
       	caption: "Research Front List"
    });
    jQuery("#tableList").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:true,refresh:true},{},{},{},{
    	multipleSearch:false,
		caption: "Research Front 항목 검색",
  		Find: "Find",
  		closeAfterSearch:true,
  		closeAfterReset:true,
	 	ResetOnClose:true,
	 	sopt:['cn','eq']
    },{});
    
});

	function modifyGrid(){
		var id = jQuery("#tableList").jqGrid('getGridParam','selrow');
		if(!id) return;
		var data = jQuery("#tableList").jqGrid('getRowData');
		var seq = data[Number(id)-1].seq;
		if (seq)	{
			if(confirm('선택된 항목을 수정하시겠습니까?')){
				location.href = "./modifyAnalysis.jsp?seq="+seq;
			}
		}
	}
	
	function deleteGrid(){
		var id = jQuery("#tableList").jqGrid('getGridParam','selrow');
		if(!id) return;
		var data = jQuery("#tableList").jqGrid('getRowData');
		var seq = data[Number(id)-1].seq;
		if (seq)	{
			if(confirm('선택된 항목을 삭제하시겠습니까?')){
				$.ajax({
					type: "GET",
					url: "./deleteAnalysis.jsp",
					data: "seq="+seq,
					success: function(msg){
						alert("데이터가 삭제되었습니다."); 
						$('#tableList').trigger("reloadGrid");
					}
				});
			}
		}
	}
	
	function textWrap(rowId, tv, rawObject, cm, rdata) {
		return 'style="white-space: normal;"'; 
	}

	function mirianLink(cellValue, options, rowObject){
		var select = "";
		if(<%=(userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth()))%>){
			select = "<select onChange=\"javascript:mirianChange(this,'"+rowObject.seq+"');\">";
			if(cellValue.toUpperCase() == '<%=MyBatisParameter.Y%>'){
				select+="<option value='<%=MyBatisParameter.N%>'>None</option>";
				select+="<option value='<%=MyBatisParameter.Y%>' selected>Service</option>";
			}else{
				select+="<option value='<%=MyBatisParameter.N%>'selected>None</option>";
				select+="<option value='<%=MyBatisParameter.Y%>'>Service</option>";
			}
			select+="</select>";
		}else{
			select = cellValue;
			if(cellValue==""){
				select = "N";
			}
		}
		
		return select;
	}
	
	function mirianChange(selObj, seq){
		var param = "seq=" + seq +"&showMirian="+selObj.value;
		var question = "Mirian 외부 서비스에 표출하시겠습니까?";
		var result = "Mirian 외부 서비스로 표출되었습니다.";
		if(selObj.value.toUpperCase() == '<%=MyBatisParameter.N%>'){
			question = "더 이상 Mirian 외부 서비스에서 표출하지 않겠습니까?";
			result = "Mirian 외부 서비스에서 제외되었습니다.";
		}
		if(confirm(question)){
			$.ajax({
				type: "GET",
				url: "./updateShowMirian.jsp",
				data: param,
				success: function(msg){
					alert(result);
				}
			});
		}else{
			var optionsList = selObj.options;
			var selected = selObj.value;
			for (var i=0;i<optionsList.length;i++){
				if(optionsList[i].value == selected){
					optionsList[i].selected = false;		
				}else{
					optionsList[i].selected = true;
				}
			}
		}
	}
	
	function titleLink(cellValue, options, rowObject){
		//alert(cellValue+'\t' + options +'\t' + rowObject);
		return "<a href=\"./analysisClusterResultListMain.jsp?seq="+rowObject.seq+"&update_flag="+rowObject.update_flag+"\">" + cellValue +"</a>";
	}
	
	function goNewAnalaysis(){
		location.href = "./analysisRegist.jsp";
	}
	
	function exportExcel(seq, updateFlag){
		if(seq && updateFlag){
			if(confirm("선택된 항목에 대한 클러스터 결과를 Export 하시겠습니까?")){
				var url = "./excelClusterAllDownload.jsp?seq="+seq+"&updateFlag="+updateFlag;
				var name = "excelDownload";
				var spec = "width=0,height=0";
				window.open(url,name,spec, true);
			}else{
				return;
			}
		}else{
			alert("잘못된 동작입니다. 페이지를 refresh 해 주세요.");
			return;
		}
	}
	
	function exportCluster(){
		var checkedSeq = selectedItem();
		if(jQuery.trim(checkedSeq) == ''){
			alert("선택된 항목이 없습니다.");
			return;
		}
		
	}
	
	function makeAction(cellValue, options, rowObject){
		return "<input type='button' class='bt5 tipTipClass' value='Export'  onclick=\"javascript:exportExcel('"+rowObject.seq+"', '"+rowObject.update_flag+"');\" title='현재 분석 결과를 Export합니다.'/>"; 	
	}
	
	function goClusterOption(){
		location.href = "./analysisOption.jsp";
	}

</script>
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
                        <table id="tableList" cellspacing="0" cellpadding="0" border="0" width="100%" ></table>
                   		<div id="pager"></div>
                    </td>
             	</tr>
            </table>
            </div>
            <%
            	if(UserAuthEnum.AUTH_SUPER.getAuth().equals(userBean.getAuth())){
            %>
            <br>            
            <div style="text-align: right">
            	<input type="button" class="bt5 tipTipClass" value="Analysis Setting"  onclick="javascript:goClusterOption();" title="클러스터 분석 조건을 설정합니다."/>
	            <input type="button" class="bt5 tipTipClass" value="Delete"  onclick="javascript:deleteGrid();" title="선택 항목을 삭제합니다."/>
	            <input type="button" class="bt5 tipTipClass" value="Modify"  onclick="javascript:modifyGrid();" title="선택 항목을 수정합니다."/>
            	<input type="button" class="bt5 tipTipClass" value="New Analysis"  onclick="javascript:goNewAnalaysis();" title="새로운 클러스터 분석 항목을 등록합니다."/>
            </div>
            <%
				}
            %>
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