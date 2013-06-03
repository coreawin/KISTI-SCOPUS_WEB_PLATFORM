<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterRegistBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
try{
	LinkedList<ClusterRegistBean> crBeanList = ClusterDao.selectClusterRegiAll(userBean.getId());
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nano</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath %>/css/jquery/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.tablesorter.min.js"></script> 
<script type="text/javascript">

function fileRegi(){
	var form = document.getElementById("clusterRegForm");
	if(form.selectFile.value==""){
		alert("분석 파일을 입력해 주세요.");
		return;
	}
	if(form.analTitle.value==""){
		alert("입력할 분석 파일에 대한 설명을 간략히 입력해 주세요.");
		form.analTitle.focus();
		return;
	}
	form.action="./clusterRegProc.jsp";
	form.submit();
}

function remove(){
	var form=document.getElementById("parameter");
	var checkedSeqList = "";
	$("input[name=seqCheck]").each(
			function() {
				var checked = $(this).attr("checked"); // 체크된 값만을 불러 들인다.
				var disabled = $(this).attr("disabled"); // 
				if(checked==true && disabled==false){
					checkedSeqList += this.value +";";
				}
			}
		);
	checkedSeqList = checkedSeqList.substr(0, (checkedSeqList.length-1));
	if(""!=checkedSeqList){
		if(confirm("선택항목을 삭제하시겠습니까?")){
			form.selectSeq.value = checkedSeqList;
			form.action="./clusterRegDeleteProc.jsp";
			form.submit();
		}
	}else{
		alert("선택된 분석이 없습니다.");
	}
}

$(document).ready(function() {
	//문서가 준비되었을때
	
	 $("#tablesorter").tablesorter({ 
        // pass the headers argument and assing a object 
        headers: { 
            // assign the secound column (we start counting zero) 
            0: { 
                // disable it by setting the property sorter to false 
                sorter: false 
            } 
        } 
	  }); 
	
	//체크박스가 체크되면 모든 체크박스를 체크한다.
    $("#ckeckAll").click(function() {
        if ($("#ckeckAll:checked").length > 0) {
            $("input:checkbox:not(checked)").attr("checked", "checked");
            $("input:checkbox:disabled").attr("checked", "");
        } else {
            $("input:checkbox:checked").attr("checked", "");
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
    	<jsp:param value="<%=TOP_MENU_CLUSTER %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_CLUSTER_MAIN %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<table class="search" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                    <td width="55%" align="left" class="tit">분석 파일 입력</td>
                    <td width="45%" align="right"> </td>
                </tr>
            </table> 
			</div>
            
            <div id="search_choice1">
            <form method="post" enctype="multipart/form-data" id="clusterRegForm" name="clusterRegForm">
			<table class="Table" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td valign="top">
	                    	<table class="Table1" border="0" cellpadding="0" cellspacing="0" align="center">
	                            <tr>
	                                <td width="100" bgcolor="#d9dce1" class="txt1"  style="padding:5px 10px;text-align:right;"><strong>분석 파일 입력</strong></td>
	                                <td width="840" bgcolor="#d9dce1">
	                                	<input type="file" id="selectFile" name="selectFile" size="70"/>
	                                </td>
	                            </tr>
	                            <tr>
	                             	<td bgcolor="#f2f2f2" height="3"></td>
	                            </tr>
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt1" style="padding:5px 10px;text-align:right;">　<strong>분석명</strong></td>
	                                <td bgcolor="#d9dce1">
	                                	<input type="text" id="analTitle" class="input_txt1" name="analTitle" size="90" maxlength="510"/>
	                                </td>
	                            </tr>
	                            <tr>
	                             	<td bgcolor="#f2f2f2" height="3"></td>
	                            </tr>
	                            <!-- 
	                            <tr>
	                                <td bgcolor="#d9dce1" class="txt1">　<strong>설명</strong></td>
	                                <td bgcolor="#d9dce1" class="txt5">
	                                	 <textarea name="textarea" rows="7" cols="72" title="" id="textarea"></textarea>
	                               	</td>
	                            </tr>
	                             -->
	                  		</table>
                  		
                  		</td>
             	</tr>
             	<tr>
                    <td class="txt1" style="padding:5px 10px;text-align:right;">
                    	<button type="button" onclick="javascript:fileRegi();" class="bt5" >분석 파일 등록</button>
                    </td>
                </tr>
            </table>
            </form> 
	 	 	</div><br />

            <div id="list">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="txt1">기존 등록된 분석명</td>
                </tr>
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" width="100%" id="tablesorter" class="tablesorter">
                            <caption>저자 list 테이블</caption>
                            <thead>
                                <tr bgcolor="#c0defa">
                                	<th style="padding:2px 2px 2px 2px;"><input name="check1" id="ckeckAll" type="checkbox" title="관리자를 제외한 회원을 모두 선택합니다."/></th>
                                    <th style="padding:2px 2px 2px 2px;">등록일시</th>
                                    <th style="padding:2px 2px 2px 2px;">입력제목</th>
                                    <th style="padding:2px 2px 2px 2px;">입력파일</th>
                                    <th style="padding:2px 2px 2px 2px;">Max Cluster</th>
                                    <th style="padding:2px 2px 2px 2px;">Min Cluster</th>
                                    <th style="padding:2px 2px 2px 2px;">Threshold</th>
                                    <th style="padding:2px 2px 2px 2px;">핵심논문수</th>
                                    <th style="padding:2px 2px 2px 2px;">분석대상 논문수</th>
                                </tr>
                            </thead>
                            <tbody>
<%
	String bgColor = "bgcolor=\"#f4f8fa\"";
	if(crBeanList.size()==0){
%>
								<tr>
 									<td colspan="9" align="center"> <%=userBean.getId() %>님이 등록하신 데이터가 존재하지 않습니다.</td>
                       	 	 	</tr>
<%		
	}

	for(ClusterRegistBean crBean : crBeanList){
	if("".equals(bgColor)){
		bgColor = "bgcolor=\"#f4f8fa\"";
	}else{
		bgColor = "";
	}
%>                            
                                <tr <%=bgColor %>>
                                	<td height="27" scope="row"><input name="seqCheck" id="seqCheck" type="checkbox" value="<%=crBean.getSeq() %>"/></td>
                                 	<td scope="row"><%=crBean.getRegistDate() %></td>
                                    <td><%=crBean.getTitle() %></td>
                                 	<td><%=crBean.getFilename() %></td>
                                    <td><%=NumberFormatUtil.getDecimalFormat(crBean.getMaxClusterCnt()) %></td>
                                    <td><%=NumberFormatUtil.getDecimalFormat(crBean.getMinClusterCnt()) %></td>
                                    <td><%=NumberFormatUtil.getDecimalFormat(crBean.getThreshold(),3) %></td>
                                    <td><%=NumberFormatUtil.getDecimalFormat(crBean.getDocCnt()) %></td>
                                    <td><%=NumberFormatUtil.getDecimalFormat(crBean.getTotalDocCnt())  %></td>
                       	 	 	</tr>
<%
	}
%>                                
                            </tbody>
                        </table></td>
             	</tr>
            </table>
            </div> 
            <div id="submit">
				<input type="button" class="bt2" value="선택된 분석 삭제하기" onclick="javascript:remove();"/>
            </div>
 	 	</div>
    </div>
    <!--contents_area-->
    
    <form id="parameter" method="post">
    	<input type="hidden" name="selectSeq" />
    </form>
    
     <!--footer_area-->
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->  
</div>
</body>
</html>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>