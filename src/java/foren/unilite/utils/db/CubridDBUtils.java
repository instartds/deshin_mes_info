package foren.unilite.utils.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <pre>
 * CUBRID ResultSet 객체의 데이터를 List에 담아서 리턴하는 Utility Class 입니다.
 * </pre>
 * 
 * @author 박종영
 */
public class CubridDBUtils {
    private static final Logger logger = LoggerFactory.getLogger(CubridDBUtils.class);
    
    /**
     * <pre>
     * CUBRID ResultSet 객체의 데이터를 List에 담아서 리턴하는 Utility Class 입니다.
     * </pre>
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    public static List<Map<String, Object>> getRsToList( ResultSet rs ) throws Exception {
        List<Map<String, Object>> rList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = null;
        
        try {
            ResultSetMetaData rsmd = rs.getMetaData();
            
            while (rs.next()) {
                //logger.info("getRs() || getColumnCount :: " + rsmd.getColumnCount());
                map = new HashMap<String, Object>();
                
                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    
                    //logger.info("getRs() ColumnName :: " + rsmd.getColumnName(i) + " :: ColumnType :: " + rsmd.getColumnType(i) + " :: Value :: " + rs.getString(rsmd.getColumnName(i)));
                    map.put(rsmd.getColumnName(i).toUpperCase(), rs.getString(rsmd.getColumnName(i)));
                }
                
                rList.add(map);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {}
        
        return rList;
    }
    
    public static void main( String[] args ) throws Exception {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // CUBRID Connect
            Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
            conn = DriverManager.getConnection("jdbc:cubrid:192.168.1.220:30000:OmegaPlus:::?charset=UTF-8", "unilite", "UNILITE");
            logger.info("큐브리드 접속성공");
            StringBuffer sql = new StringBuffer();
            sql.append("SELECT * FROM BSA300T\n");
            
            logger.info("=======================================================");
            logger.info(sql.toString());
            logger.info("=======================================================");
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql.toString());
            
            List<Map<String, Object>> rList = getRsToList(rs);
            
            logger.info("rList :: {}", rList);
            
            for (Map<String, Object> map : rList) {
                logger.info("END_DATE :: {}", map.get("END_DATE"));
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        } catch (Exception e) {
            System.err.println(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
    
}
