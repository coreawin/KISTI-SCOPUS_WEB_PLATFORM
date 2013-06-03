<%@page import="kr.co.tqk.web.DWPIQueryConverter"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="kr.co.tqk.web.db.dao.ScopusTypeDao"%>
<%@page import="kr.co.tqk.web.util.InfoStack.InfoStackType"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="org.json.JSONArray"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="org.apache.http.message.BasicNameValuePair"%>
<%@page import="org.apache.http.NameValuePair"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.util.UtilSearchParameter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp"%>
<%
try{
	HashMap<String, String> searchParameter = UtilSearchParameter
			.getSearchParameter(baseRequest);
	String select = baseRequest.getParameter("selectTopView", "10");
	String searchRule = baseRequest.getParameter("searchRule", "");
	int totalSize = baseRequest.getInteger("totalSize", 0);
	
	searchParameter.put("ln", "1");
	searchParameter.put("timeout", "60");
	String gr = String.valueOf(searchParameter.get("gr"));
	gr = gr.replaceAll(":50","");
	searchParameter.put("gr", gr);
	JSONObject jsonobj = null;
	ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
	nvps.add(new BasicNameValuePair("cn", searchParameter.get("cn")));
	nvps.add(new BasicNameValuePair("se", searchParameter.get("se")));
	nvps.add(new BasicNameValuePair("fl", searchParameter.get("fl")));
	nvps.add(new BasicNameValuePair("sn", searchParameter.get("sn")));
	nvps.add(new BasicNameValuePair("ln", searchParameter.get("ln")));
	nvps.add(new BasicNameValuePair("gr", searchParameter.get("gr")));
	nvps.add(new BasicNameValuePair("ra", searchParameter.get("ra")));
	nvps.add(new BasicNameValuePair("ft", searchParameter.get("ft")));
	nvps.add(new BasicNameValuePair("ud", searchParameter.get("ud")));
	jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);

	JSONArray groupResultArr = null;
	ArrayList<String> years = new ArrayList<String>();
	ArrayList<String> authornames = new ArrayList<String>();
	ArrayList<String> asjcs = new ArrayList<String>();
	ArrayList<String> sourcetitles = new ArrayList<String>();
	ArrayList<String> keywords = new ArrayList<String>();
	ArrayList<String> affilations = new ArrayList<String>();
	ArrayList<String> countries = new ArrayList<String>();
	ArrayList<String> sourcetypes = new ArrayList<String>();

	JSONArray groupResultJsonDataArray = null;

	if (jsonobj != null) {
		if (jsonobj.getInt("status") == 0) {
			groupResultArr = jsonobj.getJSONArray("group_result");
			for (int i = 0; i < groupResultArr.length(); i++) {
				groupResultJsonDataArray = groupResultArr.getJSONArray(i);
				if (i == 1) {
					//out.println(groupResultJsonDataArray);
				}
				for (int j = 0; j < groupResultJsonDataArray.length(); j++) {
					JSONObject o = groupResultJsonDataArray.getJSONObject(j);
					//out.print(o.getString("key")+"("+o.getString("freq")+")");
				}
			}
		}
	}
	
	Map<String, String> countryDescriptionMap = DescriptionCode.getCountryType();
	countryDescriptionMap.put("", "");
	Map<String, String> asjcKorDescriptionMap = DescriptionCode.getAsjcTypeKoreaDescription();
	Map<String, String> sourceDescriptionMap = DescriptionCode.getSourceTypeDescription();
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 검색 결과 통계 보기</title>
<link rel="SHORTCUT ICON" href="<%=request.getContextPath() %>/images/favicon.ico" />
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

jQuery(document).ready(function(){
	//$("#PUB_TABLE_LIST").fixedHeaderTable({width:'450', height: '240', footer: true, altClass: 'odd', autoShow: true });
	//$("#ASJC_TABLE_LIST").fixedHeaderTable({width:'450', height: '240', footer: true, altClass: 'odd', autoShow: true });
});

function excelExport(tbName){				
	var tbody = $('#' + tbName + ' tbody');		
	//alert(tbody.parent().parent().html());
	var form=document.getElementById("excelParameter");		
	form.staticTableBodyValue.value = tbody.parent().html();
	form.name.value = "statics";
	
	form.action = "<%=request.getContextPath()%>/common/excelExport.jsp";
		form.method = "POST";
		form.target="_blank";
	form.submit();
}

</script>

</head>

<body>
	<div class="accessibility">
		<p>
			<a href="#content">메뉴 건너뛰기</a>
		</p>
	</div>

	<div id="wrap">

		<!--top_area-->
		<jsp:include page="../inc/topArea.jsp">
			<jsp:param value="<%=TOP_MENU_SEARCH %>" name="TOP_MENU" />
			<jsp:param value="<%=SUB_MENU_DOCUMENT_SEARCH %>" name="SUB_MENU" />
		</jsp:include>
		<!--top_area-->

		<!--contents_area-->
		<div id="container">

			<div id="content">

				<div id="search">
					<table class="search" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="left" class="tit">
								<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" ><img alt="" src="../images/001_40.png" align="bottom" width="16" height="16">
		                    		논문검색결과<%=totalSize > 0 ? "(" + NumberFormatUtil.getDecimalFormat(totalSize) + ")건": "" %>에 대한 통계분석
		                    	</span>
							</td>
							<td width="30%" align="right">
								<form id="parameter" method="post">
							    	<input type="hidden" name="cn" value="<%=searchParameter.get("cn") %>" />
							    	<input type="hidden" name="se" value="<%=searchParameter.get("se") %>" />
							    	<input type="hidden" name="fl" value="<%=searchParameter.get("fl") %>" />
							    	<input type="hidden" name="sn" value="<%=searchParameter.get("sn") %>" />
							    	<input type="hidden" name="ln" value="<%=searchParameter.get("ln") %>" />
							    	<input type="hidden" name="gr" value="<%=searchParameter.get("gr") %>" />
							    	<input type="hidden" name="ra" value="<%=searchParameter.get("ra") %>" />
							    	<input type="hidden" name="ft" value="<%=searchParameter.get("ft")%>" />
							    	<input type="hidden" name="ht" value="" />
							    	<input type="hidden" name="ud" value="<%=searchParameter.get("ud") %>" />
							    	<input type="hidden" name="searchRule" value="<%=searchRule %>" />
									<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
									<span class="bt">Data filtering</span>
										<select name="selectTopView" id="selectTopView" onchange="javascript:submit();">
											<option value="ALL" <%="ALL".equalsIgnoreCase(select)?"selected":"" %>>=전체 데이터 보기=</option>
											<option value="10" <%="10".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 10 보기</option>
											<option value="20" <%="20".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 20 보기</option>
											<option value="30" <%="30".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 30 보기</option>
										</select>
								</form>	
							</td>
							<td width="10" align="right">
						</tr>
					</table>
				</div>
				<!-- 
				<div id="search_choice2">
					<table class="Table" border="0" cellpadding="0" cellspacing="0" style="margin-bottom:10px">
						<tr>
							<td valign="top">
								<form id="parameter" method="post">
							    	<input type="hidden" name="cn" value="<%=searchParameter.get("cn") %>" />
							    	<input type="hidden" name="se" value="<%=searchParameter.get("se") %>" />
							    	<input type="hidden" name="fl" value="<%=searchParameter.get("fl") %>" />
							    	<input type="hidden" name="sn" value="<%=searchParameter.get("sn") %>" />
							    	<input type="hidden" name="ln" value="<%=searchParameter.get("ln") %>" />
							    	<input type="hidden" name="gr" value="<%=searchParameter.get("gr") %>" />
							    	<input type="hidden" name="ra" value="<%=searchParameter.get("ra") %>" />
							    	<input type="hidden" name="ft" value="<%=searchParameter.get("ft")%>" />
							    	<input type="hidden" name="ht" value="" />
							    	<input type="hidden" name="ud" value="<%=searchParameter.get("ud") %>" />
							    	<input type="hidden" name="searchRule" value="<%=searchRule %>" />
									<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
									<table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" style="table-layout:fixed;whitespace:wrap;word-wrap:break-word">
										<tr>
											<td width="620" class="txt1"><span style="text-shadow: 1px 1px 2px #999;"><small><%=searchRule.indexOf("eid")!=-1?"":"Query : " + new DWPIQueryConverter().convToDQuery(searchRule) %></small></span></td>
											<td width="10"></td>
											<td width="310" align="right"><span class="bt">Data filtering</span></a>
												<select name="selectTopView" id="selectTopView" onchange="javascript:submit();">
													<option value="ALL" <%="ALL".equalsIgnoreCase(select)?"selected":"" %>>=전체 데이터 보기=</option>
													<option value="10" <%="10".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 10 보기</option>
													<option value="20" <%="20".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 20 보기</option>
													<option value="30" <%="30".equalsIgnoreCase(select)?"selected":"" %>>상위 Top 30 보기</option>
												</select></td>
										</tr>
									</table>
								</form>	
							</td>
						</tr>
		            </table>
			 	</div>
				 -->
				<div id="Graph Part">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">

												<!--   <tr>
                                            <td align="left"><strong>ASJC</strong></td>
                                            <td align="right"> 
                                            	<a href="#"><img src="<%=contextPath%>/images/nn_graph_icon01.gif" align="middle" alt="view graph" title="view graph" border="0"/></a>
                                            	<a href="#"><img src="<%=contextPath%>/images/nn_graph_icon02.gif" align="middle" alt="view table" title="view table" border="0"/></a>
                                            	<a href="javascript:excelExport('ASJC_TABLE_LIST');"><img src="<%=contextPath%>/images/nn_graph_icon03.gif" align="middle" alt="download table for excel" title="download table for excel" border="0"/></a>
                                            </td>
                                        </tr>-->

												<tr>
													<td colspan="2">
														<div id="Graph" style="display: none;">
															<table class="graph_01" border="0" cellpadding="0"
																cellspacing="0">
																<tr>
																	<td align="center">Graph</td>
																</tr>
															</table>
														</div>
														<div id="Table">
															<table summary="ASJC" cellspacing="0"
																cellpadding="0" border="0" width="100%">
																<caption>ASJC</caption>
																<thead>
																	<tr>
																		<th width="50%" align="left">&nbsp;&nbsp;ASJC Code</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('ASJC_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																	</tr>
																</thead>
																<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(1);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="ASJC" id="ASJC_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>ASJC</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="ASJC Code">ASJC Code</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="ASJC CODE";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		for (int index = 0; index < groupResultJsonDataArray.length(); index++) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key");
																			String v = o.getString("freq");
																			key += keyV+"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%= keyV + " : " + asjcKorDescriptionMap.get(keyV) %></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" ><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/barGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/barGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>


																	<%
																		}
																	%>

																</tbody>
															</table>
														</div></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
							<td align="right">
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td colspan="2">
														<div id="PUB_TABLE">
															<table id="PUB_TABLE_LIST" summary="Publication Year"
																cellspacing="0" cellpadding="0" border="0" width="100%">
																<caption>Publication Year</caption>
																<thead>
																	<th width="50%" align="left">&nbsp;&nbsp;Publication Year</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('PUBLICATION_YEAR_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																</thead>
																<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(0);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="YEAR" id="PUBLICATION_YEAR_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>Publication Year</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="Publication Year">Publication Year</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="Publication Year";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		for (int index = groupResultJsonDataArray.length()-1; index >= 0; index--) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key");
																			String v = o.getString("freq");
																			key += keyV+"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%= keyV %></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" <%=bgcolor%>><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc2" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/barGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/barGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>
																	<%
																		
																		}
																	%>
																</tbody>
															</table>
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
				<br />

				<div id="Graph Part">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">
												<!-- 
                                        <tr>
                                            <td align="left"><strong>ASJC</strong></td>
                                            <td align="right"> 
                                            	<a href="#"><img src="<%=contextPath%>/images/nn_graph_icon01.gif" align="middle" alt="view graph" title="view graph" border="0"/></a>
                                            	<a href="#"><img src="<%=contextPath%>/images/nn_graph_icon02.gif" align="middle" alt="view table" title="view table" border="0"/></a>
                                            	<a href="javascript:excelExport('ASJC_TABLE_LIST');"><img src="<%=contextPath%>/images/nn_graph_icon03.gif" align="middle" alt="download table for excel" title="download table for excel" border="0"/></a>
                                            </td>
                                        </tr>
                                         -->
												<tr>
													<td colspan="2">
														<div id="Graph" style="display: none;">
															<table class="graph_01" border="0" cellpadding="0"
																cellspacing="0">
																<tr>
																	<td align="center">Graph</td>
																</tr>
															</table>
														</div>
														<div id="Table">
															<table summary="Country" id="COUNTRY_TABLE_LIST"
																cellspacing="0" cellpadding="0" border="0" width="100%">
																<caption>Country</caption>
																<thead>
																	<tr>
																		<th width="50%" align="left">&nbsp;&nbsp;Country</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('COUNTRY_CODE_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																	</tr>
																</thead>
																<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(2);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="COUNTRY_CODE" id="COUNTRY_CODE_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>COUNTRY</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="Country">Country</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="Country";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		for (int index = 0; index < groupResultJsonDataArray.length(); index++) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key");
																			String v = o.getString("freq");
																			key += keyV+"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%= countryDescriptionMap.get(keyV)==null?keyV:countryDescriptionMap.get(keyV) %></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" <%=bgcolor%>><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc2" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/barGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/barGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>
																	<%
																		
																		}
																	%>
																</tbody>
															</table>
														</div></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
							<td align="right">
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td colspan="2">
														<div id="Graph" style="display: none;">
															<table class="graph_01" border="0" cellpadding="0"
																cellspacing="0">
																<tr>
																	<td align="center">Graph</td>
																</tr>
															</table>
														</div>
														<div id="Table">
															<table summary="Country" id="COUNTRY_TABLE_LIST"
																cellspacing="0" cellpadding="0" border="0" width="100%">
																<caption>Country</caption>
																<thead>
																	<tr>
																		<th width="50%" align="left">&nbsp;&nbsp;Country - Pie chart</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('COUNTRY_CODE_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																	</tr>
																</thead>
																<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(2);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="COUNTRY_CODE" id="COUNTRY_CODE_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>COUNTRY</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="Country">Country</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="Country";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		for (int index = 0; index < groupResultJsonDataArray.length(); index++) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key");
																			String v = o.getString("freq");
																			key += keyV+"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%= countryDescriptionMap.get(keyV)==null?keyV:countryDescriptionMap.get(keyV) %></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" <%=bgcolor%>><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc2" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/circleGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/circleGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>
																	<%
																		
																		}
																	%>
																</tbody>
															</table>
														</div></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
				<br />
				<div id="Graph Part">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td colspan="2">
														<div id="SOURCETYPE_TABLE">
															<table id="DOCUMENTTYPE_TABLE_LIST" summary="Source Type"
																cellspacing="0" cellpadding="0" border="0" width="100%"
																class="graph_table chart_type_pie table_hidden">
																<caption>Source Type</caption>
																<thead>
																	<tr>
																		<th width="50%" align="left">&nbsp;&nbsp;Document Type</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('DOCUMENT_TYPE_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																	</tr>
																</thead>
																	<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(8);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="DOCUMENT_TYPE_TYPE" id="DOCUMENT_TYPE_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>DOCUMENT TYPE</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="Country">Document Type</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="Document Type";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		Map documentTypeMap = DescriptionCode.getCitationType();
																		for (int index = 0; index < groupResultJsonDataArray.length(); index++) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key").trim();
																			String v = o.getString("freq");
																			key += documentTypeMap.get(keyV.toLowerCase())+"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%=documentTypeMap.get(keyV.toLowerCase())%></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" <%=bgcolor%>><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc2" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/circleGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/circleGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>
																	<%
																		
																		}
																	%>
																</tbody>
															</table>
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
							<td align="right">
											&nbsp;
							</td>
							<td align="right">
								<table class="graph" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="center" valign="top">
											<table class="graph_ct" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td colspan="2">
														<div id="AFFILIATION_TABLE">
															<table id="AFFILIATION_LIST" summary="Affiliation"
																cellspacing="0" cellpadding="0" border="0" width="100%"
																>
																<caption>Affiliation</caption>
																<thead>
																	<th width="50%" align="left">&nbsp;&nbsp;Affiliation</th>
																		<th width="50%" align="right">
																			<a href="javascript:excelExport('AFFILIATION_TABLE_LIST');" >
																				<img src="<%=request.getContextPath() %>/images/nn_graph_icon03.gif" align="middle" title="download format to excel" border="0"/>
																			</a>
																			&nbsp;&nbsp;
																		</th>
																</thead>
																<%
																	try {
																		groupResultJsonDataArray = groupResultArr.getJSONArray(3);
																	} catch (Exception e) {
																		groupResultJsonDataArray = null;
																	}

																	if (groupResultJsonDataArray == null) {
																%>
																<tbody>
																	<%
																		} else {
																	%>
																	<tr style="display: none;" >
																		<td height="100%" colspan="2" class="txt">
																			<table summary="AFFILIATION_TABLE_LIST" id="AFFILIATION_TABLE_LIST" cellspacing="0" cellpadding="0" border="0" width="100%">
																				<caption>Affiliation</caption>
																				<thead>
																					<tr bgcolor="#c0defa">
																						<th title="Affiliation">Affiliation</th>
																						<th title="Documents">Documents</th>
																					</tr>
																				</thead>
																				<tbody>
																	<%
																		String name="Affiliation";
																		String key = "";
																		String value ="";
																		String bgcolor = "bgcolor=\"#FFFFFF\"";
																		Map<String, String> affilationNameMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME));
																		Map<String, Integer> affilationNameFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME_FREQ));
																		Set<String> afidSet = new HashSet<String>();
												 						for (int j = 0; j < groupResultJsonDataArray.length(); j++) {
												 							JSONObject o = groupResultJsonDataArray.getJSONObject(j);
												 							String keyV = o.getString("key");
												 							afidSet.add(keyV.trim());
												 						}
																		affilationNameMap = ScopusTypeDao.getAffiliationNameDescription(affilationNameMap,
												 								affilationNameFreqMap, afidSet);
																		
																		for (int index = 0; index < groupResultJsonDataArray.length(); index++) {
																			JSONObject o = groupResultJsonDataArray.getJSONObject(index);
																			
																			if (index % 2 == 0) {
																				bgcolor = "bgcolor=\"#FFFFFF\"";
																			} else {
																				bgcolor = "bgcolor=\"#F4F8FA\"";
																			}
																			String keyV = o.getString("key");
																			String v = o.getString("freq");
																			key += keyV +"|";
                                                                    		value += v +"|";	
																	%>
																					<tr <%=bgcolor %>>
																						<td class="txt"><%= keyV.trim() %></td>
																						<td class="txt"><%= affilationNameMap.get(keyV.trim()) %></td>
																						<td class="txt"><%=NumberFormatUtil.getDecimalFormat(Integer.parseInt(v)) %></td>
																					</tr>
																	<%
																		}
																	%>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td width="500" height="250" colspan="2" <%=bgcolor%>><object
																				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
																				id="FlexCalc1" width="100%" height="100%"
																				codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
																				<param name="movie" value="../js/openflashchart/barGraph.swf" />
																				<param name="quality" value="high" />
																				<param name="bgcolor" value="#869ca7" />
																				<param name="allowScriptAccess" value="sameDomain" />
																				<param name="flashvars"
																					value="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>" />
																				<embed src="../js/openflashchart/barGraph.swf" quality="high"
																					bgcolor="#869ca7" width="100%" height="100%"
																					flashvars="name=<%=name%>&key=<%=key%>&value=<%=value%>&select=<%=select%>"
																					name="menu_Pro" align="middle" play="true"
																					loop="false" quality="high"
																					allowScriptAccess="sameDomain"
																					type="application/x-shockwave-flash"
																					pluginspage="http://www.adobe.com/go/getflashplayer">
																				</embed>
																			</object>
																		</td>
																	</tr>
																	<%
																		
																		}
																	%>
																</tbody>
															</table>
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>

			</div>
		</div>
		<!--contents_area-->

		<!--footer_area-->
		<jsp:include page="../inc/bottomArea.jsp" />
		<!--footer_area-->
	</div>

	<form id="excelParameter" method="post">
		<input type="hidden" name="staticTableBodyValue" /> 
		<input type="hidden" name="name" />
	</form>
</body>
</html>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>