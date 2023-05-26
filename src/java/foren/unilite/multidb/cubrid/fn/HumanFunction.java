package foren.unilite.multidb.cubrid.fn;

import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.*;

public class HumanFunction {

	/* ***********************************  
	함수명   : fnHumanDateDiff  
	입력인자 : 
	반환값   :        
	 *********************************** */ 

	public static String fnHumanDateDiff(String pStrtDt, String pEndDt, String dataFlag) {
		String sRtn = "";

		int diffYY = 0;
		int diffMM = 0;
		int diffDD = 0;
		int diffYear = 0;
		int diffMonth = 0;
		int diffDay = 0;

		Date startDt = null;
		Date endDt = null;
		Date calcuEndDt = null;

		int diffDays = 0;

		try{
			UtilFunction ut = new UtilFunction();

			if(pStrtDt.equals("00000000") || pEndDt.equals("00000000")){
				return "";
			}

			SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );		   

			startDt = format.parse( pStrtDt );
			endDt = format.parse( pEndDt );

			if(startDt.compareTo(endDt) > 0){
				return "";
			}

			// ================
			//  근속년(DUTY_YYYY)
			// ================
			diffYY = ut.fnSQLDateDiff("YYYY", startDt, endDt) + 1;

			calcuEndDt = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.YEAR, startDt, diffYY), -1);

			diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, endDt);

			while(diffDays < 0){
				diffYY--;

				calcuEndDt = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.YEAR, startDt, diffYY), -1);
				diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, endDt);
			}

			//			System.out.println(diffYY);
			//			System.out.println(calcuEndDt);
			//			System.out.println(diffDays);

			// ================
			//  근속월(LONG_MONTH*)
			// ================

			calcuEndDt = null;
			diffDays = 0;

			diffMM = ut.fnSQLDateDiff("MONTH", startDt, endDt) + 1;
			calcuEndDt = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, startDt, diffMM), -1);
			diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, endDt);

			while(diffDays < 0){
				diffMM--;

				calcuEndDt = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, startDt, diffMM), -1);
				diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, endDt);
			}

			// ================
			//  근속일(LONG_DAY)
			// ================
			diffDD = diffDays;

			// ================
			//  총근속일수(LONG_TOT_DAY)
			// ================
			diffDay = ut.fnSQLDateDiff("DATE", startDt, endDt) + 1;

			// ==========================
			//  총근속개월수(LONG_TOT_MONTH)
			// ==========================
			if(diffDD > 0){
				diffMonth = diffMM + 1;
			}else{
				diffMonth = diffMM;
			}

			// ==========================
			//  총속년수(LONG_YEARS)
			// ==========================
			calcuEndDt = null;

			calcuEndDt = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.YEAR, startDt, diffYY), -1);

			if(calcuEndDt.compareTo(endDt) < 0){
				diffYear = diffYY + 1;
			}else{
				diffYear = diffYY;
			}

			// ==============================================
			//  근속월(LONG_MONTH) : 근속월을 근속년으로 변환 후 잔여개월수만 리턴.
			// ==============================================
			diffMM = diffMM % 12;

			switch(dataFlag){
			case "DUTY_YYYY" : 
				sRtn = String.valueOf(diffYY);
				break;
			case "LONG_MONTH" : 
				sRtn = String.valueOf(diffMM);
				break;
			case "LONG_DAY" : 
				sRtn = String.valueOf(diffDD);
				break;
			case "LONG_YEARS" : 
				sRtn = String.valueOf(diffYear);
				break;
			case "LONG_TOT_MONTH" : 
				sRtn = String.valueOf(diffMonth);
				break;
			case "LONG_TOT_DAY" : 
				sRtn = String.valueOf(diffDay);				
				break;
			case "LONG_TOT_ALL" : 
				sRtn = ("0" + String.valueOf(diffYY)).substring(("0" + String.valueOf(diffYY)).length()-2, ("0" + String.valueOf(diffYY)).length())
				+ "." + ("0" + String.valueOf(diffMM)).substring(("0" + String.valueOf(diffMM)).length()-2, ("0" + String.valueOf(diffMM)).length())
				+ "." + ("0" + String.valueOf(diffDD)).substring(("0" + String.valueOf(diffDD)).length()-2, ("0" + String.valueOf(diffDD)).length());;
				break;
			default : sRtn = "DUTY_YYYY : " + diffYY + ", LONG_MONTH : " + diffMM + ", LONG_DAY : " + diffDD + ", LONG_YEARS : " + diffYear + ", LONG_TOT_MONTH : " + diffMonth + ", LONG_TOT_DAY : " + diffDay;			
			break;
			}


			//sRtn = "미정의";

			return sRtn;
		} catch (Exception e) {
			return "";   
		}
	}


	public static Integer fnGetCareer(String pvFrDate, String pvToDate, String pvMonth, String pvGetData) {
		Integer sRtn = 0;
		try{


			String strFrDate = "";
			Date dateFrDate = null;
			Date dateToDate = null;
			int Month = 0;
			int basCareer = 0;
			int excCareer = 0;
			String excDate = "";

			UtilFunction ut = new UtilFunction();

			SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );		   
			Date tmpFrDate = null;

			tmpFrDate = format.parse( pvFrDate );

			dateFrDate = ut.fnGetDateAdd(Calendar.DATE, tmpFrDate, -1);
			strFrDate  = format.format(dateFrDate);

			dateToDate = format.parse( pvToDate );

			Month = Integer.parseInt(pvMonth);

			// ======================================
			//  승진일/입사일로부터 기본경력기간 계산하여 체크일자 설정
			// ======================================
			Date ChkDate = ut.fnGetDateAdd(Calendar.MONTH, dateFrDate, Month);

			// ======================================
			//  승진일/입사일로부터 기본경력기간을 채웠을 경우에만 기본경력 인정  
			// ======================================
			if(ChkDate.compareTo(dateToDate) <= 0){
				basCareer = Month;
				excDate = format.format(ut.fnGetDateAdd(Calendar.DATE, ChkDate, 1));

				//				   System.out.println(excDate);
			}else{
				basCareer = 0;
				excDate = "";
			}

			// ==============================================
			//  인정경력기간 중 기본경력을 제외한 초과경력에 대해서는 30일로 나누어 경력월수 계산
			// ==============================================
			if(!excDate.equals("")){
				excCareer = ut.fnSQLDateDiff("DATE", excDate, pvToDate) / 30;
				//				   System.out.println(excDate);
				//				   System.out.println(pvToDate);
				//				   System.out.println(excCareer);
			}else{
				excCareer = 0;
			}

			if(pvGetData.equals("BAS")){
				sRtn = basCareer;
			}else{
				sRtn = excCareer;
			}

			return sRtn;
		} catch (Exception e) {
			return 0;   
		}
	}


}
