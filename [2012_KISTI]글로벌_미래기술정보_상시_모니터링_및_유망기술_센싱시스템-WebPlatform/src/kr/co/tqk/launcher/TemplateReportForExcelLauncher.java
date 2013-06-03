package kr.co.tqk.launcher;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
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

public class TemplateReportForExcelLauncher {

	String templateFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/Cluster_보고서_템플릿.xlsx";
	String readFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/target/";
	String saveFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/reportResult/nano/result/";

	public TemplateReportForExcelLauncher(String string, String string2,
			String string3) {
		templateFilePath = string;
		readFilePath = string2;
		saveFilePath = string3;
		try {
			reportForExcel();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public TemplateReportForExcelLauncher() {
	}

	public void reportForExcel() throws SQLException {
		File saveDir = new File(saveFilePath);
		if (!saveDir.isDirectory()) {
			saveDir.mkdirs();
		}

		File file = new File(readFilePath);
		System.out.println("readFilePath " + readFilePath);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		List<ReportBean> rbList = null;
		try {
			if (file.isDirectory()) {
				conn = cf.getConnection();
				for (File f : file.listFiles()) {
					if (f.isDirectory())
						continue;
					String name = f.getName();
					rbList = new LinkedList<ReportBean>();
					System.out.println(name);
					// if(name.indexOf("result_0.1_50_5_Car_kisti.txt")==-1)
					// continue;
//					String classification = name.split("_")[4];
					String fileWriterPath = saveFilePath + "Template_report_"
							+ name;

					try {
						int clusterCnt = 0;
						int documentCnt = 0;
						MultiValueMap mvm = new MultiValueMap();
						LinkedHashMap<String, LinkedHashSet<String>> clusterEidMap = new LinkedHashMap<String, LinkedHashSet<String>>();
						HashSet<String> fullEidSet = new HashSet<String>();
						String clusterKey = "";
						int writeCnt = 0;
						System.out.println("read file __ : " + name);

						if (name.endsWith(".xlsx")) {
							// 2007 이하 엑셀 보고서 파일을 읽는 경우
							System.out.println("read Excel 2007 ");
							FileInputStream inputStream = new FileInputStream(f);
							XSSFWorkbook workbook = new XSSFWorkbook(
									inputStream);
							XSSFSheet sheet = workbook.getSheetAt(0); // 첫번째 쉬트
							int rows = sheet.getPhysicalNumberOfRows(); // 행개수
							System.out.println("rows " + rows);
							for (int i = 1; i < rows; i++) {
								String tmp = "";
								XSSFRow row = sheet.getRow(i); // row 가져오기
								XSSFCell clusterKeycell = row.getCell(0);
								clusterKey = clusterKeycell
										.getStringCellValue().trim();
								XSSFCell eidDatacell = row.getCell(9);
								String eidData = null;
								try {
									eidData = eidDatacell.getStringCellValue()
											.trim();
								} catch (Exception e) {
									continue;
								}

								Pattern p = Pattern.compile("[0-9]{9,12}");
								Matcher m = p.matcher(eidData);
								HashSet<String> eidSet = new HashSet<String>();
								while (m.find()) {
									eidSet.add(m.group().trim());
								}
								documentCnt += eidSet.size();
								clusterCnt++;
								System.out.println("Making Cluster Report :"
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
								if(eidDatacell==null) continue;
								if(eidDatacell.getStringCellValue()==null) continue;
								String eidData = eidDatacell.getStringCellValue().trim();

								Pattern p = Pattern.compile("[0-9]{9,12}");
								Matcher m = p.matcher(eidData);
								HashSet<String> eidSet = new HashSet<String>();
								while (m.find()) {
									eidSet.add(m.group().trim());
								}
								documentCnt += eidSet.size();
								clusterCnt++;
								System.out.println("Making Cluster Report :"
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
							while (scanner.hasNextLine()) {
								String tmp = "";
								String line = scanner.nextLine();
								System.out.println(line);
								if (line != null) {
									line = line.trim();
									if (!"".equals(line.trim())) {
										if (line.startsWith("[")) {
											continue;
										}
										if (line.indexOf("[Info]") == -1) {

											if (writeCnt != 0
													&& writeCnt % 100 == 0) {
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
							System.out.println( writeCnt +"개에 대한 클러스터의 핵심논문에 대한 정보를 모두 가져왔습니다.");
						}
						List<List<ReportBean>> result = new ArrayList<List<ReportBean>>();
						List<ReportBean> _10RBList = new ArrayList<ReportBean>();
						;

						int cnt = 0;
						for (ReportBean rb : rbList) {
							if (cnt > 10) {
								result.add(_10RBList);
								_10RBList = new ArrayList<ReportBean>();
								cnt = 0;
							}
							_10RBList.add(rb);
							cnt++;
						}
						result.add(_10RBList);

						InputStream is = new BufferedInputStream(new FileInputStream(templateFilePath));
						XLSTransformer transformer = new XLSTransformer();
						List sheetNames = new ArrayList();
						for(int i = 0; i < result.size(); i++){
							List<ReportBean> department = (List<ReportBean>) result.get( i );
						    sheetNames.add(String.valueOf(i));
						}
						
						System.out.println("시트별 보고서 작성을 시작합니다.");
						XSSFWorkbook resultWorkbook = (XSSFWorkbook) transformer
								.transformMultipleSheetsList(is, result,
										sheetNames, "rbList",
										new HashMap(), 0);
						System.out.println("보고서 취합이 완료되어 보고서 파일을 생성합니다.");
	
						FileOutputStream fs = new FileOutputStream(fileWriterPath+".xlsx");
						resultWorkbook.write(fs);
						System.out.println("보고서 파일이 성공적으로 생성되었습니다!! " + fileWriterPath+".xlsx");
						
						
//						Map<String, Object> beans = new HashMap<String, Object>();
//						beans.put("rbList", rbList);
//						XLSTransformer transformer = new XLSTransformer();
//						System.out.println("write path " + fileWriterPath);
//						System.out.println("===========" + rbList.size());
//						transformer.transformXLS(templateFilePath, beans,
//								fileWriterPath);

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

					} catch (FileNotFoundException e) {
						e.printStackTrace();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			cf.close(conn);
		}
	}

	public static void main(String[] args) throws Exception {
		System.out.println("AAAAAAAAAAAAAAAAA TemplateReportForExcelLauncher" );
		TemplateReportForExcelLauncher task = new TemplateReportForExcelLauncher();

		if (args.length == 3) {
			task = new TemplateReportForExcelLauncher(args[0], args[1], args[2]);
		}
		task.reportForExcel();

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
