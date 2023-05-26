package foren.unilite.modules.sales.ssa;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("ssa720ukrvService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class Ssa720ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	/**getGsBillYN
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  getGsBillYN(Map param) throws Exception {	
		return  super.commonDao.list("ssa720ukrvServiceImpl.getGsBillYN", param); 
	}
	
	
	/**영업담당 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getSalesPrsn(Map param) throws Exception {
		return super.commonDao.list("ssa720ukrvServiceImpl.getSalesPrsn", param);
	}
	
	/**
	 * 
	 * 세금계산서정보검색 조회(웹캐시)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWebCashMaster(Map param) throws Exception {
		return super.commonDao.list("ssa720ukrvServiceImpl.selectWebCashMaster", param);
	}

	/**
	 * 
	 * getErrMsg
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getErrMsg(Map param) throws Exception {
		return super.commonDao.select("ssa720ukrvServiceImpl.getErrMsg", param);
	}

	
	/**
	 * 전자세금계산서 저장(Web Cash)
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAllWebCash(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		String keyValue	= getLogKey();	
//		String oprFlag	= (String)dataMaster.get("OPR_FLAG");			//로그테이블에 insert한 값만 사용
		String unitOpt	= (String)dataMaster.get("UNIT_OPT");
		String langType	= (String)dataMaster.get("LANG_TYPE");
		Map<String, Object> spParam = new HashMap<String, Object>();

		
		if(paramList != null)	{
			for(Map param: paramList) {
				if(param.get("method").equals("saveWebCash")) {
					dataList = (List<Map>)param.get("data");
					param.put("data", saveWebCash(dataList, paramMaster, user, keyValue) );	
				} 
			}
			
			//SP호출 값 세팅
			spParam.put("COMP_CODE"	, user.getCompCode());
			spParam.put("KEY_VALUE"	, keyValue);
//			spParam.put("OPR_FLAG"	, oprFlag);								//로그테이블에 insert한 값만 사용
			spParam.put("UNIT_OPT"	, unitOpt);
			spParam.put("LANG_TYPE"	, langType);
			spParam.put("LOGIN_ID"	, user.getUserID());
			spParam.put("ERROR_DESC", "");
			
			super.commonDao.update("ssa720ukrvServiceImpl.execWebCash", spParam);
			
			String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc)){				
				String messsage = errorDesc.replaceAll("\\;", "");
				throw new  UniDirectValidateException(this.getMessage(messsage, user));
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  saveWebCash(List<Map> paramList, Map paramMaster, LoginVO user, String keyValue) throws Exception {
		for(Map param : paramList)	{
			param.put("KEY_VALUE", keyValue);			
			super.commonDao.update("ssa720ukrvServiceImpl.saveWebCash", param);	
		}
		return  paramList;
	}
}
