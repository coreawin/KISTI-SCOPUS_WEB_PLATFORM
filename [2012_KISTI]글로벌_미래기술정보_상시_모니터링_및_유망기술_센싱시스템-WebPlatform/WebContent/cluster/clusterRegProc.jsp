<%@page import="java.util.LinkedList"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterSimilityDataBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterDataBean"%>
<%@page import="kr.co.tqk.web.db.bean.cluster.ClusterRegistBean"%>
<%@page import="kr.co.tqk.web.db.dao.cluster.ClusterDao"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.tqk.web.util.file.UploadFileComponentExcel"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.util.file.UploadFileComponent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/auth.jsp" %>    
<script>
<%
	UploadFileComponent ufc = new UploadFileComponent(request, CLUSTER_SAVE_PATH);
	HashMap<String, Object> parameter = ufc.uploadFile();
	String title = String.valueOf(parameter.get("analTitle"));
	List<String> sl = ufc.getSaveFileNameList();
	String uploadFile = sl.get(0);
	List<String> ofl = ufc.getOriginalFileNameList();
	
	ClusterRegistBean crBean = new ClusterRegistBean();
	crBean.setFilename(ofl.get(0));
	crBean.setDescription(".");
	crBean.setTitle(title);
	crBean.setUserId(userBean.getId());
	
	LinkedList<ClusterDataBean> cdBeanList = new LinkedList<ClusterDataBean>();
	LinkedList<ClusterSimilityDataBean> csdBeanList = new LinkedList<ClusterSimilityDataBean>();
	ClusterDataBean cdBean = null;
	BufferedReader br = null;
	File readFile = new File(CLUSTER_SAVE_PATH + File.separator + uploadFile);
	try{
 		br = new BufferedReader(new FileReader(readFile));
		String line = null;
		while((line = br.readLine())!=null){
			if("".equals(line)) continue;
			if(line.startsWith("[Info]")){
				//클러스터 정보 추출
				line = line.trim();
				if(line.indexOf("Threshold")!=-1){
					crBean.setThreshold(Float.parseFloat(line.split(":")[1].trim()));
				}else if(line.indexOf("Max")!=-1){
					crBean.setMaxClusterCnt(Integer.parseInt(line.split(":")[1].trim()));
				}else if(line.indexOf("Min")!=-1){
					crBean.setMinClusterCnt(Integer.parseInt(line.split(":")[1].trim()));
				}else if(line.indexOf("핵심 논문의 갯수")!=-1){
					crBean.setDocCnt(Integer.parseInt(line.split(":")[1].trim()));
				}else if(line.indexOf("분석 대상 총 논문")!=-1){
					crBean.setTotalDocCnt(Integer.parseInt(line.split(":")[1].trim()));
				}
			}else{
				if(!line.startsWith("[")){
					//클러스터 데이터.
					String[] clusterDataSet = line.split(":");
					cdBean = new ClusterDataBean();
					cdBean.setClusterKey(clusterDataSet[0].trim());
					cdBean.setEids(clusterDataSet[1].trim());
					cdBean.setIsdel(ClusterDataBean.ISDEL_TYPE_N);
					cdBeanList.add(cdBean);
				}
			}
		}
		ClusterDao.registClusterRegist(crBean, cdBeanList, csdBeanList);
		out.println("alert(\" "+crBean.getFilename() +"의 클러스터 정보가 저장되었습니다.\")");
	}catch(Exception e){
		e.printStackTrace();
		out.println("alert(\"오류가 발생하였습니다. \\n"+e.getMessage().replaceAll("\\\"", "'").replaceAll("\n","")+"\")");
	} finally{
		if(br!=null) br.close();
		if(readFile!=null){
			readFile.delete();
		}
		out.println("location.href=\"./clusterReg.jsp\"");
	}
%>
</script>
