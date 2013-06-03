package kr.co.tqk.web.util.file;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadFileComponent {
	private List<String> saveFileNameList = new ArrayList<String>();
	private List<String> originalFileNameList = new ArrayList<String>();
	private List<Long> fileSizeList = new ArrayList<Long>();
	private List<FileMap> fileMapList = new ArrayList<FileMap>();
	private HttpServletRequest request = null;
	String repositoryPath = null;

	public UploadFileComponent(HttpServletRequest request, String repositoryPath) {
		this.request = request;
		this.repositoryPath = repositoryPath;
	}

	private HashMap<String, Object> parameter = new HashMap<String, Object>();

	/**
	 * 파일을 업로드 하고 기타 폼의 파라미터를 HashMap형태로 가져온다.
	 * 
	 * @return 파일형태가 아닌 일반폼의 파라미터.
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> uploadFile() throws Exception {
		if (request == null)
			throw new IllegalArgumentException("request cannot be null");
		if (repositoryPath == null)
			throw new IllegalArgumentException("saveDirectory cannot be null");

		String fileName = "";
		String saveFileName = "";
		File file = new File(repositoryPath);
		if (file.isDirectory() == false) {
			file.mkdirs();
		}
		if (ServletFileUpload.isMultipartContent(request)) {
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(new File(repositoryPath));
			factory.setSizeThreshold(1024 * 1024 * 5);

			ServletFileUpload fileUpload = new ServletFileUpload(factory);
			fileUpload.setHeaderEncoding("UTF-8");
			fileUpload.setSizeMax(102400000);
			if (request.getContentLength() < fileUpload.getSizeMax()) {
				List<FileItem> list = (List<FileItem>) fileUpload
						.parseRequest(request);
				Iterator<FileItem> iter = list.iterator();
				while (iter.hasNext()) {
					FileItem item = iter.next();
					fileName = item.getFieldName();
					if (item.isFormField()) {
						String parameterValue = item.getString("UTF-8");
						Object obj = null;
						if (parameter.containsKey(fileName)) {
							obj = parameter.get(fileName);

						} else {
							obj = new LinkedList<String>();
						}
						LinkedList<String> tmpList = (LinkedList<String>) obj;
						tmpList.add(parameterValue);
						parameter.put(fileName, tmpList);
					} else {
						if (item.getSize() > 0) {
							int idx = item.getName().lastIndexOf("\\");
							if (idx == -1) {
								idx = item.getName().lastIndexOf("/");
							}
							fileName = item.getName().substring(idx + 1);
							FileUtil fh = new FileUtil();
							saveFileName = fh.uploadFileName(fileName);
							File uploadedFile = new File(repositoryPath,
									saveFileName);
							item.write(uploadedFile);
							fileMapList
									.add(new FileMap(fileName, saveFileName));
							saveFileNameList.add(saveFileName);
							originalFileNameList.add(fileName);
							fileSizeList.add(item.getSize());
						}
					}
				}
			}
		}

		for (String key : parameter.keySet()) {
			LinkedList<String> list = (LinkedList<String>) parameter.get(key);
			if (list.size() == 1) {
				parameter.put(key, list.get(0));
			} else if (list.size() == 0) {
				parameter.remove(key);
			}
		}
		return parameter;
	}

	/**
	 * 파일을 원본 파일명 그대로 업로드 하고 기타 폼의 파라미터를 HashMap형태로 가져온다.
	 * 
	 * @return 파일형태가 아닌 일반폼의 파라미터.
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> uploadFileOriginalName() throws Exception {
		if (request == null)
			throw new IllegalArgumentException("request cannot be null");
		if (repositoryPath == null)
			throw new IllegalArgumentException("saveDirectory cannot be null");

		String fileName = "";
		String saveFileName = "";
		File file = new File(repositoryPath);
		if (file.isDirectory() == false) {
			file.mkdirs();
		}
		if (ServletFileUpload.isMultipartContent(request)) {
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(new File(repositoryPath));
			factory.setSizeThreshold(1024 * 1024 * 5);

			ServletFileUpload fileUpload = new ServletFileUpload(factory);
			fileUpload.setHeaderEncoding("UTF-8");
			fileUpload.setSizeMax(102400000);
			if (request.getContentLength() < fileUpload.getSizeMax()) {
				List<FileItem> list = (List<FileItem>) fileUpload
						.parseRequest(request);
				Iterator<FileItem> iter = list.iterator();
				while (iter.hasNext()) {
					FileItem item = iter.next();
					fileName = item.getFieldName();
					if (item.isFormField()) {
						String parameterValue = item.getString("UTF-8");
						Object obj = null;
						if (parameter.containsKey(fileName)) {
							obj = parameter.get(fileName);

						} else {
							obj = new LinkedList<String>();
						}
						LinkedList<String> tmpList = (LinkedList<String>) obj;
						tmpList.add(parameterValue);
						parameter.put(fileName, tmpList);
					} else {
						if (item.getSize() > 0) {
							int idx = item.getName().lastIndexOf("\\");
							if (idx == -1) {
								idx = item.getName().lastIndexOf("/");
							}
							fileName = item.getName().substring(idx + 1);
							saveFileName = fileName;
							File uploadedFile = new File(repositoryPath,
									saveFileName);
							item.write(uploadedFile);
							fileMapList
									.add(new FileMap(fileName, saveFileName));
							saveFileNameList.add(saveFileName);
							originalFileNameList.add(fileName);
							fileSizeList.add(item.getSize());
						}
					}
				}
			}
		}

		for (String key : parameter.keySet()) {
			LinkedList<String> list = (LinkedList<String>) parameter.get(key);
			if (list.size() == 1) {
				parameter.put(key, list.get(0));
			} else if (list.size() == 0) {
				parameter.remove(key);
			}
		}
		return parameter;
	}

	/**
	 * int값의 폼 파라미터를 얻는다.
	 * 
	 * @param parameterName
	 *            파라미터 명
	 * @param defaultValue
	 *            null일경우 디폴트 값.
	 * @return
	 */
	public int getParameterInteger(String parameterName, int defaultValue) {

		if (parameter.get(parameterName) == null) {
			return defaultValue;
		}
		if (parameter.containsKey(parameterName)) {
			return Integer
					.parseInt(String.valueOf(parameter.get(parameterName)));
		}
		return defaultValue;
	}

	/**
	 * 문자열의 폼 파라미터를 얻는다.
	 * 
	 * @param parameterName
	 *            파라미터 명
	 * @param defaultValue
	 *            null일경우 디폴트 값.
	 * @return
	 */
	public String getParameter(String parameterName, String defaultValue) {
		if (parameter.get(parameterName) == null) {
			return defaultValue;
		}
		if (parameter.containsKey(parameterName)) {
			return String.valueOf(parameter.get(parameterName));
		}
		return defaultValue;
	}

	/**
	 * 서버에 저장된 파일 사이즈 크기.
	 * 
	 * @return
	 */
	public List<Long> getFileSizeList() {
		return fileSizeList;
	}

	/**
	 * 서버에 저장된 변경된 파일명 목록
	 * 
	 * @return
	 */
	public List<String> getSaveFileNameList() {
		return saveFileNameList;
	}

	/**
	 * 서버에 저장된 원본 파일명 목록
	 * 
	 * @return
	 */
	public List<String> getOriginalFileNameList() {
		return originalFileNameList;
	}
}
