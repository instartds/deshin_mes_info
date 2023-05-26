package foren.unilite.modules.z_wm;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_mtr200ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mtr200ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**출고유형에 따른 수불유형값(입고,출고,반품) M104
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectInoutType(Map param) throws Exception {
		return super.commonDao.select("s_mtr200ukrv_wmServiceImpl.selectInoutType", param);
	}

	/**
	 * 출고등록->출고내역조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_mtr200ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 출고등록->출고내역검색 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreleaseNoMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mtr200ukrv_wmServiceImpl.selectreleaseNoMasterList", param);
	}

	/**
	 * 출고등록->예약참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectrefList(Map param) throws Exception {
		return super.commonDao.list("s_mtr200ukrv_wmServiceImpl.selectrefList", param);
	}

	/**
	 * 출고등록->AS참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectrefList2(Map param) throws Exception {
		return super.commonDao.list("s_mtr200ukrv_wmServiceImpl.selectrefList2", param);
	}





	/**
	 * 출고등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "mtrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue				= getLogKey();
		List<Map> dataList			= new ArrayList<Map>();
		Map<String, Object> spParam	= new HashMap<String, Object>();
		Map<String, Object> spParam2= new HashMap<String, Object>();
		Map<String, Object> spParam3= new HashMap<String, Object>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param: dataList) {
				if("D".equals(oprFlag) || ObjUtils.isNotEmpty((param.get("CHK_FLAG")))) {
					if(!"D".equals(oprFlag)) {
						oprFlag=(String) param.get("SAVE_FLAG");
					}
					param.put("KEY_VALUE"	, keyValue);
					param.put("OPR_FLAG"	, oprFlag);
					//20210326 추가: 'U'일 때는, delete, insert 로직을 수행하기 위해서 로그테이블 2개 생성
					if("U".equals(oprFlag)) {
						//1. delete 로그 데이터 생성
						String keyValue2 = getLogKey();
						param.put("KEY_VALUE"	, keyValue2);
						param.put("data", super.commonDao.insert("s_mtr200ukrv_wmServiceImpl.insertLogMaster_D", param));

						spParam2.put("KEY_VALUE", keyValue2);
						spParam2.put("LangCode"	, user.getLanguage());
						super.commonDao.queryForObject("s_mtr200ukrv_wmServiceImpl.spReseving", spParam2);
						String errorDesc = ObjUtils.getSafeString(spParam2.get("ERROR_DESC"));

						if(!ObjUtils.isEmpty(errorDesc)){
							throw new UniDirectValidateException(this.getMessage(errorDesc, user));
						}
						//2. insert 로그 데이터 생성
						String keyValue3 = getLogKey();
						param.put("KEY_VALUE"	, keyValue3);
						param.put("OPR_FLAG"	, "N");
						param.put("data", super.commonDao.insert("s_mtr200ukrv_wmServiceImpl.insertLogMaster", param));

						spParam3.put("KEY_VALUE"	, keyValue3);
						spParam3.put("LangCode"	, user.getLanguage());
						super.commonDao.queryForObject("s_mtr200ukrv_wmServiceImpl.spReseving", spParam3);
						errorDesc = ObjUtils.getSafeString(spParam3.get("ERROR_DESC"));

						if(!ObjUtils.isEmpty(errorDesc)){
							dataMaster.put("INOUT_NUM", "");
							throw new UniDirectValidateException(this.getMessage(errorDesc, user));
						} else {
							dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam3.get("INOUT_NUM")));
						}
					} else {
						param.put("data", super.commonDao.insert("s_mtr200ukrv_wmServiceImpl.insertLogMaster", param));
					}
				}
			}
		}

		//2.저장 Stored Procedure 실행
		spParam.put("KEY_VALUE"	, keyValue);
		spParam.put("LangCode"	, user.getLanguage());
		spParam.put("GUBUN"		, "1");

		super.commonDao.queryForObject("s_mtr200ukrv_wmServiceImpl.spReseving", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			if(ObjUtils.isEmpty(spParam3.get("INOUT_NUM"))) {
				dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("INOUT_NUM")));
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mtrl")		// INSERT
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mtrl")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mtrl")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}
}