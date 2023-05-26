package foren.unilite.modules.z_kocis;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;



@Service("s_afb950ukrkocisService")
public class S_Afb950ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	/**
     * 출납공무원 지불한도잔액(계좌별)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_kocis" )
    public Object fnGetBudgTotI( Map param ) throws Exception {
        return super.commonDao.select("s_afb950ukrkocisServiceImpl.fnGetBudgTotI", param);
    }
	
	/**
     * search
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "z_kocis", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_afb950ukrkocisServiceImpl.selectList", param);
    }
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_kocis")
	public ExtDirectFormPostResult syncMaster(S_Afb950ukrkocisModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_DEPT_CODE(user.getDeptCode());
		
		Map<String, Object> tempParam = new HashMap<String, Object>();
		
		tempParam.put("S_COMP_CODE", user.getCompCode());
        tempParam.put("DEPT_CODE", param.getS_DEPT_CODE());
        tempParam.put("AC_YYYY", param.getACC_YYYY());
        tempParam.put("monthValue", param.getACC_MM());
        
        Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", tempParam);

        if(ObjUtils.isEmpty(fnCheckCloseDate)){
            throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
        }
        
        if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
            throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
        }
		
		
    		if(param.getSAVE_FLAG().equals("") || param.getSAVE_FLAG().equals("N")){
    			
    		    Map<String, Object> refParam = new HashMap<String, Object>();
                refParam.put("S_COMP_CODE",user.getCompCode());
                refParam.put("S_DEPT_CODE",user.getDeptCode());
                refParam.put("ACC_YYYY",param.getACC_YYYY());
                
                Map createDocNo = (Map) super.commonDao.select("s_afb950ukrkocisServiceImpl.fnGetDocNo", refParam);
                param.setDOC_NO(ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
                
    			super.commonDao.insert("s_afb950ukrkocisServiceImpl.insertForm", param);
    			
    		}else if(param.getSAVE_FLAG().equals("U")){

    			super.commonDao.update("s_afb950ukrkocisServiceImpl.updateForm", param);
    		}else if(param.getSAVE_FLAG().equals("D")){
    		    
    			super.commonDao.delete("s_afb950ukrkocisServiceImpl.deleteForm", param);
    			
    		}
    		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		extResult.addResultProperty("DOC_NO", ObjUtils.getSafeString(param.getDOC_NO()));
		return extResult;
	}
		
}
