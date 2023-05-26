package test.oracle;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;

/**
 * @Class Name : TraceParser.java
 * @Description : !!! Describe Class
 * @author SangJoon Kim
 * @since 2012-12-05
 * @version 1.0
 * @see
 * 
 * @Modification Information
 * 
 *               <pre>
 *    Date                Changer         Comment
 *  ===========    =========    ===========================
 *  2012-12-05 by SangJoon Kim: initial version
 * </pre>
 */

public class TraceParser {
    public static void main(String args[]) throws Exception {
        String path = "C:/TRA/workspace/tra_cmi/src/java/test/oracle/data/"; 
        String filename = null;
        //String filename = path + "BOL_ADD.trc";
        filename = path + "BOL_AMEND _ADD_BOL.trc";
        filename = path +"BOL_AMEND__DEL_CONTAINER.trc";
        filename = path +"BOL_MANUAL_DISCHARGE_OR_BOL_WRITE_OFF.trc";
        filename = path +"MANIFEST_AMEND_GENERAL_DETAILS_AFTER_REGISTRATION_CHANGED_DESTINATION_TZDAR_TO_TZMYW.trc";
        filename = path + "/Master_Manifest/Master_Manifest_Add_Container.trc";
        filename = path + "/Master_Manifest/Master_Manifest_Add_Master_BOL.trc";
        filename = path + "/Master_Manifest/Master_Manifest_Delete_Container.trc";
        filename = path + "/Master_Manifest/Master_Manifest_Manifest_General_Details_Amendment.trc";
        filename = path + "/Master_Manifest/Master_Manifest_Manual_Discharge.trc";
        filename = path + "/T1/Master_T1_generation_does_not_have_driver_vehicle_info.trc";
        filename = path + "/T1/T1_Supplimentary_with_driver_details_and_itinerary.trc";
        
        FileInputStream fstream = new FileInputStream(filename);
        // Get the object of DataInputStream
        DataInputStream in = new DataInputStream(fstream);
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        String strLine = null;
        // Read File Line By Line
        int lineNo = 0;
        
        StringBuffer sql = new StringBuffer();
        StringBuffer vars = new StringBuffer();
        
     //   while (((strLine = br.readLine()) != null) && (lineNo < 30000)) {
            while (((strLine = br.readLine()) != null) ) {
            // Print the content on the console
            lineNo++;
            if (strLine.startsWith("PARSING IN CURSOR")) {
                sql.append(" ----- Line : " + lineNo + " \r\n ");
                
                // SQL
                boolean chk = true;
                do {
                    strLine = br.readLine();lineNo++;
                    if (strLine != null && !strLine.startsWith("END OF STMT")) {
                        sql.append(strLine);
                    } else {
                        chk = false;
                    }
                } while (chk);
                
                // Bind Variable
                chk = true;
                int vi = 0;
                do {
                    strLine = br.readLine(); lineNo++;
                    if (strLine != null && !strLine.startsWith("=======")) {
                        if(strLine.startsWith(" bind")) {
                            vars.append("\n--Bind " + vi);
                            vi ++ ;
                        }
                        if(strLine.startsWith("   value=")) {
                            vars.append(strLine);
                        }
                    } else {
                        chk = false;
                    }
                } while (chk);
//                System.out.println(SqlFormatter.sqlFormat(sql.toString(), false) + " ;\r\n");
                out(sql + " ;");
                out(vars.toString()+ " \r\n");
            }
            sql.setLength(0);
            vars.setLength(0);
        }
        System.out.println(">>> END");
    }
    
    public static void out(String out) {
        System.out.println(out);
    }
}
