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



@Service("s_afb740ukrkocisService")
public class S_Afb740ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	
	/**
     * 이체결의 subGrid 관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectSubList1(Map param) throws Exception {
        return super.commonDao.list("s_afb740ukrkocisServiceImpl.selectSubList1", param);
    }
	
	/**
     * 이체결의 search
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_afb740ukrkocisServiceImpl.selectList", param);
    }
	
	
	
	/**
     * 결재요청전 결재상태 체크 관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> beforeCheckRequest(Map param) throws Exception {
        return super.commonDao.list("s_afb740ukrkocisServiceImpl.beforeCheckRequest", param);
    }
    
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object beforeUpdateRequest (Map param, LoginVO user) throws Exception {

        return super.commonDao.update("s_afb740ukrkocisServiceImpl.beforeUpdateRequest", param);
       
    }
    
    
	/**
	 * 이체결의
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {
		
		return super.commonDao.select("s_afb740ukrkocisServiceImpl.selectForm", param);
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

	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Afb740ukrkocisModel param, LoginVO user,  BindingResult result) throws Exception {

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
                refParam.put("TB_ID","AFB740T");
                refParam.put("S_COMP_CODE",user.getCompCode());
                refParam.put("S_DEPT_CODE",user.getDeptCode());
                refParam.put("AC_YYYY",param.getAC_YYYY());
//                Map createIdx = (Map) super.commonDao.select("kocisCommonService.fnGetIdx", refParam);
//                param.setIDX(ObjUtils.getSafeString(createIdx.get("IDX")));
                
                
    		    Map createDocNo = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.fnGetDocNo", refParam);
    		    param.setDOC_NO(ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
    			super.commonDao.insert("s_afb740ukrkocisServiceImpl.insertForm", param);
    			
    			
    			/**
    			 * AFB510T 저장 관련 로직
    			 */
    			
			    Map<String, Object> tempParam1 = new HashMap<String, Object>();
                
                tempParam1.put("S_COMP_CODE", user.getCompCode());
                tempParam1.put("S_USER_ID", user.getUserID());
                tempParam1.put("S_DEPT_CODE", user.getDeptCode());
                
                
                tempParam1.put("EX_DATE", param.getEX_DATE());
                tempParam1.put("BUDG_CODE", param.getBUDG_CODE());
                tempParam1.put("ACCT_NO", param.getREF_ACCT_NO());
                tempParam1.put("AC_GUBUN", param.getAC_GUBUN());

                tempParam1.put("BUDG_TRANSFER_I", (-1 * ObjUtils.parseDouble(param.getEX_AMT())));
                tempParam1.put("BUDG_FOR_AMT_I", (-1 * ObjUtils.parseDouble(param.getCURR_AMT())));

                super.commonDao.update("s_afb740ukrkocisServiceImpl.updateAFB510T", tempParam1);
    			
    			
    			
    			
    			
    			
//    			param.setBUDG_YYYYMM(param.getEX_DATE().substring(0,6));
			    Map checkAFB510T = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.checkAFB510T", param);

                param.setBUDG_TRANSFER_I(param.getEX_AMT());
                param.setBUDG_FOR_AMT_I(param.getCURR_AMT());
                
    	        if(ObjUtils.isEmpty(checkAFB510T)){
    	            super.commonDao.insert("s_afb740ukrkocisServiceImpl.insertAFB510T", param);
    	        }else{
    	            super.commonDao.update("s_afb740ukrkocisServiceImpl.updateAFB510T", param);
    	        }
    			
    			
    			
    		}else if(param.getSAVE_FLAG().equals("U")){
    		    
		        Map checkAFB740T = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.checkAFB740T", param);
                
                if(!checkAFB740T.get("AP_STS").equals("0")){
                    throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
                }
                
    			super.commonDao.update("s_afb740ukrkocisServiceImpl.updateForm", param);
    			
    		}else if(param.getSAVE_FLAG().equals("D")){
    		    
    		    
    		    Map checkAFB740T = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.checkAFB740T", param);
                
                if(!checkAFB740T.get("AP_STS").equals("0")){
                    throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
                }
                
    		    
    		    
                
                Map<String, Object> tempParam1 = new HashMap<String, Object>();
                
                tempParam1.put("S_COMP_CODE", user.getCompCode());
                tempParam1.put("S_USER_ID", user.getUserID());
                tempParam1.put("S_DEPT_CODE", user.getDeptCode());
                
                
                tempParam1.put("EX_DATE", param.getEX_DATE());
                tempParam1.put("BUDG_CODE", param.getBUDG_CODE());
                tempParam1.put("ACCT_NO", param.getREF_ACCT_NO());
                tempParam1.put("AC_GUBUN", param.getAC_GUBUN());

                tempParam1.put("BUDG_TRANSFER_I", ObjUtils.parseDouble(param.getEX_AMT()));
                tempParam1.put("BUDG_FOR_AMT_I", ObjUtils.parseDouble(param.getCURR_AMT()));

                super.commonDao.update("s_afb740ukrkocisServiceImpl.updateAFB510T", tempParam1);
                
    		    
                Map<String, Object> tempParam2 = new HashMap<String, Object>();
                
                tempParam2.put("S_COMP_CODE", user.getCompCode());
                tempParam2.put("S_USER_ID", user.getUserID());
                tempParam2.put("S_DEPT_CODE", user.getDeptCode());
                
                
                tempParam2.put("EX_DATE", param.getEX_DATE());
                tempParam2.put("BUDG_CODE", param.getBUDG_CODE());
                tempParam2.put("ACCT_NO", param.getACCT_NO());
                tempParam2.put("AC_GUBUN", param.getAC_GUBUN());

                tempParam2.put("BUDG_TRANSFER_I", (-1 * ObjUtils.parseDouble(param.getEX_AMT())));
                tempParam2.put("BUDG_FOR_AMT_I", (-1 * ObjUtils.parseDouble(param.getCURR_AMT())));

                super.commonDao.update("s_afb740ukrkocisServiceImpl.updateAFB510T", tempParam2);
    		    
    			super.commonDao.delete("s_afb740ukrkocisServiceImpl.deleteForm", param);
    			
/*			    param.setBUDG_YYYYMM(param.getAC_DATE().substring(0,6));
                Map checkAFB510T = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.checkAFB510T", param);
    			
			    Map<String, Object> newParam = new HashMap<String, Object>();
                
			    newParam.put("S_USER_ID",user.getUserID());
                newParam.put("S_COMP_CODE",user.getCompCode());
                newParam.put("S_DEPT_CODE",user.getDeptCode());
                
                newParam.put("BUDG_YYYYMM", param.getBUDG_YYYYMM());
                newParam.put("BUDG_CODE", param.getBUDG_CODE());
                newParam.put("ACCT_NO", param.getACCT_NO());
                
                newParam.put("BUDG_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_I")) - ObjUtils.parseDouble(param.getWON_AMT()));
                newParam.put("BUDG_CONF_I", ObjUtils.parseDouble(checkAFB510T.get("BUDG_CONF_I")) - ObjUtils.parseDouble(param.getWON_AMT()));
                
                super.commonDao.update("s_afb740ukrkocisServiceImpl.updateAFB510T_NEW", newParam);
    			
    			*/
    		}
    		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		extResult.addResultProperty("DOC_NO", ObjUtils.getSafeString(param.getDOC_NO()));
		return extResult;
	}
	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object updateDC (Map param, LoginVO user) throws Exception {
        
        Object objRtn = "";
        
        Map beforeCheckUpdateDC = (Map) super.commonDao.select("s_afb740ukrkocisServiceImpl.beforeCheckUpdateDC", param);
        if(ObjUtils.isNotEmpty(beforeCheckUpdateDC)){
            if(beforeCheckUpdateDC.get("GW_STATUS").equals("1")){
                super.commonDao.update("s_afb740ukrkocisServiceImpl.updateDC", param);
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
