package foren.unilite.modules.accnt.afn;

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



@Service("afn310ukrService")
public class Afn310ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 어음명세
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("afn310ukrService.selectList", param);
	}

	
	
	/**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            
            spParam.put("CompCode", user.getCompCode());
            spParam.put("ExecDate",dataMaster.get("EXEC_DATE")); 
            spParam.put("LangCode", user.getLanguage());
            spParam.put("UserId", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAfn310Ukr", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new Exception(errorDesc);
            }
            
            
        } catch(Exception e) {
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
        
        paramList.add(0, paramMaster);
        return  paramList;
    }
    

}
