package test;

import kr.co.tqk.web.MakeSearchRule;

public class Test {

	public static void main(String[] args) {
		String filter = " se={title,abs,keyword:title}&ft=ASJC:match:1104;1103;1101;1100;1230";

		MakeSearchRule.extractSearchRuleFilter(filter);
	}
}
