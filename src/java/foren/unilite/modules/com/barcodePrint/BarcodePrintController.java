package foren.unilite.modules.com.barcodePrint;

import java.io.DataOutputStream;
import java.lang.reflect.Field;
import java.net.Socket;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;

@Controller
public class BarcodePrintController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/prodt/pmp/";
	
	@Resource( name = "barcodeService" )
    private BarcodeServiceImpl barcodeService;
	
	
	@RequestMapping(value = "/prodt/testbarcoderkr.do")
    public String testbarcoderkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {  };
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        param.put("S_COMP_CODE",loginVO.getCompCode());
        return JSP_PATH + "testbarcoderkr";
    }
	
	@ResponseBody
    @RequestMapping(value = "/barcode/testBarcodePrint.do")
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public String testBarcodePrint(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
	    
	    System.setProperty("file.encoding","UTF-8");

	    Field charset = Charset.class.getDeclaredField("defaultCharset");

	    charset.setAccessible(true);

	    charset.set(null,null);

        Map<String, Object> param = _req.getParameterMap();
        
	    String SuccessFlag = "N";
	    
	    
try{
    
	    String ZPLString = 
	            "^XA^LL500^LH0,0^F0300,100^BXN,10,200,,,,^FDZEBRA TECHNOLOGIES CORP>333 CORPORATE WOODS PKWYVERNON HILLS, ILLINOIS  60061-3109^FS^XZ";
	         
	    
	    /**
	     * 데이터 여러로우
	     */
	 /*   
	    List<Map<String, Object>> allDatas = barcodeService.barCodeDataSelect(param);
        
	    int tempIndex = 0; 

        String ZPLString3 = "";

        String itemName = "";
        String itemCode = "";
        String spec = "";
        String today = "";
        
        String lotNo = "";
        
        for(Map data: allDatas) {
            tempIndex = tempIndex + 1;
            
            itemName = ObjUtils.getSafeString(data.get("ITEM_NAME"));
            itemCode = ObjUtils.getSafeString(data.get("ITEM_CODE"));
            spec = ObjUtils.getSafeString(data.get("SPEC"));
            today = ObjUtils.getSafeString(data.get("TODAY"));
            
            lotNo = itemCode + today.substring(2,8);
            
            
            //int fullLen = itemCode.length()+9; 
                    

            lotNo =lotNo+ String.format("%03d",tempIndex);
            
            
            ZPLString3 = 
                    
            "@@@itemName : "+ itemName
            +"@@@itemCode : "+ itemCode
            +"@@@spec : "+ spec
            +"@@@today : "+ today
            +"@@@lotNo : "+ lotNo; //+itemCode+today+"000" + tempIndex;

            logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +ZPLString3);
        }
        */
	    
	    
	    
	    
	    
	    String receiveParam = ""; 
        if(ObjUtils.isNotEmpty(param.get("TEST_TEXT"))){

            receiveParam = ObjUtils.getSafeString(param.get("TEST_TEXT"));
        }else{
            receiveParam = "No value";
        }
	    
	    /**
	     * 갯수설정
	     */

        int cntParam = 0; 
        if(ObjUtils.isNotEmpty(param.get("CNT"))){

            cntParam = Integer.parseInt(ObjUtils.getSafeString(param.get("CNT")));
        }else{
            cntParam = 1;
        }
        
List<Map<String, Object>> allDatas = barcodeService.barCodeDataSelect(param);
        
        int tempIndex = 0; 

        String ZPLString3 = "";

        String itemName = "";
        String itemCode = "";
        String spec = "";
        String today = "";
        
        String lotNo = "";
        
        

        String ZPLString4 = "";
        
        Socket clientSocket=new Socket("192.168.1.40",6101);
        
        for(int i=0; i<cntParam; i++) {
            
            itemName = ObjUtils.getSafeString(allDatas.get(0).get("ITEM_NAME"));
            itemCode = ObjUtils.getSafeString(allDatas.get(0).get("ITEM_CODE"));
            spec = ObjUtils.getSafeString(allDatas.get(0).get("SPEC"));
            today = ObjUtils.getSafeString(allDatas.get(0).get("TODAY"));
            
            lotNo = itemCode + today.substring(2,8);
            
            lotNo =lotNo+ String.format("%03d",i+1);
            
            
            ZPLString3 = 
                    
            "@@@itemName : "+ itemName
            +"@@@itemCode : "+ itemCode
            +"@@@spec : "+ spec
            +"@@@today : "+ today
            +"@@@lotNo : "+ lotNo; //+itemCode+today+"000" + tempIndex;

            logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +ZPLString3);
            
//            ZPLString4= "^XA"
//                            +"^FO80,80^AE21,10^FD@@@itemName : "+ itemName
//                            + "@@@itemCode : "+ itemCode
//                            +"@@@spec : "+ spec
//                            +"@@@today : "+ today
//                            +"@@@lotNo : "+ lotNo
//                            +"^FS"
//                            +"^XZ";
//            
            String testStr = "";
    
                    ZPLString4= "^XA";
                    ZPLString4  +="^SEE:UHANGUL.DAT^FS" ;
                    
//                    ZPLString4 +="^CW1,E:KFONT3.FNT^CI26^FS";
                    ZPLString4 +="^CW1,E:corefont.TTF^CI26^FS";//돋음
                    

                    ZPLString4 +="^FO75,50^A1N,22,22^FDItem^FS";

                    ZPLString4 +="^FO150,50^A1N,20,20^FD"+itemName+"^FS";
                    
                    ZPLString4 +="^FO75,80^A1N,22,22^FDCode^FS";

                    ZPLString4 +="^FO150,80^A1N,20,20^FD"+itemCode+"^FS";
                    
                    ZPLString4 +="^FO75,110^A1N,22,22^FDSpec^FS";
                    
                    ZPLString4 +="^FO150,110^A1N,20,20^FD"+spec+"^FS";
                    
                    ZPLString4 +="^FO75,140^A1N,22,22^FDToday^FS";

                    ZPLString4 +="^FO150,140^A1N,20,20^FD"+today+"^FS";
                    
//                    ZPLString4 +="^FO50,150^A1N,20,20^FDLotNo          "+lotNo+"^FS";

                    ZPLString4 +="^FO75,190^BXN,4,200,,,,^FD"+lotNo+"^FS";
                    
                            
                    ZPLString4 +="^XZ";
            
            
            
     /*  테스트 ZPL     
       
            ZPLString4= "^XA";
            ZPLString4  +="^SEE:UHANGUL.DAT^FS" ;
            
//            ZPLString4 +="^CW1,E:KFONT3.FNT^CI26^FS";
            ZPLString4 +="^CW1,E:corefont.TTF^CI26^FS";//돋음
            
            ZPLString4 +="^FO50,50^AE21,10^FD@START@ABCDEFGHIJKLMNOPQRSTUVWXYZ@END@^FS";

            ZPLString4 +="^FO50,100^A1N,30,30^FD@시작@가나다라마바사아자차카타파하@끝@^FS";
            
            ZPLString4 +="^FO50,150^A1N,30,30^FD-INFORMATION-^FS";

            ZPLString4 +="^FO50,200^A1N,30,30^FD@ReceiveParam@ "+receiveParam+"^FS";
            
            ZPLString4 +="^FO50,250^A1N,30,30^FD@Item@ "+itemName+"^FS";
            ZPLString4 +="^FO50,300^A1N,30,30^FD@Code@ "+itemCode+"^FS";
            ZPLString4 +="^FO50,350^A1N,30,30^FD@Spec@ "+spec+"^FS";
            ZPLString4 +="^FO50,400^A1N,30,30^FD@Today@ "+today+"^FS";
            ZPLString4 +="^FO50,450^A1N,30,30^FD@LotNo@ "+lotNo+"^FS";
            
            ZPLString4 +="^FO50,500^BXN,10,200,,,,^FD"+lotNo+"^FS";
            
            ZPLString4 +="^FO50,800^A1N,30,30^FD@시작@가나다라마바사아자차카타파하@끝@^FS";
                    
            ZPLString4 +="^XZ";
            
            
    */
            
            
            
            logger.debug("@@@@@@@@@@@@@@테스트@@@@@@@@@@@@@:" +ZPLString4);
            
            
            
            
            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            
            byte[] dataTest = ZPLString4.getBytes("EUC-KR"); 
            
            outToServer.write(dataTest);
            
//            String aa =  new String(ZPLString4.getBytes(),"utf-8");
            
//            String aa =  ZPLString4.getBytes();
//            outToServer.write(ZPLString4.getBytes("utf-8"));
//            outToServer.writeUTF(ZPLString4);
//            outToServer.writeBytes(aa);
//            outToServer.writeUTF(aa);
          //  euc-kr
            
//            String aa = new String(ZPLString4.getBytes("euc-kr"));
//              String aa = new String(ZPLString4.getBytes("utf-8"));
//          String aa = new String(ZPLString4.getBytes("ISO-8859-1"));
//            String aa = new String(ZPLString4.getBytes("utf-8"), "ISO-8859-1");
            
//            outToServer.writeBytes(ZPLString4);
            

//            outToServer.writeBytes(ZPLString4);
            
            
        }
	    

        clientSocket.close();
	    
       /* 
        ZPLString3 = 
       
        "itemName : "+ itemName
        +"itemCode : "+ itemCode
        +"spec : "+ spec
        +"today : "+ today
        +"lotNo : "+itemCode+today+"001";
        */
/*
	    String ZPLString2 = 
	    "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
	    +"^XA"
	    +"^MMT"
	    +"^PW599"
	    +"^LL0280"
	    +"^LS0"
	    +"^FO192,192^GFA,02688,02688,00028,:Z64:"
	    +"eJztkjFqwzAYhX+LCBlPbpGdJQWTpcIX6KrQGI+1i40TaO6QgKiGdhAmheC53U0mo1P0CB2anqf20Nge2qGUksGfFsHj6b3/RwADAyfOqD7f4O91+ZsnvZ81vh5L6ZLseiMIf5Si1RCoyve1hYq8rJBivm5rGqDukvQwMYJglmC+SA/dN5XPmGWhXOcalfX1qF2OQhiLNXFJIElGhFjT1lcysMrGpzQqUMVYvyt+XWBqvL7jJ0yjuJPnmVC3a3ys9u0Y0x0NgPAmjwtCyI3Y3Pe0L1/dNa86PcG2weBNHp84OMBRdNGZz2t9Vq66Pg9zIHMpx5ILKsNAyE4eNHn1PrVizN/Xu9U9zeBOglOg9HCAyEl62qkwytIspTTIAuyG6VUs3tqeVvNjoDQLBlNkTk2vUEfNXi2drb1d2TE2guVLaj+rjg9q394sdmpqgUKQ747aWTwTc9edn4fhx8Msi+3bzX+MOTAwMPCnfALiBlu6:9F04"
	    +"^FT29,162^A0N,23,69^FH\^FDTODAY^FS"
	    +"^FT30,124^A0N,23,91^FH\^FDSPEC^FS"
	    +"^FT30,87^A0N,23,86^FH\^FDCODE^FS"
	    +"^FO23,131^GB551,0,8^FS"
	    +"^FT30,51^A0N,23,93^FH\^FDITEM^FS"
	    +"^FO23,93^GB551,0,8^FS"
	    +"^FO21,21^GB557,154,8^FS"
	    +"^FO24,57^GB551,0,8^FS"
	    +"^FO224,21^GB0,150,8^FS"
	    +"^FT235,50^A0N,21,67^FH\^FD"+ itemName  +"^FS"
	    +"^FT233,89^A0N,24,67^FH\^FD"+ itemCode  +"^FS"
	    +"^FT233,124^A0N,22,67^FH\^FD"+ spec  +"^FS"
	    +"^FT232,164^A0N,25,60^FH\^FD"+ today  +"^FS"
	    +"^BY84,84^FT30,270^BXN,6,200,0,0,1,~"
	    +"^FH\^FD"+itemCode+today+"001"+"^FS"
	    +"^PQ1,0,1,Y^XZ";
*/

//	        try
//	        {
//	            for(Map param : paramList )    {
//	                
//	            }
	            
	       /*     Socket clientSocket=new Socket("192.168.1.40",6101);
	            
	            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	            
	            outToServer.writeBytes(ZPLString);
	            
	            
	            clientSocket.close();
*/
	            
//	            System.out.println("테스트@@@@@@:" +ZPLString);

	            logger.debug("테스트@@@@@@:" +ZPLString);
	            SuccessFlag ="Y";
	        }
	        catch (Exception ex)
	        {
	            SuccessFlag = "N";
	            // Catch Exception
	        }
	    
	    return SuccessFlag;
	}
}
