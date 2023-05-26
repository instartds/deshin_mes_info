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

@Service("bpr811rkrvService")
public class Bpr811rkrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	
    /**
     * 참조정보
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public List<Map<String, Object>>  referenceInfo(Map param) throws Exception {    
        
        return super.commonDao.list("bpr811rkrvServiceImpl.referenceInfo", param);
        
    }
    
    /**
     * Z001 KS마크 이름 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkKsmarkName(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkKsmarkName", param);
        
    }
	
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public String printAllLogic(Map param) throws Exception {

        
        String rtnV = "";

        int readSerialNo = 0;
        String basisDate = "";

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
        basisDate = ObjUtils.getSafeString(tempMap1.get("BASIS_DATE"));
        
        
        //채번테이블에 마지막으로 저장된 시리얼번호 + 발행매수
        int saveSerialNo = 0;
        saveSerialNo = readSerialNo + Integer.parseInt(ObjUtils.getSafeString(param.get("CNT")));  
        
        
        /**
         * BAUTONOT(채번테이블)  UPDATE  
         * LAST_SEQ 마지막 시리얼번호
         */
        tempParam1.put("LAST_SEQ", saveSerialNo);
        this.updateSerialNo(tempParam1);
        
        
        
        
        
        String ZPLString = "";
        
        String ipAdr = "";
        int port = 0;
        
        Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));
//        tempParam0.put("LABEL_GUBUN", "4");
        
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
        String type = "";
        String lotNo = "";
        String DataMatrix = "";
        int insideCnt = 0;
        
        String ksMarkGubun = "";
        String ksMarkName = "";

        
        itemName = ObjUtils.getSafeString(param.get("ITEM_NAME"));
        itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE"));
        spec = ObjUtils.getSafeString(param.get("SPEC"));
        type = ObjUtils.getSafeString(param.get("TYPE"));
//      lotNo = today.substring(2,8);
        lotNo = ObjUtils.getSafeString(param.get("LOT_NO"));
        
        insideCnt =  ObjUtils.parseInt(param.get("INSIDE_CNT"));
        
        
        ksMarkGubun = ObjUtils.getSafeString(param.get("KS_MARK_GUBUN")); 
        ksMarkName = ObjUtils.getSafeString(param.get("KS_MARK_NAME"));
        
        
        Map<String, Object> tempParam3 = new HashMap<String, Object>();
        
        tempParam3.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam3.put("ITEM_CODE", itemCode);
        tempParam3.put("KS_MARK_GUBUN", ksMarkGubun);

        String ksMarkRef2 = "";
        String ksMarkRef3 = "";
        String ksMarkRef4 = "";
        
        if(ObjUtils.getSafeString(param.get("KS_GUBUN")).equals("2")){  
	        Map tempMap3 = this.checkMarkRef(tempParam3);
	        
	        ksMarkRef2 = ObjUtils.getSafeString(tempMap3.get("KS_MARK_REF2"));
	        ksMarkRef3 = ObjUtils.getSafeString(tempMap3.get("KS_MARK_REF3"));
	        ksMarkRef4 = ObjUtils.getSafeString(tempMap3.get("KS_MARK_REF4"));
        }
        
        String etlMarkCheck = "";
        
        etlMarkCheck = ObjUtils.getSafeString(param.get("ETL")); 

        String sN = "";

        String sNtr = "";		//tr출력용
        
        Socket clientSocket = new Socket(ipAdr,port);
        
        for(int i=0; i<cnt; i++) {
            DataMatrix = itemCode + lotNo + String.format("%05d",readSerialNo+1+i);
//            sN = lotNo.substring(0,2) + String.format("%05d",readSerialNo+1+i);
            if(ObjUtils.getSafeString(param.get("SIZE")).equals("1")){      // BOX
          
                /* 20180529 box 최종본*/
                
//if(ipAdr.equals("192.168.123.184")){			//유양산전에서 box 라벨 출력하는 프린트기가 두대가 있는데 한대에서 값들이 위로 올라가서 찍히는 현상이 있어서 해당(IP) 라벨프린트에서 임의로 값들을 내리는 작업
//	ZPLString = "^XA^LS-15^XZ";
//}else{
//	ZPLString = "^XA^LS0^XZ";
//}
//            	ZPLString = "^XA^LH0,0^XZ";
//				ZPLString += "^XA^LT0^XZ";
                ZPLString = "^XA";
                ZPLString += "^SEE:UHANGUL.DAT^FS";
//        		ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
                ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
                ZPLString +="^PW800";		//라벨 가로 크기관련
                ZPLString += "^LH0,0^FS";
                ZPLString += "^LT0^FS";
                /*  글자크기  40,40*/      
                /*
            	ZPLString +="^FO640,260^A1R,40,40^FD"+itemName+"^FS";
                
                ZPLString +="^FO560,260^A1R,40,40^FD"+itemCode+"^FS";

                ZPLString +="^FO480,260^A1R,40,40^FD"+type+"^FS";
                
                ZPLString +="^FO400,260^A1R,40,40^FD"+spec+"^FS";

                ZPLString +="^FO330,550^A1R,40,40^FD"+insideCnt+"^FS";
                
                ZPLString +="^FO240,260^A1R,40,40^FD"+lotNo+"^FS";
                 */
                /*  글자크기  35,35*/   
               
	ZPLString +="^FO640,260^A1R,35,35^FD"+itemName+"^FS";
                
                ZPLString +="^FO560,260^A1R,35,35^FD"+itemCode+"^FS";

                ZPLString +="^FO480,260^A1R,35,35^FD"+type+"^FS";
                
                ZPLString +="^FO400,260^A1R,35,35^FD"+spec+"^FS";

if(insideCnt != 0){
                ZPLString +="^FO330,550^A1R,35,35^FD"+insideCnt+"^FS";
}           
                ZPLString +="^FO240,260^A1R,35,35^FD"+lotNo+"^FS";
                
               
                ZPLString +="^FO60,450^BXR,5,200^FD"+DataMatrix+"^FS";
                
            	if(etlMarkCheck.equals("true")) { //ETL
                    
                    ZPLString +="~DG000.GRF,01536,016,";
                    ZPLString +=",::::::K07FFC10L03FE,K07FFC10K07FIF0,O010J03FJFE,O010J07FKF80,K03FC010I01FF8007FE0,K07FC010I03F80I07F8,K03FC010I0HFK03F8,M04010H01FC0K07E,M04010H03F003FE003F,M04010H07E00FHFC01F80,K03FC010H0FC07FIFH0FC0,K07FC01001F80FJFC07C0,K03F001001F03FJFE03F0,O01003C07FKF81F0,M0401003C0FFCFDFFC0F8,K03FF0100181FE0FC3FE0F8,K07FF8100C03F80FC0FF03C,K06040100F03F80FC07F03C,K02040100C0FF00FC03F83E,O010020FC00FC01FC1E,K01F00101A0FC00FC00FC0E,K03FC010081F800FC007E0F,K0H2C010243F80K07E0F,K0624010040Q0F,K06240107C0N03F07,K062C0101C0N03F07,K063C010380N03F0780,L030010587FOF0780,O010787FOF0780,K03FC010787FOF0780,K07FC010187FOF0780,K03FC010787FOF0780,M04010187FOF0780,M04010Q03F0780,M0C0100C0N03F07,O010Q03E07,M0C0103C0Q0F,K03FF010341FNFE0F,K07FF810081FNFE0F,K0604010020FNFC1E,K02040100E0FNF81E,O0101007FMF83E,K03F80100A03F80L03C,K03FC0100E03FC0L07C,K0H2C0100181FF0L0F8,K062401003C07FF880I0F0,K062401003E07FHFA0H01F0,K062C01001F01FHFA0H03E0,K0238010H0F807FF90H07C0,L030010H0FC03FFA0H0FC0,O010H07E003F8001F,K03FFC10H03F0H070H03F,K07FFC10H01FC0K0FE,O010I07F0J03F8,L060010I03FC0I0HF0,K01F8010I01FFC00FFC0,K038C010J03FKF80,K030C010J01FJFE,K020H010K03FIF0,O010M07C,,::::::::::::::::::::::::::::";
                    ZPLString +="^FT40,700^XG000.GRF,1,1^FS";
                    ZPLString +="^PQ1,0,1,Y";
            	}else{
                	if(ObjUtils.getSafeString(param.get("KS_GUBUN")).equals("2")){ //  KS
                		
                		/* 20180529 box  최종본*/
                        
                        ZPLString +="~DG000.GRF,02048,016,";
                        ZPLString +=",:::::::::::::::::::::::::::::::::U0C,T07FFE,R0807FHF80,Q07807FIF0,P01F807FIFC,P07F807FJF80,P0HF807FJF80,O03FF807FJFE0,O0IF807FKF8,N01FHF807FKFC,N03FHF807F81FIF,N07FHF807F80FIF,N0IFC007F800FHFC0,M01FHF8007F800FHFC0,M03FFE0H07F8001FFE0,M07FFC0H07F8001FFE0,M07FF0I07F80H07FF8,L01FFE0I07F80H01FFC,L01FFC0I07F80H01FFC,L03FF80I07F80I0HFE,L03FF0J07F80I07FE,L03FF0J07F80I03FF,L07FE0J07F80I03FF,L0HFC0J07F80I01FF80,L0HF80R0HFC0,:K01FF0S07FC0,K01FF0S03FC0,K03FE0S03FE0,:K03FE007FNF801FF0,:K07FC007FNF801FF0,:K07F8007FNF800FF0,K0HF8007FNF800FF8,::K0HF80J07FF0L07F8,K0HF80J03FFC0K07F8,K0HF80J01FFE0K07F8,K0HF80K07FF0K07F8,K0HF80K03FFC0J07F8,K0HF80K07FFE0J07F8,K0HF80J01FIFK0HF8,K0HF80J07FIF80I0HF8,K07F80I03FJFE0I0HF0,K07F80I0MFJ0HF0,K07FC0H03FIF7FF8001FF0,K07FC001FIF81FFE001FF0,K03FC007FIFH0IFH01FF0,K03FE007FHF8007FF001FF0,K03FE007FFE0H01FF001FF0,K03FE007FF0J0HFH03FE0,K03FF007FE0J07F003FE0,K01FF007F0K03F007FC0,K01FF007C0L0F007FC0,L0HF8070M0700FFC0,L0HFC0O0101FF80,L07FC0J07F80I01FF,L03FF0J07F80I03FF,:L03FF80I07F80I0HFE,L01FFC0I07F80I0HFE,L01FFE0I07F80H01FFC,M07FF0I07F80H07FF8,M07FF80H07F80H0IF0,M03FFE0H07F8001FFE0,M01FHFI07F8007FFE0,N0IFC007F800FHFC0,N0IFE007F803FHF80,N03FHFC07F807FHF,N03FIF07F807FFE,O0MF807FF8,O03FKF807FE0,O01FKF807FE0,P07FJF807F80,P03FJF807E,Q07FIF8070,Q03FIF8060,R03FHF80,S07FF80,,:::::::::::";
                        ZPLString +="^FT40,645^XG000.GRF,1,1^FS";
                        ZPLString +="^PQ1,0,1,Y";
             
                        ZPLString +="^FO110,645^A1R,25,25^FD"+ksMarkRef2+"^FS";
                        ZPLString +="^FO85,645^A1R,25,25^FD"+ksMarkRef3+"^FS";
                        ZPLString +="^FO60,645^A1R,25,25^FD"+ksMarkRef4+"^FS";   
                        
            			
            			
            		}
                }
                
                ZPLString +="^XZ";
                
            }
            
            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            byte[] dataTest = ZPLString.getBytes("EUC-KR"); 
            outToServer.write(dataTest);
        }
        
        

        clientSocket.close();
        
        
        
        
        rtnV = "Y";
        
        return rtnV;
    } 
    /**
     * KS 마크 구분 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkMarkGubun(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkMarkGubun", param);
        
    }
    /**
     * KS 마크 REF정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkMarkRef(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkMarkRef", param);
        
    }
    /**
     * 라벨프리트 ip정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkIpAddr(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkIpAddr", param);
        
    }
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void insertSerialNo(Map param) throws Exception {

        Map checkSerialNo = (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkSerialNo", param);
        if(ObjUtils.isEmpty(checkSerialNo)){
            super.commonDao.insert("bpr811rkrvServiceImpl.insertSerialNo", param);
            
        }
        return;
    } 
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void updateSerialNo(Map param) throws Exception {

        super.commonDao.update("bpr811rkrvServiceImpl.updateSerialNo", param);
          
        return;
    } 
    /**
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkSerialNo(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr811rkrvServiceImpl.checkSerialNo", param);
        
    }
}
