package foren.unilite.modules.accnt.agd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agd150ukrService")
public class Agd150ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	//기간비용 ITEM_CODE 가져오는 부분
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  getItemCode(Map param) throws Exception {
		return  super.commonDao.list("agd150ukrServiceImpl.getItemCode", param);
	}

	
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
/*    @ExtDirectMethod( group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public Map callProcedure(Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> insertList = null;

            for(Map dataListMap: paramList) {
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        return  paramList;
    }*/
    
    @ExtDirectMethod( group = "accnt")
    public Map callProcedure( Map param, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 Key 생성      
        String keyValue	= getLogKey();

        //2.로그테이블에 KEY_VALUE 업데이트
		param.put("KEY_VALUE", keyValue);
        super.commonDao.insert("agd150ukrServiceImpl.insertLogTable", param);
        
        String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
	
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
    	//기표취소이면..
    	if("D".equals(ObjUtils.getSafeString(param.get("OPR_FLAG")))) {
    		super.commonDao.queryForObject("agd150ukrServiceImpl.agd150ukrCancel", param);
    		
    	} else {
    		super.commonDao.queryForObject("agd150ukrServiceImpl.agd150ukrDo", param);
    	}
    	String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
    }	
}
