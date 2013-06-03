package kr.co.tqk.web.db.dao.export;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import kr.co.tqk.web.db.bean.export.ExportBean;

public class ExportCluster extends ExportDocument {

	BufferedWriter br = null;

	/**
	 * @param makeFileName
	 * @param selectedCheck
	 */
	public ExportCluster(String makeFileName) {
		super(makeFileName, ExportDao.CLUSTER_DATA_EXPORT);
		try {
			br = new BufferedWriter(new FileWriter(super.writeFile));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void write() {
		if (exportDataList != null) {
//			StringBuffer tmp = new StringBuffer();
			for (ExportBean eb : exportDataList) {
//				tmp.setLength(0);
				String eid = eb.getEid();
//				tmp.append(eb.getRefCitList());
				try {
					br.write(eid + "|" + eb.getRefCitList() + "\r\n");
				} catch (IOException e) {
					e.printStackTrace();
				}
				/*
				for (String refCitEID : tmp.toString().split(";")) {
					refCitEID = refCitEID.trim();
					if ("".equals(refCitEID))
						continue;
				}
				*/
			}
		}
	}

	@Override
	public void flush() {
		if (br != null)
			try {
				br.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
	}

	@Override
	public void close() {
		flush();

		if (br != null)
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
	}

}
