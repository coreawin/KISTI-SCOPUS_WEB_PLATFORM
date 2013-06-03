package test;

import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.util.HCPTree;
import kr.co.topquadrant.util.MakeHCPTree;

import com.google.gson.Gson;

public class TestHCPTree {
	
	
	public static void main(String[] args) throws Exception {
		FileInputStream fis = new FileInputStream("e:\\hcplist.data");
		ObjectInputStream dis = new ObjectInputStream(fis);
		List<HCP> set = (List<HCP>) dis.readObject();
//		for(HCP h : set){
//			System.out.println(h.getAsjc_code() +"|"+h.getPublication_year()+"|"+h.getTotal()+"|"+h.getDocument_count()+"|"+h.getThreshold());
//		}
		MakeHCPTree t = new MakeHCPTree(set);
		Set<String> largeAsjc = new HashSet<String>();
//		largeAsjc.add("1200");
//		largeAsjc.add("2100");
		
		List<HCPTree> list = t.makeTreeData(largeAsjc);
		System.out.println(new Gson().toJson(list));
	}

}
