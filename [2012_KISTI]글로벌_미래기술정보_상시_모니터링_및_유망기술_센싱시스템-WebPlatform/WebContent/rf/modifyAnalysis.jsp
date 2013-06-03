<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.topquadrant.db.bean.RFAnalysis"%>
<%@page import="kr.co.topquadrant.db.mybatis.MyBatisParameter"%>
<%@page import="kr.co.topquadrant.db.dao.ResearchFrontDAO"%>
<%@page import="kr.co.topquadrant.db.dao.IResearchFrontDao"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>
<%
boolean unauthorized = false;

if(userBean==null) {unauthorized = true;};
if(!userBean.getAuth().equalsIgnoreCase(UserAuthEnum.AUTH_SUPER.getAuth())){
	unauthorized = true;
}
if(unauthorized){
	out.println("<script>");
	out.println("alert('해당 페이지로의 접근 권한이 없습니다.');");
	out.println("location.href=\"./analysisMain.jsp\";");
	out.println("</script>");
}
	int seq = baseRequest.getInteger("seq", -1);
	
	Map<String, String> asjcCodeList = DescriptionCode.getAsjcTypeEngDescription();
	IResearchFrontDao irf = new ResearchFrontDAO();
	RFAnalysis rfAnalysis = irf.selectAnalysis(seq);
	List<String> asjcList = irf.selectAnalysisAsjc(seq);
	
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SCOPUS 정보 검색 플랫폼 - Research Front Modify Cluster Analysis</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

	var asjcCodeList = [];
	<%for(String key : asjcCodeList.keySet()){%>
			asjcCodeList[<%=key%>] = '1';
	<%}%>

	$(document).ready(function() {
		//문서가 준비되었을때
		registAsjcCode();
	});
	
	function registAsjcCode(){
		<%
		if(asjcList!=null){
			for(String asjc : asjcList){
				asjc = asjc+";"+asjcCodeList.get(asjc.trim());
				out.println("asjc_add('"+asjc+"');");
			}
		}
		%>
	}
	
	function asjc_add(val){
		var form = document.getElementById("frm");
		alert(form +"\t" + val);
		//alert(form.sele_asjc +"\t" + val);
		//selectAddOption(form.sele_asjc, val);
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

	function registerCluster(){
		var selectedASJCCodes = "";
		var selectedASJC = document.getElementById("sele_asjc");
		for(var i=0;i<selectedASJC.length;i++){
			var term = jQuery.trim(selectedASJC.options[i].value);
			selectedASJCCodes += term + " ";
		}
		var form = document.getElementById("frm");
		
		if(jQuery.trim(form.title.value)==''){
			alert("Title을 입력하세요");
			form.title.focus();
			return;
		}
		
		if(jQuery.trim(selectedASJCCodes)== '' && jQuery.trim(form.asjcUser.value)==''){
			var check = false;
			$("input[name=addDoc]").each(function() {
				var value = $(this).attr("value");
				var checked = $(this).attr("checked");
				if(checked){
					check = true;
				}
		    });
			if(!check){
				alert("분석 대상이 되는 ASJC코드나 출처 논문 타입을 입력해 주세요.");
				return;
			}
		}
		selectedASJCCodes = selectedASJCCodes + jQuery("#asjcUser").text();
		var asjcCodes = selectedASJCCodes.split(" ");
		var errCodes = "";
		var confirmCodes = "";
		for(var idx=0; idx<asjcCodes.length; idx++){
			var inputAsjc = jQuery.trim(asjcCodes[idx]);
			var value = asjcCodeList[inputAsjc];
			if(value==null){
				errCodes += inputAsjc + " ";
			}else{
				confirmCodes += inputAsjc + " ";
			}
		}
		if(jQuery.trim(errCodes)!=''){
			if(!confirm("유효하지 않은 ASJC 코드가 존재합니다.\n["+ jQuery.trim(errCodes)+"]\n 시스템은 이 코드를 무시하고 입력합니다. 계속하시겠습니까?")){
				form.asjcUser.focus();
				return;
			}
		}
		form.selectedASJCCodes.value = confirmCodes;
		form.method="POST";
		form.action = "./analysisModifyProc.jsp";
		form.submit();
	}
	
	
	function PopupWindow(pageName) {
		var cw=640;
		var ch=400;
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		var px=Math.round((sw-cw)/2);
		var py=Math.round((sh-ch)/2);
		window.open(pageName,"","left="+px+",top="+py+",width="+cw+",height="+ch+",toolbar=no,menubar=no,status=yes,resizable=yes,scrollbars=yes");
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
	
	function asjc_add(val){
		var form = document.getElementById("frm");
		selectAddOption(form.sele_asjc, val);
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

</script>
</head>
<body>
<div class="accessibility">
	<p><a href="#content">메뉴 건너뛰기</a></p>
</div>

<div id="wrap">

	<!--top_area-->
    <jsp:include page="../inc/topArea.jsp">
    	<jsp:param value="<%=TOP_MENU_MANAGE %>" name="TOP_MENU"/>
    	<jsp:param value="<%=SUB_MENU_USER_MANAGE %>" name="SUB_MENU"/>
    </jsp:include>
    <!--top_area-->
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">
        
	    	<div id="search">
			<% String menuTerm = "Research Front (New Cluster Analysis)"; %>
	    		<%@include file="../common/quickSearchFixSize.jsp" %>
			</div>
			
            <div>
            <form name="frm" id="frm" method="post">
            	<input type="hidden" name="seq" value="<%=seq%>"/>
            	<input type="hidden" name="selectedASJCCodes"/>
            <table class="Table9" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td colspan="2" style="padding:2px 2px 2px 2px;">
                    	<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" >Modify Cluster Analysis</span>
                    </td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right;" width="100">Title</td>
                    <td style="padding:2px 5px 2px 5px;"><input type="text" name="title" maxlength="512" style="width: 97%;" value="<%=UtilString.nullCkeck(rfAnalysis.getTitle(), true)%>"/></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right; vertical-align: top;">Description</td>
                    <td style="padding:2px 5px 2px 5px;"><textarea rows="5" name="description" style="width: 98%; word-wrap:break-word;"> <%=UtilString.nullCkeck(rfAnalysis.getDescription(), true) %></textarea></td>
                </tr>
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right; vertical-align: top;">
                    	<br><br>
                    	ASJC Code
                    </td>
                    <td style="padding:2px 5px 2px 5px;">
						<table border="0" cellpadding="0" cellspacing="0" summary="ASJC 분류별 테이블" width="100%">
                            <tr>
                             	<td height="35" align="right" style="padding:2px 8px 2px 5px;">
                              		<div id="submit">
										<input type="button" value="Search ASJC Code" class="bt5" title="버튼을 선택하여 ASJC 코드를 검색할 수 있습니다." onclick="javascript:PopupWindow('../documentSearch/ASJCPopup.jsp');">
                                    </div>
                                </td>
                         	</tr>
                            <tr>
                           	 	<td>
                           	 		<select id="sele_asjc" name="sele_asjc" multiple size="10" style="width:99%"></select>
							    </td>
                            </tr>
                            <tr>
                             	<td height="35" align="right" style="padding:2px 8px 2px 5px;">
                              		<div id="submit">
										<input type="button" class="bt5" title="선택하여 등록된 데이터를 전부 삭제합니다." value="Delete All" onclick="javascript:selectlist_all_del(this.form.sele_asjc);">
										<input type="button" class="bt5" title="선택한 데이터를 삭제합니다." value="Delete" onclick="javascript:selectlist_del(this.form.sele_asjc);">
                                    </div>
                                </td>
                         	</tr>
                        </table>
                    </td>
                </tr>
                
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right; vertical-align: top;">
                    	Enter ASJC Code 
                    	<img src='../images/system_question_alt_02.png'	class="tipTipClass" title="ASJC 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." style="vertical-align: middle;" border='0'/>
                    </td>
                    <td style="padding:2px 5px 2px 5px;">
                        <textarea rows="3" id="asjcUser" name="asjcUser" style="width: 98%; word-wrap:break-word;" title="ASJC 코드 데이터를 띄어쓰기로 구분하여 넣어주세요." ></textarea>
                    </td>
                </tr>
                
       	  		<tr height="40">
                    <td style="padding:2px 5px 2px 20px; text-align: right; vertical-align: top;">
                    	Additional Journal
                    </td>
                    <td style="padding:2px 5px 2px 5px;">
                    	<table>
                    		<tr>
                    			<td width="50%">
			                        <input type="checkbox" name="addScience" value="<%=MyBatisParameter.Y%>" <%=MyBatisParameter.Y.equalsIgnoreCase(rfAnalysis.getAdd_science())?"checked='checked'":"" %>/> Include Papers in Science (Recent 5 years) <br> 
			                        <!-- 
			                        <input type="checkbox" name="addScience" value="<%=MyBatisParameter.N%>" checked="checked"/> Science 출처에 대한 논문 선택안함<br>
			                        <input type="checkbox" name="addScience" value="<%=MyBatisParameter.R%>"/> Science 출처에 대한 관련논문 (최근 5년 이후)
			                         -->
			                        <input type="checkbox" name="addNature" value="<%=MyBatisParameter.Y%>" <%=MyBatisParameter.Y.equalsIgnoreCase(rfAnalysis.getAdd_nature())?"checked='checked'":"" %>/> Include Papers in Nature (Recent 5 years) <br>
			                        <!-- 
			                        <input type="checkbox" name="addNature" value="<%=MyBatisParameter.N%>" checked="checked"/> Nature 출처에 대한 논문 선택안함<br>
			                        <input type="checkbox" name="addNature" value="<%=MyBatisParameter.R%>"/> Nature 출처에 대한 관련논문 (최근 5년 이후)
			                         -->
                    			</td>
                    		</tr>
                    	</table>
                        
                        
                    </td>
                </tr>
                
       	  		<tr height="60">
                    <td colspan="2" style="padding:2px 17px 2px 20px; text-align: right; vertical-align: middle;">
                        <div id="submit">
							<input type="button" value="Modify Cluster Analysis" class="bt4" title="클러스터 분석 정보를 수정합니다." onclick="javascript:registerCluster();">
                        </div>
                    </td>
                </tr>
            </table> 
            </form>
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
    <jsp:include page="../inc/bottomArea.jsp"/>
    <!--footer_area-->      
</div>
</body>
</html>