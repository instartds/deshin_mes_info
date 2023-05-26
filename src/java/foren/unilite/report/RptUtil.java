package foren.unilite.report;

import java.text.DecimalFormat;
import java.math.*;
import java.lang.*;

import net.sf.jasperreports.engine.JRDefaultScriptlet;

public class RptUtil extends JRDefaultScriptlet {
	public String convertHangul(String money){
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
		String[] han2 = {"","십","백","천"};
		String[] han3 = {"","만","억","조","경"};

		StringBuffer result = new StringBuffer();
		int len = money.length();
		for(int i=len-1; i>=0; i--){
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
				result.append(han2[i%4]);
			if(i%4 == 0)
				result.append(han3[i/4]);
		}
		
		return result.toString();
	}
	
	public String numberToWord2(BigDecimal num){
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
		String[] han2 = {"","십","백","천"};
		String[] han3 = {"","만","억","조","경"};

		String money = String.valueOf(num);
		StringBuffer result = new StringBuffer();
		
		int len = money.length();
		for(int i=len-1; i>=0; i--){
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
				result.append(han2[i%4]);
			if(i%4 == 0)
				result.append(han3[i/4]);
		}
		
		return result.toString();
	}
	
	public String numberToWord(BigInteger num){
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
		String[] han2 = {"","십","백","천"};
		String[] han3 = {"","만","억","조","경"};
		
		String money = String.valueOf(num);
		StringBuffer result = new StringBuffer();
		
		int len = money.length();
		for(int i=len-1; i>=0; i--){
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
				result.append(han2[i%4]);
			if(i%4 == 0)
				result.append(han3[i/4]);
		}
		
		return result.toString();
	}
	
	/*public String ChangeNumberToWord(long num){
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
		String[] han2 = {"","십","백","천"};
		String[] han3 = {"","만","억","조","경"};
		
		
		String money = String.valueOf(Math.abs(num));
	    StringBuffer result = new StringBuffer();
		
		int len = money.length();
		
		String sign = "";
		if (num < 0) { 
			sign = "- ";
		}

		for(int i=len-1; i>=0; i--){
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
				result.append(han2[i%4]);
			if(i%4 == 0)
				result.append(han3[i/4]);
		}

		return sign + result.toString();
	}*/
	
	
	
	public String ChangeNumberToWord(long num){
	      String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
	      String[] han2 = {"","십","백","천"};
	      String[] han3 = {"","만","억","조","경"};
	      String sign = "";
	      
	      String money = String.valueOf(Math.abs(num));
	     StringBuffer result = new StringBuffer();
	      
	     if(money.equals("0")) {
	         result.append("영");
	     } else {
	        int len = money.length();
	        
	        if (num < 0) { 
	          sign = "- ";
	        }

	        for(int i=len-1; i>=0; i--){
	          result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
	          if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
	            result.append(han2[i%4]);
	          if(i%4 == 0)
	            result.append(han3[i/4]);
	        }
	     }
	      return sign + result.toString();
	   }
	
	public String numberToWordStr(String money){
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"};
		String[] han2 = {"","십","백","천"};
		String[] han3 = {"","만","억","조","경"};
		
		StringBuffer result = new StringBuffer();
		
		int len = money.length();
		for(int i=len-1; i>=0; i--){
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]);
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0)
				result.append(han2[i%4]);
			if(i%4 == 0)
				result.append(han3[i/4]);
		}
		
		return result.toString();
	}
	
	public String numberTest(double num) {
		return String.valueOf(num);
	}

}