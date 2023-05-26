package foren.unilite.modules.z_yp;

import java.io.DataOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.PrintServiceAttribute;
import javax.print.attribute.standard.PrinterName;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_pmp111ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmp111ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  구매품 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	public List<Map<String, Object>> selectList(Map param) throws Exception {

		return super.commonDao.list("s_pmp111ukrv_ypServiceImpl.selectList", param);
	}








	/**
	 * 배송분류표 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeDeliLabel(Map param) throws Exception {
		List rtnList					= new ArrayList();
		String orderNumList[]			= ((String) param.get("ORDER_NUM")).split(",");;
        List<Map> serNoList             = (List<Map>) param.get("SER_NO");
        List<Map> prodtYearList             = (List<Map>) param.get("PRODT_YEAR");

		int i = 0;
		for (String orderNum : orderNumList) {
			param.put("ORDER_NUM"	, orderNum);
            param.put("SER_NO"      , serNoList.get(i));
            param.put("PRODT_YEAR"      , prodtYearList.get(i));
			rtnList.add(super.commonDao.list("s_pmp111ukrv_ypServiceImpl.makeDeliLabel", param));
			i++;
		}
		return rtnList;
	}

	/**
	 * 배송분류표 라벨 출력(New)
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeDeliLabelNew(Map param) throws Exception {
		List rtnList					= new ArrayList();
		try{
				String orderNumList[]			= ((String) param.get("ORDER_NUM")).split(",");
		        List<Map> serNoList             = (List<Map>) param.get("SER_NO");
		        List<Map> prodtYearList             = (List<Map>) param.get("PRODT_YEAR");
		        List<Map> deliLabelqList             = (List<Map>) param.get("DELI_LABEL_Q");
		        List<Map> packQtyList             = (List<Map>) param.get("PACK_QTY");
		        String expDateArray[]             =   ((String)  param.get("EXP_DATE")).split(",");;

		        Map<String, Object> tempParam0 = new HashMap<String, Object>();
		        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
		        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));

		        String ipAdr = "";
		        int port = 0;
		        port = 6101;
		        Map tempMap0 =this.checkIpAddr(tempParam0);
		        ipAdr = ObjUtils.getSafeString(tempMap0.get("DELI_IP_ADDR"));		//IP정보
		        logger.debug("[[배송분류표 당당자 IP]]" + ipAdr);
		        logger.debug("[[orderNumListLength]]" + orderNumList.length);
		        logger.debug("[[expDateList]]" + expDateArray);
		        Socket clientSocket = new Socket(ipAdr,port);
		        String ZPLString = "";

				int i = 0;
				double packQty = 0;
				int labelQ = 0;
				double remainQ = 0;
				double qtyPerBox	= 0;
				String qtyPerBoxStr = "";
				String extDate = "";

				for (String orderNum : orderNumList) {
					  logger.debug("[[orderNum]]" + orderNum);
					param.put("ORDER_NUM"	, orderNum);
		            param.put("SER_NO"      , serNoList.get(i));
		            param.put("PRODT_YEAR"      , prodtYearList.get(i));
		            List<Map> rtnList1 = super.commonDao.list("s_pmp111ukrv_ypServiceImpl.makeDeliLabel", param);
		            for(Map map : rtnList1  ){
		            	if(orderNum.equals((String) map.get("ORDER_NUM")) && ObjUtils.parseInt(serNoList.get(i)) ==  ObjUtils.parseInt(map.get("SER_NO"))){
		            		packQty =  ObjUtils.parseDouble(packQtyList.get(i));
		            		labelQ =  ObjUtils.parseInt(deliLabelqList.get(i));
		            		extDate = expDateArray[i];
		            		extDate = extDate.substring(0,4) + "." +  extDate.substring(4,6) + "." + extDate.substring(6,8);
		            	}

		            	logger.debug("[[extDate]]" + extDate);
		            	remainQ =ObjUtils.parseDouble(map.get("ORDER_Q"));
		            	for(int j=0; j<labelQ; j++){

		            		if(remainQ / packQty >= 1){
		            			qtyPerBox = packQty;
		            			remainQ = remainQ - packQty;
		            			//qtyPerBoxStr = ObjUtils.getSafeString(qtyPerBox);
		            			qtyPerBoxStr = String.format("%.2f", qtyPerBox) ;

		            		}else{

		            			qtyPerBox = remainQ % packQty ;
		            			qtyPerBox = Math.round(qtyPerBox * 100d) / 100d;  //소수 둘째자리 반올림
		            			qtyPerBoxStr = String.format("%.2f", qtyPerBox) ;
		            		}

		            		ZPLString = "^XA^LH0,0^XZ";
				      	    ZPLString += "^XA^LT0^XZ";
				            ZPLString += "^XA";
				            ZPLString += "^SEE:UHANGUL.DAT^FS";
				            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
				            //ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
				            ZPLString += "^CW1,E:MALGUNBD.TTF^CI28^FS";	//맑은고딕 볼드
				            ZPLString +="^PW800";

				            ZPLString +="^FO168,80^A1N,36,36^FD" +map.get("CUSTOM_NAME")+"^FS";
				            ZPLString +="^FO168,132^A1N,36,36^FD" +map.get("ITEM_NAME")+"^FS";
				            ZPLString +="^FO168,184^A1N,36,36^FD" +map.get("SPEC")+"^FS";
				            ZPLString +="^FO168,240^A1N,36,36^FD" +  qtyPerBoxStr +"^FS";
				            ZPLString +="^FO696,240^A1N,36,36^FD" +(j+1) + '/' + labelQ +"^FS";
				            ZPLString +="^FO168,293^A1N,36,36^FD" + map.get("DELIVERY_DATE")+ "^FS";
				            ZPLString +="^FO560,293^A1N,36,36^FD" + map.get("ORDER_DATE")+ "^FS";
				            ZPLString +="^FO168,349^A1N,36,36^FD" + map.get("PACK_DATE")+ "^FS";
				            ZPLString +="^FO560,349^A1N,36,36^FD" + map.get("STORAGE_METHOD")+ "^FS";
				            //ZPLString +="^FO560,349^A1N,36,36^FD" + "10℃이하"+ "^FS";
				            ZPLString +="^FO168,405^A1N,29,29^FD" + extDate + "^FS";
				            ZPLString +="^FO560,405^A1N,36,36^FD" + map.get("CAR_NUMBER")+ "^FS";
				            ZPLString +="^FO150,460^A1N,29,29^FD" + map.get("ORIGIN")+ "^FS";
				            ZPLString +="^FO420,456^A1N,36,36^FD" + map.get("PRODT_YEAR")+ "^FS";
				            ZPLString +="^FO688,456^A1N,36,36^FD" + map.get("QUALITY_GRADE")+ "^FS";
				            ZPLString +="^FO168,510^A1N,36,36^FD" + map.get("SUPPLIER")+ "^FS";
				            ZPLString +="^FO168,590^A1N,36,36^FD" + map.get("PRE_WORK_DATE")+ "^FS";

					        ZPLString +="^XZ";
					        logger.debug("[[ZPL]]" + ZPLString);
			               DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
			               //byte[] printData = ZPLString.getBytes("EUC-KR");
			               byte[] printData = ZPLString.getBytes("UTF-8");
			               outToServer.write(printData);
		            	}

		            }

					i++;
				}
				clientSocket.close();
				rtnList.add("SUCCESS") ;
		} catch(Exception e){
			e.printStackTrace();
		}

		 return "SUCCESS";
	}


	/**
	 * 친환경(green01) 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGr01Label(Map param) throws Exception {
		List rtnList					= new ArrayList();
		String orderNumList[]			= ((String) param.get("ORDER_NUM")).split(",");;
		List<Map> serNoList				= (List<Map>) param.get("SER_NO");
		List<Map> lotNoList				= (List<Map>) param.get("LOT_NO");
        List<Map> prodtYearList             = (List<Map>) param.get("PRODT_YEAR");

		int i = 0;
		for (String orderNum : orderNumList) {
			param.put("ORDER_NUM"	, orderNum);
			param.put("SER_NO"		, serNoList.get(i));
			param.put("LOT_NO"		, lotNoList.get(i));
            param.put("PRODT_YEAR"      , prodtYearList.get(i));
			rtnList.add(super.commonDao.list("s_pmp111ukrv_ypServiceImpl.makeGr01Label", param));
			i++;
		}
		return rtnList;
	}



	/**
	 * 친환경(green01) 라벨 출력_New
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeGr01LabelNew(Map param) throws Exception {
		List rtnList					= new ArrayList();
		String orderNumList[]			= ((String) param.get("ORDER_NUM")).split(",");;
		List<Map> serNoList				= (List<Map>) param.get("SER_NO");
		List<Map> lotNoList				= (List<Map>) param.get("LOT_NO");
        List<Map> prodtYearList             = (List<Map>) param.get("PRODT_YEAR");
        List<Map> gr01LabelqList             = (List<Map>) param.get("GR01_LABEL_Q");

        Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));

        String ipAdr = "";
        int port = 0;
        port = 6101;
        Map tempMap0 =this.checkIpAddr(tempParam0);
        ipAdr = ObjUtils.getSafeString(tempMap0.get("GREEN_S_IP_ADDR"));		//IP정보
        logger.debug("[[친환경 당당자 IP]]" + ipAdr);
        Socket clientSocket = new Socket(ipAdr,port);
        String ZPLString = "";

		int i = 0;
		int labelQ = 0;
		for (String orderNum : orderNumList) {
			param.put("ORDER_NUM"	, orderNum);
			param.put("SER_NO"		, serNoList.get(i));
			param.put("LOT_NO"		, lotNoList.get(i));
            param.put("PRODT_YEAR"      , prodtYearList.get(i));
            List<Map> rtnList1 =  super.commonDao.list("s_pmp111ukrv_ypServiceImpl.makeGr01Label", param);
            for(Map map : rtnList1  ){
            	labelQ = (int) map.get("LABEL_Q");
            	if(orderNum.equals((String) map.get("ORDER_NUM")) && ObjUtils.parseInt(serNoList.get(i)) ==  ObjUtils.parseInt(map.get("SER_NO"))){
            		labelQ =  ObjUtils.parseInt(gr01LabelqList.get(i));
            	}

            		for(int j=0; j<labelQ; j++){
            			ZPLString = "^XA^LH0,0^XZ";
    		      	    ZPLString += "^XA^LT0^XZ";
    		            ZPLString += "^XA";
    		            ZPLString += "^SEE:UHANGUL.DAT^FS";
    		            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
    		            ZPLString += "^CW1,E:MALGUN.TTF^CI26^FS";	//맑은고딕 볼드
    		            ZPLString +="^PW520";
    		            ZPLString +="^FO12,24^GB498,0,2,^FS";
    		            ZPLString +="^FO12,24^GB0,498,2,^FS";
    		            ZPLString +="^FO508,24^GB0,498,2,^FS";
    		            ZPLString +="^FO180,88^GB0,304,2,^FS";
    		            ZPLString +="^FO12,518^GB498,0,2,^FS";
    		            ZPLString +="^FO12,88^GB498,0,2,^FS";
    		            ZPLString +="^FO12,392^GB498,0,2,^FS";
    		            ZPLString +="^FO80,43^A1N,32,32^FD"+ "친환경농산물 표시사항"+"^FS";
    		            ZPLString +="^FO196,108^A1N,17,17^FD"+ "취 급 자 : "+"^FS" +  "^FO280,108^A1N,21,21^FD" +map.get("COMP_NAME")+"^FS";
    		            ZPLString +="^FO196,140^A1N,17,17^FD"+ "인증번호 : "+"^FS" +  "^FO280,140^A1N,21,21^FD" +map.get("COMP_CERF_CODE")+"^FS";
    		            ZPLString +="^FO196,172^A1N,17,17^FD"+ "전화번호 : "+"^FS" +  "^FO280,172^A1N,21,21^FD" +map.get("TELEPHON")+"^FS";
    		            ZPLString +="^FO196,204^A1N,17,17^FD"+"작업장주소:"+"^FS";
    		            ZPLString +="^FO196,225^A1N,17,17^FD"+map.get("ADDR")+"^FS";
    		            ZPLString +="^FO196,257^A1N,17,17^FD"+"품      목 : "+"^FS" +  "^FO280,257^A1N,21,21^FD" +map.get("ITEM_NAME")+"^FS";
    		            ZPLString +="^FO196,289^A1N,17,17^FD"+"산      지 : "+"^FS" +  "^FO280,289^A1N,21,21^FD" +map.get("PRODT_PERSON")+"^FS";
    		            ZPLString +="^FO196,321^A1N,17,17^FD"+"생산연도 : "+"^FS" +  "^FO280,321^A1N,21,21^FD" +map.get("PRODT_YEAR")+"^FS";
    		            ZPLString +="^FO196,353^A1N,17,17^FD"+"무게/개수: "+"^FS" +  "^FO280,353^A1N,21,21^FD" +map.get("SALE_UNIT")+"^FS";
    		            ZPLString +="^FO24,278^A1N,17,17^FD"+map.get("CENTER")+"^FS";
    		            ZPLString +="^FO24,340^A1N,21,21^FD"+map.get("CUSTOM_NAME")+"^FS";
    		            ZPLString +="^FO127,412^B3N,N,50^FD"+map.get("BARCODE")+"^FS";
    		            ZPLString +="^FO80,496^A1N,23,23^FD"+map.get("MANAGE_NO")+"^FS";
    			        ZPLString +="^XZ";
    			        logger.debug("[[ZPL]]" + ZPLString);
    	                DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
    	                byte[] printData = ZPLString.getBytes("EUC-KR");
    	                outToServer.write(printData);
            		}

            }

			i++;
		}
		  clientSocket.close();
		   return "SUCCESS";
	}

	/**
	 * 친환경(green01) 라벨 출력_New_USB(테스트 필요!!)
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGr01LabelNewLocal(Map param) throws Exception {
		List rtnList					= new ArrayList();
		String orderNumList[]			= ((String) param.get("ORDER_NUM")).split(",");;
		List<Map> serNoList				= (List<Map>) param.get("SER_NO");
		List<Map> lotNoList				= (List<Map>) param.get("LOT_NO");
        List<Map> prodtYearList             = (List<Map>) param.get("PRODT_YEAR");


        PrintService psZebra = null;
        String sPrinterName = null;
        String printerName = "zdesigner zt410-203dpi zpl";

        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        for (int i = 0; i < services.length; i++) {
            PrintServiceAttribute attr = services[i].getAttribute(PrinterName.class);
            sPrinterName = ((PrinterName) attr).getValue();
            logger.debug("[[LOCAL에 설치된 프린터명]]" + sPrinterName.toLowerCase());
            if (sPrinterName.indexOf(printerName) >= 0) {
             psZebra = services[i];
             break;
            }
           }

           if (psZebra == null) {
        	   throw new Exception();
           }

        String ZPLString = "";
		int i = 0;
		for (String orderNum : orderNumList) {
			param.put("ORDER_NUM"	, orderNum);
			param.put("SER_NO"		, serNoList.get(i));
			param.put("LOT_NO"		, lotNoList.get(i));
            param.put("PRODT_YEAR"      , prodtYearList.get(i));
            List<Map> rtnList1 =  super.commonDao.list("s_pmp111ukrv_ypServiceImpl.makeGr01Label", param);
            for(Map map : rtnList1  ){

              	  ZPLString += "";

                  logger.debug("[[ZPLString]]" + ZPLString );
                  DocPrintJob job = psZebra.createPrintJob();

                  byte[] by = ZPLString.getBytes("EUC-KR");
                  DocFlavor flavor = DocFlavor.BYTE_ARRAY.AUTOSENSE;
                  Doc doc = new SimpleDoc(by, flavor, null);
                  job.print(doc, null);

            }

			i++;
		}

		return rtnList;
	}

	/**
	 * 라벨출력 후, 해당 데이터 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savePrintedData(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("savePrinted")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.savePrinted(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	private void savePrinted( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
//		try {
			Map checkSrq100t = new HashMap();
			for(Map param :paramList )	{
				logger.debug("[[param]]" + param);
			    if(param.get("IS_DEL_REC").equals("N")){//작지 등록일시..
			    	checkSrq100t = (Map) super.commonDao.select("s_pmp111ukrv_ypServiceImpl.savePrinted", param);

			    /*	String errorDesc = ObjUtils.getSafeString(checkSrq100t.get("COUNT"));
					if(!"0".equals(errorDesc))	{
						throw new  UniDirectValidateException("출고정보가 존재하는 데이터는 수정할 수 없습니다.");
					}*/

			    } else{//삭제일 경우
			    	//출하지시등록 여부 확인
					/*checkSrq100t = (Map) super.commonDao.select("s_pmp111ukrv_ypServiceImpl.checkBeforeDelete", param);

					String errorDesc = ObjUtils.getSafeString(checkSrq100t.get("COUNT"));
					if(!"0".equals(errorDesc))	{
						throw new  UniDirectValidateException("출하지시등록 된 데이터는 삭제할 수 없습니다.");
					}*/

			        super.commonDao.delete("s_pmp111ukrv_ypServiceImpl.delPrinted", param);
			        if(param.get("SRQ100T_DEL").equals("Y")){
			        	super.commonDao.delete("s_pmp111ukrv_ypServiceImpl.delSrq100t", param);
			        }
			    }
			}
//		} catch(Exception e){
//			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n관리자에게 문의 하세요.");
//		}
		return;
	}

	  /**
     * 라벨프리트 ip정보 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public Map checkIpAddr(Map param) throws Exception {

        return (Map) super.commonDao.select("s_pmp111ukrv_ypServiceImpl.checkIpAddr", param);

    }

    /**
	 *
	 * print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> greenLabelClipPrintList(Map param) throws Exception {
		return super.commonDao.list("s_pmp111ukrv_ypServiceImpl.greenLabelClipPrintList", param);
	}

	 /**
	 *
	 * print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> deliveryLabelClipPrintList(Map param) throws Exception {
		return super.commonDao.list("s_pmp111ukrv_ypServiceImpl.deliveryLabelClipPrintList",param);
	}
	 /**
	 *
	 * print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int insertLogDetails(Map param) throws Exception {

		int retVal = super.commonDao.update("s_pmp111ukrv_ypServiceImpl.insertDeliveryLabelTemp", param);

		return retVal;
	}
}
