package addition.compare;

import java.io.File;
import java.io.FileWriter;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;

import kr.co.tqk.analysis.cluster.Similarity;

/**
 * @author 정승한
 * 
 */
public class ReadDownloadData {

	String readFilePath = null;
	String repositoryPath = null;

	LinkedHashSet<String> totalKey = new LinkedHashSet<String>();

	LinkedHashMap<String, LinkedHashMap<String, String>> totalData = new LinkedHashMap<String, LinkedHashMap<String, String>>();

	public ReadDownloadData(String readFilePath, String repositoryPath) {
		this.readFilePath = readFilePath;
		this.repositoryPath = repositoryPath;
	}

	public void processSimilarity(double similityCutOff, int cutPoint) {
		File readFileDirectory = new File(readFilePath);
		if (readFileDirectory.isDirectory()) {

			File dir = new File(repositoryPath);
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}

			for (File readFile : readFileDirectory.listFiles()) {
				if (!readFile.isFile())
					continue;
				String fileName = readFile.getName();
				String repositoryFileName = fileName.substring(0,
						fileName.lastIndexOf("."));
				System.out.println("===========================");
				System.out.println("read file " + fileName);
				System.out.println("===========================");
				LinkedHashMap<String, String> result = new Similarity()
						.processSilarity(true, readFile.getAbsolutePath(),
								"\t", repositoryPath, repositoryFileName,
								similityCutOff, cutPoint);
				totalKey.addAll(result.keySet());
				totalData.put(fileName, result);
			}
		}
	}

	public void export(String fileWriteName) throws Exception {
		if (totalKey.size() == 0 || totalData.size() == 0)
			throw new Exception("");

		FileWriter fw = new FileWriter(fileWriteName);
		fw.write("KEY \t");
		for (String fileName : totalData.keySet()) {
			fw.write(fileName);
			fw.write("\t");
		}
		fw.write("\r\n");

		for (String key : totalKey) {
			fw.write(key);
			fw.write("\t");
			for (String fileName : totalData.keySet()) {
				LinkedHashMap<String, String> result = totalData.get(fileName);
				if (result.containsKey(key)) {
					fw.write(result.get(key));
					fw.write("\t");
				} else {
					fw.write("\t");
				}
			}
			fw.write("\r\n");
		}
	}

	public static void main(String[] args) throws Exception {
		String readFilePath = "./data/20110906/";
		String repositoryPath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/addition/similarity/";
		double similityCutOff = 0.01;
		int cutPoint = 5;
		ReadDownloadData rdd = new ReadDownloadData(readFilePath,
				repositoryPath);
		rdd.processSimilarity(similityCutOff, cutPoint);
		rdd.export("e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/addition/result.txt");

	}

}
