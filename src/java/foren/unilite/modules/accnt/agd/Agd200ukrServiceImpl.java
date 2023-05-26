package foren.unilite.modules.accnt.agd;

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
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("agd200ukrService")
public class Agd200ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")			// 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("agd200ukrServiceImpl.selectList", param);
	}
	
	
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> insertList = null;

            for(Map dataListMap: paramList) {
            	logger.debug("method : "+ dataListMap.get("method"));
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }

            }           
            if(insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        return  paramList;
    }
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        List<Map> dataList = new ArrayList<Map>();
        String keyValue = getLogKey(); 
        
        if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: paramList) {
					paramData.put("KEY_VALUE", keyValue);		
					super.commonDao.update("agd200ukrServiceImpl.insertLog", paramData);	
				}
			}
			//SP 호출
			if("D".equals(ObjUtils.getSafeString(dataMaster.get("OPR_FLAG"))))	{
				cancButton(paramMaster, keyValue, user);
			}
			if("N".equals(ObjUtils.getSafeString(dataMaster.get("OPR_FLAG"))))	{
				procButton(paramMaster, keyValue, user);
			}
		}
    
    }
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object procButton(Map paramMaster, String keyValue, LoginVO user) throws Exception {

		Object r = null;
		Map dataMasterMap = (Map) paramMaster.get("data");
        dataMasterMap.put("KEY_VALUE", keyValue);
        dataMasterMap.put("DIV_CODE", dataMasterMap.get("ACCNT_DIV_CODE"));
        
		// 입력일
		String sysDate = (String) super.commonDao.select("agd200ukrServiceImpl.getSystemDate", null);
		dataMasterMap.put("INPUT_DATE", sysDate);
        
		//회계담당자코드
		/*Map chargeParam = new HashMap();
        chargeParam.put("S_COMP_CODE", user.getCompCode());
        chargeParam.put("S_USER_ID", user.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(chargeParam);
        if (ObjUtils.isNotEmpty(chargeMap)) {
        	dataMasterMap.put("CHARGE_CODE", chargeMap.get("CHARGE_CODE"));
        }*/
        dataMasterMap.put("CALL_PATH","LIST");
		super.commonDao.queryForObject("agd200ukrServiceImpl.agd200ukrDo", dataMasterMap);
		//Map<String, Object>	rMap = (Map<String, Object>) r;
		String sErr = ObjUtils.getSafeString(dataMasterMap.get("ERROR_DESC"));
		if(ObjUtils.isNotEmpty(sErr))	{
			String ebyn_message = ObjUtils.getSafeString(dataMasterMap.get("EBYN_MESSAGE"));
			if(!"FALSE".equals(ebyn_message))	{	//@EBYN_MESSAGE (OUTPUT)  TRUE:메세지띄움, FALSE:메세지안띄움
				throw new UniDirectValidateException(this.getMessage(sErr, user));
			}
		} 
		return r;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")		// 실행
	public Object cancButton(Map paramMaster, String keyValue, LoginVO user) throws Exception {
		Object r = null;
		Map dataMasterMap = (Map) paramMaster.get("data");
        dataMasterMap.put("KEY_VALUE", keyValue);
        logger.debug(" ACCNT_DIV_CODE : "+dataMasterMap.get("ACCNT_DIV_CODE"));
        dataMasterMap.put("DIV_CODE", dataMasterMap.get("ACCNT_DIV_CODE"));
		// 입력일
		String sysDate = (String) super.commonDao.select("agd200ukrServiceImpl.getSystemDate", null);
		dataMasterMap.put("INPUT_DATE", sysDate);
        
		//회계담당자코드
		/*Map chargeParam = new HashMap();
        chargeParam.put("S_COMP_CODE", user.getCompCode());
        chargeParam.put("S_USER_ID", user.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(chargeParam);
        if (ObjUtils.isNotEmpty(chargeMap)) {
        	dataMasterMap.put("CHARGE_CODE", chargeMap.get("CHARGE_CODE"));
        }*/
		dataMasterMap.put("CALL_PATH","List");
		 super.commonDao.queryForObject("agd200ukrServiceImpl.agd200ukrCancel", dataMasterMap);
		//Map<String, Object>	rMap = (Map<String, Object>) r;
		String sErr = ObjUtils.getSafeString(dataMasterMap.get("ERROR_DESC"));
		if(ObjUtils.isNotEmpty(sErr))	{
			throw new UniDirectValidateException(this.getMessage(sErr, user));
		}
		
		return r;
	}
}
