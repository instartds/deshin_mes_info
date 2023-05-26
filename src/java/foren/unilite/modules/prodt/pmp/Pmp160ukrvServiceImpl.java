package foren.unilite.modules.prodt.pmp;

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

@Service("pmp160ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Pmp160ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 생산정보 Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		//	조회1
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("pmp160ukrvServiceImpl.selectDetailList", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		//	조회2
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("pmp160ukrvServiceImpl.selectDetailList2", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		//	대체품목 조회
	public List<Map<String, Object>> selectReplaceItem(Map param) throws Exception {
		List<Map> selectReplaceData = (List<Map>) super.commonDao.list("pmp160ukrvServiceImpl.selectReplaceItem1", param);
//		Object baseDateData = selectReplaceData.get(0).get("BASE_DATE");
//		Object fromItemData = selectReplaceData.get(0).get("ITEM_CODE");
//		String baseDate2 = (String)baseDateData;
//		String fromItem = (String)fromItemData;
		String baseDate2 = "";
		String fromItem = "";

		for(int i = 0; i < selectReplaceData.size(); i++) {
			baseDate2 = baseDate2 + selectReplaceData.get(i).get("BASE_DATE") + "|#";
			fromItem = fromItem + selectReplaceData.get(i).get("ITEM_CODE") + "|#";
		}	 
		param.put("BASE_DATE2", baseDate2);
		param.put("FROM_ITEM", fromItem);
		return super.commonDao.list("pmp160ukrvServiceImpl.selectReplaceItem2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

			for(Map param:	dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("pmp160ukrvServiceImpl.insertLogMaster", param));
			}
		}
		//4.매출저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("pmp160ukrvServiceImpl.USP_PRODT_Pmp100ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception { 
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	private void beforeSaveDetail(Map param, LoginVO user, String string) {
		// TODO Auto-generated method stub
	}




	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)			//품목코드 입력 시, LOSS_RATE 가져오기
	public List<Map<String, Object>> getLossRate (Map param) throws Exception {
		return super.commonDao.list("pmp160ukrvServiceImpl.getLossRate", param);
	}

	/**
	 * 예약자재 재생성 호출 로직 - 20200403 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public void fnRegeneration (Map param, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		param.put("KEY_VALUE", keyValue);
		super.commonDao.queryForObject("pmp160ukrvServiceImpl.fnRegeneration", param);

		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

		if(!errorDesc.isEmpty()){
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user)+ (messsage.length > 1 ? messsage[1] : ""));
		}
	}
}