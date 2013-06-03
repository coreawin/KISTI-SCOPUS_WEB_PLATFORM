<%kr.co.tqk.web.util.RequestUtil baseRequest = new kr.co.tqk.web.util.RequestUtil(request);%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.db.dao.ASJCDao"%>
<%@page import="kr.co.tqk.db.SearchHandler"%>
<%
	
	String search  = baseRequest.getParameter("find_name", null);
	String asjc_select = baseRequest.getParameter("asjc_select","all");
	String firstVal = baseRequest.getParameter("firstVal", null);
	String forwardASJC =  baseRequest.getParameter("forwardASJC",null);
	
	String[] asjcCode={};
	
	if(forwardASJC != null){
		asjcCode=forwardASJC.split(",");
	}
	
	String ckd="";
	String ckd2="";
	String ckd3="";
	String ckd4="";
	
	if("all".equals(asjc_select.trim())){
		ckd="checked";
		ckd2="";
		ckd3="";
		ckd4="";
	}else if("1000".equals(asjc_select.trim())){
		ckd="";
		ckd2="checked";
		ckd3="";
		ckd4="";
	}else if("2000".equals(asjc_select.trim())){
		ckd="";
		ckd2="";
		ckd3="checked";
		ckd4="";
	}else if("3000".equals(asjc_select.trim())){
		ckd="";
		ckd2="";
		ckd3="";
		ckd4="checked";
	}
	
	LinkedList<ASJCDao> list = new LinkedList<ASJCDao>();

		
	if(firstVal==null){
			if(search==null){   
				//검색하지 않았을 경우. 
				if("all".equals(asjc_select.trim())){
					list =SearchHandler.selectASJC();		
				}else{
					list =SearchHandler.selectASJC(asjc_select);	
				}
			}else{
				//검색하였을 경우.	
				list =SearchHandler.selectASJCSearch(asjc_select,search);
			}	
		
	}else if("first".equals(firstVal.trim())){
		list =SearchHandler.selectASJC();
	}
	
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>SCOPUS 정보 검색 플랫폼 - Search ASJC Code</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>

<script>

var ck_asjc="all";

function searchASJC(){
	form=document.getElementById("frm");
	form.asjc_select.value=ck_asjc;
	form.action="ASJCPopup.jsp"
	form.submit();
}
function searchASJCFirst(){
	form=document.getElementById("frm");
	form.firstVal.value="first";
	form.find_name.value="";

	form.action="ASJCPopup.jsp"
	form.submit();
}

function changeRadio(){
	form=document.getElementById("frm");
	var asjc=form.asjc;

	for(var i=0;i<asjc.length;i++){
		if(form.asjc[i].checked==true){
			ck_asjc=form.asjc[i].value;
		}
	}

	form.asjc_select.value=ck_asjc;
	form.action="ASJCPopup.jsp";
	form.submit();
}

function forwardParent(){
	form = document.getElementById("frm");

	opener.asjc_add(form.asjc_code.value);
}
</script>

<link href="<%=request.getContextPath() %>/css/nano_style.css" rel="stylesheet" type="text/css" />

</head>
<body  style="background:#FFFFFF;">

<div id="content_popup">
<form name="frm" id="frm" method="post">
<input type="hidden" id="asjc_select" name="asjc_select"  >
<input type="hidden" id="firstVal"  name="firstVal" />

	<table cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="640" cellpadding="0" cellspacing="0">
					<tr>
						<td background="../images/nn_search_popup_bg.gif" width="640" height="17"></td>
				 	</tr>
					<tr>
					 	<td>
                        	<div><h1 class="tit_txt_3">Search ASJC Code</h1></div>

                       	 	<div class="viewA">
                          	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="ASJC 선택 테이블">
                                            <tr>
												<td height="25" valign="middle" class="txt">
													<input type="radio" name="asjc" value="all" <%=ckd%> onclick="javascript:changeRadio();"> all | &nbsp;
													<input type="radio" name="asjc" value="1000" <%=ckd2%> onclick="javascript:changeRadio();" > 1000 | &nbsp;
													<input type="radio" name="asjc" value="2000" <%=ckd3%> onclick="javascript:changeRadio();" > 2000 | &nbsp;
													<input type="radio" name="asjc" value="3000" <%=ckd4%> onclick="javascript:changeRadio();" > 3000
												</td>
                                            </tr>
                                            <tr>
                                                <td height="35" valign="middle" class="txt"> 
													<input type="text" id="find_name" name="find_name" class="input_txt" value="<%=(search==null)?"":search %>"  maxlength="15" />
													<input type="button" class="bt5" value="Search"  onclick="javascript:searchASJC();"/>
													<!-- input type="button" class="bt5" value="전체검색"  onclick="javascript:searchASJCFirst();"/ -->
												</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
													<select id="asjc_code" name="asjc_code" size=10 style="width:500px" multiple onchange="javascript:forwardParent();">
														<%for(ASJCDao dao :  list) {
														%>
														   <option value="<%=dao.getAsjc_code()+";"+dao.getDescription() %>">(<%=dao.getAsjc_code() %>) &nbsp;&nbsp; <%=dao.getDescription() %></option>
														<%} %>
													</select>
                                                </td>
                                            </tr>
											<tr><td><br>
												<input type="button" class="bt5" value="Close" onclick="javascript:self.close();" >
											</td></tr>
                                        </table></td>
                                </tr>
                            </table>
                     		</div>
				 	</tr>
				</table></td>
		</tr>
	</table>
</form>
</div>


	 
</body>
</html>


