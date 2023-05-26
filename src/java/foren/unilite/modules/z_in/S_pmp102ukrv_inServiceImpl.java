package foren.unilite.modules.z_in;

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
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_pmp102ukrv_inService")
public class S_pmp102ukrv_inServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());




	/**
	 * 수주정보 Master 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("s_pmp102ukrv_inServiceImpl.selectMaster", param);
	}

	/**
	 *
	 * 수주정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		if("1".equals(param.get("TYPE"))){
			return selectDetailList1(param);
		}else{
			return selectDetailList2(param);
		}
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1(Map param) throws Exception {
		Map map = (Map) super.commonDao.select("s_pmp102ukrv_inServiceImpl.validatePmp100QBom", param);
		if(map != null && !"0".equals(map.get("ERROR_CODE"))){
			throw new Exception(map.get("ERROR_DESC")+"");
		}
		param.put("MRP_CONTROL_NUM", map.get("MRP_CONTROL_NUM"));
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectDetailList1", param);
	}
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> selectList(Map param) throws Exception {
		Map map = (Map) super.commonDao.select("s_pmp102ukrv_inServiceImpl.validatePmp100QBom", param);
		if(map != null && !"0".equals(map.get("ERROR_CODE"))){
			throw new Exception(map.get("ERROR_DESC")+"");
		}
		param.put("MRP_CONTROL_NUM", map.get("MRP_CONTROL_NUM"));
		List<Map<String, Object>> masterList =  super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectDetailList1", param);
		List<Map<String, Object>> detailList =  super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectDetailList2", param);
		Map dataMap = new HashMap<>();
		dataMap.put("masterList", masterList);
		dataMap.put("detailList", detailList);
		return dataMap;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectDetailList2", param);
	}

	/**
	 *
	 * 수주정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectOrderNumMaster", param);
	}

	/**
	 *
	 * 수주정보검색 조회(Detail)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectOrderNumDetail", param);
	}

	/**
	 *
	 * 견적 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectEstiList", param);
	}

	/**
	 *
	 * 수주이력 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectRefList", param);
	}

	/**
	 * 수주정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramMaster:" + paramMaster);
		logger.debug("[saveAll] paramDetail:" + paramList);

		//2.수주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String sTopWkordNum= null;
		Map sWkordNum = new HashMap();
		String  topLotno = null;

		if(dataMaster.get("detailArray") != null){
			List<Map<String, Object>> detailArray = (List) dataMaster.get("detailArray");
			Map<String, Object> selLotnoMap =detailArray.get(0);
			int dCnt = 0;
			String sSeqNo = "", sAutoNo = null;
			if(detailArray != null && detailArray.size() > 0){
				for (int i = 0; i < detailArray.size(); i++) {
					Map<String, Object> map = detailArray.get(i);
					map.put("S_COMP_CODE",user.getCompCode());
					map.put("S_USER_ID",user.getUserID());

					if(!sSeqNo.equals(map.get("SEQ_NO")+"")){

						map.put("TABLE","PMP100T");
						map.put("TYPE","P");

						Map<String, Object> autoNumMap = (Map<String, Object>)super.commonDao.select("s_pmp102ukrv_inServiceImpl.selectAutoNum",map);
						if(autoNumMap != null){
							sAutoNo = autoNumMap.get("AUTO_NUM")+"";
							if(i == 0){
								sTopWkordNum = sAutoNo;
								dCnt = dCnt + 1;

							}
							sWkordNum.put(map.get("SEQ_NO")+"", sAutoNo);  //sWkordNum
						}

					}
					if(map.get("WKORD_NUM") == null || "".equals(map.get("WKORD_NUM"))){

						map.put("WKORD_NUM", sAutoNo);
					};

					map.put("TOP_WKORD_NUM", sTopWkordNum);
					selLotnoMap.put("TOP_WKORD_NUM", sTopWkordNum);

					super.commonDao.insert("s_pmp102ukrv_inServiceImpl.insertPmp100t",map);
					if("Y".equals(map.get("LINE_END_YN"))){
						Map ErrorMap = (Map) super.commonDao.select("s_pmp102ukrv_inServiceImpl.fnWorkOrders",map);
						if(!";".equals(ErrorMap.get("ERROR_CODE")) && !"".equals(ErrorMap.get("ERROR_CODE"))){
							throw new Exception(ErrorMap.get("ERROR_DESC")+"");
						}
					}
					sSeqNo = map.get("SEQ_NO")+"";

				}
				selLotnoMap.put("S_COMP_CODE",user.getCompCode());
				topLotno = (String) super.commonDao.select("s_pmp102ukrv_inServiceImpl.selLotno",selLotnoMap);
				logger.debug("[topLotno]" + topLotno);

			}
		}


		if(dataMaster.get("masterArray") != null){
			List<Map<String, Object>> masterArray = (List) dataMaster.get("masterArray");

			String sCustomCode;
			if(masterArray != null && masterArray.size() > 0){
				for(Map<String,Object> map : masterArray){
					if("1".equals(map.get("SUPPLY_TYPE")) || "3".equals(map.get("SUPPLY_TYPE"))){
						map.put("S_COMP_CODE",user.getCompCode());
						map.put("COMP_CODE",user.getCompCode());
						map.put("S_USER_ID",user.getUserID());
						Map customMap = (Map) super.commonDao.select("s_pmp102ukrv_inServiceImpl.getCustom",map);

						if(customMap.get("CUSTOM_CODE") == null){
							sCustomCode = "";
						}else{
							sCustomCode = customMap.get("CUSTOM_CODE").toString();
						}
						map.put("CUSTOM_CODE",sCustomCode);

						map.put("TABLE","MRP400T");
						map.put("TYPE","M");
						Map<String, Object> autoNumMap = (Map<String, Object>)super.commonDao.select("s_pmp102ukrv_inServiceImpl.selectAutoNum",map);
						map.put("ORDER_REQ_NUM",autoNumMap.get("AUTO_NUM")+"");
						map.put("sTopWkordNum",sTopWkordNum);
						super.commonDao.insert("s_pmp102ukrv_inServiceImpl.insertMrp400t",map);


					}
					if("3".equals(map.get("SUPPLY_TYPE"))){
						super.commonDao.insert("s_pmp102ukrv_inServiceImpl.updatePpl00t",map);
					}
				}
			}

		}


		dataMaster.put("sWkordNum", sWkordNum);
		dataMaster.put("sTopWkordNum", sTopWkordNum);
		dataMaster.put("topLotno", topLotno);
		//5.수주마스터 정보 + 수주디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 수주디테일 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);

			super.commonDao.insert("s_pmp102ukrv_inServiceImpl.insertLogDetail", param);
		}

		return params;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {


		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {

		 return 0;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		 return 0;
	}

	/**
	 *
	 * 작업장라인조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWhline(Map param) throws Exception {
		return super.commonDao.list("s_pmp102ukrv_inServiceImpl.selectWhline", param);
	}

}
