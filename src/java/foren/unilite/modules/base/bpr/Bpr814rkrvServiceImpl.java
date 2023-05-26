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

@Service("bpr814rkrvService")
public class Bpr814rkrvServiceImpl extends TlabAbstractServiceImpl {
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
        
        return super.commonDao.list("bpr814rkrvServiceImpl.referenceInfo", param);
        
    }


    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void insertSerialNo(Map param) throws Exception {

        Map checkSerialNo = (Map) super.commonDao.select("bpr814rkrvServiceImpl.checkSerialNo", param);
        if(ObjUtils.isEmpty(checkSerialNo)){
            super.commonDao.insert("bpr814rkrvServiceImpl.insertSerialNo", param);
            
        }
        return;
    } 
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void updateSerialNo(Map param) throws Exception {

        super.commonDao.update("bpr814rkrvServiceImpl.updateSerialNo", param);
          
        return;
    } 
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")       
    public Map checkSerialNo(Map param) throws Exception {    
        
        return (Map) super.commonDao.select("bpr814rkrvServiceImpl.checkSerialNo", param);
        
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
//        tempParam0.put("LABEL_GUBUN", "2");
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
        String barcode = "";
        
        
        itemName = ObjUtils.getSafeString(param.get("ITEM_NAME"));
        itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE"));
        spec = ObjUtils.getSafeString(param.get("SPEC"));

//      lotNo = today.substring(2,8);
        lotNo = ObjUtils.getSafeString(param.get("LOT_NO"));
        
      
        String sN = "";	
        
        Socket clientSocket = new Socket(ipAdr,port);
        
        for(int i=0; i<cnt; i++) {
            barcode = itemCode + lotNo + String.format("%05d",readSerialNo+1+i);
       

        	sN = String.format("%05d",readSerialNo+1+i);
            
            /* 20180530 원자재출력 최종 */
//        	ZPLString = "^XA^LH0,0^XZ";
//    		ZPLString += "^XA^LT0^XZ";
            
//            ZPLString += "^XA";
//    		ZPLString += "^XA";
//    		ZPLString += "^CW1,ANMDJ.TTF^CI16^FO100,50^A1,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^XZ";
//    		ZPLString += "^XA";
//    		ZPLString += "^CWK,E:KFONT3.TTF^CI16^FO100,100^A1,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^XZ";

//    		ZPLString += "^XA^FWR";
//    		ZPLString += "^SEE:UHANGUL.DAT^FS";
//    		ZPLString += "^SEE:^CWK,E:COREFONT.TTF^CI28^FS^FO100,100^A1,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^XZ";
//    		ZPLString += "^XA";
//    		ZPLString += "^FO100,150^A1,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^XZ";
    		
//    		ZPLString += "^XA";
//    		ZPLString += "^SEE:^CW1,E:COREFONT.TTF^CI28^FS";
//    		ZPLString += "^SEE:^CW2,E:KFONT3.TTF^CI28^FS";
//    		ZPLString += "^FO100,100^A1N,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^FO100,150^A2N,30,30^FD ENGLISH/한국어^FS";
//    		ZPLString += "^XZ";
    		
//    		ZPLString += "^XA";
//    		ZPLString += "^BY2,2.0^FS";
//    		ZPLString += "^SEE:UHANGUL.DAT^FS";
//    		ZPLString += "^CW1,E:KFONT3.FNT^CI26^FS";
//    		ZPLString += "^FO50,50^A0,40,40^FDChang Sung^FS";
//    		ZPLString += "^FO50,100^A0,40,40^FD02) 597-5972^FS";
//    		ZPLString += "^FO50,150^B3N,N,50,Y^FD5975972^FS";
//    		ZPLString += "^FO50,250^A1N,30,30^FD한글영문한자출력^FS";
//    		ZPLString += "^FO50,300^A1N,50,50^FD한글영문한자출력^FS";
//    		ZPLString += "^PQ2,1,1,Y^FS";
//    		ZPLString += "^XZ";

    		
    		ZPLString = "^XA";
            ZPLString += "^SEE:UHANGUL.DAT^FS";
//    		ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
            ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
            ZPLString +="^PW550";		//라벨 가로 크기관련
            ZPLString += "^LH0,0^FS";
            ZPLString += "^LT0^FS";
        	ZPLString +="^FO50,30^A1N,25,25^FD"+"Item"+"^FS";
        	ZPLString +="^FO180,30^A1N,25,25^FD"+itemName+"^FS";

            ZPLString +="^FO50,64^A1N,25,25^FD"+"Code"+"^FS";
            ZPLString +="^FO180,64^A1N,25,25^FD"+itemCode+"^FS";

            ZPLString +="^FO50,93^A1N,25,25^FD"+"Spec"+"^FS";
            ZPLString +="^FO180,93^A1N,25,25^FD"+spec+"^FS";

            ZPLString +="^FO45,127^A1N,25,25^FD"+"Lot No"+"^FS";
            ZPLString +="^FO180,127^A1N,25,25^FD"+itemCode+lotNo+sN+"^FS";

//            ZPLString +="^BY1,3.0,45^FO140,165^BCN,45,N,N,^FD"+barcode+"^FS";   //code128
            
//            ZPLString +="^BY2,3.0,45^FO45,165^BCN,45,N,N,^FD"+barcode+"^FS";
            
//            ZPLString +="^BY2,2.0,45^FO45,165^BCN,45,N,N,^FD"+barcode+"^FS";

          ZPLString +="^BY1,3.0,45^FO95,165^B3N,45,N,N,^FD"+barcode+"^FS";    //code39
          
//          ZPLString +="^BY2,3.0,45^FO45,165^B1N,45,N,N,^FD"+barcode+"^FS";   //code11
            
            
//            ZPLString +="^BY2,3.0,40^FO80,165^B3N,N,40,N,N^FD"+"151-014A180403001"+"^FS";
//          ZPLString +="^BY1,3.0,45^FO30,165^BCN,45,N,N,^FD"+"151-014A180403001"+"^FS";
//            ZPLString +="^BY2,3.0,45^FO30,165^BCN,45,N,N,^FD"+"151-014Axxx180403001"+"^FS";
            //11자리 itemCode 가 있고  12자리 itemCode 는 자리가 안맞을듯.. 확인필요 
//            barcode
            
            
//            ^BC
//            Code 128 Bar Code (Subsets A, B, and C)
//            Description The ^BC command creates the Code 128 bar code, a high-density,
//            variable length, continuous, alphanumeric symbology. It was designed for complexly
//            encoded product identification.
//            Code 128 has three subsets of characters. There are 106 encoded printing characters in
//            each set, and each character can have up to three different meanings, depending on the
//            character subset being used. Each Code 128 character consists of six elements: three
//            bars and three spaces.
//             ^BC supports a fixed print ratio.
//             Field data (^FD) is limited to the width (or length, if rotated) of the label.
//            Format ^BCo,h,f,g,e,m
//            This table identifies the parameters for this format:
//            ! Important  If additional information about the Code 128 bar code is required, see
//            ZPL Programming Guide Volume Two for AIM, Inc. contact information.
//            Parameters Details
//            o = orientation Accepted Values:
//            N = normal
//            R = rotated 90 degrees (clockwise)
//            I = inverted 180 degrees
//            B = read from bottom up, 270 degrees
//            Default Value: current ^FW value
//            h = bar code height
//            (in dots)
//            Accepted Values: 1 to 32000
//            Default Value: value set by ^BY
//            f = print
//            interpretation line
//            Accepted Values: Y (yes) or N (no)
//            Default Value: Y
//            The interpretation line can be printed in any font by placing the
//            font command before the bar code command.
//            g = print
//            interpretation line
//            above code
//            Accepted Values: Y (yes) or N (no)
//            Default Value: N
//            e = UCC check digit Accepted Values: Y (yes) or N (no)
//            Default Value: N
//            m = mode Accepted Values:
//            N = no selected mode
//            U = UCC Case Mode
//            A = Automatic Mode. This analyzes the data sent and
//            automatically determines the best packing method. The full
//            ASCII character set can be used in the ^FD statement  the
//            printer determines when to shift subsets. A string of four or
//            more numeric digits cause an automatic shift to Subset C.
//            Default Value: N
//            d = insert data
//            
            
            
            
            
            
            
            
            
            
            
            
            
            
//            ^BY
//            Bar Code Field Default
//            Description The ^BY command is used to change the default values for the module
//            width (in dots), the wide bar to narrow bar width ratio and the bar code height (in
//            dots). It can be used as often as necessary within a label format.
            
//            Format ^BYw,r,h
//            This table identifies the parameters for this format:
//            For parameter r, the actual ratio generated is a function of the number of dots in
//            parameter w, module width. See the table on the next page.
//            Parameters Details
            
//            w = module width
//            (in dots)
//            Accepted Values: 1 to 10
//            Initial Value at power-up: 2
            
//            r = wide bar to
//            narrow bar width
//            ratio
//            Accepted Values: 2.0 to 3.0, in 0.1 increments
//            This parameter has no effect on fixed-ratio bar codes.
            
//            h = bar code height
//            (in dots)
//            Accepted Values: 2.0 to 3.0, in 0.1 increments
//            Initial Value at power-up: 10
//            Example  Set module width (w) to 9 and the ratio (r) to 2.4. The width of the
//            narrow bar is 9 dots wide and the wide bar is 9 by 2.4, or 21.6 dots. However, since
//            the printer rounds out to the nearest dot, the wide bar is actually printed at 22 dots.
//            This produces a bar code with a ratio of 2.44 (22 divided by 9). This ratio is as close
//            to 2.4 as possible, since only full dots are printed.           
            
            
            
            
//            ^B3
//            Code 39 Bar Code
            
//          ^B3o,e,h,f,g
            
//          o = orientation Accepted Values:
//        	N = normal
//        	R = rotated 90 degrees (clockwise)
//        	I = inverted 180 degrees
//        	B = read from bottom up, 270 degrees
//        	Default Value: current ^FW value
            
//        	e = Mod-43 check
//        	digit
//        	Accepted Values: Y (yes) or N (no)
//        	Default Value: N
            
//        	h = bar code height
//        	(in dots)
//        	Accepted Values: 1 to 32000
//        	Default Value: value set by ^BY
            
//        	f = print
//        	interpretation line
//        	Accepted Values: Y (yes) or N (no)
//        	Default Value: Y
            
//        	g = print
//        	interpretation line
//        	above code
//        	Accepted Values: Y (yes) or N (no)
//        	Default Value: N
        	
        	
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
        
        return (Map) super.commonDao.select("bpr814rkrvServiceImpl.checkIpAddr", param);
        
    }
}
