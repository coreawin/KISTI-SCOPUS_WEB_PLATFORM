package kr.co.tqk.cleansing;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import kr.co.tqk.analysis.util.NumberFormatUtil;

public class DicLoader {

	Scanner dicScanner = null;
	private File dataFileDirectoryFile = null;
	LinkedHashMap<String, Integer> dictionary = null;
	public static final String TAB = "\t";
	public static final String ENTER = "\n";
	public static HashSet<String> ignoreWord = new HashSet<String>();
	public static HashSet<String> ignoreRexWord = new HashSet<String>();
	
	public static HashSet<String> extractRexWord = new HashSet<String>();
	
	static {
		ignoreWord.add("Building");
		ignoreWord.add("building");
		ignoreWord.add("Bldg");
		ignoreWord.add("bldg");
		ignoreWord.add("B/D");
		ignoreWord.add("Fl.");
		ignoreWord.add("fl.");
		ignoreWord.add("Floor");
		ignoreWord.add("floor");
		ignoreWord.add("Tower");
		ignoreWord.add("tower");
		ignoreWord.add("-Dong");
		ignoreWord.add("-dong");
		ignoreWord.add("Apt.");
		ignoreWord.add("Team");
		ignoreWord.add("team");
		ignoreWord.add("office");
		ignoreWord.add("Office");
		ignoreWord.add("Department");
		ignoreWord.add("Departments");
		ignoreWord.add("department");
		ignoreWord.add("departments");
		ignoreWord.add("dept.");
		ignoreWord.add("Dept.");
		ignoreWord.add("Dept");
		ignoreWord.add("dept");
		
		ignoreRexWord.add("[0-9]{3}-[0-9]{3}");
		ignoreRexWord.add("[0-9]{3}-[0-9]{2}");
		ignoreRexWord.add("[0-9]{3}-[0-9]{2}");
		ignoreRexWord.add("#[0-9]{2}");
		ignoreRexWord.add("[0-9]{1,}");
		
		extractRexWord.add("[A-Z]{1,}.*-[A-Z]{1,}");
		extractRexWord.add("[A-Z]{1,}");
	}

	public DicLoader(String dicFileName, String dataFileDirectoryName)
			throws Exception {
		dicScanner = new Scanner(new File(dicFileName), "utf-8");
		dataFileDirectoryFile = new File(dataFileDirectoryName);
		dictionary = new LinkedHashMap<String, Integer>();
		dicLoader();
	}
	
	public DicLoader(String dicFileName) throws Exception {
		dicScanner = new Scanner(new File(dicFileName), "utf-8");
		dictionary = new LinkedHashMap<String, Integer>();
		dicLoader();
	}

	
	public void cleansing() throws IOException {
		BufferedWriter rbw = null;
		BufferedWriter rkbw = null;
		HashSet<String> checkEID = new HashSet<String>();
		BufferedReader br = null;
		if (dataFileDirectoryFile.isDirectory()) {
			rkbw = new BufferedWriter(new FileWriter(new File("kor.result.txt")));
			for (File readDataFile : dataFileDirectoryFile.listFiles()) {
				try {
					System.out.println("read file " + readDataFile.getAbsolutePath());
					br = new BufferedReader(new FileReader(readDataFile));
					rbw = new BufferedWriter(new FileWriter(new File(
							readDataFile.getName() + ".all.result.txt")));
					if (br != null) {
						int cnt = 0;
						String line = null;
						while ((line = br.readLine())!=null) {
							if ("".equals(line)) {
								continue;
							}
							String[] data = line.split(TAB);

							String eid = "";
							String gseq = "";
							String afid = "";
							String dftid = "";
							String orgName = "";
							String countryCode = "";
							try{
							for (int idx = 0; idx < data.length; idx++) {
								if (idx == 0)
									eid = data[0].trim();
								if (idx == 1)
									gseq = data[1].trim();
								if (idx == 2)
									afid = data[2].trim();
								if (idx == 3)
									dftid = data[3].trim();
								if (idx == 4)
									orgName = data[4].trim();
								if (idx == 5)
									countryCode = data[5].trim();
							}
							}catch(Exception e){
								e.printStackTrace();
							}
							
//							if("60013682".equals(afid) || "60000656".equals(afid) || "60098516".equals(afid)){
//							}
							if (countryCode.equalsIgnoreCase("kor")) {
								checkEID.add(eid);
								rkbw.write(eid + TAB + gseq + TAB + afid + TAB
										+ dftid + TAB + orgName + TAB
										+ countryCode + TAB
										+ findDelegateWord(orgName) + ENTER);
							}else{
								rbw.write(eid + TAB + gseq + TAB + afid + TAB
										+ dftid + TAB + orgName + TAB + countryCode
										+ TAB + findDelegateWord(orgName) + ENTER);
							}
							if (cnt % 100000 == 0) {
								System.out.println("read data "
										+ NumberFormatUtil
												.getDecimalFormat(cnt));
							}
							cnt++;
						}
					}
					System.out.println("read compleate and file flushing " + checkEID.size());
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					if (rbw != null) {
						rbw.flush();
						rbw.close();
					}
					if (br != null)
						br.close();
				}
//				break;
			}
		}
		if (rkbw != null) {
			rkbw.flush();
			rkbw.close();
		}
		

	}

	private void dicLoader() {
		if (dicScanner != null) {
			int cnt = 0;
			while (dicScanner.hasNextLine()) {
				String line = dicScanner.nextLine().trim();
				if ("".equals(line)) {
					continue;
				}
				String dicWord = line.split("=")[1].toLowerCase();
				if(!dictionary.containsKey(dicWord)){
					dictionary.put(dicWord, cnt++);
				}
			}
			dicScanner.close();
		}
	}

	/**
	 * 두 단어를 비교하여 우선순위가 높은 단어를 리턴한다.
	 * 
	 * @param x
	 *            비교대상 단어
	 * @param y
	 *            비교대상 단어
	 * @return
	 */
	public String findDelegateWord(String words) {
		int min = 10000;
		String findWord = "";
		Pattern p = Pattern.compile("((?<=\\[).*?(?=\\]))");
		Matcher m = p.matcher(words);
		String word = "";
		String fWord = null;
		boolean needWord = false;
		while (m.find()) {
			fWord = word;
			word = m.group();
			
			boolean brek = false;
			for(String ignoreReg : ignoreRexWord){
				if(word.matches(ignoreReg)){
					brek = true;
					break;
				}
			}
			if(brek==false){
				for(String ignore : ignoreWord){
					if(word.indexOf(ignore)!=-1){
						brek = true;
						break;
					}
				}
			}
			if(brek) continue;
			
			
			int ranking = getRanking(word);
			if(ranking>33){
				for(String extractReg : extractRexWord){
					if(word.matches(extractReg)){
						//이 단어는 무조건 추출한다.
						findWord = word;
						needWord = true;
						break;
					}
				}
			}
			if (ranking <= min) {
				min = ranking;
				findWord = word;
			}
//			System.out.println(ranking +"\t" + word + "\t" + min);
			if(needWord) continue;
			
			if(ranking == min && min ==10000){
				findWord = word;
			}
			
			
//			if(ranking == 10000 && min == 10000){
//				findWord = word;
//				fWord = word;
//			}
		}
		return "".equals(findWord) ? word : findWord;
	}

	/**
	 * 해당 단어에서 사전에 포함된 가장 높은 랭킹을 얻는다.<br>
	 * 
	 * @param x
	 * @return
	 */
	public int getRanking(String x) {
		int ranking = 10000;
//		System.out.println("ranking " + ranking);
		x = x.replaceAll("\\/", " ").replaceAll("\\-", " ");
		for (String word : x.split(" ")) {
			if (dictionary.containsKey(word.toLowerCase())) {
				int min = dictionary.get(word.toLowerCase());
				if (min < ranking) {
					ranking = min;
				}
			}
		}
		return ranking;
	}

	public static void main(String[] args) throws Exception {
//		if (args.length != 2) {
//			args = new String[] {
//					"c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/scopus/한국기관_클린징/기관추출사전(with여운동).txt",
//					"c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/scopus/한국기관_클린징/data/" };
//		}
		DicLoader dl = new DicLoader(args[0], args[1]);
		dl.cleansing();

		
//				args = new String[]{
//				"c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/scopus/한국기관_클린징/기관추출사전(with여운동).txt"
//		};
//		DicLoader dl = new DicLoader(args[0]);
//		System.out.println(dl.findDelegateWord("[Advanced Functional Nanohybrid Material Laboratory][Department of Chemistry][Dongguk University-Seoul Campus]"));
//		System.out.println(dl.findDelegateWord("[MarkAny Research Institutes][10F, Ssanglim bldg]"));
//		System.out.println(dl.findDelegateWord("[TCS Team][Korea Telecom Freetel][15F, KTF Tower][111-222]"));
//		System.out.println(dl.findDelegateWord("[R and D Team, Solid Technologies][10th fl. IT Venture Tower East Wing]"));
//		System.out.println(dl.findDelegateWord("[TCS Team][Korea Telecom Freetel][15F, KTF Tower]"));
//		System.out.println(dl.findDelegateWord("[Korea Astronomy and Space Science Institute][Taeduk Radio Astronomy Observatory][61-1]"));
	}

}
