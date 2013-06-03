package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import kr.co.tqk.analysis.report.DocumentBean;
import kr.co.tqk.analysis.report.GetReportData;
import kr.co.tqk.analysis.report.ReportBean;
import kr.co.tqk.db.ConnectionFactory;
import net.sf.jxls.transformer.XLSTransformer;

import org.apache.commons.collections.map.MultiValueMap;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class TemplateReportForExcelLauncher2 {

	String templateFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/Cluster_보고서_템플릿.xlsx";
	String readFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/target/tmp";
	String saveFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/tmp";

	/**
	 * 
	 * @param string
	 *            엑셀 템플릿 파일 경로
	 * @param string2
	 *            클러스터 결과 파일이 있는 디렉토리
	 * @param string3
	 *            보고서 파일이 생성될 디렉토리
	 * @throws SQLException 
	 */
	public TemplateReportForExcelLauncher2(String string, String string2,
			String string3) throws SQLException {
		templateFilePath = string;
		readFilePath = string2;
		saveFilePath = string3;
		reportForExcel();
	}

	public TemplateReportForExcelLauncher2() {
		System.out.println("execute ");
	}

	public void reportForExcel() throws SQLException {
		File saveDir = new File(saveFilePath);
		if (!saveDir.isDirectory()) {
			saveDir.mkdirs();
		}

		File file = new File(readFilePath);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		List<ReportBean> rbList = new LinkedList<ReportBean>();
		try {
			if (file.isDirectory()) {
				for (File f : file.listFiles()) {
					
					if (f.isDirectory())
						continue;
					String name = f.getName();
					// if(name.indexOf("result_0.1_50_5_Car_kisti.txt")==-1)
					// continue;
					String classification = name.split("_")[4];
					String fileWriterPath = saveFilePath + "Template_report_"
							+ name + ".xlsx";

					try {
						conn = cf.getConnection();
						int clusterCnt = 0;
						int documentCnt = 0;
						MultiValueMap mvm = new MultiValueMap();
						LinkedHashMap<String, LinkedHashSet<String>> clusterEidMap = new LinkedHashMap<String, LinkedHashSet<String>>();
						HashSet<String> fullEidSet = new HashSet<String>();
						String clusterKey = "";
						
						System.out.println("read file __ : " + name);

						if (name.endsWith(".xlsx")) {
							// 2007 이하 엑셀 보고서 파일을 읽는 경우
							System.out.println("read Excel 2007 ");
							FileInputStream inputStream = new FileInputStream(f);
							XSSFWorkbook workbook = new XSSFWorkbook(
									inputStream);
							XSSFSheet sheet = workbook.getSheetAt(0); // 첫번째 쉬트
							int rows = sheet.getPhysicalNumberOfRows(); // 행개수
							for (int i = 1; i < rows; i++) {
								String tmp = "";
								XSSFRow row = sheet.getRow(i); // row 가져오기
								XSSFCell clusterKeycell = row.getCell(0);
								clusterKey = clusterKeycell
										.getStringCellValue().trim();
								XSSFCell eidDatacell = row.getCell(9);
								String eidData = eidDatacell
										.getStringCellValue().trim();

								Pattern p = Pattern.compile("[0-9]{9,12}");
								Matcher m = p.matcher(eidData);
								HashSet<String> eidSet = new HashSet<String>();
								while (m.find()) {
									eidSet.add(m.group().trim());
								}
								documentCnt += eidSet.size();
								clusterCnt++;
								System.out.println("Making Cluster Report "
										+ clusterKey + "\t" + (clusterCnt));
								GetReportData grd = new GetReportData(conn,
										eidSet);
								ReportBean rb = grd.getReportData();
								rb.setClusterKey(clusterKey);
								for (String key : rb.getAsjcList().keySet()) {
									mvm.put(key, key);
									break;
								}
								rb.setKeywordListString(rb.getKeywordList()
										.toString().replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " "));
								StringBuffer sb = new StringBuffer();
								LinkedHashSet<String> eidListSet = null;
								int cnt = 0;
								for (DocumentBean db : rb.getDocumentList()) {
									if (clusterEidMap.containsKey(clusterKey)) {
										eidListSet = clusterEidMap
												.get(clusterKey);
									} else {
										eidListSet = new LinkedHashSet<String>();
									}
									eidListSet.add(db.getEid());
									clusterEidMap.put(clusterKey, eidListSet);

									fullEidSet.add(db.getEid());

									if (cnt > 9)
										continue;

									sb.append("("
											+ db.getCitationCount()
											+ ")["
											+ db.getEid()
											+ "-"
											+ db.getTitle().replaceAll("\t",
													" ") + "]");
									sb.append("\r\n");
									cnt++;
								}
								rb.setDocumentInfo(sb.toString());
								if (rb.getKoreaOrgNameList().toString()
										.length() > 32000) {
									tmp = rb.getKoreaOrgNameList().toString()
											.substring(0, 32000);
								} else {
									tmp = rb.getKoreaOrgNameList().toString();
								}
								rb.getPublicationYearInfo();
								rb.getCitationPublicationYearInfo();

								rb.setKoreaInfo(tmp.replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " ")
										.replaceAll("\\`", "\r\n"));

								tmp = "";
								if (rb.getTopCitationCountOrgAndAuthorNameList()
										.toString().length() > 32000) {
									tmp = rb.getTopCitationCountOrgAndAuthorNameList()
											.toString().substring(0, 32000);
								} else {
									tmp = rb.getTopCitationCountOrgAndAuthorNameList()
											.toString();
								}
								rb.setTopCitationOrgCountyInfo(tmp
										.replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " ")
										.replaceAll("\\`", "\r\n"));

								rbList.add(rb);
							}
						} else if (name.endsWith(".xls")) {
							// 2003 이하 엑셀 보고서 파일을 읽는 경우
							System.out.println("read Excel 2003");
							FileInputStream inputStream = new FileInputStream(f);
							POIFSFileSystem fileSystem = new POIFSFileSystem(
									inputStream);
							HSSFWorkbook workbook = new HSSFWorkbook(fileSystem);
							HSSFSheet sheet = workbook.getSheetAt(0); // 첫번째 쉬트
							int rows = sheet.getPhysicalNumberOfRows(); // 행개수
							for (int i = 1; i < rows; i++) {
								String tmp = "";
								HSSFRow row = sheet.getRow(i); // row 가져오기
								HSSFCell clusterKeycell = row.getCell(0);
								clusterKey = clusterKeycell
										.getStringCellValue().trim();
								HSSFCell eidDatacell = row.getCell(9);
								String eidData = eidDatacell
										.getStringCellValue().trim();

								Pattern p = Pattern.compile("[0-9]{9,12}");
								Matcher m = p.matcher(eidData);
								HashSet<String> eidSet = new HashSet<String>();
								while (m.find()) {
									eidSet.add(m.group().trim());
								}
								documentCnt += eidSet.size();
								clusterCnt++;
								System.out.println("Making Cluster Report "
										+ clusterKey + "\t" + (clusterCnt));
								GetReportData grd = new GetReportData(conn,
										eidSet);
								ReportBean rb = grd.getReportData();
								rb.setClusterKey(clusterKey);
								for (String key : rb.getAsjcList().keySet()) {
									mvm.put(key, key);
									break;
								}
								rb.setKeywordListString(rb.getKeywordList()
										.toString().replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " "));
								StringBuffer sb = new StringBuffer();
								LinkedHashSet<String> eidListSet = null;
								int cnt = 0;
								for (DocumentBean db : rb.getDocumentList()) {
									if (clusterEidMap.containsKey(clusterKey)) {
										eidListSet = clusterEidMap
												.get(clusterKey);
									} else {
										eidListSet = new LinkedHashSet<String>();
									}
									eidListSet.add(db.getEid());
									clusterEidMap.put(clusterKey, eidListSet);

									fullEidSet.add(db.getEid());

									if (cnt > 9)
										continue;

									sb.append("("
											+ db.getCitationCount()
											+ ")["
											+ db.getEid()
											+ "-"
											+ db.getTitle().replaceAll("\t",
													" ") + "]");
									sb.append("\r\n");
									cnt++;
								}
								rb.setDocumentInfo(sb.toString());
								if (rb.getKoreaOrgNameList().toString()
										.length() > 32000) {
									tmp = rb.getKoreaOrgNameList().toString()
											.substring(0, 32000);
								} else {
									tmp = rb.getKoreaOrgNameList().toString();
								}
								rb.getPublicationYearInfo();
								rb.getCitationPublicationYearInfo();

								rb.setKoreaInfo(tmp.replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " ")
										.replaceAll("\\`", "\r\n"));

								tmp = "";
								if (rb.getTopCitationCountOrgAndAuthorNameList()
										.toString().length() > 32000) {
									tmp = rb.getTopCitationCountOrgAndAuthorNameList()
											.toString().substring(0, 32000);
								} else {
									tmp = rb.getTopCitationCountOrgAndAuthorNameList()
											.toString();
								}
								rb.setTopCitationOrgCountyInfo(tmp
										.replaceAll("\\{", "")
										.replaceAll("\\}", "")
										.replaceAll("\t", " ")
										.replaceAll("\\`", "\r\n"));

								rbList.add(rb);
							}
						} else {
							// 텍스트 형태의 원시 클러스터 결과 파일을 읽는 경우.
							Scanner scanner = new Scanner(f);
							int writeCnt = 0;
							while (scanner.hasNextLine()) {
								String tmp = "";
								String line = scanner.nextLine();
								if (line != null) {
									line = line.trim();
									if (!"".equals(line.trim())) {
										if (line.startsWith("[")) {
											continue;
										}
										if (line.indexOf("[Info]") == -1) {

											if (writeCnt != 0
													&& writeCnt % 10 == 0) {
												System.out
														.println( writeCnt +"개에 대한 클러스터의 핵심논문에 대한 정보를 가져왔습니다.");
											}
											writeCnt++;
											String data = line.substring(
													line.indexOf(":") + 1,
													line.length());
											String[] eids = data.split(",");
											HashSet<String> eidSet = new HashSet<String>();
											for (String eid : eids) {
												if (!"".equals(eid.trim())) {
													eidSet.add(eid);
												}
											}
											clusterKey = line.substring(0,
													line.indexOf(":"));
											documentCnt += eidSet.size();
											clusterCnt++;
											GetReportData grd = new GetReportData(
													conn, eidSet);
											ReportBean rb = grd.getReportData();
											rb.setClusterKey(clusterKey);
											for (String key : rb.getAsjcList()
													.keySet()) {
												mvm.put(key, key);
												break;
											}
											rb.setKeywordListString(rb
													.getKeywordList()
													.toString()
													.replaceAll("\\{", "")
													.replaceAll("\\}", "")
													.replaceAll("\t", " "));
											StringBuffer sb = new StringBuffer();
											LinkedHashSet<String> eidListSet = null;
											int cnt = 0;
											for (DocumentBean db : rb
													.getDocumentList()) {
												if (clusterEidMap
														.containsKey(clusterKey)) {
													eidListSet = clusterEidMap
															.get(clusterKey);
												} else {
													eidListSet = new LinkedHashSet<String>();
												}
												eidListSet.add(db.getEid());
												clusterEidMap.put(clusterKey,
														eidListSet);

												fullEidSet.add(db.getEid());

												if (cnt > 9)
													continue;

												sb.append("("
														+ db.getCitationCount()
														+ ")["
														+ db.getEid()
														+ "-"
														+ db.getTitle()
																.replaceAll(
																		"\t",
																		" ")
														+ "]");
												sb.append("\r\n");
												cnt++;
											}
											rb.setDocumentInfo(sb.toString());
											if (rb.getKoreaOrgNameList()
													.toString().length() > 32000) {
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
													.replaceAll("\\`", "\r\n"));

											tmp = "";
											if (rb.getTopCitationCountOrgAndAuthorNameList()
													.toString().length() > 32000) {
												tmp = rb.getTopCitationCountOrgAndAuthorNameList()
														.toString()
														.substring(0, 32000);
											} else {
												tmp = rb.getTopCitationCountOrgAndAuthorNameList()
														.toString();
											}
											rb.setTopCitationOrgCountyInfo(tmp
													.replaceAll("\\{", "")
													.replaceAll("\\}", "")
													.replaceAll("\t", " ")
													.replaceAll("\\`", "\r\n"));

											rbList.add(rb);
										}
									}
								}
							}
							scanner.close();
						}
						cf.close(conn);
						Map<String, Object> beans = new HashMap<String, Object>();
						beans.put("rbList", rbList);
						XLSTransformer transformer = new XLSTransformer();
						System.out.println("write path " + fileWriterPath);
						transformer.transformXLS(templateFilePath, beans,
								fileWriterPath);
//						System.out.println("===========" + rbList.size());

						// MultiValueMap mvmMap = new MultiValueMap();
						// for (Object key : mvm.keySet()) {
						// mvmMap.put(mvm.getCollection(key).size(),
						// (List<String>) mvm.get(key));
						// }
						//
						// SortedMap<Integer, List> sortedMap = new
						// TreeMap<Integer, List>(
						// Collections.reverseOrder());
						// for (Object key : mvmMap.keySet()) {
						// sortedMap.put(
						// Integer.parseInt(String.valueOf(key)),
						// (List<String>) mvmMap.get(key));
						// }

						System.out.println("보고서 생성 완료 => " + name); // 파일을 돌리면 "성공"이라는 메시지가 찍히고
													// E드라이브에
						// 파일생성됨

					} catch (FileNotFoundException e) {
						e.printStackTrace();
					} catch (Exception e) {
						e.printStackTrace();
					}finally {
//						cf.close(conn);
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} 
	}

	public static void main(String[] args) throws Exception {

		TemplateReportForExcelLauncher2 task = new TemplateReportForExcelLauncher2();
		// args = new String[]{
		// "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/Cluster_보고서_템플릿.xlsx",
		// "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/target/tmp",
		// "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/tmp"};

		if (args.length == 3) {
			task = new TemplateReportForExcelLauncher2(args[0], args[1], args[2]);
		}
		task.reportForExcel();
		// Timer timer = new Timer();
		// Calendar cal = Calendar.getInstance();
		// cal.set(Calendar.SECOND, 5);
		// cal.setTimeInMillis(System.currentTimeMillis());
		// System.out.println(cal.getTime() +"\t" + new Date());
		// cal.add(Calendar.HOUR, 3);
		// cal.add(Calendar.MINUTE, 30);
		// System.out.println(" preserve execute time : " + cal.getTime());
		// timer.schedule(task, cal.getTime());

	}

	// @Override
	public void run() {
		System.out.println(Calendar.getInstance().getTime());
		try {
			reportForExcel();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
