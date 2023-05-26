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
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_sal100ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Sal100ukrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 기본 거래처명 가져오는 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Map getCustomNm(Map param) throws Exception {
		return (Map) super.commonDao.select("s_sal100ukrv_wmServiceImpl.getCustomNm", param);
	}

	/**
	 * 창고CELL 코드 가져오는 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public String getWhCellCode(Map param) throws Exception {
		return (String) super.commonDao.select("s_sal100ukrv_wmServiceImpl.getWhCellCode", param);
	}

	/**
	 * 담당자 변경 시, 자동으로 set할 데이터 가져오는 로직
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Map chgInoutPrsn(Map param) throws Exception {
		return (Map) super.commonDao.select("s_sal100ukrv_wmServiceImpl.chgInoutPrsn", param);
	}

	/**
	 * 기획상품단가 가져오는 로직 - 20210225 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Double getUnitPrice(Map param) throws Exception {
		return (Double) super.commonDao.select("s_sal100ukrv_wmServiceImpl.getUnitPrice", param);
	}




	/**
	 * 조회팝업 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectOrderNumMasterList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sal100ukrv_wmServiceImpl.selectOrderNumMasterList", param);
	}

	/**
	 * 판매등록 (WM) 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sal100ukrv_wmServiceImpl.selectList", param);
	}





	/**판매등록 (WM) 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue					= getLogKey();
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList				= new ArrayList<Map>();
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param: dataList) {
				param.put("KEY_VALUE"	, keyValue);
				param.put("OPR_FLAG"	, oprFlag);
				param.put("data", super.commonDao.insert("s_sal100ukrv_wmServiceImpl.insertLogMaster", param));
			}
		}

		//3.출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		super.commonDao.queryForObject("s_sal100ukrv_wmServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String salePrsnChk = ObjUtils.getSafeString(spParam.get("SalePrsnChk"));

		//출하지시 마스터 출하지시 번호 update
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INOUT_NUM", "");
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			if(!ObjUtils.isEmpty(salePrsnChk)){
				dataMaster.put("SALE_PRSN_CHK", salePrsnChk);
			}
			//수주번호 그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}
}