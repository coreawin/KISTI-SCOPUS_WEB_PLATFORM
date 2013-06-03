package kr.co.topquadrant.util;

import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.List;

import kr.co.topquadrant.db.bean.HCP;

import com.google.gson.Gson;

public class HCPTree {

	String id;
	List<String> cell;

	public HCPTree(String id, List<String> data) {
		this.id = id;
		this.cell = data;
	}

	public String getId() {
		return id;
	}

	public List<String> getCellData() {
		return cell;
	}

	public static void main(String[] args) throws Exception {

		FileInputStream fis = new FileInputStream("e:\\hcplist.data");
		ObjectInputStream dis = new ObjectInputStream(fis);
		List<HCP> set = (List<HCP>) dis.readObject();
		// for (HCP h : set) {
		// System.out.println(h.getAsjc_code());
		// }
		new MakeHCPTree(set);
		// String asjc = "1102";
		// String firstString = asjc.substring(0, 2);
		// String lastString = asjc.substring(2, asjc.length());
		//
		// System.out.println(firstString + "___" + lastString);
		Gson g = new Gson();
//		System.out.println(g.toJson(t));
	}

}
