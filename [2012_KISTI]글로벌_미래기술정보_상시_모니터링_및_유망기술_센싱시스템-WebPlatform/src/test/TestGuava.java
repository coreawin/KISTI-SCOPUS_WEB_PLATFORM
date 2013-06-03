package test;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;

public class TestGuava {

	public void testTable(){
		Table<Integer, Integer, String> table = HashBasedTable.create();
		table.put(1995, 1100, "6");
		table.put(1995, 1104, "3");
		table.put(1995, 1307, "1");
		System.out.println(table);
	}
	
	
	public static void main(String[] args){
		TestGuava tg = new TestGuava();
		tg.testTable();
	}
}
