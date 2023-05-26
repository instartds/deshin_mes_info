package foren.unilite.modules.com.barcodePrint;

import java.io.DataOutputStream;
import java.net.Socket;
import java.util.Map;

import foren.framework.utils.ObjUtils;

public class BarcodePrintUtils {
    
    public static void barcodePrint(Map param) {
        try{
            String ipAdr = "";
            if(ObjUtils.isNotEmpty(param.get("IP_ADR"))){
                ipAdr = ObjUtils.getSafeString(param.get("IP_ADR"));
            }
            int port = 0001;
            if(ObjUtils.isNotEmpty(param.get("PORT"))){
                port = ObjUtils.parseInt(param.get("PORT"));
            }
            int cnt = 0;
            if(ObjUtils.isNotEmpty(param.get("CNT"))){
                cnt = ObjUtils.parseInt(param.get("CNT"));
            }
            String zplStr = "";
            if(ObjUtils.isNotEmpty(param.get("ZPL_STR"))){
                zplStr = ObjUtils.getSafeString(param.get("ZPL_STR"));
            }
            
            Socket clientSocket=new Socket(ipAdr,port);
     
            for(int i=0; i<cnt; i++) {
                
                DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
                byte[] dataTest = zplStr.getBytes("EUC-KR"); 
                outToServer.write(dataTest);
            }
            clientSocket.close();
        }catch (Exception ex){
            
        }
    }
}
