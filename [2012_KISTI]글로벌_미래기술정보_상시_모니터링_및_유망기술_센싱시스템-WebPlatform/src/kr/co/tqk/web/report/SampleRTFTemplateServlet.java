package kr.co.tqk.web.report;

import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.Reader;
import java.util.HashSet;
import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;

import kr.co.tqk.analysis.report.DocumentBean;
import kr.co.tqk.analysis.report.GetReportData;
import kr.co.tqk.analysis.report.ReportBean;
import kr.co.tqk.web.db.bean.cluster.ClusterDataBean;
import kr.co.tqk.web.db.dao.cluster.ClusterDao;
import kr.co.tqk.web.util.RequestUtil;
import net.sourceforge.rtf.template.IContext;
import net.sourceforge.rtf.web.servlet.AbstractRTFTemplateServlet;

/**
 * 
 * Sample RTFTemplate Servlet which implements RTFTemplateServlet.
 * 
 * @version 1.0.0 
 * @author <a href="mailto:angelo.zerr@gmail.com">Angelo ZERR</a>
 *
 */
public class SampleRTFTemplateServlet extends AbstractRTFTemplateServlet  {
	public static final long serialVersionUID = 1L;	
	private static final String JAKARATA_VELOCITY_MODEL = "jakarta-velocity-model";
    private static final String REQUEST_MODELNAME = "modelName";
    private static final String REQUEST_MUSTBECACHED = "mustBeCached";
	
	protected Reader getRTFReader(HttpServletRequest request) throws Exception {
		// 1. Get Real path of RTF model.
		String rtfModelPath = "/models/wordReport.rtf"; 
		rtfModelPath = super.getRealPathOfRTFModel(request, rtfModelPath);
		// 2. Get Reader of RTF model
		Reader rtfModelReader = new FileReader(new File(rtfModelPath));
		return rtfModelReader;
	}
	
    protected String cacheWithKey(HttpServletRequest request) {
        // Test if checkbox cache is checked
        if (request.getParameter(REQUEST_MUSTBECACHED) != null) {
            // Cache must be enable for the RTF model
            // return name of the RTF model
            return request.getParameter(REQUEST_MODELNAME);
        }
        return null;
    }
    
    protected String unCacheWithKey(HttpServletRequest request) {
        // Test if checkbox cache is checked
        if (request.getParameter(REQUEST_MUSTBECACHED) == null) {
            // Cache must be disable for the RTF model
            // return name of the RTF model
            return request.getParameter(REQUEST_MODELNAME);            
        }        
        return null;
    }
    
	protected void putContext(HttpServletRequest request, IContext ctx ) throws Exception {
		// Swith RTF Model Name, Context is different
		String rtfModelName = request.getParameter(REQUEST_MODELNAME);
//		if (JAKARATA_VELOCITY_MODEL.equals(rtfModelName)) {
			putContextJAKARATA_VELOCITY_MODEL(request, ctx);
//		}
//		else {
			// ...... Other RTF model
//		}
	}
	
	protected InputStream getXMLFieldsAvailable(HttpServletRequest request) throws Exception {
		//	Swith RTF Model Name, XML fields available is different or can be null
		String rtfModelName = request.getParameter(REQUEST_MODELNAME);
//		if (JAKARATA_VELOCITY_MODEL.equals(rtfModelName)) {
			String xmlFieldsAvailable = "jakarta-velocity-model.fields.xml";
			InputStream inputStream = SampleRTFTemplateServlet.class.getResourceAsStream(xmlFieldsAvailable);
			return inputStream;
//		}
//		else {
			// ...... Other RTF model
//		}
//		return null;
	}
	
	protected void putContextJAKARATA_VELOCITY_MODEL(HttpServletRequest request, IContext ctx ) throws Exception {
		HashSet<String> eidSet = new HashSet<String>();
		
		RequestUtil baseRequest = new RequestUtil(request);
		String clusterKey = baseRequest.getParameter("clusterKey","wordExport");
		int selectSeq = baseRequest.getInteger("selectSeq",-1);
		LinkedList<ClusterDataBean> cdbList = ClusterDao.selectClusterDataAll(selectSeq, clusterKey);
		String eids = cdbList.getFirst().getEids();
		for(String eid : eids.split(",")){
			eid = eid.trim();
			if("".equals(eid)) continue;
			eidSet.add(eid);
		}
		
//		eidSet.add("1642569233");
//		eidSet.add("56249139730");
//		eidSet.add("34447281556");
//		eidSet.add("31044445958");
//		eidSet.add("12144259816");
//		eidSet.add("3242658286");
//		eidSet.add("67349110450");
//		eidSet.add("77954385116");
		
		GetReportData grd = new GetReportData(eidSet);
		ReportBean rb = grd.getReportData();
		rb.setClusterKey(clusterKey);
		rb.setKeywordListString(rb
				.getKeywordList().toString()
				.replaceAll("\\{", "")
				.replaceAll("\\}", "")
				.replaceAll("\t", " "));
		StringBuffer sb = new StringBuffer();
		String tmp = "";
		for (DocumentBean db : rb
				.getDocumentList()) {
			
			sb.append("("
					+ db.getCitationCount()
					+ ")["
					+ db.getEid()
					+ "-"
					+ db.getTitle().replaceAll(
							"\t", " ") + "]");
			sb.append("\\par");
		}
		rb.setDocumentInfo(sb.toString());
		
		if (rb.getKoreaOrgNameList().toString()
				.length() > 32000) {
			tmp = rb.getKoreaOrgNameList()
					.toString()
					.substring(0, 32000);
		} else {
			tmp = rb.getKoreaOrgNameList()
					.toString();
		}
		rb.getPublicationYearInfo();
		rb.getCitationPublicationYearInfo();

		rb.setKoreaInfo(tmp
				.replaceAll("\\{", "")
				.replaceAll("\\}", "")
				.replaceAll("\t", " ")
				.replaceAll("\\`", "\\\\par"));
		
		for(Integer year : rb.getPublicationYearInfo().keySet()){
			ctx.put("py_value_"+year, rb.getPublicationYearInfo().get(year));
		}
		for(Integer year : rb.getCitationPublicationYearInfo().keySet()){
			ctx.put("ci_value_"+year, rb.getCitationPublicationYearInfo().get(year));
		}
		
        ctx.put("rb", rb);		
	}
	
	/**
	 * return name of FileName for Content-Disposition
	 */
	protected String getFileNameOfContentDisposition(HttpServletRequest request) {
		String rtfModelName = "wordReport";
		if (rtfModelName != null) {
			return rtfModelName + ".rtf";
		}
		return super.getFileNameOfContentDisposition(request);
	}
    
}
