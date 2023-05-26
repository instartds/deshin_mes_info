package foren.unilite.modules.z_yp;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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



@Service("s_pmp112ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmp112ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 생산정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.selectDetailList", param);
	}

	/**
	 * PMP200T 조회(detailGird2)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectPMP200T(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.selectPMP200T", param);
	}
	
	/**
	 * 작업지시 조회 (팝업창)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWorkNum(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.selectWorkNum", param);
	}
	
	/**
	 * 신규 / 수주참조 시, PMP200T 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getPMP200T(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.getPMP200T", param);
	}

	/**
	 * 수주정보참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSalesOrderList(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.selectSalesOrderList", param);
	}

	/**
	 * 공정정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProgInfo(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.selectProgInfo", param);
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
				progWorkCode = (Map) super.commonDao.select("s_pmp112ukrv_ypServiceImpl.getProgWorkCode", param);

				param.put("PROG_WORK_CODE"	, progWorkCode.get("PROG_WORK_CODE"));
				param.put("LINE_SEQ"		, progWorkCode.get("LINE_SEQ"));
				param.put("data"			, super.commonDao.insert("s_pmp112ukrv_ypServiceImpl.insertLogMaster", param));
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
				
				param.put("data" , super.commonDao.insert("s_pmp112ukrv_ypServiceImpl.insertLogDetail", param));
			}
		}
		
		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue"	, keyValue);
		spParam.put("USER_ID"	, user.getUserID());

		super.commonDao.queryForObject("s_pmp112ukrv_ypServiceImpl.USP_PRODT_PMP100UKR_YP", spParam);

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
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.makeDeliveryLabel", param);
	}
	
	
	
	/**
	 * 친환경(소, green01) 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGreen01Label(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.makeGreen01Label", param);
	}
	
	
	
	/**
	 * 친환경(대, green02) 라벨 출력
	 */
	@ExtDirectMethod(group = "z_yp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> makeGreen02Label(Map param) throws Exception {
		return super.commonDao.list("s_pmp112ukrv_ypServiceImpl.makeGreen02Label", param);
	}
}
