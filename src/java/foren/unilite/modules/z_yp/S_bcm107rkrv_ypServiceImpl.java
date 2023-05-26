package foren.unilite.modules.z_yp;

import java.io.DataOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_bcm107rkrv_ypService")
public class S_bcm107rkrv_ypServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 거래처, 인증정보 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_bcm107rkrv_ypServiceImpl.selectList", param);
	}

	/**
	 * 친환경 라벨출력
	 * @param 선택한 레코드
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savePrintedData(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");


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

		Map<String, Object> tempParam0 = new HashMap<String, Object>();
        tempParam0.put("S_COMP_CODE", user.getCompCode());
        tempParam0.put("S_USER_ID", user.getUserID());

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
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			for(Map param:	dataList) {
				labelQ =  (int) param.get("PRINT_CNT");
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
		            ZPLString +="^FO196,108^A1N,17,17^FD"+ "취 급 자 : "+"^FS" +  "^FO280,108^A1N,21,21^FD" +param.get("CUSTOM_NAME")+"^FS";
		            ZPLString +="^FO196,140^A1N,17,17^FD"+ "인증번호 : "+"^FS" +  "^FO280,140^A1N,21,21^FD" +param.get("CERT_NO")+"^FS";
		            ZPLString +="^FO196,172^A1N,17,17^FD"+ "전화번호 : "+"^FS" +  "^FO280,172^A1N,21,21^FD" +param.get("TELEPHON")+"^FS";
		            ZPLString +="^FO196,204^A1N,17,17^FD"+"작업장주소:"+"^FS";
		            ZPLString +="^FO196,225^A1N,17,17^FD"+param.get("WORK_ADDR")+"^FS";
		            ZPLString +="^FO196,257^A1N,17,17^FD"+"품      목 : "+"^FS" +  "^FO280,257^A1N,21,21^FD" +param.get("ITEM_NAME")+"^FS";
		            ZPLString +="^FO196,289^A1N,17,17^FD"+"산      지 : "+"^FS" +  "^FO280,289^A1N,21,21^FD" +param.get("ORIGIN")+"^FS";
		            ZPLString +="^FO196,321^A1N,17,17^FD"+"생산연도 : "+"^FS" +  "^FO280,321^A1N,21,21^FD" +param.get("PRDT_YEAR")+"^FS";
		            ZPLString +="^FO196,353^A1N,17,17^FD"+"무게/개수: "+"^FS" +  "^FO280,353^A1N,21,21^FD" +param.get("ORDER_UNIT")+"^FS";
		            ZPLString +="^FO24,278^A1N,17,17^FD"+param.get("CONFIRM_CENTER")+"^FS";
		            //ZPLString +="^FO24,340^A1N,21,21^FD"+param.get("CUSTOM_NAME")+"^FS";
		            ZPLString +="^FO127,412^B3N,N,50^FD"+param.get("PRDCER_CERT_NO")+"^FS";
		            //ZPLString +="^FO80,496^A1N,23,23^FD"+param.get("ANT_NUM")+"^FS";
			        ZPLString +="^XZ";
			        logger.debug("[[ZPL]]" + ZPLString);
	                 DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	                 byte[] printData = ZPLString.getBytes("EUC-KR");
	                 outToServer.write(printData);
				}
				logger.debug("[[param]]" + param);
			}
		}
		clientSocket.close();
		dataMaster.put("KEY_VALUE", keyValue);

		paramList.add(0, paramMaster);

		return  paramList;

	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")		// INSERT
	public Integer	savePrinted(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
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
}
