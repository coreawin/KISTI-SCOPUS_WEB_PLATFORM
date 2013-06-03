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
	 * Ŭ������ �м� ����� ���� �� ����Ʈ�� �ۼ��Ѵ�.
	 * 
	 * @param readFilePath
	 *            Ŭ������ ��� ������ �ִ� ���丮 ���.
	 * @param saveFilePath
	 *            �� ����Ʈ�� �ۼ��� ���丮 ���.
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

						HSSFWorkbook workbook = new HSSFWorkbook(); // ��ũ�� ����
						HSSFSheet sheet = workbook.createSheet(); // ������ ��ũ�Ͽ� ��Ʈ
																	// ����
						workbook.setSheetName(0, "Cluster");

						HSSFCellStyle style = workbook.createCellStyle(); // ����
																			// ��Ÿ��
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
						row.createCell(ccnt++).setCellValue("��з�");
						row.createCell(ccnt++).setCellValue("�з��ڵ�");
						row.createCell(ccnt++).setCellValue("�ٽɳ���");
						row.createCell(ccnt++).setCellValue("�ٽɳ�\r\n���ο��");
						row.createCell(ccnt++).setCellValue("�ٽɳ���\r\n���ο��");
						row.createCell(ccnt++).setCellValue("�ٽɳ�\r\n��տ���");
						row.createCell(ccnt++).setCellValue("�ο��\r\n��տ���");
						row.createCell(ccnt++).setCellValue("�ٽ�Ű����");
						row.createCell(ccnt++).setCellValue("�ٽɳ�");
						row.createCell(ccnt++).setCellValue("������Ȳ");
						row.createCell(ccnt++).setCellValue("���࿬����Ȳ");
						row.createCell(ccnt++).setCellValue("�ο��\r\n���࿬����Ȳ");
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
										row = sheet.createRow(rowcnt); // �ο�
										// ����(1��°�ο�,
										// ����-0��°�ο찡
										cell = row.createCell(0); // ���� �����ϰ�
										cell.setCellValue(line);
										sheet.addMergedRegion(new CellRangeAddress(
												rowcnt, rowcnt++, 0, 13));
										continue;
									}
									if (line.indexOf("[Info]") == -1) {

										if (writeCnt != 0
												&& writeCnt % 100 == 0) {
											System.out.println("Ŭ������ ������ �����."
													+ writeCnt);
										}
										writeCnt++;
										int columnCnt = 0;
										row = sheet.createRow(rowcnt++); // �ο�
										// ����(1��°�ο�,
										// ����-0��°�ο찡
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
										/* Ŭ������ Ű */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(clusterKey);
										/* ��з� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb.getAsjcLargeList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\\, ", "\r\n"));
										/* ASJC �з� */
										for (String key : rb.getAsjcList()
												.keySet()) {
											mvm.put(key, key);
											break;
										}
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb.getAsjcList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\t", " ")
												.replaceAll("\\, ", "\r\n"));
										/* �ٽɳ��� */
										// System.out.println(" �ٽɳ��� : " +
										// rb.getDocumentCount());
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(String.valueOf(rb
												.getDocumentCount()));
										/* �ٽɳ� ���ο�� */
										// System.out.println(" �ٽɳ��� ���ο��: " +
										// rb.getCitationCount());
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(String.valueOf(rb
												.getCitationCount()));
										/* �ٽɳ� �� ���ο�� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getCitationCountPerDocument());
										/* �ٽɳ� ��տ��� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getAveragePublicationYear());
										/* �ٽɳ��� �ο���鿡 ���� ��տ��� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getAverageCitationPublicationYear());
										/* �ٽɳ� Ű���� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb.getKeywordList()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\t", " ")
												.replaceAll("\\, ", "\r\n"));
										/* �ٽɳ� */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
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
										/* ������Ȳ */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
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
										/* ���࿬����Ȳ */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
										cell.setCellStyle(style);
										cell.setCellValue(rb
												.getPublicationYearInfo()
												.toString()
												.replaceAll("\\{", "")
												.replaceAll("\\}", "")
												.replaceAll("\\, ", "\r\n"));
										/* �ο�� ���࿬�� ��Ȳ */
										cell = row.createCell(columnCnt++); // ����
										// �����ϰ�
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
									row = sheet.createRow(rowcnt); // �ο�
																	// ����(1��°�ο�,
									// ����-0��°�ο찡
									cell = row.createCell(0); // ���� �����ϰ�
									cell.setCellValue("�з����� : " + s + ":"
											+ ll.size() + "\r\n");
									sheet.addMergedRegion(new CellRangeAddress(
											rowcnt, rowcnt++, 0, 13));
									break;
								}
							}
						}

						row = sheet.createRow(rowcnt); // �ο� ����(1��°�ο�, ����-0��°�ο찡
						cell = row.createCell(0); // ���� �����ϰ�
						cell.setCellValue("�ٽɳ��� : " + fullEidSet.size() + "\n");
						sheet.addMergedRegion(new CellRangeAddress(rowcnt,
								rowcnt++, 0, 13));

						row = sheet.createRow(rowcnt); // �ο� ����(1��°�ο�, ����-0��°�ο찡
						cell = row.createCell(0); // ���� �����ϰ�
						cell.setCellValue("Ŭ������ ī��Ʈ. : " + clusterCnt + "\n");
						sheet.addMergedRegion(new CellRangeAddress(rowcnt,
								rowcnt++, 0, 13));

						sheet = workbook.createSheet(); // ������ ��ũ�Ͽ� ��Ʈ ����
						workbook.setSheetName(1, "Add Info");

						// TODO Ŭ������ ��ȣ���� EID�� ����
						int rowCnt = 0;
						row = sheet.createRow(rowCnt++);
						ccnt = 0;
						row.createCell(ccnt++).setCellValue("CK");
						row.createCell(ccnt++).setCellValue("EID");
						row.createCell(ccnt++).setCellValue("����⵵");
						row.createCell(ccnt++).setCellValue("REF ����");
						row.createCell(ccnt++).setCellValue("CIT ����");
						row.createCell(ccnt++).setCellValue("���θ�");
						row.createCell(ccnt++).setCellValue("��������");
						row.createCell(ccnt++).setCellValue("���, ����, ����");
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
								cell = row.createCell(columnCnt++); // ���� �����ϰ�
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
								// TODO �ʹ� ���.
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
						System.out.println("����"); // ������ ������ "����"�̶�� �޽����� ������
													// E����̺꿡
						// ���ϻ�����
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
		HSSFCellStyle style = workbook.createCellStyle(); // ���� ��Ÿ��
		style.setWrapText(true);
		style.setAlignment(HSSFCellStyle.VERTICAL_TOP);
		return style;
	}

}
