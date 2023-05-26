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
public class HumanProcedure {
//    public static void main(String[] args) {
//        SP_HUMAN_RetireCalc("MASTER", "R", "20170705", "20170705", "20000092", "unilite5"); 
//    }

    @SuppressWarnings("static-access")
    public static String SP_HUMAN_RetireCalc(
                  String COMP_CODE      //법인코드
                , String RETR_TYPE      //정산구분 ( M : 중도정산, R : 퇴직자 )                               
                , String RETR_DATE      //정산일
                , String SUPP_DATE      //지급일
                , String PERSON_NUMB    //사번
                , String USER_ID        //로그인id
            ) {
        
        UtilFunction ut = new UtilFunction();
        HumanFunction hf = new HumanFunction();
        
        Connection conn = null;
        ResultSet rs = null;

        String sRtn = "";

        
           /* ===============================================================================================================================
          기본값 설정
         ================================================================================================================================
           [퇴직금 계산식 추가] - 메뉴사용 안함 , DB상에만 입력 "퇴직금 계산식 생성.SQL" 참조
            퇴직금(직원) 계삭식 = (3개월급여총액+3개월평균상여총액+3개월평균년월차총액)/평균임금계산방식*30*(총근속일수/365)

            [퇴직금기준설정 설정값]
            *평균임금계산방식 : 일평균임금 방식 (D)
            *연차수당코드선택 : 해당되는 지급항목 선택 
                    
            [지급/공제 설정]
                - 상여금 항목 : 평균임금(포함한다) / 상여성퇴직금(포함한다)
                    
        ================================================================================================================================= */

        try
        {


            // DB 연결
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);

            StringBuffer sql = new StringBuffer();
            PreparedStatement  pstmt = null;
            int RECORD_CNT = 0;

            SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );
            
            Date dRETR_DATE = null;
            
            dRETR_DATE = format.parse(RETR_DATE);
                    
            /* ============================================================================================================================
              0. 퇴직 / 중도정산 / 1년미만자 여부 체크
            ===============================================================================================================================*/
            Date H_JOIN_DATE = null;  // 입사일
            Date H_RETR_DATE = null;  // 퇴사일
            
            String strH_JOIN_DATE = "";
            String strH_RETR_DATE = "";
            
            String OT_KIND   = "";    // 퇴직분류 ( OF : 임원, ST : 직원)


            sql.setLength(0);
            sql.append( " SELECT  (CASE WHEN ORI_JOIN_DATE = '00000000' OR ORI_JOIN_DATE = '' THEN JOIN_DATE             " + "\n");
            sql.append( "               ELSE ORI_JOIN_DATE                                                               " + "\n");
            sql.append( "          END)                                                               AS H_JOIN_DATE     " + "\n");
            sql.append( "      , NVL(RETR_DATE,'00000000')                                            AS H_RETR_DATE     " + "\n");
            sql.append( "       , CASE WHEN OT_KIND IS NULL OR OT_KIND = '' THEN 'ST' ELSE OT_KIND END AS OT_KIND         " + "\n");
            sql.append( " FROM HUM100T                                                                                   " + "\n");
            sql.append( " WHERE COMP_CODE   = " + "'" + COMP_CODE + "'                                                   " + "\n");
            sql.append( " AND   PERSON_NUMB = " + "'" + PERSON_NUMB + "'                                                 " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                strH_JOIN_DATE = rs.getString("H_JOIN_DATE");
                strH_RETR_DATE = rs.getString("H_RETR_DATE");
                OT_KIND = rs.getString("OT_KIND");
            }

            pstmt.close();
            rs.close();
            
            if(!strH_JOIN_DATE.equals("00000000")){
                H_JOIN_DATE = format.parse(strH_JOIN_DATE);
            }

            if(!strH_RETR_DATE.equals("00000000")){
                H_RETR_DATE = format.parse(strH_RETR_DATE);
            }
            
            Date sTmpDate = null;
            
            sTmpDate = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.YEAR, H_JOIN_DATE, 1), -1);

            
            if(RETR_TYPE.equals("M") && !strH_RETR_DATE.equals("00000000")){
                return "퇴사자는 중도정산을 할 수 없습니다.";
            }else if(RETR_TYPE.equals("R") && strH_RETR_DATE.equals("00000000")) {
                return "재직자는 퇴직금정산을 할 수 없습니다.";
            }else if(dRETR_DATE.compareTo(sTmpDate) < 0) {
                return "1년 미만자 입니다." + "/" + RETR_DATE + "/" + strH_JOIN_DATE;
            }else{
                
                /*=============
                  1. 퇴직금 계산
                ==============*/

                String M_CALCU_END_DATE = ""; // [중도정산]기산일
                Date dM_CALCU_END_DATE = null;
                String M_RETR_DATE = "";      // [중도정산]정산일
                Date dM_RETR_DATE = null;
                String M_SUPP_DATE = "";      // [중도정산]지급일
                Date dM_SUPP_DATE = null;
                double M_TAX_TOTAL_I = 0;     // [중도정산]정산금액
                int M_CNT = 0;                // [중도정산]갯수

                String R_CALCU_END_DATE   = "";  // [퇴직정산]기산일
                Date dR_CALCU_END_DATE = null;
                String MON_LAST_DATE      = "";  // 정산일에 속한 달의 마지막일자
                Date dMON_LAST_DATE = null;
                String MON_START_DATE     = "";  // 3개월 시작일
                Date dMON_START_DATE = null;
                String MON_END_DATE       = "";  // 3개월 종료일
                Date dMON_END_DATE = null;
                int MON_START_WORK_DAY    = 0;   // 3개월 시작월의 근무일수
                int MON_END_WORK_DAY      = 0;   // 3개월 종료월의 근무일수
                int MON_START_DAY         = 0;   // 3개월 시작월의 일수
                int MON_END_DAY           = 0;   // 3개월 종료월의 일수
                int RETR_END_DAY          = 0;   // 퇴직월의 일수
                String YEAR_START_DATE    = "";  // 1년 시작일
                Date dYEAR_START_DATE = null;
                
                int DUTY_YYYY             = 0;   // (근속기간)년
                int LONG_MONTH            = 0;   // (근속기간)월
                int LONG_DAY              = 0;   // (근속기간)일
                int LONG_YEARS            = 0;   // 근속년
                int LONG_TOT_MONTH        = 0;   // 근속월
                int LONG_TOT_DAY          = 0;   // 근속일자 

                // 퇴직기준설정
                String YEAR_CODE          = "";  // 연차수당 코드
                String AMT_CALCU          = "";  // 평균임금계산방식

                // 연차수당코드
                sql.setLength(0);
                sql.append( " SELECT NVL(YEAR_CODE,'')  AS YEAR_CODE                                " + "\n");
                sql.append( "      , NVL(AMT_CALCU,'D') AS AMT_CALCU  --평균임금계산방식 (D:일평균 , M: 월평균)   " + "\n");
                sql.append( " FROM HBS400T                                                          " + "\n");
                sql.append( " WHERE COMP_CODE = " + "'" + COMP_CODE + "'                            " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    YEAR_CODE = rs.getString("YEAR_CODE");
                    AMT_CALCU = rs.getString("AMT_CALCU");
                }

                pstmt.close();
                rs.close();
                
                // 중도정산 여부 체크
                sql.setLength(0);
                sql.append( " SELECT MIN(A.JOIN_DATE) AS M_CALCU_END_DATE                                                       " + "\n");
                sql.append( "      , MAX(A.RETR_DATE) AS M_RETR_DATE                                                            " + "\n");
                sql.append( "      , MAX(A.SUPP_DATE) AS M_SUPP_DATE                                                            " + "\n");
                sql.append( "      , SUM(A.RETR_ANNU_I + A.GLORY_AMOUNT_I + A.GROUP_INSUR_I + A.ETC_AMOUNT_I) AS M_TAX_TOTAL_I  " + "\n");
                sql.append( "      , COUNT(*) AS M_CNT                                                                          " + "\n");
                sql.append( " FROM HRT500T A                                                                                    " + "\n");
                sql.append( " WHERE A.COMP_CODE         = " + "'" + COMP_CODE + "'                                              " + "\n");
                sql.append( " AND   A.RETR_DATE        != " + "'" + RETR_DATE + "'                                              " + "\n");
                sql.append( " AND   A.RETR_TYPE         = 'M'                                                                   " + "\n");
                sql.append( " AND   A.PERSON_NUMB       = " + "'" + PERSON_NUMB + "'                                             " + "\n");
                sql.append( " GROUP BY A.COMP_CODE                                                                              " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    M_CALCU_END_DATE = rs.getString("M_CALCU_END_DATE");
                    M_RETR_DATE = rs.getString("M_RETR_DATE");
                    M_SUPP_DATE = rs.getString("M_SUPP_DATE");
                    M_TAX_TOTAL_I = rs.getInt("M_TAX_TOTAL_I");
                    M_CNT = rs.getInt("M_CNT");
                }

                pstmt.close();
                rs.close();
                
                // 기산일
                if(M_CNT > 0){
                    dM_RETR_DATE = format.parse(M_RETR_DATE);
                    dM_RETR_DATE = ut.fnGetDateAdd(Calendar.DATE, dM_RETR_DATE, 1);  // 중도정산일 + 1
                    
                    R_CALCU_END_DATE = format.format(dM_RETR_DATE);
                }else{
                    R_CALCU_END_DATE = strH_JOIN_DATE;  // 입사일
                }
                

                
                DUTY_YYYY = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "DUTY_YYYY"));             // (근속기간)년
                LONG_MONTH = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "LONG_MONTH"));           // (근속기간)월
                LONG_DAY = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "LONG_DAY"));               // (근속기간)일
                LONG_YEARS = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "LONG_YEARS"));           // 근속년
                LONG_TOT_MONTH = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "LONG_TOT_MONTH"));   // 근속월
                LONG_TOT_DAY = Integer.parseInt(hf.fnHumanDateDiff(R_CALCU_END_DATE, RETR_DATE, "LONG_TOT_DAY"));       // 근속일자
                
//                System.out.println(DUTY_YYYY);
//                System.out.println(LONG_MONTH);
//                System.out.println(LONG_DAY);
//                System.out.println(LONG_YEARS);
//                System.out.println(LONG_TOT_MONTH);
//                System.out.println(LONG_TOT_DAY);
                
                //=======================
                // 3개월1년 범위계산(일자기준으로 고정)
                //=======================
                Calendar cal = Calendar.getInstance();                    
                cal.setTime(dRETR_DATE);
                
                int endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                String StrEndDay = "0" + String.valueOf(endDay);
                
                String TmpDate = "";
                Date dTmpDate = null;
                
                TmpDate = format.format(dRETR_DATE).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                dTmpDate = format.parse(TmpDate);
                
                
                dMON_LAST_DATE = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dTmpDate, 1), -1);
                
                //===============
                // 3개월 시작일
                //===============
                if(dMON_LAST_DATE.compareTo(dRETR_DATE) == 0){
                    dTmpDate = ut.fnGetDateAdd(Calendar.MONTH, dMON_LAST_DATE, -2);
                    cal.setTime(dTmpDate);
                    
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                    StrEndDay = "0" + String.valueOf(endDay);
                    
                    MON_START_DATE = format.format(dTmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    
                    dMON_START_DATE = format.parse(MON_START_DATE);
                }else{
                    dMON_START_DATE = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dRETR_DATE, -3), 1);
                }
                
                dMON_END_DATE = dRETR_DATE;
                
                //===============
                // 3개월 시작월의 근무일수
                //===============
                dTmpDate = ut.fnGetDateAdd(Calendar.MONTH, dMON_START_DATE, 1);
                cal.setTime(dTmpDate);                
                endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                StrEndDay = "0" + String.valueOf(endDay);
                TmpDate = format.format(dTmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                dTmpDate = ut.fnGetDateAdd(Calendar.DATE, format.parse(TmpDate), -1);
                
                
                MON_START_WORK_DAY = ut.fnSQLDateDiff("DATE", dMON_START_DATE, dTmpDate) + 1;


                //===============
                // 3개월 종료월의 근무일수
                //===============
                if(RETR_TYPE.equals("M")){
                    cal.setTime(dMON_END_DATE);
                    MON_END_WORK_DAY = cal.get(Calendar.DATE);
                }else{
                    cal.setTime(dMON_LAST_DATE);
                    MON_END_WORK_DAY= cal.get(Calendar.DATE);
                }


                //===============
                // 퇴직월일수
                //===============
                cal.setTime(dRETR_DATE);
                RETR_END_DAY = cal.get(Calendar.DATE);

                //===============
                // 3개월 시작월의 월일수
                //===============                
                dTmpDate = ut.fnGetDateAdd(Calendar.MONTH, dMON_START_DATE, 1);
                cal.setTime(dTmpDate);                
                endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                StrEndDay = "0" + String.valueOf(endDay);
                TmpDate = format.format(dTmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                dTmpDate = ut.fnGetDateAdd(Calendar.DATE, format.parse(TmpDate), -1);
                cal.setTime(dTmpDate);
                MON_START_DAY = cal.get(Calendar.DATE);
                
                
                //===============
                // 3개월 종료월의 월일수
                //===============    
                dTmpDate = ut.fnGetDateAdd(Calendar.MONTH, dRETR_DATE, 1);
                cal.setTime(dTmpDate);                
                endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                StrEndDay = "0" + String.valueOf(endDay);
                TmpDate = format.format(dTmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                dTmpDate = ut.fnGetDateAdd(Calendar.DATE, format.parse(TmpDate), -1);
                cal.setTime(dTmpDate);
                MON_END_DAY = cal.get(Calendar.DATE);
                
                
                //===============
                // 1년 범위계산
                //===============    
                if(ut.fnGetDateAdd(Calendar.MONTH, dMON_LAST_DATE, -1).compareTo(dRETR_DATE) == 0){
                    dYEAR_START_DATE = ut.fnGetDateAdd(Calendar.MONTH, dMON_LAST_DATE, -11);
                }else{
                    dYEAR_START_DATE = ut.fnGetDateAdd(Calendar.MONTH, dRETR_DATE, -11);
                    YEAR_START_DATE = format.format(dYEAR_START_DATE).substring(0, 6);
                }
                
                String CALC_TYPE = "";        // 계산식 타입 ( 1:연산자 , 2:DB합산 , 4:숫자)
                String CALC_CODE = "";        // 계산식 코드
                String CALC_SQL  = "";        // 계산식
                double CALC_TMP  = 0.000000;
                double CALC_SUM  = 0.000000;  // 계산값
                double PAY_SUM   = 0.000000;  // 급여총액
                double BONUS_SUM = 0.000000;  // 상여총액
                double YEAR_SUM  = 0.000000;  // 년차총액
                double AVG_PAY   = 0.000000;  // 3개월 급여
                double AVG_BONUS = 0.000000;  // 3개월 상여
                double AVG_YEAR  = 0.000000;  // 3개월 년차
                double TOT_SUM   = 0.000000;  // 총합
                double AVG_SUM   = 0.000000;  // 3개월 총합
                  
                                
                String KeyValue = "";              
                sql.setLength(0);    
                sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    KeyValue = rs.getString(1);
                }

                
                sql.setLength(0);    
                sql.append( "  " + "\n");
                sql.append( "  DROP TABLE IF EXISTS TMP_CALC_" + KeyValue + ";\n");
                sql.append( "                                           " + "\n");
                sql.append( "  CREATE TABLE TMP_CALC_" + KeyValue + "   " + "\n");
                sql.append( "  (                                        " + "\n");
                sql.append( "      KEY_VALUE       VARCHAR(20) NULL,    " + "\n");
                sql.append( "         PERSON_NUMB     VARCHAR(10) ,        " + "\n");
                sql.append( "      CALC_SUM        NUMERIC(30, 6)       " + "\n");                
                sql.append( "  ) REUSE_OID ;                            " + "\n");
                sql.append( "                                           " + "\n");
                sql.append( "  CREATE INDEX TMP_CALC_IDX01 ON TMP_CALC_" + KeyValue + "(key_value); " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                
                
                PreparedStatement pstmt2 = null;
                ResultSet rs2 = null;
                
                CALC_SQL = "";
                CALC_SQL = CALC_SQL + "INSERT INTO TMP_CALC_" + KeyValue + " (KEY_VALUE, PERSON_NUMB , CALC_SUM) " + "\n";
                CALC_SQL = CALC_SQL    + " SELECT " + "'" + KeyValue + "'  ," + "\n";
                CALC_SQL = CALC_SQL    + "    " + "'" + PERSON_NUMB + "'  ," + "\n";
                
                sql.setLength(0);
                sql.append( " SELECT TYPE AS CALC_TYPE, UNIQUE_CODE AS CALC_CODE  " + "\n");    
                sql.append( " FROM HRT000T                                        " + "\n");    
                sql.append( " WHERE COMP_CODE  = " + "'" + COMP_CODE + "'         " + "\n");    
                sql.append( " AND   SUPP_TYPE  = 'R'                              " + "\n");    
                sql.append( " AND   OT_KIND_01 = " + "'" + OT_KIND + "'           " + "\n");    
                sql.append( " ORDER BY CALCU_SEQ                                  " + "\n");    

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();
                
                while(rs.next()){
                    CALC_TYPE = rs.getString("CALC_TYPE");
                    CALC_CODE = rs.getString("CALC_CODE");
                    
                    if(CALC_TYPE.equals("1")){
                        CALC_SQL = CALC_SQL + CALC_CODE;
                    }else if(CALC_TYPE.equals("4")){
                        CALC_SQL = CALC_SQL + CALC_CODE + ".000000";
                    }else{

                        if(CALC_CODE.equals("007")){ // 3개월 급여총액
                            
                            MON_START_DATE = format.format(dMON_START_DATE);
                            MON_END_DATE = format.format(dMON_END_DATE);
                            
                            sql.setLength(0);
                            sql.append( " SELECT SUM(NVL(AMOUNT_I, 0))  AS CALC_TMP" + "\n");    
                            sql.append( "     ,  SUM(NVL(AMOUNT_I, 0))  AS PAY_SUM" + "\n");    
                            sql.append( "     ,  SUM(NVL(AMOUNT_I, 0))  AS AVG_PAY" + "\n");    
                            sql.append( " FROM (" + "\n");        
                            sql.append( "        SELECT CASE WHEN A.PAY_YYYYMM = LEFT(" + "'" + MON_START_DATE + "',6) THEN A.AMOUNT_I * (" + MON_START_WORK_DAY + " / " + MON_START_DAY + ") " + "\n");    
                            sql.append( "                    WHEN A.PAY_YYYYMM > LEFT(" + "'" + MON_START_DATE + "',6) AND A.PAY_YYYYMM < LEFT(" + "'" + MON_END_DATE + "',6) THEN  AMOUNT_I" + "\n");    
                            sql.append( "                    ELSE A.AMOUNT_I * (" + MON_END_WORK_DAY + " / " + MON_END_DAY + ")        END                          AS AMOUNT_I" + "\n");    
                            sql.append( "        FROM       HPA300T A " + "\n");    
                            sql.append( "        INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE" + "\n");    
                            sql.append( "                            AND B.WAGES_CODE = A.WAGES_CODE" + "\n");    
                            sql.append( "        LEFT JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE" + "\n");    
                            sql.append( "                           AND C.MAIN_CODE  = 'H032'" + "\n");    
                            sql.append( "                           AND C.SUB_CODE   = A.SUPP_TYPE" + "\n");    
                            sql.append( "        WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                                 " + "\n");    
                            sql.append( "         AND   A.PERSON_NUMB = " + "'" + PERSON_NUMB + "'                               " + "\n");    
                            sql.append( "         AND   A.PAY_YYYYMM  BETWEEN LEFT(" + "'" + MON_START_DATE + "',6) AND LEFT(" + "'" + MON_END_DATE + "',6)" + "\n");    
                            sql.append( "         AND (A.SUPP_TYPE   = '1' OR C.REF_CODE1 = '1')" + "\n");    
                            sql.append( "         AND B.RETR_WAGES  = 'Y'" + "\n");    
                            sql.append( "         AND B.RETR_BONUS  = 'N'" + "\n");    
                            sql.append( "      ) A" + "\n");    

                            pstmt2 = conn.prepareStatement(sql.toString());
                            rs2 = pstmt2.executeQuery();
                            
                            while(rs2.next()){
                                CALC_TMP = rs2.getDouble("CALC_TMP");
                                PAY_SUM  = rs2.getDouble("PAY_SUM");
                                AVG_PAY  = rs2.getDouble("AVG_PAY");
                            }
                            
                            CALC_SQL = CALC_SQL + CALC_TMP;
                            
                            pstmt2.close();
                            rs2.close();
                            
                        }else if(CALC_CODE.equals("008")){  // 3개월 상여총액
                            
                            YEAR_START_DATE = format.format(dYEAR_START_DATE);
                            RETR_DATE = format.format(dRETR_DATE);

                            sql.setLength(0);
                            sql.append( " SELECT SUM(NVL(A.AMOUNT_I,0))*3/12   AS CALC_TMP                    " + "\n");    
                            sql.append( "      , SUM(NVL(A.AMOUNT_I,0))        AS BONUS_SUM                     " + "\n");    
                            sql.append( "      , SUM(NVL(A.AMOUNT_I,0))*3/12   AS AVG_BONUS                   " + "\n");    
                            sql.append( " FROM       HPA300T A                                                " + "\n");    
                            sql.append( " INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE                  " + "\n");    
                            sql.append( "                     AND B.WAGES_CODE = A.WAGES_CODE                 " + "\n");    
                            sql.append( " LEFT  JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE                  " + "\n");    
                            sql.append( "                      AND C.MAIN_CODE  = 'H032'                       " + "\n");    
                            sql.append( "                      AND C.SUB_CODE   = A.SUPP_TYPE                  " + "\n");    
                            sql.append( " WHERE A.COMP_CODE    = " + "'" + COMP_CODE + "'                     " + "\n");    
                            sql.append( " AND   A.PERSON_NUMB  = " + "'" + PERSON_NUMB + "'                   " + "\n");    
                            sql.append( " AND   A.PAY_YYYYMM  >= LEFT(" + "'" + YEAR_START_DATE + "',6)       " + "\n");    
                            sql.append( " AND   A.PAY_YYYYMM  <= LEFT(" + "'" + RETR_DATE + "',6)             " + "\n");    
                            sql.append( " AND  (A.SUPP_TYPE    = '1' OR C.REF_CODE1 = '1')                    " + "\n");    
                            sql.append( " AND   B.RETR_WAGES   = 'Y'                                          " + "\n");    
                            sql.append( " AND   B.RETR_BONUS   = 'Y'                                          " + "\n");    

                            pstmt2 = conn.prepareStatement(sql.toString());
                            rs2 = pstmt2.executeQuery();
                            
                            while(rs2.next()){
                                CALC_TMP  = rs2.getDouble("CALC_TMP");
                                BONUS_SUM   = rs2.getDouble("BONUS_SUM");
                                AVG_BONUS = rs2.getDouble("AVG_BONUS");
                            }
                            
                            CALC_SQL = CALC_SQL + CALC_TMP;
                            
                            pstmt2.close();
                            rs2.close();
                            
                        }else if(CALC_CODE.equals("009")){  // 3개월 연차수당
                            YEAR_START_DATE = format.format(dYEAR_START_DATE);
                            RETR_DATE = format.format(dRETR_DATE);
                            
                            sql.setLength(0);
                            sql.append( " SELECT SUM(NVL(A.AMOUNT_I,0))*3/12 AS CALC_TMP                     " + "\n");    
                            sql.append( "      , SUM(NVL(A.AMOUNT_I,0))      AS YEAR_SUM                     " + "\n");    
                            sql.append( "      , SUM(NVL(A.AMOUNT_I,0))*3/12 AS AVG_YEAR                     " + "\n");    
                            sql.append( " FROM HPA300T A                                                     " + "\n");    
                            sql.append( " WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                     " + "\n");
                            sql.append( " AND   A.PERSON_NUMB = " + "'" + PERSON_NUMB + "'                   " + "\n");    
                            sql.append( " AND   A.PAY_YYYYMM >= LEFT(" + "'" + YEAR_START_DATE + "',6)       " + "\n");    
                            sql.append( " AND   A.PAY_YYYYMM <= LEFT(" + "'" + RETR_DATE + "',6)             " + "\n");    
                            sql.append( " AND   A.WAGES_CODE  = " + "'" + YEAR_CODE + "'                     " + "\n");    
                            sql.append( " AND   A.AMOUNT_I   != 0 " + "\n");    

                            pstmt2 = conn.prepareStatement(sql.toString());
                            rs2 = pstmt2.executeQuery();
                            
                            while(rs2.next()){
                                CALC_TMP  = rs2.getDouble("CALC_TMP");
                                YEAR_SUM  = rs2.getDouble("YEAR_SUM");
                                AVG_YEAR  = rs2.getDouble("AVG_YEAR");
                            }
                            
                            CALC_SQL = CALC_SQL + CALC_TMP;
                            
                            pstmt2.close();
                            rs2.close();
                            
                        }else if(CALC_CODE.equals("003")){
                            if(AMT_CALCU.equals("D")){
                                CALC_SQL = CALC_SQL + (ut.fnSQLDateDiff("DATE", dMON_START_DATE, dRETR_DATE) + 1);
                            }else{
                                CALC_SQL = CALC_SQL + "3";
                            }
                        }else if(CALC_CODE.equals("031")){  // 총 근속일수
                            CALC_SQL = CALC_SQL + LONG_TOT_DAY;
                        }
                    }
                } // End of while
                
                pstmt.close();
                rs.close();
                
                TOT_SUM = PAY_SUM + BONUS_SUM + YEAR_SUM;
                AVG_SUM = AVG_PAY + AVG_BONUS + AVG_YEAR;
                
                pstmt = conn.prepareStatement(CALC_SQL.toString());
                pstmt.execute();
                pstmt.close();
                
                
                sql.setLength(0);
                sql.append( " SELECT CALC_SUM                                " + "\n");    
                sql.append( " FROM TMP_CALC_" + KeyValue + "                 " + "\n");    
                sql.append( " WHERE KEY_VALUE   = " + "'" + KeyValue + "'    " + "\n");
                sql.append( " AND   PERSON_NUMB = " + "'" + PERSON_NUMB + "' " + "\n");    

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();
                
                while(rs.next()){
                    CALC_SUM  = rs.getDouble("CALC_SUM");
                }
                
                //========================================
                // 2. HRT300T (퇴직급여내역) DELETE / INSERT
                //========================================
                RETR_DATE = format.format(dRETR_DATE);
                
                sql.setLength(0);
                sql.append( " DELETE                                         " + "\n");    
                sql.append( " FROM HRT300T                                   " + "\n");    
                sql.append( " WHERE COMP_CODE   = " + "'" + COMP_CODE + "'   " + "\n");
                sql.append( " AND   RETR_DATE   = " + "'" + RETR_DATE + "'   " + "\n");
                sql.append( " AND   RETR_TYPE   = " + "'" + RETR_TYPE + "'   " + "\n");
                sql.append( " AND   PERSON_NUMB = " + "'" + PERSON_NUMB + "' " + "\n");    
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                MON_START_DATE = format.format(dMON_START_DATE);
                MON_END_DATE = format.format(dMON_END_DATE);
                
                sql.setLength(0);
                sql.append( " INSERT INTO HRT300T                                                                                                                 " + "\n");    
                sql.append( " (  COMP_CODE       , RETR_DATE         , RETR_TYPE        , PERSON_NUMB    , PAY_YYYYMM                                             " + "\n");    
                sql.append( "  , PAY_STRT_DATE   , PAY_LAST_DATE     , WAGES_DAY        , WAGES_CODE     , AMOUNT_I                                               " + "\n");    
                sql.append( "  , UPDATE_DB_USER  , UPDATE_DB_TIME    , INSERT_DB_USER   , INSERT_DB_TIME                                                          " + "\n");    
                sql.append( " )                                                                                                                                      " + "\n");    
                sql.append( " SELECT A.COMP_CODE                                                                                                                  " + "\n");    
                sql.append( "      , " + "'" + RETR_DATE + "'                                                                                                     " + "\n");    
                sql.append( "      , " + "'" + RETR_TYPE + "'                                                                                                     " + "\n");    
                sql.append( "      , A.PERSON_NUMB                                                                                                                " + "\n");    
                sql.append( "      , A.PAY_YYYYMM                                                                                                                 " + "\n");    
                sql.append( "      , CASE WHEN A.PAY_YYYYMM = LEFT(" + "'" + MON_START_DATE + "' ,6) THEN " + "'" + MON_START_DATE + "'                           " + "\n");    
                sql.append( "             ELSE A.PAY_YYYYMM + '01'                                                                                                " + "\n");    
                sql.append( "        END                                                                                                                          " + "\n");    
                sql.append( "      , CASE WHEN A.PAY_YYYYMM = LEFT(" + "'" + MON_END_DATE + "' ,6) THEN " + "'" + MON_END_DATE + "'                               " + "\n");    
                sql.append( "             ELSE TO_CHAR(TO_DATE(ADDDATE(ADDDATE(A.PAY_YYYYMM+'01', INTERVAL 1 MONTH), INTERVAL -1 DAY)), 'YYYYMMDD')               " + "\n");    
                sql.append( "        END                                                                                                                          " + "\n");    
                sql.append( "      , CASE WHEN A.PAY_YYYYMM = LEFT(" + "'" + MON_START_DATE + "' ,6) THEN " + MON_START_WORK_DAY + "                              " + "\n");    
                sql.append( "             WHEN A.PAY_YYYYMM > LEFT(" + "'" + MON_START_DATE + "' ,6) AND A.PAY_YYYYMM < LEFT(" + "'" + MON_END_DATE + "' ,6) THEN " + "\n");    
                sql.append( "                   --CONVERT(NUMERIC,RIGHT(CONVERT(NVARCHAR(10), DATEADD(DAY, -1, DATEADD(MONTH, 1, A.PAY_YYYYMM + '01')), 112), 2))  " + "\n");    
                sql.append( "                  DAY(ADDDATE(ADDDATE(A.PAY_YYYYMM + '01', INTERVAL 1 MONTH), INTERVAL -1 DAY))                                      " + "\n");    
                sql.append( "             ELSE " + MON_END_WORK_DAY + "                                                                                           " + "\n");    
                sql.append( "        END                                                                                                                          " + "\n");    
                sql.append( "      , A.WAGES_CODE                                                                                                                 " + "\n");    
                sql.append( "      , SUM(CASE WHEN A.PAY_YYYYMM = LEFT(" + "'" + MON_START_DATE + "' ,6) THEN A.AMOUNT_I * (" + MON_START_WORK_DAY + " / " + MON_START_DAY + ") " + "\n");    
                sql.append( "                 WHEN A.PAY_YYYYMM > LEFT(" + "'" + MON_START_DATE + "' ,6) AND A.PAY_YYYYMM < LEFT(" + "'" + MON_END_DATE + "' ,6) THEN  A.AMOUNT_I" + "\n");    
                sql.append( "                 ELSE A.AMOUNT_I * (" + MON_END_WORK_DAY + " / " + MON_END_DAY + ")                        " + "\n");    
                sql.append( "            END)                                                                                           " + "\n");    
                sql.append( "      , " + "'" + USER_ID + "'                                                                                                       " + "\n");    
                sql.append( "      , SYSDATETIME" + "\n");    
                sql.append( "      , " + "'" + USER_ID + "'                                                                                                       " + "\n");    
                sql.append( "      , SYSDATETIME" + "\n");    
                sql.append( " FROM       HPA300T A" + "\n");    
                sql.append( " INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE                                                          " + "\n");    
                sql.append( "                      AND B.WAGES_CODE = A.WAGES_CODE                                                         " + "\n");    
                sql.append( " LEFT JOIN  BSA100T C  ON C.COMP_CODE = A.COMP_CODE                                                          " + "\n");    
                sql.append( "                      AND C.MAIN_CODE  = 'H032'                                                               " + "\n");    
                sql.append( "                      AND C.SUB_CODE   = A.SUPP_TYPE                                                          " + "\n");    
                sql.append( " WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                                                              " + "\n");    
                sql.append( " AND   A.PERSON_NUMB = " + "'" + PERSON_NUMB + "'                                                            " + "\n");    
                sql.append( " AND   A.PAY_YYYYMM  BETWEEN LEFT(" + "'" + MON_START_DATE + "' ,6) AND LEFT(" + "'" + MON_END_DATE + "' ,6) " + "\n");    
                sql.append( " AND  (A.SUPP_TYPE   = '1' OR C.REF_CODE1 = '1')                                                             " + "\n");    
                sql.append( " AND   B.RETR_WAGES  = 'Y'                                                                                   " + "\n");    
                sql.append( " AND   B.RETR_BONUS  = 'N'                                                                                   " + "\n");    
                sql.append( " GROUP BY A.COMP_CODE , A.PAY_YYYYMM , A.PERSON_NUMB , A.WAGES_CODE                                          " + "\n");    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                
                //============================================
                // 3. HRT400T (퇴직상여 /연차내역)  DELETE / INSERT
                //============================================
                sql.setLength(0);
                sql.append( " DELETE                                         " + "\n");    
                sql.append( " FROM HRT400T                                   " + "\n");    
                sql.append( " WHERE COMP_CODE   = " + "'" + COMP_CODE + "'   " + "\n");
                sql.append( " AND   RETR_DATE   = " + "'" + RETR_DATE + "'   " + "\n");
                sql.append( " AND   RETR_TYPE   = " + "'" + RETR_TYPE + "'   " + "\n");
                sql.append( " AND   PERSON_NUMB = " + "'" + PERSON_NUMB + "' " + "\n");    
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                YEAR_START_DATE = format.format(dYEAR_START_DATE);
                
                sql.setLength(0);
                sql.append( "INSERT INTO HRT400T                                                                 " + "\n");    
                sql.append( "( COMP_CODE      , RETR_DATE      , RETR_TYPE      , PERSON_NUMB , BONUS_YYYYMM     " + "\n");    
                sql.append( ", BONUS_TYPE     , BONUS_RATE     , BONUS_I        , SUPP_DATE   , INSERT_DB_USER   " + "\n");    
                sql.append( ", INSERT_DB_TIME , UPDATE_DB_USER , UPDATE_DB_TIME                                  " + "\n");    
                sql.append( ")                                                                                   " + "\n");    
                sql.append( "--상여                                                                                                                                                                                                                     " + "\n");    
                sql.append( "SELECT " + "'" + COMP_CODE + "'                                                     " + "\n");    
                sql.append( "     , " + "'" + RETR_DATE + "'                                                     " + "\n");    
                sql.append( "     , " + "'" + RETR_TYPE + "'                                                     " + "\n");    
                sql.append( "     , " + "'" + PERSON_NUMB + "'                                                   " + "\n");    
                sql.append( "     , A.BONUS_YYYYMM                                                               " + "\n");    
                sql.append( "     , '2'                                                                          " + "\n");    
                sql.append( "      , 0                                                                            " + "\n");    
                sql.append( "      , NVL(B.BONUS_I,0)                                                             " + "\n");    
                sql.append( "      , " + "'" + SUPP_DATE + "'                                                     " + "\n");    
                sql.append( "      , " + "'" + USER_ID + "'                                                       " + "\n");    
                sql.append( "      , SYSDATETIME                                                                  " + "\n");    
                sql.append( "      , " + "'" + USER_ID + "'                                                       " + "\n");    
                sql.append( "      , SYSDATETIME                                                                  " + "\n");    
                sql.append( "FROM (                                                                              " + "\n");    
                sql.append( "                                                                                    " + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL 0 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -1 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -2 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -3 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -4 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -5 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -6 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -7 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -8 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -9 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -10 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "       UNION ALL" + "\n");    
                sql.append( "       SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(LEFT(" + "'" + RETR_DATE + "', 6) + '01', INTERVAL -11 MONTH), INTERVAL 1 DAY)), 'YYYYMM') AS BONUS_YYYYMM       " + "\n");    
                sql.append( "     ) A " + "\n");    
                sql.append( "LEFT JOIN (                                                              " + "\n");    
                sql.append( "            SELECT A.PAY_YYYYMM            AS BONUS_YYYYMM                " + "\n");    
                sql.append( "                 , SUM(NVL(A.AMOUNT_I,0))  AS BONUS_I                     " + "\n");    
                sql.append( "           FROM       HPA300T A                                          " + "\n");    
                sql.append( "           INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE            " + "\n");    
                sql.append( "                               AND B.WAGES_CODE = A.WAGES_CODE           " + "\n");    
                sql.append( "           LEFT  JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE            " + "\n");    
                sql.append( "                               AND C.MAIN_CODE  = 'H032'                 " + "\n");    
                sql.append( "                               AND C.SUB_CODE   = A.SUPP_TYPE            " + "\n");    
                sql.append( "            WHERE A.COMP_CODE  = " + "'" + COMP_CODE + "'                " + "\n");    
                sql.append( "            AND A.PERSON_NUMB  = " + "'" + PERSON_NUMB + "'              " + "\n");    
                sql.append( "            AND A.PAY_YYYYMM  >= LEFT(" + "'" + YEAR_START_DATE + "' ,6) " + "\n");    
                sql.append( "            AND A.PAY_YYYYMM  <= LEFT(" + "'" + RETR_DATE + "' ,6)       " + "\n");    
                sql.append( "            AND (A.SUPP_TYPE   = '1' OR C.REF_CODE1 = '1')               " + "\n");    
                sql.append( "            AND B.RETR_WAGES   = 'Y'                                     " + "\n");    
                sql.append( "            AND B.RETR_BONUS   = 'Y'                                     " + "\n");    
                sql.append( "            GROUP BY A.COMP_CODE , A.PAY_YYYYMM , A.PERSON_NUMB           " + "\n");    
                sql.append( "            ) B ON A.BONUS_YYYYMM = B.BONUS_YYYYMM                        " + "\n");    
                sql.append( "                                                                         " + "\n");    
                sql.append( "UNION ALL                                                                " + "\n");    
                sql.append( "                                                                         " + "\n");    
                sql.append( "--연차                                                                                                                                                                                       " + "\n");    
                sql.append( "SELECT A.COMP_CODE                                                       " + "\n");    
                sql.append( "     , " + "'" + RETR_DATE + "'                                          " + "\n");    
                sql.append( "     , " + "'" + RETR_TYPE + "'                                          " + "\n");    
                sql.append( "     , A.PERSON_NUMB                                                     " + "\n");    
                sql.append( "     , A.PAY_YYYYMM                                                      " + "\n");    
                sql.append( "     , 'F'                                                               " + "\n");    
                sql.append( "     , 0                                                                 " + "\n");    
                sql.append( "     , SUM(NVL(A.AMOUNT_I,0))                                            " + "\n");    
                sql.append( "     , " + "'" + SUPP_DATE + "'                                          " + "\n");    
                sql.append( "     , " + "'" + USER_ID + "'                                            " + "\n");    
                sql.append( "      , SYSDATETIME                                                       " + "\n");    
                sql.append( "      , " + "'" + USER_ID + "'                                            " + "\n");    
                sql.append( "      , SYSDATETIME                                                       " + "\n");    
                sql.append( "FROM HPA300T A                                                           " + "\n");    
                sql.append( "WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                           " + "\n");
                sql.append( "AND   A.PERSON_NUMB = " + "'" + PERSON_NUMB + "'                         " + "\n");    
                sql.append( "AND   A.PAY_YYYYMM >= LEFT(" + "'" + YEAR_START_DATE + "',6)             " + "\n");    
                sql.append( "AND   A.PAY_YYYYMM <= LEFT(" + "'" + RETR_DATE + "' ,6)                  " + "\n");    
                sql.append( "AND   A.WAGES_CODE  = " + "'" + YEAR_CODE + "'                           " + "\n");    
                sql.append( "AND   A.AMOUNT_I   != 0                                                  " + "\n");    
                sql.append( "GROUP BY A.COMP_CODE , A.PAY_YYYYMM , A.PERSON_NUMB                      " + "\n");    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                //============================================
                // 5. HRT500T (퇴직정산내역) DELETE / INSERT
                //============================================
                String RETR_RESN = "";
                
                if(RETR_TYPE.equals("M")){
                    RETR_RESN = "5";
                }else if(RETR_TYPE.equals("R")) {
                    if(OT_KIND.equals("OF")){
                        RETR_RESN = "4";
                    }else{
                        RETR_RESN = "3";
                    }
                }else{
                    RETR_RESN = "6";
                }
                
                sql.setLength(0);
                sql.append( " DELETE                                         " + "\n");    
                sql.append( " FROM HRT500T                                   " + "\n");    
                sql.append( " WHERE COMP_CODE   = " + "'" + COMP_CODE + "'   " + "\n");
                sql.append( " AND   RETR_DATE   = " + "'" + RETR_DATE + "'   " + "\n");
                sql.append( " AND   RETR_TYPE   = " + "'" + RETR_TYPE + "'   " + "\n");
                sql.append( " AND   PERSON_NUMB = " + "'" + PERSON_NUMB + "' " + "\n");    
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                sql.setLength(0);
                sql.append( "INSERT INTO HRT500T" + "\n");    
                sql.append( "( COMP_CODE        , RETR_DATE       , RETR_TYPE         , PERSON_NUMB       , JOIN_DATE         , SUPP_DATE       , RETR_RESN          , DUTY_YYYY     , LONG_MONTH" + "\n");    
                sql.append( ", LONG_DAY         , LONG_TOT_DAY    , LONG_TOT_MONTH    , LONG_YEARS        , PAY_TOTAL_I       , BONUS_TOTAL_I   , YEAR_TOTAL_I       , AVG_PAY_3     , AVG_BONUS_I_3" + "\n");    
                sql.append( ", AVG_YEAR_I_3     , TOT_WAGES_I     , AVG_WAGES_I       , ORI_RETR_ANNU_I   , RETR_ANNU_I       , GLORY_AMOUNT_I  , GROUP_INSUR_I      , OUT_INCOME_I  , ETC_AMOUNT_I " + "\n");    
                sql.append( ", RETR_SUM_I       , SUPP_TOTAL_I    , REAL_AMOUNT_I     , R_ANNU_TOTAL_I    , R_TAX_TOTAL_I     , R_JOIN_DATE     , R_CALCU_END_DATE   , R_RETR_DATE   , R_SUPP_DATE " + "\n");    
                sql.append( ", R_LONG_MONTHS    , R_LONG_YEARS    , S_JOIN_DATE       , S_CALCU_END_DATE  , S_RETR_DATE       , S_LONG_MONTHS   , S_LONG_YEARS" + "\n");    
                sql.append( ", INSERT_DB_USER   , INSERT_DB_TIME  , UPDATE_DB_USER    , UPDATE_DB_TIME           ) " + "\n");    
                sql.append( "VALUES" + "\n");    
                sql.append( "( " + "'" + COMP_CODE + "'        " + "\n");    
                sql.append( ", " + "'" + RETR_DATE + "'        " + "\n");    
                sql.append( ", " + "'" + RETR_TYPE + "'        " + "\n");    
                sql.append( ", " + "'" + PERSON_NUMB + "'      " + "\n");    
                sql.append( ", " + "'" + R_CALCU_END_DATE + "' " + "\n");    
                sql.append( ", " + "'" + SUPP_DATE + "'        " + "\n");    
                sql.append( ", " + "'" + RETR_RESN + "'        " + "\n");    
                sql.append( ", " + DUTY_YYYY + "               " + "\n");    
                sql.append( ", " + LONG_MONTH + "              " + "\n");    
                sql.append( ", " + LONG_DAY + "                " + "\n");    
                sql.append( ", " + LONG_TOT_DAY + "            " + "\n");    
                sql.append( ", " + LONG_TOT_MONTH + "          " + "\n");    
                sql.append( ", " + LONG_YEARS + "              " + "\n");    
                sql.append( ", " + PAY_SUM + "                 " + "\n");    
                sql.append( ", " + BONUS_SUM + "               " + "\n");    
                sql.append( ", " + YEAR_SUM + "                " + "\n");    
                sql.append( ", " + AVG_PAY + "                 " + "\n");    
                sql.append( ", " + AVG_BONUS + "               " + "\n");    
                sql.append( ", " + AVG_YEAR + "                " + "\n");    
                sql.append( ", " + AVG_SUM + "                 " + "\n");
                sql.append( ", FLOOR(" + AVG_SUM + " / 3)      " + "\n");    
//                sql.append( ", " + TOT_SUM + "                 " + "\n");
//                sql.append( ", FLOOR(" + TOT_SUM + " / 3)      " + "\n");
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", 0                               " + "\n");    
                sql.append( ", 0                               " + "\n");    
                sql.append( ", 0                               " + "\n");    
                sql.append( ", 0                               " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + CALC_SUM + "                " + "\n");    
                sql.append( ", " + "'" + strH_JOIN_DATE + "'   " + "\n");    
                sql.append( ", " + "'" + R_CALCU_END_DATE + "' " + "\n");    
                sql.append( ", " + "'" + RETR_DATE + "'        " + "\n");    
                sql.append( ", " + "'" + SUPP_DATE + "'        " + "\n");    
                sql.append( ", " + LONG_TOT_MONTH + "          " + "\n");    
                sql.append( ", " + LONG_YEARS + "              " + "\n");    
                sql.append( ", " + "'" + strH_JOIN_DATE + "'   " + "\n");    
                sql.append( ", " + "'" + R_CALCU_END_DATE + "' " + "\n");    
                sql.append( ", " + "'" + RETR_DATE + "'        " + "\n");    
                sql.append( ", " + LONG_TOT_MONTH + "          " + "\n");    
                sql.append( ", " + LONG_YEARS + "              " + "\n");    
                sql.append( ", " + "'" + USER_ID + "'          " + "\n");
                sql.append( ", SYSDATETIME                     " + "\n");    
                sql.append( ", " + "'" + USER_ID + "'          " + "\n");
                sql.append( ", SYSDATETIME                     " + "\n");    
                sql.append( ")" + "\n");    


                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                sql.setLength(0);    
                sql.append( "  DROP TABLE IF EXISTS TMP_CALC_" + KeyValue + ";\n");
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
            }
            
            //---------------------------------------------------------------------------------------------------------
            conn.setAutoCommit(true);
            return sRtn;

        } catch (Exception e) {
            //System.out.println(e.getMessage());
            return e.getMessage();   

        }
    }

    // 퇴직금 계산(SP 개발로인한 작업중지)
    @SuppressWarnings("static-access")
    public static String SP_HUMAN_RetirePayCalc(
            String sCompCode      //법인코드
            , String sPersonNumb    //사번
            , String sRetrType      //정산구분 ( M : 중도정산, R : 퇴직자, S : 퇴직추계)
            , String sRetrDate      //정산일
            , String sSuppDate      //지급일
            , String sUserId        //로그인id
            , int dExepMonthsBe13   //2013이전 제외 월수
            , int dExepDayBe13      //2013이전 제외 일수
            , int dExepMonthsAf13   //2013이후 제외 월수
            , int dExepDayAf13      //2013이후 제외 일수
            ) {
        UtilFunction ut = new UtilFunction();

        Connection conn = null;
        ResultSet rs = null;

        String sRtn = "";

        final String csOF_BEFORE_DATE  = "20111231";  // 임원퇴직금개정기준일
        final String csOF_REVISE_DATE  = "20120101";  // 임원퇴직금개정시행일
        final String csTAX_BEFORE_DATE = "20121231";  // 퇴직소득세개정기준일
        final String csTAX_REVISE_DATE = "20130101";  // 퇴직소득세개정시행일

        boolean bMidRetrExist = false;
        boolean sBool = false;

        int iMDutyYyyy = 0;
        int iMLongMonth = 0;
        int iMLongDay = 0;
        int iMLongMonths = 0;
        int iMLongDays = 0;

        int iRDutyYyyy = 0;
        int iRLongMonth = 0;
        int iRLongDay = 0;
        int iRLongMonths = 0;
        int iRLongDays = 0;

        int iSDutyYyyy = 0;
        int iSLongMonth = 0;
        int iSLongDay = 0;
        int iSLongMonths = 0;
        int iSLongDays = 0;

        int iAddMonth = 0;
        int iRExepMonthsBe13 = 0;
        int iRExepMonthsAf13 = 0;
        int iRExepMonths = 0;

        int iRAddMonthsBe13 = 0;
        int iRAddMonthsAf13 = 0;
        int iRAddMonths = 0;
        int iRLongMonthsCal = 0;
        int iRLongYears = 0;
        String sSJoinDate = "";
        String sSCalcuEndDate = "";
        String sSRetrDate = "";

        int iSExepMonths = 0;
        int iSAddMonths = 0;
        int iSDupliMonths = 0;
        int iSLongMonthsCal = 0;
        int iSLongYears = 0;

        String sCalcuEndDateBe13 = "";
        String sRetrDateBe13 = "";
        int iLongMonthsBe13 = 0;
        int iExepMonthsBe13 = 0;
        int iAddMonthsBe13 = 0;
        int iLongYearsBe13 = 0;
        String sCalcuEndDateAf13 = "";
        String sRetrDateAf13 = "";
        int iLongMonthsAf13 = 0;
        int iExepMonthsAf13 = 0;
        int iAddMonthsAf13 = 0;
        int iLongYearsAf13 = 0;
        int iLongMonthsBe13Cal = 0;
        int iLongMonthsAf13Cal = 0;




        //System.out.println(Integer.parseInt("20170501".substring(6, 8)) - Integer.parseInt("20170510".substring(6, 8)));

        //        SimpleDateFormat fmrt2 = new SimpleDateFormat( "yyyyMMdd" );
        //        Date sDateFrx = null;
        //        Date sDateTox = null;
        //
        //        try {
        //        sDateFrx = fmrt2.parse( "20170615" );  // 최종분 기산일
        //        
        //        Calendar cal = Calendar.getInstance();
        //        
        //        cal.setTime(sDateFrx);
        //        int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
        //        
        //        String StrEndDay = String.valueOf(endDay);
        //        
        //        System.out.print(fmrt2.format(sDateFrx).substring(0,  6) + StrEndDay);
        //        
        //        } catch (ParseException e) {
        //            e.printStackTrace();
        //        }

        try
        {
            //            int abc = ut.fnSQLDateDiff("YYYY", "20150101", "20170101");
            //            System.out.println(abc);

            // fnSQLDateDiff overloading date type
            //            try {
            //                SimpleDateFormat fmrt3 = new SimpleDateFormat( "yyyyMMdd" );
            //                Date f1 = null;
            //                Date f2 = null;
            //
            //                f1 = fmrt3.parse("20150101");
            //                f2 = fmrt3.parse("20170101");
            //                int abc = fnSQLDateDiff("mm", f1, f2);
            //                System.out.println(abc);
            //            } catch(Exception e){
            //                
            //            }

            //            double abcd = 0.0;
            //            
            //            String aaaa = "20170128";
            //            
            //            abcd = Integer.parseInt(aaaa.substring(6, 8));
            //            System.out.println(abcd);
            //-------------------------------
            /*
            try {
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat fmrt3 = new SimpleDateFormat( "yyyyMMdd" );
                Date TmpDate = null;  

                Date abb = fmrt3.parse( "20170401" );

                cal.setTime(abb);

                int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                    
                String StrEndDay = String.valueOf(endDay);

                TmpDate = fmrt3.parse( fmrt3.format(abb).substring(0,  6) + StrEndDay );


                double lFrMonWorkDays = 0.0;

                lFrMonWorkDays = fnGetDateDiff(Calendar.DATE, abb, TmpDate) + 1;

                System.out.println(lFrMonWorkDays);

            }catch (ParseException e) {
                e.printStackTrace();
            }  
             */

            //-------------------------------

            // DB 연결
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);

            StringBuffer sql = new StringBuffer();
            PreparedStatement  pstmt = null;
            int RECORD_CNT = 0;

            // ========================
            //   0.퇴직정산은 퇴직자인 경우만 해당         
            //     중도정산은 재직자인 경우만 해당         
            // ========================            
            if(sRetrType.equals("R") || sRetrType.equals("M")) {

                String vRETR_DATE = "";

                sql.setLength(0);
                sql.append( " SELECT RETR_DATE                                   " + "\n");
                sql.append( " FROM HUM100T                                       " + "\n");
                sql.append( " WHERE COMP_CODE   = " + "'" + sCompCode + "'       " + "\n");
                sql.append( " AND   PERSON_NUMB = " + "'" + sPersonNumb + "'     " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    vRETR_DATE = rs.getString("RETR_DATE");
                }

                if(sRetrType.equals("R") && vRETR_DATE.equals("00000000")) {
                    pstmt.close();
                    rs.close();
                    //System.out.println("퇴직금계산은 퇴직자만 가능합니다.(1)");
                    return "퇴직금계산은 퇴직자만 가능합니다.[001]";
                }

                if(sRetrType.equals("M") && !vRETR_DATE.equals("00000000")) {
                    pstmt.close();
                    rs.close();
                    //System.out.println("퇴직금계산은 퇴직자만 가능합니다.(2)");
                    return "퇴직금계산은 퇴직자만 가능합니다.[002]";
                }

                pstmt.close();
                rs.close();
            }

            // ========================
            //        정산내역이 있는지 확인               
            // ========================
            sql.setLength(0);
            sql.append( " SELECT COUNT(*) AS HRT_CNT                        " + "\n");
            sql.append( " FROM HRT500T                                      " + "\n");
            sql.append( " WHERE COMP_CODE      = " + "'" + sCompCode + "'   " + "\n");
            sql.append( " AND   RETR_TYPE      = " + "'" + sRetrType + "'   " + "\n");
            sql.append( " AND   RETR_DATE      = " + "'" + sRetrDate + "'   " + "\n");
            sql.append( " AND   PERSON_NUMB    = " + "'" + sPersonNumb + "' " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                RECORD_CNT = rs.getInt("HRT_CNT");
            }

            pstmt.close();
            rs.close();

            // ======================== 
            //         퇴직금계산                              
            // ========================
            if(RECORD_CNT == 0){

                // ========================
                //  지급일이 없으면 퇴직일로 셋팅   117
                // ========================
                if(sSuppDate.equals("") || sSuppDate.isEmpty()){
                    sSuppDate = sRetrDate;
                }

                // ========================
                //  1. 퇴직금 기준설정 139
                // ========================
                sql.setLength(0);
                sql.append( " SELECT AMT_RANGE                            " + "\n");     //'3개월평균범위      - D:일자기준    /B:전월기준     /M:마감기준(월) /N:마감기준(일)
                sql.append( "      , AMT_CALCU                            " + "\n");     //'평균임금계산방식   - D:일평균임금  /M:월평균임금
                sql.append( "      , PERIOD_CALCU                         " + "\n");     //'근속기간계산방식   - D:근속일수    /M:근속월수     /T:년월일
                sql.append( "      , RETR_DUTY_RULE                       " + "\n");     //'근속기간산정방식   - ○일 이상이면 1개월 간주
                sql.append( "      , ADD_YN                               " + "\n");     //'누진적용여부       - Y:한다        /N:안한다
                sql.append( "      , PS_ADD_YN                            " + "\n");     //'임원누진적영여부   - Y:한다        /N:안한다
                sql.append( "      , LAST_YEAR_YN                         " + "\n");     //'마지막년차포함여부 - Y:한다        /N:안한다
                sql.append( "      , NVL(YEAR_CODE , '') AS YEAR_CODE     " + "\n");     //연차수당코드
                sql.append( "      , NVL(BONUS_CODE, '') AS BONUS_CODE    " + "\n");     //상여금코드
                sql.append( "      , NVL(RETR_CODE , '') AS RETR_CODE     " + "\n");     //퇴직금코드
                sql.append( " FROM HBS400T                                " + "\n");
                sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "'  " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                List<Map> vRtnHBS400T = new ArrayList<Map>();

                /* 퇴직금 기준설정 ResultSet --> List Map */
                vRtnHBS400T = ut.getRsToList(rs);

                pstmt.close();
                rs.close();

                // ========================
                //  2. 입사일,퇴직분류(직원/임원) 157       
                // ========================
                sql.setLength(0);
                sql.append( " SELECT (CASE WHEN NVL(B.POST_CODE   , '') != '' THEN 'OF'           " + "\n");
                sql.append( "              WHEN NVL(A.RETR_OT_KIND, '')  = '' THEN 'ST'           " + "\n");
                sql.append( "              ELSE A.RETR_OT_KIND                                    " + "\n");
                sql.append( "         END) AS RETR_OT_KIND                                        " + "\n");
                sql.append( "      , (CASE WHEN A.ORI_JOIN_DATE = '00000000' THEN A.JOIN_DATE     " + "\n");  
                sql.append( "              ELSE A.ORI_JOIN_DATE                                   " + "\n");
                sql.append( "         END) AS JOIN_DATE                                           " + "\n");
                sql.append( " FROM      HUM100T A                                                 " + "\n");
                sql.append( " LEFT JOIN HRT120T B ON B.COMP_CODE = A.COMP_CODE                    " + "\n");
                sql.append( "                    AND B.POST_CODE = A.POST_CODE                    " + "\n");
                sql.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'                      " + "\n");
                sql.append( " AND   A.PERSON_NUMB = " + "'" + sPersonNumb + "'                    " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                String sJoinDate   = "";
                String sRetrOtKind = "";

                while(rs.next()){
                    sJoinDate   = rs.getString("JOIN_DATE");
                    sRetrOtKind = rs.getString("RETR_OT_KIND");
                }

                SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );
                Date sRetrDateConv = null;
                Date sJoinDateConv = null;

                try{
                    sRetrDateConv = format.parse( sRetrDate );

                    if(!sJoinDate.equals("")){
                        sJoinDateConv = format.parse( sJoinDate );                        

                        int compare = sJoinDateConv.compareTo( ut.fnGetDateAdd(Calendar.YEAR, sRetrDateConv, 1) );
                        if ( compare > 0 )
                        {
                            pstmt.close();
                            rs.close();
                            return "퇴직금 계산일은 입사일보다 이전일 수 없습니다.[003]";
                        }
                    }

                    pstmt.close();
                    rs.close();
                } catch (ParseException e) {
                    pstmt.close();
                    rs.close();
                    throw e;
                }

                // ========================
                //  3. 중간지급-중도정산금액,기납부세액   185
                // ========================
                sql.setLength(0);
                sql.append( " SELECT A.COMP_CODE                                                                                                      " + "\n");
                sql.append( "      , MIN(A.JOIN_DATE)                                                                             AS M_CALCU_END_DATE " + "\n");
                sql.append( "      , MAX(A.RETR_DATE)                                                                             AS M_RETR_DATE      " + "\n");
                sql.append( "      , MAX(A.SUPP_DATE)                                                                             AS M_SUPP_DATE      " + "\n");
                sql.append( "      , SUM(A.RETR_ANNU_I + A.GLORY_AMOUNT_I + A.GROUP_INSUR_I + A.ETC_AMOUNT_I + A.OUT_INCOME_I)    AS M_ANNU_TOTAL_I   " + "\n");
                sql.append( "      , SUM(A.OUT_INCOME_I)                                                                          AS M_OUT_INCOME_I   " + "\n");
                sql.append( "      , SUM(A.RETR_ANNU_I + A.GLORY_AMOUNT_I + A.GROUP_INSUR_I + A.ETC_AMOUNT_I)                     AS M_TAX_TOTAL_I    " + "\n");
                sql.append( "      , SUM(A.IN_TAX_I)                                                                              AS PAY_END_TAX      " + "\n");
                sql.append( " FROM HRT500T A                                                                                                          " + "\n");
                sql.append( " WHERE A.COMP_CODE           = " + "'" + sCompCode + "'                                                                  " + "\n");
                sql.append( " AND   A.RETR_DATE          != " + "'" + sRetrDate + "'                                                                  " + "\n");
                sql.append( " AND   A.RETR_TYPE           = 'M'                                                                                       " + "\n");
                sql.append( " AND   A.PERSON_NUMB         = " + "'" + sPersonNumb + "'                                                                " + "\n");
                sql.append( " AND   LEFT(A.SUPP_DATE,4)   = CASE WHEN " + "'" + sRetrType + "' = 'R' THEN LEFT(" + "'" + sRetrDate + "', 4)           " + "\n");
                sql.append( "                                    ELSE  LEFT(" + "'" + sSuppDate + "', 4)                                              " + "\n");
                sql.append( "                               END                                                                                       " + "\n");
                sql.append( " GROUP BY A.COMP_CODE                                                                                                    " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                //System.out.println("20170121".substring(0, 4));

                //System.out.println(global.diff_day);
                //fnDateDiff("20090101", "20170609", "1");
                //System.out.println(global.diff_day);

                String sMJoinDate = "";
                String sMCalcuEndDate = "";
                String sMRetrDate = "";
                String sMSuppDate = "";
                long dMAnnuTotalI = 0;
                long dMOutIncomeI = 0;
                long dMTaxTotalI = 0;
                long dPayEndTax = 0;
                int iMExepMonthsBe13 = 0;
                int iMExepMonthsAf13 = 0;
                int iMExepMonths = 0;
                int iMAddMonthsBe13 = 0;
                int iMAddMonthsAf13 = 0;
                int iMAddMonths = 0;
                int iMLongMonthsCal = 0;
                //long iMLongMonths = 0;
                int iMLongYears = 0;


                while(rs.next()){

                    bMidRetrExist = true;

                    sMJoinDate = sJoinDate;                                        // 중간지급-입사일
                    sMCalcuEndDate = rs.getString("M_CALCU_END_DATE");             // 중간지급-기산일

                    if(Integer.parseInt(rs.getString("M_RETR_DATE").substring(0, 4)) >= 2013) {
                        sMRetrDate = rs.getString("M_SUPP_DATE");                   // 중간지급-퇴사일(2013년이후는 중도정산의 지급일이 퇴사일)                    
                    } else {
                        sMRetrDate = rs.getString("M_RETR_DATE");                   // 중간지급-퇴사일(2013년이전은 중도정산의 퇴사일이 퇴사일)
                    }

                    sMSuppDate   = rs.getString("M_SUPP_DATE");                    // 중간지급-지급일
                    dMAnnuTotalI = rs.getLong("M_ANNU_TOTAL_I");                   // 중간지급-퇴직급여
                    dMOutIncomeI = rs.getLong("M_OUT_INCOME_I");                   // 중간지급-비과세퇴직급여
                    dMTaxTotalI  = rs.getLong("M_TAX_TOTAL_I");                    // 중간지급-과세대상퇴직급여
                    dPayEndTax   = rs.getLong("PAY_END_TAX");                      // 중간지급-기납부세액


                    // ==========================
                    //  4. 중간지급-근속년,근속월,근속일,근속년수
                    //    ,근속월수,근속일수,제외월수,가산월수 224
                    // ==========================
                    sBool = fnDateDiff(sMCalcuEndDate, sMRetrDate, vRtnHBS400T.get(0).get("retr_duty_rule").toString());

                    iMDutyYyyy = global.diff_yy;
                    iMLongMonth = global.diff_mm;
                    iMLongDay = global.diff_dd;
                    iMLongMonths = global.diff_month;
                    iMLongDays = global.diff_day;

                    if(!sBool){
                        pstmt.close();
                        rs.close();
                        return "퇴직금 계산작업중 오류가 발생했습니다.[fnDateDiff][004]";
                    }

                    iMExepMonthsBe13 = 0;                                          // 중간지급-제외월수(2013이전)
                    iMExepMonthsAf13 = 0;                                          // 중간지급-제외월수(2013이후)
                    iMExepMonths     = iMExepMonthsBe13 + iMExepMonthsAf13;        // 중간지급-제외월수
                    iMAddMonthsBe13  = 0;                                          // 중간지급-가산월수(2013이전)
                    iMAddMonthsAf13  = 0;                                          // 중간지급-가산월수(2013이후)
                    iMAddMonths      = iMAddMonthsBe13 + iMAddMonthsAf13;          // 중간지급-가산월수
                    iMLongMonthsCal  = iMLongMonths - iMExepMonths + iMAddMonths;  // 중간지급-최종근속월수 = 근속월수 - 제외월수 + 가산월수

                    if(iMLongMonthsCal > 0) {
                        if(iMLongMonthsCal % 12 > 0) {
                            iMLongYears = (int)(iMLongMonthsCal / 12) + 1;
                        }else{
                            iMLongYears = (int)(iMLongMonthsCal / 12);
                        }
                    }else {
                        iMLongYears = 0;
                    }
                } // End Of while

                pstmt.close();
                rs.close();

                // ===========================================================================================
                //  5. 최종분-기산일(중도정산이 없는 경우:입사일/중도정산이 있는 경우:2013년이전 최종정산일 + 1일, 2013년이후 최종지급일 + 1일) 270
                // ===========================================================================================
                sql.setLength(0);
                sql.append( " SELECT TO_CHAR(                                                                                                " + "\n");
                sql.append( "                         NVL(                                                                                   " + "\n");
                sql.append( "                              (                                                                                 " + "\n");
                sql.append( "                               SELECT (CASE WHEN (                                                              " + "\n");
                sql.append( "                                                   SELECT COUNT(*)                                              " + "\n");
                sql.append( "                                                   FROM HRT500T                                                 " + "\n");
                sql.append( "                                                   WHERE COMP_CODE   = K.COMP_CODE                              " + "\n");
                sql.append( "                                                   AND   PERSON_NUMB = K.PERSON_NUMB                            " + "\n");
                sql.append( "                                                   AND   RETR_DATE   = " + "'" + sRetrDate + "'                 " + "\n");
                sql.append( "                                                   AND   RETR_DATE   < " + "'" + sRetrDate + "'                 " + "\n");
                sql.append( "                                                   AND   RETR_TYPE    = 'M'                                     " + "\n");
                sql.append( "                                                 ) != 0 THEN  " + "'" + sRetrDate + "'                          " + "\n");
                sql.append( "                                            ELSE (CASE WHEN LEFT(MAX(SUPP_DATE),4) < '2013' THEN ADDDATE(MAX(RETR_DATE), INTERVAL +1 DAY) --DATEADD(DAY, 1, CONVERT(DATETIME, MAX(RETR_DATE), 112)) " + "\n");
                sql.append( "                                                       ELSE ADDDATE(MAX(SUPP_DATE), INTERVAL +1 DAY) --DATEADD(DAY, 1, CONVERT(DATETIME, MAX(SUPP_DATE), 112))                                  " + "\n");
                sql.append( "                                                  END)                                                          " + "\n");
                sql.append( "                                       END)                                                                     " + "\n");
                sql.append( "                               FROM HRT500T K                                                                   " + "\n");
                sql.append( "                               WHERE K.COMP_CODE    = A.COMP_CODE                                               " + "\n");
                sql.append( "                               AND   K.PERSON_NUMB  = A.PERSON_NUMB                                             " + "\n");
                sql.append( "                               AND   K.RETR_TYPE    = 'M'                                                       " + "\n");
                sql.append( "                               AND   K.RETR_DATE    < " + "'" + sRetrDate + "'                                  " + "\n");
                sql.append( "                               GROUP BY PERSON_NUMB, K.COMP_CODE                                                " + "\n");
                sql.append( "                              )                                                                                 " + "\n");
                sql.append( "                           , TO_CHAR( (CASE WHEN A.ORI_JOIN_DATE = '00000000' THEN A.JOIN_DATE                  " + "\n");
                sql.append( "                                            ELSE A.ORI_JOIN_DATE                                                " + "\n");
                sql.append( "                                       END), 'YYYYMMDD')                                                        " + "\n");
                sql.append( "                      ), 'YYYYMMDD') AS R_CALCU_END_DATE                                                        " + "\n");
                sql.append( " FROM HUM100T A                                                                                                 " + "\n");
                sql.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'                                                                 " + "\n");
                sql.append( " AND   A.PERSON_NUMB = " + "'" + sPersonNumb + "'                                                               " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                String sRJoinDate = sJoinDate;         // 최종분 입사일
                String sRRetrDate = "";
                String sRSuppDate = "";
                String sRCalcuEndDate = "";

                while(rs.next()){
                    sRCalcuEndDate = rs.getString("R_CALCU_END_DATE");    // 최종분 기산일
                }
                pstmt.close();
                rs.close();

                if(sRetrType.equals("M")) {
                    sRRetrDate = sSuppDate;    // 최종분 퇴사일=중도정산인 경우 퇴사일은 지급일로 함.
                }else{
                    sRRetrDate = sRetrDate;    // 최종분 퇴사일=중도정산이 아닌 경우 퇴사일은 정산일로 함.
                }

                sRSuppDate = sSuppDate;        // 최종분 지급일


                // =========================
                //  6. 최종분-기산일/퇴사일 확인 317
                // =========================
                if (sRCalcuEndDate.compareTo(sRRetrDate) > 0)
                {
                    if(sRetrType.equals("M")){
                        return "입사일 : " + sRCalcuEndDate + " 퇴직일 : " + sRetrDate + " [005]";
                    }else{
                        return "정산시작일 : " + sRCalcuEndDate + " 정산일 : " + sRetrDate + " [005]";
                    }
                }

                // ==================================================
                //  7. 최종분-근속년,근속월,근속일,근속년수,근속월수,근속일수,제외월수,가산월수
                // ==================================================        
                // 초기화
                global.diff_yy = 0;
                global.diff_mm = 0;
                global.diff_dd = 0;
                global.diff_month = 0;
                global.diff_day = 0;

                sBool = false;                
                sBool = fnDateDiff(sRCalcuEndDate, sRRetrDate, vRtnHBS400T.get(0).get("retr_duty_rule").toString());

                if(!sBool){
                    return "퇴직금 계산작업중 오류가 발생했습니다.[fnDateDiff][006]";
                }

                iRDutyYyyy   = global.diff_yy;
                iRLongMonth  = global.diff_mm;
                iRLongDay    = global.diff_dd;
                iRLongMonths = global.diff_month;
                iRLongDays   = global.diff_day;


                // ==================================================
                //  8. 2013이전 + 2013이후 제외일수가 0 이 아니면 총근속일수에서 뺀다.
                // ==================================================

                //If (dExepDayAf13 + dExepDayBe13) <> 0 Then iRLongDays = iRLongDays - (dExepDayAf13 + dExepDayBe13)
                if(dExepDayAf13 + dExepDayBe13 != 0) {
                    iRLongDays = iRLongDays - (dExepDayAf13 + dExepDayBe13);
                }

                // ==============
                //  9. 최종분-누진월수
                // ==============
                sql.setLength(0);
                sql.append( " SELECT NVL(MAX(ADD_MONTH), 0) ADD_MONTH         " + "\n");
                sql.append( " FROM HRT110T                                    " + "\n");
                sql.append( " WHERE COMP_CODE  = " + "'" + sCompCode + "'     " + "\n");
                sql.append( " AND   OT_KIND    = " + "'" + sRetrOtKind + "'   " + "\n");
                sql.append( " AND   DUTY_YYYY <= " + iRLongMonths + "         " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                if(vRtnHBS400T.get(0).get("add_yn").equals("Y")) {
                    while(rs.next()){
                        iAddMonth = rs.getInt("ADD_MONTH");
                    }
                } else {
                    iAddMonth = 0;
                }

                pstmt.close();
                rs.close();

                iRExepMonthsBe13 = dExepMonthsBe13;                           //최종분-제외월수(2013이전)
                iRExepMonthsAf13 = dExepMonthsAf13;                           //최종분-제외월수(2013이후)
                iRExepMonths = iRExepMonthsBe13 + iRExepMonthsAf13;           //최종분-제외월수
                iRAddMonthsBe13 = 0;                                          //최종분-가산월수(2013이전)
                iRAddMonthsAf13 = 0;                                          //최종분-가산월수(2013이후)                       
                iRAddMonths = iRAddMonthsBe13 + iRAddMonthsAf13;              //최종분-가산월수
                iRLongMonthsCal = iRLongMonths - iRExepMonths + iRAddMonths;  //최종분-최종근속월수 = 근속월수 - 제외월수 + 가산월수

                if(iRLongMonthsCal > 0){
                    if(iRLongMonthsCal % 12 > 0) {
                        iRLongYears = (int)(iRLongMonthsCal / 12) + 1;
                    }else{
                        iRLongYears = (int)(iRLongMonthsCal / 12);
                    }
                }else{
                    iRLongYears = 0;
                }

                // ==================================================
                //  10. 2013이전 + 2013이후 제외월수가 0 이 아니면 총근속월수에서 뺀다. 381
                // ==================================================

                if(iRExepMonths != 0){
                    iRLongMonths = iRLongMonths - iRExepMonths;
                }

                // ======================
                //  11. 정산(합산)-기산일/퇴사일
                // ======================

                if(bMidRetrExist){
                    sSJoinDate = sJoinDate;                                    //정산(합산) 입사일

                    if(sMCalcuEndDate.compareTo(sRCalcuEndDate) <= 0){         //정산(합산) 기산일:중간지급이 있을 경우 중간지급의 기산일,최종분의 기산일 중에서 작은 일자
                        sSCalcuEndDate = sMCalcuEndDate;
                    }else{
                        sSCalcuEndDate = sRCalcuEndDate;
                    }
                    sSRetrDate = sRRetrDate;                                   //정산(합산) 퇴사일:최종분의 퇴사일
                }else{
                    sSJoinDate = sJoinDate;                                    //정산(합산) 입사일
                    sSCalcuEndDate = sRCalcuEndDate;                           //정산(합산) 기산일:중간지급이 없을 경우 최종분의 기산일
                    sSRetrDate = sRRetrDate;                                   //정산(합산) 퇴사일:최종분의 퇴사일
                }

                // ==============================================================
                //  12. 정산(합산)-근속년,근속월,근속일,근속년수,근속월수,근속일수,제외월수,가산월수,중복월수 402
                // ==============================================================
                // 초기화
                global.diff_yy = 0;
                global.diff_mm = 0;
                global.diff_dd = 0;
                global.diff_month = 0;
                global.diff_day = 0;

                sBool = false;                
                sBool = fnDateDiff(sSCalcuEndDate, sSRetrDate, vRtnHBS400T.get(0).get("retr_duty_rule").toString());

                if(!sBool){
                    return "퇴직금 계산작업중 오류가 발생했습니다.[fnDateDiff][007]";
                }

                iSDutyYyyy   = global.diff_yy;
                iSLongMonth  = global.diff_mm;
                iSLongDay    = global.diff_dd;
                iSLongMonths = global.diff_month;
                iSLongDays   = global.diff_day;



                iSExepMonths = iMExepMonths + iRExepMonths;                          //정산(합산)-제외월수
                iSAddMonths = iMAddMonths + iRAddMonths;                             //정산(합산)-가산월수
                iSDupliMonths = iMLongMonths + iRLongMonths - iSLongMonths;          //정산(합산)-중복월수 = 중간지급의 근속월수 + 최종분의 근속월수 - 정산(합산)의 근속월수                        
                iSLongMonthsCal = iSLongMonths - iSExepMonths + iSAddMonths;         //정산(합산)-최종근속월수 = 근속월수 - 제외월수 + 가산월수

                if(iSLongMonthsCal > 0){
                    if(iSLongMonthsCal % 12 > 0) {
                        iSLongYears = (int)(iSLongMonthsCal / 12) + 1;
                    }else{
                        iSLongYears = (int)(iSLongMonthsCal / 12);
                    }
                }else{
                    iSLongYears = 0;
                }


                // ==========================================
                //  13. 안분-기산일,퇴직일,근속월수,제외월수,가산월수,근속년수 422
                // ==========================================


                if(csTAX_BEFORE_DATE.compareTo(sSCalcuEndDate) < 0) {
                    sCalcuEndDateBe13 = "";                  //2013이전 기산일
                    sRetrDateBe13 = "";                      //2013이전 퇴직일                    
                    iLongMonthsBe13 = 0;                     //2013이전 근속월수
                    iExepMonthsBe13 = 0;                     //2013이전 제외월수
                    iAddMonthsBe13 = 0;                      //2013이전 가산월수
                    iLongYearsBe13 = 0;                      //2013이전 근속년수                    
                    sCalcuEndDateAf13 = sSCalcuEndDate;      //2013이후 기산일
                    sRetrDateAf13 = sSRetrDate;              //2013이후 종료일                    
                    iLongMonthsAf13 = iSLongMonths;          //2013이후 근속월수
                    iExepMonthsAf13 = iSExepMonths;          //2013이후 제외월수
                    iAddMonthsAf13 = iSAddMonths;            //2013이후 가산월수
                    iLongYearsAf13 = iSLongYears;            //2013이후 근속년수
                }

                if(csTAX_BEFORE_DATE.compareTo(sSRetrDate) > 0) {
                    sCalcuEndDateBe13 = sSCalcuEndDate;      //2013이전 기산일
                    sRetrDateBe13 = sSRetrDate;              //2013이전 퇴직일                    
                    iLongMonthsBe13 = iSLongMonths;          //2013이전 근속월수
                    iExepMonthsBe13 = iSExepMonths;          //2013이전 제외월수
                    iAddMonthsBe13 = iSAddMonths;            //2013이전 가산월수
                    iLongYearsBe13 = iSLongYears;            //2013이전 근속년수                    
                    sCalcuEndDateAf13 = "";                  //2013이후 기산일
                    sRetrDateAf13 = "";                      //2013이후 종료일                    
                    iLongMonthsAf13 = iSLongMonths;          //2013이후 근속월수
                    iExepMonthsAf13 = iSExepMonths;          //2013이후 제외월수
                    iAddMonthsAf13 = iSAddMonths;            //2013이후 가산월수
                    iLongYearsAf13 = iSLongYears;            //2013이후 근속년수
                }

                if((csTAX_BEFORE_DATE.compareTo(sSCalcuEndDate) >= 0) && (csTAX_BEFORE_DATE.compareTo(sSRetrDate) <= 0)){
                    sCalcuEndDateBe13 = sSCalcuEndDate;      //2013이전 기산일
                    sRetrDateBe13 = csTAX_BEFORE_DATE;       //2013이전 퇴직일

                    SimpleDateFormat fmt = new SimpleDateFormat( "yyyyMMdd" );
                    Date sFrDateTmp = null;
                    Date sToDateTmp = null;

                    sFrDateTmp = fmt.parse( sSCalcuEndDate );
                    sToDateTmp = fmt.parse( csTAX_BEFORE_DATE );

                    //iLongMonthsBe13 = fnGetDateDiff(Calendar.MONTH, sFrDateTmp, sToDateTmp);  //2013이전 근속월수
                    iLongMonthsBe13 = ut.fnSQLDateDiff("MONTH", sFrDateTmp, sToDateTmp);  //2013이전 근속월수

                    if(Integer.parseInt(csTAX_BEFORE_DATE.substring(6, 8)) - Integer.parseInt(sSCalcuEndDate.substring(6, 8)) >= 0){  //2013이전 근속월수
                        iLongMonthsBe13 = iLongMonthsBe13 + 1;
                    }

                    iExepMonthsBe13 = iMExepMonthsBe13 + iRExepMonthsBe13;                     //2013이전 제외월수
                    iAddMonthsBe13 = iMAddMonthsBe13 + iRAddMonthsBe13;                        //2013이전 가산월수

                    iLongMonthsBe13Cal = iLongMonthsBe13 - iExepMonthsBe13 + iAddMonthsBe13;   //2013이전-최종근속월수 = 근속월수 - 제외월수 + 가산월수

                    //2013이전 근속년수
                    if(iLongMonthsBe13Cal % 12 > 0){
                        iLongYearsBe13 = (int)(iLongMonthsBe13Cal / 12) + 1;
                    }else{
                        iLongYearsBe13 = (int)(iLongMonthsBe13Cal / 12);
                    }

                    sCalcuEndDateAf13 = csTAX_REVISE_DATE;                                    //2013이후 기산일
                    sRetrDateAf13 = sSRetrDate;                                               //2013이후 퇴직일

                    // =============================================
                    //  14. 2013년이후 근속월수 = 정산근속월수 - 2013년이전 근속월수 482
                    // ============================================= 

                    iLongMonthsAf13 = iSLongMonths - iLongMonthsBe13;                      
                    iExepMonthsAf13 = iMExepMonthsAf13 + iRExepMonthsAf13;                    //2013이후 제외월수
                    iAddMonthsAf13 = iMAddMonthsAf13 + iRAddMonthsAf13;                       //2013이후 가산월수                    
                    iLongMonthsAf13Cal = iLongMonthsAf13 - iExepMonthsAf13 + iAddMonthsAf13;  //2013이후-최종근속월수 = 근속월수 - 제외월수 + 가산월수                    
                    iLongYearsAf13 = iSLongYears - iLongYearsBe13;                            //2013이후 근속년수 = 정산근속연수 - 2013이전 근속년수

                }

                /* =============================================================================================== */
                //  15. 3개월평균범위에 따라 3개월시작일,3개월종료일,1년시작월,3개월시작월의 근무일수,3개월종료월의 근무일수,3개월시작월의 월일수,3개월종료월의 월일수 503
                /* =============================================================================================== */  

                SimpleDateFormat fmrt = new SimpleDateFormat( "yyyyMMdd" );
                Date sDateFr = null;
                Date sDateTo = null;

                sDateFr = fmrt.parse( sRCalcuEndDate );  // 최종분 기산일
                sDateTo = fmrt.parse( sRetrDate );       // 최종분 퇴사일 sSRetrDate -> sRetrDate변경

                Date dCalcuDateFr = null;
                Date dCalcuDateTo = null;
                Date dToMonEndDay = null;

                String sCalcuDateFr = "";
                String sCalcuDateTo = "";
                String sCalcuYearFr = "";
                String sToMonEndDay = "";

                double lFrMonWorkDays = 0.0;
                int lFrMonthDays = 0;
                double lToMonWorkDays = 0.0;
                int lToMonthDays = 0;
                double lToRetrWorkDays = 0.0;

                switch(vRtnHBS400T.get(0).get("amt_range").toString()){
                case "D" :
                    // =============
                    //  3개월종료일
                    // =============
                    dCalcuDateTo = ut.fnGetDateAdd( Calendar.DATE, sDateTo, 0);

                    Calendar cal = Calendar.getInstance();                    
                    cal.setTime(dCalcuDateTo);

                    // =============
                    //  해당셋팅월의 마지막일 
                    // =============
                    int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                    
                    String StrEndDay = "0" + String.valueOf(endDay);

                    //System.out.print(fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay);

                    // =============
                    //  3개월종료월의 말일
                    // =============
                    dToMonEndDay = fmrt.parse( fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()) );

                    // =============
                    //  3개월시작일
                    // =============
                    if(ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, 0).compareTo(dCalcuDateTo) == 0){
                        Date TmpDate = null;
                        TmpDate = ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, -2);                                
                        cal.setTime(TmpDate);

                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                        StrEndDay = "0" + String.valueOf(endDay);

                        dCalcuDateFr = fmrt.parse( fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()) );
                    }else{
                        dCalcuDateFr = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dCalcuDateTo, -3), 1);
                    }

                    // =============
                    //  1년시작월
                    // =============
                    Date dCalcuYearFr = null;

                    if(ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, 1), -1).compareTo(dCalcuDateTo) == 0){
                        dCalcuYearFr = ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, -11);
                    }else{
                        Date TmpDate = null;
                        TmpDate = ut.fnGetDateAdd( Calendar.MONTH, dCalcuDateTo, -11);                                
                        cal.setTime(TmpDate);

                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                    
                        StrEndDay = "0" + String.valueOf(endDay);

                        dCalcuYearFr = fmrt.parse( fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()) );
                    }


                    sCalcuDateFr = fmrt.format(dCalcuDateFr);
                    sCalcuDateTo = fmrt.format(dCalcuDateTo);
                    sCalcuYearFr = fmrt.format(dCalcuYearFr);
                    sToMonEndDay = fmrt.format(dToMonEndDay);

                    // ================
                    //  3개월시작월의 근무일수
                    // ================
                    //lFrMonWorkDays = Format(CDbl(DateDiff("d", dCalcuDateFr, DateAdd("d", -1, Year(DateAdd("m", 1, dCalcuDateFr)) & "-" & Month(DateAdd("m", 1, dCalcuDateFr)) & "-" & "01")) + 1), "##.0")
                    Date TmpDate = null;  

                    cal.setTime(dCalcuDateFr);

                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                    
                    StrEndDay = "0" + String.valueOf(endDay);

                    TmpDate = fmrt.parse( fmrt.format(dCalcuDateFr).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()) );



                    //lFrMonWorkDays = fnGetDateDiff(Calendar.DATE, dCalcuDateFr, TmpDate) + 1;
                    lFrMonWorkDays = ut.fnSQLDateDiff("DATE", dCalcuDateFr, TmpDate) + 1;

                    // ================
                    //  3개월종료월의 근무일 539
                    // ================

                    if(sRetrType.equals("M")){
                        lToMonWorkDays = Integer.parseInt(sCalcuDateTo.substring(6,  8));    // 정산끝달의 근무일수
                    }else{
                        lToMonWorkDays = Integer.parseInt(sToMonEndDay.substring(6,  8));    // 정산끝달의 달력일수
                    }

                    // ================
                    //  퇴직월일수 546
                    // ================

                    lToRetrWorkDays = Integer.parseInt(sCalcuDateTo.substring(6,  8));

                    // ================
                    //  3개월 시작월의 월일수
                    // ================    
                    TmpDate = null;                      
                    cal.setTime(dCalcuDateFr);                    
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                    


                    lFrMonthDays = endDay;

                    // ================
                    //  3개월 종료월의 월일수
                    // ================
                    TmpDate = null;
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                    

                    lToMonthDays = endDay;

                    break;
                    //전월기준
                case "B" :      
                    // ================
                    //  3개월종료월의 말일
                    // ================
                    //dToMonEndDay = Year(DateAdd("m", -1, sDateTo)) & "-" & Right("0" & Month(DateAdd("m", -1, sDateTo)), 2)
                    dToMonEndDay = ut.fnGetDateAdd( Calendar.MONTH, sDateTo, -1);

                    cal = Calendar.getInstance();

                    TmpDate = null;
                    cal.setTime(dToMonEndDay);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                                        
                    StrEndDay = "0" + String.valueOf(endDay);

                    sToMonEndDay = fmrt.format(dToMonEndDay).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    dToMonEndDay = fmrt.parse(sToMonEndDay);

                    // ================
                    //  3개월종료일
                    // ================
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                                        
                    StrEndDay = "0" + String.valueOf(endDay);

                    sCalcuDateTo = fmrt.format(dToMonEndDay).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    dCalcuDateTo = fmrt.parse(sCalcuDateTo);

                    // ================
                    //  3개월시작일
                    // ================

                    TmpDate = ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, -2);

                    cal.setTime(TmpDate);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);                                        
                    StrEndDay = "0" + String.valueOf(endDay);

                    sCalcuDateFr = fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    dCalcuDateFr = fmrt.parse(sCalcuDateFr);

                    // ================
                    //  1년시작월   568
                    // ================
                    if(ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, 1), -1).compareTo(dCalcuDateTo) == 0){
                        TmpDate = ut.fnGetDateAdd( Calendar.MONTH, dToMonEndDay, -11);
                        cal.setTime(TmpDate);
                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                        StrEndDay = "0" + String.valueOf(endDay);

                        sCalcuYearFr = fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                        dCalcuYearFr = fmrt.parse(sCalcuYearFr);
                    }else{
                        TmpDate = ut.fnGetDateAdd( Calendar.MONTH, dCalcuDateTo, -11);
                        cal.setTime(TmpDate);
                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                        StrEndDay = "0" + String.valueOf(endDay);

                        sCalcuYearFr = fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                        dCalcuYearFr = fmrt.parse(sCalcuYearFr);
                    }

                    // ==================
                    //  3개월시작월의 근무일수 580
                    // ==================
                    cal.setTime(dCalcuDateFr);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);
                    TmpDate = fmrt.parse(fmrt.format(dCalcuDateFr).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()));

                    lFrMonWorkDays = ut.fnSQLDateDiff("DATE", dCalcuDateFr, TmpDate) + 1;

                    // ==================
                    //  3개월종료월의 근무일수
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);
                    TmpDate = fmrt.parse(fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()));

                    lToMonWorkDays = ut.fnSQLDateDiff("DATE", TmpDate, ut.fnGetDateAdd(Calendar.DATE, dCalcuDateTo, 1));


                    // ==================
                    //  퇴직월일수
                    // ==================
                    lToRetrWorkDays = lToMonWorkDays;

                    // ==================
                    //  3개월시작월의 월일수 590
                    // ==================
                    cal.setTime(dCalcuDateFr);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                    lFrMonthDays = endDay;

                    // ==================
                    //  3개월종료월의 월일수
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                    lToMonthDays = endDay;

                    break;
                    //마감기준(월)
                case "M" :
                    cal = Calendar.getInstance();

                    dCalcuDateTo = ut.fnGetDateAdd(Calendar.DATE, sDateTo, 0);
                    String sTmpDate = "";
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);

                    sTmpDate = fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    dToMonEndDay = fmrt.parse(sTmpDate);

                    sql.setLength(0);
                    sql.append( " SELECT A.REF_CODE1                                      " + "\n");
                    sql.append( " FROM       BSA100T A                                    " + "\n");
                    sql.append( " INNER JOIN HUM100T B ON B.COMP_CODE     = A.COMP_CODE   " + "\n");
                    sql.append( "                     AND B.PAY_PROV_FLAG = A.SUB_CODE    " + "\n");
                    sql.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'          " + "\n");
                    sql.append( " AND   A.MAIN_CODE   = 'H031'                            " + "\n");
                    sql.append( " AND   B.PERSON_NUMB = " + "'" + sPersonNumb + "'        " + "\n");

                    pstmt = conn.prepareStatement(sql.toString());
                    rs = pstmt.executeQuery();

                    String sRefCode1 = "";

                    while(rs.next()){
                        sRefCode1 = rs.getString("REF_CODE1");
                    }

                    pstmt.close();
                    rs.close();

                    int dCloseDate = 0;

                    if(sRefCode1.equals("00")){
                        cal.setTime(dToMonEndDay);
                        endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                        dCloseDate = endDay;
                    }else{
                        dCloseDate = Integer.parseInt(sRefCode1);
                    }

                    cal.setTime(dCalcuDateTo);
                    int CurDay = cal.get(Calendar.DAY_OF_MONTH);    //day만 가져오기

                    if(dCloseDate <= CurDay){
                        dCalcuDateFr = ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, -2);
                        dCalcuDateTo = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, 1), -1);
                    }else{
                        dCalcuDateFr = ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, -3);
                        dCalcuDateTo = ut.fnGetDateAdd(Calendar.DATE, dToMonEndDay, -1);
                    }

                    // ==================
                    //  1년시작월 631
                    // ==================

                    TmpDate = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, 1), -1);

                    if(TmpDate.compareTo(dCalcuDateTo) == 0){
                        dCalcuYearFr = ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, -11);
                    }else{
                        TmpDate = null;
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -11);
                        cal.setTime(TmpDate);
                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                        StrEndDay = "0" + String.valueOf(endDay);                        
                        sTmpDate = fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());

                        dCalcuYearFr = fmrt.parse(sTmpDate);
                    }

                    sCalcuDateFr = fmrt.format(dCalcuDateFr);
                    sCalcuDateTo = fmrt.format(dCalcuDateTo);
                    sCalcuYearFr = fmrt.format(dCalcuYearFr);
                    sToMonEndDay = fmrt.format(dToMonEndDay);

                    // ==================
                    //  3개월시작월의 근무일수 643
                    // ==================
                    cal.setTime(dCalcuDateFr);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);
                    TmpDate = fmrt.parse(fmrt.format(dCalcuDateFr).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()));

                    lFrMonWorkDays = ut.fnSQLDateDiff("DATE", dCalcuDateFr, TmpDate) + 1;

                    // ==================
                    //  3개월종료월의 근무일수
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);
                    TmpDate = fmrt.parse(fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()));

                    lToMonWorkDays = ut.fnSQLDateDiff("DATE", TmpDate, ut.fnGetDateAdd(Calendar.DATE, dCalcuDateTo, 1));
                    lToRetrWorkDays = lToMonWorkDays;

                    // ==================
                    //  3개월시작월의 월일수
                    // ==================
                    cal.setTime(dCalcuDateFr);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                    lFrMonthDays = endDay;

                    // ==================
                    //  3개월종료월의 월일수
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                    lToMonthDays = endDay;

                    // ==================
                    //  총근속개월수 조정
                    // ==================
                    if(Integer.parseInt(sRCalcuEndDate.substring(6, 8)) < Integer.parseInt(sRefCode1)){
                        int lDateTerm = Integer.parseInt(sRefCode1) - Integer.parseInt(sRCalcuEndDate.substring(6, 8));

                        if(lDateTerm > 0 && Integer.parseInt(vRtnHBS400T.get(0).get("retr_duty_rule").toString()) <= lDateTerm) {
                            iRLongMonths++;
                        }                        
                    }
                    break;
                    //마감기준(일)
                case "N" :
                    // ==================
                    //  3개월종료월의 말일
                    // ==================
                    cal = Calendar.getInstance();

                    dCalcuDateTo = ut.fnGetDateAdd(Calendar.DATE, sDateTo, 0);

                    sTmpDate = "";
                    cal.setTime(dCalcuDateTo);
                    endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                    StrEndDay = "0" + String.valueOf(endDay);

                    sTmpDate = fmrt.format(dCalcuDateTo).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length());
                    dToMonEndDay = fmrt.parse(sTmpDate);

                    pstmt.close();
                    rs.close();

                    sql.setLength(0);
                    sql.append( " SELECT A.REF_CODE1                                      " + "\n");
                    sql.append( " FROM       BSA100T A                                    " + "\n");
                    sql.append( " INNER JOIN HUM100T B ON B.COMP_CODE     = A.COMP_CODE   " + "\n");
                    sql.append( "                     AND B.PAY_PROV_FLAG = A.SUB_CODE    " + "\n");
                    sql.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'          " + "\n");
                    sql.append( " AND   A.MAIN_CODE   = 'H031'                            " + "\n");
                    sql.append( " AND   B.PERSON_NUMB = " + "'" + sPersonNumb + "'        " + "\n");

                    pstmt = conn.prepareStatement(sql.toString());
                    rs = pstmt.executeQuery();

                    sRefCode1 = "";

                    while(rs.next()){
                        sRefCode1 = rs.getString("REF_CODE1");
                    }

                    pstmt.close();
                    rs.close();

                    dCloseDate = 0;

                    if(sRefCode1.equals("00")){
                        cal.setTime(dToMonEndDay);
                        endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);  

                        dCloseDate = endDay;
                    }else{
                        dCloseDate = Integer.parseInt(sRefCode1);
                    }

                    cal.setTime(dCalcuDateTo);
                    CurDay = cal.get(Calendar.DAY_OF_MONTH);    //day만 가져오기

                    if(dCloseDate > CurDay){
                        dCalcuDateFr = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -3), 1);
                        dCalcuDateTo = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, 0);
                    }else{
                        dCalcuDateFr = ut.fnGetDateAdd(Calendar.DATE, ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -2), 1);

                        if(dCloseDate != CurDay){
                            dCalcuDateTo = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, 1);
                        }else{
                            dCalcuDateTo = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, 0);
                        }

                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dToMonEndDay, 1);
                        cal.setTime(TmpDate);
                        endDay = cal.getActualMinimum(Calendar.DAY_OF_MONTH);  
                        StrEndDay = "0" + String.valueOf(endDay);
                        dToMonEndDay = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + StrEndDay.substring(StrEndDay.length()-2, StrEndDay.length()));
                    }

                    // ==================
                    //  1년시작월  707
                    // ==================                    
                    dCalcuYearFr = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -11);

                    sCalcuDateFr = fmrt.format(dCalcuDateFr);
                    sCalcuDateTo = fmrt.format(dCalcuDateTo);
                    sCalcuYearFr = fmrt.format(dCalcuYearFr);
                    sToMonEndDay = fmrt.format(dToMonEndDay);

                    // ==================
                    //  3개월시작월의 근무일수 715
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    CurDay = cal.get(Calendar.DAY_OF_MONTH);    //day만 가져오기

                    if(CurDay < dCloseDate){
                        TmpDate = fmrt.parse(fmrt.format(dCalcuDateFr).substring(0,  6) + dCloseDate);                        
                        lFrMonWorkDays = ut.fnSQLDateDiff("DATE", dCalcuDateFr, TmpDate) + 1;
                    }else if(CurDay > dCloseDate) {
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, 1);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);                        
                        lFrMonWorkDays = ut.fnSQLDateDiff("DATE", dCalcuDateFr, TmpDate) + 1;
                    }else {
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, -1);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);                        
                        lFrMonWorkDays = ut.fnSQLDateDiff("DATE", TmpDate, dCalcuDateFr);
                    }

                    // ==================
                    //  3개월종료월의 근무일수 724
                    // ==================
                    if(sRetrType.equals("M")){
                        //정산일이 마감일보다 작거나 같을 때 (전월마감일 ~ 정산일)
                        //정산일이 마감일보다 클 때          (당월마감일 ~ 정산일)

                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -1);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);                        
                        lToMonWorkDays = ut.fnSQLDateDiff("DATE", TmpDate, sDateTo);

                    }else{
                        //퇴직정산 일 경우 퇴사월의 급여를 일할계산 하지 않음.
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -1);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);

                        Date TmpDate2 = fmrt.parse(fmrt.format(dCalcuDateTo).substring(0,  6) + dCloseDate);  

                        lToMonWorkDays = ut.fnSQLDateDiff("DATE", TmpDate, TmpDate2);
                    }

                    lToRetrWorkDays = lToMonWorkDays;

                    // ==================
                    //  3개월시작월의 월일수 736
                    // ==================
                    cal.setTime(dCalcuDateTo);
                    CurDay = cal.get(Calendar.DAY_OF_MONTH);    //day만 가져오기

                    if(CurDay < dCloseDate) {
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, -1);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);

                        Date TmpDate2 = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, 0);
                        TmpDate2 = fmrt.parse(fmrt.format(TmpDate2).substring(0,  6) + dCloseDate);

                        lFrMonthDays = ut.fnSQLDateDiff("DATE", TmpDate, TmpDate2);
                    }else{
                        TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, 0);
                        TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);

                        Date TmpDate2 = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateFr, 1);
                        TmpDate2 = fmrt.parse(fmrt.format(TmpDate2).substring(0,  6) + dCloseDate);

                        lFrMonthDays = ut.fnSQLDateDiff("DATE", TmpDate, TmpDate2);
                    }

                    // ==================
                    //  3개월종료월의 월일수
                    // ==================
                    TmpDate = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, -1);
                    TmpDate = fmrt.parse(fmrt.format(TmpDate).substring(0,  6) + dCloseDate);

                    Date TmpDate2 = ut.fnGetDateAdd(Calendar.MONTH, dCalcuDateTo, 0);
                    TmpDate2 = fmrt.parse(fmrt.format(TmpDate2).substring(0,  6) + dCloseDate);

                    lToMonthDays = ut.fnSQLDateDiff("DATE", TmpDate, TmpDate2);

                    break;
                default :
                    dCalcuDateTo = null;
                    break;
                }  // End Of switch

                // ==================
                //  퇴직금계산 747
                // ==================

                sql.setLength(0);
                sql.append( " SELECT *                                        " + "\n");
                sql.append( " FROM  HRT000T                                   " + "\n");
                sql.append( " WHERE COMP_CODE   = " + "'" + sCompCode + "'    " + "\n");
                sql.append( " AND   SUPP_TYPE   = 'R'                         " + "\n");
                sql.append( " AND   OT_KIND_01  = " + "'" + sRetrOtKind + "'  " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                String sCalcuState = "";

                ResultSet rsInfo = null;

                while(rs.next()){

                    switch(rs.getString("TYPE")){
                    case "2" :    
                        /* ================================================
                         001 3개월평균임금
                         007 3개월급여총액           008 3개월평균상여총액    009 3개월평균년월차총액
                         003  평균임금계산방식        005  근속기간계산방식
                         006  퇴직기준금                 011  누진개월(율)    013  임원누진개월(율)
                         021  매월지급된퇴직금내역  023  연봉
                         031  총근속일수                 032  총근속월수                033  총근속년수
                         034  근속년수                    035  근속월수                   036  근속일수
                        =================================================== */
                        switch(rs.getString("UNIQUE_CODE")){
                        // 3개월평균임금
                        case "001" :
                            break;
                            // 3개월급여총액
                        case "007" :
                            // [ 여기까지 작업하다가 퇴직금계산 SP변환으로 작업중단 ]
                            rsInfo = fnGetPayAmt(conn, "SUM", sCompCode, sRetrDate, sRetrType, sPersonNumb, sCalcuDateFr, sCalcuDateTo, lFrMonWorkDays, lFrMonthDays, lToMonWorkDays, lToMonthDays, lToRetrWorkDays);
                            break;
                            //3개월평균상여총액    
                        case "008" :
                            break;

                            //3개월평균년월차총액    
                        case "009" :
                            break;

                            //평균임금계산방식- D:일평균임금/M:월평균임금
                        case "003" :
                            break;

                            //근속기간계산방식- D:근속일수/M:근속월수/T:년월일
                        case "005" :
                            break;

                            //누진개월(율)
                        case "011" :
                            break;    

                            //임원누진개월(율)    
                        case "013" :
                            break;    

                            //매월지급된퇴직금내역    
                        case "021" :
                            break;    

                            //연봉
                        case "023" :
                            break;    

                            //총근속일수
                        case "031" :
                            break;    

                            //총근속년수
                        case "032" :
                            break;    

                            //총근속년수
                        case "033" :
                            break;    

                        default :
                            break;
                        } // End of switch

                        break;
                    default :
                        sCalcuState = sCalcuState + "" + rs.getString("SELECT_VALUE");
                        break;

                    } // End of switch

                } // End of while



                System.out.println(1);

            } // End Of 퇴직금계산






            //---------------------------------------------------------------------------------------------------------
            conn.setAutoCommit(true);
            return sRtn;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return e.getMessage();   

        }
    }
    //
    private static ResultSet fnGetPayAmt(  Connection conn
            , String sOption
            , String sCompCode
            , String sRetrDate
            , String sRetrType
            , String sPersonNumb
            , String sCalcuDateFr
            , String sCalcuDateTo
            , double lFrMonWorkDays
            , int lFrMonthDays
            , double lToMonWorkDays
            , int lToMonthDays
            , double lToRetrWorkDays
            ) throws SQLException{

        ResultSet vRtn = null;
        StringBuffer sqlData = new StringBuffer();
        StringBuffer sql = new StringBuffer();
        String strArray = "";

        //sqlData.setLength(0);
        sqlData.append( " SELECT A.COMP_CODE" + "\n");
        sqlData.append( "      , " + "'" + sRetrDate + "'                                             AS RETR_DATE       " + "\n");
        sqlData.append( "      , " + "'" + sRetrType + "'                                             AS RETR_TYPE       " + "\n");
        sqlData.append( "      , A.PERSON_NUMB                                                        AS PERSON_NUMB     " + "\n");
        sqlData.append( "      , A.PAY_YYYYMM                                                         AS PAY_YYYYMM      " + "\n");
        sqlData.append( "      , " + "'" + sCalcuDateFr + "'                                          AS PAY_STRT_DATE   " + "\n");
        sqlData.append( "      , TO_CHAR(TO_DATE(ADDDATE(ADDDATE(A.PAY_YYYYMM + '01', INTERVAL 1 MONTH), INTERVAL -1 DAY)), 'YYYYMMDD') AS PAY_LAST_DATE   " + "\n");
        sqlData.append( "      , " + lFrMonWorkDays + "                                               AS WAGES_DAY       " + "\n");
        sqlData.append( "      , A.WAGES_CODE                                                         AS WAGES_CODE      " + "\n");
        sqlData.append( "      , NVL(A.AMOUNT_I, 0) * (" + lFrMonWorkDays + " / " + lFrMonthDays + ") AS AMOUNT_I        " + "\n");
        sqlData.append( "      , A.INSERT_DB_USER                                                     AS INSERT_DB_USER  " + "\n");
        sqlData.append( "      , A.INSERT_DB_TIME                                                     AS INSERT_DB_TIME  " + "\n");
        sqlData.append( "      , A.UPDATE_DB_USER                                                     AS UPDATE_DB_USER  " + "\n");
        sqlData.append( "      , A.UPDATE_DB_TIME                                                     AS UPDATE_DB_TIME  " + "\n");
        sqlData.append( " FROM       HPA300T A                                                                           " + "\n");
        sqlData.append( " INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND B.WAGES_CODE = A.WAGES_CODE                                            " + "\n");
        sqlData.append( " LEFT  JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND C.MAIN_CODE  = 'H032'                                                  " + "\n");
        sqlData.append( "                     AND C.SUB_CODE   = A.SUPP_TYPE                                             " + "\n");
        sqlData.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'                                                 " + "\n");
        sqlData.append( " AND   A.PERSON_NUMB = " + "'" + sPersonNumb + "'                                               " + "\n");
        sqlData.append( " AND   A.PAY_YYYYMM  = LEFT(" + "'" + sCalcuDateFr + "',6)                                      " + "\n");
        sqlData.append( " AND  (A.SUPP_TYPE   = '1' OR C.REF_CODE1 = '1')                                                " + "\n");
        sqlData.append( " AND   B.RETR_WAGES  = 'Y'                                                                      " + "\n");
        sqlData.append( " AND   B.RETR_BONUS  = 'N'                                                                      " + "\n");
        sqlData.append( "                                                                                                " + "\n");
        sqlData.append( " UNION ALL                                                                                      " + "\n");
        sqlData.append( "                                                                                                " + "\n");
        sqlData.append( " SELECT A.COMP_CODE                                                                             " + "\n");
        sqlData.append( "      , " + "'" + sRetrDate + "'              AS RETR_DATE                                      " + "\n");
        sqlData.append( "      , " + "'" + sRetrType + "'              AS RETR_TYPE                                      " + "\n");
        sqlData.append( "      , A.PERSON_NUMB                         AS PERSON_NUMB                                    " + "\n");
        sqlData.append( "      , A.PAY_YYYYMM                          AS PAY_YYYYMM                                     " + "\n");
        sqlData.append( "      , A.PAY_YYYYMM + '01'                   AS PAY_STRT_DATE                                  " + "\n");
        sqlData.append( "      , TO_CHAR(TO_DATE(ADDDATE(ADDDATE(A.PAY_YYYYMM + '01', INTERVAL 1 MONTH), INTERVAL -1 DAY)), 'YYYYMMDD') AS PAY_LAST_DATE   " + "\n");
        sqlData.append( "      , TO_NUMBER(RIGHT(TO_CHAR(TO_DATE(ADDDATE(ADDDATE(A.PAY_YYYYMM + '01', INTERVAL 1 MONTH), INTERVAL -1 DAY)), 'YYYYMMDD'), 2)) AS WAGES_DAY" + "\n");
        sqlData.append( "      , A.WAGES_CODE                          AS WAGES_CODE                                     " + "\n");
        sqlData.append( "      , NVL(A.AMOUNT_I, 0)                    AS AMOUNT_I                                       " + "\n");
        sqlData.append( "      , A.INSERT_DB_USER                      AS INSERT_DB_USER                                 " + "\n");
        sqlData.append( "      , A.INSERT_DB_TIME                      AS INSERT_DB_TIME                                 " + "\n");
        sqlData.append( "      , A.UPDATE_DB_USER                      AS UPDATE_DB_USER                                 " + "\n");
        sqlData.append( "      , A.UPDATE_DB_TIME                      AS UPDATE_DB_TIME                                 " + "\n");
        sqlData.append( " FROM       HPA300T A                                                                           " + "\n");
        sqlData.append( " INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND B.WAGES_CODE = A.WAGES_CODE                                            " + "\n");
        sqlData.append( " LEFT  JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND C.MAIN_CODE  = 'H032'                                                  " + "\n");
        sqlData.append( "                     AND C.SUB_CODE   = A.SUPP_TYPE                                             " + "\n");
        sqlData.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'                                                 " + "\n");
        sqlData.append( " AND A.PERSON_NUMB   = " + "'" + sPersonNumb + "'                                               " + "\n");
        sqlData.append( " AND A.PAY_YYYYMM    > LEFT(" + "'" + sCalcuDateFr + "',6)                                      " + "\n");
        sqlData.append( " AND A.PAY_YYYYMM    < LEFT(" + "'" + sCalcuDateTo + "',6)                                      " + "\n");
        sqlData.append( " AND (A.SUPP_TYPE    = '1' OR C.REF_CODE1 = '1')                                                " + "\n");
        sqlData.append( " AND B.RETR_WAGES    = 'Y'                                                                      " + "\n");
        sqlData.append( " AND B.RETR_BONUS    = 'N'                                                                      " + "\n");
        sqlData.append( "                                                                                                " + "\n");
        sqlData.append( " UNION ALL                                                                                      " + "\n");
        sqlData.append( "                                                                                                " + "\n");
        sqlData.append( " SELECT A.COMP_CODE                                                                             " + "\n");
        sqlData.append( "      , " + "'" + sRetrDate + "'              AS RETR_DATE                                      " + "\n");
        sqlData.append( "      , " + "'" + sRetrType + "'              AS RETR_TYPE                                      " + "\n");
        sqlData.append( "      , A.PERSON_NUMB                         AS PERSON_NUMB                                    " + "\n");
        sqlData.append( "      , A.PAY_YYYYMM                          AS PAY_YYYYMM                                     " + "\n");
        sqlData.append( "      , A.PAY_YYYYMM + '01'                   AS PAY_STRT_DATE                                  " + "\n");
        sqlData.append( "      , " + "'" + sCalcuDateTo + "'           AS PAY_STRT_DATE                                  " + "\n");
        sqlData.append( "      , " + lToRetrWorkDays + "               AS WAGES_DAY                                      " + "\n");
        sqlData.append( "      , A.WAGES_CODE                          AS WAGES_CODE                                     " + "\n");
        sqlData.append( "      , NVL(A.AMOUNT_I, 0) * (" + lToMonWorkDays + " / " + lToMonthDays + ") AS AMOUNT_I        " + "\n");
        sqlData.append( "      , A.INSERT_DB_USER                                                     AS INSERT_DB_USER  " + "\n");
        sqlData.append( "      , A.INSERT_DB_TIME                                                     AS INSERT_DB_TIME  " + "\n");
        sqlData.append( "      , A.UPDATE_DB_USER                                                     AS UPDATE_DB_USER  " + "\n");
        sqlData.append( "      , A.UPDATE_DB_TIME                                                     AS UPDATE_DB_TIME  " + "\n");
        sqlData.append( " FROM       HPA300T A                                                                           " + "\n");
        sqlData.append( " INNER JOIN HBS300T B ON B.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND B.WAGES_CODE = A.WAGES_CODE                                            " + "\n");
        sqlData.append( " LEFT  JOIN BSA100T C ON C.COMP_CODE  = A.COMP_CODE                                             " + "\n");
        sqlData.append( "                     AND C.MAIN_CODE  = 'H032'                                                  " + "\n");
        sqlData.append( "                     AND C.SUB_CODE   = A.SUPP_TYPE                                             " + "\n");
        sqlData.append( " WHERE A.COMP_CODE   = " + "'" + sCompCode + "'                                                 " + "\n");
        sqlData.append( " AND A.PERSON_NUMB   = " + "'" + sPersonNumb + "'                                               " + "\n");
        sqlData.append( " AND A.PAY_YYYYMM    = LEFT(" + "'" + sCalcuDateTo + "',6)                                      " + "\n");
        sqlData.append( " AND (A.SUPP_TYPE    = '1' OR C.REF_CODE1 = '1')                                                " + "\n");
        sqlData.append( " AND B.RETR_WAGES    = 'Y'                                                                      " + "\n");
        sqlData.append( " AND B.RETR_BONUS    = 'N'                                                                      " + "\n");

        if(sOption.equals("SUM")){
            sql.setLength(0);
            sql.append("SELECT NVL(SUM(AMOUNT_I),0) AS PAY_AMT                                           " + "\n");
            sql.append("FROM  (                                                                             " + "\n");
            sql.append( sqlData.toString());
            sql.append("      ) A                                                                             " + "\n");
        }else{

        }

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            vRtn = pstmt.executeQuery();

            //pstmt.close();

        } catch (SQLException e) {
            throw e;
        }


        return vRtn;
    }

    public static class global{        
        public static int diff_yy    = 0;
        public static int diff_mm   = 0;
        public static int diff_dd     = 0;
        public static int diff_month  = 0;
        public static int diff_day    = 0;        
    }

    @SuppressWarnings("static-access")
    private static boolean fnDateDiff(String spStrtDt, String spEndDt, String spRule) throws Exception{

        try
        {
            UtilFunction ut = new UtilFunction();

            SimpleDateFormat format = new SimpleDateFormat( "yyyyMMdd" );
            Date dStrtDt = null;
            Date dEndDt = null;
            Date dStrtDt2 = null;
            Date dEndDt2 = null;
            Date calcuEndDt = null;

            int diffDays  = 0;
            int diff_year = 0;

            HumanProcedure h = new HumanProcedure();            

            //        global g = new global();
            //        g.diff_day = 0;

            global.diff_yy    = 0;
            global.diff_mm    = 0;
            global.diff_dd    = 0;
            global.diff_month = 0;
            global.diff_day   = 0;

            //시작일이 종료일보다 크면 종료
            dStrtDt = format.parse( spStrtDt );
            dEndDt  = format.parse( spEndDt );

            dStrtDt2 = format.parse( spStrtDt.substring(0, 6) + "01" );
            dEndDt2 = format.parse( spEndDt.substring(0, 6) + "01" );


            if (dStrtDt.compareTo(dEndDt) > 0)
            {
                return false;
            }

            //총근속일수(LONG_TOT_DAY)
            //global.diff_day = fnGetDateDiff(Calendar.DATE, dStrtDt, dEndDt) + 1;
            global.diff_day = ut.fnSQLDateDiff("DATE", dStrtDt, dEndDt) + 1;

            //근속년(DUTY_YYYY)
            //diff_year = fnGetDateDiff(Calendar.YEAR, dStrtDt, dEndDt) + 1;
            diff_year = ut.fnSQLDateDiff("YEAR", dStrtDt, dEndDt) + 1;

            calcuEndDt = null;
            diffDays = 0;

            calcuEndDt = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.YEAR, dStrtDt, diff_year), -1);
            //diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, dEndDt);
            diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, dEndDt);

            while(diffDays < 0) {
                diff_year = diff_year - 1;

                calcuEndDt = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.YEAR, dStrtDt, diff_year), -1);
                //diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, dEndDt);
                diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, dEndDt);
            }

            //근속월(LONG_MONTH*), 근속일(LONG_DAY) 계산
            calcuEndDt = null;
            diffDays = 0;

            //global.diff_mm = fnGetDateDiff(Calendar.MONTH, dStrtDt, dEndDt) + 1;
            global.diff_mm = ut.fnSQLDateDiff("MONTH", dStrtDt, dEndDt) + 1;

            //            calcuEndDt = DateAdd("d", -1, DateAdd("m", diff_mm, dStrtDt))
            //            diffDays = DateDiff("d", calcuEndDt, dEndDt)
            calcuEndDt = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dStrtDt, global.diff_mm), -1);
            //diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, dEndDt);
            diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, dEndDt);

            while(diffDays < 0) {
                global.diff_mm = global.diff_mm - 1;

                calcuEndDt = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dStrtDt, global.diff_mm), -1);
                //diffDays = fnGetDateDiff(Calendar.DATE, calcuEndDt, dEndDt);
                diffDays = ut.fnSQLDateDiff("DATE", calcuEndDt, dEndDt);
            }

            global.diff_dd = diffDays;

            // 총근속개월수(LONG_TOT_MONTH)
            //dEndDt2 = DateAdd("d", -1, DateAdd("m", 1, dEndDt2))
            dEndDt2 = ut.fnGetDateAdd( Calendar.DATE, ut.fnGetDateAdd( Calendar.MONTH, dEndDt2, 1), -1);

            String result = format.format(dEndDt2).substring(6, 8);            
            //System.out.println(result);

            if (spRule.equals("0")) {
                spRule = result;
            }


            //            System.out.println("1900" + format.format(dEndDt).substring(4, 8));
            //            System.out.println("1900" + format.format(dStrtDt).substring(4, 8));

            Date tmpEndDt = null;
            Date tmpStrtDt = null;

            // 비베 에서는 월일만 가지고 d a t e d i f f 가 계산되나, java에서는 y y y y m m d d 형식이 아니면 계산이 불가능하여 1900 을 붙여 계산함
            tmpEndDt = format.parse( "1900" + format.format(dEndDt).substring(4, 8) );
            tmpStrtDt = format.parse( "1900" + format.format(dStrtDt).substring(4, 8) );

            //            tmpEndDt = format.parse("19000609");
            //            tmpStrtDt = format.parse("19000101");

            //            System.out.println(tmpEndDt);
            //            System.out.println(tmpStrtDt);

            int diffCal = 0;
            //diffCal = fnGetDateDiff(Calendar.DATE, tmpEndDt, tmpStrtDt);
            diffCal = ut.fnSQLDateDiff("DATE", tmpEndDt, tmpStrtDt);

            //System.out.println(diffCal);

            //근속년수 구하기
            if(Integer.parseInt(spEndDt.substring(4,8)) >= Integer.parseInt(spStrtDt.substring(4,8))) {
                global.diff_yy = Integer.parseInt(spEndDt.substring(0,4)) - Integer.parseInt(spStrtDt.substring(0,4));
            }else{
                //윤달이 있으면서 딱1년이 될 경우
                if(diffCal == 1){
                    //if(fnGetDateDiff(Calendar.DATE, dStrtDt, dEndDt) + 1 >= 365) {
                    if(ut.fnSQLDateDiff("DATE", dStrtDt, dEndDt) + 1 >= 365) {
                        global.diff_yy = Integer.parseInt(spEndDt.substring(0,4)) - Integer.parseInt(spStrtDt.substring(0,4));
                    } else {
                        global.diff_yy = Integer.parseInt(spEndDt.substring(0,4)) - Integer.parseInt(spStrtDt.substring(0,4)) - 1;
                    }                    
                }else{
                    global.diff_yy = Integer.parseInt(spEndDt.substring(0,4)) - Integer.parseInt(spStrtDt.substring(0,4)) - 1;
                }
            }

            // 근속월수 구하기
            if(global.diff_dd >= Integer.parseInt(spRule)) {
                global.diff_month = global.diff_mm + 1;
            }else{
                global.diff_month = global.diff_mm;
            }

            global.diff_mm = global.diff_mm % 12;

            //System.out.println(global.diff_mm);

            return true;

        }
        catch (Exception e) {

            throw e;
        }

    }
    
    
//    public static void main( String[] args ) {
//        SP_HUMAN_MonthPayCalc("MASTER", "201707", "1", "20170710", "C0018", "", "", "", "", "", "unilite5");
//    }

    public static String SP_HUMAN_MonthPayCalc(String sCompCode      //법인코드
            ,String sPayYyyymm     //급여년월
            ,String sSuppType      //지급구분
            ,String sSuppDate      //지급일자
            ,String sDivCode       //사업장코드
            ,String sPayCode       //급여지급방식
            ,String sPayProvFlag   //급여차수
            ,String sDeptCodeFr    //부서코드 from
            ,String sDeptCodeTo    //부서코드 to
            ,String sPersonNumb    //사번
            ,String sUserId        //로그인id
            ) {

        Connection conn = null;
        ResultSet rs = null;

        String sRtn = "";

        try{

            // DB 연결
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
//            conn = DriverManager.getConnection("jdbc:cubrid:211.241.199.190:30000:CRM:::?charset=UTF-8", "unilite", "UNILITE");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);

            StringBuffer sql = new StringBuffer();

            int Cnt = 0;

            // 월 급여마감 여부 체크
            sql.setLength(0);
            sql.append( " SELECT COUNT(*) AS RECORD_CNT                 " + "\n");
            sql.append( " FROM HBS900T                                  " + "\n");
            sql.append( " WHERE COMP_CODE  = " + "'" + sCompCode + "'   " + "\n");
            sql.append( " AND   CLOSE_DATE = " + "'" + sPayYyyymm + "'  " + "\n");
            sql.append( " AND   CLOSE_TYPE = '1'                        " + "\n");

            System.out.println(sql.toString());
            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                Cnt = rs.getInt("RECORD_CNT");
            }

            pstmt.close();
            rs.close();

            if(Cnt == 0) {
                // [ 1. HPA300T 월 지급내역 DELETE / INSERT ]

                // 해당월 지급내역 존재시 삭제
                sql.setLength(0);
                sql.append( " DELETE A                                                                                                  " + "\n");
                sql.append( " FROM       HPA300T A                                                                                      " + "\n");
                sql.append( " INNER JOIN HUM100T B ON A.COMP_CODE   = B.COMP_CODE                                                       " + "\n");
                sql.append( "                     AND A.PERSON_NUMB = B.PERSON_NUMB                                                     " + "\n");
                sql.append( " WHERE A.COMP_CODE     =  " + "'" + sCompCode + "'                                                         " + "\n");
                sql.append( " AND A.PAY_YYYYMM      =  " + "'" + sPayYyyymm + "'                                                        " + "\n");
                sql.append( " AND A.SUPP_TYPE       =  " + "'" + sSuppType + "'                                                            " + "\n");
                sql.append( " AND B.DIV_CODE      LIKE " + "'" + sDivCode + "' + '%'                                                    " + "\n");
                
                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND B.PAY_CODE      LIKE " + "'" + sPayCode + "' + '%'                                                " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND B.PAY_PROV_FLAG LIKE " + "'" + sPayProvFlag + "' + '%'                                            " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND B.PERSON_NUMB   LIKE " + "'" + sPersonNumb + "' + '%'                                             " + "\n");
                }
                
//                sql.append( " AND (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                " + "\n");
//                sql.append( "           ELSE B.DEPT_CODE                                                                                " + "\n");
//                sql.append( "        END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                           ELSE " + "'" + sDeptCodeFr + "'                                                   " + "\n");
//                sql.append( "                      END)  AND                                                                              " + "\n");
//                sql.append( "                     (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                           ELSE " + "'" + sDeptCodeTo + "'                                                   " + "\n");
//                sql.append( "                      END)                                                                                   " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 1 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                // HPA300T INSERT
                sql.setLength(0);
                sql.append( " INSERT INTO HPA300T ( COMP_CODE   , PAY_YYYYMM      , SUPP_TYPE        , PERSON_NUMB    , WAGES_CODE        " + "\n");
                sql.append( "                     , AMOUNT_I    , INSERT_DB_USER  , INSERT_DB_TIME   , UPDATE_DB_USER , UPDATE_DB_TIME)   " + "\n");
                sql.append( " SELECT A.COMP_CODE                                                                                          " + "\n");
                sql.append( "      , " + "'" + sPayYyyymm + "'                                                                            " + "\n");
                sql.append( "      , " + "'" + sSuppType + "'                                                                             " + "\n");
                sql.append( "      , A.PERSON_NUMB                                                                                        " + "\n");
                sql.append( "      , B.WAGES_CODE                                                                                         " + "\n");
                sql.append( "      , NVL(C.DED_AMOUNT_I, 0)                                                                               " + "\n");
                sql.append( "      , " + "'" + sUserId + "'                                                                               " + "\n");
                sql.append( "      , SYSDATETIME                                                                                          " + "\n");
                sql.append( "      , " + "'" + sUserId + "'                                                                               " + "\n");
                sql.append( "      , SYSDATETIME                                                                                          " + "\n");
                sql.append( " FROM       HUM100T A                                                                                        " + "\n");
                sql.append( " INNER JOIN HBS300T B  ON B.COMP_CODE   = A.COMP_CODE                                                        " + "\n");
                sql.append( "                      AND B.CODE_TYPE   = '1'                                                                " + "\n");
                sql.append( " LEFT  JOIN HPA700T C  ON C.COMP_CODE   = A.COMP_CODE                                                        " + "\n");
                sql.append( "                      AND C.PERSON_NUMB = A.PERSON_NUMB                                                      " + "\n");
                sql.append( "                            AND C.SUPP_TYPE   = " + "'" + sSuppType + "'                                           " + "\n");
                sql.append( "                         AND C.PROV_GUBUN  = '1' --지급                                                                                                                                                             " + "\n");
                sql.append( "                      AND C.WAGES_CODE  = B.WAGES_CODE                                                       " + "\n");
                sql.append( "                      AND " + "'" + sPayYyyymm + "'" + " BETWEEN C.PAY_FR_YYYYMM AND C.PAY_TO_YYYYMM         " + "\n");
                sql.append( " WHERE A.COMP_CODE     = " + "'" + sCompCode + "'                                                            " + "\n");
                sql.append( " AND   A.DIV_CODE      LIKE " + "'" + sDivCode + "' + '%'                                                    " + "\n");
                
                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND   A.PAY_CODE      LIKE " + "'" + sPayCode + "' + '%'                                                    " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND   A.PAY_PROV_FLAG LIKE " + "'" + sPayProvFlag + "' + '%'                                            " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND   A.PERSON_NUMB   LIKE " + "'" + sPersonNumb + "' + '%'                                             " + "\n");
                }
                
//                sql.append( " AND  (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                " + "\n");
//                sql.append( "            ELSE a.DEPT_CODE                                                                                " + "\n");
//                sql.append( "         END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeFr + "'                                                   " + "\n");
//                sql.append( "                        END)  AND                                                                              " + "\n");
//                sql.append( "                      (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeTo + "'                                                   " + "\n");
//                sql.append( "                       END)                                                                                   " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 2 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                // [ 1. HPA400T 월 공제내역 DELETE / INSERT ]

                // 해당월 지급내역 존재시 삭제
                sql.setLength(0);
                sql.append( " DELETE A                                                                                                    " + "\n");
                sql.append( " FROM       HPA400T A                                                                                        " + "\n");
                sql.append( " INNER JOIN HUM100T B  ON A.COMP_CODE   = B.COMP_CODE                                                        " + "\n");
                sql.append( "                      AND A.PERSON_NUMB = B.PERSON_NUMB                                                      " + "\n");
                sql.append( " WHERE A.COMP_CODE        = " + "'" + sCompCode + "'                                                         " + "\n");
                sql.append( " AND   A.PAY_YYYYMM       = " + "'" + sPayYyyymm + "'                                                        " + "\n");
                sql.append( " AND   A.SUPP_TYPE        = " + "'" + sSuppType + "'                                                          " + "\n");
                sql.append( " AND   B.DIV_CODE      LIKE " + "'" + sDivCode + "' + '%'                                                    " + "\n");

                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND   B.PAY_CODE      LIKE " + "'" + sPayCode + "' + '%'                                                " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND   B.PAY_PROV_FLAG LIKE " + "'" + sPayProvFlag + "' + '%'                                            " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND   B.PERSON_NUMB   LIKE " + "'" + sPersonNumb + "' + '%'                                             " + "\n");
                }
                
//                sql.append( " AND  (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                 " + "\n");
//                sql.append( "            ELSE B.DEPT_CODE                                                                                 " + "\n");
//                sql.append( "         END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeFr + "'                                                    " + "\n");
//                sql.append( "                       END)  AND                                                                               " + "\n");
//                sql.append( "                      (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeTo + "'                                                    " + "\n");
//                sql.append( "                       END)                                                                                    " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 3 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                // HPA400T INSERT
                sql.setLength(0);
                sql.append( " INSERT INTO HPA400T ( COMP_CODE      , PAY_YYYYMM      , SUPP_TYPE        , PERSON_NUMB      , DED_CODE         " + "\n");
                sql.append( "                       , DED_AMOUNT_I   , INSERt_DB_USER  , INSERT_DB_TIME   , UPDATE_DB_USER   , UPDATE_DB_TIME)  " + "\n");
                sql.append( " SELECT A.COMP_CODE                                                                                              " + "\n");
                sql.append( "      , " + "'" + sPayYyyymm + "'                                                                                " + "\n");
                sql.append( "      , " + "'" + sSuppType + "'                                                                                 " + "\n");
                sql.append( "      , A.PERSON_NUMB                                                                                            " + "\n");
                sql.append( "      , B.SUB_CODE                                                                                               " + "\n");
                sql.append( "      , NVL(C.DED_AMOUNT_I, 0)                                                                                   " + "\n");
                sql.append( "      , " + "'" + sUserId + "'                                                                                   " + "\n");
                sql.append( "      , SYSDATETIME                                                                                              " + "\n");
                sql.append( "      , " + "'" + sUserId + "'                                                                                   " + "\n");
                sql.append( "      , SYSDATETIME                                                                                              " + "\n");
                sql.append( " FROM       HUM100T A                                                                                            " + "\n");
                sql.append( " INNER JOIN BSA100T B ON B.COMP_CODE   = A.COMP_CODE                                                             " + "\n");
                sql.append( "                     AND B.MAIN_CODE   = 'H034'                                                                  " + "\n");
                sql.append( "                     AND B.SUB_CODE   != '$'                                                                     " + "\n");
                sql.append( " LEFT JOIN HPA700T C ON C.COMP_CODE    = A.COMP_CODE                                                             " + "\n");
                sql.append( "                    AND C.PERSON_NUMB  = A.PERSON_NUMB                                                           " + "\n");
                sql.append( "                    AND C.SUPP_TYPE    = " + "'" + sSuppType + "'                                                  " + "\n");
                sql.append( "                    AND C.PROV_GUBUN   = '2' --공제                                                                                                                                                                          " + "\n");
                sql.append( "                    AND C.WAGES_CODE   = B.SUB_CODE                                                              " + "\n");
                sql.append( "                    AND " + "'" + sPayYyyymm + "'" + " BETWEEN C.PAY_FR_YYYYMM AND C.PAY_TO_YYYYMM               " + "\n");
                sql.append( " WHERE A.COMP_CODE      = " + "'" + sCompCode + "'                                                               " + "\n");
                sql.append( " AND A.DIV_CODE      LIKE " + "'" + sDivCode + "' + '%'                                                          " + "\n");
                
                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND A.PAY_CODE      LIKE " + "'" + sPayCode + "' + '%'                                                      " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND A.PAY_PROV_FLAG LIKE " + "'" + sPayProvFlag + "' + '%'                                                  " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND A.PERSON_NUMB   LIKE " + "'" + sPersonNumb + "' + '%'                                                   " + "\n");
                }
                
//                sql.append( " AND  (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                     " + "\n");
//                sql.append( "            ELSE A.DEPT_CODE                                                                                     " + "\n");
//                sql.append( "         END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeFr + "'                                                        " + "\n");
//                sql.append( "                       END)  AND                                                                                   " + "\n");
//                sql.append( "                      (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeTo + "'                                                        " + "\n");
//                sql.append( "                       END)                                                                                        " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 4 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                
                // [ 1. HPA600T 월 공제내역 DELETE / INSERT ]

                //해당월 지급내역 존재시 삭제
                sql.setLength(0);
                sql.append( " DELETE A                                                                                                        " + "\n");
                sql.append( " FROM       HPA600T A                                                                                            " + "\n");
                sql.append( " INNER JOIN HUM100T B ON A.COMP_CODE   = B.COMP_CODE                                                             " + "\n");
                sql.append( "                     AND A.PERSON_NUMB = B.PERSON_NUMB                                                           " + "\n");
                sql.append( " WHERE A.COMP_CODE     = " + "'" + sCompCode + "'                                                                " + "\n");
                sql.append( " AND A.PAY_YYYYMM      = " + "'" + sPayYyyymm + "'                                                               " + "\n");
                sql.append( " AND A.SUPP_TYPE       = " + "'" + sSuppType + "'                                                                  " + "\n");
                sql.append( " AND B.DIV_CODE      LIKE " + "'" + sDivCode + "' + '%'                                                          " + "\n");
                
                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND B.PAY_CODE      LIKE " + "'" + sPayCode + "' + '%'                                                      " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND B.PAY_PROV_FLAG LIKE " + "'" + sPayProvFlag + "' + '%'                                                  " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND B.PERSON_NUMB   LIKE " + "'" + sPersonNumb + "' + '%'                                                   " + "\n");
                }
                
//                sql.append( " AND  (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                     " + "\n");
//                sql.append( "            ELSE B.DEPT_CODE                                                                                     " + "\n");
//                sql.append( "         END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeFr + "'                                                        " + "\n");
//                sql.append( "                       END)  AND                                                                                   " + "\n");
//                sql.append( "                      (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeTo + "'                                                        " + "\n");
//                sql.append( "                       END)                                                                                        " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 5 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                sql.setLength(0);
                sql.append( " INSERT INTO HPA600T ( COMP_CODE       , PAY_YYYYMM       , SUPP_TYPE       , PERSON_NUMB                   " + "\n");
                sql.append( "                     , DIV_CODE        , MAKE_SALE        , SECT_CODE       , DEPT_CODE                     " + "\n");
                sql.append( "                     , DEPT_NAME       , ABIL_CODE        , POST_CODE       , PAY_CODE                      " + "\n");
                sql.append( "                     , TAX_CODE        , TAX_CODE2        , EMPLOY_TYPE     , SUPP_DATE                     " + "\n");
                sql.append( "                     , PAY_PROV_FLAG   , SPOUSE           , WOMAN           , SUPP_NUM                      " + "\n");
                sql.append( "                     , DEFORM_NUM      , AGED_NUM         , PAY_TOTAL_I     , TAX_AMOUNT_I                  " + "\n");
                sql.append( "                     , SUPP_TOTAL_I    , DED_TOTAL_I      , REAL_AMOUNT_I   , PAY_GUBUN                     " + "\n");
                sql.append( "                     , PAY_GUBUN2      , CHILD_20_NUM     , TAXRATE_BASE    , INSERT_DB_USER                " + "\n");
                sql.append( "                     , INSERT_DB_TIME  , UPDATE_DB_USER   , UPDATE_DB_TIME )                                " + "\n");
                sql.append( " SELECT A.COMP_CODE                                                                                         " + "\n");
                sql.append( "      , A.PAY_YYYYMM                                                                                        " + "\n");
                sql.append( "      , A.SUPP_TYPE                                      --지급구분                                                                                                                      " + "\n");
                sql.append( "      , A.PERSON_NUMB                                                                                       " + "\n");
                sql.append( "      , C.DIV_CODE                                          --사업장코드                                                                                                                    " + "\n");
                sql.append( "      , C.MAKE_SALE                                      --제조판관구분                                                                                                                 " + "\n");
                sql.append( "      , C.SECT_CODE                                      --신고사업장                                                                                                                    " + "\n");
                sql.append( "      , C.DEPT_CODE                                      --부서코드                                                                                                                       " + "\n");
                sql.append( "      , C.DEPT_NAME                                      --부서명                                                                                                                           " + "\n");
                sql.append( "      , C.ABIL_CODE                                      --직책                                                                                                                             " + "\n");
                sql.append( "      , C.POST_CODE                                      --직위                                                                                                                             " + "\n");
                sql.append( "      , C.PAY_CODE                                          --급여지급방식                                                                                                                 " + "\n");
                sql.append( "      , C.TAX_CODE                                          --세액구분(m)                                          " + "\n");
                sql.append( "      , C.TAX_CODE2                                      --자녀양육비과세구분 (1:과세, 2:비과세) (master)                " + "\n");
                sql.append( "      , C.EMPLOY_TYPE                                      --사원구분(master)                                     " + "\n");
                sql.append( "      , " + "'" + sSuppDate + "'     AS SUPP_DATE          --지급일                                                                                                                           " + "\n");
                sql.append( "      , C.PAY_PROV_FLAG                                  --지급차수                                                                                                                        " + "\n");
                sql.append( "      , NVL(C.SPOUSE,'N')            AS SPOUSE           --배우자유무                                                                                                                     " + "\n");
                sql.append( "      , NVL(C.WOMAN,'N')             AS WOMAN            --부녀자                                                                                                                           " + "\n");
                sql.append( "      , NVL(C.SUPP_AGED_NUM,0)       AS SUPP_NUM         --부양자                                                                                                                           " + "\n");
                sql.append( "      , NVL(C.DEFORM_NUM,0)          AS DEFORM_NUM       --장애인                                                                                                                           " + "\n");
                sql.append( "      , NVL(C.AGED_NUM,0)            AS AGED_NUM         --경로자                                                                                                                           " + "\n");
                sql.append( "      , A.AMT                          AS PAY_TOTAL_I      --급여총액                                                                                                                        " + "\n");
                sql.append( "      , A.AMT                          AS TAX_AMOUNT_I      --급여과세금액                                                                                                                  " + "\n");
                sql.append( "      , A.AMT                          AS SUPP_TATAL_I      --지급총액                                                                                                                        " + "\n");
                sql.append( "      , B.DED_AMT                      AS DED_TOTAL_I      --공제총액                                                                                                                        " + "\n");
                sql.append( "      , A.AMT - B.DED_AMT              AS REAL_AMOUNT_I      --실지급금액                                                                                                                     " + "\n");
                sql.append( "      , C.PAY_GUBUN                                      --고용형태(정규직,비정규직)                                  " + "\n");
                sql.append( "      , C.PAY_GUBUN2                                      --일용(1),일반(2)                                      " + "\n");
                sql.append( "      , NVL(C.CHILD_20_NUM,0)          AS CHILD_20_NUM      --20세이하자녀수                                                                                                              " + "\n");
                sql.append( "      , '2'                          AS TAXRATE_BASE      --소득세세율기준(1:80%, 2:100%, 3:120%')                  " + "\n");
                sql.append( "      , " + "'" + sUserId + "'       AS INSERT_DB_USER                                                       " + "\n");
                sql.append( "      , SYSDATETIME                  AS INSERT_DB_TIME                                                       " + "\n");
                sql.append( "      , " + "'" + sUserId + "'       AS UPDATE_DB_USER                                                       " + "\n");
                sql.append( "      , SYSDATETIME                  AS UPDATE_DB_TIME                                                       " + "\n");
                sql.append( " FROM                                                                                                        " + "\n");
                sql.append( "     (                                                                                                       " + "\n");
                sql.append( "        SELECT COMP_CODE , PAY_YYYYMM, SUPP_TYPE , PERSON_NUMB, NVL(SUM(AMOUNT_I),0) AS AMT                  " + "\n");
                sql.append( "        FROM HPA300T                                                                                         " + "\n");
                sql.append( "        WHERE COMP_CODE   = " + "'" + sCompCode + "'                                                         " + "\n");
                sql.append( "        AND   PAY_YYYYMM  = " + "'" + sPayYyyymm + "'                                                        " + "\n");
                sql.append( "        AND   SUPP_TYPE   = " + "'" + sSuppType + "'                                                          " + "\n");
                sql.append( "        GROUP BY COMP_CODE , PAY_YYYYMM, SUPP_TYPE , PERSON_NUMB                                             " + "\n");
                sql.append( "     ) A                                                                                                     " + "\n");
                sql.append( " INNER JOIN  (                                                                                               " + "\n");
                sql.append( "               SELECT COMP_CODE , PAY_YYYYMM, SUPP_TYPE , PERSON_NUMB, NVL(SUM(DED_AMOUNT_I),0) AS DED_AMT   " + "\n");
                sql.append( "               FROM HPA400T                                                                                  " + "\n");
                sql.append( "               WHERE COMP_CODE    = " + "'" + sCompCode + "'                                                 " + "\n");
                sql.append( "               AND   PAY_YYYYMM   = " + "'" + sPayYyyymm + "'                                                " + "\n");
                sql.append( "               AND   SUPP_TYPE    = " + "'" + sSuppType + "'                                                  " + "\n");
                sql.append( "               GROUP BY COMP_CODE , PAY_YYYYMM, SUPP_TYPE , PERSON_NUMB                                      " + "\n");
                sql.append( "             ) B ON A.COMP_CODE    = B.COMP_CODE                                                             " + "\n");
                sql.append( "                AND A.PAY_YYYYMM   = B.PAY_YYYYMM                                                            " + "\n");
                sql.append( "                AND A.SUPP_TYPE    = B.SUPP_TYPE                                                             " + "\n");
                sql.append( "                AND A.PERSON_NUMB  = B.PERSON_NUMB                                                           " + "\n");
                sql.append( " INNER JOIN HUM100T C ON C.COMP_CODE   = A.COMP_CODE                                                         " + "\n");
                sql.append( "                     AND C.PERSON_NUMB = A.PERSON_NUMB                                                       " + "\n");
                sql.append( " WHERE A.COMP_CODE         = " + "'" + sCompCode + "'                                                        " + "\n");
                sql.append( " AND   A.PAY_YYYYMM        = " + "'" + sPayYyyymm + "'                                                       " + "\n");
                sql.append( " AND   A.SUPP_TYPE         = " + "'" + sSuppType + "'                                                          " + "\n");
                sql.append( " AND   C.DIV_CODE       LIKE " + "'" + sDivCode + "' + '%'                                                   " + "\n");
                
                if(sPayCode.equals("")){
                    
                }else{
                    sql.append( " AND   C.PAY_CODE       LIKE " + "'" + sPayCode + "' + '%'                                               " + "\n");
                }
                if(sPayProvFlag.equals("")){
                    
                }else{
                    sql.append( " AND   C.PAY_PROV_FLAG  LIKE " + "'" + sPayProvFlag + "' + '%'                                           " + "\n");
                }
                if(sPersonNumb.equals("")){
                    
                }else{
                    sql.append( " AND   C.PERSON_NUMB    LIKE " + "'" + sPersonNumb + "' + '%'                                            " + "\n");
                }
                
//                sql.append( " AND  (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' = '' THEN ''                 " + "\n");
//                sql.append( "            ELSE C.DEPT_CODE                                                                                 " + "\n");
//                sql.append( "         END) BETWEEN (CASE WHEN " + "'" + sDeptCodeFr + "' = '' AND " + "'" + sDeptCodeTo + "' <> '' THEN " + "'" + sDeptCodeTo + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeFr + "'                                                    " + "\n");
//                sql.append( "                       END)  AND                                                                               " + "\n");
//                sql.append( "                      (CASE WHEN " + "'" + sDeptCodeTo + "' = '' AND " + "'" + sDeptCodeFr + "' <> '' THEN " + "'" + sDeptCodeFr + "'" + "\n");
//                sql.append( "                            ELSE " + "'" + sDeptCodeTo + "'                                                    " + "\n");
//                sql.append( "                       END)                                                                                    " + "\n");

                System.out.println("====================================================================");
                System.out.println("=============================== 6 ==================================");
                System.out.println("====================================================================");
                
                System.out.println("sql :: " + sql.toString());
                
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
                

            } else {
                sRtn = "이미 마감된 자료입니다.";
            }

            //---------------------------------------------------------------------------------------------------------
            pstmt.close();
            rs.close();
            conn.setAutoCommit(true);

            return sRtn;

        } catch (Exception e) {
            //System.out.println(e.getMessage());
            return e.getMessage();   

        }
    }

    //@SuppressWarnings("resource")
    public static String USP_HPA340UKR(String sCompCode
            ,String sPayYymm
            ,String sProvDt
            ,String sOrgCd
            ,String sTreeFr
            ,String sTreeTo
            ,String sPayCd
            ,String sPayDayFlag
            ,String sBisicDataCreateYn  //기초자료생성여부  Y oR N
            ,String sCalcHir
            ,String sEmpNo
            ,String sSuppType
            ,String sUserId
            ,String sIncValue  //소액징수부
            ,String sRepeatYn
            ,String sDelFlag   //삭제여부
            ) {

        Connection conn = null;
        ResultSet rs = null;

        int RECORD_CNT = 0;



        String sRtn = "";
        try{
            String[] bParam = {sCompCode, sPayYymm, sProvDt, sOrgCd
                    , sTreeFr, sTreeTo, sPayCd, sPayDayFlag
                    , sBisicDataCreateYn, sCalcHir, sEmpNo, sSuppType
                    , sUserId, sIncValue, sRepeatYn, sDelFlag};

            //                ArrayList ddd = new ArrayList();
            //                ddd.add("1");
            //                System.out.println(ddd.size());

            String dParam[] = new String[16];
            int vRtnPriod[] = new int[2];

            //                dParam[15] = "11";
            //                
            //                System.out.println(dParam[15]);
            //                
            String sCloseDate = "";


            // DB 연결
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);

            StringBuffer sql = new StringBuffer();

            String KeyValue = "";              

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();


            // 마감체크 
            sql.setLength(0);                
            sql.append( "  SELECT CLOSE_DATE           " + "\n");
            sql.append( "  FROM HBS900T                " + "\n");
            sql.append( "  WHERE COMP_CODE  = 'MASTER' " + "\n");
            sql.append( "  AND   CLOSE_TYPE = '1'      " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                sCloseDate = rs.getString("CLOSE_DATE");
            }

            if (!sCloseDate.equals("")) {
                if(Integer.parseInt(sCloseDate) >= Integer.parseInt(sPayYymm)){
                    pstmt.close();
                    return "이미 마감된 자료입니다.";
                }
            }                
            pstmt.close();

            // 개인별 급여마감은 대상데이터 작업시
            // 테이블 JOIN하여 HBS910T에 없는 사번만 계산되도록
            // 쿼리에 모두 추가함

            //사번 조건의 급여계산 내역 유무

            sql.setLength(0);
            sql.append( "    SELECT COUNT(A.COMP_CODE) AS HPA600T_CNT                       " + "\n");
            sql.append( "    FROM              HPA600T A                                    " + "\n");
            sql.append( "           INNER JOIN HUM100T V ON V.COMP_CODE    = A.COMP_CODE    " + "\n");
            sql.append( "                               AND V.PERSON_NUMB  = A.PERSON_NUMB  " + "\n");
            sql.append( "     WHERE A.PAY_YYYYMM  = " + "'" + sPayYymm  + "'                " + "\n");
            sql.append( "       AND A.SUPP_TYPE   = " + "'" + sSuppType + "'                " + "\n");
            sql.append( "       AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'                " + "\n");

            if(!sCompCode.equals("")){
                sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
            }
            if(!sEmpNo.equals("")){
                sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
            }                
            if(!sPayCd.equals("")){
                sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
            }             
            if(!sOrgCd.equals("")){
                sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
            }
            if(!sTreeFr.equals("")){
                sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
            }       
            if(!sTreeTo.equals("")){
                sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
            }                       
            if(!sPayDayFlag.equals("")){
                sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
            }    


            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            int sHpa600tCnt = 0;

            while(rs.next()){
                sHpa600tCnt = Integer.parseInt(rs.getString("HPA600T_CNT"));
            }

            pstmt.close();

            if(sHpa600tCnt > 0) {
                //사번 조건일 때 개인별마감과 조인하여 마감데이터가 있을 때는 마감되었다는 메시지 뿌려준다.

                sql.setLength(0);
                sql.append( " SELECT COUNT(B.*) AS DATA_CNT                             " + "\n");
                sql.append( " FROM       HPA600T A                                      " + "\n");
                sql.append( " INNER JOIN HUM100T V ON  V.COMP_CODE    = A.COMP_CODE     " + "\n");
                sql.append( "                      AND V.PERSON_NUMB  = A.PERSON_NUMB   " + "\n");
                sql.append( " INNER JOIN HBS910T B ON  B.COMP_CODE    = A.COMP_CODE     " + "\n");
                sql.append( "                      AND B.CLOSE_DATE   = A.PAY_YYYYMM    " + "\n");
                sql.append( "                      AND B.CLOSE_TYPE   = A.SUPP_TYPE     " + "\n");
                sql.append( "                      AND B.PERSON_NUMB  = A.PERSON_NUMB   " + "\n");
                sql.append( " WHERE A.PAY_YYYYMM  = " + "'" + sPayYymm  + "'            " + "\n");
                sql.append( " AND   A.SUPP_TYPE   = " + "'" + sSuppType + "'            " + "\n");
                sql.append( " AND   A.PERSON_NUMB = " + "'" + sEmpNo    + "'            " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    


                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();



                int DATA_CNT = 0;

                while(rs.next()){
                    DATA_CNT = Integer.parseInt(rs.getString("DATA_CNT"));
                }

                if(DATA_CNT > 0){
                    pstmt.close();
                    return "이미 마감된 자료입니다.";
                }

                pstmt.close();    
            }

            // 급여계산 대상자 존재여부
            if(sRepeatYn != "REPEAT"){

                sql.setLength(0);
                sql.append( " SELECT COUNT(PERSON_NUMB) AS PERSON_CNT                  " + "\n");
                sql.append( " FROM HAT300T                                             " + "\n");
                sql.append( " WHERE COMP_CODE    = " + "'" + sCompCode + "'            " + "\n");
                sql.append( " AND   DUTY_YYYYMM  = " + "'" + sPayYymm  + "'            " + "\n");

                if(!sOrgCd.equals("")){
                    sql.append( " AND PERSON_NUMB IN (SELECT PERSON_NUMB                                 " + "\n");
                    sql.append( "                     FROM   HUM100T                                     " + "\n");
                    sql.append( "                     WHERE  COMP_CODE     = " + "'" + sCompCode   + "'  " + "\n");
                    sql.append( "                     AND    DIV_CODE     >= " + "'" + sOrgCd      + "') " + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND PERSON_NUMB IN (SELECT PERSON_NUMB                                 " + "\n");
                    sql.append( "                     FROM   HUM100T                                     " + "\n");
                    sql.append( "                     WHERE  COMP_CODE     = " + "'" + sCompCode   + "'  " + "\n");
                    sql.append( "                     AND    DEPT_CODE    >= " + "'" + sTreeFr     + "') " + "\n");
                }
                if(!sTreeTo.equals("")){
                    sql.append( " AND PERSON_NUMB IN (SELECT PERSON_NUMB                                 " + "\n");
                    sql.append( "                     FROM   HUM100T                                     " + "\n");
                    sql.append( "                     WHERE  COMP_CODE     = " + "'" + sCompCode   + "'  " + "\n");
                    sql.append( "                     AND    DEPT_CODE    <= " + "'" + sTreeTo     + "') " + "\n");
                }      
                if(!sPayCd.equals("")){
                    sql.append( " AND PERSON_NUMB IN (SELECT PERSON_NUMB                                 " + "\n");
                    sql.append( "                     FROM   HUM100T                                     " + "\n");
                    sql.append( "                     WHERE  COMP_CODE     = " + "'" + sCompCode   + "'  " + "\n");
                    sql.append( "                     AND    PAY_CODE      = " + "'" + sPayCd      + "') " + "\n");
                }               
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND PERSON_NUMB IN (SELECT PERSON_NUMB                                 " + "\n");
                    sql.append( "                     FROM   HUM100T                                     " + "\n");
                    sql.append( "                     WHERE  COMP_CODE     = " + "'" + sCompCode   + "'  " + "\n");
                    sql.append( "                     AND    PAY_PROV_FLAG = " + "'" + sPayDayFlag + "') " + "\n");
                }   
                if(!sEmpNo.equals("")){
                    sql.append( " AND PERSON_NUMB = " + "'" + sEmpNo + "'                                " + "\n"); 
                }  


                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();



                int PERSON_CNT = 0;

                while(rs.next()){
                    PERSON_CNT = Integer.parseInt(rs.getString("PERSON_CNT"));
                }

                //if(PERSON_CNT == 0){ 디버킹을위해 흐르게하기위해 !=로 잠시바꿈
                if(PERSON_CNT != 0){
                    pstmt.close();
                    return "해당사원이 존재하지 않습니다.";
                }

                pstmt.close();

                // (row : 212)
                if(sDelFlag.equals("D")) {

                    sql.setLength(0);
                    sql.append( " DELETE T1                                                    " + "\n");
                    sql.append( " FROM       HPA300T T1                                        " + "\n");
                    sql.append( " INNER JOIN HPA600T A   ON  T1.COMP_CODE   = A.COMP_CODE      " + "\n");
                    sql.append( "                        AND T1.PAY_YYYYMM  = A.PAY_YYYYMM     " + "\n");
                    sql.append( "                        AND T1.SUPP_TYPE   = A.SUPP_TYPE      " + "\n");
                    sql.append( "                        AND T1.PERSON_NUMB = A.PERSON_NUMB    " + "\n");
                    sql.append( " INNER JOIN HUM100T V   ON  T1.COMP_CODE   = V.COMP_CODE      " + "\n");
                    sql.append( "                        AND T1.PERSON_NUMB = V.PERSON_NUMB    " + "\n");
                    sql.append( " LEFT  JOIN HBS910T B   ON  B.COMP_CODE    = T1.COMP_CODE     " + "\n");
                    sql.append( "                        AND B.CLOSE_DATE   = T1.PAY_YYYYMM    " + "\n");
                    sql.append( "                        AND B.CLOSE_TYPE   = T1.SUPP_TYPE     " + "\n");
                    sql.append( "                        AND B.PERSON_NUMB  = T1.PERSON_NUMB   " + "\n");
                    sql.append( " WHERE T1.PAY_YYYYMM = " + "'" + sPayYymm  + "'               " + "\n");
                    sql.append( " AND   T1.SUPP_TYPE  = " + "'" + sSuppType + "'               " + "\n");
                    sql.append( " AND   B.COMP_CODE IS NULL                                    " + "\n");

                    if(!sCompCode.equals("")){
                        sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                    }
                    if(!sEmpNo.equals("")){
                        sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                    }                
                    if(!sPayCd.equals("")){
                        sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                    }             
                    if(!sOrgCd.equals("")){
                        sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                    }
                    if(!sTreeFr.equals("")){
                        sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                    }       
                    if(!sTreeTo.equals("")){
                        sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                    }                       
                    if(!sPayDayFlag.equals("")){
                        sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                    }    

                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.execute();
                    pstmt.close();

                    //2.월공제내역 TABLE 삭제
                    sql.setLength(0);
                    sql.append( " DELETE T1                                                    " + "\n");
                    sql.append( " FROM       HPA400T T1                                        " + "\n");
                    sql.append( " INNER JOIN HPA600T A   ON  T1.COMP_CODE   = A.COMP_CODE      " + "\n");
                    sql.append( "                        AND T1.PAY_YYYYMM  = A.PAY_YYYYMM     " + "\n");
                    sql.append( "                        AND T1.SUPP_TYPE   = A.SUPP_TYPE      " + "\n");
                    sql.append( "                        AND T1.PERSON_NUMB = A.PERSON_NUMB    " + "\n");
                    sql.append( " INNER JOIN HUM100T V   ON  T1.COMP_CODE   = V.COMP_CODE      " + "\n");
                    sql.append( "                        AND T1.PERSON_NUMB = V.PERSON_NUMB    " + "\n");
                    sql.append( " LEFT  JOIN HBS910T B   ON  B.COMP_CODE    = T1.COMP_CODE     " + "\n");
                    sql.append( "                        AND B.CLOSE_DATE   = T1.PAY_YYYYMM    " + "\n");
                    sql.append( "                        AND B.CLOSE_TYPE   = T1.SUPP_TYPE     " + "\n");
                    sql.append( "                        AND B.PERSON_NUMB  = T1.PERSON_NUMB   " + "\n");
                    sql.append( " WHERE A.PAY_YYYYMM  = " + "'" + sPayYymm  + "'               " + "\n");
                    sql.append( " AND   T1.SUPP_TYPE  = " + "'" + sSuppType + "'               " + "\n");
                    sql.append( " AND   B.COMP_CODE IS NULL                                    " + "\n");

                    if(!sCompCode.equals("")){
                        sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                    }
                    if(!sEmpNo.equals("")){
                        sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                    }                
                    if(!sPayCd.equals("")){
                        sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                    }             
                    if(!sOrgCd.equals("")){
                        sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                    }
                    if(!sTreeFr.equals("")){
                        sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                    }       
                    if(!sTreeTo.equals("")){
                        sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                    }                       
                    if(!sPayDayFlag.equals("")){
                        sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                    }    

                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.execute();
                    pstmt.close();

                    //3.급상여내역삭제
                    sql.setLength(0);
                    sql.append( " DELETE  A                                                  " + "\n");
                    sql.append( " FROM       HPA600T A                                       " + "\n");
                    sql.append( " INNER JOIN HUM100T V   ON  A.COMP_CODE    = V.COMP_CODE    " + "\n");
                    sql.append( "                        AND A.PERSON_NUMB  = V.PERSON_NUMB  " + "\n");
                    sql.append( " LEFT  JOIN HBS910T B   ON  B.COMP_CODE    = A.COMP_CODE    " + "\n");
                    sql.append( "                        AND B.CLOSE_DATE   = A.PAY_YYYYMM   " + "\n");
                    sql.append( "                        AND B.CLOSE_TYPE   = A.SUPP_TYPE    " + "\n");
                    sql.append( "                        AND B.PERSON_NUMB  = A.PERSON_NUMB  " + "\n");
                    sql.append( " WHERE A.PAY_YYYYMM = " + "'" + sPayYymm  + "'              " + "\n");
                    sql.append( " AND   A.SUPP_TYPE  = " + "'" + sSuppType + "'              " + "\n");
                    sql.append( " AND   B.COMP_CODE  IS  NULL                                " + "\n");

                    if(!sCompCode.equals("")){
                        sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                    }
                    if(!sEmpNo.equals("")){
                        sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                    }                
                    if(!sPayCd.equals("")){
                        sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                    }             
                    if(!sOrgCd.equals("")){
                        sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                    }
                    if(!sTreeFr.equals("")){
                        sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                    }       
                    if(!sTreeTo.equals("")){
                        sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                    }                       
                    if(!sPayDayFlag.equals("")){
                        sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                    }    

                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.execute();
                    pstmt.close();

                    //삭제후 리턴
                    return "";

                }
                pstmt.close();

                //자동기표 유무 체크  (row : 284)
                sql.setLength(0);
                sql.append( " SELECT COUNT(V.PERSON_NUMB) AS RECORD_CNT                    " + "\n");
                sql.append( " FROM       HPA600T V                                         " + "\n");
                sql.append( " INNER JOIN HUM100T V1   ON  V.COMP_CODE    = V1.COMP_CODE    " + "\n");
                sql.append( "                         AND V.PERSON_NUMB  = V1.PERSON_NUMB  " + "\n");
                sql.append( " LEFT  JOIN HBS910T B    ON  B.COMP_CODE    = V.COMP_CODE     " + "\n");
                sql.append( "                         AND B.CLOSE_DATE   = V.PAY_YYYYMM    " + "\n");
                sql.append( "                         AND B.CLOSE_TYPE   = V.SUPP_TYPE     " + "\n");
                sql.append( "                         AND B.PERSON_NUMB  = V.PERSON_NUMB   " + "\n");
                sql.append( " WHERE V.PAY_YYYYMM = " + "'" + sPayYymm  + "'                " + "\n");
                sql.append( " AND   V.SUPP_TYPE  = " + "'" + sSuppType + "'                " + "\n");
//                sql.append( " AND   NVL(V.EX_DATE, '') != ''                               " + "\n");
                sql.append( " AND   V.EX_DATE   IS NOT NULL                                " + "\n");
                sql.append( " AND   B.COMP_CODE IS NULL                                    " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND V.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND V.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND V.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V1.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND V.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND V.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND V.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    RECORD_CNT = Integer.parseInt(rs.getString("RECORD_CNT"));
                }

                if(RECORD_CNT > 0){
                    pstmt.close();
                    return "전표를 취소하고 계산을 다시하여 주십시오.";
                }

                pstmt.close();                    
            }

            //급여 재계산시 급여반영여부를 'N'으로 설정 (row : 337)
            sql.setLength(0);
            sql.append( " UPDATE     HWE010T V                                          " + "\n");
            sql.append( " INNER JOIN HUM100T V1 ON V1.COMP_CODE    = V.COMP_CODE        " + "\n");
            sql.append( "                      AND V1.PERSON_NUMB  = V.PERSON_NUMB      " + "\n");
            sql.append( " INNER JOIN HPA600T V2  ON V2.COMP_CODE   = V1.COMP_CODE       " + "\n");
            sql.append( "                       AND V2.PERSON_NUMB = V1.PERSON_NUMB     " + "\n");
            sql.append( "                       AND V2.PAY_YYYYMM  = V.PAY_YYYYMM       " + "\n");
            sql.append( "                       AND V2.SUPP_TYPE   = V.SUPP_TYPE        " + "\n");
            sql.append( " LEFT  JOIN HBS910T B   ON B.COMP_CODE    = V2.COMP_CODE       " + "\n");
            sql.append( "                       AND B.CLOSE_DATE   = V2.PAY_YYYYMM      " + "\n");
            sql.append( "                       AND B.CLOSE_TYPE   = V2.SUPP_TYPE       " + "\n");
            sql.append( "                       AND B.PERSON_NUMB  = V2.PERSON_NUMB     " + "\n");
            sql.append( " SET V.PAY_APPLY_YN = 'N'                                      " + "\n");
            sql.append( " WHERE V.PAY_YYYYMM = " + "'" + sPayYymm  + "'                 " + "\n");
            sql.append( " AND   V.SUPP_TYPE  = " + "'" + sSuppType + "'                 " + "\n");

            if(!sCompCode.equals("")){
                sql.append( " AND V2.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
            }
            if(!sEmpNo.equals("")){
                sql.append( " AND V2.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
            }                
            if(!sPayCd.equals("")){
                sql.append( " AND V2.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
            }             
            if(!sOrgCd.equals("")){
                sql.append( " AND V1.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
            }
            if(!sTreeFr.equals("")){
                sql.append( " AND V2.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
            }       
            if(!sTreeTo.equals("")){
                sql.append( " AND V2.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
            }                       
            if(!sPayDayFlag.equals("")){
                sql.append( " AND V2.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
            }    


            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            /* ***********************
                                          급여계산 시작 (row : 362)                     
             ************************/

            // 기초자료 생성 
            if(sBisicDataCreateYn.equals("Y")) {

                //1.월지급내역 Table 삭제
                sql.setLength(0);
                sql.append( " DELETE T1                                                    " + "\n");
                sql.append( " FROM       HPA300T T1                                        " + "\n");
                sql.append( " INNER JOIN HPA600T A   ON T1.COMP_CODE   = A.COMP_CODE       " + "\n");
                sql.append( "                       AND T1.PAY_YYYYMM  = A.PAY_YYYYMM      " + "\n");
                sql.append( "                       AND T1.SUPP_TYPE   = A.SUPP_TYPE       " + "\n");
                sql.append( "                       AND T1.PERSON_NUMB = A.PERSON_NUMB     " + "\n");
                sql.append( " INNER JOIN HUM100T V   ON T1.COMP_CODE   = V.COMP_CODE       " + "\n");
                sql.append( "                       AND T1.PERSON_NUMB = V.PERSON_NUMB     " + "\n");
                sql.append( " LEFT  JOIN HBS910T B   ON  B.COMP_CODE   = T1.COMP_CODE      " + "\n");
                sql.append( "                       AND B.CLOSE_DATE   = T1.PAY_YYYYMM     " + "\n");
                sql.append( "                       AND B.CLOSE_TYPE   = T1.SUPP_TYPE      " + "\n");
                sql.append( "                       AND B.PERSON_NUMB  = T1.PERSON_NUMB    " + "\n");
                sql.append( " WHERE T1.PAY_YYYYMM = " + "'" + sPayYymm  + "'                " + "\n");
                sql.append( " AND   T1.SUPP_TYPE  = " + "'" + sSuppType + "'                " + "\n");
                sql.append( " AND   B.COMP_CODE  IS  NULL                                   " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                //2.월공제내역 TABLE 삭제
                sql.setLength(0);
                sql.append( " DELETE T1                                                 " + "\n");
                sql.append( " FROM       HPA400T T1                                     " + "\n");
                sql.append( " INNER JOIN HPA600T A ON  T1.COMP_CODE   = A.COMP_CODE     " + "\n");
                sql.append( "                      AND T1.PAY_YYYYMM  = A.PAY_YYYYMM    " + "\n");
                sql.append( "                      AND T1.SUPP_TYPE   = A.SUPP_TYPE     " + "\n");
                sql.append( "                      AND T1.PERSON_NUMB = A.PERSON_NUMB   " + "\n");
                sql.append( " INNER JOIN HUM100T V ON  T1.COMP_CODE   = V.COMP_CODE     " + "\n");
                sql.append( "                      AND T1.PERSON_NUMB = V.PERSON_NUMB   " + "\n");
                sql.append( " LEFT  JOIN HBS910T B ON  B.COMP_CODE    = T1.COMP_CODE    " + "\n");
                sql.append( "                      AND B.CLOSE_DATE   = T1.PAY_YYYYMM   " + "\n");
                sql.append( "                      AND B.CLOSE_TYPE   = T1.SUPP_TYPE    " + "\n");
                sql.append( "                      AND B.PERSON_NUMB  = T1.PERSON_NUMB  " + "\n");
                sql.append( " WHERE A.PAY_YYYYMM  = " + "'" + sPayYymm  + "'            " + "\n");
                sql.append( " AND   T1.SUPP_TYPE  = " + "'" + sSuppType + "'            " + "\n");
                sql.append( " AND   B.COMP_CODE  IS  NULL                               " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();


                // 3.급상여내역삭제
                sql.setLength(0);
                sql.append( " DELETE A                                                 " + "\n");
                sql.append( " FROM       HPA600T A                                     " + "\n");
                sql.append( " INNER JOIN HUM100T V ON A.COMP_CODE    = V.COMP_CODE     " + "\n");
                sql.append( "                     AND A.PERSON_NUMB  = V.PERSON_NUMB   " + "\n");
                sql.append( " LEFT  JOIN HBS910T B ON B.COMP_CODE    = A.COMP_CODE     " + "\n");
                sql.append( "                     AND B.CLOSE_DATE   = A.PAY_YYYYMM    " + "\n");
                sql.append( "                     AND B.CLOSE_TYPE   = A.SUPP_TYPE     " + "\n");
                sql.append( "                     AND B.PERSON_NUMB  = A.PERSON_NUMB   " + "\n");
                sql.append( " WHERE A.PAY_YYYYMM  = " + "'" + sPayYymm  + "'           " + "\n");
                sql.append( " AND   A.SUPP_TYPE  = " + "'" + sSuppType + "'            " + "\n");
                sql.append( " AND   B.COMP_CODE IS NULL                                " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                sql.setLength(0);
                sql.append( " INSERT INTO HPA600T" + "\n");
                sql.append( " ( PAY_YYYYMM     , SUPP_TYPE   , PERSON_NUMB  , DEPT_CODE      , DEPT_NAME                        " + "\n");
                sql.append( " , ABIL_CODE      , POST_CODE   , PAY_CODE     , TAX_CODE       , TAX_CODE2                        " + "\n");
                sql.append( " , EXCEPT_TYPE    , EMPLOY_TYPE , SUPP_DATE    , PAY_PROV_FLAG                                     " + "\n");
                sql.append( " , OT_KIND        , SPOUSE      , WOMAN        , SUPP_NUM       , DEFORM_NUM                       " + "\n");
                sql.append( " , AGED_NUM       , PENS_GRADE  , MED_GRADE    , INSERT_DB_USER , INSERT_DB_TIME, UPDATE_DB_USER   " + "\n");
                sql.append( " , UPDATE_DB_TIME , DIV_CODE    , SECT_CODE    , MAKE_SALE      , COST_KIND     , PAY_GUBUN        " + "\n");
                sql.append( " , PAY_GUBUN2     , MED_AVG_I   , CHILD_20_NUM , COMP_CODE      , ANU_BASE_I    , TAXRATE_BASE)    " + "\n");
                sql.append( "                                                                                                   " + "\n");
                sql.append( " SELECT  " + "'" + sPayYymm  + "'                                                                  " + "\n");
                sql.append( "       , " + "'" + sSuppType + "'                                                                  " + "\n");
                sql.append( "       , A.PERSON_NUMB                                                                             " + "\n");
                sql.append( "       , A.DEPT_CODE                                                                               " + "\n");
                sql.append( "       , A.DEPT_NAME                                                                               " + "\n");
                sql.append( "       , A.ABIL_CODE                                                                               " + "\n");
                sql.append( "       , A.POST_CODE                                                                               " + "\n");
                sql.append( "       , A.PAY_CODE                                                                                " + "\n");
                sql.append( "       , A.TAX_CODE                                                                                " + "\n");
                sql.append( "       , A.TAX_CODE2                                                                               " + "\n");
                sql.append( "       , '0' AS EXCEPT_TYPE                                                                        " + "\n");
                sql.append( "       , A.EMPLOY_TYPE                                                                             " + "\n");
                sql.append( "       , " + "'" + sProvDt + "'                                                                    " + "\n");
                sql.append( "       , A.PAY_PROV_FLAG                                                                           " + "\n");
                sql.append( "       , A.OT_KIND                                                                                 " + "\n");
                sql.append( "       , NVL(A.SPOUSE,'N')                                                                         " + "\n");
                sql.append( "       , NVL(A.WOMAN,'N')                                                                          " + "\n");
                sql.append( "       , NVL(A.SUPP_AGED_NUM,0)                                                                    " + "\n");
                sql.append( "       , NVL(A.DEFORM_NUM,0)                                                                       " + "\n");
                sql.append( "       , NVL(A.AGED_NUM,0)                                                                         " + "\n");
                sql.append( "       , A.PENS_GRADE                                                                              " + "\n");
                sql.append( "       , A.MED_GRADE                                                                               " + "\n");
                sql.append( "       , " + "'" + sUserId + "'                                                                    " + "\n");
                sql.append( "       , SYSDATETIME                                                                               " + "\n");
                sql.append( "       , " + "'" + sUserId + "'                                                                    " + "\n");
                sql.append( "       , SYSDATETIME                                                                               " + "\n");
                sql.append( "       , A.DIV_CODE                                                                                " + "\n");
                sql.append( "       , A.SECT_CODE                                                                               " + "\n");
                sql.append( "       , A.MAKE_SALE                                                                               " + "\n");
                sql.append( "       , A.COST_KIND                                                                               " + "\n");
                sql.append( "       , A.PAY_GUBUN                                                                               " + "\n");
                sql.append( "       , A.PAY_GUBUN2                                                                              " + "\n");
                sql.append( "       , A.MED_AVG_I                                                                               " + "\n");
                sql.append( "       , A.CHILD_20_NUM                                                                            " + "\n");
                sql.append( "       , " + "'" + sCompCode + "'                                                                  " + "\n");
                sql.append( "       , A.ANU_BASE_I                                                                              " + "\n");
                sql.append( "       , CASE WHEN A.TAXRATE_BASE IS NULL THEN '2' ELSE A.TAXRATE_BASE END AS TAXRATE_BASE         " + "\n");
//                sql.append( "       , CASE WHEN NVL(A.TAXRATE_BASE, '') = '' THEN '2' ELSE A.TAXRATE_BASE END AS TAXRATE_BASE   " + "\n");
                sql.append( " FROM       HUM100T A                                                                              " + "\n");
                sql.append( " INNER JOIN HAT300T B ON B.COMP_CODE    = A.COMP_CODE                                              " + "\n");
                sql.append( "                     AND B.PERSON_NUMB  = A.PERSON_NUMB                                            " + "\n");
                sql.append( " LEFT  JOIN HPA600T C ON C.COMP_CODE    = B.COMP_CODE                                              " + "\n");
                sql.append( "                     AND C.PAY_YYYYMM   = B.DUTY_YYYYMM                                            " + "\n");
                sql.append( "                     AND C.SUPP_TYPE    = " + "'" + sSuppType + "'                                 " + "\n");
                sql.append( "                     AND C.PERSON_NUMB  = B.PERSON_NUMB                                            " + "\n");
                sql.append( " LEFT  JOIN HBS910T D ON D.COMP_CODE    = B.COMP_CODE                                              " + "\n");
                sql.append( "                     AND D.CLOSE_DATE   = B.DUTY_YYYYMM                                            " + "\n");
                sql.append( "                     AND D.CLOSE_TYPE   = " + "'" + sSuppType + "'                                 " + "\n");
                sql.append( "                     AND D.PERSON_NUMB  = B.PERSON_NUMB                                            " + "\n");
                sql.append( " WHERE A.COMP_CODE                 = " + "'" + sCompCode + "'                                      " + "\n");
                sql.append( " AND   B.DUTY_YYYYMM               = " + "'" + sPayYymm + "'                                       " + "\n");
                sql.append( " AND   NVL(A.PAY_PROV_YN,'N')      = 'Y'                                                           " + "\n");
                sql.append( " AND   NVL(A.PAY_PROV_STOP_YN,'Y') = 'N'                                                           " + "\n");
                sql.append( " AND   C.COMP_CODE IS NULL                                                                         " + "\n");
                sql.append( " AND   D.COMP_CODE IS NULL                                                                         " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

            }  // End of 기초자료생성

            //급여계산시 각종 수당코드를 배열에 만다(row : 374)
            //원소스는 배열을 말아넣고 함수를 호출하나, 함수내에서 아래 select한 내용을 사용하는것은 이후단계이므로, 먼저 함수내 로직부터 처리후 아래쿼리 루프는 이후 처리


            //                ResultSet vRtnHda010 = null;
            ResultSet vRtnHbs000 = null;
            ResultSet vRtnHbs001 = null;
            ResultSet vRtnDayCalcu = null;
            ResultSet vRtnDayCalcu_Rule = null;
            ResultSet TEMP_vRtn = null;
            ResultSet vResult = null;
            ResultSet vrtnEmploy = null;

            String[] sKind01 = null;
            String[] sKind02 = null;

            boolean boolEmployType = false;
            String strfunction = "";

            // 변환시에는 필요없는 구문으로 제거
            // 기본급인지 아니지 구별
            //                sql.setLength(0);
            //                sql.append( " SELECT '1' AS CODE_GUBUN                                " + "\n");
            //                sql.append( "        , A.WAGES_CODE                                     " + "\n");
            //                sql.append( "        , A.WAGES_KIND                                     " + "\n");
            //                sql.append( "        , A.WAGES_SEQ                                      " + "\n");
            //                sql.append( "      , B.RECORD_CNT AS RECORD_CNT                       " + "\n");
            //                sql.append( " FROM HBS300T A                                          " + "\n");
            //                sql.append( " INNER JOIN (                                            " + "\n");
            //                sql.append( "              SELECT COUNT(1) AS RECORD_CNT              " + "\n");
            //                sql.append( "              FROM HBS300T                               " + "\n");
            //                sql.append( "              WHERE COMP_CODE = " + "'" + sCompCode + "' " + "\n");
            //                sql.append( "              AND   CODE_TYPE = '1'                      " + "\n");
            //                sql.append( "            ) B ON 1 = 1                                 " + "\n");
            //                sql.append( " WHERE A.COMP_CODE = " + "'" + sCompCode + "'            " + "\n");
            //                sql.append( " AND   A.CODE_TYPE = '1'                                 " + "\n");
            //
            //                PreparedStatement pstmt1 = conn.prepareStatement(sql.toString());
            //                vRtnHda010 = pstmt1.executeQuery();                               
            //                    
            //                int vRtnHda010_Cnt = 0;
            //                
            //                while(vRtnHda010.next()){
            //                    vRtnHda010_Cnt = Integer.parseInt(vRtnHda010.getString("RECORD_CNT"));
            //                }

            // 계산식
            //                sql.setLength(0);
            //                sql.append( " SELECT SUPP_TYPE                                  " + "\n");
            //                sql.append( "      , OT_KIND_01                                 " + "\n");
            //                sql.append( "      , OT_KIND_02                                 " + "\n");
            //                sql.append( "      , OT_KIND_FULL                               " + "\n");
            //                sql.append( "      , STD_CODE                                   " + "\n");
            //                sql.append( "      , CALCU_SEQ                                  " + "\n");
            //                sql.append( "      , SELECT_VALUE                               " + "\n");
            //                sql.append( "      , TYPE                                       " + "\n");
            //                sql.append( "      , UNIQUE_CODE                                " + "\n");
            //                sql.append( " FROM HBS000T                                      " + "\n");
            //                sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "'        " + "\n");
            //                sql.append( " ORDER BY OT_KIND_01,OT_KIND_02,STD_CODE,CALCU_SEQ " + "\n");
            //
            //                PreparedStatement pstmt1 = conn.prepareStatement(sql.toString());
            //                vRtnHbs000 = pstmt1.executeQuery();                               

            //                // 계산식수당코드를 나눔
            //                sql.setLength(0);
            //                sql.append( " SELECT OT_KIND_01                                  " + "\n");
            //                sql.append( "      , OT_KIND_02                                  " + "\n");
            //                sql.append( "      , OT_KIND_FULL                                " + "\n");
            //                sql.append( "      , STD_CODE                                    " + "\n");
            //                sql.append( "      , CALCU_SEQ                                   " + "\n");
            //                sql.append( "      , SELECT_VALUE                                " + "\n");
            //                sql.append( "      , TYPE                                        " + "\n");
            //                sql.append( "      , UNIQUE_CODE                                 " + "\n");
            //                sql.append( " FROM HBS000T                                       " + "\n");
            //                sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "'         " + "\n");
            //                sql.append( " AND   CALCU_SEQ = '1'                              " + "\n");
            //                sql.append( " AND   SUPP_TYPE = " + "'" + sSuppType + "'         " + "\n");
            //                sql.append( " ORDER BY OT_KIND_01,OT_KIND_02,STD_CODE,CALCU_SEQ  " + "\n");
            //
            //                pstmt1 = conn.prepareStatement(sql.toString());
            //                vRtnHbs001 = pstmt1.executeQuery();                               

            // 중도입사자 지급기준 등록
            sql.setLength(0);
            sql.append( " SELECT PAY_CODE                            " + "\n");
            sql.append( "      , PAY_PROV_FLAG                       " + "\n");
            sql.append( "      , EXCEPT_TYPE                         " + "\n");
            sql.append( "      , WAGES_CODE                          " + "\n");
            sql.append( "      , WORK_DAY                            " + "\n");
            sql.append( "      , PROV_YN                             " + "\n");
            sql.append( "      , DAILY_YN                            " + "\n");
            sql.append( " FROM HBS360T                               " + "\n");
            sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "' " + "\n");

            PreparedStatement pstmt1 = conn.prepareStatement(sql.toString());
            vRtnDayCalcu = pstmt1.executeQuery();                               

            sql.setLength(0);
            sql.append( " SELECT SUB_CODE                            " + "\n");
            sql.append( " FROM BSA100T                               " + "\n");
            sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "' " + "\n");
            sql.append( " AND   MAIN_CODE = 'H147'                   " + "\n");
            sql.append( " AND   REF_CODE1 = 'Y'                      " + "\n");

            pstmt1 = conn.prepareStatement(sql.toString());
            vRtnDayCalcu_Rule = pstmt1.executeQuery();                               

            sql.setLength(0);
            sql.append( " SELECT A.WEL_LEVEL1                                       " + "\n");
            sql.append( "      , A.WEL_LEVEL2                                       " + "\n");
            sql.append( "      , A.WEL_CODE                                         " + "\n");
            sql.append( "      , A.SEQ_NUM                                          " + "\n");
            sql.append( " FROM       HWE010T AS A                                   " + "\n");
            sql.append( " INNER JOIN HUM100T AS V ON V.COMP_CODE   = A.COMP_CODE    " + "\n");
            sql.append( "                        AND V.PERSON_NUMB = A.PERSON_NUMB  " + "\n");
            sql.append( " INNER JOIN HPA600T AS M  ON M.COMP_CODE  = A.COMP_CODE    " + "\n");
            sql.append( "                        AND M.PERSON_NUMB = A.PERSON_NUMB  " + "\n");
            sql.append( "                        AND M.SUPP_TYPE   = A.SUPP_TYPE    " + "\n");
            sql.append( "                        AND M.PAY_YYYYMM  = A.PAY_YYYYMM   " + "\n");
            sql.append( " LEFT  JOIN HBS910T AS D  ON D.COMP_CODE  = M.COMP_CODE    " + "\n");
            sql.append( "                        AND D.CLOSE_DATE  = M.PAY_YYYYMM   " + "\n");
            sql.append( "                        AND D.CLOSE_TYPE  = M.SUPP_TYPE    " + "\n");
            sql.append( "                        AND D.PERSON_NUMB = M.PERSON_NUMB  " + "\n");
            sql.append( " WHERE A.COMP_CODE  = " + "'" + sCompCode + "'             " + "\n");
            sql.append( " AND   A.PAY_YYYYMM = " + "'" + sPayYymm + "'              " + "\n");
            sql.append( " AND   A.SUPP_TYPE  = " + "'" + sSuppType + "'             " + "\n");
            sql.append( " AND   M.COMP_CODE IS NULL                                 " + "\n");

            if(!sCompCode.equals("")){
                sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
            }
            if(!sEmpNo.equals("")){
                sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
            }                
            if(!sPayCd.equals("")){
                sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
            }             
            if(!sOrgCd.equals("")){
                sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
            }
            if(!sTreeFr.equals("")){
                sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
            }       
            if(!sTreeTo.equals("")){
                sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
            }                       
            if(!sPayDayFlag.equals("")){
                sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
            }    

            sql.append( " GROUP BY A.WEL_LEVEL1, A.WEL_LEVEL2, A.WEL_CODE, A.SEQ_NUM " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            TEMP_vRtn = pstmt.executeQuery();    

            while(TEMP_vRtn.next()){
                //RECORD_CNT = Integer.parseInt(rs.getString("RECORD_CNT"));

                //임시테이블에 급여에 반영할 복지금 입력                    
                sql.setLength(0);
                sql.append( " INSERT INTO T_HPA320UKR_1                                               " + "\n");
                sql.append( " (                                                                       " + "\n");
                sql.append( "    KEY_VALUE                                                            " + "\n");
                sql.append( "  , COMP_CODE                                                            " + "\n");
                sql.append( "  , PAY_YYYYMM                                                           " + "\n");
                sql.append( "  , PERSON_NUMB                                                          " + "\n");
                sql.append( "  , SUPP_TYPE                                                            " + "\n");
                sql.append( "  , TAX_I                                                                " + "\n");
                sql.append( "  , NON_TAX_I                                                            " + "\n");
                sql.append( "  , GIVE_I                                                               " + "\n");
                sql.append( "  , WAGES_CODE                                                           " + "\n");
                sql.append( "  , APPLY_YYMM                                                           " + "\n");
                sql.append( "  , PAY_YN                                                               " + "\n");
                sql.append( "  , WEL_LEVEL1                                                           " + "\n");
                sql.append( "  , WEL_LEVEL2                                                           " + "\n");
                sql.append( "  , WEL_CODE                                                             " + "\n");
                sql.append( "  , SEQ_NUM                                                              " + "\n");
                sql.append( " )                                                                       " + "\n");
                sql.append( " SELECT " + "'" + KeyValue + "'                                          " + "\n");
                sql.append( "      , T1.COMP_CODE                                                     " + "\n");
                sql.append( "      , T1.PAY_YYYYMM                                                    " + "\n");
                sql.append( "      , T1.PERSON_NUMB                                                   " + "\n");
                sql.append( "      , T1.SUPP_TYPE                                                     " + "\n");
                sql.append( "      , NVL(T1.TAX_I,0) AS TAX_I                                         " + "\n");
                sql.append( "      , NVL(T1.NON_TAX_I,0)    AS NON_TAX_I                              " + "\n");
                sql.append( "      , NVL(T1.GIVE_I,0)       AS GIVE_I                                 " + "\n");
                sql.append( "      , NVL(T2.WAGES_CODE, '') AS WAGES_CODE                             " + "\n");
                sql.append( "      , T2.APPLY_YYMM                                                    " + "\n");
                sql.append( "      , T2.PAY_YN                                                        " + "\n");
                sql.append( "      , T1.WEL_LEVEL1                                                    " + "\n");
                sql.append( "      , T1.WEL_LEVEL2                                                    " + "\n");
                sql.append( "      , T1.WEL_CODE                                                      " + "\n");
                sql.append( "      , T1.SEQ_NUM                                                       " + "\n");
                sql.append( " FROM       HWE010T AS T1                                                " + "\n");
                sql.append( " LEFT  JOIN HWE100T AS T2  ON T2.COMP_CODE  = T1.COMP_CODE               " + "\n");
                sql.append( "                          AND T2.WEL_LEVEL1 = T1.WEL_LEVEL1              " + "\n");
                sql.append( "                          AND T2.WEL_LEVEL2 = T1.WEL_LEVEL2              " + "\n");
                sql.append( "                          AND T2.WEL_CODE   = T1.WEL_CODE                " + "\n");
                sql.append( "                          AND T2.APPLY_YYMM = T1.APPLY_YYMM              " + "\n");
                sql.append( "                          AND T2.USE_YN     = 'Y'  --사용 한다                                        " + "\n");
                sql.append( "                          AND T2.TAX_CODE   != '4' --기타소득 제외                                  " + "\n");
                sql.append( " WHERE T1.COMP_CODE   = " + "'" + sCompCode + "'                         " + "\n");
                sql.append( " AND   T1.PAY_YYYYMM  = " + "'" + sPayYymm  + "'                         " + "\n");
                sql.append( " AND   T1.WEL_LEVEL1  = " + "'" + TEMP_vRtn.getString("WEL_LEVEL1") + "' " + "\n");
                sql.append( " AND   T1.WEL_LEVEL2  = " + "'" + TEMP_vRtn.getString("WEL_LEVEL2") + "' " + "\n");
                sql.append( " AND   T1.WEL_CODE    = " + "'" + TEMP_vRtn.getString("WEL_CODE") + "'   " + "\n");
                sql.append( " AND   T1.SEQ_NUM     = " + Integer.parseInt(rs.getString("SEQ_NUM")) + "" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();

            }                
            pstmt.close();


            ResultSet vrtnselect = null;

            // 급여계산시 각종 수당코드를 배열에 만다
            sql.setLength(0);
            sql.append( " SELECT '1' AS CODE_TYPE                     " + "\n");
            sql.append( "      , WAGES_SEQ                            " + "\n");
            sql.append( "      , WAGES_CODE                           " + "\n");
            sql.append( "      , WAGES_NAME                           " + "\n");                
            sql.append( " FROM HBS300T                                " + "\n");
            sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "'  " + "\n");
            sql.append( " AND   CODE_TYPE = '1'                       " + "\n");
            sql.append( " AND   USE_YN    = 'Y'                       " + "\n");
            sql.append( " ORDER BY CALCU_SEQ                          " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();                               

            // row : 3305
            while(rs.next()){
                sql.setLength(0);
                sql.append( " DELETE T1                                                              " + "\n");
                sql.append( " FROM            HPA300T AS T1                                          " + "\n");
                sql.append( " INNER JOIN HPA600T AS A  ON T1.COMP_CODE   = A.COMP_CODE               " + "\n");
                sql.append( "                         AND T1.PAY_YYYYMM  = A.PAY_YYYYMM              " + "\n");
                sql.append( "                         AND T1.SUPP_TYPE   = A.SUPP_TYPE               " + "\n");
                sql.append( "                         AND T1.PERSON_NUMB = A.PERSON_NUMB             " + "\n");
                sql.append( " INNER JOIN HUM100T AS V   ON T1.COMP_CODE   = V.COMP_CODE              " + "\n");
                sql.append( "                         AND T1.PERSON_NUMB = V.PERSON_NUMB             " + "\n");
                sql.append( " LEFT  JOIN HBS910T AS D   ON D.COMP_CODE    = A.COMP_CODE              " + "\n");
                sql.append( "                         AND D.CLOSE_DATE   = A.PAY_YYYYMM              " + "\n");
                sql.append( "                         AND D.CLOSE_TYPE   = A.SUPP_TYPE               " + "\n");
                sql.append( "                         AND D.PERSON_NUMB  = A.PERSON_NUMB             " + "\n");
                sql.append( " WHERE T1.PAY_YYYYMM      =  " + "'" + sPayYymm + "'                    " + "\n");
                sql.append( " AND   T1.SUPP_TYPE       =  " + "'" + sSuppType + "'                   " + "\n");
                sql.append( " AND   T1.WAGES_CODE      =  " + "'" + rs.getString("WAGES_CODE") + "'  " + "\n");
                sql.append( " AND   D.COMP_CODE IS NULL                                              " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND A.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND A.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND A.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND A.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND A.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND A.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                // If vRtnHda010.RECORDCOUNT > 0 Then  '수당코드 (row : 3335) 변환시에는 필요없는 조건문으로 제거
                // 고정지급수당이 있을때
                sql.setLength(0);
                sql.append( " INSERT INTO HPA300T                                                                     " + "\n");
                sql.append( " (  PAY_YYYYMM     , SUPP_TYPE      , PERSON_NUMB    , WAGES_CODE     , AMOUNT_I         " + "\n");
                sql.append( "  , COMP_CODE      , INSERT_DB_USER , INSERT_DB_TIME , UPDATE_DB_USER , UPDATE_DB_TIME)  " + "\n");
                sql.append( " SELECT M.PAY_YYYYMM                                                                     " + "\n");
                sql.append( "      , M.SUPP_TYPE                                                                      " + "\n");
                sql.append( "      , M.PERSON_NUMB                                                                    " + "\n");
                sql.append( "      , " + "'" + rs.getString("WAGES_CODE") + "'" + " AS WAGES_CODE                     " + "\n");
                sql.append( "      , AMOUNT_I                                                                         " + "\n");
                sql.append( "      , " + "'" + sCompCode + "'" + "                                                    " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                      " + "\n");
                sql.append( "      , SYSDATETIME                                                                      " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                      " + "\n");
                sql.append( "      , SYSDATETIME                                                                      " + "\n");
                sql.append( " FROM       HUM100T V                                                                    " + "\n");
                sql.append( " INNER JOIN HPA600T M ON M.COMP_CODE   = V.COMP_CODE                                     " + "\n");
                sql.append( "                     AND M.PERSON_NUMB = V.PERSON_NUMB                                   " + "\n");
                sql.append( " INNER JOIN HPA200T A ON A.COMP_CODE   = M.COMP_CODE                                     " + "\n");
                sql.append( "                     AND A.PERSON_NUMB = M.PERSON_NUMB                                   " + "\n");
                sql.append( "                     AND A.PROV_GUBUN  = M.SUPP_TYPE                                     " + "\n");
                sql.append( " LEFT  JOIN HBS910T D  ON D.COMP_CODE   = M.COMP_CODE                                    " + "\n");
                sql.append( "                     AND D.CLOSE_DATE  = M.PAY_YYYYMM                                    " + "\n");
                sql.append( "                     AND D.CLOSE_TYPE  = M.SUPP_TYPE                                     " + "\n");
                sql.append( "                     AND D.PERSON_NUMB = M.PERSON_NUMB                                   " + "\n");
                sql.append( " WHERE M.PAY_YYYYMM                = " + "'" + sPayYymm + "'                             " + "\n");
                sql.append( " AND   M.SUPP_TYPE                 = " + "'" + sSuppType + "'                            " + "\n");
                sql.append( " AND   A.WAGES_CODE                = " + "'" + rs.getString("WAGES_CODE") + "'           " + "\n");
                sql.append( " AND   A.AMOUNT_I                 !=  0                                                  " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_YN,'N')      = 'Y'                                                 " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_STOP_YN,'Y') = 'N'                                                 " + "\n");
                sql.append( " AND   D.COMP_CODE IS NULL                                                               " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                // 고정지급수당 없고 기간지급수당이 있을때
                sql.setLength(0);
                sql.append( " INSERT INTO HPA300T(  COMP_CODE , PAY_YYYYMM     , SUPP_TYPE      , PERSON_NUMB    , WAGES_CODE      " + "\n");
                sql.append( "                     , AMOUNT_I  , INSERT_DB_USER , INSERT_DB_TIME , UPDATE_DB_USER , UPDATE_DB_TIME) " + "\n");
                sql.append( " SELECT " + "'" + sCompCode + "'" + "                                                                 " + "\n");
                sql.append( "      , M.PAY_YYYYMM                                                                                  " + "\n");
                sql.append( "      , M.SUPP_TYPE                                                                                   " + "\n");
                sql.append( "      , M.PERSON_NUMB                                                                                 " + "\n");
                sql.append( "      , " + "'" + rs.getString("WAGES_CODE") + "'" + " AS WAGES_CODE                                  " + "\n");
                sql.append( "      , A.DED_AMOUNT_I AS AMOUNT_I                                                                    " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                                   " + "\n");
                sql.append( "      , SYSDATETIME                                                                                   " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                                   " + "\n");
                sql.append( "      , SYSDATETIME                                                                                   " + "\n");
                sql.append( " FROM       HUM100T V                                                                                 " + "\n");
                sql.append( " INNER JOIN HPA600T M ON M.COMP_CODE   = V.COMP_CODE                                                  " + "\n");
                sql.append( "                     AND M.PERSON_NUMB = V.PERSON_NUMB                                                " + "\n");
                sql.append( " INNER JOIN HPA700T A ON A.COMP_CODE   = M.COMP_CODE                                                  " + "\n");
                sql.append( "                     AND A.PERSON_NUMB = M.PERSON_NUMB                                                " + "\n");
                sql.append( "                     AND A.SUPP_TYPE   = M.SUPP_TYPE                                                  " + "\n");
                sql.append( "                     AND A.PROV_GUBUN  = '1'                                                          " + "\n");
                sql.append( " LEFT  JOIN HPA200T B  ON B.COMP_CODE  = M.COMP_CODE                                                  " + "\n");
                sql.append( "                     AND B.PERSON_NUMB = M.PERSON_NUMB                                                " + "\n");
                sql.append( "                     AND B.PROV_GUBUN  = '1'                                                          " + "\n");
                sql.append( "                     AND B.AMOUNT_I   != 0                                                            " + "\n");
                sql.append( "                     AND B.WAGES_CODE  = A.WAGES_CODE                                                 " + "\n");
                sql.append( " LEFT  JOIN HBS910T D ON D.COMP_CODE   = M.COMP_CODE                                                  " + "\n");
                sql.append( "                     AND D.CLOSE_DATE  = M.PAY_YYYYMM                                                 " + "\n");
                sql.append( "                     AND D.CLOSE_TYPE  = M.SUPP_TYPE                                                  " + "\n");
                sql.append( "                     AND D.PERSON_NUMB = M.PERSON_NUMB                                                " + "\n");
                sql.append( " WHERE A.SUPP_TYPE                 = " + "'" + sSuppType + "'                                         " + "\n");
                sql.append( " AND   A.PROV_GUBUN                = '1'                                                              " + "\n");
                sql.append( " AND   A.WAGES_CODE                = " + "'" + rs.getString("WAGES_CODE") + "'                        " + "\n");
                sql.append( " AND   A.DED_AMOUNT_I             != 0                                                                " + "\n");
                sql.append( " AND   M.PAY_YYYYMM                = " + "'" + sPayYymm + "'                                          " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_YN,'N')      = 'Y'                                                              " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_STOP_YN,'Y') = 'N'                                                              " + "\n");
                sql.append( " AND  ((A.PAY_FR_YYYYMM <= " + "'" + sPayYymm + "')                                                   " + "\n");
                sql.append( " AND   (A.PAY_TO_YYYYMM >= " + "'" + sPayYymm + "'))                                                  " + "\n");
                sql.append( " AND   B.COMP_CODE IS NULL                                                                            " + "\n");
                sql.append( " AND   D.COMP_CODE IS NULL                                                                            " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                // 고정,기간지급수당 없고 복지금지급수당이 있을때
                sql.setLength(0);
                sql.append( " INSERT INTO HPA300T(  COMP_CODE      , PAY_YYYYMM     , SUPP_TYPE      , PERSON_NUMB    , WAGES_CODE       " + "\n");
                sql.append( "                     , AMOUNT_I       , INSERT_DB_USER , INSERT_DB_TIME , UPDATE_DB_USER , UPDATE_DB_TIME)  " + "\n");
                sql.append( " SELECT " + "'" + sCompCode + "'" + "                                                                       " + "\n");
                sql.append( "      , M.PAY_YYYYMM                                                                                        " + "\n");
                sql.append( "      , M.SUPP_TYPE                                                                                         " + "\n");
                sql.append( "      , M.PERSON_NUMB                                                                                       " + "\n");
                sql.append( "      , " + "'" + rs.getString("WAGES_CODE") + "'" + " AS WAGES_CODE                                        " + "\n");
                sql.append( "      , A.GIVE_I AS AMOUNT_I                                                                                " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                                         " + "\n");
                sql.append( "      , SYSDATETIME                                                                                         " + "\n");
                sql.append( "      , " + "'" + sUserId + "'" + "                                                                         " + "\n");
                sql.append( "      , SYSDATETIME                                                                                         " + "\n");
                sql.append( " FROM       HUM100T     V                                                                                   " + "\n");
                sql.append( " INNER JOIN HPA600T     M  ON V.COMP_CODE   = M.COMP_CODE                                                   " + "\n");
                sql.append( "                          AND V.PERSON_NUMB = M.PERSON_NUMB                                                 " + "\n");
                sql.append( " INNER JOIN (                                                                                               " + "\n");
                sql.append( "              SELECT COMP_CODE                                                                              " + "\n");
                sql.append( "                   , PAY_YYYYMM                                                                             " + "\n");
                sql.append( "                   , PERSON_NUMB                                                                            " + "\n");
                sql.append( "                   , SUPP_TYPE                                                                              " + "\n");
                sql.append( "                   , SUM(NVL(GIVE_I,0)) GIVE_I                                                              " + "\n");
                sql.append( "                   , WAGES_CODE                                                                             " + "\n");
                sql.append( "              FROM T_HPA320UKR_1                                                                            " + "\n");
                sql.append( "              WHERE COMP_CODE   = " + "'" + sCompCode + "'                                                  " + "\n");
                sql.append( "              AND   WAGES_CODE  = " + "'" + rs.getString("WAGES_CODE") + "'                                 " + "\n");
                sql.append( "              AND   GIVE_I     != 0                                                                         " + "\n");
                sql.append( "              AND   PAY_YN      = 'Y'                                                                       " + "\n");
                sql.append( "              AND   WAGES_CODE IS NOT NULL                                                                  " + "\n");
                sql.append( "              AND   KEY_VALUE   = " + "'" + KeyValue + "'                                                   " + "\n");
                sql.append( "              GROUP BY COMP_CODE, PAY_YYYYMM, PERSON_NUMB, WAGES_CODE, SUPP_TYPE                            " + "\n");
                sql.append( "            ) A  ON M.COMP_CODE   = A.COMP_CODE                                                             " + "\n");
                sql.append( "                AND M.PAY_YYYYMM  = A.PAY_YYYYMM                                                            " + "\n");
                sql.append( "                AND M.PERSON_NUMB = A.PERSON_NUMB                                                           " + "\n");
                sql.append( "                AND M.SUPP_TYPE   = A.SUPP_TYPE                                                             " + "\n");
                sql.append( " LEFT  JOIN HBS910T D    ON D.COMP_CODE   = M.COMP_CODE                                                     " + "\n");
                sql.append( "                        AND D.CLOSE_DATE  = M.PAY_YYYYMM                                                    " + "\n");
                sql.append( "                        AND D.CLOSE_TYPE  = M.SUPP_TYPE                                                     " + "\n");
                sql.append( "                        AND D.PERSON_NUMB = M.PERSON_NUMB                                                   " + "\n");
                sql.append( " WHERE M.COMP_CODE                 = " + "'" + sCompCode + "'                                               " + "\n");
                sql.append( " AND   M.PAY_YYYYMM                = " + "'" + sPayYymm + "'                                                " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_YN,'')       = 'Y'                                                                    " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_STOP_YN,'Y') = ''                                                                     " + "\n");
                sql.append( " AND   A.PERSON_NUMB NOT IN (                                                                               " + "\n");
                sql.append( "                              SELECT X.PERSON_NUMB                                                          " + "\n");
                sql.append( "                              FROM (                                                                        " + "\n");
                sql.append( "                                    SELECT PERSON_NUMB                                                      " + "\n");
                sql.append( "                                    FROM HPA200T                                                            " + "\n");
                sql.append( "                                    WHERE COMP_CODE   = " + "'" + sCompCode + "'                            " + "\n");
                sql.append( "                                    AND   WAGES_CODE  = " + "'" + rs.getString("WAGES_CODE") + "'           " + "\n");
                sql.append( "                                    AND   AMOUNT_I   != 0                                                   " + "\n");
                sql.append( "                                                                                                            " + "\n");
                sql.append( "                                    UNION ALL                                                               " + "\n");
                sql.append( "                                                                                                            " + "\n");
                sql.append( "                                    SELECT PERSON_NUMB                                                      " + "\n");
                sql.append( "                                    FROM HPA700T                                                            " + "\n");
                sql.append( "                                    WHERE COMP_CODE   = " + "'" + sCompCode + "'                            " + "\n");
                sql.append( "                                    AND SUPP_TYPE     = " + "'" + sSuppType + "'                            " + "\n");
                sql.append( "                                    AND PROV_GUBUN    = '1'                                                 " + "\n");
                sql.append( "                                    AND WAGES_CODE    = " + "'" + rs.getString("WAGES_CODE") + "'           " + "\n");
                sql.append( "                                    AND ((PAY_FR_YYYYMM <= " + "'" + sPayYymm + "')                         " + "\n");
                sql.append( "                                     AND (PAY_TO_YYYYMM >= " + "'" + sPayYymm + "'))                        " + "\n");
                sql.append( "                                   ) X                                                                      " + "\n");
                sql.append( "                             )                                                                              " + "\n");
                sql.append( " AND D.COMP_CODE IS NULL                                                                                    " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();


                // 급여에 반영된 복지금 급여반영 처리로 UPDATE
                sql.setLength(0);
                sql.append( " SELECT A.PERSON_NUMB, A.WEL_LEVEL1, A.WEL_LEVEL2, A.WEL_CODE, A.SEQ_NUM                            " + "\n");
                sql.append( " FROM       HUM100T     V                                                                           " + "\n");
                sql.append( " INNER JOIN HPA600T     M ON V.COMP_CODE   = M.COMP_CODE                                            " + "\n");
                sql.append( "                  AND V.PERSON_NUMB = M.PERSON_NUMB                                                 " + "\n");
                sql.append( " INNER JOIN (                                                                                       " + "\n");
                sql.append( "             SELECT COMP_CODE                                                                       " + "\n");
                sql.append( "                  , PAY_YYYYMM                                                                      " + "\n");
                sql.append( "                  , PERSON_NUMB                                                                     " + "\n");
                sql.append( "                  , SUPP_TYPE                                                                       " + "\n");
                sql.append( "                  , WAGES_CODE                                                                      " + "\n");
                sql.append( "                  , WEL_LEVEL1                                                                      " + "\n");
                sql.append( "                  , WEL_LEVEL2                                                                      " + "\n");
                sql.append( "                  , WEL_CODE                                                                        " + "\n");
                sql.append( "                  , SEQ_NUM                                                                         " + "\n");
                sql.append( "             FROM T_HPA320UKR_1                                                                     " + "\n");
                sql.append( "             WHERE COMP_CODE   = " + "'" + sCompCode + "'" + "                                      " + "\n");
                sql.append( "             AND   WAGES_CODE  = " + "'" + rs.getString("WAGES_CODE") + "'                          " + "\n");
                sql.append( "             AND   GIVE_I     != 0                                                                  " + "\n");
                sql.append( "             AND   PAY_YN      = 'Y'                                                                " + "\n");
                sql.append( "             AND   WAGES_CODE IS NOT NULL                                                           " + "\n");
//                sql.append( "             AND   WAGES_CODE != ''                                                                 " + "\n");
                sql.append( "             AND   KEY_VALUE   = " + "'" + KeyValue + "'" + "                                       " + "\n");
                sql.append( "             GROUP BY COMP_CODE, PERSON_NUMB, WAGES_CODE                                            " + "\n");
                sql.append( "                    , WEL_LEVEL1, WEL_LEVEL2, WEL_CODE                                              " + "\n");
                sql.append( "                    , PAY_YYYYMM, SUPP_TYPE, SEQ_NUM                                                " + "\n");
                sql.append( "            ) A  ON M.COMP_CODE   = A.COMP_CODE                                                     " + "\n");
                sql.append( "                AND M.PAY_YYYYMM  = A.PAY_YYYYMM                                                    " + "\n");
                sql.append( "                AND M.PERSON_NUMB = A.PERSON_NUMB                                                   " + "\n");
                sql.append( "                AND M.SUPP_TYPE   = A.SUPP_TYPE                                                     " + "\n");
                sql.append( " LEFT  JOIN HBS910T D ON D.COMP_CODE   = M.COMP_CODE                                                " + "\n");
                sql.append( "                     AND D.CLOSE_DATE  = M.PAY_YYYYMM                                               " + "\n");
                sql.append( "                     AND D.CLOSE_TYPE  = M.SUPP_TYPE                                                " + "\n");
                sql.append( "                     AND D.PERSON_NUMB = M.PERSON_NUMB                                              " + "\n");
                sql.append( " WHERE M.COMP_CODE                 = " + "'" + sCompCode + "'                                       " + "\n");
                sql.append( " AND   M.PAY_YYYYMM                = " + "'" + sPayYymm + "'                                        " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_YN,'N')      = 'Y'                                                            " + "\n");
                sql.append( " AND   NVL(V.PAY_PROV_STOP_YN,'Y') = 'N'                                                            " + "\n");
                sql.append( " AND   A.PERSON_NUMB NOT IN (                                                                       " + "\n");
                sql.append( "                            SELECT X.PERSON_NUMB                                                    " + "\n");
                sql.append( "                            FROM (                                                                  " + "\n");
                sql.append( "                                   SELECT PERSON_NUMB                                               " + "\n");
                sql.append( "                                   FROM HPA200T                                                     " + "\n");
                sql.append( "                                   WHERE COMP_CODE  =  " + "'" + sCompCode + "'                     " + "\n");
                sql.append( "                                   AND WAGES_CODE   =  " + "'" + rs.getString("WAGES_CODE") + "'    " + "\n");
                sql.append( "                                   AND AMOUNT_I    != 0                                             " + "\n");
                sql.append( "                                                                                                    " + "\n");
                sql.append( "                                   UNION ALL                                                        " + "\n");
                sql.append( "                                                                                                    " + "\n");
                sql.append( "                                     SELECT PERSON_NUMB                                               " + "\n");
                sql.append( "                                     FROM HPA700T                                                     " + "\n");
                sql.append( "                                     WHERE COMP_CODE      = " + "'" + sCompCode + "'                  " + "\n");
                sql.append( "                                     AND SUPP_TYPE        = " + "'" + sSuppType + "'                  " + "\n");
                sql.append( "                                     AND PROV_GUBUN       = '1'                                       " + "\n");
                sql.append( "                                     AND WAGES_CODE       = " + "'" + rs.getString("WAGES_CODE") + "' " + "\n");
                sql.append( "                                     AND ((PAY_FR_YYYYMM <= " + "'" + sPayYymm + "')                  " + "\n");
                sql.append( "                                     AND (PAY_TO_YYYYMM  >= " + "'" + sPayYymm + "'))                 " + "\n");
                sql.append( "                                  )X                                                                " + "\n");
                sql.append( "                          )                                                                         " + "\n");
                sql.append( " AND D.COMP_CODE IS NULL                                                                            " + "\n");

                if(!sCompCode.equals("")){
                    sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                }
                if(!sEmpNo.equals("")){
                    sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                }                
                if(!sPayCd.equals("")){
                    sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                }             
                if(!sOrgCd.equals("")){
                    sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                }
                if(!sTreeFr.equals("")){
                    sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                }       
                if(!sTreeTo.equals("")){
                    sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                }                       
                if(!sPayDayFlag.equals("")){
                    sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                }    

                pstmt = conn.prepareStatement(sql.toString());
                vrtnselect = pstmt.executeQuery();

                while(vrtnselect.next()){
                    //RECORD_CNT = Integer.parseInt(rs.getString("RECORD_CNT"));
                    sql.setLength(0);
                    sql.append( " UPDATE HWE010T                                                         " + "\n");
                    sql.append( " SET PAY_APPLY_YN = 'Y'                                                 " + "\n");
                    sql.append( " WHERE COMP_CODE   = " + "'" + sCompCode + "'                           " + "\n");
                    sql.append( " AND   PAY_YYYYMM  = " + "'" + sPayYymm + "'                            " + "\n");
                    sql.append( " AND   PERSON_NUMB = " + "'" + vrtnselect.getString("PERSON_NUMB") + "' " + "\n");
                    sql.append( " AND   WEL_LEVEL1  = " + "'" + vrtnselect.getString("WEL_LEVEL1") + "'  " + "\n");
                    sql.append( " AND   WEL_LEVEL2  = " + "'" + vrtnselect.getString("WEL_LEVEL2") + "'  " + "\n");
                    sql.append( " AND   WEL_CODE    = " + "'" + vrtnselect.getString("WEL_CODE") + "'    " + "\n");
                    sql.append( " AND   SEQ_NUM     = " + vrtnselect.getString("WEL_CODE")                 + "\n");

                    pstmt = conn.prepareStatement(sql.toString());
                    pstmt.execute();
                    pstmt.close();
                }

                // 계산식수당코드를 나눔 (row : 3561)
                sql.setLength(0);
                sql.append( " SELECT OT_KIND_01                                          " + "\n");
                sql.append( "      , OT_KIND_02                                          " + "\n");
                sql.append( "      , OT_KIND_FULL                                        " + "\n");
                sql.append( "      , STD_CODE                                            " + "\n");
                sql.append( "      , CALCU_SEQ                                           " + "\n");
                sql.append( "      , SELECT_VALUE                                        " + "\n");
                sql.append( "      , TYPE                                                " + "\n");
                sql.append( "      , UNIQUE_CODE                                         " + "\n");
                sql.append( " FROM HBS000T                                               " + "\n");
                sql.append( " WHERE COMP_CODE = " + "'" + sCompCode + "'                 " + "\n");
                sql.append( " AND   CALCU_SEQ = '1'                                      " + "\n");
                sql.append( " AND   SUPP_TYPE = " + "'" + sSuppType + "'                 " + "\n");
                sql.append( " AND   STD_CODE = " + "'" + rs.getString("WAGES_CODE") + "' " + "\n");
                sql.append( " ORDER BY OT_KIND_01,OT_KIND_02,STD_CODE,CALCU_SEQ          " + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                vRtnHbs001 = pstmt.executeQuery();         

                String strWhere = "";

                while(vRtnHbs001.next()){

                    sql.setLength(0);
                    sql.append( " SELECT M.PERSON_NUMB                                                                              " + "\n");
                    sql.append( "      , M.EXCEPT_TYPE                                                                              " + "\n");
                    sql.append( "      , M.OT_KIND                                                                                  " + "\n");
                    sql.append( "      , V.JOIN_DATE                                                                                " + "\n");
                    sql.append( "      , V.PAY_CODE                                                                                 " + "\n");
                    sql.append( "      , N.WORK_DAY                                                                                 " + "\n");
                    sql.append( "      , N.TOT_DAY                                                                                  " + "\n");
                    sql.append( "      , M.PAY_YYYYMM                                                                               " + "\n");
                    sql.append( "      , V.RETR_DATE                                                                                " + "\n");
                    sql.append( "      , V.PAY_PROV_FLAG                                                                            " + "\n");
                    sql.append( "      , V.TRIAL_TERM_END_DATE                                                                      " + "\n");
                    sql.append( " FROM       HPA600T M                                                                              " + "\n");
                    sql.append( " INNER JOIN HUM100T V  ON M.COMP_CODE   = V.COMP_CODE                                              " + "\n");
                    sql.append( "                      AND M.PERSON_NUMB = V.PERSON_NUMB                                            " + "\n");
                    sql.append( " INNER JOIN HAT300T N  ON M.COMP_CODE   = N.COMP_CODE                                              " + "\n");
                    sql.append( "                      AND M.PAY_YYYYMM  = N.DUTY_YYYYMM                                            " + "\n");
                    sql.append( "                      AND M.PERSON_NUMB = N.PERSON_NUMB                                            " + "\n");
                    sql.append( " LEFT  JOIN HBS910T D  ON D.COMP_CODE   = M.COMP_CODE                                              " + "\n");
                    sql.append( "                      AND D.CLOSE_DATE  = M.PAY_YYYYMM                                             " + "\n");
                    sql.append( "                      AND D.CLOSE_TYPE  = M.SUPP_TYPE                                              " + "\n");
                    sql.append( "                      AND D.PERSON_NUMB = M.PERSON_NUMB                                            " + "\n");
                    sql.append( " WHERE M.PAY_YYYYMM                    = " + "'" + sPayYymm + "'                                   " + "\n");
                    sql.append( " AND   M.SUPP_TYPE                     = " + "'" + sSuppType + "'                                  " + "\n");
                    sql.append( " AND   M.PERSON_NUMB NOT IN (                                                                      " + "\n");
                    sql.append( "                              SELECT A.PERSON_NUMB                                                 " + "\n");
                    sql.append( "                              FROM (                                                               " + "\n");
                    sql.append( "                                     SELECT PERSON_NUMB                                            " + "\n");
                    sql.append( "                                     FROM HPA200T                                                  " + "\n");
                    sql.append( "                                     WHERE COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
                    sql.append( "                                     AND   WAGES_CODE  = " + "'" + rs.getString("WAGES_CODE") + "' " + "\n");
                    sql.append( "                                     AND   AMOUNT_I   != 0                                         " + "\n");
                    sql.append( "                                                                                                   " + "\n");
                    sql.append( "                                     UNION ALL                                                     " + "\n");
                    sql.append( "                                                                                                   " + "\n");
                    sql.append( "                                     SELECT PERSON_NUMB                                            " + "\n");
                    sql.append( "                                     FROM HPA700T                                                  " + "\n");
                    sql.append( "                                     WHERE COMP_CODE  = " + "'" + sCompCode + "'                   " + "\n");
                    sql.append( "                                     AND   SUPP_TYPE  = " + "'" + sSuppType + "'                   " + "\n");
                    sql.append( "                                     AND   PROV_GUBUN = '1'                                        " + "\n");
                    sql.append( "                                     AND   WAGES_CODE = " + "'" + rs.getString("WAGES_CODE") + "'  " + "\n");
                    sql.append( "                                     AND  ((PAY_FR_YYYYMM <= " + "'" + sPayYymm + "')              " + "\n");
                    sql.append( "                                     AND   (PAY_TO_YYYYMM >= " + "'" + sPayYymm + "'))             " + "\n");
                    sql.append( "                                                                                                   " + "\n");
                    sql.append( "                                     UNION ALL                                                     " + "\n");
                    sql.append( "                                                                                                   " + "\n");
                    sql.append( "                                     SELECT PERSON_NUMB                                            " + "\n");
                    sql.append( "                                     FROM T_HPA320UKR_1                                            " + "\n");
                    sql.append( "                                     WHERE COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
                    sql.append( "                                     AND   WAGES_CODE  = " + "'" + rs.getString("WAGES_CODE") + "' " + "\n");
                    sql.append( "                                     AND   GIVE_I     != 0                                         " + "\n");
                    sql.append( "                                     AND   PAY_YN      = 'Y'                                       " + "\n");
                    sql.append( "                                     AND   KEY_VALUE   = " + "'" + KeyValue + "'                   " + "\n");
                    sql.append( "                                   ) A                                                             " + "\n");
                    sql.append( "                             )                                                                     " + "\n");
                    sql.append( " AND NVL(V.PAY_PROV_YN,'N')       = 'Y'                                                            " + "\n");
                    sql.append( " AND NVL(V.PAY_PROV_STOP_YN,'Y')  = 'N'                                                            " + "\n");
                    sql.append( " AND D.COMP_CODE IS NULL                                                                           " + "\n");

                    if(!sCompCode.equals("")){
                        sql.append( " AND M.COMP_CODE = " + "'" + sCompCode    + "'" + "\n");
                    }
                    if(!sEmpNo.equals("")){
                        sql.append( " AND M.PERSON_NUMB = " + "'" + sEmpNo    + "'" + "\n");
                    }                
                    if(!sPayCd.equals("")){
                        sql.append( " AND M.PAY_CODE = " + "'" + sPayCd    + "'" + "\n");
                    }             
                    if(!sOrgCd.equals("")){
                        sql.append( " AND V.DIV_CODE = " + "'" + sOrgCd    + "'" + "\n");
                    }
                    if(!sTreeFr.equals("")){
                        sql.append( " AND M.DEPT_CODE >= " + "'" + sTreeFr    + "'" + "\n");
                    }       
                    if(!sTreeTo.equals("")){
                        sql.append( " AND M.DEPT_CODE <= " + "'" + sTreeTo    + "'" + "\n");
                    }                       
                    if(!sPayDayFlag.equals("")){
                        sql.append( " AND M.PAY_PROV_FLAG = " + "'" + sPayDayFlag    + "'" + "\n");
                    }


                    /*
                        //trWhere = fnCalcuSql(vRtnHbs001("OT_KIND_01"), vRtnHbs001("OT_KIND_02"), "v")
                     */

                    strWhere = fnCalcuSql(vRtnHbs001.getString("OT_KIND_01"),vRtnHbs001.getString("OT_KIND_02"),"v");

                    if(!strWhere.equals("")){
                        sql.append(strWhere + "\n");
                    }

                    pstmt = conn.prepareStatement(sql.toString());
                    vrtnselect = pstmt.executeQuery();      

                    //vResult = fnMakeArray(conn, bParam);
                    //                            dParam[0]  = "201601";
                    //                            dParam[1]  = "1";
                    //                            dParam[15] = sCompCode;
                    //                            vrtnEmploy = fnHat600F(conn, dParam);
                    // row : 3630
                    while(vrtnselect.next()){
                        vResult = null;

                        vResult = fnMakeArray(conn, bParam);

                        // filter 대신 직접 쿼리
                        sql.setLength(0);
                        sql.append( " SELECT SUPP_TYPE                                                     " + "\n");
                        sql.append( "      , OT_KIND_01                                                    " + "\n");
                        sql.append( "      , OT_KIND_02                                                    " + "\n");
                        sql.append( "      , OT_KIND_FULL                                                  " + "\n");
                        sql.append( "      , STD_CODE                                                      " + "\n");
                        sql.append( "      , CALCU_SEQ                                                     " + "\n");
                        sql.append( "      , SELECT_VALUE                                                  " + "\n");
                        sql.append( "      , TYPE                                                          " + "\n");
                        sql.append( "      , UNIQUE_CODE                                                   " + "\n");
                        sql.append( " FROM HBS000T                                                         " + "\n");
                        sql.append( " WHERE COMP_CODE  = " + "'" + sCompCode + "'                          " + "\n");
                        sql.append( " AND   STD_CODE   = " + "'" + rs.getString("WAGES_CODE") + "'         " + "\n");
                        sql.append( " AND   OT_KIND_01 = " + "'" + vRtnHbs001.getString("OT_KIND_01") + "' " + "\n");
                        sql.append( " AND   OT_KIND_02 = " + "'" + vRtnHbs001.getString("OT_KIND_02") + "' " + "\n");
                        sql.append( " AND   SUPP_TYPE  = " + "'" + sSuppType + "'                          " + "\n");
                        sql.append( " ORDER BY OT_KIND_01,OT_KIND_02,STD_CODE,CALCU_SEQ                    " + "\n");

                        pstmt = conn.prepareStatement(sql.toString());
                        vRtnHbs000 = pstmt.executeQuery();        

                        while(vRtnHbs000.next()){                           
                            sKind01 = null;
                            sKind02 = null;

                            // row : 3642
                            sKind01 = vRtnHbs001.getString("OT_KIND_01").split("/");
                            sKind02 = vRtnHbs001.getString("OT_KIND_02").split("/");
                        }



                        // 수습사원의 수당 일할계산 체크
                        for (int i = 0; i < sKind01.length; i++) {
                            if(sKind01[i].equals("EMPLOY_TYPE") && sKind02[i].equals("2")) {
                                dParam[0]  = vrtnselect.getString("PAY_YYYYMM");
                                dParam[1]  = vrtnselect.getString("PAY_PROV_FLAG");
                                dParam[15] = sCompCode;

                                // 급여기간 중 수습이 종료되는 것을 체크
                                vrtnEmploy = fnHat600F(conn, dParam);

                                while(vrtnEmploy.next()){                           
                                    if((vrtnEmploy.getInt("STRT_DT") <= vrtnselect.getInt("TRIAL_TERM_END_DATE")) 
                                            && (vrtnEmploy.getInt("END_DT") >= vrtnselect.getInt("TRIAL_TERM_END_DATE"))
                                            && (!vrtnselect.getString("TRIAL_TERM_END_DATE").equals(""))
                                            ){
                                        boolEmployType = true;
                                        break;                                           
                                    } else if ((vrtnEmploy.getInt("END_DT") > vrtnselect.getInt("TRIAL_TERM_END_DATE")) 
                                            && (!vrtnselect.getString("TRIAL_TERM_END_DATE").equals(""))
                                            ){
                                        //수습기간이 지났을 경우 수습기간과 정규사원기간의 배열변수를 1, 0으로 셋팅
                                        vRtnPriod[0] = 0;
                                        vRtnPriod[1] = 1;
                                        boolEmployType = true;
                                        break;
                                    } else {
                                        boolEmployType = false;
                                    }
                                }  // End of while   
                            } else {
                                boolEmployType = false;
                            }
                        }  // End of For

                        // row : 3670 (변환 중단, 계산식 사용하지 않는 SP제공받음으로인함)      

                        vRtnHbs000.beforeFirst();



                        while(vRtnHbs000.next()){                           
                            switch(vRtnHbs000.getString("TYPE")){
                            case "2" : case "3" : case "5" : case "11" :
                                strfunction = strfunction + "" + fnFetch(conn, bParam, vrtnselect.getString("PERSON_NUMB"), vRtnHbs000.getString("UNIQUE_CODE"));
                            case "9" :
                                strfunction = strfunction + "" + vResult.getString(vRtnHbs000.getString("UNIQUE_CODE"));
                            case "8" :
                                strfunction = strfunction + "" + vResult.getString(vRtnHbs000.getString("UNIQUE_CODE"));
                            default :
                                strfunction = strfunction + "" + vRtnHbs000.getString("SELECT_VALUE");
                            }


                        }



                    }

                }




            }

            pstmt.close();



            //---------------------------------------------------------------------------------------------------------
            pstmt1.close();
            rs.close();
            conn.setAutoCommit(true);
            return sRtn;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return "";   

        }
    }

    private static String fnCalcuSql(String OT_KIND_01, String OT_KIND_02, String TableName){
        String[] hKind01 = null;
        String[] hKind02 = null;
        String wSql = "";

        hKind01 = OT_KIND_01.split("/");
        hKind02 = OT_KIND_02.split("/");

        for (int i = 0; i < hKind01.length; i++) {
            //    System.out.format("array[%d] = %s%n", i, hKind01[i]);
            wSql = wSql + " AND " + TableName + "." + hKind01[i] + " = " + "'" + hKind02[i] + "'" + "\n";
        }

        return wSql;
    }

    private static ResultSet fnMakeArray(Connection conn, String[] bParam) throws SQLException{

        ResultSet vRtn = null;
        StringBuffer sql = new StringBuffer();
        String strArray = "";

        sql.setLength(0);
        sql.append( " SELECT DISTINCT SELECT_VALUE                   " + "\n");
        sql.append( "      , SELECT_NAME                             " + "\n");
        sql.append( "      , RTRIM(SELECT_SYNTAX) AS SELECT_SYNTAX   " + "\n");
        sql.append( "      , UNIQUE_CODE                             " + "\n");
        sql.append( " FROM HBS000T                                   " + "\n");
        sql.append( " WHERE COMP_CODE  = " + "'" + bParam[0] + "'    " + "\n");
        sql.append( " AND   SUPP_TYPE  = " + "'" + bParam[11] + "'   " + "\n");
        sql.append( " AND   TYPE IN ('2','3','5','11')               " + "\n");

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            vRtn = pstmt.executeQuery();

            strArray = "SELECT M.COMP_CODE, M.PERSON_NUMB" + "\n";

            String sSyn = "";
            String sValue = "";
            String sUniqueCode = "";

            while(vRtn.next()){
                sSyn = vRtn.getString("SELECT_SYNTAX").replace("\"", "");
                sValue = vRtn.getString("SELECT_VALUE").replace("\"", "");
                sUniqueCode = vRtn.getString("UNIQUE_CODE").replace("\"", "");

                strArray = strArray + ", NVL((" + sSyn;

                if(sSyn.substring(sSyn.replace("/[ ]*$/g", "").length()-1, sSyn.replace("/[ ]*$/g", "").length()).equals("=")){
                    strArray = strArray + "'" + sValue + "'), 0) AS " + sUniqueCode + "\n";                       
                } else {

                    strArray = strArray + "), 0) AS " + sUniqueCode + "\n";
                }    
            }
            strArray = strArray + "FROM       HPA600T M                                                                 " + "\n";
            strArray = strArray + "INNER JOIN HUM100T V  ON M.COMP_CODE    = V.COMP_CODE                                " + "\n";
            strArray = strArray + "                     AND M.PERSON_NUMB  = V.PERSON_NUMB                              " + "\n";
            strArray = strArray + "LEFT  JOIN BSA100T M2 ON M2.COMP_CODE   = V.COMP_CODE                                " + "\n";
            strArray = strArray + "                     AND M2.MAIN_CODE   = 'H032'                                     " + "\n";
            strArray = strArray + "                     AND (M2.SUB_CODE   = M.SUPP_TYPE OR M2.REF_CODE1 = M.SUPP_TYPE) " + "\n";
            strArray = strArray + "WHERE M.PAY_YYYYMM = " + "'" + bParam[1]  + "'                                       " + "\n";
            strArray = strArray + "AND   M2.SUB_CODE  = " + "'" + bParam[11] + "'                                       " + "\n"; 

            if(!bParam[0].equals("")){
                strArray = strArray + " AND M.COMP_CODE = " + "'" + bParam[0]    + "'" + "\n";
            }
            if(!bParam[10].equals("")){
                strArray = strArray + " AND M.PERSON_NUMB = " + "'" + bParam[10]    + "'" + "\n";
            }                
            if(!bParam[6].equals("")){
                strArray = strArray + " AND M.PAY_CODE = " + "'" + bParam[6]    + "'" + "\n";
            }             
            if(!bParam[3].equals("")){
                strArray = strArray + " AND V.DIV_CODE = " + "'" + bParam[3]    + "'" + "\n";
            }
            if(!bParam[4].equals("")){
                strArray = strArray + " AND M.DEPT_CODE >= " + "'" + bParam[4]    + "'" + "\n";
            }       
            if(!bParam[5].equals("")){
                strArray = strArray + " AND M.DEPT_CODE <= " + "'" + bParam[5]    + "'" + "\n";
            }                       
            if(!bParam[7].equals("")){
                strArray = strArray + " AND M.PAY_PROV_FLAG = " + "'" + bParam[7]    + "'" + "\n";
            }

            // HBS000T 의 쿼리를 큐브리도로 변환해야함....(기준이되는 계산식 쿼리)

            pstmt = conn.prepareStatement(strArray);
            vRtn = pstmt.executeQuery();

            //pstmt.close();

        } catch (SQLException e) {
            throw e;
        }


        return vRtn;
    }

    // 지급차수에 따른 날짜 가져오기
    private static ResultSet fnHat600F(Connection conn, String[] bParam) throws SQLException{

        ResultSet vRtn = null;
        StringBuffer sql = new StringBuffer();

        sql.setLength(0);
        sql.append( " SELECT F.SUB_CODE                                                                                                                    " + "\n");
        sql.append( "      , CASE F.REF_CODE2 WHEN '00' THEN TO_CHAR(" + "'" + bParam[0] + "' + '01')                                                      " + "\n");
        sql.append( "                         ELSE ADDDATE(ADDDATE(" + "'" + bParam[0] + "' + F.REF_CODE2,  INTERVAL -1 MONTH), INTERVAL 1 DAY)            " + "\n");
        sql.append( "        END STRT_DT                                                                                                                   " + "\n");
        sql.append( "      , CASE F.REF_CODE2 WHEN '00' THEN TO_CHAR(TO_DATE(ADDDATE(ADDDATE(" + "'" + bParam[0] + "' + '01',  INTERVAL 1 MONTH), INTERVAL -1 DAY)), 'YYYYMMDD')" + "\n");
        sql.append( "                         ELSE TO_CHAR(" + "'" + bParam[0] + "' + F.REF_CODE2)                                                         " + "\n");
        sql.append( "        END END_DT                              " + "\n");
        sql.append( "      , F.REF_CODE2                             " + "\n");
        sql.append( " FROM BSA100T F                                 " + "\n");
        sql.append( " WHERE F.COMP_CODE  = " + "'" + bParam[15] + "' " + "\n");
        sql.append( " AND   F.MAIN_CODE  = 'H031'                    " + "\n");
        sql.append( " AND   F.SUB_CODE  != '$'                       " + "\n");
        sql.append( " AND   F.SUB_CODE   = " + "'" + bParam[1] + "'  " + "\n");


        try {
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            vRtn = pstmt.executeQuery();


        } catch (SQLException e) {
            throw e;
        }


        return vRtn;
    }

    private static int fnFetch(Connection conn, String[] bParam, String PersonNumb, String UniqueCode) throws SQLException{

        ResultSet vRtn = null;
        int sReturn = 0;

        // filter 대체
        bParam[10] = PersonNumb;
        vRtn = fnMakeArray(conn, bParam);

        try {
            while(vRtn.next()){
                sReturn = vRtn.getInt(UniqueCode);
            }

        } catch (SQLException e) {
            throw e;
        }


        return sReturn;
    }

    public static String fnGetHpa955skrSelectCol1(String sCompCode) {

        Connection conn = null;
        ResultSet rs = null;



        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);


            // DB 연결

            StringBuffer sql = new StringBuffer();

            String KeyValue = "";              

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();

            sql.setLength(0);                
            sql.append( "INSERT INTO T_HPA955SKR_1 (KEY_VALUE, SEQ, SUB_CODE, CODE_NAME) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY REF_CODE2, SUB_CODE ) AS SEQ  " + "\n");
            sql.append( "     , SUB_CODE                                                 " + "\n");
            sql.append( "     , CODE_NAME                                                " + "\n");
            sql.append( "FROM BSA100T                                                    " + "\n");
            sql.append( "WHERE COMP_CODE   = " + "'" + sCompCode + "'                    " + "\n");
            sql.append( "AND   MAIN_CODE   = 'H034'                                      " + "\n");
            sql.append( "AND   USE_YN      = 'Y'                                         " + "\n");
            sql.append( "AND   SUB_CODE   != '$'                                         " + "\n");
            sql.append( "ORDER BY REF_CODE2, SUB_CODE;                                   " + "\n");
            sql.append( ""+ "\n");
            sql.append( "INSERT INTO T_HPA955SKR_2 (KEY_VALUE, W_SEQ, WAGES_CODE, WAGES_NAME, WAGES_SEQ) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY WAGES_SEQ, WAGES_CODE ) AS SEQ  " + "\n");
            sql.append( "     , WAGES_CODE                                               " + "\n");
            sql.append( "     , WAGES_NAME                                               " + "\n");
            sql.append( "     , WAGES_SEQ                                                " + "\n");
            sql.append( "FROM HBS300T                                                    " + "\n");
            sql.append( "WHERE COMP_CODE   = " + "'" + sCompCode + "'                    " + "\n");
            sql.append( "AND   CODE_TYPE   = '1'                                         " + "\n");
            sql.append( "AND   USE_YN      = 'Y'                                         " + "\n");
            sql.append( "ORDER BY WAGES_SEQ, WAGES_CODE;                                 " + "\n");

            try{
                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();

            } catch(SQLException  e){
                //System.out.println(e);

            } finally {
                pstmt.close();
            }


            int HBO800PH_COUNT = 0;
            int HPA900PH_COUNT = 0;

            sql.setLength(0);
            sql.append( "SELECT (SELECT COUNT(W_SEQ) FROM T_HPA955SKR_2 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HBO800PH_COUNT");
            sql.append( "        ,  (SELECT COUNT(SEQ)     FROM T_HPA955SKR_1 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HPA900PH_COUNT");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                HBO800PH_COUNT = Integer.parseInt(rs.getString("HBO800PH_COUNT"));
                HPA900PH_COUNT = Integer.parseInt(rs.getString("HPA900PH_COUNT"));
            }
            pstmt.close();


            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, W_SEQ, WAGES_NAME                    " + "\n");
            sql.append( "FROM T_HPA955SKR_2                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HBO800PH_COUNT < 40){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HBO800PH_COUNT + 1) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HBO800PH_COUNT++;
            }

            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, SEQ+40, CODE_NAME                    " + "\n");
            sql.append( "FROM T_HPA955SKR_1                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HPA900PH_COUNT < 20){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HPA900PH_COUNT + 41) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HPA900PH_COUNT++;
            }

            rs.close();
            conn.setAutoCommit(true);

            sRtn = KeyValue;
            return sRtn;
        } catch (Exception e) {
            return "";   

        }
    }

    public static String fnGetHpa950skrSelectCol2(String sCompCode, String sDateFr, String sDateTo) {

        Connection conn = null;
        ResultSet rs = null;



        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);


            // DB 연결

            StringBuffer sql = new StringBuffer();

            String KeyValue = "";              

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();

            sql.setLength(0);                
            sql.append( "INSERT INTO T_HPA950SKR_1 (KEY_VALUE, SEQ, SUB_CODE, CODE_NAME) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY REF_CODE2, SUB_CODE ) AS SEQ  " + "\n");
            sql.append( "     , SUB_CODE                                                 " + "\n");
            sql.append( "     , CODE_NAME                                                " + "\n");
            sql.append( "FROM       BSA100T S                                            " + "\n");
            sql.append( "INNER JOIN HPA400T C ON C.COMP_CODE = S.COMP_CODE               " + "\n");
            sql.append( "                    AND C.DED_CODE  = S.SUB_CODE                " + "\n");
            sql.append( "WHERE C.COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
            sql.append( "AND   C.PAY_YYYYMM >= " + "'" + sDateFr + "'                    " + "\n");
            sql.append( "AND   C.PAY_YYYYMM <= " + "'" + sDateTo + "'                    " + "\n");
            sql.append( "AND   S.MAIN_CODE   = 'H034'                                    " + "\n");
            sql.append( "AND   USE_YN        = 'Y'                                       " + "\n");
            sql.append( "AND   SUB_CODE     != '$'                                       " + "\n");
            sql.append( "GROUP BY S.COMP_CODE, S.SUB_CODE, S.CODE_NAME, S.REF_CODE2      " + "\n");
            sql.append( "ORDER BY S.REF_CODE2, S.SUB_CODE;                               " + "\n");
            sql.append( ""+ "\n");
            sql.append( "INSERT INTO T_HPA950SKR_2 (KEY_VALUE, W_SEQ, WAGES_CODE, WAGES_NAME, WAGES_SEQ) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY S.WAGES_SEQ, S.WAGES_CODE ) AS SEQ  " + "\n");
            sql.append( "     , S.WAGES_CODE                                             " + "\n");
            sql.append( "     , S.WAGES_NAME                                             " + "\n");
            sql.append( "     , S.WAGES_SEQ                                              " + "\n");
            sql.append( "FROM       HBS300T S                                            " + "\n");
            sql.append( "INNER JOIN HPA300T A ON A.COMP_CODE  = S.COMP_CODE              " + "\n");
            sql.append( "                    AND A.WAGES_CODE = S.WAGES_CODE             " + "\n");
            sql.append( "WHERE S.COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
            sql.append( "AND   S.CODE_TYPE   = '1'                                       " + "\n");
            sql.append( "AND   A.SUPP_TYPE   = '1'                                       " + "\n");
            sql.append( "AND   A.PAY_YYYYMM >= " + "'" + sDateFr + "'                    " + "\n");
            sql.append( "AND   A.PAY_YYYYMM <= " + "'" + sDateTo + "'                    " + "\n");
            sql.append( "GROUP BY S.WAGES_CODE, S.WAGES_NAME, S.WAGES_SEQ                " + "\n");
            sql.append( "ORDER BY S.WAGES_SEQ, S.WAGES_CODE;                             " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            int HBO800PH_COUNT = 0;
            int HPA900PH_COUNT = 0;

            sql.setLength(0);
            sql.append( "SELECT (SELECT COUNT(W_SEQ) FROM T_HPA950SKR_2 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HBO800PH_COUNT");
            sql.append( "    ,  (SELECT COUNT(SEQ)     FROM T_HPA950SKR_1 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HPA900PH_COUNT");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                HBO800PH_COUNT = Integer.parseInt(rs.getString("HBO800PH_COUNT"));
                HPA900PH_COUNT = Integer.parseInt(rs.getString("HPA900PH_COUNT"));
            }
            pstmt.close();


            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, W_SEQ, WAGES_NAME                    " + "\n");
            sql.append( "FROM T_HPA950SKR_2                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HBO800PH_COUNT < 40){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HBO800PH_COUNT + 1) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HBO800PH_COUNT++;
            }

            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, SEQ+20, CODE_NAME                    " + "\n");
            sql.append( "FROM T_HPA950SKR_1                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HPA900PH_COUNT < 20){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HPA900PH_COUNT + 21) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HPA900PH_COUNT++;
            }

            rs.close();
            conn.setAutoCommit(true);

            sRtn = KeyValue;
            return sRtn;
        } catch (Exception e) {
            return "";   
        }
    }
//    
//    public static void main( String[] args ) {
//        fnGetHpa350ukrSelectList("20170712171219140191", "MASTER", "C0018", "201707", "1", "", "", "", "", "", "");
//    }
  
    public static String fnGetHpa350ukrSelectList(String KeyValue
            , String COMP_CODE
            , String DIV_CODE
            , String PAY_YYYYMM
            , String SUPP_TYPE
            , String PERSON_NUMB
            , String PAY_CODE
            , String PAY_PROV_FLAG
            , String PAY_GUBUN
            , String DEPT_CODE_FROM
            , String DEPT_CODE_TO) {

        Connection conn = null;
        ResultSet rs = null;



        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
//            conn = DriverManager.getConnection("jdbc:cubrid:211.241.199.190:30000:CRM:::?charset=UTF-8", "unilite", "UNILITE");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);
            

            System.out.println("====================================================================");
            System.out.println("=============================== 1 ==================================");
            System.out.println("====================================================================");
            
            System.out.println("KeyValue :: " + KeyValue);            
            
            // DB 연결

            StringBuffer sql = new StringBuffer();                        

            //임시테이블 생성
            sql.setLength(0);    
            sql.append( "  " + "\n");
            sql.append( "  DROP TABLE IF EXISTS T_HPA350UKR_1_" + KeyValue + ";\n");
            sql.append( "  " + "\n");
            sql.append( "  CREATE TABLE T_HPA350UKR_1_" + KeyValue + "                                    " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE       VARCHAR(20) NULL,                                          " + "\n");
            sql.append( "         COMP_CODE2      VARCHAR(08) ,                                              " + "\n");
            sql.append( "      DIV_CODE2       VARCHAR(08) ,                                              " + "\n");
            sql.append( "      DEPT_CODE2      VARCHAR(08) ,                                              " + "\n");
            sql.append( "      DEPT_NAME2      VARCHAR(30) ,                                              " + "\n");
            sql.append( "      POST_CODE2      VARCHAR(02) ,                                              " + "\n");
            sql.append( "      NAME2           VARCHAR(60) ,                                              " + "\n");
            sql.append( "      PERSON_NUMB2    VARCHAR(10) ,                                              " + "\n");
            sql.append( "      JOIN_DATE2      VARCHAR(10) ,                                              " + "\n");
            sql.append( "      PAY_YYYYMM2     VARCHAR(06) ,                                              " + "\n");
            sql.append( "      SUPP_TOTAL_I2   NUMERIC(18, 6) ,                                           " + "\n");
            sql.append( "      DED_TOTAL_I2    NUMERIC(18, 6) ,                                           " + "\n");
            sql.append( "      REAL_AMOUNT_I2  NUMERIC(18, 6)                                             " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX T_HPA350UKR_1_IDX01 ON T_HPA350UKR_1_" + KeyValue + "(key_value); " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  DROP TABLE IF EXISTS T_HPA350UKR_2_" + KeyValue + ";\n");
            sql.append( "  " + "\n");
            sql.append( "  CREATE TABLE T_HPA350UKR_2_" + KeyValue + "                                    " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE      VARCHAR(20) NULL,                                           " + "\n");
            sql.append( "         NID            INTEGER AUTO_INCREMENT ,                                    " + "\n");
            sql.append( "         WAGES_CODE     VARCHAR(10) ,                                               " + "\n");
            sql.append( "         WAGES_NAME     VARCHAR(20) ,                                               " + "\n");
            sql.append( "         USE_YN         VARCHAR(1)                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX T_HPA350UKR_2_IDX01 ON T_HPA350UKR_2_" + KeyValue + "(key_value); " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  DROP TABLE IF EXISTS T_HPA350UKR_3_" + KeyValue + ";\n");
            sql.append( "  " + "\n");
            sql.append( "  CREATE TABLE T_HPA350UKR_3_" + KeyValue + "                                    " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE      VARCHAR(20) NULL,                                           " + "\n");
            sql.append( "         NID            INTEGER AUTO_INCREMENT ,                                    " + "\n");
            sql.append( "         DED_CODE       VARCHAR(10) ,                                               " + "\n");
            sql.append( "         DED_NAME       VARCHAR(20) ,                                               " + "\n");
            sql.append( "         USE_YN         VARCHAR(1)                                                  " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX T_HPA350UKR_3_IDX01 ON T_HPA350UKR_3_" + KeyValue + "(key_value); " + "\n");
            sql.append( "                                                                                 " + "\n");          

            System.out.println("====================================================================");
            System.out.println("=============================== 2 ==================================");
            System.out.println("====================================================================");
            
            System.out.println(sql.toString());            
            
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);    
            sql.append( "  INSERT INTO T_HPA350UKR_1_" + KeyValue + "\n");
            sql.append( "   ( KEY_VALUE" + "\n");
            sql.append( "   , COMP_CODE2" + "\n");
            sql.append( "   , DIV_CODE2" + "\n");
            sql.append( "   , DEPT_CODE2" + "\n");
            sql.append( "   , DEPT_NAME2" + "\n");
            sql.append( "   , POST_CODE2" + "\n");
            sql.append( "   , NAME2" + "\n");
            sql.append( "   , PERSON_NUMB2" + "\n");
            sql.append( "   , JOIN_DATE2" + "\n");
            sql.append( "   , PAY_YYYYMM2" + "\n");
            sql.append( "   , SUPP_TOTAL_I2" + "\n");
            sql.append( "   , DED_TOTAL_I2" + "\n");
            sql.append( "   , REAL_AMOUNT_I2" + "\n");
            sql.append( "   )" + "\n");
            sql.append( "  SELECT " + "'" + KeyValue + "'"  + "\n");
            sql.append( "       , A.COMP_CODE" + "\n");
            sql.append( "       , A.DIV_CODE" + "\n");
            sql.append( "       , B.DEPT_CODE" + "\n");
            sql.append( "       , B.DEPT_NAME" + "\n");
            sql.append( "       , A.POST_CODE" + "\n");
            sql.append( "       , A.NAME" + "\n");
            sql.append( "       , A.PERSON_NUMB" + "\n");
            sql.append( "       , fnGetUserDateComp(" + "'" + COMP_CODE + "'" + ", A.JOIN_DATE) AS JOIN_DATE" + "\n");
            sql.append( "       , B.PAY_YYYYMM" + "\n");
            sql.append( "       , B.SUPP_TOTAL_I" + "\n");
            sql.append( "       , B.DED_TOTAL_I" + "\n");
            sql.append( "       , B.REAL_AMOUNT_I" + "\n");
            sql.append( "  FROM        HUM100T AS A " + "\n");
            sql.append( "  INNER JOIN (" + "\n");
            sql.append( "               SELECT" + "\n");
            sql.append( "                          B.COMP_CODE" + "\n");
            sql.append( "                        , B.DIV_CODE" + "\n");
            sql.append( "                        , B.PERSON_NUMB" + "\n");
            sql.append( "                        , B.PAY_YYYYMM" + "\n");
            sql.append( "                        , B.PAY_PROV_FLAG" + "\n");
            sql.append( "                        , B.PAY_GUBUN" + "\n");
            sql.append( "                        , B.PAY_GUBUN2" + "\n");
            sql.append( "                        , B.PAY_CODE" + "\n");
            sql.append( "                        , B.DEPT_CODE" + "\n");
            sql.append( "                        , B.DEPT_NAME" + "\n");
            sql.append( "                        , MAX(NVL(B.SUPP_TOTAL_I, 0))  AS SUPP_TOTAL_I" + "\n");
            sql.append( "                        , MAX(NVL(B.DED_TOTAL_I, 0))   AS DED_TOTAL_I" + "\n");
            sql.append( "                        , MAX(NVL(B.REAL_AMOUNT_I, 0)) AS REAL_AMOUNT_I" + "\n");
            sql.append( "                FROM HPA600T AS B " + "\n");
            sql.append( "                WHERE B.COMP_CODE      = " + "'" + COMP_CODE + "'" + "\n");
            sql.append( "                AND     B.DIV_CODE     = " + "'" + DIV_CODE + "'" + "\n");
            sql.append( "                AND     B.PAY_YYYYMM   = " + "'" + PAY_YYYYMM + "'" + "\n");
            sql.append( "                AND     B.SUPP_TYPE    = " + "'" + SUPP_TYPE + "'" + "\n");
            sql.append( "                GROUP BY B.COMP_CODE, B.DIV_CODE, B.PERSON_NUMB, B.PAY_YYYYMM, B.PAY_PROV_FLAG, B.PAY_GUBUN, B.PAY_GUBUN2, B.PAY_CODE , B.DEPT_CODE, B.DEPT_NAME" + "\n");
            sql.append( "            ) AS B ON B.COMP_CODE   = A.COMP_CODE" + "\n");
            sql.append( "                  AND B.DIV_CODE    = A.DIV_CODE" + "\n");
            sql.append( "                  AND B.PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append( "  WHERE A.COMP_CODE  = " + "'" + COMP_CODE + "'" + "\n");
            
            if(PERSON_NUMB.equals("")){
                
            }else{
                sql.append( "  AND   ((" + "'" + PERSON_NUMB    + "' != '' AND A.PERSON_NUMB   LIKE " + "'" + PERSON_NUMB + "' + '%'" + ")   OR (" + "'" + PERSON_NUMB + "'" + "    = ''))" + "\n");
            }

            if(PAY_CODE.equals("")){
                
            }else{
                sql.append( "  AND   ((" + "'" + PAY_CODE       + "' != '' AND B.PAY_CODE      LIKE " + "'" + PAY_CODE + "' + '%'" + ")      OR (" + "'" + PAY_CODE + "'" + "       = ''))" + "\n");
            }
            if(PAY_PROV_FLAG.equals("")){
                
            }else{
                sql.append( "  AND   ((" + "'" + PAY_PROV_FLAG  + "' != '' AND B.PAY_PROV_FLAG LIKE " + "'" + PAY_PROV_FLAG + "' + '%'" + ") OR (" + "'" + PAY_PROV_FLAG + "'" + "  = ''))" + "\n");
            }
            if(PAY_GUBUN.equals("")){
                
            }else{
                sql.append( "  AND   ((" + "'" + PAY_GUBUN      + "' != '' AND B.PAY_GUBUN     LIKE " + "'" + PAY_GUBUN + "' + '%'" + ")     OR (" + "'" + PAY_GUBUN + "'" + "      = ''))" + "\n");
            }
//            sql.append( "  AND   ((" + "'" + DEPT_CODE_FROM + "' != '' AND A.DEPT_CODE       >= " + "'" + DEPT_CODE_FROM + "'" + ")      OR (" + "'" + DEPT_CODE_FROM + "'" + " = ''))" + "\n");
//            sql.append( "  AND   ((" + "'" + DEPT_CODE_TO   + "' != '' AND A.DEPT_CODE       <= " + "'" + DEPT_CODE_TO + "'" + ")        OR (" + "'" + DEPT_CODE_TO + "'" + "   = ''))" + "\n");
            sql.append( "  ORDER BY A.DIV_CODE, B.DEPT_CODE, A.POST_CODE, A.JOIN_DATE, A.NAME; " + "\n");
            sql.append( "                                              " + "\n");
            sql.append( "  INSERT INTO T_HPA350UKR_2_" + KeyValue + "  " + "\n");
            sql.append( "         (                                    " + "\n");
            sql.append( "           KEY_VALUE                          " + "\n");
            sql.append( "         , WAGES_CODE                         " + "\n");
            sql.append( "         , WAGES_NAME                         " + "\n");
            sql.append( "         , USE_YN                             " + "\n");
            sql.append( "         )                                    " + "\n");
            sql.append( "  SELECT " + "'" + KeyValue + "'              " + "\n");
            sql.append( "       , WAGES_CODE                           " + "\n");
            sql.append( "       , WAGES_NAME                           " + "\n");
            sql.append( "       , USE_YN                               " + "\n");
            sql.append( "  FROM HBS300T                                " + "\n");
            sql.append( "  WHERE COMP_CODE = " + "'" + COMP_CODE + "'  " + "\n");
            sql.append( "  AND USE_YN = 'Y'                            " + "\n");
            sql.append( "  ORDER BY SORT_SEQ;                          " + "\n");
            sql.append( "                                              " + "\n");
            sql.append( "                                              " + "\n");
            sql.append( "  INSERT INTO T_HPA350UKR_3_" + KeyValue + "  " + "\n");
            sql.append( "  (                                           " + "\n");
            sql.append( "     KEY_VALUE                                " + "\n");
            sql.append( "   , DED_CODE                                 " + "\n");
            sql.append( "   , DED_NAME                                 " + "\n");
            sql.append( "   , USE_YN                                   " + "\n");
            sql.append( "  )                                           " + "\n");
            sql.append( "  SELECT " + "'" + KeyValue + "'              " + "\n");
            sql.append( "       , SUB_CODE                             " + "\n");
            sql.append( "       , CODE_NAME                            " + "\n");
            sql.append( "       , USE_YN                               " + "\n");
            sql.append( "  FROM BSA100T                                " + "\n");
            sql.append( "  WHERE COMP_CODE  = " + "'" + COMP_CODE + "' " + "\n");
            sql.append( "  AND   MAIN_CODE  = 'H034'                   " + "\n");
            sql.append( "  AND   SUB_CODE  != '$'                      " + "\n");
            sql.append( "  AND   USE_YN    = 'Y'                       " + "\n");
            sql.append( "  ORDER BY REF_CODE2;                         " + "\n");
            sql.append( "                                              " + "\n");

            System.out.println("====================================================================");
            System.out.println("=============================== 3 ==================================");
            System.out.println("====================================================================");
            
            System.out.println(sql.toString());
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            sql.setLength(0);
            sql.append( "SELECT (SELECT MAX(NID) FROM T_HPA350UKR_2_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "') AS MAXNO"  + "\n");
            sql.append( "     , (SELECT MAX(NID) FROM T_HPA350UKR_3_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "') AS MAXNO2" + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            int i = 1;              
            int MAXNO = 0;

            int i2 = 1;
            int MAXNO2 = 0;

            while(rs.next()){
                MAXNO = Integer.parseInt(rs.getString("MAXNO"));
                MAXNO2 = Integer.parseInt(rs.getString("MAXNO2"));
            }
            pstmt.close();

            String CREATE_NAME = "CREATE TABLE HPA_T_" + KeyValue + "" + "\n"
                    + "(  COMP_CODE     VARCHAR(10)    " + "\n"
                    + " , DIV_CODE      VARCHAR(08)    " + "\n"
                    + " , DEPT_CODE     VARCHAR(08)    " + "\n"
                    + " , DEPT_NAME     VARCHAR(30)    " + "\n"
                    + " , POST_CODE     VARCHAR(02)    " + "\n"
                    + " , NAME          VARCHAR(60)    " + "\n"
                    + " , PERSON_NUMB   VARCHAR(10)    " + "\n"
                    + " , JOIN_DATE     VARCHAR(10)    " + "\n"
                    + " , PAY_YYYYMM    VARCHAR(06)    " + "\n"
                    + " , SUPP_TOTAL_I  NUMERIC(18,6)  " + "\n"
                    + " , DED_TOTAL_I   NUMERIC(18,6)  " + "\n"
                    + " , REAL_AMOUNT_I NUMERIC(18,6)  " + "\n";


            String TEMP_CODE = "";
            String TEMP_NAME = "";

            while(i <= MAXNO){

                sql.setLength(0);
                sql.append( " SELECT WAGES_CODE, WAGES_NAME FROM T_HPA350UKR_2_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("WAGES_CODE");
                    TEMP_NAME = rs.getString("WAGES_NAME");
                }
                pstmt.close();

                CREATE_NAME = CREATE_NAME + ", WAGES_PAY" + TEMP_CODE + " NUMERIC(18, 6)" + "\n";
                i++;
            }

            while(i2 <= MAXNO2){

                sql.setLength(0);
                sql.append( " SELECT DED_CODE, DED_NAME FROM T_HPA350UKR_3_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i2 + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("DED_CODE");
                    TEMP_NAME = rs.getString("DED_NAME");
                }
                pstmt.close();

                CREATE_NAME = CREATE_NAME + ", WAGES_DED" + TEMP_CODE + " NUMERIC(18, 6)" + "\n";
                i2++;
            }      

            CREATE_NAME = CREATE_NAME + ")";

            String WAGES_CODE = "INSERT INTO HPA_T_" + KeyValue + "" + "\n"
                    + "(  COMP_CODE         " + "\n"
                    + " , DIV_CODE          " + "\n"
                    + " , DEPT_CODE         " + "\n"
                    + " , DEPT_NAME         " + "\n"
                    + " , POST_CODE         " + "\n"
                    + " , NAME              " + "\n"
                    + " , PERSON_NUMB       " + "\n"
                    + " , JOIN_DATE         " + "\n"
                    + " , PAY_YYYYMM        " + "\n"
                    + " , SUPP_TOTAL_I      " + "\n"
                    + " , DED_TOTAL_I       " + "\n"
                    + " , REAL_AMOUNT_I     " + "\n";

            i = 1;
            i2 = 1;

            while(i <= MAXNO){

                sql.setLength(0);
                sql.append( " SELECT WAGES_CODE, WAGES_NAME FROM T_HPA350UKR_2_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("WAGES_CODE");
                    TEMP_NAME = rs.getString("WAGES_NAME");
                }
                pstmt.close();

                WAGES_CODE = WAGES_CODE + ", WAGES_PAY" + TEMP_CODE + "" + "\n";
                i++;
            }

            while(i2 <= MAXNO2){

                sql.setLength(0);
                sql.append( " SELECT DED_CODE, DED_NAME FROM T_HPA350UKR_3_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i2 + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("DED_CODE");
                    TEMP_NAME = rs.getString("DED_NAME");
                }
                pstmt.close();

                WAGES_CODE = WAGES_CODE + ", WAGES_DED" + TEMP_CODE + "" + "\n";
                i2++;
            }  

            WAGES_CODE = WAGES_CODE + ")";

            WAGES_CODE = WAGES_CODE + "\n"
                    + "SELECT COMP_CODE2              " + "\n"
                    + "     , DIV_CODE2               " + "\n"
                    + "     , DEPT_CODE2              " + "\n"
                    + "     , DEPT_NAME2              " + "\n"
                    + "     , POST_CODE2              " + "\n"
                    + "     , NAME2                   " + "\n"
                    + "     , PERSON_NUMB2            " + "\n"
                    + "     , JOIN_DATE2              " + "\n"
                    + "     ," + "'" + PAY_YYYYMM + "'" + "\n"
                    + "     , SUPP_TOTAL_I2           " + "\n"
                    + "     , DED_TOTAL_I2            " + "\n"
                    + "     , REAL_AMOUNT_I2          " + "\n";

            i = 1;
            i2 = 1;

            while(i <= MAXNO){

                sql.setLength(0);
                sql.append( " SELECT WAGES_CODE, WAGES_NAME FROM T_HPA350UKR_2_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("WAGES_CODE");
                    TEMP_NAME = rs.getString("WAGES_NAME");
                }
                pstmt.close();

                WAGES_CODE = WAGES_CODE + ", 0" + "" + "\n";
                i++;
            }

            while(i2 <= MAXNO2){

                sql.setLength(0);
                sql.append( " SELECT DED_CODE, DED_NAME FROM T_HPA350UKR_3_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + i2 + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    TEMP_CODE = rs.getString("DED_CODE");
                    TEMP_NAME = rs.getString("DED_NAME");
                }
                pstmt.close();

                WAGES_CODE = WAGES_CODE + ", 0" + "" + "\n";
                i2++;
            }  

            WAGES_CODE = WAGES_CODE + " FROM T_HPA350UKR_1_" + KeyValue + "";



            sql.setLength(0);    
            sql.append( "  " + "\n");
            sql.append( "  DROP TABLE IF EXISTS HPA_T_" + KeyValue + ";\n");


            System.out.println("====================================================================");
            System.out.println("=============================== 4 ==================================");
            System.out.println("====================================================================");
            
            System.out.println(sql.toString());            
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);
            sql.append(CREATE_NAME);

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);
            sql.append(WAGES_CODE);

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);
            sql.append( "                                                                                 " + "\n");
            sql.append( "  DROP TABLE IF EXISTS WAGES_T_" + KeyValue + ";\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE TABLE WAGES_T_" + KeyValue + "                                          " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE      VARCHAR(20) NULL,                                           " + "\n");
            sql.append( "         NID            INTEGER AUTO_INCREMENT ,                                    " + "\n");
            sql.append( "         PERSON_NUMB2   VARCHAR(10) ,                                               " + "\n");
            sql.append( "         WAGES_CODE     VARCHAR(16) ,                                               " + "\n");
            sql.append( "         AMOUNT_I       NUMERIC(18, 6)                                              " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX WAGES_T_IDX01 ON WAGES_T_" + KeyValue + "(key_value);             " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  DROP TABLE IF EXISTS DED_T_" + KeyValue + ";\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE TABLE DED_T_" + KeyValue + "                                            " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE      VARCHAR(20) NULL,                                           " + "\n");
            sql.append( "         NID            INTEGER AUTO_INCREMENT ,                                    " + "\n");
            sql.append( "         PERSON_NUMB2   VARCHAR(10) ,                                               " + "\n");
            sql.append( "         DED_CODE       VARCHAR(16) ,                                               " + "\n");
            sql.append( "         AMOUNT_I       NUMERIC(18, 6)                                              " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX DED_T_IDX01 ON DED_T_" + KeyValue + "(key_value);                 " + "\n");
            sql.append( "                                                                                 " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);
            sql.append( "INSERT INTO WAGES_T_" + KeyValue + "                                      " + "\n");
            sql.append( "(  KEY_VALUE                                                              " + "\n");
            sql.append( " , PERSON_NUMB2                                                           " + "\n");
            sql.append( " , WAGES_CODE                                                             " + "\n");
            sql.append( " , AMOUNT_I                                                               " + "\n");
            sql.append( " )                                                                        " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'" + "                                       " + "\n");
            sql.append( "     , PERSON_NUMB                                                        " + "\n");
            sql.append( "     , 'WAGES_PAY' + A.WAGES_CODE                                         " + "\n");
            sql.append( "     , A.AMOUNT_I                                                         " + "\n");
            sql.append( "FROM       HPA300T A                                                      " + "\n");
            sql.append( "LEFT  JOIN HBS300T B  ON A.COMP_CODE  = B.COMP_CODE                       " + "\n");
            sql.append( "                     AND A.WAGES_CODE = B.WAGES_CODE                      " + "\n");
            sql.append( " WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                           " + "\n");
            sql.append( " AND   B.USE_YN      = 'Y'                                                " + "\n");
            sql.append( " AND   A.PAY_YYYYMM  = " + "'" + PAY_YYYYMM + "'                          " + "\n");
            sql.append( " AND   A.SUPP_TYPE   = '1'                                                " + "\n");                
            sql.append( " ORDER BY B.SORT_SEQ                                                      " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            sql.setLength(0);
            sql.append( "INSERT INTO DED_T_" + KeyValue + "                                        " + "\n");
            sql.append( "(  KEY_VALUE                                                              " + "\n");
            sql.append( " , PERSON_NUMB2                                                           " + "\n");
            sql.append( " , DED_CODE                                                               " + "\n");
            sql.append( " , AMOUNT_I                                                               " + "\n");
            sql.append( " )                                                                        " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'" + "                                       " + "\n");
            sql.append( "     , A.PERSON_NUMB                                                      " + "\n");
            sql.append( "     , 'WAGES_DED' + A.DED_CODE                                           " + "\n");
            sql.append( "     , DED_AMOUNT_I                                                       " + "\n");
            sql.append( "FROM        HPA400T A                                                     " + "\n");
            sql.append( "LEFT  JOIN BSA100T B  ON A.COMP_CODE = B.COMP_CODE                        " + "\n");
            sql.append( "                     AND A.DED_CODE  = B.SUB_CODE                         " + "\n");
            sql.append( "                     AND B.MAIN_CODE = 'H034'                             " + "\n");
            sql.append( "                     AND B.SUB_CODE != '$'                                " + "\n");
            sql.append( " WHERE A.COMP_CODE   = " + "'" + COMP_CODE + "'                           " + "\n");
            sql.append( " AND    PAY_YYYYMM   = " + "'" + PAY_YYYYMM + "'                          " + "\n");
            sql.append( " AND    A.SUPP_TYPE  = '1'                                                " + "\n");
            sql.append( " AND    B.USE_YN     = 'Y'                                                " + "\n");
            sql.append( " ORDER BY REF_CODE2                                                       " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            sql.setLength(0);
            sql.append( "  DROP TABLE IF EXISTS TBLGROUP_" + KeyValue + ";\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE TABLE TBLGROUP_" + KeyValue + "                                         " + "\n");
            sql.append( "  (                                                                              " + "\n");
            sql.append( "      KEY_VALUE      VARCHAR(20) NULL,                                           " + "\n");
            sql.append( "         NID            INTEGER AUTO_INCREMENT ,                                    " + "\n");
            sql.append( "         CODE           VARCHAR(20)                                                 " + "\n");
            sql.append( "  ) REUSE_OID ;                                                                  " + "\n");
            sql.append( "                                                                                 " + "\n");
            sql.append( "  CREATE INDEX TBLGROUP_IDX01 ON TBLGROUP_" + KeyValue + "(key_value);           " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            sql.setLength(0);
            sql.append( "  INSERT INTO TBLGROUP_" + KeyValue                + "\n");
            sql.append( "  (KEY_VALUE, CODE)                              " + "\n");
            sql.append( "  SELECT " + "'" + KeyValue + "'" + ",WAGES_CODE " + "\n");
            sql.append( "  FROM WAGES_T_" + KeyValue                       + "\n");
            sql.append( "  WHERE KEY_VALUE = " + "'" + KeyValue + "'      " + "\n");
            sql.append( "  GROUP BY WAGES_CODE;                           " + "\n");;

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();



            sql.setLength(0);
            sql.append( "SELECT COUNT(CODE) AS MAXCOUNT FROM TBLGROUP_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' "  + "\n");                

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            int SLOOP = 1;    
            int MAXCOUNT = 0;
            String WAGES_CODE2 = "";
            String TEMPSQL = "";

            while(rs.next()){
                MAXCOUNT = Integer.parseInt(rs.getString("MAXCOUNT"));
            }
            pstmt.close();

            while(SLOOP <= MAXCOUNT){

                sql.setLength(0);
                sql.append( " SELECT CODE FROM TBLGROUP_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + SLOOP + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    WAGES_CODE2 = rs.getString("CODE");
                }
                pstmt.close();

                TEMPSQL = "UPDATE HPA_T_" + KeyValue + " A" + "\n";
                TEMPSQL = TEMPSQL + "INNER JOIN WAGES_T_" + KeyValue + " B ON B.PERSON_NUMB2 = A.PERSON_NUMB AND B.WAGES_CODE = " + "'" + WAGES_CODE2 + "' " + "\n";
                TEMPSQL = TEMPSQL + "SET A." + WAGES_CODE2 + " = B.AMOUNT_I" + "\n";

                sql.setLength(0);
                sql.append(TEMPSQL);

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();


                SLOOP++;
            }

            sql.setLength(0);
            sql.append("TRUNCATE TABLE TBLGROUP_" + KeyValue);

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();



            sql.setLength(0);
            sql.append( "  INSERT INTO TBLGROUP_" + KeyValue                + "\n");
            sql.append( "  (KEY_VALUE, CODE)                              " + "\n");
            sql.append( "  SELECT " + "'" + KeyValue + "'" + ",DED_CODE " + "\n");
            sql.append( "  FROM DED_T_" + KeyValue                       + "\n");
            sql.append( "  WHERE KEY_VALUE = " + "'" + KeyValue + "'      " + "\n");
            sql.append( "  GROUP BY DED_CODE;                           " + "\n");;

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            SLOOP = 1;
            TEMPSQL = "";
            WAGES_CODE2 = "";

            while(SLOOP <= MAXCOUNT){

                sql.setLength(0);
                sql.append( " SELECT CODE FROM TBLGROUP_" + KeyValue + " WHERE KEY_VALUE = " + "'" + KeyValue + "' AND NID = " + SLOOP + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    WAGES_CODE2 = rs.getString("CODE");
                }
                pstmt.close();

                TEMPSQL = "UPDATE HPA_T_" + KeyValue + " A" + "\n";
                TEMPSQL = TEMPSQL + "INNER JOIN DED_T_" + KeyValue + " B ON B.PERSON_NUMB2 = A.PERSON_NUMB AND B.DED_CODE = " + "'" + WAGES_CODE2 + "' " + "\n";
                TEMPSQL = TEMPSQL + "SET A." + WAGES_CODE2 + " = B.AMOUNT_I" + "\n";

                sql.setLength(0);
                sql.append(TEMPSQL);

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                SLOOP++;
            }

            //임시테이블 삭제
            sql.setLength(0);
            sql.append( "DROP TABLE T_HPA350UKR_1_" + KeyValue  + ";\n");
            sql.append( "DROP TABLE T_HPA350UKR_2_" + KeyValue  + ";\n");
            sql.append( "DROP TABLE T_HPA350UKR_3_" + KeyValue  + ";\n");

            sql.append( "DROP TABLE WAGES_T_" + KeyValue  + ";\n");
            sql.append( "DROP TABLE DED_T_" + KeyValue  + ";\n");
            sql.append( "DROP TABLE TBLGROUP_" + KeyValue  + ";\n");

            //sql.append( "DROP TABLE HPA_T_" + KeyValue  + ";\n"); <-- 요테이블은 최종 데이터 SELECT후에 XML단에서 삭제처리

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            rs.close();
            conn.setAutoCommit(true);

            sRtn = KeyValue;
            return sRtn;
        } catch (Exception e) {
            return "";   
        }
    }

    public static String fnGetHpa950skrSelectCol1(String sCompCode) {

        Connection conn = null;
        ResultSet rs = null;



        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);


            // DB 연결

            StringBuffer sql = new StringBuffer();

            String KeyValue = "";              

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();

            sql.setLength(0);                
            sql.append( "INSERT INTO T_HPA950SKR_1 (KEY_VALUE, SEQ, SUB_CODE, CODE_NAME) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY REF_CODE2, SUB_CODE ) AS SEQ  " + "\n");
            sql.append( "     , SUB_CODE                                                 " + "\n");
            sql.append( "     , CODE_NAME                                                " + "\n");
            sql.append( "FROM BSA100T                                                    " + "\n");
            sql.append( "WHERE COMP_CODE   = " + "'" + sCompCode + "'                    " + "\n");
            sql.append( "AND   MAIN_CODE   = 'H034'                                      " + "\n");
            sql.append( "AND   USE_YN      = 'Y'                                         " + "\n");
            sql.append( "AND   SUB_CODE   != '$'                                         " + "\n");
            sql.append( "ORDER BY REF_CODE2, SUB_CODE;                                   " + "\n");
            sql.append( ""+ "\n");
            sql.append( "INSERT INTO T_HPA950SKR_2 (KEY_VALUE, W_SEQ, WAGES_CODE, WAGES_NAME, WAGES_SEQ) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY WAGES_SEQ, WAGES_CODE ) AS SEQ  " + "\n");
            sql.append( "     , WAGES_CODE                                               " + "\n");
            sql.append( "     , WAGES_NAME                                               " + "\n");
            sql.append( "     , WAGES_SEQ                                                " + "\n");
            sql.append( "FROM HBS300T                                                    " + "\n");
            sql.append( "WHERE COMP_CODE   = " + "'" + sCompCode + "'                    " + "\n");
            sql.append( "AND   CODE_TYPE   = '1'                                         " + "\n");
            sql.append( "AND   USE_YN      = 'Y'                                         " + "\n");
            sql.append( "ORDER BY WAGES_SEQ, WAGES_CODE;                                 " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            int HBO800PH_COUNT = 0;
            int HPA900PH_COUNT = 0;

            sql.setLength(0);
            sql.append( "SELECT (SELECT COUNT(W_SEQ) FROM T_HPA950SKR_2 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HBO800PH_COUNT");
            sql.append( "        ,  (SELECT COUNT(SEQ)     FROM T_HPA950SKR_1 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HPA900PH_COUNT");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                HBO800PH_COUNT = Integer.parseInt(rs.getString("HBO800PH_COUNT"));
                HPA900PH_COUNT = Integer.parseInt(rs.getString("HPA900PH_COUNT"));
            }
            pstmt.close();


            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, W_SEQ, WAGES_NAME                    " + "\n");
            sql.append( "FROM T_HPA950SKR_2                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HBO800PH_COUNT < 40){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HBO800PH_COUNT + 1) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HBO800PH_COUNT++;
            }

            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, SEQ+20, CODE_NAME                    " + "\n");
            sql.append( "FROM T_HPA950SKR_1                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HPA900PH_COUNT < 20){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA950SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HPA900PH_COUNT + 21) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HPA900PH_COUNT++;
            }

            rs.close();
            conn.setAutoCommit(true);

            sRtn = KeyValue;
            return sRtn;
        } catch (Exception e) {
            return "";   
        }
    }

    public static String fnGetHpa955skrSelectCol2(String sCompCode, String sDateFr, String sDateTo) {

        Connection conn = null;
        ResultSet rs = null;



        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
            conn.setAutoCommit(false);


            // DB 연결

            StringBuffer sql = new StringBuffer();

            String KeyValue = "";              

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();

            sql.setLength(0);                
            sql.append( "INSERT INTO T_HPA955SKR_1 (KEY_VALUE, SEQ, SUB_CODE, CODE_NAME) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY REF_CODE2, SUB_CODE ) AS SEQ  " + "\n");
            sql.append( "     , SUB_CODE                                                 " + "\n");
            sql.append( "     , CODE_NAME                                                " + "\n");
            sql.append( "FROM       BSA100T S                                            " + "\n");
            sql.append( "INNER JOIN HPA400T C ON C.COMP_CODE = S.COMP_CODE               " + "\n");
            sql.append( "                    AND C.DED_CODE  = S.SUB_CODE                " + "\n");
            sql.append( "WHERE C.COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
            sql.append( "AND   C.PAY_YYYYMM >= " + "'" + sDateFr + "'                    " + "\n");
            sql.append( "AND   C.PAY_YYYYMM <= " + "'" + sDateTo + "'                    " + "\n");
            sql.append( "AND   S.MAIN_CODE   = 'H034'                                    " + "\n");
            sql.append( "AND   USE_YN        = 'Y'                                       " + "\n");
            sql.append( "AND   SUB_CODE     != '$'                                       " + "\n");
            sql.append( "GROUP BY S.COMP_CODE, S.SUB_CODE, S.CODE_NAME, S.REF_CODE2      " + "\n");
            sql.append( "ORDER BY S.REF_CODE2, S.SUB_CODE;                               " + "\n");
            sql.append( ""+ "\n");
            sql.append( "INSERT INTO T_HPA955SKR_2 (KEY_VALUE, W_SEQ, WAGES_CODE, WAGES_NAME, WAGES_SEQ) " + "\n");
            sql.append( "SELECT " + "'" + KeyValue + "'                                   " + "\n");
            sql.append( "     , ROW_NUMBER() OVER(ORDER BY S.WAGES_SEQ, S.WAGES_CODE ) AS SEQ  " + "\n");
            sql.append( "     , S.WAGES_CODE                                             " + "\n");
            sql.append( "     , S.WAGES_NAME                                             " + "\n");
            sql.append( "     , S.WAGES_SEQ                                              " + "\n");
            sql.append( "FROM       HBS300T S                                            " + "\n");
            sql.append( "INNER JOIN HPA300T A ON A.COMP_CODE  = S.COMP_CODE              " + "\n");
            sql.append( "                    AND A.WAGES_CODE = S.WAGES_CODE             " + "\n");
            sql.append( "WHERE S.COMP_CODE   = " + "'" + sCompCode + "'                  " + "\n");
            sql.append( "AND   S.CODE_TYPE   = '1'                                       " + "\n");
            sql.append( "AND   A.SUPP_TYPE   = '1'                                       " + "\n");
            sql.append( "AND   A.PAY_YYYYMM >= " + "'" + sDateFr + "'                    " + "\n");
            sql.append( "AND   A.PAY_YYYYMM <= " + "'" + sDateTo + "'                    " + "\n");
            sql.append( "GROUP BY S.WAGES_CODE, S.WAGES_NAME, S.WAGES_SEQ                " + "\n");
            sql.append( "ORDER BY S.WAGES_SEQ, S.WAGES_CODE;                             " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            int HBO800PH_COUNT = 0;
            int HPA900PH_COUNT = 0;

            sql.setLength(0);
            sql.append( "SELECT (SELECT COUNT(W_SEQ) FROM T_HPA955SKR_2 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HBO800PH_COUNT");
            sql.append( "    ,  (SELECT COUNT(SEQ)   FROM T_HPA955SKR_1 WHERE KEY_VALUE =" + "'" + KeyValue + "' ) AS HPA900PH_COUNT");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                HBO800PH_COUNT = Integer.parseInt(rs.getString("HBO800PH_COUNT"));
                HPA900PH_COUNT = Integer.parseInt(rs.getString("HPA900PH_COUNT"));
            }
            pstmt.close();


            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, W_SEQ, WAGES_NAME                    " + "\n");
            sql.append( "FROM T_HPA955SKR_2                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HBO800PH_COUNT < 40){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HBO800PH_COUNT + 1) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HBO800PH_COUNT++;
            }

            sql.setLength(0);       
            sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
            sql.append( "SELECT KEY_VALUE, SEQ+40, CODE_NAME                    " + "\n");
            sql.append( "FROM T_HPA955SKR_1                                     " + "\n");
            sql.append( "WHERE KEY_VALUE = " + "'" + KeyValue + "'              " + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            while(HPA900PH_COUNT < 20){

                sql.setLength(0);
                sql.append( "INSERT INTO T_HPA955SKR_3(KEY_VALUE, W_SEQ, WAGES_NAME)" + "\n");
                sql.append( "VALUES (" + "'" + KeyValue + "'" + ", " + (HPA900PH_COUNT + 41) + ", '')" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();

                HPA900PH_COUNT++;
            }

            rs.close();
            conn.setAutoCommit(true);

            sRtn = KeyValue;
            return sRtn;
        } catch (Exception e) {
            return "";   
        }
    }

//    public static void main( String[] args ) {
//        SP_HAT_doTotalWork_innerFunctions("1", "201707", "20170701", "20170731", "C0018", "", "", "20000103", "unilite5", "", "MASTER", "20170701", "20170731");
//    }
    
    public static String SP_HAT_doTotalWork_innerFunctions(String PAY_PROV_FLAG
            , String DUTY_YYYYMMDD
            , String DUTY_YYYYMMDD_FR
            , String DUTY_YYYYMMDD_TO
            , String DIV_CODE
            , String DEPT_CODE_FR
            , String DEPT_CODE_TO
            , String PERSON_NUMB
            , String UPDATE_DB_USER
            , String ISEXTENDED
            , String COMP_CODE
            , String PAY_YYYYMMDD_FR
            , String PAY_YYYYMMDD_TO                                                                
            ) 
    {

        Connection conn = null;
        ResultSet rs = null;

        String sRtn = "";
        try{

            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:default:connection");
//            conn = DriverManager.getConnection("jdbc:cubrid:211.241.199.190:30000:CRM:::?charset=UTF-8", "unilite", "UNILITE");
            conn.setAutoCommit(false);

            String KeyValue = "";

            StringBuffer sql = new StringBuffer();

            sql.append( " SELECT LEFT(TO_CHAR(SYSDATETIME, 'yyyymmddhh24missff') + LEFT(TO_CHAR(TO_NUMBER(RAND()) * 10000), 3), 20)  ");

            PreparedStatement  pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            while(rs.next()){
                KeyValue = rs.getString(1);
            }

            pstmt.close();

            System.out.println("====================================================================");
            System.out.println("=============================== 1 ==================================");
            System.out.println("====================================================================");
            
            System.out.println("KeyValue :: " + KeyValue);
            
            sql.setLength(0);                    
            sql.append("SET @COMP_CODE             = " + "'" + COMP_CODE + "';\n");
            sql.append("SET @DUTY_YYYYMMDD         = " + "CASE WHEN '" + DUTY_YYYYMMDD + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD + "' END;\n");
            sql.append("SET @DUTY_YYYYMMDD_FR      = " + "CASE WHEN '" + DUTY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_FR + "' END;\n");
            sql.append("SET @DUTY_YYYYMMDD_TO      = " + "CASE WHEN '" + DUTY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_TO + "' END;\n");
            sql.append("SET @PAY_YYYYMMDD_FR       = " + "CASE WHEN '" + PAY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_FR + "' END;\n");
            sql.append("SET @PAY_YYYYMMDD_TO       = " + "CASE WHEN '" + PAY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_TO + "' END;\n");
            sql.append("SET @PERSON_NUMB           = " + "'" + PERSON_NUMB + "';\n");
            sql.append("SET @UPDATE_DB_USER        = " + "'" + UPDATE_DB_USER + "';\n");
            sql.append("SET @PAY_PROV_FLAG         = " + "'" + PAY_PROV_FLAG + "';\n");
            sql.append("SET @DIV_CODE              = " + "'" + DIV_CODE + "';\n");
//            sql.append("SET @DEPT_CODE_TO          = " + "'" + DEPT_CODE_TO + "';\n");
//            sql.append("SET @DEPT_CODE_FR          = " + "'" + DEPT_CODE_FR + "';\n");
            sql.append("" + "\n");
            sql.append("SET @KeyValue  = " + "'" + KeyValue + "';\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("-- 큐브리드 변환" + "\n");
            sql.append("    INSERT INTO T_HAT200UKR_1  " + "\n");
            sql.append("    (" + "\n");
            sql.append("          KEY_VALUE" + "\n");
            sql.append("        , STR_YEAR" + "\n");
            sql.append("        , STR_FR_DT" + "\n");
            sql.append("        , STR_TO_DT" + "\n");
            sql.append("        , USE_YEAR" + "\n");
            sql.append("        , USE_FR_DT" + "\n");
            sql.append("        , USE_TO_DT" + "\n");
            sql.append("    )    " + "\n");
            sql.append("    SELECT @KeyValue" + "\n");
            sql.append("             , LEFT(TO_CHAR(STR_FR_DT, 'YYYYMMDD'),4)  AS STR_YEAR" + "\n");
            sql.append("             , TO_CHAR(STR_FR_DT, 'YYYYMMDD')             AS STR_FR_DT" + "\n");
            sql.append("             , TO_CHAR(STR_TO_DT, 'YYYYMMDD')             AS STR_TO_DT" + "\n");
            sql.append("             , LEFT(TO_CHAR(END_FR_DT, 'YYYYMMDD'),4)  AS USE_YEAR" + "\n");
            sql.append("             , TO_CHAR(END_FR_DT, 'YYYYMMDD')             AS USE_FR_DT" + "\n");
            sql.append("             , TO_CHAR(END_TO_DT, 'YYYYMMDD')            AS USE_TO_DT" + "\n");
            sql.append("    FROM (" + "\n");
            sql.append("                SELECT CASE WHEN RIGHT(@DUTY_YYYYMMDD,2)  < SUBSTRING(FR_STD_DAY,5,2)  THEN (CASE WHEN YEAR_STD_FR_YYYY = '1'  THEN TO_CHAR(FR_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                             ELSE TO_CHAR(TO_DATE(ADDDATE(FR_STD_DAY, INTERVAL -1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                     END)" + "\n");
            sql.append("                                   ELSE (CASE WHEN YEAR_STD_FR_YYYY = '1'  THEN (CASE WHEN SUBSTRING(FR_STD_DAY, 5,2) <> '01' THEN TO_CHAR(TO_DATE(ADDDATE(FR_STD_DAY, INTERVAL +1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                    ELSE TO_CHAR(FR_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                            END)" + "\n");
            sql.append("                                                    ELSE TO_CHAR(FR_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                             END)" + "\n");
            sql.append("                           END  AS STR_FR_DT" + "\n");
            sql.append("                        , CASE WHEN RIGHT(@DUTY_YYYYMMDD,2)  < SUBSTRING(FR_STD_DAY,5,2)  THEN (CASE WHEN YEAR_STD_FR_YYYY = '1'  THEN TO_CHAR(TO_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                            ELSE TO_CHAR(TO_DATE(ADDDATE(TO_STD_DAY, INTERVAL -1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                    END)" + "\n");
            sql.append("                                  ELSE (CASE WHEN YEAR_STD_FR_YYYY = '1'  THEN (CASE WHEN SUBSTRING(FR_STD_DAY, 5,2) <> '01' THEN TO_CHAR(TO_DATE(ADDDATE(TO_STD_DAY, INTERVAL +1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                      ELSE TO_CHAR(TO_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                           END)" + "\n");
            sql.append("                                                   ELSE TO_CHAR(TO_STD_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                           END)" + "\n");
            sql.append("                         END AS STR_TO_DT" + "\n");
            sql.append("                        , CASE WHEN RIGHT(@DUTY_YYYYMMDD,2)  < SUBSTRING(FR_DAY,5,2)  THEN (CASE WHEN YEAR_USE_FR_YYYY = '2' THEN TO_CHAR(FR_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                      ELSE TO_CHAR(TO_DATE(ADDDATE(FR_DAY, INTERVAL -1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                             END)" + "\n");
            sql.append("                                  ELSE (CASE WHEN YEAR_USE_FR_YYYY = '2' THEN (CASE WHEN SUBSTRING(FR_DAY, 5,2) <> '01' THEN TO_CHAR(TO_DATE(ADDDATE(FR_DAY, INTERVAL +1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                  ELSE TO_CHAR(FR_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                         END)" + "\n");
            sql.append("                                                  ELSE TO_CHAR(FR_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                          END)" + "\n");
            sql.append("                          END AS END_FR_DT" + "\n");
            sql.append("                        , CASE WHEN RIGHT(@DUTY_YYYYMMDD,2)  <SUBSTRING(FR_DAY,5,2)  THEN (CASE WHEN YEAR_USE_FR_YYYY = '2' THEN TO_CHAR(TO_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                                  ELSE TO_CHAR(TO_DATE(ADDDATE(TO_DAY, INTERVAL -1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                           END)" + "\n");
            sql.append("                                  ELSE (CASE WHEN YEAR_USE_FR_YYYY = '2' THEN (CASE WHEN SUBSTRING(FR_DAY, 5,2) <> '01' THEN TO_CHAR(TO_DATE(ADDDATE(TO_DAY, INTERVAL +1 YEAR)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                                 ELSE TO_CHAR(TO_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                                                                                        END)" + "\n");
            sql.append("                                                 ELSE TO_CHAR(TO_DAY, 'YYYYMMDD')" + "\n");
            sql.append("                                         END)" + "\n");
            sql.append("                          END AS END_TO_DT" + "\n");
            sql.append("                 FROM (" + "\n");
            sql.append("                             SELECT YEAR_STD_FR_YYYY" + "\n");
            sql.append("                                      , YEAR_USE_FR_YYYY" + "\n");
            sql.append("                                      , TO_CHAR(CASE WHEN YEAR_STD_FR_YYYY = '1' THEN LEFT(@DUTY_YYYYMMDD,4) - 2" + "\n");
            sql.append("                                                              WHEN YEAR_STD_FR_YYYY = '2' THEN LEFT(@DUTY_YYYYMMDD,4) - 1" + "\n");
            sql.append("                                                              ELSE LEFT(@DUTY_YYYYMMDD,4)" + "\n");
            sql.append("                                                      END) + YEAR_STD_FR_MM + YEAR_STD_FR_DD  AS FR_STD_DAY" + "\n");
            sql.append("                                      , TO_CHAR(CASE WHEN YEAR_STD_TO_YYYY = '1' THEN LEFT(@DUTY_YYYYMMDD,4) - 2" + "\n");
            sql.append("                                                              WHEN YEAR_STD_TO_YYYY = '2' THEN LEFT(@DUTY_YYYYMMDD,4) - 1" + "\n");
            sql.append("                                                              ELSE LEFT(@DUTY_YYYYMMDD,4)" + "\n");
            sql.append("                                                       END ) + YEAR_STD_TO_MM + YEAR_STD_TO_DD AS TO_STD_DAY" + "\n");
            sql.append("                                      , TO_CHAR(CASE WHEN YEAR_USE_FR_YYYY = '3' THEN LEFT(@DUTY_YYYYMMDD,4)" + "\n");
            sql.append("                                                              WHEN YEAR_USE_FR_YYYY = '2' THEN LEFT(@DUTY_YYYYMMDD,4) - 1" + "\n");
            sql.append("                                                              ELSE LEFT(@DUTY_YYYYMMDD,4)  +  1" + "\n");
            sql.append("                                                      END ) +  YEAR_USE_FR_MM+ YEAR_USE_FR_DD  AS FR_DAY" + "\n");
            sql.append("                                      , TO_CHAR(CASE WHEN YEAR_USE_TO_YYYY = '3' THEN LEFT(@DUTY_YYYYMMDD,4)" + "\n");
            sql.append("                                                              WHEN YEAR_USE_TO_YYYY = '2' THEN  LEFT(@DUTY_YYYYMMDD,4) - 1" + "\n");
            sql.append("                                                              ELSE LEFT(@DUTY_YYYYMMDD,4)  +  1" + "\n");
            sql.append("                                                      END ) +  YEAR_USE_TO_MM  +  YEAR_USE_TO_DD   AS TO_DAY" + "\n");
            sql.append("                         FROM HBS400T AS A" + "\n");
            sql.append("                        WHERE COMP_CODE = @COMP_CODE" + "\n");
            sql.append("                        ) A" + "\n");
            sql.append("            ) AA;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--    PRINT '--SQL12_DO INSERT to Temp : @results2'" + "\n");
            sql.append("" + "\n");
            sql.append("--SELECT * FROM T_HAT200UKR_2" + "\n");
            sql.append("" + "\n");
            sql.append("    INSERT INTO T_HAT200UKR_2 (KEY_VALUE, YEAR_USE_FR_YYYY, YEAR_USE_TO_YYYY)" + "\n");
            sql.append("    SELECT @KeyValue" + "\n");
            sql.append("             , YEAR_USE_FR_YYYY" + "\n");
            sql.append("             , YEAR_USE_TO_YYYY" + "\n");
            sql.append("    FROM HBS400T" + "\n");
            sql.append("    WHERE COMP_CODE = @COMP_CODE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--    PRINT '--SQL13_DO INSERT INTO HAT700T'" + "\n");
            sql.append("--    -- 3." + "\n");
            sql.append("    INSERT INTO HAT700T" + "\n");
            sql.append("                    (DUTY_YYYY, SUPP_TYPE, PERSON_NUMB, DUTY_YYYYMMDDFR, DUTY_YYYYMMDDTO " + "\n");
            sql.append("                    ,DUTY_YYYYMMDDFR_USE, DUTY_YYYYMMDDTO_USE,  INSERT_DB_USER, INSERT_DB_TIME, UPDATE_DB_USER, UPDATE_DB_TIME" + "\n");
            sql.append("                    ,YEAR_SAVE, YEAR_BONUS_I, YEAR_NUM, COMP_CODE) " + "\n");
            sql.append("             SELECT (SELECT USE_YEAR FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)  AS DUTY_YYYY" + "\n");
            sql.append("                  , 'F' AS  SUPP_TYPE" + "\n");
            sql.append("                  , AA.PERSON_NUMB" + "\n");
            sql.append("                  , (SELECT STR_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)   AS DUTY_YYYYMMDDFR" + "\n");
            sql.append("                  , (SELECT STR_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)   AS DUTY_YYYYMMDDTO" + "\n");
            sql.append("                  , (SELECT USE_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)   AS DUTY_YYYYMMDDFR_USE" + "\n");
            sql.append("                  , (SELECT USE_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)  AS DUTY_YYYYMMDDTO_USE" + "\n");
            sql.append("                  , @UPDATE_DB_USER AS INSERT_DB_USER" + "\n");
            sql.append("                  , SYSDATETIME  AS INSERT_DB_TIME                  " + "\n");
            sql.append("                  , @UPDATE_DB_USER AS UPDATE_DB_USER" + "\n");
            sql.append("                  , SYSDATETIME  AS UPDATE_DB_TIME" + "\n");
            sql.append("                  , CASE WHEN AA.JOIN_DATE <= (SELECT STR_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue) THEN AA.YEAR_SAVE " + "\n");
            sql.append("                         ELSE 0 END YEAR_SAVE" + "\n");
            sql.append("                  , CASE WHEN AA.JOIN_DATE <= (SELECT STR_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue) THEN AA.GUNSOK " + "\n");
            sql.append("                         ELSE 0 END GUNSOK" + "\n");
            sql.append("                  , CASE WHEN AA.JOIN_DATE <= (SELECT STR_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue) THEN (AA.YEAR_SAVE + AA.GUNSOK ) " + "\n");
            sql.append("                         ELSE 0 END TOT_YEAR_SAVE" + "\n");
            sql.append("                  , @COMP_CODE" + "\n");
            sql.append("               FROM (" + "\n");
            sql.append("                       SELECT A.PERSON_NUMB" + "\n");
            sql.append("                               ,  A.JOIN_DATE" + "\n");
            sql.append("                               ,  A.YEAR_SAVE" + "\n");
//            sql.append("                                , CASE WHEN NVL(A.ORI_JOIN_DATE, '') = '' THEN fnGetYMDFromDate(A.JOIN_DATE2, (SELECT STR_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue))" + "\n");
            sql.append("                            , CASE WHEN A.ORI_JOIN_DATE IS NULL THEN fnGetYMDFromDate(A.JOIN_DATE2, (SELECT STR_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue))" + "\n");
            sql.append("                                          ELSE fnGetYMDFromDate(A.ORI_JOIN_DATE,(SELECT STR_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue))" + "\n");
            sql.append("                                  END AS GUNSOK " + "\n");
            sql.append("                                           " + "\n");
            sql.append("                       FROM (" + "\n");
            sql.append("                      " + "\n");
            sql.append("                                   SELECT B.PERSON_NUMB" + "\n");
            sql.append("                                                , CASE WHEN B.ORI_JOIN_DATE = '00000000' OR B.ORI_JOIN_DATE IS NULL THEN JOIN_DATE " + "\n");
//            sql.append("                                             , CASE WHEN B.ORI_JOIN_DATE = '00000000' OR B.ORI_JOIN_DATE = '' THEN JOIN_DATE " + "\n");
            sql.append("                                                          ELSE B.ORI_JOIN_DATE " + "\n");
            sql.append("                                                  END AS JOIN_DATE" + "\n");
            sql.append("                                                , CASE WHEN NVL((SELECT SUM(DUTY_NUM)" + "\n");
            sql.append("                                                                            FROM          HAT200T AS E" + "\n");
            sql.append("                                                                            INNER JOIN HBS100T AS F  ON E.COMP_CODE = F.COMP_CODE" + "\n");
            sql.append("                                                                                                                  AND E.DUTY_CODE   = F.DUTY_CODE" + "\n");
            sql.append("                                                                            WHERE E.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                                                                            AND F.YEAR_REL_CODE    = 'Y'" + "\n");
            sql.append("                                                                            AND DUTY_YYYYMM     >= (SELECT STR_FR_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)" + "\n");
            sql.append("                                                                            AND DUTY_YYYYMM     <= (SELECT STR_TO_DT FROM T_HAT200UKR_1 WHERE KEY_VALUE = @KeyValue)" + "\n");
            sql.append("                                                                            AND E.PERSON_NUMB     = B.PERSON_NUMB  " + "\n");
            sql.append("                                                                            AND F.PAY_CODE           = B.PAY_CODE   " + "\n");
            sql.append("                                                                           GROUP BY E.PERSON_NUMB" + "\n");
            sql.append("                                                                           ), 0) >= SUPP_YEAR_NUM_A AND SUPP_YEAR_NUM_A > 0 THEN SUPP_YEAR_NUM_B  " + "\n");
            sql.append("                                                         ELSE SUPP_YEAR_NUM_A" + "\n");
            sql.append("                                                 END AS YEAR_SAVE" + "\n");
            sql.append("                                                , B.ORI_JOIN_DATE" + "\n");
            sql.append("                                                , B.JOIN_DATE  AS JOIN_DATE2" + "\n");
            sql.append("                                                " + "\n");
            sql.append("                                   FROM          HUM100T AS B" + "\n");
            sql.append("                                   INNER JOIN HBS340T  AS C  ON B.COMP_CODE = C.COMP_CODE" + "\n");
            sql.append("                                                                           AND B.PAY_CODE    = C.PAY_CODE" + "\n");
            sql.append("                                   LEFT    JOIN (" + "\n");
            sql.append("                                                            SELECT " + "\n");
            sql.append("                                                                      D.COMP_CODE" + "\n");
            sql.append("                                                                    , D.PERSON_NUMB" + "\n");
            sql.append("                                                                    , D.BE_DIV_NAME AS BE_DIV_CODE" + "\n");
            sql.append("                                                             FROM HUM760T AS D" + "\n");
            sql.append("                                                             WHERE D.COMP_CODE        =  @COMP_CODE" + "\n");
            sql.append("                                                               AND D.ANNOUNCE_DATE >= @DUTY_YYYYMMDD_FR " + "\n");
            sql.append("                                                               AND D.ANNOUNCE_DATE <= @DUTY_YYYYMMDD_TO " + "\n");
            sql.append("                                                               AND D.ANNOUNCE_CODE  = (" + "\n");
            sql.append("                                                                                                         SELECT MAX(ANNOUNCE_CODE)" + "\n");
            sql.append("                                                                                                         FROM HUM760T" + "\n");
            sql.append("                                                                                                         WHERE COMP_CODE      = D.COMP_CODE" + "\n");
            sql.append("                                                                                                         AND PERSON_NUMB      = D.PERSON_NUMB" + "\n");
            sql.append("                                                                                                         AND ANNOUNCE_DATE   = D.ANNOUNCE_DATE" + "\n");
            sql.append("                                                                                                         )" + "\n");
            sql.append("                                                             GROUP BY D.COMP_CODE, D.PERSON_NUMB, D.BE_DIV_NAME" + "\n");
            sql.append("                                                     ) AS D ON D.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                                             AND D.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("                                    WHERE B.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                                    AND    B.PAY_PROV_FLAG = @PAY_PROV_FLAG" + "\n");
            sql.append("                                    AND    NVL(B.DIV_CODE, '')      = (CASE WHEN D.BE_DIV_CODE IS NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE B.DIV_CODE END)" + "\n");
            sql.append("                                    AND    NVL(D.BE_DIV_CODE, '') = (CASE WHEN D.BE_DIV_CODE IS NOT NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE ''  END)" + "\n");
            sql.append("                                    AND    B.PERSON_NUMB          = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE B.PERSON_NUMB END)" + "\n");
//          sql.append("                                    AND    NVL(B.DIV_CODE, '')      = (CASE WHEN NVL(D.BE_DIV_CODE, '') = ''   AND @DIV_CODE  <> '' THEN @DIV_CODE ELSE B.DIV_CODE END)" + "\n");
//            sql.append("                                    AND    NVL(D.BE_DIV_CODE, '') = (CASE WHEN NVL(D.BE_DIV_CODE, '') != ''  AND @DIV_CODE  != ''  THEN @DIV_CODE ELSE ''  END)" + "\n");
//            sql.append("                                    AND    B.PERSON_NUMB          = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB ELSE B.PERSON_NUMB END)" + "\n");
//            sql.append("                                    AND    B.DEPT_CODE             >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR ELSE B.DEPT_CODE END)" + "\n");
//            sql.append("                                    AND    B.DEPT_CODE             <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO ELSE B.DEPT_CODE END)" + "\n");
            sql.append("                                    AND    B.PERSON_NUMB NOT IN(SELECT A.PERSON_NUMB" + "\n");
            sql.append("                                                                                    FROM         HAT700T AS A" + "\n");
            sql.append("                                                                                    LEFT   JOIN HAT300T AS B  ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                                                                                                         AND A.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("                                                                                                                         AND B.DUTY_YYYYMM = @DUTY_YYYYMMDD" + "\n");
            sql.append("                                                                                    WHERE A.COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                                                                                    AND    LEFT(A.DUTY_YYYYMMDDFR_USE, 6) <= (CASE WHEN (SELECT YEAR_USE_FR_YYYY " + "\n");
            sql.append("                                                                                                                                                                           FROM T_HAT200UKR_2 " + "\n");
            sql.append("                                                                                                                                                                           WHERE KEY_VALUE = @KeyValue) = 2 And (SELECT YEAR_USE_TO_YYYY " + "\n");
            sql.append("                                                                                                                                                                                                                                        FROM T_HAT200UKR_2" + "\n");
            sql.append("                                                                                                                                                                                                                                        WHERE KEY_VALUE = @KeyValue" + "\n");
            sql.append("                                                                                                                                                                                                                                        ) = 2" + "\n");
            sql.append("                                                                                                                                                                THEN (LEFT(@DUTY_YYYYMMDD, 4) - 1) + RIGHT(@DUTY_YYYYMMDD, 2)" + "\n");
//            sql.append("                                                                                                                                                             THEN (LEFT(@DUTY_YYYYMMDD, 4) - 1) + '' + RIGHT(@DUTY_YYYYMMDD, 2)" + "\n");
            sql.append("                                                                                                                                                                ELSE @DUTY_YYYYMMDD " + "\n");
            sql.append("                                                                                                                                                       END)" + "\n");
            sql.append("                                                                                   AND LEFT(A.DUTY_YYYYMMDDTO_USE, 6)    >= (CASE WHEN (SELECT YEAR_USE_FR_YYYY " + "\n");
            sql.append("                                                                                                                                                                           FROM T_HAT200UKR_2" + "\n");
            sql.append("                                                                                                                                                                           WHERE KEY_VALUE = @KeyValue) = 2 And (SELECT YEAR_USE_TO_YYYY " + "\n");
            sql.append("                                                                                                                                                                                                                                        FROM T_HAT200UKR_2" + "\n");
            sql.append("                                                                                                                                                                                                                                        WHERE KEY_VALUE = @KeyValue) = 2" + "\n");
            sql.append("                                                                                                                                                               THEN (LEFT(@DUTY_YYYYMMDD, 4) - 1) + RIGHT(@DUTY_YYYYMMDD, 2)" + "\n");
//            sql.append("                                                                                                                                                            THEN (LEFT(@DUTY_YYYYMMDD, 4) - 1) + '' + RIGHT(@DUTY_YYYYMMDD, 2)" + "\n");
            sql.append("                                                                                                                                                               ELSE @DUTY_YYYYMMDD " + "\n");
            sql.append("                                                                                                                                                       END)" + "\n");
            sql.append("                                                                                  )" + "\n");
            sql.append("                                ) A    " + "\n");
            sql.append("                ) AA;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--    " + "\n");
            sql.append("--    PRINT '--SQL14_DO UPDATE HAT700T'" + "\n");
            sql.append("--    -- 4." + "\n");
            sql.append("    UPDATE HAT700T A INNER JOIN  (" + "\n");
            sql.append("                                                      SELECT A.DUTY_YYYY                                 AS H_DUTY_YYYY" + "\n");
            sql.append("                                                               ,   A.YEAR_USE -  B.YEAR_USE              AS H_YEAR_USE" + "\n");
            sql.append("                                                               ,  A.YEAR_SAVE -  B.YEAR_GIVE            AS H_YEAR_NUM" + "\n");
            sql.append("                                                               ,  A.MONTH_NUM -  B.MONTH_NUM   AS H_HMONTH_NUM" + "\n");
            sql.append("                                                               ,  A.MONTH_USE -  B.MONTH_USE      AS H_MONTH_USE" + "\n");
            sql.append("                                                               ,  A.MONTH_PROV -  B.MONTH_GIVE   AS H_MONTH_PROV" + "\n");
            sql.append("                                                               ,  A.PERSON_NUMB                           AS H_PERSON_NUMB" + "\n");
            sql.append("                                                               ,  A.COMP_CODE" + "\n");
            sql.append("                                                               ,  A.SUPP_TYPE" + "\n");
            sql.append("                                                      FROM          HAT700T AS A " + "\n");
            sql.append("                                                      INNER JOIN HAT300T AS B ON A.COMP_CODE      = B.COMP_CODE" + "\n");
            sql.append("                                                                                            AND A.PERSON_NUMB  = B.PERSON_NUMB" + "\n");
            sql.append("                                                      INNER JOIN HUM100T AS V ON A.COMP_CODE    = V.COMP_CODE" + "\n");
            sql.append("                                                                                             AND A.PERSON_NUMB = V.PERSON_NUMB" + "\n");
            sql.append("                                                      LEFT  JOIN (" + "\n");
            sql.append("                                                                        SELECT " + "\n");
            sql.append("                                                                                   D.COMP_CODE" + "\n");
            sql.append("                                                                                 , D.PERSON_NUMB" + "\n");
            sql.append("                                                                                 , D.BE_DIV_NAME   AS BE_DIV_CODE" + "\n");
            sql.append("                                                                          FROM HUM760T AS D" + "\n");
            sql.append("                                                                         WHERE D.COMP_CODE      =  @COMP_CODE " + "\n");
            sql.append("                                                                         AND D.ANNOUNCE_DATE >= @DUTY_YYYYMMDD_FR " + "\n");
            sql.append("                                                                         AND D.ANNOUNCE_DATE <= @DUTY_YYYYMMDD_TO" + "\n");
            sql.append("                                                                         AND D.ANNOUNCE_CODE  = (" + "\n");
            sql.append("                                                                                                                   SELECT MAX(ANNOUNCE_CODE)" + "\n");
            sql.append("                                                                                                                   FROM HUM760T" + "\n");
            sql.append("                                                                                                                     WHERE COMP_CODE      = D.COMP_CODE" + "\n");
            sql.append("                                                                                                                   AND PERSON_NUMB    = D.PERSON_NUMB" + "\n");
            sql.append("                                                                                                                   AND ANNOUNCE_DATE  = D.ANNOUNCE_DATE" + "\n");
            sql.append("                                                                                                                   )" + "\n");
            sql.append("                                                                         GROUP BY D.COMP_CODE, D.PERSON_NUMB, D.BE_DIV_NAME" + "\n");
            sql.append("                                                                  ) AS D ON D.COMP_CODE    = V.COMP_CODE" + "\n");
            sql.append("                                                                          AND D.PERSON_NUMB = V.PERSON_NUMB" + "\n");
            sql.append("                                                        WHERE A.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                                                        AND    B.DUTY_YYYYMM  >= LEFT(A.DUTY_YYYYMMDDFR_USE,6) " + "\n");
            sql.append("                                                        AND    B.DUTY_YYYYMM  <= LEFT(A.DUTY_YYYYMMDDTO_USE,6) " + "\n");
            sql.append("                                                        AND    B.DUTY_YYYYMM   = @DUTY_YYYYMMDD " + "\n");
            sql.append("                                                        AND    V.PAY_PROV_FLAG = @PAY_PROV_FLAG" + "\n");
            sql.append("                                                        AND    NVL(V.DIV_CODE, '') = CASE WHEN D.BE_DIV_CODE IS NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE V.DIV_CODE END" + "\n");
            sql.append("                                                        AND    NVL(D.BE_DIV_CODE, '') = CASE WHEN D.BE_DIV_CODE IS NOT NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE ''  END" + "\n");
            sql.append("                                                        AND    V.PERSON_NUMB = CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE V.PERSON_NUMB END" + "\n");
//            sql.append("                                                        AND    NVL(V.DIV_CODE, '') = CASE WHEN NVL(D.BE_DIV_CODE, '') = '' AND @DIV_CODE <> '' THEN @DIV_CODE ELSE V.DIV_CODE END" + "\n");
//            sql.append("                                                        AND    NVL(D.BE_DIV_CODE, '') = CASE WHEN NVL(D.BE_DIV_CODE, '') <> '' AND @DIV_CODE != '' THEN @DIV_CODE ELSE ''  END" + "\n");
//            sql.append("                                                        AND    V.PERSON_NUMB = CASE WHEN NVL(@PERSON_NUMB, '') <> '' THEN @PERSON_NUMB ELSE V.PERSON_NUMB END" + "\n");
//            sql.append("                                                        AND    V.DEPT_CODE >= CASE WHEN NVL(@DEPT_CODE_FR, '') <> '' THEN @DEPT_CODE_FR ELSE V.DEPT_CODE END" + "\n");
//            sql.append("                                                        AND    V.DEPT_CODE <= CASE WHEN NVL(@DEPT_CODE_TO, '') <> '' THEN @DEPT_CODE_TO ELSE V.DEPT_CODE END" + "\n");
            sql.append("                                                    ) AA ON AA.COMP_CODE           = A.COMP_CODE" + "\n");
            sql.append("                                                         AND AA.H_DUTY_YYYY          = A.DUTY_YYYY" + "\n");
            sql.append("                                                         AND AA.SUPP_TYPE              = A.SUPP_TYPE" + "\n");
            sql.append("                                                         AND AA.H_PERSON_NUMB    = A.PERSON_NUMB" + "\n");
            sql.append("                " + "\n");
            sql.append("    SET A.YEAR_USE           = AA.H_YEAR_USE" + "\n");
            sql.append("        , A.YEAR_SAVE          = AA.H_YEAR_NUM" + "\n");
            sql.append("        , A.MONTH_NUM      = AA.H_HMONTH_NUM" + "\n");
            sql.append("        , A.MONTH_USE        = AA.H_MONTH_USE" + "\n");
            sql.append("        , A.MONTH_PROV      = AA.H_MONTH_PROV" + "\n");
            sql.append("        , A.UPDATE_DB_USER = @UPDATE_DB_USER" + "\n");
            sql.append("        , A.UPDATE_DB_TIME  = SYSDATETIME" + "\n");
            sql.append("  WHERE A.COMP_CODE   = @COMP_CODE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--    PRINT '--SQL15_DO DELETE HAT300T'" + "\n");
            sql.append("    --6. 집계테이블을 지움" + "\n");
            sql.append("    DELETE T" + "\n");
            sql.append("    FROM            HAT300T AS T" + "\n");
            sql.append("    INNER JOIN HUM100T AS V ON T.COMP_CODE     = V.COMP_CODE" + "\n");
            sql.append("                                            AND T.PERSON_NUMB = V.PERSON_NUMB" + "\n");
            sql.append("    LEFT    JOIN (" + "\n");
            sql.append("                        SELECT " + "\n");
            sql.append("                               D.COMP_CODE" + "\n");
            sql.append("                             , D.PERSON_NUMB" + "\n");
            sql.append("                             , D.BE_DIV_NAME AS BE_DIV_CODE" + "\n");
            sql.append("                          FROM HUM760T AS D" + "\n");
            sql.append("                         WHERE D.COMP_CODE          =  @COMP_CODE " + "\n");
            sql.append("                         AND     D.ANNOUNCE_DATE >=  @DUTY_YYYYMMDD_FR" + "\n");
            sql.append("                         AND     D.ANNOUNCE_DATE <=  @DUTY_YYYYMMDD_TO " + "\n");
            sql.append("                         AND     D.ANNOUNCE_CODE  = (SELECT MAX(ANNOUNCE_CODE)" + "\n");
            sql.append("                                                                        FROM HUM760T " + "\n");
            sql.append("                                                                         WHERE COMP_CODE          = D.COMP_CODE" + "\n");
            sql.append("                                                                       AND     PERSON_NUMB      = D.PERSON_NUMB" + "\n");
            sql.append("                                                                       AND     ANNOUNCE_DATE  = D.ANNOUNCE_DATE)" + "\n");
            sql.append("                         GROUP BY D.COMP_CODE, D.PERSON_NUMB, D.BE_DIV_NAME" + "\n");
            sql.append("                       ) AS D ON D.COMP_CODE      = V.COMP_CODE" + "\n");
            sql.append("                               AND D.PERSON_NUMB   = V.PERSON_NUMB" + "\n");
            sql.append("    WHERE T.DUTY_YYYYMM   = @DUTY_YYYYMMDD" + "\n");
            sql.append("        AND V.PAY_PROV_FLAG =  @PAY_PROV_FLAG" + "\n");
            sql.append("        AND NVL(V.DIV_CODE, '')     =  (CASE WHEN D.BE_DIV_CODE IS NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE V.DIV_CODE END)" + "\n");
            sql.append("        AND NVL(D.BE_DIV_CODE, '') = (CASE WHEN D.BE_DIV_CODE IS NOT NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE ''  END)" + "\n");
            sql.append("        AND V.PERSON_NUMB          = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE V.PERSON_NUMB END)" + "\n");
//            sql.append("        AND NVL(V.DIV_CODE, '')     =  (CASE WHEN NVL(D.BE_DIV_CODE, '') = '' AND @DIV_CODE <> '' THEN @DIV_CODE ELSE V.DIV_CODE END)" + "\n");
//            sql.append("        AND NVL(D.BE_DIV_CODE, '') = (CASE WHEN NVL(D.BE_DIV_CODE, '') <> '' AND @DIV_CODE != '' THEN @DIV_CODE ELSE ''  END)" + "\n");
//            sql.append("        AND V.PERSON_NUMB          = (CASE WHEN NVL(@PERSON_NUMB, '') <> '' THEN @PERSON_NUMB ELSE V.PERSON_NUMB END)" + "\n");
//            sql.append("        AND V.DEPT_CODE               >= (CASE WHEN NVL(@DEPT_CODE_FR, '') <> '' THEN @DEPT_CODE_FR ELSE V.DEPT_CODE END)" + "\n");
//            sql.append("        AND V.DEPT_CODE               <= (CASE WHEN NVL(@DEPT_CODE_TO, '') <> '' THEN @DEPT_CODE_TO ELSE V.DEPT_CODE END);" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--  6. 근무일수 시간구하기" + "\n");
            sql.append("" + "\n");
            sql.append("--    PRINT '--SQL16_DO INSERT INTO HAT300T'" + "\n");
            sql.append("    INSERT INTO HAT300T" + "\n");
            sql.append("           (DUTY_YYYYMM,     PERSON_NUMB, TOT_DAY,   SUN_DAY,   SAT_DAY, WEEK_DAY,  NON_WEEK_DAY " + "\n");
            sql.append("          , DED_DAY,         DED_TIME,    WORK_DAY,  WORK_TIME, DUTY_FROM, DUTY_TO, INSERT_DB_USER, INSERT_DB_TIME, UPDATE_DB_USER" + "\n");
            sql.append("          , UPDATE_DB_TIME,  COMP_CODE) " + "\n");
            sql.append("     SELECT CC.DUTY_YYYYMM" + "\n");
            sql.append("          , CC.PERSON_NUMB" + "\n");
            sql.append("          , DATEDIFF(@PAY_YYYYMMDD_TO, @PAY_YYYYMMDD_FR) + 1 AS TOT_DAY" + "\n");
            sql.append("          , CC.SUN_DAY" + "\n");
            sql.append("          , CC.SAT_DAY" + "\n");
            sql.append("          , CC.PAY_DAY" + "\n");
            sql.append("          , CC.NON_WEEK_DAY" + "\n");
            sql.append("          , ROUND(CC.DED_DAY,2) AS DED_DAY" + "\n");
            sql.append("          , ROUND(NVL((CC.DED_TIME - NVL(ETC.DED_NUM_88, 0) + NVL(ETC.DED_NUM_84, 0)), 0),2) DED_TIME" + "\n");
            sql.append("          , ROUND(NVL(CASE WHEN  ((CC.PAY_DAY *  CC.DAY_WORK_TIME) - CC.DED_TIME) = 0 THEN 0" + "\n");
            sql.append("                              ELSE (((CC.PAY_DAY *  CC.DAY_WORK_TIME) - CC.DED_TIME) / CC.DAY_WORK_TIME ) " + "\n");
            sql.append("                          END, 0),2) AS  REAL_DAY_NUM" + "\n");
            sql.append("          , NVL(((CC.REAL_DAY_TIME + NVL(CC.DED_TIME, 0)) - (NVL(CC.DED_TIME, 0) - NVL(ETC.DED_NUM_88, 0) + NVL(ETC.DED_NUM_84, 0))), 0) REAL_DAY_TIME" + "\n");
            sql.append("          , TO_CHAR(CC.START_DATE, 'YYYYMMDD') AS START_DATE" + "\n");
            sql.append("          , TO_CHAR(CC.END_DATE  , 'YYYYMMDD') AS END_DATE" + "\n");
            sql.append("          , @UPDATE_DB_USER" + "\n");
            sql.append("          , SYSDATETIME" + "\n");
            sql.append("          , @UPDATE_DB_USER" + "\n");
            sql.append("          , SYSDATETIME" + "\n");
            sql.append("          , CC.COMP_CODE" + "\n");
            sql.append("      FROM (" + "\n");
            sql.append("                 SELECT BB.PERSON_NUMB" + "\n");
            sql.append("                          , BB.DUTY_YYYYMM" + "\n");
            sql.append("                          , (SELECT NVL(SUM(TO_NUMBER(NVL(D.REF_CODE1,0))),0)" + "\n");
            sql.append("                             FROM          HBS600T C" + "\n");
            sql.append("                             INNER JOIN BSA100T D ON D.COMP_CODE  = C.COMP_CODE" + "\n");
            sql.append("                                                              AND D.SUB_CODE     = C.HOLY_TYPE" + "\n");
            sql.append("                                                              AND D.MAIN_CODE   = 'H003'" + "\n");
            sql.append("                                                              AND D.SUB_CODE    != '$'" + "\n");
            sql.append("                                                              " + "\n");
            sql.append("                             WHERE C.COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                             AND    C.DIV_CODE       = BB.DIV_CODE" + "\n");
            sql.append("                             AND    C.CAL_DATE      >= BB.START_DATE" + "\n");
            sql.append("                             AND    C.CAL_DATE      <= BB.END_DATE) - CAST(BB.DED_TIME AS NUMERIC) AS REAL_DAY_TIME" + "\n");
            sql.append("                          ,  DATEDIFF(END_DATE,START_DATE) +1 AS PAY_DAY" + "\n");
            sql.append("                          ,  (SELECT DAY_WORK_TIME FROM HBS400T WHERE COMP_CODE = @COMP_CODE) AS DAY_WORK_TIME" + "\n");
            sql.append("                          , BB.START_DATE" + "\n");
            sql.append("                          , BB.END_DATE" + "\n");
            sql.append("                          , BB.DED_TIME" + "\n");
            sql.append("                          , BB.DED_DAY" + "\n");
            sql.append("                         , (SELECT COUNT(*)" + "\n");
            sql.append("                            FROM HBS600T" + "\n");
            sql.append("                            WHERE COMP_CODE = @COMP_CODE" + "\n");
            sql.append("                            AND     DIV_CODE    = BB.DIV_CODE " + "\n");
            sql.append("                            AND     WEEK_DAY    = '1'" + "\n");
            sql.append("                            AND     CAL_DATE   >= BB.START_DATE " + "\n");
            sql.append("                            AND     CAL_DATE   <= BB.END_DATE )  AS SUN_DAY" + "\n");
            sql.append("                         , (SELECT COUNT(*) " + "\n");
            sql.append("                            FROM HBS600T" + "\n");
            sql.append("                            WHERE COMP_CODE = @COMP_CODE" + "\n");
            sql.append("                            AND    DIV_CODE     = BB.DIV_CODE" + "\n");
            sql.append("                            AND    WEEK_DAY    = '7'" + "\n");
            sql.append("                            AND    CAL_DATE   >= BB.START_DATE " + "\n");
            sql.append("                            AND    CAL_DATE   <= BB.END_DATE ) SAT_DAY" + "\n");
            sql.append("                          , (SELECT COUNT(*)" + "\n");
            sql.append("                               FROM HBS600T" + "\n");
            sql.append("                              WHERE COMP_CODE = @COMP_CODE" + "\n");
            sql.append("                                AND DIV_CODE  = BB.DIV_CODE" + "\n");
            sql.append("                                AND HOLY_TYPE = '3'" + "\n");
            sql.append("                                AND CAL_DATE >= BB.START_DATE " + "\n");
            sql.append("                                AND CAL_DATE <= BB.END_DATE ) AS NON_WEEK_DAY" + "\n");
            sql.append("                          , BB.COMP_CODE " + "\n");
            sql.append("               FROM (" + "\n");
            sql.append("                           SELECT AA.DUTY_YYYYMM" + "\n");
            sql.append("                                    , AA.PERSON_NUMB" + "\n");
            sql.append("                                    , AA.DED_TIME" + "\n");
            sql.append("                                    , AA.DED_DAY" + "\n");
            sql.append("                                    , A.DIV_CODE" + "\n");
            sql.append("                                    , CASE WHEN A.JOIN_DATE >=  @PAY_YYYYMMDD_FR THEN TO_CHAR(A.JOIN_DATE, 'YYYYMMDD')" + "\n");
            sql.append("                                              ELSE TO_CHAR(@PAY_YYYYMMDD_FR, 'YYYYMMDD')" + "\n");
            sql.append("                                      END AS START_DATE" + "\n");
            sql.append("                                    , CASE WHEN A.RETR_DATE >= @PAY_YYYYMMDD_FR AND A.RETR_DATE <= @PAY_YYYYMMDD_TO AND A.RETR_DATE != '00000000' THEN TO_CHAR(A.RETR_DATE, 'YYYYMMDD')" + "\n");
            sql.append("                                              ELSE TO_CHAR(@PAY_YYYYMMDD_TO, 'YYYYMMDD')" + "\n");
            sql.append("                                      END   AS END_DATE" + "\n");
            sql.append("                                  , AA.COMP_CODE" + "\n");
            sql.append("                              FROM            HUM100T A" + "\n");
            sql.append("                            INNER JOIN (" + "\n");
            sql.append("                                                SELECT A.DUTY_YYYYMM" + "\n");
            sql.append("                                                         , A.PERSON_NUMB" + "\n");
            sql.append("                                                         , A.GUBUN" + "\n");
            sql.append("                                                         , SUM(Y_NUM) Y_NUM" + "\n");
            sql.append("                                                         , SUM(Y_TIME) Y_TIME" + "\n");
            sql.append("                                                         , SUM(N_NUM) N_NUM" + "\n");
            sql.append("                                                         , SUM(N_TIME) N_TIME" + "\n");
            sql.append("                                                         , SUM(Y_TIME) + (SUM(Y_NUM) * M1.DAY_WORK_TIME)  DED_TIME" + "\n");
            sql.append("                                                         , CASE WHEN (SUM(Y_TIME)  + (SUM(Y_NUM)  * M1.DAY_WORK_TIME)) = 0 THEN 0 " + "\n");
            sql.append("                                                                ELSE (SUM(Y_TIME)  + (SUM(Y_NUM)  * M1.DAY_WORK_TIME))" + "\n");
            sql.append("                                                                                                  / M1.DAY_WORK_TIME " + "\n");
            sql.append("                                                            END  AS DED_DAY " + "\n");
            sql.append("                                                         , A.COMP_CODE  " + "\n");
            sql.append("                                                 FROM (" + "\n");
            sql.append("                                                            SELECT 'Y' GUBUN" + "\n");
            sql.append("                                                                     , A.PERSON_NUMB" + "\n");
            sql.append("                                                                     , A.DUTY_YYYYMM" + "\n");
            sql.append("                                                                     , A.DUTY_CODE" + "\n");
            sql.append("                                                                     , B.MARGIR_TYPE" + "\n");
            sql.append("                                                                     , B.PAY_CODE" + "\n");
            sql.append("                                                                     , (A.DUTY_NUM * TO_NUMBER(CASE WHEN M1.REF_CODE4 IS NULL THEN '1'" + "\n");
//            sql.append("                                                                     , (A.DUTY_NUM * TO_NUMBER(CASE WHEN M1.REF_CODE4 = '' THEN '1'" + "\n");
            sql.append("                                                                                                                         ELSE NVL(M1.REF_CODE4,'1')" + "\n");
            sql.append("                                                                                                                 END)) AS Y_NUM -- 반차적용" + "\n");
            sql.append("                                                                     , A.DUTY_TIME AS Y_TIME" + "\n");
            sql.append("                                                                     , 0           AS N_NUM" + "\n");
            sql.append("                                                                     , 0           AS N_TIME" + "\n");
            sql.append("                                                                     , A.COMP_CODE" + "\n");
            sql.append("                                                               FROM          HAT200T  A" + "\n");
            sql.append("                                                             INNER JOIN HBS100T  B ON B.COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("                                                                                               AND B.DUTY_CODE     = A.DUTY_CODE" + "\n");
            sql.append("                                                             INNER JOIN HUM100T C ON C.COMP_CODE   = A.COMP_CODE" + "\n");
            sql.append("                                                                                               AND C.PAY_CODE       = B.PAY_CODE" + "\n");
            sql.append("                                                                                               AND C.PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append("                                                             LEFT    JOIN BSA100T M1 ON M1.COMP_CODE  = A.COMP_CODE" + "\n");
            sql.append("                                                                                                AND M1.SUB_CODE     = A.DUTY_CODE" + "\n");
            sql.append("                                                                                                AND M1.MAIN_CODE   = 'H033'" + "\n");
            sql.append("                                                                                                AND M1.REF_CODE3    = 'Y'" + "\n");
            sql.append("                                                             WHERE A.COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                                                             AND    A.DUTY_YYYYMM = @DUTY_YYYYMMDD" + "\n");
            sql.append("                                                             AND    B.MARGIR_TYPE    = 'Y'" + "\n");
            sql.append("     " + "\n");
            sql.append("                                                             UNION ALL" + "\n");
            sql.append("     " + "\n");
            sql.append("                                                            SELECT 'Y' GUBUN" + "\n");
            sql.append("                                                                     , A.PERSON_NUMB" + "\n");
            sql.append("                                                                     , A.DUTY_YYYYMM" + "\n");
            sql.append("                                                                     , A.DUTY_CODE" + "\n");
            sql.append("                                                                     , B.MARGIR_TYPE" + "\n");
            sql.append("                                                                     , B.PAY_CODE" + "\n");
            sql.append("                                                                     , 0           AS Y_NUM" + "\n");
            sql.append("                                                                     , 0           AS Y_TIME" + "\n");
            sql.append("                                                                     , (A.DUTY_NUM * TO_NUMBER(CASE WHEN REF_CODE4 IS NULL THEN '1'" + "\n");
//            sql.append("                                                                     , (A.DUTY_NUM * TO_NUMBER(CASE WHEN REF_CODE4 = '' THEN '1'" + "\n");
            sql.append("                                                                                                                         ELSE NVL(REF_CODE4,'1')" + "\n");
            sql.append("                                                                                                                 END)) AS N_NUM -- 반차적용" + "\n");
            sql.append("                                                                     , A.DUTY_TIME AS N_TIME" + "\n");
            sql.append("                                                                     , A.COMP_CODE" + "\n");
            sql.append("                                                              FROM          HAT200T  A" + "\n");
            sql.append("                                                              INNER JOIN HBS100T  B ON B.COMP_CODE      = A.COMP_CODE" + "\n");
            sql.append("                                                                                                AND B.DUTY_CODE       = A.DUTY_CODE" + "\n");
            sql.append("                                                              INNER JOIN HUM100T  C ON C.COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("                                                                                                 AND C.PAY_CODE        = B.PAY_CODE" + "\n");
            sql.append("                                                                                                 AND C.PERSON_NUMB  = A.PERSON_NUMB" + "\n");
            sql.append("                                                              LEFT    JOIN BSA100T M1 ON  M1.COMP_CODE  = A.COMP_CODE" + "\n");
            sql.append("                                                                                                  AND M1.SUB_CODE     = A.DUTY_CODE" + "\n");
            sql.append("                                                                                                  AND M1.MAIN_CODE   = 'H033'" + "\n");
            sql.append("                                                                                                  AND M1.REF_CODE3    = 'Y'" + "\n");
            sql.append("                                                              WHERE A.COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                                                              AND    A.DUTY_YYYYMM = @DUTY_YYYYMMDD" + "\n");
            sql.append("                                                              AND    B.MARGIR_TYPE    = 'N'" + "\n");
            sql.append("                                                         ) A" + "\n");
            sql.append("                                                         INNER JOIN HBS400T M1 ON M1.COMP_CODE = A.COMP_CODE" + "\n");
            sql.append("                                                GROUP BY A.DUTY_YYYYMM, A.PERSON_NUMB, A.GUBUN, A.COMP_CODE, M1.DAY_WORK_TIME" + "\n");
            sql.append("                                       ) AA ON AA.COMP_CODE   = A.COMP_CODE" + "\n");
            sql.append("                                           AND AA.PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append("                      WHERE A.COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                        AND A.JOIN_DATE      <= @PAY_YYYYMMDD_TO" + "\n");
            sql.append("                        AND (A.RETR_DATE     >= @PAY_YYYYMMDD_FR OR  A.RETR_DATE   = '00000000')" + "\n");
            sql.append("                        AND A.DIV_CODE         =  CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE A.DIV_CODE END" + "\n");
            sql.append("                        AND A.PAY_PROV_FLAG =  CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END" + "\n");
            sql.append("                        AND A.PERSON_NUMB = CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE A.PERSON_NUMB END" + "\n");
//            sql.append("                        AND A.DIV_CODE         =  CASE WHEN @DIV_CODE <> '' THEN @DIV_CODE ELSE A.DIV_CODE END" + "\n");
//            sql.append("                        AND A.PAY_PROV_FLAG =  CASE WHEN @PAY_PROV_FLAG != '' THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END" + "\n");
//            sql.append("                        AND A.PERSON_NUMB = CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB ELSE A.PERSON_NUMB END" + "\n");
//            sql.append("                        AND A.DEPT_CODE >= CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR ELSE A.DEPT_CODE END" + "\n");
//            sql.append("                        AND A.DEPT_CODE <= CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO ELSE A.DEPT_CODE END" + "\n");
            sql.append("                    ) BB " + "\n");
            sql.append("            ) CC" + "\n");
            sql.append("          LEFT JOIN (" + "\n");
            sql.append("                               SELECT  A.COMP_CODE" + "\n");
            sql.append("                                        ,  A.PERSON_NUMB" + "\n");
            sql.append("                                        ,  SUM(NVL(CAST(DD.REF_CODE1 AS INT), 0))               AS DED_NUM_84" + "\n");
            sql.append("                                        ,  SUM(NVL(A.DUTY_NUM, 0) * NVL(D.DAY_WORK_TIME, 0)) AS DED_NUM_88              " + "\n");
            sql.append("                               FROM               HAT600T  A" + "\n");
            sql.append("                               INNER JOIN HUM100T B ON B.COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("                                                                 AND B.PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append("                               INNER JOIN HBS100T C ON C.COMP_CODE     = A.COMP_CODE" + "\n");
            sql.append("                                                                AND C.DUTY_CODE       = A.DUTY_CODE" + "\n");
            sql.append("                                                                AND C.PAY_CODE         = B.PAY_CODE" + "\n");
            sql.append("                               INNER JOIN HBS400T D ON D.COMP_CODE     = A.COMP_CODE" + "\n");
            sql.append("                               INNER JOIN (" + "\n");
            sql.append("                                                      SELECT C.COMP_CODE " + "\n");
            sql.append("                                                                , C.CAL_DATE" + "\n");
            sql.append("                                                                , D.REF_CODE1" + "\n");
            sql.append("                                                                , C.DIV_CODE" + "\n");
            sql.append("                                                      FROM          HBS600T C" + "\n");
            sql.append("                                                      INNER JOIN BSA100T D  ON D.COMP_CODE  = C.COMP_CODE" + "\n");
            sql.append("                                                                                        AND D.SUB_CODE     = C.HOLY_TYPE" + "\n");
            sql.append("                                                                                        AND D.MAIN_CODE   = 'H003'" + "\n");
            sql.append("                                                      WHERE C.COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                                                      AND    C.CAL_DATE      >= @PAY_YYYYMMDD_FR              " + "\n");
            sql.append("                                                      AND    C.CAL_DATE      <= @PAY_YYYYMMDD_TO" + "\n");
            sql.append("                                                 ) DD ON DD.COMP_CODE = A.COMP_CODE" + "\n");
            sql.append("                                                       AND DD.DIV_CODE    = B.DIV_CODE" + "\n");
            sql.append("                                                       AND DD.CAL_DATE    = A.DUTY_YYYYMMDD" + "\n");
            sql.append("                               WHERE A.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("                               AND A.DUTY_YYYYMMDD >= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                               AND A.DUTY_YYYYMMDD <= (CASE WHEN B.RETR_DATE = '00000000' THEN @PAY_YYYYMMDD_TO" + "\n");
            sql.append("                                                                                   ELSE B.RETR_DATE" + "\n");
            sql.append("                                                                          END)" + "\n");
            sql.append("                                AND C.COTR_TYPE      = '2'" + "\n");
            sql.append("                                AND MARGIR_TYPE      = 'Y'" + "\n");
            sql.append("                                AND A.DUTY_NUM       > 0" + "\n");
            sql.append("                              GROUP BY A.COMP_CODE, A.PERSON_NUMB" + "\n");
            sql.append("                            ) ETC ON ETC.COMP_CODE    = CC.COMP_CODE" + "\n");
            sql.append("                                  AND ETC.PERSON_NUMB = CC.PERSON_NUMB" + "\n");
            sql.append("      WHERE CC.COMP_CODE  =  @COMP_CODE    ;" + "\n");
            sql.append("      " + "\n");
            sql.append("" + "\n");
            sql.append("--  7. 일수근태가져오기" + "\n");
            sql.append("--    PRINT '--VB : fnDateCalcu1'" + "\n");
            sql.append("--    PRINT '--SQL17_DO UPDATE HAT300T'" + "\n");
            sql.append("    --1. 월차발생(300T insert)" + "\n");
            sql.append("    UPDATE HAT300T A " + "\n");
            sql.append("                 INNER JOIN     " + "\n");
            sql.append("                (" + "\n");
            sql.append("                SELECT @DUTY_YYYYMMDD AS H_DUTY_YYYYMM" + "\n");
            sql.append("                         , AA.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                         , NVL((CASE WHEN MONTH_CALCU_YN = 'Y' THEN (CASE WHEN SUM(AA.DUTY_SUM) > 0 THEN 0" + "\n");
            sql.append("                                                                                                           WHEN MAX(BB.TOT_DAY) = MAX(BB.WEEK_DAY) THEN 1" + "\n");
            sql.append("                                                                                                           ELSE 0" + "\n");
            sql.append("                                                                                                  END)" + "\n");
            sql.append("                                           ELSE 0" + "\n");
            sql.append("                                   END), 0) AS MONTH_MAKE" + "\n");
            sql.append("                         , AA.COMP_CODE" + "\n");
            sql.append("                FROM (" + "\n");
            sql.append("                            SELECT AA.PERSON_NUMB" + "\n");
            sql.append("                                     , AA.DUTY_YYYYMM" + "\n");
            sql.append("                                     , UPPER(MONTH_REL_CODE) MONTH_REL_CODE" + "\n");
            sql.append("                                     , CASE WHEN UPPER(MONTH_REL_CODE)  = 'Y' THEN NVL((SELECT NVL(DUTY_NUM +DUTY_TIME,0)" + "\n");
            sql.append("                                                                                        FROM HAT200T            " + "\n");
            sql.append("                                                                                        WHERE COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                                                                                        AND   PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                                                                                        AND   PERSON_NUMB  = AA.PERSON_NUMB" + "\n");
            sql.append("                                                                                        AND   DUTY_YYYYMM  = AA.BASIC_DUTY_YYYYMM" + "\n");
            sql.append("                                                                                        AND   DUTY_CODE    = D.DUTY_CODE ), 0) " + "\n");
            sql.append("                                               ELSE 0" + "\n");
            sql.append("                                       END AS DUTY_SUM" + "\n");
            sql.append("                                     , D.DUTY_CODE" + "\n");
            sql.append("                                     , C.COMP_CODE" + "\n");
            sql.append("                                     , AA.BASIC_DUTY_YYYYMM" + "\n");
            sql.append("                                     , MONTH_CALCU_YN" + "\n");
            sql.append("                            FROM          HUM100T C " + "\n");
            sql.append("                            INNER JOIN HBS100T D ON C.COMP_CODE = D.COMP_CODE" + "\n");
            sql.append("                                                              AND C.PAY_CODE     = D.PAY_CODE" + "\n");
            sql.append("                            INNER JOIN HBS400T E ON D.COMP_CODE = E.COMP_CODE" + "\n");
            sql.append("                            INNER JOIN (" + "\n");
            sql.append("                            " + "\n");
            sql.append("                                               SELECT DISTINCT(A.PERSON_NUMB) AS PERSON_NUMB" + "\n");
            sql.append("                                                         , A.COMP_CODE" + "\n");
            sql.append("                                                         , DUTY_YYYYMM" + "\n");
            sql.append("                                                         , CASE WHEN B.AMASS_NUM = '0' THEN TO_CHAR(DUTY_YYYYMM + '01', 'YYYYMMDD')" + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '1' THEN TO_CHAR(TO_DATE(ADDDATE( DUTY_YYYYMM+ '01' , INTERVAL +1 MONTH)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '8' THEN TO_CHAR(TO_DATE(ADDDATE( DUTY_YYYYMM+ '01' , INTERVAL -1 MONTH)), 'YYYYMMDD')     " + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '9' THEN TO_CHAR(TO_DATE(ADDDATE( DUTY_YYYYMM + '01', INTERVAL -2 MONTH)), 'YYYYMMDD')" + "\n");
            sql.append("                                                           END AS BASIC_DUTY_YYYYMM             " + "\n");
            sql.append("                                                         , CASE WHEN B.AMASS_NUM = '0' THEN TO_CHAR(DUTY_YYYYMM + '01', 'YYYYMMDD')" + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '1' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_FR , INTERVAL +1 MONTH)), 'YYYYMMDD')            " + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '8' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_FR , INTERVAL -1 MONTH)), 'YYYYMMDD')                  " + "\n");
            sql.append("                                                                   WHEN B.AMASS_NUM = '9' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_FR , INTERVAL -2 MONTH)), 'YYYYMMDD')            " + "\n");
            sql.append("                                                          END AS BASIC_DUTY_YYYYMMDDFR             " + "\n");
            sql.append("                                                        , CASE WHEN B.AMASS_NUM = '0' THEN TO_CHAR(@PAY_YYYYMMDD_FR,  'YYYYMMDD')" + "\n");
            sql.append("                                                                  WHEN B.AMASS_NUM = '1' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_TO , INTERVAL +1 MONTH)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                  WHEN B.AMASS_NUM = '8' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_TO , INTERVAL -1 MONTH)), 'YYYYMMDD')" + "\n");
            sql.append("                                                                  WHEN B.AMASS_NUM = '9' THEN TO_CHAR(TO_DATE(ADDDATE( @PAY_YYYYMMDD_TO , INTERVAL -2 MONTH)), 'YYYYMMDD')" + "\n");
            sql.append("                                                          END AS BASIC_DUTY_YYYYMMDDTO             " + "\n");
            sql.append("                                                    FROM          HAT200T A " + "\n");
            sql.append("                                                    INNER JOIN HBS340T  B ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                                    INNER JOIN HUM100T C ON B.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                                                                                       AND B.PAY_CODE       = C.PAY_CODE " + "\n");
            sql.append("                                                                                       AND A.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                                                                                       AND A.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                                                    WHERE A.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                                                    AND C.DIV_CODE             =  (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE C.DIV_CODE          END)" + "\n");
            sql.append("                                                    AND C.PAY_PROV_FLAG    =  (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                                                    AND C.PERSON_NUMB      = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                                                    AND C.DIV_CODE             =  (CASE WHEN @DIV_CODE                  != '' THEN @DIV_CODE         ELSE C.DIV_CODE          END)" + "\n");
//            sql.append("                                                    AND C.PAY_PROV_FLAG    =  (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                                                    AND C.PERSON_NUMB      = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                                                    AND C.DEPT_CODE         >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                                                    AND C.DEPT_CODE         <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("                                                   AND A.DUTY_YYYYMM       = @DUTY_YYYYMMDD " + "\n");
            sql.append("                                                ) AA ON AA.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                     AND AA.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                         WHERE C.COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                         AND D.COMP_CODE      = @COMP_CODE                " + "\n");
            sql.append("                         AND C.JOIN_DATE        <= AA.BASIC_DUTY_YYYYMMDDTO" + "\n");
            sql.append("                         AND C.PERSON_NUMB   = AA.PERSON_NUMB" + "\n");
            sql.append("                         AND (C.RETR_DATE      >= AA.BASIC_DUTY_YYYYMMDDFR   OR  C.RETR_DATE = '00000000')" + "\n");
            sql.append("                         " + "\n");
            sql.append("                    ) AA, HAT300T BB" + "\n");
            sql.append("                WHERE AA.COMP_CODE             = BB.COMP_CODE " + "\n");
            sql.append("                AND    AA.PERSON_NUMB          = BB.PERSON_NUMB " + "\n");
            sql.append("                AND    AA.BASIC_DUTY_YYYYMM = BB.DUTY_YYYYMM" + "\n");
            sql.append("                GROUP BY AA.PERSON_NUMB, AA.COMP_CODE, AA.MONTH_CALCU_YN" + "\n");
            sql.append("       ) B ON B.COMP_CODE           = A.COMP_CODE" + "\n");
            sql.append("          AND B.H_DUTY_YYYYMM    = A.DUTY_YYYYMM" + "\n");
            sql.append("          AND B.H_PERSON_NUMB = A.PERSON_NUMB       " + "\n");
            sql.append("    SET MONTH_NUM = B.MONTH_MAKE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL18_DO UPDATE HAT700T'" + "\n");
            //sql.append("    --2. 월차발생(700T update)" + "\n");
            sql.append("    UPDATE HAT700T A" + "\n");
            sql.append("              INNER JOIN" + "\n");
            sql.append("              (" + "\n");
            sql.append("               SELECT A.DUTY_YYYY AS H_DUTY_YYYY" + "\n");
            sql.append("                        , A.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                        , (A.MONTH_NUM  + B.MONTH_NUM) AS H_MONTH_NUM" + "\n");
            sql.append("                        , A.COMP_CODE H_COMP_CODE" + "\n");
            sql.append("               FROM          HAT700T  A " + "\n");
            sql.append("               INNER JOIN HAT300T  B ON A.COMP_CODE      = B.COMP_CODE" + "\n");
            sql.append("                                                 AND A.PERSON_NUMB   = B.PERSON_NUMB " + "\n");
            sql.append("               INNER JOIN HUM100T C ON A.COMP_CODE      = C.COMP_CODE" + "\n");
            sql.append("                                                  AND A.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                                                  AND B.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                  AND B.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                WHERE B.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("                AND B.DUTY_YYYYMM     >= LEFT(A.DUTY_YYYYMMDDFR_USE,6) " + "\n");
            sql.append("                AND B.DUTY_YYYYMM     <= LEFT(A.DUTY_YYYYMMDDTO_USE,6) " + "\n");
            sql.append("                AND B.DUTY_YYYYMM       = @DUTY_YYYYMMDD" + "\n");
            sql.append("                AND C.DIV_CODE              = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE C.DIV_CODE         END)" + "\n");
            sql.append("                AND C.PAY_PROV_FLAG     = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                AND C.PERSON_NUMB      = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                AND C.DIV_CODE              = (CASE WHEN @DIV_CODE                  != '' THEN @DIV_CODE          ELSE C.DIV_CODE         END)" + "\n");
//            sql.append("                AND C.PAY_PROV_FLAG     = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                AND C.PERSON_NUMB      = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                AND C.DEPT_CODE         >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                AND C.DEPT_CODE         <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("              ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("                 AND B.H_DUTY_YYYY      = A.DUTY_YYYY" + "\n");
            sql.append("                 AND B.H_PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append("                  " + "\n");
            sql.append("    SET A.MONTH_NUM = B.H_MONTH_NUM;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL19_DO UPDATE HAT300T'" + "\n");
            //sql.append("    --3.월차사용(300T insert)" + "\n");
            sql.append("    UPDATE HAT300T A " + "\n");
            sql.append("          INNER JOIN" + "\n");
            sql.append("         (" + "\n");
            sql.append("         SELECT DUTY_YYYYMM AS H_DUTY_YYYYMM" + "\n");
            sql.append("                    , A.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                    , SUM(DUTY_NUM) H_MONTH_USE " + "\n");
            sql.append("                    , A.COMP_CODE H_COMP_CODE" + "\n");
            sql.append("           FROM          HAT200T A " + "\n");
            sql.append("           INNER JOIN HUM100T B ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                             AND A.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("          WHERE A.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("          AND   DUTY_YYYYMM       = @DUTY_YYYYMMDD" + "\n");
            sql.append("          AND   DUTY_CODE         = '22'" + "\n");
            sql.append("          AND   B.DIV_CODE        = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE       ELSE B.DIV_CODE        END)" + "\n");
            sql.append("          AND   B.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG  ELSE B.PAY_PROV_FLAG   END)" + "\n");
            sql.append("          AND   B.PERSON_NUMB     = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB    ELSE B.PERSON_NUMB     END)" + "\n");
//            sql.append("          AND   B.DIV_CODE        = (CASE WHEN  @DIV_CODE              != '' THEN @DIV_CODE       ELSE B.DIV_CODE        END)" + "\n");
//            sql.append("          AND   B.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG  ELSE B.PAY_PROV_FLAG   END)" + "\n");
//            sql.append("          AND   B.PERSON_NUMB     = (CASE WHEN NVL(@PERSON_NUMB, '')   != '' THEN @PERSON_NUMB    ELSE B.PERSON_NUMB     END)" + "\n");
//            sql.append("          AND   B.DEPT_CODE      >= (CASE WHEN NVL(@DEPT_CODE_FR, '')  != '' THEN @DEPT_CODE_FR   ELSE B.DEPT_CODE       END)" + "\n");
//            sql.append("          AND   B.DEPT_CODE      <= (CASE WHEN NVL(@DEPT_CODE_TO, '')  != '' THEN @DEPT_CODE_TO   ELSE B.DEPT_CODE       END)" + "\n");
            sql.append("         GROUP BY DUTY_YYYYMM, A.PERSON_NUMB, A.COMP_CODE" + "\n");
            sql.append("         ) B ON B.H_COMP_CODE       = A.COMP_CODE" + "\n");
            sql.append("            AND B.H_DUTY_YYYYMM    = A.DUTY_YYYYMM" + "\n");
            sql.append("            AND B.H_PERSON_NUMB    = A.PERSON_NUMB         " + "\n");
            sql.append("    SET A.MONTH_USE = B.H_MONTH_USE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--" + "\n");
            //sql.append("--    PRINT '--SQL20_DO UPDATE HAT700T'" + "\n");
            //sql.append("    --4.월차사용(700T insert)" + "\n");
            sql.append("    UPDATE HAT700T A" + "\n");
            sql.append("    INNER JOIN" + "\n");
            sql.append("     (" + "\n");
            sql.append("     SELECT A.DUTY_YYYY AS H_DUTY_YYYY" + "\n");
            sql.append("          , A.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("          , (A.MONTH_USE  + B.MONTH_USE) AS H_MONTH_USE" + "\n");
            sql.append("          , A.COMP_CODE H_COMP_CODE" + "\n");
            sql.append("     FROM          HAT700T  A " + "\n");
            sql.append("     INNER JOIN HAT300T  B ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                          AND A.PERSON_NUMB = B.PERSON_NUMB " + "\n");
            sql.append("     INNER JOIN HUM100T C ON A.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                         AND A.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                         AND B.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                         AND B.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("     WHERE A.COMP_CODE      = @COMP_CODE" + "\n");
            sql.append("     AND  ((B.DUTY_YYYYMM     >= LEFT(A.DUTY_YYYYMMDDFR_USE,6)) " + "\n");
            sql.append("     AND   (B.DUTY_YYYYMM     <= LEFT(A.DUTY_YYYYMMDDTO_USE,6))) " + "\n");
            sql.append("     AND   B.DUTY_YYYYMM       = @DUTY_YYYYMMDD" + "\n");
            sql.append("     AND   C.DIV_CODE          = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE       ELSE C.DIV_CODE         END)" + "\n");
            sql.append("     AND   C.PAY_PROV_FLAG     = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG  ELSE C.PAY_PROV_FLAG    END)" + "\n");
            sql.append("     AND   C.PERSON_NUMB       = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB    ELSE C.PERSON_NUMB      END)" + "\n");
//            sql.append("     AND   C.DIV_CODE          = (CASE WHEN @DIV_CODE              != '' THEN @DIV_CODE       ELSE C.DIV_CODE         END)" + "\n");
//            sql.append("     AND   C.PAY_PROV_FLAG     = (CASE WHEN @PAY_PROV_FLAG         != '' THEN @PAY_PROV_FLAG  ELSE C.PAY_PROV_FLAG    END)" + "\n");
//            sql.append("     AND   C.PERSON_NUMB       = (CASE WHEN NVL(@PERSON_NUMB, '')  != '' THEN @PERSON_NUMB    ELSE C.PERSON_NUMB      END)" + "\n");
//            sql.append("     AND   C.DEPT_CODE        >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("     AND   C.DEPT_CODE        <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO   ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("    ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("       AND B.H_DUTY_YYYY    = A.DUTY_YYYY" + "\n");
            sql.append("       AND B.H_PERSON_NUMB  = A.PERSON_NUMB" + "\n");
            sql.append("    SET A.MONTH_USE = B.H_MONTH_USE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL21_DO UPDATE HAT300T'" + "\n");
            //sql.append("    --5.월차지급(700T 업데이트)" + "\n");
            //sql.append("    --5.월차지급(700T 업데이트)" + "\n");
            sql.append("    UPDATE HAT300T A" + "\n");
            sql.append("             INNER JOIN" + "\n");
            sql.append("            (" + "\n");
            sql.append("               SELECT AA.DUTY_YYYYMM AS H_DUTY_YYYYMM" + "\n");
            sql.append("                        , AA.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                        , CASE WHEN (SELECT MONTH_CALCU_YN" + "\n");
            sql.append("                                             FROM HBS400T" + "\n");
            sql.append("                                             WHERE COMP_CODE = @COMP_CODE) = 'N' THEN 0 " + "\n");
            sql.append("                                  ELSE (AA.USE_MONTH )  " + "\n");
            sql.append("                          END AS H_MONTH_PROV" + "\n");
            sql.append("                        , AA.COMP_CODE AS H_COMP_CODE" + "\n");
            sql.append("               FROM (" + "\n");
            sql.append("                          SELECT  DISTINCT(A.PERSON_NUMB) AS PERSON_NUMB" + "\n");
            sql.append("                                  , A.DUTY_YYYY" + "\n");
            sql.append("                                  , B.DUTY_YYYYMM" + "\n");
            sql.append("                                  , A.MONTH_PROV" + "\n");
            sql.append("                                  , (MONTH_NUM - MONTH_USE - MONTH_PROV - SAVE_MONTH_NUM ) AS  USE_MONTH" + "\n");
            sql.append("                                  , (SELECT MONTH_NUM " + "\n");
            sql.append("                                     FROM HAT300T " + "\n");
            sql.append("                                     WHERE COMP_CODE   =  @COMP_CODE" + "\n");
            sql.append("                                     AND DUTY_YYYYMM   =  @DUTY_YYYYMMDD " + "\n");
            sql.append("                                     AND PERSON_NUMB   = A.PERSON_NUMB" + "\n");
            sql.append("                                     AND DUTY_YYYYMM >= LEFT(A.DUTY_YYYYMMDDFR_USE,6)" + "\n");
            sql.append("                                     AND DUTY_YYYYMM <= LEFT(A.DUTY_YYYYMMDDTO_USE,6) " + "\n");
            sql.append("                                     )  AS MONTH_NUM" + "\n");
            sql.append("                                  , (SELECT MONTH_USE " + "\n");
            sql.append("                                     FROM HAT300T " + "\n");
            sql.append("                                     WHERE COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                                     AND DUTY_YYYYMM   = @DUTY_YYYYMMDD " + "\n");
            sql.append("                                        AND PERSON_NUMB   = A.PERSON_NUMB" + "\n");
            sql.append("                                     AND DUTY_YYYYMM >= LEFT(A.DUTY_YYYYMMDDFR_USE,6)" + "\n");
            sql.append("                                     AND DUTY_YYYYMM <= LEFT(A.DUTY_YYYYMMDDTO_USE,6) " + "\n");
            sql.append("                                     ) AS MONTH_USE" + "\n");
            sql.append("                                 , A.COMP_CODE" + "\n");
            sql.append("                       FROM          HAT700T  A " + "\n");
            sql.append("                       INNER JOIN HAT200T  B ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                                         AND A.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("                       INNER JOIN HUM100T C ON A.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                                                         AND A.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                                                         AND B.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                         AND B.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                       INNER JOIN HBS340T D ON C.COMP_CODE     = D.COMP_CODE" + "\n");
            sql.append("                                                        AND C.PAY_CODE         = D.PAY_CODE" + "\n");
            sql.append("                       WHERE A.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("                        AND   ((B.DUTY_YYYYMM >= LEFT(A.DUTY_YYYYMMDDFR_USE,6))" + "\n");
            sql.append("                        AND   (B.DUTY_YYYYMM <= LEFT(A.DUTY_YYYYMMDDTO_USE,6)))" + "\n");
            sql.append("                        AND   C.JOIN_DATE        <= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                        AND   (C.RETR_DATE       >= @PAY_YYYYMMDD_TO  OR  C.RETR_DATE = '00000000' )" + "\n");
            sql.append("                        AND   C.DIV_CODE           = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE C.DIV_CODE          END)" + "\n");
            sql.append("                        AND   C.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                        AND   C.PERSON_NUMB    = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                        AND   C.DIV_CODE           = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE C.DIV_CODE          END)" + "\n");
//            sql.append("                        AND   C.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                        AND   C.PERSON_NUMB    = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                        AND   C.DEPT_CODE       >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                        AND   C.DEPT_CODE       <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("                        AND B.DUTY_YYYYMM = @DUTY_YYYYMMDD" + "\n");
            sql.append("                        ) AA" + "\n");
            sql.append("             WHERE AA.COMP_CODE = @COMP_CODE" + "\n");
            sql.append("             AND AA.USE_MONTH     > 0 " + "\n");
            sql.append("             ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("               AND B.H_DUTY_YYYYMM = A.DUTY_YYYYMM" + "\n");
            sql.append("               AND B.H_PERSON_NUMB = A.PERSON_NUMB                 " + "\n");
            sql.append("    SET A.MONTH_GIVE = B.H_MONTH_PROV;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL22_DO UPDATE HAT700T'" + "\n");
            //sql.append("    --6." + "\n");
            sql.append("    UPDATE HAT700T A" + "\n");
            sql.append("                INNER JOIN " + "\n");
            sql.append("              (" + "\n");
            sql.append("               SELECT AA.DUTY_YYYY AS H_DUTY_YYYY" + "\n");
            sql.append("                        , AA.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                        , (AA.USE_MONTH) H_MONTH_PROV" + "\n");
            sql.append("                        , AA.COMP_CODE AS H_COMP_CODE" + "\n");
            sql.append("               FROM (" + "\n");
            sql.append("                           SELECT DISTINCT(A.PERSON_NUMB) PERSON_NUMB" + "\n");
            sql.append("                                    , A.DUTY_YYYY" + "\n");
            sql.append("                                    , B.DUTY_YYYYMM" + "\n");
            sql.append("                                    , A.MONTH_PROV" + "\n");
            sql.append("                                    , (A.MONTH_PROV + B.MONTH_GIVE) AS  USE_MONTH" + "\n");
            sql.append("                                    , A.COMP_CODE" + "\n");
            sql.append("                           FROM          HAT700T A " + "\n");
            sql.append("                           INNER JOIN HAT300T B  ON A.COMP_CODE     = B.COMP_CODE" + "\n");
            sql.append("                                                             AND A.PERSON_NUMB  = B.PERSON_NUMB" + "\n");
            sql.append("                           INNER JOIN HUM100T C ON A.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                                                             AND A.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                                                             AND B.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                             AND B.PERSON_NUMB  = C.PERSON_NUMB" + "\n");
            sql.append("                           WHERE A.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                           AND    B.DUTY_YYYYMM >= LEFT(A.DUTY_YYYYMMDDFR_USE,6)" + "\n");
            sql.append("                           AND    B.DUTY_YYYYMM <= LEFT(A.DUTY_YYYYMMDDTO_USE,6)" + "\n");
            sql.append("                             AND    C.DIV_CODE          = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE          ELSE C.DIV_CODE         END)" + "\n");
            sql.append("                           AND    C.PAY_PROV_FLAG = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                           AND    C.PERSON_NUMB   = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                           AND    C.DIV_CODE          = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE          ELSE C.DIV_CODE         END)" + "\n");
//            sql.append("                           AND    C.PAY_PROV_FLAG = (CASE WHEN @PAY_PROV_FLAG           != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                           AND    C.PERSON_NUMB   = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                           AND    C.DEPT_CODE      >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                           AND    C.DEPT_CODE      <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("                           AND    B.DUTY_YYYYMM  = @DUTY_YYYYMMDD) AA" + "\n");
            sql.append("          ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("             AND B.H_DUTY_YYYY      = A.DUTY_YYYY" + "\n");
            sql.append("             AND B.H_PERSON_NUMB = A.PERSON_NUMB    " + "\n");
            sql.append("    SET A.MONTH_PROV = B.H_MONTH_PROV;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    " + "\n");
            //sql.append("--    PRINT '--SQL23_DO UPDATE HAT300T'" + "\n");
            //sql.append("--    --7. 보건지급일수" + "\n");
            sql.append("    UPDATE HAT300T A " + "\n");
            sql.append("                INNER JOIN " + "\n");
            sql.append("                 (" + "\n");
            sql.append("                  SELECT AA.DUTY_YYYYMM AS H_DUTY_YYYYMM" + "\n");
            sql.append("                           , AA.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                           , CASE WHEN (SELECT MENS_CALCU_YN " + "\n");
            sql.append("                                                FROM HBS400T" + "\n");
            sql.append("                                                WHERE COMP_CODE = @COMP_CODE) = 'N' THEN 0 " + "\n");
            sql.append("                                     ELSE AA.MENS_REL_CODE  - DUTY_USE " + "\n");
            sql.append("                             END AS MENS_REL_CODE" + "\n");
            sql.append("                           , AA.COMP_CODE AS H_COMP_CODE" + "\n");
            sql.append("                   FROM  HAT200T A," + "\n");
            sql.append("                             (SELECT AA.DUTY_YYYYMM" + "\n");
            sql.append("                                       , AA.PERSON_NUMB" + "\n");
            sql.append("                                       , CASE WHEN SUM(AA.DUTY_NUM) > 0 THEN 0" + "\n");
            sql.append("                                                 ELSE 1 " + "\n");
            sql.append("                                         END AS MENS_REL_CODE" + "\n");
            sql.append("                                       , SUM(CASE WHEN AA.DUTY_CODE = '25' THEN DUTY_NUM1 " + "\n");
            sql.append("                                                         ELSE 0 " + "\n");
            sql.append("                                                 END ) AS DUTY_USE " + "\n");
            sql.append("                                       , @COMP_CODE AS COMP_CODE" + "\n");
            sql.append("                              FROM (" + "\n");
            sql.append("                                           SELECT A.DUTY_YYYYMM" + "\n");
            sql.append("                                                    , A.PERSON_NUMB" + "\n");
            sql.append("                                                    , CASE WHEN B.MENS_REL_CODE = 'Y' THEN DUTY_NUM" + "\n");
            sql.append("                                                              ELSE 0" + "\n");
            sql.append("                                                      END AS DUTY_NUM" + "\n");
            sql.append("                                                    , A.DUTY_CODE" + "\n");
            sql.append("                                                    , A.DUTY_NUM AS DUTY_NUM1" + "\n");
            sql.append("                                           FROM          HAT200T A " + "\n");
            sql.append("                                           INNER JOIN HBS100T B ON A.COMP_CODE      = B.COMP_CODE" + "\n");
            sql.append("                                                                            AND A.DUTY_CODE       = B.DUTY_CODE" + "\n");
            sql.append("                                           INNER JOIN HUM100T C  ON A.COMP_CODE    = C.COMP_CODE" + "\n");
            sql.append("                                                                              AND A.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                                           WHERE A.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("                                           AND A.DUTY_YYYYMM       = @DUTY_YYYYMMDD" + "\n");
            sql.append("                                           AND C.SEX_CODE              = 'F'" + "\n");
            sql.append("                                           AND C.JOIN_DATE            <= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                                           AND (C.RETR_DATE           >= @PAY_YYYYMMDD_FR  OR  C.RETR_DATE = '00000000' )" + "\n");
            sql.append("                                           AND C.DIV_CODE               = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE          ELSE C.DIV_CODE         END)" + "\n");
            sql.append("                                           AND C.PAY_PROV_FLAG       = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                                           AND C.PERSON_NUMB        = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                                           AND C.DIV_CODE               = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE          ELSE C.DIV_CODE         END)" + "\n");
//            sql.append("                                           AND C.PAY_PROV_FLAG       = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                                           AND C.PERSON_NUMB        = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                                           AND C.DEPT_CODE           >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                                           AND C.DEPT_CODE           <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("                                           AND B.PAY_CODE               = C.PAY_CODE" + "\n");
            sql.append("                                         ) AA" + "\n");
            sql.append("                             GROUP BY DUTY_YYYYMM, PERSON_NUMB  " + "\n");
            sql.append("                        ) AA" + "\n");
            sql.append("               WHERE A.COMP_CODE   = AA.COMP_CODE" + "\n");
            sql.append("                 AND A.PERSON_NUMB = AA.PERSON_NUMB" + "\n");
            sql.append("                 AND A.DUTY_YYYYMM = AA.DUTY_YYYYMM" + "\n");
            sql.append("               ) B ON B.H_COMP_CODE      = A.COMP_CODE" + "\n");
            sql.append("                  AND B.H_DUTY_YYYYMM   = A.DUTY_YYYYMM" + "\n");
            sql.append("                  AND B.H_PERSON_NUMB   = A.PERSON_NUMB                      " + "\n");
            sql.append("    SET A.MENS_GIVE = B.MENS_REL_CODE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--" + "\n");
            //sql.append("    --8. 만근지급일수(), 전월만근에 따른 중도입사자의 년차지급" + "\n");
            sql.append("    UPDATE HAT300T A" + "\n");
            sql.append("               INNER JOIN " + "\n");
            sql.append("                (" + "\n");
            sql.append("                   SELECT AA.DUTY_YYYYMM AS H_DUTY_YYYYMM" + "\n");
            sql.append("                            , AA.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                            , CASE WHEN SUM(AA.DUTY_NUM+AA.DUTY_TIME) > 0 THEN 0" + "\n");
            sql.append("                                      ELSE 1" + "\n");
            sql.append("                              END AS FULL_REL_CODE" + "\n");
            sql.append("                            , NVL(BB.FULL_GIVE, 0) AS FULL_GIVE" + "\n");
            sql.append("                            , AA.COMP_CODE AS H_COMP_CODE" + "\n");
            sql.append("                   FROM (" + "\n");
            sql.append("                              SELECT A.DUTY_YYYYMM" + "\n");
            sql.append("                                       , A.PERSON_NUMB" + "\n");
            sql.append("                                       , CASE WHEN B.FULL_REL_CODE = 'Y' THEN SUM(DUTY_NUM)" + "\n");
            sql.append("                                                 ELSE 0" + "\n");
            sql.append("                                         END AS DUTY_NUM" + "\n");
            sql.append("                                       , CASE WHEN B.FULL_REL_CODE = 'Y' THEN SUM(DUTY_TIME)" + "\n");
            sql.append("                                                 ELSE 0" + "\n");
            sql.append("                                         END AS DUTY_TIME" + "\n");
            sql.append("                                       , TOT_DAY" + "\n");
            sql.append("                                       , WORK_DAY" + "\n");
            sql.append("                                       , A.COMP_CODE" + "\n");
            sql.append("                              FROM          HAT200T A " + "\n");
            sql.append("                              INNER JOIN HBS100T B ON A.COMP_CODE       = B.COMP_CODE" + "\n");
            sql.append("                                                               AND A.DUTY_CODE        = B.DUTY_CODE" + "\n");
            sql.append("                              INNER JOIN HUM100T C ON A.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                                 AND A.PERSON_NUMB = C.PERSON_NUMB" + "\n");
            sql.append("                                                                 AND B.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                                                 AND B.PAY_CODE         = C.PAY_CODE" + "\n");
            sql.append("                              INNER JOIN HAT300T D ON A.COMP_CODE      = D.COMP_CODE" + "\n");
            sql.append("                                                                 AND A.PERSON_NUMB = D.PERSON_NUMB" + "\n");
            sql.append("                                                                 AND A.DUTY_YYYYMM = D.DUTY_YYYYMM" + "\n");
            sql.append("                              WHERE A.COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                              AND A.DUTY_YYYYMM    = @DUTY_YYYYMMDD" + "\n");
            sql.append("                              AND C.JOIN_DATE         <= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                              AND (C.RETR_DATE        >= @PAY_YYYYMMDD_TO  OR  C.RETR_DATE = '00000000' )" + "\n");
            sql.append("                              AND B.FULL_REL_CODE    = 'Y'" + "\n");
            sql.append("                              AND C.DIV_CODE           = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE C.DIV_CODE          END)" + "\n");
            sql.append("                              AND C.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
            sql.append("                              AND C.PERSON_NUMB    = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                              AND C.DIV_CODE           = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE C.DIV_CODE          END)" + "\n");
//            sql.append("                              AND C.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE C.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                              AND C.PERSON_NUMB    = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE C.PERSON_NUMB   END)" + "\n");
//            sql.append("                              AND C.DEPT_CODE       >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE C.DEPT_CODE        END)" + "\n");
//            sql.append("                              AND C.DEPT_CODE       <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE C.DEPT_CODE        END)" + "\n");
            sql.append("                               GROUP BY A.DUTY_YYYYMM, A.PERSON_NUMB, A.COMP_CODE, B.FULL_REL_CODE, TOT_DAY, WORK_DAY" + "\n");
            sql.append("                            ) AA " + "\n");
            sql.append("                            LEFT  JOIN    " + "\n");
            sql.append("                             (" + "\n");
            sql.append("                               SELECT  CASE WHEN (DATEDIFF(@PAY_YYYYMMDD_TO, A.JOIN_DATE) + 1) < 365 THEN" + "\n");
            sql.append("                                                    CASE WHEN C.JOIN_MID_CHECK = '1' THEN " + "\n");
            sql.append("                                                             B.FULL_GIVE" + "\n");
            sql.append("                                                        ELSE 0                                   " + "\n");
            sql.append("                                                        END" + "\n");
            sql.append("                                              ELSE 0" + "\n");
            sql.append("                                              END AS FULL_GIVE" + "\n");
            sql.append("                                        , A.COMP_CODE" + "\n");
            sql.append("                                        , A.PERSON_NUMB" + "\n");
            sql.append("                                        , @DUTY_YYYYMMDD AS DUTY_YYYYMM" + "\n");
            sql.append("                               FROM HUM100T A " + "\n");
            sql.append("                               LEFT JOIN (" + "\n");
            sql.append("                                                SELECT COMP_CODE" + "\n");
            sql.append("                                                         , DUTY_YYYYMM" + "\n");
            sql.append("                                                         , PERSON_NUMB" + "\n");
            sql.append("                                                         , FULL_GIVE" + "\n");
            sql.append("                                                FROM HAT300T" + "\n");
            sql.append("                                                WHERE COMP_CODE    = @COMP_CODE" + "\n");
            sql.append("                                                AND    DUTY_YYYYMM = LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -1 MONTH)), 'YYYYMMDD'), 6)" + "\n");
            sql.append("                                                " + "\n");
            sql.append("                                               ) B ON A.COMP_CODE     = B.COMP_CODE" + "\n");
            sql.append("                                                  AND A.PERSON_NUMB = B.PERSON_NUMB                               " + "\n");
            sql.append("                              INNER JOIN HBS340T C ON A.COMP_CODE = C.COMP_CODE" + "\n");
            sql.append("                                                               AND A.PAY_CODE    = C.PAY_CODE" + "\n");
            sql.append("                              WHERE A.COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                              AND B.DUTY_YYYYMM     = LEFT(TO_CHAR(TO_DATE(ADDDATE(@PAY_YYYYMMDD_TO, INTERVAL -1 MONTH)), 'YYYYMMDD'), 6)                              " + "\n");
            sql.append("                              AND A.JOIN_DATE         <= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                              AND (A.RETR_DATE        >= @PAY_YYYYMMDD_TO  OR  A.RETR_DATE = '00000000' )" + "\n");
            sql.append("                              AND A.DIV_CODE           = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE A.DIV_CODE          END)" + "\n");
            sql.append("                              AND A.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END)" + "\n");
            sql.append("                              AND A.PERSON_NUMB   = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE A.PERSON_NUMB   END)" + "\n");
//            sql.append("                              AND A.DIV_CODE           = (CASE WHEN @DIV_CODE                  != '' THEN @DIV_CODE         ELSE A.DIV_CODE          END)" + "\n");
//            sql.append("                              AND A.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                              AND A.PERSON_NUMB   = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE A.PERSON_NUMB   END)" + "\n");
//            sql.append("                              AND A.DEPT_CODE      >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE A.DEPT_CODE        END)" + "\n");
//            sql.append("                              AND A.DEPT_CODE     <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO   ELSE A.DEPT_CODE        END)" + "\n");
            sql.append("                           ) BB ON AA.COMP_CODE   = BB.COMP_CODE" + "\n");
            sql.append("                               AND AA.DUTY_YYYYMM = BB.DUTY_YYYYMM" + "\n");
            sql.append("                              AND AA.PERSON_NUMB  = BB.PERSON_NUMB" + "\n");
            sql.append("" + "\n");
            sql.append("                         GROUP BY AA.DUTY_YYYYMM, AA.PERSON_NUMB, BB.FULL_GIVE, AA.COMP_CODE" + "\n");
            sql.append("             ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("               AND B.H_DUTY_YYYYMM = A.DUTY_YYYYMM" + "\n");
            sql.append("               AND B.H_PERSON_NUMB = A.PERSON_NUMB                   " + "\n");
            sql.append("    SET A.FULL_GIVE = B.FULL_REL_CODE" + "\n");
            sql.append("        , A.YEAR_GIVE = B.FULL_GIVE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL25_DO UPDATE HAT300T'" + "\n");
            //sql.append("    --9. 년차사용(300T insert)" + "\n");
            sql.append("    UPDATE HAT300T A" + "\n");
            sql.append("               INNER JOIN" + "\n");
            sql.append("                 (" + "\n");
            sql.append("                  SELECT A.DUTY_YYYYMM AS H_DUTY_YYYYMM" + "\n");
            sql.append("                           , A.PERSON_NUMB AS H_PERSON_NUMB" + "\n");
            sql.append("                           , SUM(DUTY_NUM * CAST(C.REF_CODE4 AS FLOAT)) AS  H_YEAR_USE " + "\n");
            sql.append("                           , A.COMP_CODE AS H_COMP_CODE" + "\n");
            sql.append("                  FROM          HAT200T   A " + "\n");
            sql.append("                  INNER JOIN HUM100T  B ON A.COMP_CODE    = B.COMP_CODE" + "\n");
            sql.append("                                                     AND A.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("                  INNER JOIN BSA100T   C ON C.COMP_CODE     = A.COMP_CODE " + "\n");
            sql.append("                                                     AND C.MAIN_CODE      = 'H033' " + "\n");
            sql.append("                                                     AND C.REF_CODE3       = 'Y' " + "\n");
            sql.append("                                                     AND C.SUB_CODE        = A.DUTY_CODE" + "\n");
            sql.append("                  WHERE A.COMP_CODE     = @COMP_CODE" + "\n");
            sql.append("                  AND    A.DUTY_YYYYMM  = @DUTY_YYYYMMDD" + "\n");
            sql.append("                  AND   B.DIV_CODE          = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE          ELSE B.DIV_CODE         END)" + "\n");
            sql.append("                  AND   B.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE B.PAY_PROV_FLAG END)" + "\n");
            sql.append("                  AND   B.PERSON_NUMB   = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE B.PERSON_NUMB   END)" + "\n");
//            sql.append("                  AND   B.DIV_CODE          = (CASE WHEN @DIV_CODE                    != '' THEN @DIV_CODE          ELSE B.DIV_CODE         END)" + "\n");
//            sql.append("                  AND   B.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG           != '' THEN @PAY_PROV_FLAG ELSE B.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                  AND   B.PERSON_NUMB   = (CASE WHEN NVL(@PERSON_NUMB, '')  != '' THEN @PERSON_NUMB  ELSE B.PERSON_NUMB   END)" + "\n");
//            sql.append("                  AND   B.DEPT_CODE      >= (CASE WHEN NVL(@DEPT_CODE_FR, '')  != '' THEN @DEPT_CODE_FR   ELSE B.DEPT_CODE        END)" + "\n");
//            sql.append("                  AND   B.DEPT_CODE     <= (CASE WHEN NVL(@DEPT_CODE_TO, '')  != '' THEN @DEPT_CODE_TO   ELSE B.DEPT_CODE        END )   " + "\n");
            sql.append("                  GROUP BY DUTY_YYYYMM, A.PERSON_NUMB, A.COMP_CODE" + "\n");
            sql.append("                 ) B ON B.H_COMP_CODE      = A.COMP_CODE" + "\n");
            sql.append("                    AND B.H_DUTY_YYYYMM   = A.DUTY_YYYYMM" + "\n");
            sql.append("                    AND B.H_PERSON_NUMB   = A.PERSON_NUMB     " + "\n");
            sql.append("    SET A.YEAR_USE = B.H_YEAR_USE;     " + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--    PRINT '--SQL26_DO UPDATE HAT700T'" + "\n");
            //sql.append("    --10.년차사용(700T update)" + "\n");
            sql.append("    UPDATE HAT700T A" + "\n");
            sql.append("                 INNER JOIN" + "\n");
            sql.append("                 (" + "\n");
            sql.append("                  SELECT C.DUTY_YYYY                        AS H_DUTY_YYYY" + "\n");
            sql.append("                           , C.PERSON_NUMB                   AS H_PERSON_NUMB" + "\n");
            sql.append("                           , (C.YEAR_USE + AA.YEAR_USE)  AS H_YEAR_USE" + "\n");
            sql.append("                           , C.COMP_CODE                      AS H_COMP_CODE" + "\n");
            sql.append("                  FROM           HAT700T C " + "\n");
            sql.append("                  INNER JOIN (" + "\n");
            sql.append("                                      SELECT A.DUTY_YYYYMM" + "\n");
            sql.append("                                               , A.PERSON_NUMB" + "\n");
            sql.append("                                               , SUM(DUTY_NUM * CAST(C.REF_CODE4 AS FLOAT)) AS YEAR_USE " + "\n");
            sql.append("                                               , A.COMP_CODE" + "\n");
            sql.append("                                      FROM          HAT200T   A " + "\n");
            sql.append("                                      INNER JOIN HUM100T  B ON A.COMP_CODE     = B.COMP_CODE" + "\n");
            sql.append("                                                                         AND A.PERSON_NUMB  = B.PERSON_NUMB" + "\n");
            sql.append("                                      INNER JOIN BSA100T   C ON A.COMP_CODE     = C.COMP_CODE " + "\n");
            sql.append("                                                                         AND C.MAIN_CODE      = 'H033' " + "\n");
            sql.append("                                                                         AND C.REF_CODE3       = 'Y' " + "\n");
            sql.append("                                                                         AND C.SUB_CODE        = A.DUTY_CODE" + "\n");
            sql.append("                                      WHERE A.COMP_CODE       = @COMP_CODE" + "\n");
            sql.append("                                      AND     A.DUTY_YYYYMM   = @DUTY_YYYYMMDD" + "\n");
            sql.append("                                      AND     B.DIV_CODE           = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE B.DIV_CODE          END)" + "\n");
            sql.append("                                      AND     B.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE B.PAY_PROV_FLAG END)" + "\n");
            sql.append("                                      AND     B.PERSON_NUMB    = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE B.PERSON_NUMB   END)" + "\n");
//            sql.append("                                      AND     B.DIV_CODE           = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE B.DIV_CODE          END)" + "\n");
//            sql.append("                                      AND     B.PAY_PROV_FLAG   = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE B.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                                      AND     B.PERSON_NUMB    = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE B.PERSON_NUMB   END)" + "\n");
//            sql.append("                                      AND     B.DEPT_CODE       >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE B.DEPT_CODE        END)" + "\n");
//            sql.append("                                      AND     B.DEPT_CODE       <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE B.DEPT_CODE        END)    " + "\n");
            sql.append("                                     GROUP BY A.DUTY_YYYYMM , A.PERSON_NUMB, A.COMP_CODE" + "\n");
            sql.append("                                   ) AA ON AA.COMP_CODE     = C.COMP_CODE" + "\n");
            sql.append("                                        AND AA.PERSON_NUMB   = C.PERSON_NUMB" + "\n");
            sql.append("                                        AND AA.DUTY_YYYYMM >= LEFT(C.DUTY_YYYYMMDDFR_USE,6) " + "\n");
            sql.append("                                        AND AA.DUTY_YYYYMM <= LEFT(C.DUTY_YYYYMMDDTO_USE,6)" + "\n");
            sql.append("                  ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
            sql.append("                     AND B.H_DUTY_YYYY      = A.DUTY_YYYY" + "\n");
            sql.append("                     AND B.H_PERSON_NUMB = A.PERSON_NUMB    " + "\n");
            sql.append("    SET A.YEAR_USE = B.H_YEAR_USE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("--    PRINT '--SQL27_DO CREATE #TEMPCOUNT'" + "\n");
            sql.append("" + "\n");
            //sql.append("--    중도입사자의 전월만근에 의한 근태집계월의 년차생성" + "\n");
            //sql.append("--    조건:전월의 근태집계자료 중 만근(FULL_GIVE)가 1이어야만 근태를 집계하는 월에" + "\n");
            //sql.append("--         년차가 1개 생성 됨" + "\n");
            //sql.append("--    중도입사자가 근무한지 1년이 될는 시기는 년차등록의 설정에 따라 년차를 계산함" + "\n");
            //sql.append("--    중도입사자가 근무한지 1년이 넘을 경우는 더 이상 월별 년차를 발생시키지 않는다" + "\n");
            //sql.append("--    중도입사자의 입사년의 다음 해의 경우 1년이 되지 않은 시점에서는 년차의 갯수에" + "\n");
            //sql.append("--    월에 발생된 년차를 더해준다" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--        PRINT '--SQL28_DO INSERT INTO #TEMPCOUNT'" + "\n");
            sql.append("         INSERT INTO T_HAT200UKR_3 (KEY_VALUE, MONTH_COUNT, PERSON_NUMB, COMP_CODE, FRDATE, TODATE, DUTY_YYYYMM, ROW_NUMBER)" + "\n");
            sql.append("         SELECT @KeyValue" + "\n");
            sql.append("                  , COUNT(NVL(B.DUTY_YYYYMM, 0)) AS MONTH_COUNT" + "\n");
            sql.append("                  , C.PERSON_NUMB" + "\n");
            sql.append("                  , C.COMP_CODE" + "\n");
            sql.append("                  , A.FR_DATE" + "\n");
            sql.append("                  , A.TO_DATE" + "\n");
            sql.append("                  , C.DUTY_YYYYMM" + "\n");
            sql.append("                  , 1 AS ROW_NUMBER" + "\n");
            sql.append("         FROM  (" + "\n");
            sql.append("                     SELECT (CASE WHEN YEAR_STD_FR_YYYY = '1' THEN LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -2 YEAR)), 'YYYYMMDD'), 4)" + "\n");
            sql.append("                                           WHEN YEAR_STD_FR_YYYY = '2' THEN LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -1 YEAR)), 'YYYYMMDD'), 4)" + "\n");
            sql.append("                                         WHEN YEAR_STD_FR_YYYY = '3' THEN LEFT(@DUTY_YYYYMMDD, 4)" + "\n");
            sql.append("                                 END) + YEAR_STD_FR_MM + YEAR_STD_FR_DD AS FR_DATE" + "\n");
            sql.append("                              , (CASE WHEN YEAR_STD_TO_YYYY = '1' THEN LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -2 YEAR)), 'YYYYMMDD'), 4)" + "\n");
            sql.append("                                         WHEN YEAR_STD_TO_YYYY = '2' THEN LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -1 YEAR)), 'YYYYMMDD'), 4)" + "\n");
            sql.append("                                         WHEN YEAR_STD_TO_YYYY = '3' THEN LEFT(@DUTY_YYYYMMDD, 4)" + "\n");
            sql.append("                                 END) + YEAR_STD_TO_MM + YEAR_STD_TO_DD AS TO_DATE" + "\n");
            sql.append("                                , COMP_CODE" + "\n");
            sql.append("                     FROM HBS400T " + "\n");
            sql.append("                     WHERE COMP_CODE = @COMP_CODE" + "\n");
            sql.append("                    ) A " + "\n");
            sql.append("                    INNER JOIN HUM100T K ON A.COMP_CODE      = K.COMP_CODE" + "\n");
            sql.append("                    INNER JOIN HAT300T  C ON K.COMP_CODE      = C.COMP_CODE" + "\n");
            sql.append("                                                      AND K.PERSON_NUMB   = C.PERSON_NUMB" + "\n");
            sql.append("                                                      AND C.DUTY_YYYYMM <= @DUTY_YYYYMMDD" + "\n");
            sql.append("                    LEFT    JOIN HAT300T  B ON A.COMP_CODE       = B.COMP_CODE" + "\n");
            sql.append("                                                      AND B.DUTY_YYYYMM >= SUBSTRING(A.FR_DATE, 1, 6)" + "\n");
            sql.append("                                                      AND B.DUTY_YYYYMM <= SUBSTRING(A.TO_DATE, 1, 6)" + "\n");
            sql.append("                                                      AND B.PERSON_NUMB   = C.PERSON_NUMB " + "\n");
            sql.append("          WHERE A.COMP_CODE   = @COMP_CODE " + "\n");
            sql.append("          AND K.DIV_CODE          = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE          ELSE K.DIV_CODE         END)" + "\n");
            sql.append("          AND K.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE K.PAY_PROV_FLAG END)" + "\n");
            sql.append("          AND K.PERSON_NUMB   = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE K.PERSON_NUMB   END)" + "\n");
//            sql.append("          AND K.DIV_CODE          = (CASE WHEN @DIV_CODE                    != '' THEN @DIV_CODE          ELSE K.DIV_CODE         END)" + "\n");
//            sql.append("          AND K.PAY_PROV_FLAG  = (CASE WHEN @PAY_PROV_FLAG           != '' THEN @PAY_PROV_FLAG ELSE K.PAY_PROV_FLAG END)" + "\n");
//            sql.append("          AND K.PERSON_NUMB   = (CASE WHEN NVL(@PERSON_NUMB, '')  != '' THEN @PERSON_NUMB  ELSE K.PERSON_NUMB   END)" + "\n");
//            sql.append("          AND K.DEPT_CODE      >= (CASE WHEN NVL(@DEPT_CODE_FR, '')  != '' THEN @DEPT_CODE_FR   ELSE K.DEPT_CODE        END)" + "\n");
//            sql.append("          AND K.DEPT_CODE      <= (CASE WHEN NVL(@DEPT_CODE_TO, '')  != '' THEN @DEPT_CODE_TO  ELSE K.DEPT_CODE        END)" + "\n");
            sql.append("         GROUP BY C.PERSON_NUMB, C.COMP_CODE, A.FR_DATE, A.TO_DATE, C.DUTY_YYYYMM;" + "\n");
            sql.append("          " + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("--        PRINT '--SQL29_DO UPDATE #TEMPCOUNT'    " + "\n");
            sql.append("UPDATE  T_HAT200UKR_3 A " + "\n");
            sql.append("INNER JOIN (" + "\n");
            sql.append("                   SELECT COUNT(NVL(PERSON_NUMB,0)) AS ROW_NUMBER" + "\n");
            sql.append("                             , PERSON_NUMB " + "\n");
            sql.append("                   FROM T_HAT200UKR_3" + "\n");
            sql.append("                   WHERE KEY_VALUE = @KeyValue" + "\n");
            sql.append("                   GROUP BY PERSON_NUMB" + "\n");
            sql.append("                   ) AS B ON A.PERSON_NUMB = B.PERSON_NUMB" + "\n");
            sql.append("                   " + "\n");
            sql.append("SET A.ROW_NUMBER =  B.ROW_NUMBER" + "\n");
            sql.append("WHERE A.KEY_VALUE = @KeyValue;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            sql.append("         UPDATE HAT700T A " + "\n");
            sql.append("         INNER JOIN " + "\n");
            sql.append("                    (" + "\n");
            sql.append("                   SELECT CASE WHEN M2.JOIN_MID_CHECK = '1' THEN (CASE WHEN (MAX(M2.WORK_MONTH) = 12) THEN M2.YEAR_CNT" + "\n");
            sql.append("                                                                                                         WHEN (MAX(M2.WORK_MONTH) > 12) THEN M2.YEAR_SAVE" + "\n");
            sql.append("                                                                                                         WHEN (MAX(M2.WORK_MONTH) < 12) THEN M2.YEAR_SAVE + T.YEAR_GIVE" + "\n");
            sql.append("                                                                                                 END)" + "\n");
            sql.append("                                       ELSE M2.YEAR_SAVE" + "\n");
            sql.append("                               END AS YEAR_GIVE" + "\n");
            sql.append("                             , T.COMP_CODE" + "\n");
            sql.append("                             , T.PERSON_NUMB" + "\n");
            sql.append("                             , M2.YEAR_CNT" + "\n");
            sql.append("                             , M2.DUTY_YYYY" + "\n");
            sql.append("                             , M2.JOIN_MID_CHECK" + "\n");
            sql.append("                   FROM          HAT300T     T " + "\n");
            sql.append("                   INNER JOIN HUM100T M1 ON T.COMP_CODE    = M1.COMP_CODE" + "\n");
            sql.append("                                                        AND T.PERSON_NUMB = M1.PERSON_NUMB                            " + "\n");
            sql.append("                   INNER JOIN (" + "\n");
            sql.append("                                        SELECT CASE WHEN (P.MONTH_COUNT < 12) AND (MAX(P.ROW_NUMBER) = 12) THEN (CASE WHEN (SUM(M1.DUTY_NUM) >= 0 AND SUM(M1.DUTY_NUM) < G.ABSENCE_CNT) THEN G.SUPP_YEAR_NUM_A" + "\n");
            sql.append("                                                                                                                                                                             WHEN SUM(M1.DUTY_NUM) >= G.ABSENCE_CNT THEN G.SUPP_YEAR_NUM_B                     " + "\n");
            sql.append("                                                                                                                                                                    END)" + "\n");
            sql.append("                                                           ELSE 0" + "\n");
            sql.append("                                                   END AS YEAR_CNT" + "\n");
            sql.append("                                                , P.MONTH_COUNT" + "\n");
            sql.append("                                                , K.PERSON_NUMB   " + "\n");
            sql.append("                                                , P.FRDATE" + "\n");
            sql.append("                                                , P.TODATE" + "\n");
            sql.append("                                                , K.COMP_CODE " + "\n");
            sql.append("                                                , F.YEAR_SAVE" + "\n");
            sql.append("                                                , MAX(P.ROW_NUMBER) WORK_MONTH   " + "\n");
            sql.append("                                                , F.DUTY_YYYY" + "\n");
            sql.append("                                                , G.JOIN_MID_CHECK" + "\n");
            sql.append("                                        FROM              HUM100T      K  " + "\n");
            sql.append("                                        LEFT     JOIN    HAT200T      M1 ON K.COMP_CODE    = M1.COMP_CODE" + "\n");
            sql.append("                                                                                    AND K.PERSON_NUMB = M1.PERSON_NUMB" + "\n");
            sql.append("                                        INNER JOIN T_HAT200UKR_3  P  ON P.COMP_CODE    = K.COMP_CODE" + "\n");
            sql.append("                                                                                    AND P.PERSON_NUMB = K.PERSON_NUMB" + "\n");
            sql.append("                                                                                    AND P.KEY_VALUE       = @KeyValue" + "\n");
            sql.append("                                        INNER JOIN HBS100T           C  ON M1.COMP_CODE  = C.COMP_CODE" + "\n");
            sql.append("                                                                                    AND M1.DUTY_CODE   = C.DUTY_CODE" + "\n");
            sql.append("                                        INNER JOIN HBS340T           G  ON K.COMP_CODE    = G.COMP_CODE" + "\n");
            sql.append("                                                                                    AND K.PAY_CODE       = G.PAY_CODE" + "\n");
            sql.append("                                        INNER JOIN HAT700T           F  ON P.COMP_CODE    = F.COMP_CODE" + "\n");
            sql.append("                                                                                   AND P.PERSON_NUMB = F.PERSON_NUMB" + "\n");
            sql.append("                                                                                   AND P.FRDATE            = F.DUTY_YYYYMMDDFR" + "\n");
            sql.append("                                                                                   AND P.TODATE           = F.DUTY_YYYYMMDDTO " + "\n");
            sql.append("                                       WHERE K.COMP_CODE        = @COMP_CODE" + "\n");
            sql.append("                                       AND    M1.DUTY_YYYYMM >= LEFT(TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD + '01', INTERVAL -1 YEAR)), 'YYYYMMDD'), 6)                                       " + "\n");
            sql.append("                                       AND    M1.DUTY_YYYYMM <= @DUTY_YYYYMMDD" + "\n");
            sql.append("                                       AND    K.DIV_CODE             = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE K.DIV_CODE          END)" + "\n");
            sql.append("                                       AND    K.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE K.PAY_PROV_FLAG END)" + "\n");
            sql.append("                                       AND    K.PERSON_NUMB      = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE K.PERSON_NUMB   END)" + "\n");
//            sql.append("                                       AND    K.DIV_CODE             = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE K.DIV_CODE          END)" + "\n");
//            sql.append("                                       AND    K.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG           != '' THEN @PAY_PROV_FLAG ELSE K.PAY_PROV_FLAG END)" + "\n");
//            sql.append("                                       AND    K.PERSON_NUMB      = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE K.PERSON_NUMB   END)" + "\n");
//            sql.append("                                       AND    K.DEPT_CODE         >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE K.DEPT_CODE        END)" + "\n");
//            sql.append("                                       AND    K.DEPT_CODE         <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE K.DEPT_CODE        END)" + "\n");
            sql.append("                                       AND    C.COTR_TYPE            = '2'" + "\n");
            sql.append("                                       AND    K.YEAR_GIVE             = 'Y'" + "\n");
            sql.append("                                       AND    K.JOIN_DATE             > P.FRDATE" + "\n");
            sql.append("                                       AND    P.MONTH_COUNT     < 12" + "\n");
            sql.append("                                       AND    K.JOIN_DATE          <= @PAY_YYYYMMDD_FR " + "\n");
            sql.append("                                       AND    (K.RETR_DATE         >= @PAY_YYYYMMDD_FR OR K.RETR_DATE = '00000000')" + "\n");
            sql.append("                                     GROUP BY P.MONTH_COUNT, K.PERSON_NUMB, P.FRDATE, P.TODATE, G.ABSENCE_CNT, G.SUPP_YEAR_NUM_A" + "\n");
            sql.append("                                            , G.SUPP_YEAR_NUM_B, K.COMP_CODE, G.JOIN_MID_CHECK, K.JOIN_DATE, F.YEAR_SAVE, F.DUTY_YYYY" + "\n");
            sql.append("                                   ) M2 ON T.COMP_CODE   = M2.COMP_CODE" + "\n");
            sql.append("                                       AND T.PERSON_NUMB = M2.PERSON_NUMB                                                                                                                                                                   " + "\n");
            sql.append("                   WHERE T.COMP_CODE   = @COMP_CODE" + "\n");
            sql.append("                   AND T.DUTY_YYYYMM = @DUTY_YYYYMMDD" + "\n");
            sql.append("                   AND M1.DIV_CODE      =  CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE M1.DIV_CODE END" + "\n");
            sql.append("                   AND M1.PAY_PROV_FLAG =  CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE M1.PAY_PROV_FLAG END" + "\n");
            sql.append("                   AND M1.PERSON_NUMB = CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE M1.PERSON_NUMB END" + "\n");
//            sql.append("                   AND M1.DIV_CODE      =  CASE WHEN @DIV_CODE <> '' THEN @DIV_CODE ELSE M1.DIV_CODE END" + "\n");
//            sql.append("                   AND M1.PAY_PROV_FLAG =  CASE WHEN @PAY_PROV_FLAG <> '' THEN @PAY_PROV_FLAG ELSE M1.PAY_PROV_FLAG END" + "\n");
//            sql.append("                   AND M1.PERSON_NUMB = CASE WHEN NVL(@PERSON_NUMB, '') <> '' THEN @PERSON_NUMB ELSE M1.PERSON_NUMB END" + "\n");
//            sql.append("                   AND M1.DEPT_CODE >= CASE WHEN NVL(@DEPT_CODE_FR, '') <> '' THEN @DEPT_CODE_FR ELSE M1.DEPT_CODE END" + "\n");
//            sql.append("                   AND M1.DEPT_CODE <= CASE WHEN NVL(@DEPT_CODE_TO, '') <> '' THEN @DEPT_CODE_TO ELSE M1.DEPT_CODE END    " + "\n");
            sql.append("                   AND M1.JOIN_DATE <= @PAY_YYYYMMDD_FR" + "\n");
            sql.append("                   AND (M1.RETR_DATE >= @PAY_YYYYMMDD_FR OR M1.RETR_DATE = '00000000')   " + "\n");
            sql.append("                   GROUP BY M1.JOIN_DATE, M2.YEAR_CNT, T.COMP_CODE, T.PERSON_NUMB, M2.MONTH_COUNT, M2.YEAR_SAVE, M2.DUTY_YYYY, M2.JOIN_MID_CHECK, T.YEAR_GIVE" + "\n");
            sql.append("                  ) B ON B.COMP_CODE     = A.COMP_CODE" + "\n");
            sql.append("                     AND B.PERSON_NUMB = A.PERSON_NUMB" + "\n");
            sql.append("                     AND B.DUTY_YYYY      = A.DUTY_YYYY         " + "\n");
            sql.append("         SET A.YEAR_SAVE = B.YEAR_GIVE;" + "\n");
            sql.append("" + "\n");
            sql.append("" + "\n");
            //sql.append("-- 주차 기준 검색     " + "\n");
            //sql.append(" --1. 주차    " + "\n");
            //sql.append("--    PRINT '--SQL31_DO INSERT to Temp : @results3'    " + "\n");
            sql.append("    INSERT INTO T_HAT200UKR_4 (KEY_VALUE, WEEK_CALCU_YN, EXTEND_WORK_YN, FIVE_APPLY_DATE)" + "\n");
            sql.append("    SELECT @KeyValue" + "\n");
            sql.append("         , WEEK_CALCU_YN" + "\n");
            sql.append("         , EXTEND_WORK_YN" + "\n");
            sql.append("         , FIVE_APPLY_DATE" + "\n");
            sql.append("    FROM HBS400T" + "\n");
            sql.append("    WHERE COMP_CODE = @COMP_CODE;" + "\n");


            System.out.println("====================================================================");
            System.out.println("=============================== 2 ==================================");
            System.out.println("====================================================================");
            
            System.out.println(sql.toString());
            
            pstmt = conn.prepareStatement(sql.toString());
            //pstmt.executeUpdate();
            pstmt.execute();
            pstmt.close();
            
            sql.setLength(0);                    
            sql.append( " SELECT WEEK_CALCU_YN, FIVE_APPLY_DATE FROM T_HAT200UKR_4 WHERE KEY_VALUE = " + "'" + KeyValue + "'\n");

            pstmt = conn.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();


            String WEEK_CALCU_YN   = "N";
            String FIVE_APPLY_DATE = "";

            while(rs.next()){
                WEEK_CALCU_YN = rs.getString(1);
                FIVE_APPLY_DATE = rs.getString(2);
            }



            if(WEEK_CALCU_YN.equals("N")) {

                sql.setLength(0);
                sql.append("SET @COMP_CODE             = " + "'" + COMP_CODE + "';\n");
                sql.append("SET @DUTY_YYYYMMDD         = " + "CASE WHEN '" + DUTY_YYYYMMDD + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_FR      = " + "CASE WHEN '" + DUTY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_TO      = " + "CASE WHEN '" + DUTY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_FR       = " + "CASE WHEN '" + PAY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_TO       = " + "CASE WHEN '" + PAY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PERSON_NUMB           = " + "'" + PERSON_NUMB + "';\n");
                sql.append("SET @UPDATE_DB_USER        = " + "'" + UPDATE_DB_USER + "';\n");
                sql.append("SET @PAY_PROV_FLAG         = " + "'" + PAY_PROV_FLAG + "';\n");
                sql.append("SET @DIV_CODE              = " + "'" + DIV_CODE + "';\n");
//                sql.append("SET @DEPT_CODE_TO          = " + "'" + DEPT_CODE_TO + "';\n");
//                sql.append("SET @DEPT_CODE_FR          = " + "'" + DEPT_CODE_FR + "';\n");
                sql.append("" + "\n");                        
                sql.append("        UPDATE HAT300T B" + "\n");
                sql.append("        INNER JOIN HUM100T A ON A.COMP_CODE     = B.COMP_CODE" + "\n");
                sql.append("                                          AND A.PERSON_NUMB  = B.PERSON_NUMB" + "\n");
                sql.append("        SET B.WEEK_GIVE = 0 " + "\n");
                sql.append("          WHERE A.COMP_CODE         = @COMP_CODE" + "\n");
                sql.append("          AND     B.DUTY_YYYYMM     = @DUTY_YYYYMMDD" + "\n");
                sql.append("          AND     A.DIV_CODE            = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE          ELSE A.DIV_CODE         END)" + "\n");
                sql.append("          AND     A.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END)" + "\n");
                sql.append("          AND     A.PERSON_NUMB     = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE A.PERSON_NUMB   END)" + "\n");
//                sql.append("          AND     A.DIV_CODE            = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE          ELSE A.DIV_CODE         END)" + "\n");
//                sql.append("          AND     A.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE A.PAY_PROV_FLAG END)" + "\n");
//                sql.append("          AND     A.PERSON_NUMB     = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE A.PERSON_NUMB   END)" + "\n");
//                sql.append("          AND     A.DEPT_CODE        >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE A.DEPT_CODE        END)" + "\n");
//                sql.append("          AND     A.DEPT_CODE        <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE A.DEPT_CODE        END);                          " + "\n");

            }else {

                sql.setLength(0);
                sql.append("SET @COMP_CODE             = " + "'" + COMP_CODE + "';\n");
                sql.append("SET @DUTY_YYYYMMDD         = " + "CASE WHEN '" + DUTY_YYYYMMDD + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_FR      = " + "CASE WHEN '" + DUTY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_TO      = " + "CASE WHEN '" + DUTY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_FR       = " + "CASE WHEN '" + PAY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_TO       = " + "CASE WHEN '" + PAY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PERSON_NUMB           = " + "'" + PERSON_NUMB + "';\n");
                sql.append("SET @UPDATE_DB_USER        = " + "'" + UPDATE_DB_USER + "';\n");
                sql.append("SET @PAY_PROV_FLAG         = " + "'" + PAY_PROV_FLAG + "';\n");
                sql.append("SET @DIV_CODE              = " + "'" + DIV_CODE + "';\n");
//                sql.append("SET @DEPT_CODE_TO          = " + "'" + DEPT_CODE_TO + "';\n");
//                sql.append("SET @DEPT_CODE_FR          = " + "'" + DEPT_CODE_FR + "';\n");
                sql.append("" + "\n");    
                sql.append("--  8. 주차 구하기" + "\n");    
                sql.append("    UPDATE HAT300T A " + "\n");
                sql.append("    INNER JOIN " + "\n");
                sql.append("                     (" + "\n");
                sql.append("                        SELECT PERSON_NUMB AS H_PERSON_NUMB" + "\n");
                sql.append("                                 , @DUTY_YYYYMMDD YYYYMM" + "\n");
                sql.append("                                 , SUM(DUTY_SUM) DUTY_SUM" + "\n");
                sql.append("                                 , COMP_CODE AS H_COMP_CODE" + "\n");
                sql.append("                        FROM (" + "\n");
                sql.append("                                     SELECT H.PERSON_NUMB" + "\n");
                sql.append("                                              , H.NAME" + "\n");
                sql.append("                                              , D.CAL_DATE" + "\n");
                sql.append("                                              , D.START_DATE" + "\n");
                sql.append("                                              , D.END_DATE" + "\n");
                sql.append("                                              , CASE WHEN  SUM((CASE WHEN F.WEEK_REL_CODE = 'Y' THEN DUTY_NUM + DUTY_TIME " + "\n");
                sql.append("                                                                                    ELSE 0 " + "\n");
                sql.append("                                                                             END)) > 0 THEN 0 " + "\n");
                sql.append("                                                        ELSE (CASE WHEN CAL_DATE IS NULL THEN 0 " + "\n");
                sql.append("                                                                         ELSE 1 " + "\n");
                sql.append("                                                                END) " + "\n");
                sql.append("                                                END AS DUTY_SUM" + "\n");
                sql.append("                                             , H.COMP_CODE" + "\n");
                sql.append("                                      FROM (" + "\n");
                sql.append("                                                 SELECT A.DIV_CODE" + "\n");
                sql.append("                                                          , A.CAL_DATE" + "\n");
                sql.append("                                                          , A.CAL_NO" + "\n");
                sql.append("                                                          , A.WEEK_DAY" + "\n");
                sql.append("                                                          , MAX(B.CAL_DATE) START_DATE" + "\n");
                sql.append("                                                          , MAX(C.CAL_DATE) END_DATE" + "\n");
                sql.append("                                                          , A.COMP_CODE" + "\n");
                sql.append("                                                 FROM          HBS600T A " + "\n");
                sql.append("                                                 INNER JOIN HBS600T B  ON A.COMP_CODE = B.COMP_CODE" + "\n");
                sql.append("                                                                                   AND A.DIV_CODE     = B.DIV_CODE" + "\n");
                sql.append("                                                 INNER JOIN HBS600T C ON A.COMP_CODE  = B.COMP_CODE" + "\n");
                sql.append("                                                                                   AND A.DIV_CODE     = C.DIV_CODE" + "\n");
                sql.append("                                                 WHERE A.COMP_CODE      = @COMP_CODE" + "\n");
                sql.append("                                                 AND A.CAL_DATE            >= @DUTY_YYYYMMDD_FR" + "\n");
                sql.append("                                                 AND A.CAL_DATE            <= @DUTY_YYYYMMDD_TO" + "\n");
                sql.append("                                                 AND A.WEEK_DAY             = '1'" + "\n");
                sql.append("                                                 AND B.CAL_DATE            >=  TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_FR, -7)), 'YYYYMMDD') " + "\n");
                sql.append("                                                 AND B.CAL_DATE            < A.CAL_DATE" + "\n");
                sql.append("                                                 AND C.CAL_DATE            >=  TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_TO, -7)), 'YYYYMMDD') " + "\n");
                sql.append("                                                 AND C.CAL_DATE            < A.CAL_DATE" + "\n");
                sql.append("                                                 AND B.WEEK_DAY             = '2'" + "\n");
                sql.append("                                                 AND C.WEEK_DAY             = '7'" + "\n");
                sql.append("                                                 GROUP BY A.DIV_CODE, A.CAL_DATE, A.CAL_NO, A.WEEK_DAY, A.COMP_CODE" + "\n");
                sql.append("                                                ) D " + "\n");
                sql.append("                                      INNER JOIN HUM100T H ON D.COMP_CODE         = H.COMP_CODE" + "\n");
                sql.append("                                                                         AND D.START_DATE        >= H.JOIN_DATE" + "\n");
                sql.append("                                                                         AND D.DIV_CODE            = H.DIV_CODE" + "\n");
                sql.append("                                                                         AND (H.RETR_DATE          = '00000000' OR D.CAL_DATE <= H.RETR_DATE)" + "\n");
                sql.append("                                                                         AND H.COMP_CODE        = (CASE WHEN @COMP_CODE IS NOT NULL THEN @COMP_CODE      ELSE H.COMP_CODE      END)" + "\n");
                sql.append("                                                                         AND H.DIV_CODE            = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE H.DIV_CODE          END)" + "\n");
                sql.append("                                                                         AND H.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG IS NOT NULL THEN @PAY_PROV_FLAG ELSE H.PAY_PROV_FLAG END)" + "\n");
                sql.append("                                                                         AND H.PERSON_NUMB     = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE H.PERSON_NUMB   END)" + "\n");
//                sql.append("                                                                         AND H.COMP_CODE        = (CASE WHEN @COMP_CODE               != '' THEN @COMP_CODE      ELSE H.COMP_CODE      END)" + "\n");
//                sql.append("                                                                         AND H.DIV_CODE            = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE H.DIV_CODE          END)" + "\n");
//                sql.append("                                                                         AND H.PAY_PROV_FLAG    = (CASE WHEN @PAY_PROV_FLAG          != '' THEN @PAY_PROV_FLAG ELSE H.PAY_PROV_FLAG END)" + "\n");
//                sql.append("                                                                         AND H.PERSON_NUMB     = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE H.PERSON_NUMB   END)" + "\n");
//                sql.append("                                                                         AND H.DEPT_CODE        >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE H.DEPT_CODE        END)" + "\n");
//                sql.append("                                                                         AND H.DEPT_CODE        <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE H.DEPT_CODE        END)" + "\n");
                sql.append("                                       LEFT     JOIN HAT600T E ON H.COMP_CODE         = E.COMP_CODE" + "\n");
                sql.append("                                                                        AND H.PERSON_NUMB      = E.PERSON_NUMB" + "\n");
                sql.append("                                                                        AND E.DUTY_YYYYMMDD >= D.START_DATE" + "\n");
                sql.append("                                                                        AND E.DUTY_YYYYMMDD <= D.END_DATE" + "\n");
                sql.append("                                        LEFT     JOIN HBS100T F ON E.COMP_CODE          = F.COMP_CODE" + "\n");
                sql.append("                                                                        AND E.DUTY_CODE           = F.DUTY_CODE" + "\n");
                sql.append("                                                                        AND H.COMP_CODE         = F.COMP_CODE" + "\n");
                sql.append("                                                                        AND H.PAY_CODE            = F.PAY_CODE" + "\n");
                sql.append("                                                                        AND F.WEEK_REL_CODE     = 'Y'" + "\n");
                sql.append("                                            " + "\n");
                sql.append("    " + "\n");
                sql.append("                                        GROUP BY H.PERSON_NUMB, H.NAME, D.CAL_DATE, D.START_DATE, D.END_DATE, H.COMP_CODE" + "\n");
                sql.append("                                   ) X" + "\n");
                sql.append("                          GROUP BY X.COMP_CODE, PERSON_NUMB, COMP_CODE " + "\n");
                sql.append("                      ) B ON B.H_COMP_CODE    = A.COMP_CODE" + "\n");
                sql.append("                       AND B.YYYYMM             = A.DUTY_YYYYMM" + "\n");
                sql.append("                       AND B.H_PERSON_NUMB = A.PERSON_NUMB" + "\n");
                sql.append("                                                                                                     " + "\n");
                sql.append("    SET A.WEEK_GIVE   = B.DUTY_SUM ;" + "\n");

            }

            System.out.println("====================================================================");
            System.out.println("=============================== 3 ==================================");
            System.out.println("====================================================================");
            
            System.out.println(sql.toString());
            
            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();

            //--3.연장근로에 대한 할증25%계산(3년간한 시행할 수 있음)
            String STREXTEND_END_DATE  = "";
            
/* 
            if(WEEK_CALCU_YN.equals("Y") && !FIVE_APPLY_DATE.equals("") && ISEXTENDED.equals("Y")){

                sql.setLength(0);                    
                sql.append( " SELECT TO_CHAR(TO_DATE(ADDDATE(ADDDATE(" + "'" + FIVE_APPLY_DATE + "'" + ", INTERVAL +3 YEAR), INTERVAL -1 DAY)), 'YYYYMMDD') AS STREXTEND_END_DATE" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                rs = pstmt.executeQuery();

                while(rs.next()){
                    STREXTEND_END_DATE = rs.getString(1);
                }

                pstmt.close();

                //연장근로 25%할증 적용 기간이 현재 집계하는 기간사이에 있어야 함

                if(((Integer.parseInt(DUTY_YYYYMMDD_FR) >= Integer.parseInt(FIVE_APPLY_DATE)) || (Integer.parseInt(DUTY_YYYYMMDD_TO) >= Integer.parseInt(FIVE_APPLY_DATE)))
                        && ((Integer.parseInt(DUTY_YYYYMMDD_FR) <= Integer.parseInt(STREXTEND_END_DATE)) || (Integer.parseInt(DUTY_YYYYMMDD_TO) <= Integer.parseInt(STREXTEND_END_DATE)))){

                    //  용 도 : 근무자의 연장근로시간에서 최초 4시간(25%할증) 연장근로시간을 계산하고
                    //       최초 4시간 만큼을 연장근로에서 뺀다

                    sql.setLength(0);
                    sql.append("        SELECT A.DUTY_YYYYMMDD" + "\n");
                    sql.append("             , A.DUTY_TIME " + "\n");
                    sql.append("             , A.DUTY_MINU" + "\n");
                    sql.append("             , A.DUTY_CODE" + "\n");
                    sql.append("             , C.CAL_NO    " + "\n");
                    sql.append("             , A.PERSON_NUMB" + "\n");
                    sql.append("        FROM          HAT600T    A" + "\n");
                    sql.append("        INNER JOIN BSA100T    B ON B.COMP_CODE     = A.COMP_CODE" + "\n");
                    sql.append("                                            AND B.MAIN_CODE      = 'H033'" + "\n");
                    sql.append("                                            AND B.SUB_CODE        = A.DUTY_CODE " + "\n");
                    sql.append("                                            AND B.REF_CODE1       = '1'" + "\n");
                    sql.append("                                            AND B.REF_CODE3 IS NOT NULL" + "\n");
                    sql.append("        INNER JOIN HUM100T  D ON A.COMP_CODE     = D.COMP_CODE" + "\n");
                    sql.append("                                            AND A.PERSON_NUMB = D.PERSON_NUMB" + "\n");
                    sql.append("        INNER JOIN (" + "\n");
                    sql.append("                             SELECT A.DIV_CODE" + "\n");
                    sql.append("                                      , A.CAL_DATE" + "\n");
                    sql.append("                                      , A.CAL_NO" + "\n");
                    sql.append("                                      , A.WEEK_DAY" + "\n");
                    sql.append("                                      , A.HOLY_TYPE" + "\n");
                    sql.append("                                      , A.COMP_CODE" + "\n");
                    sql.append("                             FROM          HBS600T  A" + "\n");
                    sql.append("                             INNER JOIN HBS600T  B ON A.COMP_CODE = B.COMP_CODE" + "\n");
                    sql.append("                                                               AND A.DIV_CODE     = B.DIV_CODE" + "\n");
                    sql.append("                             INNER JOIN HBS600T  C ON A.COMP_CODE = B.COMP_CODE" + "\n");
                    sql.append("                                                               AND A.DIV_CODE     = C.DIV_CODE" + "\n");
                    sql.append("                              WHERE A.COMP_CODE     = @COMP_CODE" + "\n");
                    sql.append("                              AND    B.CAL_DATE        >= @DUTY_YYYYMMDD_FR" + "\n");
                    sql.append("                              AND    B.CAL_DATE        <= @DUTY_YYYYMMDD_TO" + "\n");
                    sql.append("                              AND    A.CAL_DATE        >=  TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_FR, -7)), 'YYYYMMDD') " + "\n");
                    sql.append("                              AND    A.CAL_DATE        <= B.CAL_DATE" + "\n");
                    sql.append("                              AND    C.CAL_DATE        >=  TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_FR, -7)), 'YYYYMMDD') " + "\n");
                    sql.append("                              AND    C.CAL_DATE        <= TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_TO, -7)), 'YYYYMMDD') " + "\n");
                    sql.append("                              AND    A.CAL_NO             = B.CAL_NO" + "\n");
                    sql.append("                              AND    A.CAL_NO             = C.CAL_NO" + "\n");
                    sql.append("                              AND    A.WEEK_DAY         > 1" + "\n");
                    sql.append("                              AND    A.HOLY_TYPE      != '0'" + "\n");
                    sql.append("                              GROUP BY A.DIV_CODE, A.CAL_DATE, A.CAL_NO, A.WEEK_DAY, A.COMP_CODE, A.HOLY_TYPE" + "\n");
                    sql.append("                          ) C ON A.COMP_CODE          = C.COMP_CODE" + "\n");
                    sql.append("                             AND D.DIV_CODE             = C.DIV_CODE" + "\n");
                    sql.append("                             AND A.DUTY_YYYYMMDD  = C.CAL_DATE" + "\n");
                    sql.append("         WHERE A.COMP_CODE      = @COMP_CODE" + "\n");
                    sql.append("         AND C.CAL_DATE          >= TO_CHAR(TO_DATE(ADDDATE(@DUTY_YYYYMMDD_FR, -7)), 'YYYYMMDD')" + "\n");
                    sql.append("         AND C.CAL_DATE          <= @DUTY_YYYYMMDD_TO" + "\n");
                    sql.append("         AND D.PAY_PROV_FLAG   = @PAY_PROV_FLAG" + "\n");
                    sql.append("         AND D.DIV_CODE            = (CASE WHEN @DIV_CODE IS NOT NULL THEN @DIV_CODE         ELSE D.DIV_CODE        END)" + "\n");
                    sql.append("         AND A.PERSON_NUMB     = (CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB  ELSE A.PERSON_NUMB END)" + "\n");
//                    sql.append("         AND D.DIV_CODE            = (CASE WHEN @DIV_CODE                   != '' THEN @DIV_CODE         ELSE D.DIV_CODE        END)" + "\n");
//                    sql.append("         AND A.PERSON_NUMB     = (CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB  ELSE A.PERSON_NUMB END)" + "\n");
//                    sql.append("         AND D.DEPT_CODE        >= (CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR   ELSE D.DEPT_CODE      END)" + "\n");
//                    sql.append("         AND D.DEPT_CODE        <= (CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO  ELSE D.DEPT_CODE      END)" + "\n");
                    sql.append("         AND C.WEEK_DAY            > 1" + "\n");
                    sql.append("         AND  ((A.DUTY_TIME != 0) OR (A.DUTY_MINU != 0))" + "\n");
                    sql.append("         AND  C.HOLY_TYPE   != '0'" + "\n");
                    sql.append("         ORDER BY A.PERSON_NUMB, A.DUTY_YYYYMMDD, B.REF_CODE3" + "\n");


                    pstmt = conn.prepareStatement(sql.toString());
                    rs = pstmt.executeQuery();

                    int INT_EXTEND_TIME = 4;
                    float REST_TIME = INT_EXTEND_TIME * 60;
                    int FIRST_CAL_NO;
                    int CAL_NO;
                    String FIRST_DUTY_YYYYMMDD = ""; //@DUTY_YYYYMMDD_C
                    String FIRST_PERSON_NUMB = ""; //@PERSON_NUMB_C
                    String WEEK = "1";
                    String DUTY_YYYYMMDD_C = "";
                    String PERSON_NUMB_C = "";
                    float WORK_TIME = 0;
                    float MONTH_EXTEND_WORK_TIME = 0;
                    float MODREST_MINU = 0;
                    float MODREST_TIME = 0;
                    float DUTY_TIME_C = 0;
                    float DUTY_MINU_C = 0;
                    float CALCUWORK_TIME = 0;
                    String DUTY_CODE_C = "";

                    while(rs.next()){
                        DUTY_YYYYMMDD_C = rs.getString("DUTY_YYYYMMDD");
                        PERSON_NUMB_C = rs.getString("PERSON_NUMB");
                        CAL_NO = Integer.parseInt(rs.getString("CAL_NO"));
                        FIRST_CAL_NO = CAL_NO;
                        DUTY_CODE_C = rs.getString("DUTY_CODE");

                        if((Integer.parseInt(FIVE_APPLY_DATE) <= Integer.parseInt(DUTY_YYYYMMDD_C)) 
                                && (Integer.parseInt(DUTY_YYYYMMDD_C) <= Integer.parseInt(STREXTEND_END_DATE))){

                            if(FIRST_PERSON_NUMB != PERSON_NUMB_C){
                                if(WORK_TIME != 0) {
                                    WORK_TIME = Math.round(WORK_TIME / 60);
                                    //주가 바뀔때마다 연장근무시간을 더한다
                                    MONTH_EXTEND_WORK_TIME = MONTH_EXTEND_WORK_TIME + WORK_TIME;                                            
                                }

                                //연장근무가 있을 경우
                                if(MONTH_EXTEND_WORK_TIME > 0) {

                                    sql.setLength(0);
                                    sql.append("UPDATE HAT300T A" + "\n");
                                    sql.append("SET A.EXTEND_WORK_TIME =" + MONTH_EXTEND_WORK_TIME + "\n");
                                    sql.append("WHERE COMP_CODE   = " + "'" + COMP_CODE + "'" + "\n");
                                    sql.append("AND   DUTY_YYYYMM = " + "'" + DUTY_YYYYMMDD + "'" + "\n");
                                    sql.append("AND   PERSON_NUMB = " + "'" + FIRST_PERSON_NUMB + "'" + "\n");

                                    pstmt = conn.prepareStatement(sql.toString());
                                    pstmt.execute();
                                    pstmt.close();
                                }

                                MONTH_EXTEND_WORK_TIME = 0;
                                REST_TIME = 0;
                                WORK_TIME = 0;                                        
                            }

                            if(FIRST_CAL_NO != CAL_NO){
                                //REST_TIME이 0이 아닐경우는 한주동안 연장근무를 4시간 이상하지 않았으므로 분으로 들어오는 dblRest_Time를 시간으로 처리해줘야 함
                                if(WORK_TIME != 0){
                                    WORK_TIME = Math.round(WORK_TIME / 60);
                                }

                                //주가 바뀔때마다 연장근무시간을 더한다
                                MONTH_EXTEND_WORK_TIME = MONTH_EXTEND_WORK_TIME + WORK_TIME;
                                REST_TIME = INT_EXTEND_TIME * 60;
                                MODREST_MINU = 0;
                                MODREST_TIME = 0;
                                WORK_TIME = 0;
                                FIRST_DUTY_YYYYMMDD = DUTY_YYYYMMDD_C;
                                WEEK = "1";

                            }

                            if(WEEK.equals("1")){
                                if(REST_TIME - (DUTY_TIME_C * 60) - DUTY_MINU_C <= 0){
                                    MODREST_TIME = ((DUTY_TIME_C * 60) + DUTY_MINU_C) - REST_TIME;
                                    MODREST_MINU = MODREST_TIME % 60;
                                    MODREST_TIME = MODREST_TIME / 60;
                                    CALCUWORK_TIME = Math.round(REST_TIME/60);

                                    sql.setLength(0);
                                    sql.append("UPDATE HAT200T" + "\n");
                                    sql.append("SET DUTY_TIME = DUTY_TIME - " + CALCUWORK_TIME + "\n");
                                    sql.append("WHERE COMP_CODE   = " + "'" + COMP_CODE + "'" + "\n");
                                    sql.append("AND   DUTY_YYYYMM = " + "'" + DUTY_YYYYMMDD + "'" + "\n");
                                    sql.append("AND   PERSON_NUMB = " + "'" + PERSON_NUMB_C + "'" + "\n");
                                    sql.append("AND   DUTY_CODE   = " + "'" + DUTY_CODE_C + "'" + "\n");

                                    pstmt = conn.prepareStatement(sql.toString());
                                    pstmt.execute();
                                    pstmt.close();

                                    //전월에 4시간 미만 연장근로 하여 같은 주로 넘어온 경우 남은 시간만 할증시간으로 처리

                                    if(REST_TIME + WORK_TIME >= 240){
                                        REST_TIME = INT_EXTEND_TIME;
                                    }else{
                                        REST_TIME = Math.round(REST_TIME / 60);
                                    }

                                    MONTH_EXTEND_WORK_TIME = MONTH_EXTEND_WORK_TIME + WORK_TIME;
                                    REST_TIME = 0;
                                    WORK_TIME = 0;
                                    CALCUWORK_TIME = 0;
                                    WEEK = "0";
                                } else{

                                    REST_TIME = REST_TIME - (DUTY_TIME_C * 60) - DUTY_MINU_C;
                                    WORK_TIME = WORK_TIME + (DUTY_TIME_C * 60) + DUTY_MINU_C;
                                }

                                if(((DUTY_TIME_C != 0) || (DUTY_MINU_C != 0)) && (REST_TIME > 0)){
                                    sql.setLength(0);
                                    sql.append("UPDATE HAT200T " + "\n");
                                    sql.append("SET DUTY_TIME = DUTY_TIME -  ROUND(((" + DUTY_TIME_C + " * 60) + " + DUTY_MINU_C + ") / 60, 6)" + "\n");
                                    sql.append("WHERE COMP_CODE   = " + "'" + COMP_CODE + "'" + "\n");
                                    sql.append("AND   DUTY_YYYYMM = " + "'" + DUTY_YYYYMMDD + "'" + "\n");
                                    sql.append("AND   PERSON_NUMB = " + "'" + PERSON_NUMB_C + "'" + "\n");
                                    sql.append("AND   DUTY_CODE   = " + "'" + DUTY_CODE_C + "'" + "\n");

                                    pstmt = conn.prepareStatement(sql.toString());
                                    pstmt.execute();
                                    pstmt.close();
                                }                                        
                            }                                    
                        } else{
                            // 연장근무 할증율이 기간중이다 3년이 경과할 경우 기간중에 계산된 것을 저장한다(시작일자 이전은 계산하지 않는다
                            if(Integer.parseInt(DUTY_YYYYMMDD_C) > Integer.parseInt(STREXTEND_END_DATE)){
                                if(WORK_TIME != 0){
                                    WORK_TIME = Math.round(WORK_TIME / 60);
                                    MONTH_EXTEND_WORK_TIME = MONTH_EXTEND_WORK_TIME + WORK_TIME;    
                                }

                                if(MONTH_EXTEND_WORK_TIME > 0){
                                    sql.setLength(0);
                                    sql.append("UPDATE HAT300T " + "\n");
                                    sql.append("SET EXTEND_WORK_TIME = " + MONTH_EXTEND_WORK_TIME + "\n");
                                    sql.append("WHERE COMP_CODE   = " + "'" + COMP_CODE + "'" + "\n");
                                    sql.append("AND   DUTY_YYYYMM = " + "'" + DUTY_YYYYMMDD + "'" + "\n");
                                    sql.append("AND   PERSON_NUMB = " + "'" + FIRST_PERSON_NUMB + "'" + "\n");

                                    pstmt = conn.prepareStatement(sql.toString());
                                    pstmt.execute();
                                    pstmt.close();

                                    MONTH_EXTEND_WORK_TIME = 0;
                                    REST_TIME = 0;
                                    WORK_TIME = 0;
                                }
                            }                                    
                        }
                        FIRST_CAL_NO = CAL_NO;
                        FIRST_PERSON_NUMB = PERSON_NUMB_C;

                    }  // End of While 

                    if(WORK_TIME != 0){
                        WORK_TIME = Math.round(WORK_TIME / 60);
                        //주가 바뀔때마다 연장근무시간을 더한다
                        MONTH_EXTEND_WORK_TIME = MONTH_EXTEND_WORK_TIME + WORK_TIME;
                    }

                    //연장근무가 있을 경우
                    if(MONTH_EXTEND_WORK_TIME > 0){
                        sql.setLength(0);
                        sql.append("UPDATE HAT300T " + "\n");
                        sql.append("SET EXTEND_WORK_TIME = " + MONTH_EXTEND_WORK_TIME + "\n");
                        sql.append("WHERE COMP_CODE    = " + "'" + COMP_CODE + "'" + "\n");
                        sql.append("AND   DUTY_YYYYMM  = " + "'" + DUTY_YYYYMMDD + "'" + "\n");
                        sql.append("AND   PERSON_NUMB  = " + "'" + FIRST_PERSON_NUMB + "'" + "\n");

                        pstmt = conn.prepareStatement(sql.toString());
                        pstmt.execute();
                        pstmt.close();
                    }
                }
            }
            

            //연장근로 할증로직 미계산
            if(ISEXTENDED.equals("N")){

                sql.setLength(0);            
                sql.append("SET @COMP_CODE             = " + "'" + COMP_CODE + "';\n");
                sql.append("SET @DUTY_YYYYMMDD         = " + "CASE WHEN '" + DUTY_YYYYMMDD + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_FR      = " + "CASE WHEN '" + DUTY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @DUTY_YYYYMMDD_TO      = " + "CASE WHEN '" + DUTY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + DUTY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_FR       = " + "CASE WHEN '" + PAY_YYYYMMDD_FR + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_FR + "' END;\n");
                sql.append("SET @PAY_YYYYMMDD_TO       = " + "CASE WHEN '" + PAY_YYYYMMDD_TO + "' = '' THEN NULL ELSE '" + PAY_YYYYMMDD_TO + "' END;\n");
                sql.append("SET @PERSON_NUMB           = " + "'" + PERSON_NUMB + "';\n");
                sql.append("SET @UPDATE_DB_USER        = " + "'" + UPDATE_DB_USER + "';\n");
                sql.append("SET @PAY_PROV_FLAG         = " + "'" + PAY_PROV_FLAG + "';\n");
                sql.append("SET @DIV_CODE              = " + "'" + DIV_CODE + "';\n");
                sql.append("SET @DEPT_CODE_TO          = " + "'" + DEPT_CODE_TO + "';\n");
                sql.append("SET @DEPT_CODE_FR          = " + "'" + DEPT_CODE_FR + "';\n");
                sql.append("" + "\n");                        
                sql.append("    -- 5. " + "\n");
                sql.append("    SET @dblExtend_Work_Time = (SELECT NVL(EXTEND_WORK_TIME, '0') AS EXTEND_WORK_TIME " + "\n");
                sql.append("                                                FROM          HAT300T AS T" + "\n");
                sql.append("                                               INNER JOIN HUM100T AS V ON T.COMP_CODE    = V.COMP_CODE" + "\n");
                sql.append("                                                                                      AND T.PERSON_NUMB = V.PERSON_NUMB" + "\n");
                sql.append("                                               LEFT  JOIN (" + "\n");
                sql.append("                                                                    SELECT D.COMP_CODE" + "\n");
                sql.append("                                                                             , D.PERSON_NUMB" + "\n");
                sql.append("                                                                             , D.BE_DIV_NAME AS BE_DIV_CODE" + "\n");
                sql.append("                                                                    FROM HUM760T AS D" + "\n");
                sql.append("                                                                    WHERE D.COMP_CODE      =  @COMP_CODE " + "\n");
                sql.append("                                                                    AND D.ANNOUNCE_DATE >=  @DUTY_YYYYMMDD_FR " + "\n");
                sql.append("                                                                    AND D.ANNOUNCE_DATE <= @DUTY_YYYYMMDD_TO " + "\n");
                sql.append("                                                                    AND D.ANNOUNCE_CODE  = (SELECT MAX(ANNOUNCE_CODE)" + "\n");
                sql.append("                                                                                                              FROM HUM760T " + "\n");
                sql.append("                                                                                                              WHERE COMP_CODE      = D.COMP_CODE" + "\n");
                sql.append("                                                                                                              AND PERSON_NUMB    = D.PERSON_NUMB" + "\n");
                sql.append("                                                                                                              AND ANNOUNCE_DATE  = D.ANNOUNCE_DATE)" + "\n");
                sql.append("                                                                     GROUP BY D.COMP_CODE, D.PERSON_NUMB, D.BE_DIV_NAME" + "\n");
                sql.append("                                                                   ) AS D ON D.COMP_CODE   = V.COMP_CODE" + "\n");
                sql.append("                                                                           AND D.PERSON_NUMB = V.PERSON_NUMB" + "\n");
                sql.append("                                              WHERE T.DUTY_YYYYMM       = @COMP_CODE " + "\n");
                sql.append("                                              AND V.PAY_PROV_FLAG         =  @PAY_PROV_FLAG" + "\n");
                sql.append("                                              AND NVL(V.DIV_CODE, '')      = CASE WHEN D.BE_DIV_CODE IS NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE V.DIV_CODE END" + "\n");
                sql.append("                                              AND NVL(D.BE_DIV_CODE, '') = CASE WHEN D.BE_DIV_CODE IS NOT NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE ''  END" + "\n");
                sql.append("                                              AND V.PERSON_NUMB = CASE WHEN @PERSON_NUMB IS NOT NULL THEN @PERSON_NUMB ELSE V.PERSON_NUMB END" + "\n");
//                sql.append("                                              AND NVL(V.DIV_CODE, '')      = CASE WHEN NVL(D.BE_DIV_CODE, '') = '' AND @DIV_CODE <> '' THEN @DIV_CODE ELSE V.DIV_CODE END" + "\n");
//                sql.append("                                              AND NVL(D.BE_DIV_CODE, '') = CASE WHEN NVL(D.BE_DIV_CODE, '') != '' AND @DIV_CODE != '' THEN @DIV_CODE ELSE ''  END" + "\n");
//                sql.append("                                              AND V.PERSON_NUMB = CASE WHEN NVL(@PERSON_NUMB, '') != '' THEN @PERSON_NUMB ELSE V.PERSON_NUMB END" + "\n");
//                sql.append("                                              AND V.DEPT_CODE >= CASE WHEN NVL(@DEPT_CODE_FR, '') != '' THEN @DEPT_CODE_FR ELSE V.DEPT_CODE END" + "\n");
//                sql.append("                                              AND V.DEPT_CODE <= CASE WHEN NVL(@DEPT_CODE_TO, '') != '' THEN @DEPT_CODE_TO ELSE V.DEPT_CODE END" + "\n");
                sql.append("                                            );" + "\n");
                sql.append("                                            " + "\n");
                sql.append("                                            " + "\n");
                sql.append("    " + "\n");
                sql.append("    SET @dblExtend_Work_Time = CASE WHEN @dblExtend_Work_Time IS NOT NULL THEN 0 ELSE @dblExtend_Work_Time END;" + "\n");
//                sql.append("    SET @dblExtend_Work_Time = CASE WHEN NVL(@dblExtend_Work_Time, '') = '' THEN 0 ELSE @dblExtend_Work_Time END;" + "\n");
                sql.append("    " + "\n");
                sql.append("        UPDATE HAT300T T" + "\n");
                sql.append("        INNER JOIN HUM100T AS V  ON V.COMP_CODE    = T.COMP_CODE" + "\n");
                sql.append("                                                AND V.PERSON_NUMB = T.PERSON_NUMB" + "\n");
                sql.append("        LEFT  JOIN (" + "\n");
                sql.append("                            SELECT " + "\n");
                sql.append("                                   D.COMP_CODE" + "\n");
                sql.append("                                 , D.PERSON_NUMB" + "\n");
                sql.append("                                 , D.BE_DIV_NAME AS BE_DIV_CODE" + "\n");
                sql.append("                            FROM HUM760T AS D " + "\n");
                sql.append("                            WHERE D.COMP_CODE          = @COMP_CODE" + "\n");
                sql.append("                            AND     D.ANNOUNCE_DATE >= @DUTY_YYYYMMDD_FR " + "\n");
                sql.append("                            AND     D.ANNOUNCE_DATE <= @DUTY_YYYYMMDD_TO" + "\n");
                sql.append("                            AND     D.ANNOUNCE_CODE  = (" + "\n");
                sql.append("                                                                          SELECT MAX(ANNOUNCE_CODE)" + "\n");
                sql.append("                                                                          FROM HUM760T " + "\n");
                sql.append("                                                                          WHERE COMP_CODE      = D.COMP_CODE" + "\n");
                sql.append("                                                                          AND PERSON_NUMB      = D.PERSON_NUMB" + "\n");
                sql.append("                                                                          AND ANNOUNCE_DATE  = D.ANNOUNCE_DATE" + "\n");
                sql.append("                                                                          )" + "\n");
                sql.append("                             GROUP BY D.COMP_CODE, D.PERSON_NUMB, D.BE_DIV_NAME" + "\n");
                sql.append("                           ) AS D ON D.COMP_CODE     = V.COMP_CODE" + "\n");
                sql.append("                                   AND D.PERSON_NUMB  = V.PERSON_NUMB" + "\n");
                sql.append("        SET T.EXTEND_WORK_TIME        = @dblExtend_Work_Time" + "\n");
                sql.append("        WHERE T.DUTY_YYYYMM           = @DUTY_YYYYMMDD" + "\n");
                sql.append("        AND T.PERSON_NUMB             = V.PERSON_NUMB " + "\n");
                sql.append("        AND V.PAY_PROV_FLAG           =  @PAY_PROV_FLAG" + "\n");
                sql.append("        AND NVL(V.DIV_CODE, '')       = (CASE WHEN D.BE_DIV_CODE IS NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE V.DIV_CODE END)" + "\n");
                sql.append("        AND NVL(D.BE_DIV_CODE, '')    = (CASE WHEN D.BE_DIV_CODE IS NOT NULL AND @DIV_CODE IS NOT NULL THEN @DIV_CODE ELSE ''  END)" + "\n");
                sql.append("        AND V.PERSON_NUMB             = (CASE WHEN @PERSON_NUMB  IS NOT NULL THEN @PERSON_NUMB ELSE V.PERSON_NUMB END)" + "\n");
//                sql.append("        AND NVL(V.DIV_CODE, '')       = (CASE WHEN NVL(D.BE_DIV_CODE, '')   = '' AND @DIV_CODE !=  '' THEN @DIV_CODE ELSE V.DIV_CODE END)" + "\n");
//                sql.append("        AND NVL(D.BE_DIV_CODE, '')    = (CASE WHEN NVL(D.BE_DIV_CODE, '')  != '' AND @DIV_CODE != ''  THEN @DIV_CODE ELSE ''  END)" + "\n");
//                sql.append("        AND V.PERSON_NUMB             = (CASE WHEN NVL(@PERSON_NUMB, '')   != '' THEN @PERSON_NUMB ELSE V.PERSON_NUMB END)" + "\n");
//                sql.append("        AND V.DEPT_CODE              >= (CASE WHEN NVL(@DEPT_CODE_FR, '')  != '' THEN @DEPT_CODE_FR ELSE V.DEPT_CODE END)" + "\n");
//                sql.append("        AND V.DEPT_CODE              <= (CASE WHEN NVL(@DEPT_CODE_TO, '')  != '' THEN @DEPT_CODE_TO ELSE V.DEPT_CODE END);" + "\n");

                pstmt = conn.prepareStatement(sql.toString());
                pstmt.execute();
                pstmt.close();
            }
*/            

            // 임시테이블 데이터 삭제
            sql.setLength(0);
            sql.append(" DELETE FROM T_HAT200UKR_1 WHERE KEY_VALUE = " + "'" + KeyValue + "';" + "\n");
            sql.append(" DELETE FROM T_HAT200UKR_2 WHERE KEY_VALUE = " + "'" + KeyValue + "';" + "\n");
            sql.append(" DELETE FROM T_HAT200UKR_3 WHERE KEY_VALUE = " + "'" + KeyValue + "';" + "\n");
            sql.append(" DELETE FROM T_HAT200UKR_4 WHERE KEY_VALUE = " + "'" + KeyValue + "';" + "\n");

            pstmt = conn.prepareStatement(sql.toString());
            pstmt.execute();
            pstmt.close();


            rs.close();

            //트랜잭션 커밋
            conn.setAutoCommit(true);


            sRtn = "집계 작업이 완료 되었습니다.";
            return sRtn;
        } catch (Exception e) {
            return "집계 작업을 실패 하였습니다.";
        }
    }           
}