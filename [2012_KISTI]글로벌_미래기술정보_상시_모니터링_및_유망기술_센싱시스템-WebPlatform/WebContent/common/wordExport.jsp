<%@page import="kr.co.tqk.analysis.report.ReportBean"%>
<%@page import="kr.co.tqk.web.util.MapUtil"%>
<%@page import="kr.co.tqk.analysis.report.GetReportData"%>
<%@page import="java.util.HashSet"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterDataBean"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.regex.Pattern"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./auth.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	String fileName = request.getParameter("fileName");
	if(fileName==null) fileName = "report.doc";
	
	int selectSeq = baseRequest.getInteger("selectSeq", 21);
	String clusterKey = baseRequest.getParameter("clusterKey", null);
	
	
	//String htmlData = request.getParameter("htmlData");
	response.setHeader("Content-Type", "application/x-msdownload");
	response.setHeader("Content-Disposition", "attachment;filename="+fileName+";");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>과학기술 계량 정보분석을 통한 유망연구영역 분석</title>

<style type="text/css">
<!--
html {_overflow-y:scroll; _overflow-x:auto; height:100%;}
img {border:0 none;}

body {font-size:12px; line-height:1.7; text-align:left; margin:0; padding:0; /*font-family:dotum, "돋움", "AppleGothic", "Lucida Grande", verdana, serif;*/ font-family:Arial, verdana, helvetica, sans-serif;}
#wrap {float:left; position:relative; width:100%; margin:0 auto; padding:0px; text-align:left;}	
	#container {position:relative; *zoom:1;}
	#container:after {content:" "; display:block; height:0; clear:both;}
		#content {float:left; width:960px; overflow:hidden; padding:15px 15px; font-family:/*dotum, "돋움",*/ Arial, verdana, helvetica, sans-serif; !important; font-size:12px;!important;}
		
#content .ct {width:960px; font-size:12px; border:0px solid #DBDBDB; margin:0px; padding:0px; vertical-align:middle;}
#content .Table12 {border-top:1px #dcdcdc solid; border-right:1px #dcdcdc solid; width:960px; font-size:12px; margin:0px;}
#content .Table12 th {font-family:dotum, "돋움"; !important; padding:3px 5px; background-color:#dcf0f7; border-top:0px #dcdcdc solid; border-right:0px #dcdcdc solid; color:#25405b; text-align:center;}
#content .Table12 td {border-bottom:1px #dcdcdc solid; border-left:1px #dcdcdc solid; color:#434343; vertical-align:middle;}
#content .Table12 .txt {color:#000; text-decoration:underline;}
#content .Table12 .txt3 {padding:5px 5px; color:#25405b; font-weight:bold; text-align:center;}
#content .Table12 .txt3_1 {padding:3px 5px;}
#content .Table12 .txt4 {border-bottom:1px #dcdcdc solid; border-left:1px #dcdcdc solid; padding:3px 5px; background-color:#ecf8ff; color:#2277e0; text-align:center;}
#content .Table12 .txt5 {padding:2px 2px; color:#2a87d5;}
#content .Table12 .txt5_1 {padding:2px 2px; color:#005eac; text-align:center;}
#content .Table12 .txt6 {padding:2px 2px; text-align:center;}
#content .Table12 a:link, a:visited {color:#005eb8; text-decoration:underline;}
#content .Table12 a:hover, a:active {color:#005eb8; text-decoration:underline;}
#content .Table13 {width:100%; font-size:12px; border-top:0px #dcdcdc solid; border-right:0px #dcdcdc solid; margin:0px;}
#content .Table13 th {font-family:dotum, "돋움"; !important; font-size:12px; padding:0px 5px; background-color:#dcf0f7; border-bottom:1px #dcdcdc solid; border-left:0px #dcdcdc solid; color:#25405b; text-align:center;}
#content .Table13 td {padding:5px 5px; border-bottom:1px #dcdcdc solid; border-left:0px #dcdcdc solid; color:#434343; vertical-align:middle;}
#content .Table13 .txt4 {width:100px; padding:2px 2px; background-color:#ecf8ff; color:#2277e0; text-align:center;}
#content .Table13 a:link, a:visited {color:#005eb8; text-decoration:underline;}
#content .Table13 a:hover, a:active {color:#005eb8; text-decoration:underline;}
#content .Table14 {width:100%; font-size:12px; border-top:1px #dcdcdc solid; border-right:1px #dcdcdc solid; margin:0px;}
#content .Table14 td {padding:0px 5px; border-bottom:1px #dcdcdc solid; border-left:1px #dcdcdc solid; color:#434343; text-align:center;}
-->
</style>
</head>

<body>
<div id="wrap">
	
	<!--contents_area-->
    <div id="container">
    
		<div id="content">

            <div id="report">
            <table class="ct" border="0" cellpadding="0" cellspacing="0">
       	  		<tr>
                    <td>
                        <table class="Table12" border="0" cellpadding="0" cellspacing="0" summary="분석 보고서 테이블">
                        	<tr>
                                <td class="txt3">과학기술 계량정보분석을 통한 유망연구영역 분석</td>
                                <th class="txt4">일련번호</th>
                                <td class="txt3_1">sfsdfsdf</td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                	<table class="Table13" border="0" cellpadding="0" cellspacing="0" align="center">
                                        <tr>
                                         	<th class="txt4">연구분야</th>
                                            <td>ㅇㄹㄴㄹㄴㅇㄹ</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">대분류</th>
                                            <td>농학 및 생물학(81.25%)</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">분류코드<br />(%,빈도)</th>
                                            <td>ㅇㄹㄴㄹㄴㅇㄹ</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">통계정보</th>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td>핵심논문수</td>
                                                        <td>핵심논문피인용수</td>
                                                        <td>핵심 논문당 피인용수</td>
                                                        <td>핵심논문평균연도</td>
                                                        <td>인용논문평균연도</td>
                                                    </tr>
                                                    <tr>
                                                        <td>16</td>
                                                        <td>701</td>
                                                        <td>43.8125</td>
                                                        <td>2001.5465</td>
                                                        <td>45</td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">핵심키워드</th>
                                            <td>ㅇㄹㄴㄹㄴㅇㄹ</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">핵심논문</th>
                                            <td>ㅇㄹㄴㄹㄴㅇㄹ</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">국내현황</th>
                                            <td>ㅇㄹㄴㄹㄴㅇㄹ</td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">발생연도현황</th>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td>2001</td>
                                                        <td>2002</td>
                                                        <td>2003</td>
                                                        <td>2004</td>
                                                        <td>2005</td>
                                                        <td>2006</td>
                                                        <td>2007</td>
                                                        <td>2008</td>
                                                        <td>2009</td>
                                                        <td>2010</td>
                                                        <td>2011</td>
                                                    </tr>
                                                    <tr>
                                                        <td>16</td>
                                                        <td>3</td>
                                                        <td>4</td>
                                                        <td>2</td>
                                                        <td>4</td>
                                                        <td>1</td>
                                                        <td>7</td>
                                                        <td>4</td>
                                                        <td>2</td>
                                                        <td>4</td>
                                                        <td>4</td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <th class="txt4">인용논문<br />발행연도현황</th>
                                            <td>
                                            	<table class="Table14" border="0" cellpadding="0" cellspacing="0" align="center">
                                                    <tr bgcolor="#ecf8ff">
                                                        <td>2001</td>
                                                        <td>2002</td>
                                                        <td>2003</td>
                                                        <td>2004</td>
                                                        <td>2005</td>
                                                        <td>2006</td>
                                                        <td>2007</td>
                                                        <td>2008</td>
                                                        <td>2009</td>
                                                        <td>2010</td>
                                                        <td>2011</td>
                                                    </tr>
                                                    <tr>
                                                        <td>16</td>
                                                        <td>3</td>
                                                        <td>4</td>
                                                        <td>2</td>
                                                        <td>4</td>
                                                        <td>1</td>
                                                        <td>7</td>
                                                        <td>4</td>
                                                        <td>2</td>
                                                        <td>4</td>
                                                        <td>4</td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                        <tr>
                                            <th height="30" class="txt4">연구영역명</th>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <th height="50" class="txt4">연구영역의<br />개요</th>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <th height="60" class="txt4" >기타의견</th>
                                            <td></td>
                                        </tr>
                                    </table></td>
                            </tr>
                        </table></td>
   	  		 	</tr>
            </table>
            </div>     
 	 	</div>
    </div>
    <!--contents_area-->
</div>
</body>
</html>