package foren.unilite.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import foren.framework.utils.MiFormat;

public class DateUtis {
    public static TimeZone          tz                = TimeZone.getDefault();
    private static SimpleDateFormat formatter         = new SimpleDateFormat("yyyyMMdd", Locale.KOREA);
    private static SimpleDateFormat longDateFormatter = new SimpleDateFormat("yyyyMMddHHmmss");
    
    /**
     * <pre>
     * 오늘일자를 "yyyyMMdd" 타입으로 리턴
     * </pre>
     * 
     * @return
     */
    public static String getToDay() {
        Date currentTime = new Date();
        return formatter.format(currentTime);
    }
    
    /**
     * <pre>
     * 오늘일자를 입력된 DataFomat 타입으로 리턴
     * </pre>
     * 
     * @param str
     * @return
     */
    public static String getToDayForDateFormat( String dateFormat ) {
        String dTime = null;
        
        SimpleDateFormat formatter = new SimpleDateFormat(dateFormat, Locale.KOREA);
        Date currentTime = new Date();
        dTime = formatter.format(currentTime);
        
        return dTime;
    }
}
