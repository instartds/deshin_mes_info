package foren.unilite.modules.base.bpr;

import java.io.DataOutputStream;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("bpr813rkrvService")
public class Bpr813rkrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	


    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void insertSerialNo(Map param) throws Exception {

        Map checkSerialNo = (Map) super.commonDao.select("bpr813rkrvServiceImpl.checkSerialNo", param);
        if(ObjUtils.isEmpty(checkSerialNo)){
            super.commonDao.insert("bpr813rkrvServiceImpl.insertSerialNo", param);
            
        }
        return;
    } 
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void updateSerialNo(Map param) throws Exception {

        super.commonDao.update("bpr813rkrvServiceImpl.updateSerialNo", param);
          
        return;
    } 
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkSerialNo(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr813rkrvServiceImpl.checkSerialNo", param);
        
    }
	
	
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public String printAllLogic(Map param) throws Exception {

        
        String rtnV = "";
                

        int readSerialNo = 0;
        String today = "";
        
        if(ObjUtils.getSafeString(param.get("RE_PRINT")).equals("2")){
        
        
	        Map<String, Object> tempParam1 = new HashMap<String, Object>();
	        
	        tempParam1.put("S_COMP_CODE", param.get("S_COMP_CODE"));
	        tempParam1.put("DIV_CODE", param.get("DIV_CODE"));
	        tempParam1.put("S_USER_ID", param.get("S_USER_ID"));
	        tempParam1.put("LOT_NO", param.get("LOT_NO"));
	        
	        this.insertSerialNo(tempParam1);
	        
	        Map tempMap1 = this.checkSerialNo(param);
	        
	      //채번테이블에 마지막으로 저장된 시리얼번호
	        readSerialNo = Integer.parseInt(ObjUtils.getSafeString(tempMap1.get("SERIAL_NO")));
	      //채번테이블에 저장된 오늘날짜
	        today = ObjUtils.getSafeString(tempMap1.get("BASIS_DATE"));
	        
	        
	        //채번테이블에 마지막으로 저장된 시리얼번호 + 발행매수
	        int saveSerialNo = 0;
	        saveSerialNo = readSerialNo + Integer.parseInt(ObjUtils.getSafeString(param.get("CNT")));  
	        
	        
	        /**
	         * BAUTONOT(채번테이블)  UPDATE  
	         * LAST_SEQ 마지막 시리얼번호
	         */
	        tempParam1.put("LAST_SEQ", saveSerialNo);
	        this.updateSerialNo(tempParam1);
	        
	        
	        
        
        
        
        }else{
        
        
        
	        //재발행일경우
	        readSerialNo = Integer.parseInt(ObjUtils.getSafeString(param.get("SERIAL_NO")));
	        readSerialNo= readSerialNo -1;
	        today = ObjUtils.getSafeString(param.get("SYSDATE"));
        
        }
        
        
        String ZPLString = "";
        
        String ipAdr = "";
        int port = 0;

        Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));
        
//        tempParam0.put("LABEL_GUBUN", "5");
        Map tempMap0 =this.checkIpAddr(tempParam0);
        ipAdr = ObjUtils.getSafeString(tempMap0.get("IP_ADDR"));		//IP정보
        port = 6101;
//        String ipAdr = "192.168.123.183";	//유양산전 내부
//        int port = 9100;
        
        int cnt = 0;
            
        
        cnt = ObjUtils.parseInt(param.get("CNT"));
        
        String itemName = "";
        String itemCode = "";
        String spec = "";
        String lotNo = "";
        String DataMatrix = "";
        
        
        itemName = ObjUtils.getSafeString(param.get("ITEM_NAME"));
        itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE"));
        spec = ObjUtils.getSafeString(param.get("SPEC"));
//      lotNo = today.substring(2,8);
        lotNo = ObjUtils.getSafeString(param.get("LOT_NO"));
        
      
        String sN = "";	
        
        Socket clientSocket = new Socket(ipAdr,port);
        
        for(int i=0; i<cnt; i++) {
            DataMatrix = itemCode + lotNo + String.format("%05d",readSerialNo+1+i);
       

        	sN = lotNo + String.format("%05d",readSerialNo+1+i);
            
            /* 20180530 PCB출력 최종 */
//        	ZPLString = "^XA^LH0,0^XZ";
//    		ZPLString += "^XA^LT0^XZ";
            
            ZPLString = "^XA";
            ZPLString += "^SEE:UHANGUL.DAT^FS";
//    		ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
            ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
            ZPLString +="^PW400";
            ZPLString += "^LH0,0^FS";
            ZPLString += "^LT0^FS";
//            ZPLString +="^FO40,60^BXN,3,200^FD"+DataMatrix+"^FS";
//            ZPLString +="^FO110,65^A1,20,20^FD"+itemCode+"^FS";
//            ZPLString +="^FO40,60^A1N,20,20^FD"+sN+"^FS";
            

            ZPLString +="^FO35,20^BXN,3,200^FD"+DataMatrix+"^FS";
            ZPLString +="^FO100,20^A1N,23,23^FD"+itemCode+"^FS";
            ZPLString +="^FO100,50^A1N,23,23^FD"+sN+"^FS";
            
            ZPLString +="^XZ";
            
            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            byte[] dataTest = ZPLString.getBytes("EUC-KR"); 
            outToServer.write(dataTest);
        }
        
        

        clientSocket.close();
        
        
        
        
        rtnV = "Y";
        
        return rtnV;
    } 

    /**
     * 라벨프린트 ip정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkIpAddr(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr813rkrvServiceImpl.checkIpAddr", param);
        
    }
}
