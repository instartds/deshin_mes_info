package foren.unilite.modules.z_kd;

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



@Service("s_pmp100ukrv_kdService")
public class S_pmp100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.select("s_pmp100ukrv_kdServiceImpl.selectMaster", param);
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
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectDetailList", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1(Map param) throws Exception {
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectDetailList1", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectDetailList2", param);
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
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectOrderNumMaster", param);
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
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectOrderNumDetail", param);
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
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectEstiList", param);
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
		return super.commonDao.list("s_pmp100ukrv_kdServiceImpl.selectRefList", param);
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

		//1.로그테이블에서 사용할 KeyValue 생성
		Map<String, Object> mapKey = (Map<String, Object>)super.commonDao.select("s_pmp100ukrv_kdServiceImpl.getKeyValue");
		String keyValue = ObjUtils.getSafeString(mapKey.get("keyValue"));				

		//2.수주마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);

		if (ObjUtils.isEmpty(dataMaster.get("ORDER_NUM") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_pmp100ukrv_kdServiceImpl.insertLogMaster", dataMaster);
		
		//3.수주디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map param: paramList) {
			dataList = (List<Map>)param.get("data");

			if(param.get("method").equals("insertDetail")) {
				param.put("data", insertLogDetails(dataList, keyValue, "N") );	
			} else if(param.get("method").equals("updateDetail")) {
				param.put("data", insertLogDetails(dataList, keyValue, "U") );	
			} else if(param.get("method").equals("deleteDetail")) {
				param.put("data", insertLogDetails(dataList, keyValue, "D") );	
			}
		}

		//4.수주저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("spSalesOrder", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		if(!errorDesc.isEmpty()){
			dataMaster.put("ORDER_NUM", "");
			throw new Exception(errorDesc);
		} else {
			dataMaster.put("ORDER_NUM", ObjUtils.getSafeString(spParam.get("OrderNum")));
		}
		
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
			
			super.commonDao.insert("s_pmp100ukrv_kdServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
}
