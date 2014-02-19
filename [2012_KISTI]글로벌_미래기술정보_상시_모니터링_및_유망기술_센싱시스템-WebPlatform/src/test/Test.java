package test;

import kr.co.tqk.web.MakeSearchRule;

public class Test {

	public static void main(String[] args) {
//		String filter = " se={title,abs,keyword:title}&ft=ASJC:match:1104;1103;1101;1100;1230";
//		String a = "Reddy Ashok Kumar()_;Brahmaiah Upputuri(M.N.R Medical College)_IND;Narayen Nitesh(Maxivision Eye Centre)_IND;Reddy Ravi Kumar,Reddy Rupak Kumar,Chitta Meghraj(Medivision Eye and Health Care Centre)_IND;Prasad Srinivas(Sarojini Devi Eye Hospital)_IND;Swarup Rishi(Swarup Eye Centre)_IND;Mohiuddin Syed Maaz(Eye Care Hyderabad)_IND;Reddy Madhukar(Drishti Eye Centre)_IND;Aasuri Murali K.(Sulochana Eye Centre)_IND;Murthy B. S R(Vasan Eye Care)_IND;Bhide Milind(Hyderabad Eye Centre)_IND;Ahmed Sajid(Arvind Eye Hospital)_IND;Mohiuddin Syed Maaz(Neo Retina)_IND";
//		String specialCharacter = "[^^\uAC00-\uD7A300-9a-zA-Z\\s,;_\\(\\)]";
//		specialCharacter = "[^\uAC00-\uD7A3xfe0-9a-zA-Z,;_().\\s]";
//		System.out.println(a.replaceAll(specialCharacter, "@"));
//		MakeSearchRule.extractSearchRuleFilter(filter);
		
		String au = "Zhang X.-Y.";
		System.out.println(au.replaceAll("\\.\\s{1,}", "."));
	}
	
}
