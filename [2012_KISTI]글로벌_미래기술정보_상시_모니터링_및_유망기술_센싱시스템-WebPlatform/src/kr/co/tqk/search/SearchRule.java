package kr.co.tqk.search;

public class SearchRule {
	public static String searchRule(String search, String asjc, String source, String country, String source_type, String year) throws Exception{
		
		String addSearch="";
		
		addSearch=search(search) + "*" + searchYear(year) + "*" +searchAddition(asjc, source, country, source_type);
		
		if(addSearch.indexOf("**") != -1){
			addSearch=addSearch.replace("**", "*");
		}
		
		if(!"*".equals(addSearch)){
			if("*".equals(addSearch.substring(addSearch.length()-1, addSearch.length()))){
				addSearch=addSearch.substring(0,addSearch.length()-1);
			}
			if("*".equals(addSearch.substring(0,1))){
				addSearch=addSearch.substring(1,addSearch.length());
			}
		}else{
			addSearch="";
		}
		
		return addSearch;
	}
	
	
	
	public static String searchYear(String year) throws Exception{
		String[] search_year = {};
		
		String year_tmp = "";
		
		try{
			
			if(!"".equals(year.trim())){
				search_year = year.split(";");
				year_tmp = "[PUB("+search_year[0]+"~"+search_year[1]+")]";
			}else{
				year_tmp = "";
			}
			
		}catch(Exception e){
			System.out.println(e);
		}
		
		return year_tmp;
	}
	
	public static String search(String search) throws Exception{
		
		String[] search_tmp = search.split("@");
		String[] search_tmp2 = {};
		String search_tmp3="";
		
		
		
		try{
			for(int i=0;i<search_tmp.length;i++){
				int first_c=1;
				int cnt=0;
				
				search_tmp2=search_tmp[i].split(";");
				
				for(int z=2;z<search_tmp2.length;z++){
					if(!"empty".equals(search_tmp2[z])){
						cnt++;
					}
				}
				
				for(int j=2;j<search_tmp2.length;j++){
					
					if(!"empty".equals(search_tmp2[j])){
						
						
						
						if("first".equals(search_tmp2[0].trim())){
							if(first_c==1){
								if(first_c==cnt){
									search_tmp3 += "["+search_tmp2[j]+"("+search_tmp2[1]+")]";	
								}else{
									search_tmp3 += "["+search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
								}
							}else if(first_c==cnt){
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")]";
							}else{
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
							}
							
							first_c++;
						}
						
						if("and".equals(search_tmp2[0].trim())){
							if(first_c==1){
								if(first_c==cnt){
									search_tmp3 += "*["+search_tmp2[j]+"("+search_tmp2[1]+")]";	
								}else{
									search_tmp3 += "*["+search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
								}
								
							}else if(first_c==cnt){
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")]";
							}else{
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
							}
							
							first_c++;
						}
						
						if("or".equals(search_tmp2[0].trim())){
							if(first_c==1){
								if(first_c==cnt){
									search_tmp3 += "+["+search_tmp2[j]+"("+search_tmp2[1]+")]";
								}else{
									search_tmp3 += "+["+search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
								}
								
								
							}else if(first_c==cnt){
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")]";
							}else{
								search_tmp3 += search_tmp2[j]+"("+search_tmp2[1]+")"+"+";
							}
							
							first_c++;
						}
					}
				}
			}
			
		}catch(Exception e){
			System.out.println(e);
		}
		
		
		return search_tmp3;
		
	}
	
	public static String searchAddition(String asjc, String source, String country, String source_type) throws Exception {
		
		String[] asjc_temp=asjc.split(";");
		String[] source_temp=source.split(";");
		String[] country_temp=country.split(";");
		String[] source_type_temp=source_type.split(";");
		
		String asjc_rule="";
		String source_rule="";
		String country_rule="";
		String source_type_rule="";
		
		String rule="";

		try{
			if(asjc_temp.length==1){
				if(!"".equals(asjc_temp[0])){
					asjc_rule="[ASJC(";
					asjc_rule += asjc_temp[0]+")]";
				}
			}else{
				asjc_rule="[ASJC(";
				for(int i=0;i<asjc_temp.length;i++){
					if(i==asjc_temp.length-1){
						asjc_rule += asjc_temp[i] +")]";
					}else{
						asjc_rule += asjc_temp[i] +"+";	
					}
				}
			}
			
			if(source_temp.length==1){
				if(!"".equals(source_temp[0])){
					source_rule="[SOUR(";
					source_rule += source_temp[0]+")]";
				}
			}else{
				source_rule="[SOUR(";
				for(int i=0;i<source_temp.length;i++){
					if(i==source_temp.length-1){
						source_rule += source_temp[i] +")]";
					}else{
						source_rule += source_temp[i] +"+";	
					}
				}
			}
			
			if(country_temp.length==1){
				if(!"".equals(country_temp[0])){
					country_rule="[CON(";
					country_rule += country_temp[0]+")]";
				}
			}else{
				country_rule="[CON(";
				for(int i=0;i<country_temp.length;i++){
					if(i==country_temp.length-1){
						country_rule += country_temp[i] +")]";
					}else{
						country_rule += country_temp[i] +"+";	
					}
				}
			}
			
			if(source_type_temp.length==1){
				if(!"".equals(source_type_temp[0])){
					source_type_rule="[SOURTYPE(";
					source_type_rule += source_type_temp[0]+")]";
				}
			}else{
				source_type_rule="[SOURTYPE(";
				for(int i=0;i<source_type_temp.length;i++){
					if(i==source_type_temp.length-1){
						source_type_rule += source_type_temp[i] +")]";
					}else{
						source_type_rule += source_type_temp[i] +"+";	
					}
				}
			}
			
			
			rule=asjc_rule+"*"+source_rule+"*"+country_rule+"*"+source_type_rule;
			
			
			
			if(rule.indexOf("***") != -1){
				rule=rule.replace("***", "*");
			}else if(rule.indexOf("**") != -1){
				rule=rule.replace("**", "*");
			}
			
			if(!"*".equals(rule)){
				if("*".equals(rule.substring(rule.length()-1, rule.length()))){
					rule=rule.substring(0,rule.length()-1);
				}
				if("*".equals(rule.substring(0,1))){
					rule=rule.substring(1,rule.length());
				}
			}else{
				rule="";
			}
			
//			if(!"".equals(rule.trim())){
//				rule="["+rule+"]";
//			}
			
		}catch (Exception e) {
			System.out.println(e);
		}
		
		return rule;
	}
}
