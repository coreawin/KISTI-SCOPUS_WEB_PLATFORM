package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Scanner;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.analysis.report.DocumentBean;
import kr.co.tqk.analysis.report.GetDocumentData;
import kr.co.tqk.analysis.report.GetReportData;
import kr.co.tqk.analysis.report.ReportBean;
import kr.co.tqk.db.ConnectionFactory;

import org.apache.commons.collections.map.MultiValueMap;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;

public class ReportForExcelLauncher {

	String readFilePath;
	String saveFilePath;

	/**
	 * 클러스터 분석 결과에 대한 상세 리포트를 작성한다.
	 * 
	 * @param readFilePath
	 *            클러스터 결과 파일이 있는 디렉토리 경로.
	 * @param saveFilePath
	 *            상세 리포트가 작성될 디렉토리 경로.
	 * @throws SQLException
	 */
	public ReportForExcelLauncher(String readFilePath, String saveFilePath)
			throws SQLException {
		this.readFilePath = readFilePath;
		this.saveFilePath = saveFilePath;
		reportForExcel();
	}

	private void reportForExcel() throws SQLException {
		File file = new File(readFilePath);
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		try {
			if (file.isDirectory()) {
				conn = cf.getConnection();
				for (File f : file.listFiles()) {
					if (f.isDirectory())
						continue;
					String name = f.getName();
					String classification = name.split("_")[4];
					System.out.println("read file : " + name);
					File dir = new File(saveFilePath);
					if (!dir.isDirectory()) {
						dir.mkdirs();
					}
					String fileWriterPath = saveFilePath + "Report_" + name
							+ ".xls";

					try {
						Scanner scanner = new Scanner(f);
						int clusterCnt = 0;
						int documentCnt = 0;
						MultiValueMap mvm = new MultiValueMap();
						LinkedHashMap<String, LinkedHashSet<String>> clusterEidMap = new LinkedHashMap<String, LinkedHashSet<String>>();
						HashSet<String> fullEidSet = new HashSet<String>();

						HSSFWorkbook workbook = new HSSFWorkbook(); // 워크북 생성
						HSSFSheet sheet = workbook.createSheet(); // 생성한 워크북에 시트
																	// 생성
						workbook.setSheetName(0, "Cluster");

						HSSFCellStyle style = workbook.createCellStyle(); // 셀의
																			// 스타일
						style.setVerticalAlignment(CellStyle.VERTICAL_TOP);
						style.setWrapText(true);

						int rowcnt = 0;
						HSSFCell cell = null;
						HSSFRow row = null;

						row = sheet.createRow(rowcnt++);
						int ccnt = 0;
						cell = row.createCell(ccnt++);
						style.setWrapText(true);
						row.setRowStyle(style);
						row.createCell(ccnt++).setCellValue("대분류");
						row.createCell(ccnt++).setCellValue("분류코드");
						row.createCell(ccnt++).setCellValue("핵심논문수");
						row.createCell(ccnt++).setCellValue("핵심논문\r\n피인용수");
						row.createCell(ccnt++).setCellValue("핵심논문당\r\n피인용수");
						row.createCell(ccnt++).setCellValue("핵심논문\r\n평균연도");
						row.createCell(ccnt++).setCellValue("인용논문\r\n평균연도");
						row.createCell(ccnt++).setCellValue("핵심키워드");
						row.createCell(ccnt++).setCellValue("핵심논문");
						row.createCell(ccnt++).setCellValue("국내현황");
						row.createCell(ccnt++).setCellValue("발행연도현황");
						row.createCell(ccnt++).setCellValue("인용논문\r\n발행연도현황");
						String clusterKey = "";
						int writeCnt = 0;
						while (scanner.hasNextLine()) {
							String tmp = "";
							String line = scanner.nextLine();
							if (line != null) {
								line = line.trim();
								if (!"".equals(line.trim())) {
									if (line.startsWith("[")) {
										// bw.write(line + "\n");
										row = sheet.createRow(rowcnt); // 로우
										// 생성(1번째로우,
										// 참고-0번째로우가
										cell = row.createCell(0); // 셀을 생성하고
										cell.setCellValue(line);
										sheet.addMergedRegion(new CellRangeAddress(
												rowcnt, rowcnt++, 0, 13));
										continue;
									}
									if (line.indexOf("[Info]") == -1) {

										if (writeCnt != 0
												&& writeCnt % 100 == 0) {
											System.out.println("클러스터 데이터 기록중."
													+ writeCnt);
										}
										writeCnt++;
										int columnCnt = 0;
										row = sheet.createRow(rowcnt++); // 로우
										// 생성(1번째로우,
										// 참고-0번째로우가
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
										/* 클러스터 키 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(clusterKey);
										/* 대분류 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb.getAsjcLargeList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\\, ", "\r\n"));
										/* ASJC 분류 */
										for (String key : rb.getAsjcList()
												.keySet()) {
											mvm.put(key, key);
											break;
										}
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb.getAsjcList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\t", " ")
												.replaceAll("\\, ", "\r\n"));
										/* 핵심논문수 */
										// System.out.println(" 핵심논문수 : " +
										// rb.getDocumentCount());
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(String.valueOf(rb
												.getDocumentCount()));
										/* 핵심논문 피인용수 */
										// System.out.println(" 핵심논문수 피인용수: " +
										// rb.getCitationCount());
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(String.valueOf(rb
												.getCitationCount()));
										/* 핵심논문 당 피인용수 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getCitationCountPerDocument());
										/* 핵심논문 평균연도 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getAveragePublicationYear());
										/* 핵심논문의 인용논문들에 대한 평균연도 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getAverageCitationPublicationYear());
										/* 핵심논문 키워드 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb.getKeywordList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\t", " ")
												.replaceAll("\\, ", "\r\n"));
										/* 핵심논문 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										StringBuffer sb = new StringBuffer();
										LinkedHashSet<String> eidListSet = null;
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
											sb.append("("
													+ db.getCitationCount()
													+ ")["
													+ db.getEid()
													+ "-"
													+ db.getTitle().replaceAll(
															"\t", " ") + "]");
											sb.append("\r\n");
										}
										cell.setCellValue(sb.toString());
										/* 국내현황 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										if (rb.getKoreaOrgNameList().toString()
												.length() > 32000) {
											tmp = rb.getKoreaOrgNameList()
													.toString()
													.substring(0, 32000);
										} else {
											tmp = rb.getKoreaOrgNameList()
													.toString();
										}
										cell.setCellValue(tmp
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\t", " ")
												.replaceAll("\\`", "\r\n"));
										/* 발행연도현황 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getPublicationYearInfo()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\\, ", "\r\n"));
										/* 인용논문 발행연도 현황 */
										cell = row.createCell(columnCnt++); // 셀을
										// 생성하고
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getCitationPublicationYearInfo()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\\, ", "\r\n"));
									}
								}
							}
						}

						MultiValueMap mvmMap = new MultiValueMap();
						for (Object key : mvm.keySet()) {
							mvmMap.put(mvm.getCollection(key).size(),
									(List<String>) mvm.get(key));
						}

						SortedMap<Integer, List> sortedMap = new TreeMap<Integer, List>(
								Collections.reverseOrder());
						for (Object key : mvmMap.keySet()) {
							sortedMap.put(
									Integer.parseInt(String.valueOf(key)),
									(List<String>) mvmMap.get(key));
						}

						for (Integer i : sortedMap.keySet()) {
							List<List> list = (List<List>) sortedMap.get(i);
							for (List<String> ll : list) {
								for (String s : ll) {
									row = sheet.createRow(rowcnt); // 로우
																	// 생성(1번째로우,
									// 참고-0번째로우가
									cell = row.createCell(0); // 셀을 생성하고
									cell.setCellValue("분류정보 : " + s + ":"
											+ ll.size() + "\r\n");
									sheet.addMergedRegion(new CellRangeAddress(
											rowcnt, rowcnt++, 0, 13));
									break;
								}
							}
						}

						row = sheet.createRow(rowcnt); // 로우 생성(1번째로우, 참고-0번째로우가
						cell = row.createCell(0); // 셀을 생성하고
						cell.setCellValue("핵심논문수 : " + fullEidSet.size() + "\n");
						sheet.addMergedRegion(new CellRangeAddress(rowcnt,
								rowcnt++, 0, 13));

						row = sheet.createRow(rowcnt); // 로우 생성(1번째로우, 참고-0번째로우가
						cell = row.createCell(0); // 셀을 생성하고
						cell.setCellValue("클러스터 카운트. : " + clusterCnt + "\n");
						sheet.addMergedRegion(new CellRangeAddress(rowcnt,
								rowcnt++, 0, 13));

						sheet = workbook.createSheet(); // 생성한 워크북에 시트 생성
						workbook.setSheetName(1, "Add Info");

						// TODO 클러스터 번호별로 EID를 구축
						int rowCnt = 0;
						row = sheet.createRow(rowCnt++);
						ccnt = 0;
						row.createCell(ccnt++).setCellValue("CK");
						row.createCell(ccnt++).setCellValue("EID");
						row.createCell(ccnt++).setCellValue("발행년도");
						row.createCell(ccnt++).setCellValue("REF 갯수");
						row.createCell(ccnt++).setCellValue("CIT 갯수");
						row.createCell(ccnt++).setCellValue("저널명");
						row.createCell(ccnt++).setCellValue("문서제목");
						row.createCell(ccnt++).setCellValue("기관, 국가, 저자");
						row.createCell(ccnt++).setCellValue("Abstract");
						
						for (String clusterKeyNo : clusterEidMap.keySet()) {
							LinkedHashSet<String> eidSet = clusterEidMap
									.get(clusterKeyNo);
							GetDocumentData gdd = new GetDocumentData(conn,
									eidSet);
							HashMap<String, DocumentBean> dbSet = gdd.getDocumentInfo();
							row = sheet.createRow(rowCnt++);
							ccnt = 0;
							for (String eid : dbSet.keySet()) {
								DocumentBean db = dbSet.get(eid);
								int columnCnt = 0;
								row = sheet.createRow(rowCnt++);
								cell = row.createCell(columnCnt++); // 셀을 생성하고
								cell.setCellStyle(style);
								cell.setCellValue(clusterKeyNo);

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(db.getEid());

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(String.valueOf(db
										.getPublicationYear()));

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(String.valueOf(db
										.getReferenceCount()));

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(String.valueOf(db
										.getCitationCount()));

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(db.getSourceTitle());

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(db.getTitle());

								MultiValueMap mvmDB = db
										.getKoreaOrgAndAuthorNameInfo();
								StringBuffer sb = new StringBuffer();
								if (mvmDB != null) {
									for (Object okey : mvmDB.keySet()) {
										sb.append(okey + "\t");
										List<String> list = (List<String>) mvmDB
												.get(okey);
										for (String s : list) {
											sb.append("(" + s + ")");
										}
										sb.append("\r\n");
									}
								}
								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								// TODO 너무 길다.
								if (sb.toString().length() > 32000) {
									sb.setLength(32000);
								}
								cell.setCellValue(sb.toString());

								cell = row.createCell(columnCnt++);
								cell.setCellStyle(style);
								cell.setCellValue(db.getAbs());
							}
						}
						FileOutputStream fs = null;
						try {
							fs = new FileOutputStream(fileWriterPath);
							workbook.write(fs);
						} catch (Exception e) {
							e.printStackTrace();
						} finally {
							if (fs != null)
								fs.close();
						}
						System.out.println("성공"); // 파일을 돌리면 "성공"이라는 메시지가 찍히고
													// E드라이브에
						// 파일생성됨
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

	public static HSSFCellStyle getDefaultStyle(HSSFWorkbook workbook) {
		HSSFCellStyle style = workbook.createCellStyle(); // 셀의 스타일
		style.setWrapText(true);
		style.setAlignment(HSSFCellStyle.VERTICAL_TOP);
		return style;
	}

}
