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

@SuppressWarnings("unused")
public class  UtilFunction {

	// "Result set" to "map list"
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getRsToList(ResultSet rs){

		List list = new ArrayList();

		try {

			if( rs.next() ){
				do{
					Map map = new HashMap();

					ResultSetMetaData rsMD= rs.getMetaData();
					int rsMDCnt = rsMD.getColumnCount();
					for( int i = 1; i <= rsMDCnt; i++ ) {                   
						String column = rsMD.getColumnName(i).toLowerCase();
						String value  = rs.getString(column);

						map.put(column, value);
					}

					list.add(map);
				}while( rs.next() );

			}else{
				list = java.util.Collections.EMPTY_LIST;
			}


		} catch (Exception e) {                
			list = null;
		}

		return list;
	}


	public static String fnGetTxt(String sCode) {

		Connection conn = null;
		ResultSet rs = null;



		String sRtn = "";
		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");


			// DB 연결 

			StringBuffer sql = new StringBuffer();

			sql.append( "     SELECT MSG_DESC              ");
			sql.append( "     FROM   BSA010T               ");
			sql.append( "     WHERE  MSG_NO = " + "'" + sCode + "'");
			sql.append( "     AND    MSG_TYPE = '1'    ");

			PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();

			while(rs.next()){
				sRtn = rs.getString("MSG_DESC").toString();
			}

			
			return sRtn;
		} catch (Exception e) {
			return "";   
		}
	}
	
	
	public static String fnGetUserDateComp(String sCompcode, String sDate) {

		Connection conn = null;
		ResultSet rs = null;



		String sRtn = "";
		try{

			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");



			String DateFormat = "";
			String DatePart01  = "";
			String ComBinDt01 = "";
			String tempDate = "";

			if(sDate.equals(null) || sDate == "") {    		
				return sDate;	
			}

			// DB 연결

			StringBuffer sql = new StringBuffer();

			sql.append( "     SELECT CODE_NAME             ");
			sql.append( "     FROM   BSA100T               ");
			sql.append( "     WHERE  COMP_CODE = " + "'" + sCompcode + "'");
			sql.append( "     AND    MAIN_CODE = 'B044'    ");
			sql.append( "     AND    REF_CODE1 = 'Y'       ");

			PreparedStatement  pstmt = conn.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			while(rs.next()){
				DateFormat = rs.getString(1);
			}

			//값이 없으면 default값 셋팅
			if(DateFormat.equals(null) || DateFormat == ""){
				DateFormat = "YYYY.MM.DD";
			}

			if(DateFormat.equals(null) || DateFormat == "") {

				return sDate;
			}


			if(DateFormat.length() < 6) {
				return sDate;
			}

			tempDate = sDate;    	
			ComBinDt01 = sDate;

			sDate = tempDate.replace(".", "").replace("-", "").replace("/", "");


			if(DateFormat.length() == 10) {
				if(sDate.length() == 8) {

					DatePart01 = DateFormat.substring(0, 1);

					switch(DatePart01){
					case "Y" : ComBinDt01 = sDate.substring(0, 4) + DateFormat.substring(4, 5)+ sDate.substring(4, 6) + DateFormat.substring(7, 8) + sDate.substring(6, 8);
					break;
					case "M" : ComBinDt01 = sDate.substring(4, 6) + DateFormat.substring(2, 3) + sDate.substring(6, 8) + DateFormat.substring(5, 6) + sDate.substring(0, 4);
					break;
					case "D" : ComBinDt01 = sDate.substring(6, 8) + DateFormat.substring(2, 3) + sDate.substring(4, 6) + DateFormat.substring(5, 6) + sDate.substring(0, 4);
					break;					
					default :
						break;
					}

				} 


				if(sDate.length() == 6){

					DatePart01 = DateFormat.substring(0, 1);

					switch(DatePart01){
					case "Y" : ComBinDt01 = sDate.substring(0, 4) + DateFormat.substring(4, 5) + sDate.substring(4, 6);
					break;
					case "M" : ComBinDt01 = sDate.substring(4, 6) + DateFormat.substring(2, 3) + sDate.substring(0, 4);
					break;
					case "D" : ComBinDt01 = sDate.substring(4, 6) + DateFormat.substring(5, 6) + sDate.substring(0, 4);
					break;		

					}
				}
			}

			sRtn = ComBinDt01;
			return sRtn;
		} catch (Exception e) {
			return "";   
		}
	}

	/**
	 * @param pStrtDt
	 * @param pEndDt
	 * @param rValuType
	 * @return
	 */
	public static String fnGetYMDFromDate(String pStrtDt, String pEndDt, String rValuType) throws Exception {

		String sRtn = "";

		int fullYears;      // ① 만으로 계산된 년수
		int fullMonths;     // ② 만으로 계산된 월수
		int rmMonth;        // ③ @fullYears  계산 후 잔여월수
		int rmDay;           // ④ @fullMonths 계산 후 잔여일수
		int upYears;         // ⑤ 총년수(@rmMonth을 1년으로 계산하여 포함)
		int upMonths;        // ⑥ 총월수(@rmDay을   1개월로 계산하여 포함)
		int totDays;         // ⑦ 실제총일수

		try {
			//시작일짜가 공백이면 오늘날짜입력
			if (pStrtDt == ""){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
				Calendar c1 = Calendar.getInstance();
				String strToday = sdf.format(c1.getTime());

				pStrtDt = String.valueOf(strToday);

				//System.out.println(pStrtDt);

				return "";
			}



			if (pEndDt == ""){
				return "";
			}

			Date calcuEndDt = null;
			int diffDays;

			SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );
			Date startDt = null;
			Date endDt = null;
			try {
				startDt = format.parse( pStrtDt );
				endDt = format.parse( pEndDt );
			} catch (ParseException e) {
				e.printStackTrace();
			}

			int compare = startDt.compareTo( endDt );
			if ( compare > 0 )
			{
				return sRtn;
			}


			// ① @fullYears 계산
			//fullYears = fnGetDateDiff(Calendar.YEAR, startDt, endDt) + 1;
			fullYears = fnSQLDateDiff("YEAR", startDt, endDt) + 1;

			calcuEndDt = null;
			diffDays = 0;

			calcuEndDt = fnGetDateAdd( Calendar.DATE, fnGetDateAdd( Calendar.YEAR, startDt, fullYears), -1);
			//diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, endDt);
			diffDays = fnSQLDateDiff("DATE", calcuEndDt, endDt);

			while(diffDays < 0) {
				fullYears	= fullYears - 1;

				calcuEndDt = fnGetDateAdd( Calendar.DATE, fnGetDateAdd( Calendar.YEAR, startDt, fullYears), -1);
				//diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, endDt);
				diffDays = fnSQLDateDiff("DATE", calcuEndDt, endDt);

			}

			//System.out.println(diffDays);
			//fullMonths	= fnGetDateDiff(Calendar.MONTH, startDt, endDt) + 1; 
			fullMonths	= fnSQLDateDiff("MONTH", startDt, endDt) + 1;

			//System.out.print(fullMonths);

			calcuEndDt = null;
			diffDays	= 0;

			calcuEndDt = fnGetDateAdd( Calendar.DATE, fnGetDateAdd( Calendar.MONTH, startDt, fullMonths), -1);
			//diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, endDt);
			diffDays = fnSQLDateDiff("DATE", calcuEndDt, endDt);

			//	    	System.out.println(calcuEndDt);
			//	    	System.out.println(diffDays);

			while(diffDays < 0) {
				fullMonths	= fullMonths - 1;

				calcuEndDt = fnGetDateAdd( Calendar.DATE, fnGetDateAdd( Calendar.MONTH, startDt, fullMonths), -1);
				//diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, endDt);
				diffDays = fnSQLDateDiff("DATE", calcuEndDt, endDt);
			}

			//	    	System.out.println(calcuEndDt);
			//	    	System.out.println(diffDays);

			rmMonth    = fullMonths % 12;
			rmDay = diffDays;
			//	    	System.out.println(rmDay);

			calcuEndDt = null;

			calcuEndDt = fnGetDateAdd( Calendar.DATE, fnGetDateAdd( Calendar.YEAR, startDt, fullYears), -1);

			compare = calcuEndDt.compareTo( endDt );
			//	        System.out.println(format.format(calcuEndDt));
			//	        System.out.println(format.format(endDt));
			if ( compare < 0 )
			{
				upYears = fullYears + 1;
			} else {

				upYears = fullYears;
			}

			if (rmDay > 0) {
				upMonths = fullMonths + 1;
			} else {

				upMonths = fullMonths;
			}

			//totDays = fnGetDateDiff(Calendar.DATE, startDt, endDt) + 1;
			totDays = fnSQLDateDiff("DATE", startDt, endDt) + 1;

			//System.out.println(totDays);

			switch(rValuType){
			case "FULL_YEARS" : sRtn = String.valueOf(fullYears);
			break;
			case "FULL_MONTHS" : sRtn = String.valueOf(fullMonths);
			break;
			case "RM_MONTHS" : sRtn = String.valueOf(rmMonth);
			break;
			case "RM_DAY" : sRtn = String.valueOf(rmDay);
			break;
			case "FULL_YMD" : sRtn = String.valueOf(fullYears) + "." + String.valueOf(fullMonths) + "." + String.valueOf(rmDay);
			break;
			case "UP_YEARS" : sRtn = String.valueOf(upYears);
			break;
			case "UP_MONTHS" : sRtn = String.valueOf(upMonths);
			break;
			case "TOT_DAYS" : sRtn = String.valueOf(totDays);
			break;		
			default : sRtn = "FULL_YEARS : " + fullYears + ",FULL_MONTHS : " + fullMonths + ", FULL_YMD : " + rmDay + ", UP_YEARS : " + upYears + ", UP_MONTHS : " + upMonths + ", TOT_DAYS : " + totDays;			
			break;
			}

			//System.out.println(sRtn);
			return sRtn;
		} catch(Exception e) {
			return "";
		}
	}


	/* ***********************************  
		함수명   : fnGetYMDFromDate2  
		입력인자 : 
		반환값   :    
	 *********************************** */ 

	public static String fnGetYMDFromDate2(java.lang.Integer YYYY, java.lang.Integer MM, java.lang.Integer DD, String rValuType) {

		String sRtn = "";

		String RETURN_DD = "";
		String RETURN_MM = "";
		String RETURN_YYYY = "";

		int RM_DD;
		int RM_MM;

		if(DD >= 30){
			RETURN_DD = Integer.toString((int) Math.floor(DD % 30));
			RM_DD = (int)Math.floor(DD / 30);
		} else {
			RETURN_DD = Integer.toString(DD);
			RM_DD = 0;
		}

		if(Integer.parseInt(RETURN_DD) < 0){
			if(Integer.parseInt(RETURN_DD) < -30){

				RETURN_DD = Integer.toString(60 + DD);
				RM_DD     = RM_DD - 2;    			

			}else{

				RETURN_DD = Integer.toString(30 + DD);
				RM_DD     = RM_DD - 1;    			
			}
		}

		if(RETURN_DD.length() < 2) {    		    	
			RETURN_DD = "0" + RETURN_DD;
		}

		// ② 월 계산
		if(MM + RM_DD >= 12 ) {
			RETURN_MM = Integer.toString((int) Math.floor((MM + RM_DD) % 12));
			RM_MM     = (int)Math.floor((MM + RM_DD) / 12);

		} else {
			RETURN_MM = Integer.toString(MM + RM_DD);
			RM_MM = 0;
		}


		if(Integer.parseInt(RETURN_MM) < 0){
			if(Integer.parseInt(RETURN_MM) < -12){

				RETURN_MM = Integer.toString(24 + (MM + RM_DD));
				RM_MM     = RM_MM - 2;    			

			}else{

				RETURN_MM = Integer.toString(12 + (MM + RM_DD));
				RM_MM     = RM_MM - 1;    			
			}
		}

		if(RETURN_MM.length() < 2) {    		    	
			RETURN_MM = "0" + RETURN_MM;
		}


		// ③ 년 계산
		RETURN_YYYY =Integer.toString(YYYY + RM_MM);

		if(RETURN_YYYY.length() < 2) {
			RETURN_YYYY = '0' + RETURN_YYYY;
		}



		switch(rValuType){
		case "YEARS" : sRtn = RETURN_YYYY;
		break;
		case "MONTH" : sRtn = RETURN_MM;
		break;
		case "DAY" : sRtn = RETURN_DD;
		break;		
		default : sRtn = RETURN_YYYY + '/' + RETURN_MM + '/' + RETURN_DD;
		break;
		}



		return sRtn;
	}

	/* ***********************************  
		함수명   : fnGetYMDFromDate2  
		입력인자 : 
		반환값   :    
	 *********************************** */ 

	public static String fnGetYMDFromDate3(java.lang.Integer PAYSTEP_CARR, java.lang.String rValueType) {

		String sRtn = "";

		//	    	String DIFF_PAYSTEP_CARR = "";
		int YYYY;
		int MM;
		int DD;

		int janDay;

		//	    	String RETURN_YYYY = "";
		//	    	String RETURN_MM = "";
		//	    	String RETURN_DD = "";

		PAYSTEP_CARR = PAYSTEP_CARR - 2;

		YYYY = (PAYSTEP_CARR) / 365;
		janDay = PAYSTEP_CARR - (YYYY * 365);

		MM = janDay / 31;
		DD = janDay - (MM * 31);


		//	    	System.out.println(YYYY);
		//	    	System.out.println(MM);
		//	    	System.out.println(DD);

		switch(rValueType){
		case "YEARS" : sRtn = String.valueOf(YYYY);
		break;
		case "MONTH" : sRtn = String.valueOf(MM);
		break;
		case "DAY" : sRtn = String.valueOf(DD);
		break;

		}


		return sRtn;
	}



	// 날짜사이 계산
	private static final double DAY_MILLIS = 1000 * 60 * 60 * 24.0015;
	private static final double WEEK_MILLIS = DAY_MILLIS * 7;
	private static final double MONTH_MILLIS = DAY_MILLIS * 30.43675;
	private static final double YEAR_MILLIS = WEEK_MILLIS * 52.2;

	// Java Version
	public static int fnGetDateDiff( int calUnit, java.util.Date d1, java.util.Date d2 ) {
		long diff = d2.getTime() - d1.getTime();

		switch (calUnit) {
		case Calendar.DATE :
			return (int) (diff / (1000 * 60 * 60 * 24));  
		case Calendar.WEEK_OF_YEAR :
			return (int) (diff / WEEK_MILLIS + .5);
		case Calendar.MONTH :
			return (int) (diff / MONTH_MILLIS + .5);
		case Calendar.YEAR :
			return (int) (diff / YEAR_MILLIS + .5);
		default:
			return 0;
		}
	}

	// SQL Version
	public static int fnSQLDateDiff( String calUnit, String d1, String d2 ) throws Exception{
		Connection conn = null;
		ResultSet rs = null;

		try {
			// DB 연결
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");

			StringBuffer sql = new StringBuffer();
			PreparedStatement  pstmt = null;
			int sVal = 0;

			sql.setLength(0);
			sql.append( " SELECT CAST(ROUND(DATEDIFF(" + "'" + d2 + "', '" + d1 + "') / 365.0, 0) AS INT) AS DIFF_YEAR   " + "\n");
			sql.append( "      , CAST(TRUNC(MONTHS_BETWEEN(" + "'" + d2 + "', '" + d1 + "'), 0) AS INT)   AS DIFF_MONTH  " + "\n");
			sql.append( "      , DATEDIFF(" + "'" + d2 + "', '" + d1 + "')                                AS DIFF_DAY    " + "\n");
			sql.append( " FROM DB_ROOT;" + "\n");

			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();

			while(rs.next()){
				switch (calUnit) {
				case "YYYY" : case "YEAR" : case "yyyy" : case "year" :
					sVal = rs.getInt("DIFF_YEAR");
					break;
				case "MM" : case "mm" : case "MONTH" : case "month" :
					sVal = rs.getInt("DIFF_MONTH");
					break;
				case "DD" : case "dd" : case "DAY" : case "day" : case "DATE" : case "date" :
					sVal = rs.getInt("DIFF_DAY");
					break;
				default:
					sVal = 0;
					break;
				}
			}

			pstmt.close();
			rs.close();
			return sVal;
		} catch(Exception e) {
			throw e;
		}
	}

	// SQL Version
	public static int fnSQLDateDiff( String calUnit, java.util.Date d1, java.util.Date d2 ) throws Exception{
		Connection conn = null;
		ResultSet rs = null;


		SimpleDateFormat fmrt = new SimpleDateFormat( "yyyyMMdd" );
		String sDateFr = "";
		String sDateTo = "";

		sDateFr = fmrt.format(d1);
		sDateTo = fmrt.format(d2);


		try {
			// DB 연결
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");

			StringBuffer sql = new StringBuffer();
			PreparedStatement  pstmt = null;
			int sVal = 0;

			sql.setLength(0);
			sql.append( " SELECT CAST(ROUND(DATEDIFF(" + "'" + sDateTo + "', '" + sDateFr + "') / 365.0, 0) AS INT) AS DIFF_YEAR   " + "\n");
			sql.append( "      , CAST(TRUNC(MONTHS_BETWEEN(" + "'" + sDateTo + "', '" + sDateFr + "'), 0) AS INT)   AS DIFF_MONTH  " + "\n");
			sql.append( "      , DATEDIFF(" + "'" + sDateTo + "', '" + sDateFr + "')                                AS DIFF_DAY    " + "\n");
			sql.append( " FROM DB_ROOT;" + "\n");

			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();

			while(rs.next()){
				switch (calUnit) {
				case "YYYY" : case "YEAR" : case "yyyy" : case "year" :
					sVal = rs.getInt("DIFF_YEAR");
					break;
				case "MM" : case "mm" : case "MONTH" : case "month" :
					sVal = rs.getInt("DIFF_MONTH");
					break;
				case "DD" : case "dd" : case "DAY" : case "day"  : case "DATE" : case "date" :
					sVal = rs.getInt("DIFF_DAY");
					break;
				default:
					sVal = 0;
					break;
				}
			}

			pstmt.close();
			rs.close();
			return sVal;
		} catch(Exception e) {
			throw e;
		}
	}


	public static int fnfnGetDateAddEach( int calUnit, java.util.Date d1, int num) {
		Calendar c = Calendar.getInstance();    	
		c.setTime(d1);

		switch (calUnit) {
		case Calendar.YEAR : //Add Year
		c.add(Calendar.YEAR, num);
		return c.get(Calendar.YEAR);
		case Calendar.MONTH :  //Add Month
			c.add(Calendar.MONTH, num);
			return c.get(Calendar.MONTH) + 1;  
		case Calendar.DATE :   //Add Day
			c.add(Calendar.DATE, num);
			return c.get(Calendar.DATE);
		case Calendar.HOUR_OF_DAY :   //Add Hour
			c.add(Calendar.HOUR_OF_DAY, num);
			return c.get(Calendar.HOUR_OF_DAY);
		case Calendar.MINUTE :   //Add Minute
			c.add(Calendar.MINUTE, num);
			return c.get(Calendar.MINUTE);
		case Calendar.SECOND :  //Add Second
			c.add(Calendar.SECOND, num);
			return c.get(Calendar.SECOND);
		default:
			return 0;
		}
	}

	public static Date fnGetDateAdd( int calUnit, java.util.Date d1, int num) {
		Calendar c = Calendar.getInstance();    	
		c.setTime(d1);

		Date rtnDate = null;

		switch (calUnit) {
		case Calendar.YEAR : //Add Year
		c.add(Calendar.YEAR, num);
		rtnDate = c.getTime();
		break;
		case Calendar.MONTH :  //Add Month
			c.add(Calendar.MONTH, num);
			rtnDate = c.getTime();
			break;
		case Calendar.DATE :   //Add Day
			c.add(Calendar.DATE, num);
			rtnDate = c.getTime();
			break;
		case Calendar.HOUR_OF_DAY :   //Add Hour
			c.add(Calendar.HOUR_OF_DAY, num);
			rtnDate = c.getTime();
			break;
		case Calendar.MINUTE :   //Add Minute
			c.add(Calendar.MINUTE, num);
			rtnDate = c.getTime();
			break;
		case Calendar.SECOND :  //Add Second
			c.add(Calendar.SECOND, num);
			rtnDate = c.getTime();
			break;
		}
		//System.out.println(rtnDate);
		return rtnDate;


		//	        System.out.println(format.format(c.getTime()));
		//	        return c.getTime();
	}


	public static ResultSet fnResultSet( String comp_code ) throws Exception{
		Connection conn = null;
		ResultSet vRtn = null;
		ResultSet rs = null;


		try {
			// DB 연결
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
			conn = DriverManager.getConnection("jdbc:default:connection");

			StringBuffer sql = new StringBuffer();
			PreparedStatement  pstmt = null;
			int sVal = 0;

			sql.setLength(0);
			sql.append( " SELECT MAIN_CODE   " + "\n");
			sql.append( "      , SUB_CODE  " + "\n");
			sql.append( " FROM BSA100T;" + "\n");

			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			vRtn = rs;

			pstmt.close();
			rs.close();
			return vRtn;
		} catch(Exception e) {
			throw e;
		}
	}


}

