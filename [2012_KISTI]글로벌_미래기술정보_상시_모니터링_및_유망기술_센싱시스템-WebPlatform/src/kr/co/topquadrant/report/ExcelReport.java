package kr.co.topquadrant.report;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;

import kr.co.topquadrant.db.bean.ClusterDocument;
import kr.co.topquadrant.db.bean.ClusterDocumentExcelExport;
import kr.co.topquadrant.db.dao.IResearchFrontDao;
import kr.co.topquadrant.db.dao.ResearchFrontDAO;
import kr.co.topquadrant.db.mybatis.MyBatisParameter;
import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

public class ExcelReport {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		String param = "1_49_21;";
		List<ClusterDocumentExcelExport> list = new LinkedList<ClusterDocumentExcelExport>();

		if(param!=null){
			String[] paramsArray = param.split(";");
			
			IResearchFrontDao dao = new ResearchFrontDAO();
			for(String paramInfo : paramsArray){
				String[] params = paramInfo.split("_");
				int seq = Integer.parseInt(params[0]);
				int consecutiveNumber = Integer.parseInt(params[1]);
				int updateFlag = Integer.parseInt(params[2]);
				MyBatisParameter mbp = new MyBatisParameter();
				mbp.setSeq(seq);
				mbp.setConsecutiveNumber(consecutiveNumber);
				mbp.setUpdate_flag(updateFlag);
				ClusterDocument cd = dao.getClusterResultInfo(mbp);
				list.add(new ClusterDocumentExcelExport(cd));
			}
		}
		
		Map beans = new HashMap();
		beans.put("cdlist", list);
		XLSTransformer transformer = new XLSTransformer();
		String templateFileName = "d:\\Neon\\Distribution\\TemplateExportCluster.xlsx";
		String outputFileName = "d:\\Neon\\Distribution\\outputFormat.xlsx";
		try {
			transformer.transformXLS(templateFileName, beans, outputFileName);
		} catch (ParsePropertyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
