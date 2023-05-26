package foren.unilite.modules.z_yp;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_pmp110ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmp110ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 생산정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectDetailList", param);
	}

	/**
	 *
	 * 자재예약(PMP200T) 조회(detailGird)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectS_PMP201T_YP(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectS_PMP201T_YP", param);
	}

	/**
	 * PMP200T 조회(detailGird2)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPMP200T(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectPMP200T", param);
	}

	/**
	 * 작업지시 조회 (팝업창)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWorkNum(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectWorkNum", param);
	}

	/**
	 * 신규 / 수주참조 시, PMP200T 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getPMP200T(Map param) throws Exception {
		logger.debug("[param]" + param);
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.getPMP200T", param);
	}

	/**
	 * 수주정보참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectSalesOrderList", param);
	}

	/**
	 * 공정정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProgInfo(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.selectProgInfo", param);
	}






	/**
	 * 작업지시 MASTER 저장 (PMP100T)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//변수 선언(공정코드)
		Map progWorkCode;										//공정코드용

		//로그테이블에 입력할 panelSearch 정보
		String divCode			= (String) dataMaster.get("DIV_CODE");
		String workShopCode		= (String) dataMaster.get("WORK_SHOP_CODE");
		String prodtWkordDate	= (String) dataMaster.get("PRODT_WKORD_DATE");
		String prodtStartDate	= (String) dataMaster.get("PRODT_START_DATE");
		String prodtEndDate		= (String) dataMaster.get("PRODT_END_DATE");

		logger.debug("[saveAll] paramDetail:" + paramList);
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//3.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 등 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");

			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

			for(Map param:	dataList) {
				param.put("KEY_VALUE"			, keyValue);
				param.put("OPR_FLAG"			, oprFlag);
				param.put("DIV_CODE"			, divCode);
				param.put("WORK_SHOP_CODE"		, workShopCode);
				param.put("PRODT_WKORD_DATE"	, prodtWkordDate);
				param.put("PRODT_START_DATE"	, prodtStartDate);
				param.put("PRODT_END_DATE"		, prodtEndDate);
				//공정코드 가져오는 로직
				progWorkCode = (Map) super.commonDao.select("s_pmp110ukrv_ypServiceImpl.getProgWorkCode", param);

				param.put("PROG_WORK_CODE"	, progWorkCode.get("PROG_WORK_CODE"));
				param.put("LINE_SEQ"		, progWorkCode.get("LINE_SEQ"));
				param.put("data"			, super.commonDao.insert("s_pmp110ukrv_ypServiceImpl.insertLogMaster", param));
			}
		}
		dataMaster.put("KEY_VALUE", keyValue);

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer	insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}






	/**
	 * 자재예약 MASTER 저장 (PMP200T)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String keyValue = (String) dataMaster.get("KEY_VALUE");
		if(ObjUtils.isEmpty(keyValue)) {
			keyValue = getLogKey();
		}

		//1.로그테이블에 입력할 keyValue 정보
		String divCode			= (String) dataMaster.get("DIV_CODE");
		String workShopCode		= (String) dataMaster.get("WORK_SHOP_CODE");
		String prodtWkordDate	= (String) dataMaster.get("PRODT_WKORD_DATE");

		logger.debug("[saveAll] paramDetail:" + paramList);

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 등 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");

			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail2")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";

			for(Map param:	dataList) {
				param.put("KEY_VALUE"			, keyValue);
				param.put("OPR_FLAG"			, oprFlag);
				param.put("DIV_CODE"			, divCode);
				param.put("WORK_SHOP_CODE"		, workShopCode);
				param.put("PRODT_WKORD_DATE"	, prodtWkordDate);

				param.put("data" , super.commonDao.insert("s_pmp110ukrv_ypServiceImpl.insertLogDetail", param));
			}
		}

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue"	, keyValue);
		spParam.put("USER_ID"	, user.getUserID());

		super.commonDao.queryForObject("s_pmp110ukrv_ypServiceImpl.USP_PRODT_PMP100UKR_YP", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
		if(!ObjUtils.isEmpty(errorDesc)){
//			dataMaster.put("TOP_WKORD_NUM", "");
			throw new	UniDirectValidateException(this.getMessage(errorDesc, user));

		} else {
			dataMaster.put("TOP_WKORD_NUM", ObjUtils.getSafeString(spParam.get("TOP_WKORD_NUM")));
			dataMaster.put("LOT_NO", ObjUtils.getSafeString(spParam.get("LOT_NO")));
		}

		paramList.add(0, paramMaster);
		return	paramList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer	insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// DELETE
	public Integer deleteDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	/**
	 * 배송분류표 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeDeliveryLabel(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeDeliveryLabel", param);
	}

	/**
	 * 배송분류표 라벨 출력 New
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeDeliveryLabelNew(Map param) throws Exception {
		 List<Map> labelQList             = (List<Map>) param.get("LABEL_Q");
		 List<Map> packQtyList      = (List<Map>) param.get("PACK_QTY");
		 List<Map> wkordNumList  = (List<Map>) param.get("WKORD_NUM");
		 String qtyFormat  =  (String) param.get("QTY_FORMAT");
		 int qtyFormatLength = qtyFormat.substring(5+1).length(); //소수점 지정을 위한 값구하기
		 Map<String, Object> tempParam0 = new HashMap<String, Object>();
	        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
	        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));

	        String ipAdr = "";
	        int port = 0;
	        port = 6101;
	        Map tempMap0 =this.checkIpAddr(tempParam0);
	        ipAdr = ObjUtils.getSafeString(tempMap0.get("DELI_IP_ADDR"));		//IP정보
	        logger.debug("[[배송분류 당당자 IP]]" + ipAdr);
	        Socket clientSocket = new Socket(ipAdr,port);
	        String ZPLString = "";
			 int i = 0;
			 int labelQ = 0;
			 double packQty = 0;
			 double remainQ = 0;
			 double qtyPerBox	= 0;
			 List<Map> rtnList = super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeDeliveryLabel", param);
			 for(Map rtnListMap : rtnList ){
				// logger.debug("[[i]]" +wkordNumList.get(i));
				// logger.debug("[[iWKORD_NUM]]" +ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM")));

				 for(int k=0; k<wkordNumList.size(); k++){
					 if(( ObjUtils.getSafeString(wkordNumList.get(k)).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
		            		labelQ =  ObjUtils.parseInt(labelQList.get(k));
		            		packQty =  ObjUtils.parseDouble(packQtyList.get(k));
		            	}
				 }

				 remainQ =ObjUtils.parseDouble(rtnListMap.get("WKORD_Q"));
				 for(int j=0; j<labelQ; j++){
					 if(remainQ / packQty >= 1){
						 	qtyPerBox = packQty;
	            			remainQ = remainQ - packQty;
	            		}else{

	            			qtyPerBox = remainQ % packQty ;
	            			qtyPerBox = Math.round(qtyPerBox * 100d) / 100d;  //소수 둘째자리 반올림
	            		}
						//ZPLString = "^XA^LH0,0^XZ";
			      	    //ZPLString += "^XA^LT0^XZ";
			            //ZPLString += "^XA";
					    ZPLString += "^XA";
					    ZPLString +=	"^LL720";
					    ZPLString +=	"^LH0,0";
					    ZPLString += "^LT0";
			            ZPLString += "^SEE:UHANGUL.DAT^FS";
			            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
			            //ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕 볼드
			            ZPLString += "^CW1,E:MALGUNBD.TTF^CI28^FS";	//맑은고딕 볼드
			            ZPLString +="^PW800";
			            ZPLString +="^FO168,80^A1N,36,36^FD" +rtnListMap.get("CUSTOM_NAME")+"^FS";
			            ZPLString +="^FO168,132^A1N,36,36^FD" +rtnListMap.get("ITEM_NAME")+"^FS";
			            ZPLString +="^FO168,184^A1N,36,36^FD" +rtnListMap.get("SPEC")+"^FS";
			            ZPLString +="^FO168,240^A1N,36,36^FD" +  String.format("%." + qtyFormatLength + "f", qtyPerBox) +"^FS";
			            ZPLString +="^FO696,240^A1N,36,36^FD" +(j+1) + '/' + labelQ +"^FS";
			            ZPLString +="^FO168,293^A1N,36,36^FD" + rtnListMap.get("DELIVERY_DATE")+ "^FS";
			            ZPLString +="^FO560,293^A1N,36,36^FD" + rtnListMap.get("ORDER_DATE")+ "^FS";
			            ZPLString +="^FO168,349^A1N,36,36^FD" + rtnListMap.get("PACK_DATE")+ "^FS";
			            ZPLString +="^FO560,349^A1N,36,36^FD" + rtnListMap.get("STORAGE_METHOD")+ "^FS";
			           //ZPLString +="^FO560,349^A1N,36,36^FD" + "10℃이하"+ "^FS";
			            ZPLString +="^FO168,405^A1N,29,29^FD" + rtnListMap.get("EXP_DATE")+ "^FS";
			            ZPLString +="^FO560,405^A1N,36,36^FD" + rtnListMap.get("CAR_NUMBER")+ "^FS";
			            ZPLString +="^FO150,460^A1N,29,29^FD" + rtnListMap.get("ORIGIN")+ "^FS";
			            ZPLString +="^FO420,456^A1N,36,36^FD" + rtnListMap.get("PRODT_YEAR")+ "^FS";
			            ZPLString +="^FO688,456^A1N,36,36^FD" + rtnListMap.get("QUALITY_GRADE")+ "^FS";
			            ZPLString +="^FO168,510^A1N,36,36^FD" + rtnListMap.get("SUPPLIER")+ "^FS";
			            ZPLString +="^FO168,590^A1N,36,36^FD" + rtnListMap.get("PRE_WORK_DATE")+ "^FS";
				        ZPLString +="^XZ";

		            //   DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
		            //   byte[] printData = ZPLString.getBytes("UTF-8");
		             //  outToServer.write(printData);
				 }
				 i++;
			 }
			 logger.debug("[[ZPL]]" + ZPLString);
			  DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	          byte[] printData = ZPLString.getBytes("UTF-8");
	          outToServer.write(printData);
			  clientSocket.close();
		 return "SUCCESS";
	}


	/**
	 * 친환경(소, green01) 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGreen01Label(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeGreen01Label", param);
	}

	/**
	 * 친환경(소, green01) 라벨 출력 New
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeGreen01LabelNew(Map param) throws Exception {
		 List<Map> grLabelQ             = (List<Map>) param.get("GR_LABEL_Q");
		 List<Map> wkordNumList      = (List<Map>) param.get("WKORD_NUM");
		 List<Map> rtnList = super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeGreen01Label", param);

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

		 for(Map rtnListMap : rtnList ){

			  for(int k=0; k<wkordNumList.size(); k++){
					 if(( ObjUtils.getSafeString(wkordNumList.get(k)).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
		            		labelQ =   ObjUtils.parseInt(grLabelQ.get(k));
		           	}
			 }

				logger.debug("[[labelQ]]" + labelQ);

				for(int j=0; j<labelQ; j++){
					ZPLString = "^XA^LH0,0^XZ";
		      	    ZPLString += "^XA^LT0^XZ";
		            ZPLString += "^XA";
		            ZPLString += "^SEE:UHANGUL.DAT^FS";
		            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
		            ZPLString += "^CW1,E:MALGUN.TTF^CI26^FS";	//맑은고딕
		            ZPLString +="^PW520";
		            ZPLString +="^FO12,24^GB498,0,2,^FS";
		            ZPLString +="^FO12,24^GB0,498,2,^FS";
		            ZPLString +="^FO508,24^GB0,498,2,^FS";
		            ZPLString +="^FO180,88^GB0,304,2,^FS";
		            ZPLString +="^FO12,518^GB498,0,2,^FS";
		            ZPLString +="^FO12,88^GB498,0,2,^FS";
		            ZPLString +="^FO12,392^GB498,0,2,^FS";
		            ZPLString +="^FO80,43^A1N,32,32^FD"+ "친환경농산물 표시사항"+"^FS";
		            ZPLString +="^FO196,108^A1N,17,17^FD"+ "취 급 자 : "+"^FS" +  "^FO280,108^A1N,21,21^FD" +rtnListMap.get("COMP_NAME")+"^FS";
		            ZPLString +="^FO196,140^A1N,17,17^FD"+ "인증번호 : "+"^FS" +  "^FO280,140^A1N,21,21^FD" +rtnListMap.get("COMP_CERF_CODE")+"^FS";
		            ZPLString +="^FO196,172^A1N,17,17^FD"+ "전화번호 : "+"^FS" +  "^FO280,172^A1N,21,21^FD" +rtnListMap.get("TELEPHON")+"^FS";
		            ZPLString +="^FO196,204^A1N,17,17^FD"+"작업장주소:"+"^FS";
		            ZPLString +="^FO196,225^A1N,17,17^FD"+rtnListMap.get("ADDR")+"^FS";
		            ZPLString +="^FO196,257^A1N,17,17^FD"+"품      목 : "+"^FS" +  "^FO280,257^A1N,21,21^FD" +rtnListMap.get("ITEM_NAME")+"^FS";
		            ZPLString +="^FO196,289^A1N,17,17^FD"+"산      지 : "+"^FS" +  "^FO280,289^A1N,21,21^FD" +rtnListMap.get("PRODT_PERSON")+"^FS";
		            ZPLString +="^FO196,321^A1N,17,17^FD"+"생산연도 : "+"^FS" +  "^FO280,321^A1N,21,21^FD" +rtnListMap.get("PRODT_YEAR")+"^FS";
		            ZPLString +="^FO196,353^A1N,17,17^FD"+"무게/개수: "+"^FS" +  "^FO280,353^A1N,21,21^FD" +rtnListMap.get("SALE_UNIT")+"^FS";
		            ZPLString +="^FO24,278^A1N,17,17^FD"+rtnListMap.get("CENTER")+"^FS";
		            ZPLString +="^FO24,340^A1N,21,21^FD"+rtnListMap.get("CUSTOM_NAME")+"^FS";
		            ZPLString +="^FO127,412^B3N,N,50^FD"+rtnListMap.get("BARCODE")+"^FS";
		            ZPLString +="^FO80,496^A1N,23,23^FD"+rtnListMap.get("MANAGE_NO")+"^FS";
			        ZPLString +="^XZ";
			        logger.debug("[[ZPL]]" + ZPLString);
	                DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	                byte[] printData = ZPLString.getBytes("EUC-KR");
	                outToServer.write(printData);
				}
			i++;
		 }
	    clientSocket.close();
		return "SUCCESS";
	}

	/**
	 * 친환경(대, green02) 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGreen02Label(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeGreen02Label", param);
	}

	/**
	 * 친환경(대, green02) 라벨 출력_New
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeGreen02LabelNew(Map param) throws Exception {
		 List<Map> grLabelQ             = (List<Map>) param.get("LABEL_Q");
		 List<Map> wkordNumList      = (List<Map>) param.get("WKORD_NUM");
		 List<Map> foodGrade      = (List<Map>) param.get("FOOD_GRADE");
		 List<Map> proteinContent      = (List<Map>) param.get("PROTEIN_CONTENT");
		 List<Map> userProdtPerson      = (List<Map>) param.get("USER_PRODT_PERSON");
		 List<Map> userItemName      = (List<Map>) param.get("USER_ITEM_NAME");
		 List<Map> rtnList = super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeGreen02Label", param);;

		Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));

        String ipAdr = "";
        int port = 0;
        port = 6101;
        Map tempMap0 =this.checkIpAddr(tempParam0);
        ipAdr = ObjUtils.getSafeString(tempMap0.get("GREEN_B_IP_ADDR"));		//IP정보
        logger.debug("[[친환경 당당자 IP]]" + ipAdr);
        logger.debug("[[foodGrade]]" + foodGrade);
        logger.debug("[[proteinContent]]" + proteinContent);
        Socket clientSocket = new Socket(ipAdr,port);
        String ZPLString = "";
		 int i = 0;
		 int labelQ = 0;
		 String foodGradeStr = "";
		 String proteinContentStr = "";
		 String userProdtPersonStr = "";
		 String userItemNameStr = "";
		 for(Map rtnListMap : rtnList ){
			 logger.debug("[[wkordNum]]" +wkordNumList.get(i));

			 for(int k=0; k<wkordNumList.size(); k++){
				 if(( ObjUtils.getSafeString(wkordNumList.get(k)).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
	            		labelQ =  ObjUtils.parseInt(grLabelQ.get(k));
	            		if( foodGrade.get(k) != null){
	            			foodGradeStr = ObjUtils.getSafeString(foodGrade.get(k));
	            		}
	            		if(proteinContent.get(k) != null){
	            			proteinContentStr = ObjUtils.getSafeString(proteinContent.get(k));
	            		}
	            		if(userProdtPerson.get(k) != null){
	            			userProdtPersonStr = ObjUtils.getSafeString(userProdtPerson.get(k));
	            		}
	            		if(userItemName.get(k) != null){
	            			userItemNameStr = ObjUtils.getSafeString(userItemName.get(k));
	            		}
	            	}
			 }
			 /*	 if(( ObjUtils.getSafeString(wkordNumList.get(i)).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
            		labelQ =  ObjUtils.parseInt(grLabelQ.get(i));
            	}*/
				logger.debug("[[labelQ]]" + labelQ);

				for(int j=0; j<labelQ; j++){
					ZPLString = "^XA^LH0,0^XZ";
		      	    ZPLString += "^XA^LT0^XZ";
		            ZPLString += "^XA";
		            ZPLString += "^SEE:UHANGUL.DAT^FS";
		            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
		            ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕
		            ZPLString +="^PW784";
		            ZPLString +="^FO410,96^A1N,25,25^FD" + rtnListMap.get("COMP_NAME") +"^FS";
		            ZPLString +="^FO410,130^A1N,25,25^FD" + rtnListMap.get("COMP_CERF_CODE") +"^FS";
		            ZPLString +="^FO410,168^A1N,25,25^FD" + rtnListMap.get("TELEPHON") +"^FS";
		            ZPLString +="^FO410,206^A1N,25,25^FD"+rtnListMap.get("ADDR")+"^FS";
		            if(ObjUtils.isEmpty(userItemNameStr)){//사용자 입력 품명
		            	ZPLString +="^FO410,243^A1N,25,25^FD"+rtnListMap.get("ITEM_NAME")+"^FS";
		            }else{
		            	ZPLString +="^FO410,243^A1N,25,25^FD"+userItemNameStr+"^FS";
		            }
		            ZPLString +="^FO664,245^A1N,25,25^FD"+rtnListMap.get("ITEM_KIND")+"^FS";
		            ZPLString +="^FO410,280^A1N,25,25^FD"+rtnListMap.get("PROD_AREA")+"^FS";
		            ZPLString +="^FO410,316^A1N,25,25^FD"+rtnListMap.get("PRODT_YEAR")+"^FS";

		            ZPLString +="^FO40,316^A1N,25,25^FD"+rtnListMap.get("CENTER")+"^FS";
		            //ZPLString +="^FO40,345^A1N,18,18^FD"+rtnListMap.get("CUSTOM_NAME")+"^FS";

		            ZPLString +="^FO410,350^A1N,25,25^FD"+rtnListMap.get("PRODT_DATE")+"^FS";

		            //등급
		            if(foodGradeStr.equals("01")){	//특

		            	ZPLString +="^FO344,375^GC40,3,B^FS";

		            }else if(foodGradeStr.equals("02")){	//상

		            	ZPLString +="^FO448,375^GC40,3,B^FS";

		            }else if(foodGradeStr.equals("03")){	//보통

		            	ZPLString +="^FO554,375^GC40,3,B^FS";

		            }else if(foodGradeStr.equals("04") || ObjUtils.isEmpty(foodGradeStr)){	//미검사

		            	ZPLString +="^FO715,375^GC40,3,B^FS";

		            }
		            //단백질 함유
		            if(proteinContentStr.equals("01")){	//수

		            	ZPLString +="^FO344,415^GC40,3,B^FS";

		            }else if(proteinContentStr.equals("02")){	//우

		            	ZPLString +="^FO448,415^GC40,3,B^FS";

		            }else if(proteinContentStr.equals("03")){	//미

		            	ZPLString +="^FO554,415^GC40,3,B^FS";

		            }else if(proteinContentStr.equals("04") || ObjUtils.isEmpty(proteinContentStr)){	//미검사

		            	ZPLString +="^FO715,415^GC40,3,B^FS";
		            }

		            if(ObjUtils.isEmpty(userProdtPersonStr)){//사용자 생산지
		            	ZPLString +="^FO300,460^A1N,25,25^FD"+ rtnListMap.get("PRODT_PERSON") +"^FS";
		            }else{
		            	ZPLString +="^FO300,460^A1N,25,25^FD"+ userProdtPersonStr +"^FS";
		            }

		            ZPLString +="^FO300,498^A1N,25,25^FD"+rtnListMap.get("MANAGE_NO")+"^FS";
		            ZPLString +="^FO300,518^B3N,N,50^FD"+rtnListMap.get("BARCODE")+"^FS";
			        ZPLString +="^XZ";


			      logger.debug("[[ZPL]]" + ZPLString);
	              DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	              byte[] printData = ZPLString.getBytes("EUC-KR");
	              outToServer.write(printData);
				}
			i++;
		 }
		clientSocket.close();
		return "SUCCESS";

	}

	/**
	 * 친환경(대, green02) 라벨 출력_NewLocal
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public String makeGreen02LabelNewUsb(Map param) throws Exception {
		 List<Map> grLabelQ             = (List<Map>) param.get("LABEL_Q");
		 List<Map> wkordNumList      = (List<Map>) param.get("WKORD_NUM");
		 List<Map> foodGrade      = (List<Map>) param.get("FOOD_GRADE");
		 List<Map> proteinContent      = (List<Map>) param.get("PROTEIN_CONTENT");
		 List<Map> rtnList = super.commonDao.list("s_pmp110ukrv_ypServiceImpl.makeGreen02Label", param);;

		Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", param.get("S_COMP_CODE"));
        tempParam0.put("S_USER_ID", param.get("S_USER_ID"));

        PrintService psZebra = null;
        String sPrinterName = null;
        String printerName = "zdesigner zt410-203dpi zpl (1 복사)";
        logger.debug("[[foodGrade]]" + foodGrade);
        logger.debug("[[proteinContent]]" + proteinContent);
        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        for (int i = 0; i < services.length; i++) {
            PrintServiceAttribute attr = services[i].getAttribute(PrinterName.class);
            sPrinterName = ((PrinterName) attr).getValue();
            sPrinterName = sPrinterName.toLowerCase();
            logger.debug("[[LOCAL에 설치된 프린터명]]" + sPrinterName.toLowerCase());
            if (sPrinterName.equals(printerName)) {
             psZebra = services[i];
             break;
            }
           }

           if (psZebra == null) {
        	   throw new Exception();
           }
        String ZPLString = "";
		 int i = 0;
		 int labelQ = 0;
		 String foodGradeStr = "";
		 String proteinContentStr = "";
		 for(Map rtnListMap : rtnList ){
			 logger.debug("[[wkordNum]]" +wkordNumList.get(i));
			  if(( ObjUtils.getSafeString(wkordNumList.get(i)).equals(ObjUtils.getSafeString(rtnListMap.get("WKORD_NUM"))))){
            		labelQ =  ObjUtils.parseInt(grLabelQ.get(i));
            	}
				logger.debug("[[labelQ]]" + labelQ);
				foodGradeStr = ObjUtils.getSafeString(foodGrade.get(i));
				proteinContentStr = ObjUtils.getSafeString(proteinContent.get(i));
				for(int j=0; j<1; j++){
					ZPLString = "^XA^LH0,0^XZ";
		      	    ZPLString += "^XA^LT0^XZ";
		            ZPLString += "^XA";
		            ZPLString += "^SEE:UHANGUL.DAT^FS";
		            //ZPLString += "^CW1,E:COREFONT.TTF^CI26^FS";
		            ZPLString += "^CW1,E:MALGUNBD.TTF^CI26^FS";	//맑은고딕
		            ZPLString +="^PW784";
		            ZPLString +="^FO410,96^A1N,25,25^FD" +rtnListMap.get("COMP_NAME")+"^FS";
		            ZPLString +="^FO410,130^A1N,25,25^FD" +rtnListMap.get("COMP_CERF_CODE")+"^FS";
		            ZPLString +="^FO410,168^A1N,25,25^FD" +"031-770-4000"+"^FS";
		            ZPLString +="^FO410,206^A1N,25,25^FD"+rtnListMap.get("ADDR")+"^FS";
		            ZPLString +="^FO410,243^A1N,25,25^FD"+rtnListMap.get("ITEM_NAME")+"^FS";
		            ZPLString +="^FO664,245^A1N,25,25^FD"+rtnListMap.get("ITEM_KIND")+"^FS";
		            ZPLString +="^FO410,280^A1N,25,25^FD"+rtnListMap.get("PROD_AREA")+"^FS";
		            ZPLString +="^FO410,316^A1N,25,25^FD"+rtnListMap.get("PRODT_YEAR")+"^FS";

		            ZPLString +="^FO40,316^A1N,25,25^FD"+rtnListMap.get("CENTER")+"^FS";
		            ZPLString +="^FO40,345^A1N,18,18^FD"+rtnListMap.get("CUSTOM_NAME")+"^FS";

		            ZPLString +="^FO410,350^A1N,25,25^FD"+rtnListMap.get("PRODT_DATE")+"^FS";
		            ZPLString +="^FO300,460^A1N,25,25^FD"+rtnListMap.get("PRODT_PERSON")+"^FS";
		            //등급
		            if(foodGradeStr.equals("01")){//특

		            	ZPLString +="^FO400,456^GC80,10,B^FS";

		            }else if(foodGradeStr.equals("02")){//상

		            	ZPLString +="^FO420,456^GC80,10,B^FS";;

		            }else if(foodGradeStr.equals("03")){//보통

		            	ZPLString +="^FO440,456^GC80,10,B^FS";

		            }else if(foodGradeStr.equals("04")){//미검사

		            	ZPLString +="^FO460,456^GC80,10,B^FS";

		            }
		            //단백질 보유
		            if(proteinContentStr.equals("01")){//수

		            	ZPLString +="^FO460,466^GC80,10,B^FS";

		            }else if(proteinContentStr.equals("02")){//우

		            	ZPLString +="^FO460,466^GC80,10,B^FS";

		            }else if(proteinContentStr.equals("03")){//미

		            	ZPLString +="^FO460,466^GC80,10,B^FS";

		            }else if(proteinContentStr.equals("04")){//미검사

		            	ZPLString +="^FO460,466^GC80,10,B^FS";
		            }
		            ZPLString +="^FO300,498^A1N,25,25^FD"+rtnListMap.get("MANAGE_NO")+"^FS";
		            ZPLString +="^FO300,518^B3N,N,50^FD"+rtnListMap.get("BARCODE")+"^FS";
			        ZPLString +="^XZ";
			        logger.debug("[[ZPL]]" + ZPLString);
			        DocPrintJob job = psZebra.createPrintJob();

	                  byte[] by = ZPLString.getBytes("EUC-KR");
	                  DocFlavor flavor = DocFlavor.BYTE_ARRAY.AUTOSENSE;
	                  Doc doc = new SimpleDoc(by, flavor, null);
	                  job.print(doc, null);
				}
			i++;
		 }
		return "SUCCESS";

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






//클립리포트로 변경
	/**
	 * 친환경(소) insert - 20210830 추가
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer insertPrintData(Map param) throws Exception {
		super.commonDao.insert("s_pmp110ukrv_ypServiceImpl.insertPrintData", param);
		return 0;
	}
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getGreen02Label(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.getGreen02Label", param);
	}
	/**
	 * 배송분류표 데이터 insert - 20210830 추가
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer insertPrint2Data(Map param) throws Exception {
		super.commonDao.insert("s_pmp110ukrv_ypServiceImpl.insertPrint2Data", param);
		return 0;
	}
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getDeliveryLabel(Map param) throws Exception {
		return super.commonDao.list("s_pmp110ukrv_ypServiceImpl.getDeliveryLabel", param);
	}
}