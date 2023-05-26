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



@Service("s_afb730ukrkocisService")
public class S_Afb730ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	
	/**
     * 결의서 리스트
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "z_kocis", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
        return super.commonDao.list("s_afb730ukrkocisServiceImpl.selectDetailList", param);
    }
    
	
	/**
     * 세출예산등록 search
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "z_kocis", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_afb730ukrkocisServiceImpl.selectList", param);
    }
	
	
	
	/**
     * 결재요청전 결재상태 체크 관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "z_kocis", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> beforeCheckRequest(Map param) throws Exception {
        return super.commonDao.list("s_afb730ukrkocisServiceImpl.beforeCheckRequest", param);
    }
    
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object beforeUpdateRequest (Map param, LoginVO user) throws Exception {

        return super.commonDao.update("s_afb730ukrkocisServiceImpl.beforeUpdateRequest", param);
       
    }
    
    
	/**
	 * 채권등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_kocis")
	public Object selectForm(Map param) throws Exception {
		
		return super.commonDao.select("s_afb730ukrkocisServiceImpl.selectForm", param);
		/*if(param.get("RE_REFERENCE").equals("Y")){
			return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
		}else{
			if( super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param) == null){
				return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
			}else{
				return super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param);
			}
		}*/
	}
	
	/**
	 * 이관 및 진행 정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_kocis")
	public Object selectForm2(Map param) throws Exception {
		return super.commonDao.select("s_afb730ukrkocisServiceImpl.selectForm2", param);
	}
	


	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_kocis")
	public ExtDirectFormPostResult syncMaster(S_Afb730ukrkocisModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_DEPT_CODE(user.getDeptCode());
		
	    param.setAC_YYYY(param.getEX_DATE().substring(0,4));
	    
	    Map<String, Object> checkParam = new HashMap<String, Object>();
        checkParam.put("S_COMP_CODE", user.getCompCode());
        checkParam.put("DEPT_CODE", user.getDeptCode());
        checkParam.put("AC_YYYY", param.getAC_YYYY());
        checkParam.put("monthValue", ObjUtils.getSafeString(param.getEX_DATE()).substring(4, 6));
        
        Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", checkParam);

        if(ObjUtils.isEmpty(fnCheckCloseDate)){
            throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
            
        }
        
        if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
            throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
        }
        
		
    		if(param.getSAVE_FLAG().equals("") || param.getSAVE_FLAG().equals("N")){
    			
    		    Map<String, Object> refParam = new HashMap<String, Object>();
                refParam.put("TB_ID","AFB730T");
                refParam.put("S_COMP_CODE",user.getCompCode());
                refParam.put("S_DEPT_CODE",user.getDeptCode());
                refParam.put("AC_YYYY",param.getAC_YYYY());
//                Map createIdx = (Map) super.commonDao.select("kocisCommonService.fnGetIdx", refParam);
//                param.setIDX(ObjUtils.parseInt(createIdx.get("IDX")));
                
                
                Map createDocNo = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.fnGetDocNo", refParam);
                param.setDOC_NO(ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
    			super.commonDao.insert("s_afb730ukrkocisServiceImpl.insertForm", param);
    			
    			
    			/**
    			 * AFB510T 저장 관련 로직
    			 */
    	/*		
    			
    			param.setBUDG_YYYYMM(param.getAC_DATE().substring(0,6));
			    Map checkAFB510T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB510T", param);
			    
    	        if(ObjUtils.isEmpty(checkAFB510T)){
    	            param.setBUDG_I(param.getWON_AMT());
    	            param.setBUDG_CONF_I(param.getWON_AMT());
    	            super.commonDao.insert("s_afb730ukrkocisServiceImpl.insertAFB510T", param);
    	        }else{
    	            param.setBUDG_I(ObjUtils.parseDouble(checkAFB510T.get("BUDG_I")) + ObjUtils.parseDouble(param.getWON_AMT()));
                    param.setBUDG_CONF_I(ObjUtils.parseDouble(checkAFB510T.get("BUDG_CONF_I")) + ObjUtils.parseDouble(param.getWON_AMT()));
    	            super.commonDao.update("s_afb730ukrkocisServiceImpl.updateAFB510T_NEW", param);
    	        }
    			
    			*/
    			
    		}else if(param.getSAVE_FLAG().equals("U")){
    		    
  /*  		    param.setBUDG_YYYYMM(param.getAC_DATE().substring(0,6));
    		    
                Map checkAFB510T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB510T", param);
    		    
    		    
    		    Map checkAFB503T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB503T", param);
//    		    checkAFB503T.get("BUDG_CODE")
//              checkAFB503T.get("WON_AMT")
    		    
    		    Map<String, Object> newParam = new HashMap<String, Object>();
    		    
    		    newParam.put("S_USER_ID",user.getUserID());
    		    newParam.put("S_COMP_CODE",user.getCompCode());
    		    newParam.put("S_DEPT_CODE",user.getDeptCode());
    		    
    		    newParam.put("BUDG_YYYYMM", param.getBUDG_YYYYMM());
                newParam.put("BUDG_CODE", param.getBUDG_CODE());
                newParam.put("ACCT_NO", param.getACCT_NO());
                
                newParam.put("BUDG_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_I")) - ObjUtils.parseDouble(checkAFB503T.get("WON_AMT")) + ObjUtils.parseDouble(param.getWON_AMT()));
                newParam.put("BUDG_CONF_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_CONF_I")) - ObjUtils.parseDouble(checkAFB503T.get("WON_AMT")) + ObjUtils.parseDouble(param.getWON_AMT()));
    		    
                
                
                super.commonDao.update("s_afb730ukrkocisServiceImpl.updateAFB510T_NEW", newParam);*/
                
                /*
    		    Map<String, Object> oldParam = new HashMap<String, Object>();     //이전값은  -
    		    oldParam.put("BUDG_YYYYMM", param.getBUDG_YYYYMM());
    		    oldParam.put("BUDG_CODE", param.getBUDG_CODE());
    		    oldParam.put("ACCT_NO", param.getACCT_NO());
    		    
    		    oldParam.put("BUDG_I", param.getWON_AMT());
                oldParam.put("BUDG_CONF_I", "");
    		    
    		    super.commonDao.update("s_afb730ukrkocisServiceImpl.updateAFB510T_OLD", oldParam);
    		    
    		    Map<String, Object> newParam = new HashMap<String, Object>();     //새로입력한 값은 해당 코드에 +
    		    newParam.put("BUDG_YYYYMM", param.getBUDG_YYYYMM());
    		    newParam.put("BUDG_CODE", param.getBUDG_CODE());
    		    newParam.put("ACCT_NO", param.getACCT_NO());
                
    		    newParam.put("BUDG_I", "");
    		    newParam.put("BUDG_CONF_I", "");
                
    		    super.commonDao.update("s_afb730ukrkocisServiceImpl.updateAFB510T_NEW", newParam);*/
		        Map checkAFB730T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB730T", param);
                
                if(!checkAFB730T.get("STATUS").equals("0")){
                    throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
                }
    		    
    			super.commonDao.update("s_afb730ukrkocisServiceImpl.updateForm", param);
    		}else if(param.getSAVE_FLAG().equals("D")){
    		    
		        Map checkAFB730T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB730T", param);
                
                if(!checkAFB730T.get("STATUS").equals("0")){
                    throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
                }
                
    			super.commonDao.delete("s_afb730ukrkocisServiceImpl.deleteForm", param);
    			
		/*	    param.setBUDG_YYYYMM(param.getAC_DATE().substring(0,6));
                Map checkAFB510T = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.checkAFB510T", param);
    			
			    Map<String, Object> newParam = new HashMap<String, Object>();
                
			    newParam.put("S_USER_ID",user.getUserID());
                newParam.put("S_COMP_CODE",user.getCompCode());
                newParam.put("S_DEPT_CODE",user.getDeptCode());
                
                newParam.put("BUDG_YYYYMM", param.getBUDG_YYYYMM());
                newParam.put("BUDG_CODE", param.getBUDG_CODE());
                newParam.put("ACCT_NO", param.getACCT_NO());
                
                newParam.put("BUDG_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_I")) - ObjUtils.parseDouble(param.getWON_AMT()));
                newParam.put("BUDG_CONF_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_CONF_I")) - ObjUtils.parseDouble(param.getWON_AMT()));
                
                super.commonDao.update("s_afb730ukrkocisServiceImpl.updateAFB510T_NEW", newParam);
    			*/
    			
    		}
    		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		extResult.addResultProperty("DOC_NO", ObjUtils.getSafeString(param.getDOC_NO()));
		return extResult;
	}
	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object updateDC (Map param, LoginVO user) throws Exception {
        
        Object objRtn = "";
        
        Map beforeCheckUpdateDC = (Map) super.commonDao.select("s_afb730ukrkocisServiceImpl.beforeCheckUpdateDC", param);
        if(ObjUtils.isNotEmpty(beforeCheckUpdateDC)){
            if(beforeCheckUpdateDC.get("GW_STATUS").equals("1")){
                super.commonDao.update("s_afb730ukrkocisServiceImpl.updateDC", param);
            }else{
                String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                String errMessage = "기안중취소 처리할 수 없습니다.\n상태 : " + beforeCheckUpdateDC.get("CODE_NAME");
                errMessage = errMessage.replace("\n",line);
                objRtn = errMessage;
            }
        }
        
        return objRtn;
    }
	
	
}
