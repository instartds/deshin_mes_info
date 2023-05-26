package foren.unilite.modules.z_jw;

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

@Service("s_map300ukrv_jwService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_map300ukrv_jwServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 입고단가 일괄조정 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_map300ukrv_jwServiceImpl.selectList", param);
	}
	
	/**
	 * 입고단가 일괄조정 저장
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
//			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateList"))	oprFlag="U";
//			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map<String, Object> param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("data", super.commonDao.insert("s_map300ukrv_jwServiceImpl.insertLogMaster", param));
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);
		spParam.put("LANG_CODE", user.getLanguage());
		spParam.put("ERROR_DESC","");

		super.commonDao.queryForObject("sps_map300ukrv_jw", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
		}
		
		paramList.add(0, paramMaster);
			
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map>  updateList(List<Map> params,LoginVO user) throws Exception {
		
		return  params;
	}
	
}