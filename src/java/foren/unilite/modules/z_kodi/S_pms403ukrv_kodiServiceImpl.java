package foren.unilite.modules.z_kodi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

import javax.annotation.Resource;

import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.tags.ComboService;
import foren.unilite.modules.com.combo.ComboServiceImpl;



@Service("s_pms403ukrv_kodiService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_pms403ukrv_kodiServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_pms403ukrv_kodiServiceImpl.selectMaster", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("s_pms403ukrv_kodiServiceImpl.selectDetail", param);
	}


	/**
	 * 검색팝업창 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_pms403ukrv_kodiServiceImpl.selectOrderNumMaster", param);
	}

	/**
	 * 접수참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_pms403ukrv_kodiServiceImpl.selectEstiList", param);
	}

	/**
	 * 검사항목 가져오기 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectTestListNew(Map param) throws Exception {
		return super.commonDao.list("s_pms403ukrv_kodiServiceImpl.selectTestListNew", param);
	}

	/**
	 * 결과값 default 가져오는 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public String getTestResult(Map param) throws Exception {
		return (String) super.commonDao.select("s_pms403ukrv_kodiServiceImpl.getTestResult", param);
	}

	/**
	 * 공정검사정보 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))  oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))  oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))  oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_pms403ukrv_kodiServiceImpl.insertLogMaster", param));
			}
		}

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_pms403ukrv_kodiServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INSPEC_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			dataMaster.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // INSERT
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		return 0;
	}




	/**
	 * 공정검사 상세정보 저장
	 * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("deleteDetail2"))  oprFlag="D";

			for(Map param:  dataList) {
				if(oprFlag != "D") {
					if("N".equals(param.get("SAVE_FLAG"))) {
						oprFlag = "N";
					} else {
						oprFlag = "U";
					}
				}
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_pms403ukrv_kodiServiceImpl.insertLogMaster2", param));
			}
		}

		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_pms403ukrv_kodiServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INSPEC_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			dataMaster.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // INSERT
	public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")		  // UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		return 0;
	}

	/**
	 * 표준검사항목 저장
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equip")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> copyAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		super.commonDao.delete("s_pms403ukrv_kodiServiceImpl.testcodeDelete", dataMaster);

		if(paramList != null)   {
            List<Map> insertList = null;
            for(Map dataListMap: paramList) {
        		if(dataListMap.get("method").equals("testcodeCopy")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            if(insertList != null) this.testcodeCopy(insertList, user);

        }
        paramList.add(0, paramMaster);

        return  paramList;
    }

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> testcodeCopy(List<Map> params, LoginVO user) throws Exception {


		for(Map param: params)		{
			super.commonDao.insert("s_pms403ukrv_kodiServiceImpl.testcodeCopy", param);
		}
		return params;
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "pms")
	public List<Map<String, Object>>  inspecQtyCheck(Map param) throws Exception {
		return  super.commonDao.list("s_pms403ukrv_kodiServiceImpl.inspecQtyCheck", param);
	}

	/**
     * 시험항목
     * @param param(S_COMP_CODE)
     * @return
     * @throws Eception
     * */
	public List<ComboItemModel> getTestCode(Map param) throws Exception{
		return (List<ComboItemModel>) super.commonDao.list("s_pms403ukrv_kodiServiceImpl.getTestCode", param);
	}

}
