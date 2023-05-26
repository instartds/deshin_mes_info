package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_afb520ukrkocisService")
public class S_Afb520ukrkocisServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 메인 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("s_afb520ukrkocisServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 탭 조회(예산조정, 당겨배정, 예산전용, 추경예산)
	public List<Map<String, Object>>  selectDetailList(Map param) throws Exception {	
		return  super.commonDao.list("s_afb520ukrkocisServiceImpl.selectDetailList", param);
	}
	
	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kocis")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetail")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetail(deleteList, user);
            if(insertList != null) this.insertDetail(insertList, user);
            if(updateList != null) this.updateDetail(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
        try {
            for(Map param : paramList ) {
                
                Map<String, Object> tempParam = new HashMap<String, Object>();
                
                tempParam.put("S_COMP_CODE", user.getCompCode());
                tempParam.put("DEPT_CODE", param.get("DEPT_CODE"));
                tempParam.put("AC_YYYY", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(0, 4));
                tempParam.put("monthValue", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(4, 6));
                
                Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", tempParam);

                if(ObjUtils.isEmpty(fnCheckCloseDate)){
                    throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
                }
                
                if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
                    throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
                }
                
                
                Map<String, Object> checkParam = new HashMap<String, Object>();

                checkParam.put("S_COMP_CODE", user.getCompCode());
                checkParam.put("DEPT_CODE", param.get("DEPT_CODE"));
                checkParam.put("BUDG_YYYYMM", param.get("BUDG_YYYYMM"));
                checkParam.put("BUDG_CODE", param.get("BUDG_CODE"));
                checkParam.put("ACCT_NO", param.get("ACCT_NO"));
                
                Map fnCheckBudgTotI = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.fnCheckBudgTotI", checkParam);
                
                if(ObjUtils.isEmpty(fnCheckBudgTotI)){
                    throw new  UniDirectValidateException("예산편성 정보가 없습니다. 확인해 주십시오.");
                    
                }
                
                
                double checkBudgTotI = 0.0;
                double divertBudgI = 0.0;
                
                checkBudgTotI = ObjUtils.parseDouble(fnCheckBudgTotI.get("BUDG_TOT_I"));
                
                divertBudgI = ObjUtils.parseDouble(param.get("DIVERT_BUDG_I"));
                
                if(divertBudgI > checkBudgTotI){

                    throw new  UniDirectValidateException("조정가능 금액을 초과하였습니다.");
                    
                }else{
                
                    if(ObjUtils.isEmpty(param.get("DOC_NO"))){
                    
                        Map<String, Object> refParam = new HashMap<String, Object>();
                        
                        refParam.put("S_COMP_CODE",user.getCompCode());
                        refParam.put("S_DEPT_CODE",user.getDeptCode());
                        refParam.put("AC_YYYY", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(0, 4));
                        Map createDocNo = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.fnGetDocNo", refParam);
        
                        refParam.put("DOC_NO",ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
                        Map fnGetSeq = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.fnGetSeq", refParam);
                        
                        param.put("DOC_NO",ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
                        param.put("SEQ",fnGetSeq.get("SEQ"));
                    
                    }else{
    
                        Map<String, Object> refParam2 = new HashMap<String, Object>();
    
                        refParam2.put("S_COMP_CODE",user.getCompCode());
                        refParam2.put("S_DEPT_CODE",user.getDeptCode());
                        
                        refParam2.put("DOC_NO",ObjUtils.getSafeString(param.get("DOC_NO")));
                        Map fnGetSeq = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.fnGetSeq", refParam2);
                        param.put("SEQ",fnGetSeq.get("SEQ"));
                    }
                    
                    
                    Map<String, Object> tempParam1 = new HashMap<String, Object>();
                    
                    tempParam1.put("S_COMP_CODE", user.getCompCode());
                    tempParam1.put("S_USER_ID", user.getUserID());
                    tempParam1.put("S_DEPT_CODE", user.getDeptCode());
                    
                    tempParam1.put("BUDG_YYYYMM", param.get("BUDG_YYYYMM"));
                    tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
                    tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
                    tempParam1.put("AC_GUBUN", param.get("AC_GUBUN"));
    
                    tempParam1.put("BUDG_ASGN_I", (-1 * ObjUtils.parseDouble(param.get("DIVERT_BUDG_I"))));
    
                    super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam1);
                    
                    
                    Map<String, Object> tempParam2 = new HashMap<String, Object>();
                    
                    tempParam2.put("S_COMP_CODE", user.getCompCode());
                    tempParam2.put("S_USER_ID", user.getUserID());
                    tempParam2.put("S_DEPT_CODE", user.getDeptCode());
                             
                    tempParam2.put("BUDG_YYYYMM", param.get("DIVERT_YYYYMM"));
                    tempParam2.put("BUDG_CODE", param.get("DIVERT_BUDG_CODE"));
                    tempParam2.put("ACCT_NO", param.get("ACCT_NO"));
                    tempParam2.put("AC_GUBUN", param.get("AC_GUBUN"));
                    
                    tempParam2.put("BUDG_ASGN_I", ObjUtils.parseDouble(param.get("DIVERT_BUDG_I")));
                             
                    Map checkAFB510T = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.checkAFB510T", tempParam2);
                    
                    if(ObjUtils.isEmpty(checkAFB510T)){
                        super.commonDao.insert("s_afb520ukrkocisServiceImpl.insertAFB510T", tempParam2);
                    }else{
                        super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam2);
                    }
                    
                    super.commonDao.insert("s_afb520ukrkocisServiceImpl.insertDetail", param);
                }
            }   
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            Map<String, Object> tempParam = new HashMap<String, Object>();
            
            tempParam.put("S_COMP_CODE", user.getCompCode());
            tempParam.put("DEPT_CODE", param.get("DEPT_CODE"));
            tempParam.put("AC_YYYY", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(0, 4));
            tempParam.put("monthValue", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(4, 6));
            
            Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", tempParam);

            if(ObjUtils.isEmpty(fnCheckCloseDate)){
                throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
            }
            
            if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
                throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
            }
            
            
            Map checkAFB520T = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.checkAFB520T", param);
            
            if(!checkAFB520T.get("AP_STS").equals("0")){
                throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
            }
            
            
            Map<String, Object> tempParam1 = new HashMap<String, Object>();
            
            tempParam1.put("S_COMP_CODE", user.getCompCode());
            tempParam1.put("S_USER_ID", user.getUserID());
            tempParam1.put("S_DEPT_CODE", user.getDeptCode());
                     
            tempParam1.put("BUDG_YYYYMM", param.get("BUDG_YYYYMM"));
            tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
            tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
            tempParam1.put("AC_GUBUN", param.get("AC_GUBUN"));
                     
            tempParam1.put("BUDG_ASGN_I", ObjUtils.parseDouble(checkAFB520T.get("DIVERT_BUDG_I")));
                     
            super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam1);
            
            Map<String, Object> tempParam2 = new HashMap<String, Object>();
            
            tempParam2.put("S_COMP_CODE", user.getCompCode());
            tempParam2.put("S_USER_ID", user.getUserID());
            tempParam2.put("S_DEPT_CODE", user.getDeptCode());
            
            tempParam2.put("BUDG_YYYYMM", param.get("BUDG_YYYYMM"));
            tempParam2.put("BUDG_CODE", param.get("BUDG_CODE"));
            tempParam2.put("ACCT_NO", param.get("ACCT_NO"));
            tempParam2.put("AC_GUBUN", param.get("AC_GUBUN"));

            tempParam2.put("BUDG_ASGN_I", (-1 * ObjUtils.parseDouble(param.get("DIVERT_BUDG_I"))));

            super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam2);
            
            Map<String, Object> tempParam3 = new HashMap<String, Object>();
            
            tempParam3.put("S_COMP_CODE", user.getCompCode());
            tempParam3.put("S_USER_ID", user.getUserID());
            tempParam3.put("S_DEPT_CODE", user.getDeptCode());
                     
            tempParam3.put("BUDG_YYYYMM", param.get("DIVERT_YYYYMM"));
            tempParam3.put("BUDG_CODE", checkAFB520T.get("DIVERT_BUDG_CODE"));
            tempParam3.put("ACCT_NO", param.get("ACCT_NO"));
            tempParam3.put("AC_GUBUN", param.get("AC_GUBUN"));
                     
            tempParam3.put("BUDG_ASGN_I", (-1 * ObjUtils.parseDouble(checkAFB520T.get("DIVERT_BUDG_I"))));
                     
            super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam3);
            
            
            
            Map<String, Object> tempParam4 = new HashMap<String, Object>();
            
            tempParam4.put("S_COMP_CODE", user.getCompCode());
            tempParam4.put("S_USER_ID", user.getUserID());
            tempParam4.put("S_DEPT_CODE", user.getDeptCode());
                     
            tempParam4.put("BUDG_YYYYMM", param.get("DIVERT_YYYYMM"));
            tempParam4.put("BUDG_CODE", param.get("DIVERT_BUDG_CODE"));
            tempParam4.put("ACCT_NO", param.get("ACCT_NO"));
            tempParam4.put("AC_GUBUN", param.get("AC_GUBUN"));
                     
            tempParam4.put("BUDG_ASGN_I", ObjUtils.parseDouble(param.get("DIVERT_BUDG_I")));
            
            Map checkAFB510T = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.checkAFB510T", tempParam4);
            
            if(ObjUtils.isEmpty(checkAFB510T)){
                super.commonDao.insert("s_afb520ukrkocisServiceImpl.insertAFB510T", tempParam4);
            }else{
                super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam4);
            }
            
            
            super.commonDao.update("s_afb520ukrkocisServiceImpl.updateDetail", param);
            
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {
             
             Map<String, Object> tempParam = new HashMap<String, Object>();
             
             tempParam.put("S_COMP_CODE", user.getCompCode());
             tempParam.put("DEPT_CODE", param.get("DEPT_CODE"));
             tempParam.put("AC_YYYY", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(0, 4));
             tempParam.put("monthValue", ObjUtils.getSafeString(param.get("DIVERT_YYYYMM")).substring(4, 6));
             
             Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", tempParam);

             if(ObjUtils.isEmpty(fnCheckCloseDate)){
                 throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
             }
             
             if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
                 throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
             }
             
             
             Map checkAFB520T = (Map) super.commonDao.select("s_afb520ukrkocisServiceImpl.checkAFB520T", param);
             
             if(!checkAFB520T.get("AP_STS").equals("0")){
                 throw new  UniDirectValidateException("결재상태를 확인 해 주십시오.");
             }
             
             Map<String, Object> tempParam1 = new HashMap<String, Object>();
             
             tempParam1.put("S_COMP_CODE", user.getCompCode());
             tempParam1.put("S_USER_ID", user.getUserID());
             tempParam1.put("S_DEPT_CODE", user.getDeptCode());
                      
             tempParam1.put("BUDG_YYYYMM", param.get("BUDG_YYYYMM"));
             tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
             tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
             tempParam1.put("AC_GUBUN", param.get("AC_GUBUN"));
                      
             tempParam1.put("BUDG_ASGN_I", ObjUtils.parseDouble(checkAFB520T.get("DIVERT_BUDG_I")));
                      
             super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam1);
             
             Map<String, Object> tempParam2 = new HashMap<String, Object>();
             
             tempParam2.put("S_COMP_CODE", user.getCompCode());
             tempParam2.put("S_USER_ID", user.getUserID());
             tempParam2.put("S_DEPT_CODE", user.getDeptCode());
                      
             tempParam2.put("BUDG_YYYYMM", param.get("DIVERT_YYYYMM"));
             tempParam2.put("BUDG_CODE", checkAFB520T.get("DIVERT_BUDG_CODE"));
             tempParam2.put("ACCT_NO", param.get("ACCT_NO"));
             tempParam2.put("AC_GUBUN", param.get("AC_GUBUN"));
                      
             tempParam2.put("BUDG_ASGN_I", (-1 * ObjUtils.parseDouble(checkAFB520T.get("DIVERT_BUDG_I"))));
                      
             super.commonDao.update("s_afb520ukrkocisServiceImpl.updateAFB510T", tempParam2);

             super.commonDao.delete("s_afb520ukrkocisServiceImpl.deleteDetail", param);
             
         }
         return;
    }
	
}

