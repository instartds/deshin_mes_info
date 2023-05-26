package foren.unilite.modules.z_in;

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
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_sof120ukrv_inService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_sof120ukrv_inServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주진행현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		logger.debug("[[param]]" + param);
		return  super.commonDao.list("s_sof120ukrv_inServiceImpl.selectList", param);
	}

	/**
	 * saveall
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sof")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_sof120ukrv_inServiceImpl.insertLogMaster", param));
			}
		}
		//출고등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());

		super.commonDao.queryForObject("s_sof120ukrv_inServiceImpl.spReceiving", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("ORDER_NUM", "");
			 throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}


//사용 안 하는 로직
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sof")
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_sof120ukrv_inServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sof")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{
			 logger.debug("[[param]]" + param);
			List<Map> beforeUpdateCheck = (List<Map>) super.commonDao.list("s_sof120ukrv_inServiceImpl.beforeUpdateCheck", param);

			if(!ObjUtils.isNotEmpty(beforeUpdateCheck)){
				super.commonDao.update("s_sof120ukrv_inServiceImpl.insertDetail", param);
			}else{
				super.commonDao.update("s_sof120ukrv_inServiceImpl.updateDetail", param);
			}
		}
		return;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sof")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{
			try {
				super.commonDao.delete("s_sof120ukrv_inServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return;
	}
}