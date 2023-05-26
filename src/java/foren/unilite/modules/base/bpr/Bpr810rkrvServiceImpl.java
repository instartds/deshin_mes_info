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

@Service("bpr810rkrvService")
public class Bpr810rkrvServiceImpl extends TlabAbstractServiceImpl {
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

        return super.commonDao.list("bpr810rkrvServiceImpl.referenceInfo", param);

    }



    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void insertSerialNo(Map param) throws Exception {

        Map checkSerialNo = (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkSerialNo", param);
        if(ObjUtils.isEmpty(checkSerialNo)){
            super.commonDao.insert("bpr810rkrvServiceImpl.insertSerialNo", param);

        }
        return;
    }


    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void updateSerialNo(Map param) throws Exception {

        super.commonDao.update("bpr810rkrvServiceImpl.updateSerialNo", param);

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

        return (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkSerialNo", param);

    }





    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
    public void updatePMR110T(Map param) throws Exception {

        super.commonDao.update("bpr810rkrvServiceImpl.updatePMR110T", param);

        return;
    }



    /**
     * Z001 KS마크 이름 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public Map checkKsmarkName(Map param) throws Exception {

        return (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkKsmarkName", param);

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




	        /**
	         * 재발행이 아닐시
	         * 해당 PMR110T  UPDATE
	         * FR_SERIAL_NO 시리얼(FR)
	         * TO_SERIAL_NO 시리얼(TO)
	         * TEMPC_01     출력여부
	         *
	         */
	        int frSerialNo = 0;

	        frSerialNo = readSerialNo + 1;


	        String frSerialNoFormatChange = "";
	        frSerialNoFormatChange = String.format("%05d",frSerialNo);
	        String toSerialNoFormatChange = "";
	        toSerialNoFormatChange = String.format("%05d",saveSerialNo);


	        Map<String, Object> tempParam2 = new HashMap<String, Object>();

	        tempParam2.put("S_COMP_CODE", param.get("S_COMP_CODE"));
	        tempParam2.put("DIV_CODE", param.get("DIV_CODE"));
	        tempParam2.put("S_USER_ID", param.get("S_USER_ID"));
	        tempParam2.put("PRODT_NUM", param.get("PRODT_NUM"));


	        tempParam2.put("FR_SERIAL_NO", today.substring(2,4)+frSerialNoFormatChange);
	        tempParam2.put("TO_SERIAL_NO", today.substring(2,4)+toSerialNoFormatChange);
	        tempParam2.put("PRINT_YN", "Y");

	        this.updatePMR110T(tempParam2);


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

        /*if(ObjUtils.getSafeString(param.get("SIZE")).equals("3")){
        	tempParam0.put("LABEL_GUBUN", "3");	//tr라벨프린트
        }else{
        	tempParam0.put("LABEL_GUBUN", "1");//제품라벨프린트 (대, 소)
        }*/
        Map tempMap0 =this.checkIpAddr(tempParam0);
        ipAdr = ObjUtils.getSafeString(tempMap0.get("IP_ADDR"));		//IP정보
        port = 6101;

        int cnt = 0;


        cnt = ObjUtils.parseInt(param.get("CNT"));

        String itemName = "";
        String itemCode = "";
        String spec = "";
        String type = "";
        String lotNo = "";
        String DataMatrix = "";

        String ksMarkGubun = "";
        String ksMarkName = "";


        itemName = ObjUtils.getSafeString(param.get("ITEM_NAME"));
        itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE"));
        spec = ObjUtils.getSafeString(param.get("SPEC"));
        type = ObjUtils.getSafeString(param.get("TYPE"));
//        lotNo = today.substring(2,8);
        lotNo = ObjUtils.getSafeString(param.get("LOT_NO"));

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
            sN = lotNo.substring(0,2) + String.format("%05d",readSerialNo+1+i);
            if(ObjUtils.getSafeString(param.get("SIZE")).equals("1")){      // 대

                /* 20180529 대 최종본*/
//            	ZPLString = "^XA^LH0,0^XZ";
//            	ZPLString += "^XA^LT0^XZ";

                ZPLString = "^XA";
                ZPLString += "^SEE:UHANGUL.DAT^FS";
//        		ZPLString += "^CW1,E:MALGUNSL.TTF^CI28^FS";  //맑은고딕 슬림  	 ^CI28	UTF-8 용
//                ZPLString += "^CW1,E:MALGUN.TTF^CI28^FS";	 //맑은고딕
//                ZPLString += "^CW1,E:MALGUNBD.TTF^CI28^FS";	//맑은고딕 볼드

//        		ZPLString += "^CW1,E:MALGUNSL.TTF^CI26^FS";  //맑은고딕 슬림	   ^CI26	EUC-KR 용
//                ZPLString += "^CW1,E:MALGUN.TTF^CI26^FS";	 //맑은고딕
                ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
                ZPLString +="^PW555";		//라벨 가로 크기관련
                ZPLString += "^LH0,0^FS";
   //             ZPLString += "^LT0^FS";

     /*  글자크기  23,23*/
                /*
            	ZPLString +="^FO130,43^A1N,23,23^FD"+itemName+"^FS";

                ZPLString +="^FO130,83^A1N,23,23^FD"+itemCode+"^FS";

                ZPLString +="^FO130,123^A1N,23,23^FD"+spec+" / "+type+"^FS";

                ZPLString +="^FO130,163^A1N,23,23^FD"+lotNo+" / "+sN+"^FS";

    /*  글자크기  21,21*/
                ZPLString +="^FO130,43^A1N,21,21^FD"+itemName+"^FS";

                ZPLString +="^FO130,83^A1N,21,21^FD"+itemCode+"^FS";
if(type.equals("")){
                ZPLString +="^FO130,123^A1N,21,21^FD"+spec+"^FS";
}else{
    			ZPLString +="^FO130,123^A1N,21,21^FD"+spec+" / "+type+"^FS";
}
                ZPLString +="^FO130,163^A1N,21,21^FD"+lotNo+" / "+sN+"^FS";


                ZPLString +="^FO283,210^BXN,3,200^FD"+DataMatrix+"^FS";

            	if(etlMarkCheck.equals("true")) { //ETL

                    ZPLString  +="^FO350,195^GFA,00512,00512,00008,:Z64:";
                    ZPLString  +="eJxjYBgowPwHQvP9bwDTdcwfwPQOIAQCxgcMNmBlDS/4QDQ76192EM0lubMZpEHG9u/BA0Cap6agAURbfCg8AKYXGDYsANKGDwoPJADppAMJDSA6uaHwSAGQVm4wbDAA8f8UngPRSX8K+pD5QPkuA4j6e2D1BxJ7QPoNDxT+AdGWCwx3LIDY9wNkn8SPgg8gWqam8COI5pIwBLuPnaeQHeL+BLD7GQ8wyID918AwA0yLs0H8zdAGDRARvMHFCAT45B0YoPIKEDo2dasqyL2eagtyQO6KVFUMBNGcCoqKCiC++cK/QH8CACAXSm0=:31A8";
                    ZPLString  +="^PQ1,0,1,Y";
            	}else{
            		if(ObjUtils.getSafeString(param.get("KS_GUBUN")).equals("2")){ //  KS


                		/* 20180529 대 최종본*/
                        ZPLString +="~DG000.GRF,00768,008,";
                        ZPLString +=",::::::::::::::::::::::::J0IF0,I03FHFC,I0KF,H01FJFC0,H03FC03FC0,H0FE0H07F0,H0FC0H01F8,01F0J0F8,03E0J07C,07E0J03E,07C0J03E,07C0J01E,0F03C3FC,0F03C3F8,0F03CFE0,0F03DF80,0F03FF80,1FF3FF83FF80,1FF3FFC3FF80,1FF3FBC3FF80,1FF3E3E3FF80,I03C1F00780,I03C1F00F,I03C0F80F,I03C0780F,I03C07C0F,0780J01E,07C0J03E,:03E0J07C,01F0J0F8,H0FC0H01F8,H0FE0H07F0,H03FC03FC0,H01FJFC0,I0KF,I03FHFC,J0IF8,,::::::::::::::::::::::::::::::::";
                        ZPLString +="^FT344,285^XG000.GRF,1,1^FS";
                        ZPLString +="^PQ1,0,1,Y";

                        ZPLString +="^FO388,218^A1N,13,13^FD"+ksMarkRef2+"^FS";
                        ZPLString +="^FO388,231^A1N,13,13^FD"+ksMarkRef3+"^FS";
                        ZPLString +="^FO388,244^A1N,13,13^FD"+ksMarkRef4+"^FS";
            		}
            	}

                ZPLString +="^XZ";

            }else if(ObjUtils.getSafeString(param.get("SIZE")).equals("2")){               //소

            	/* 20180529 소 최종본 */
//                ZPLString = "^XA^LH0,0^XZ";
//                ZPLString += "^XA^LT0^XZ";
                ZPLString = "^XA";
                ZPLString += "^SEE:UHANGUL.DAT^FS";
//        		ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
//              ZPLString += "^CW1,E:MALGUN.TTF^CI26^FS";	 //맑은고딕
                ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
                ZPLString +="^PW430";
                ZPLString += "^LH0,0^FS";
//                ZPLString += "^LT0^FS";
                /* 글자 크기 20,20*/
           /* 	ZPLString +="^FO110,34^A1N,20,20^FD"+itemName+"^FS";

                ZPLString +="^FO110,64^A1N,20,20^FD"+itemCode+"^FS";

                ZPLString +="^FO110,92^A1N,20,20^FD"+spec+" / "+type+"^FS";

                ZPLString +="^FO110,122^A1N,20,20^FD"+lotNo+" / "+sN+"^FS";*/


/* 글자 크기 18,18 */
            	ZPLString +="^FO110,34^A1N,18,18^FD"+itemName+"^FS";

                ZPLString +="^FO110,64^A1N,18,18^FD"+itemCode+"^FS";
if(type.equals("")){
    			ZPLString +="^FO110,92^A1N,18,18^FD"+spec+"^FS";
}else{
                ZPLString +="^FO110,92^A1N,18,18^FD"+spec+" / "+type+"^FS";
}
                ZPLString +="^FO110,122^A1N,18,18^FD"+lotNo+" / "+sN+"^FS";

                ZPLString +="^FO210,152^BXN,3,200^FD"+DataMatrix+"^FS";


                /* 글자 크기 18,18 */
                /*            	ZPLString +="^FO110,14^A1N,18,18^FD"+itemName+"^FS";

                ZPLString +="^FO110,44^A1N,18,18^FD"+itemCode+"^FS";
if(type.equals("")){
    			ZPLString +="^FO110,72^A1N,18,18^FD"+spec+"^FS";
}else{
                ZPLString +="^FO110,72^A1N,18,18^FD"+spec+" / "+type+"^FS";
}
                ZPLString +="^FO110,102^A1N,18,18^FD"+lotNo+" / "+sN+"^FS";

                ZPLString +="^FO210,132^BXN,3,200^FD"+DataMatrix+"^FS";

   */

                if(etlMarkCheck.equals("true")) { //ETL
                    ZPLString  +="^FO265,133^GFA,00512,00512,00008,:Z64:";
                    ZPLString  +="eJxjYBgowPwHQvP9bwDTdcwfwPQOIAQCxgcMNmBlDS/4QDQ76192EM0lubMZpEHG9u/BA0Cap6agAURbfCg8AKYXGDYsANKGDwoPJADppAMJDSA6uaHwSAGQVm4wbDAA8f8UngPRSX8K+pD5QPkuA4j6e2D1BxJ7QPoNDxT+AdGWCwx3LIDY9wNkn8SPgg8gWqam8COI5pIwBLuPnaeQHeL+BLD7GQ8wyID918AwA0yLs0H8zdAGDRARvMHFCAT45B0YoPIKEDo2dasqyL2eagtyQO6KVFUMBNGcCoqKCiC++cK/QH8CACAXSm0=:31A8";
                    ZPLString  +="^PQ1,0,1,Y";
            	}else{
                	if(ObjUtils.getSafeString(param.get("KS_GUBUN")).equals("2")){ //  KS

                		/* 20180529 소 최종본 */
                        ZPLString +="~DG000.GRF,00768,008,";
                        ZPLString +=",::::::::::::::::::::::::J0IF0,I03FHFC,I0KF,H01FJFC0,H03FC03FC0,H0FE0H07F0,H0FC0H01F8,01F0J0F8,03E0J07C,07E0J03E,07C0J03E,07C0J01E,0F03C3FC,0F03C3F8,0F03CFE0,0F03DF80,0F03FF80,1FF3FF83FF80,1FF3FFC3FF80,1FF3FBC3FF80,1FF3E3E3FF80,I03C1F00780,I03C1F00F,I03C0F80F,I03C0780F,I03C07C0F,0780J01E,07C0J03E,:03E0J07C,01F0J0F8,H0FC0H01F8,H0FE0H07F0,H03FC03FC0,H01FJFC0,I0KF,I03FHFC,J0IF8,,::::::::::::::::::::::::::::::::";
                        ZPLString +="^FT265,227^XG000.GRF,1,1^FS";
                        ZPLString +="^PQ1,0,1,Y";

                        ZPLString +="^FO310,159^A1N,13,13^FD"+ksMarkRef2+"^FS";
                        ZPLString +="^FO310,172^A1N,13,13^FD"+ksMarkRef3+"^FS";
                        ZPLString +="^FO310,185^A1N,13,13^FD"+ksMarkRef4+"^FS";

            		}
                }

                ZPLString +="^XZ";


            }else{		//TR출력

                sNtr = lotNo + String.format("%05d",readSerialNo+1+i);

                /* 20180524 tr출력 최종 */
//                ZPLString = "^XA^LH0,0^XZ";
//        		ZPLString += "^XA^LT0^XZ";

                ZPLString = "^XA";
                ZPLString += "^SEE:UHANGUL.DAT^FS";
//        		ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
                ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
                ZPLString +="^PW400";
                ZPLString += "^LH0,0^FS";
                ZPLString += "^LT0^FS";

                ZPLString +="^FO15,50^BXN,4,200^FD"+DataMatrix+"^FS";
                ZPLString +="^FO95,55^A1N,23,23^FD"+itemCode+"^FS";
                ZPLString +="^FO95,95^A1N,23,23^FD"+sNtr+"^FS";



                ZPLString +="^XZ";
            }

            DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
            byte[] dataTest = ZPLString.getBytes("EUC-KR");
//            byte[] dataTest = ZPLString.getBytes("UTF-8");
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

        return (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkMarkGubun", param);

    }
    /**
     * KS 마크 REF정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public Map checkMarkRef(Map param) throws Exception {

        return (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkMarkRef", param);

    }

    /**
     * 라벨프리트 ip정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public Map checkIpAddr(Map param) throws Exception {

        return (Map) super.commonDao.select("bpr810rkrvServiceImpl.checkIpAddr", param);

    }
}
