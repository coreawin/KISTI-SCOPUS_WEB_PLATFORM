<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.tqk.web.db.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/common.jsp" %>
<%@include file="./commonNoregist.jsp" %>
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
    	url:'<%=serviceURL%>/rf/analysisMainGridData.jsp?showMirian=<%=MyBatisParameter.Y%>',
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
    	colNames:['No', 'Title', 'ASJC Code', 'Description', 'Science', 'Nature', 'Date'],
       	colModel:[
			{name:'seq', index:'SEQ', hidden:true},
			{name:'title', index:'title', search:true, align:'left', formatter:titleLink, cellattr: textWrap},
			{name:'asjcList',label:'asjcList', search:false, searchoptions:{sopt:['cn']}, align:'left', sortable: false, jsonmap:"asjcList",
		          formatter: function (cellvalue) {
		              return cellvalue.join(" ");
		          }, cellattr: textWrap},
			{name:'description',index:'DESCRIPTION', searchoptions:{sopt:['cn']}, sortable: false, align:'left', cellattr: textWrap},
			{name:'add_science',index:'ADD_SCIENCE', stype:'select', searchoptions:{sopt:['eq'], value:"Y:Y;N:N"}, width:'40'},
			{name:'add_nature',index:'ADD_NATURE', stype:'select', searchoptions:{sopt:['eq'], value:"Y:Y;N:N", attr:{title:'Select Science'}}, width:'40'},
			{name:'reg_date_first',index:'REG_DATE_FIRST', width:'60', align:'center', sorttype:'date'}
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

	function textWrap(rowId, tv, rawObject, cm, rdata) {
		return 'style="white-space: normal;"'; 
	}

	function titleLink(cellValue, options, rowObject){
		//alert(cellValue+'\t' + options +'\t' + rowObject);
		return "<a href=\"<%=serviceURL%>/noregist/analysisClusterResultListMain.jsp?seq="+rowObject.seq+"&update_flag="+rowObject.update_flag+"\">" + cellValue +"</a>";
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
	    		<% String menuTerm = "Research Front"; %>
	    		<%@include file="./titleBar.jsp" %>
			</div>
			<br>
            <div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table id="tableList" cellspacing="0" cellpadding="0" border="0" width="100%"></table>
                   		<div id="pager"></div>
                   		
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
    <!--contents_area-->
    
    <!--footer_area-->
    <jsp:include page="./bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>