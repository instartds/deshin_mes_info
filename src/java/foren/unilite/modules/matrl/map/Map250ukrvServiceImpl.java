package foren.unilite.modules.matrl.map;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
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

@Service("map250ukrvService")
public class Map250ukrvServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("map250ukrvServiceImpl.selectList", param);
	}

	/**
	 * 
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
		if(paramList != null && paramList.size() > 0)  {
            List<Map> updateList = null;
            for(Map dataListMap: paramList) {
            	String oprFlag = "N";
    			if(dataListMap.get("method").equals("updateList"))	oprFlag="U";
    			updateList = (List<Map>) dataListMap.get("data");
    			if("U".equals(oprFlag)){//
    				if(updateList!=null && updateList.size()>0){
    					for(Map param : updateList){
    						if("true".equals(param.get("CHK"))){
	            				param.put("KEY_VALUE", keyValue);
	            				param.put("OPR_FLAG",oprFlag);
	            				param.put("data", super.commonDao.insert("map250ukrvServiceImpl.insertLogMaster", param));
    						}
            			}
    				}
    				
    			}
    			
                
            }           
        }
		//4.접수등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		spParam.put("LANG_CODE", user.getLanguage());
		spParam.put("ERROR_DESC", "");
		
		super.commonDao.queryForObject("spMap250ukrv", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map>  updateList(List<Map> params,LoginVO user) throws Exception {
		for(Map param: params){
			super.commonDao.update("map250ukrvServiceImpl.update", param);
		}
		return  params;
	}
}