package foren.unilite.modules.z_kocis;

import java.text.SimpleDateFormat;
import java.util.Date;
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

@Service("s_afb530ukrkocisService")
public class S_Afb530ukrkocisServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 메인 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("s_afb530ukrkocisServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 예산참조 조회
	public List<Map<String, Object>>  selectRefPopup(Map param) throws Exception {	
		return  super.commonDao.list("s_afb530ukrkocisServiceImpl.selectRefPopup", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 저장전 마감여부 체크
	public List<Map<String, Object>>  selectBudgCloseFg(Map param) throws Exception {	
		return  super.commonDao.list("s_afb530ukrkocisServiceImpl.selectBudgCloseFg", param);
	}

	
	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kocis")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        Map<String, Object> tempParam = new HashMap<String, Object>();
        
        tempParam.put("S_COMP_CODE", user.getCompCode());
        tempParam.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
        tempParam.put("AC_YYYY", ObjUtils.getSafeString(dataMaster.get("IWALL_YYYYMM")).substring(0, 4));
        tempParam.put("monthValue", ObjUtils.getSafeString(dataMaster.get("IWALL_YYYYMM")).substring(4, 6));
        
        Map fnCheckCloseDate = (Map) super.commonDao.select("kocisCommonService.fnCheckCloseMonth", tempParam);

        if(ObjUtils.isEmpty(fnCheckCloseDate)){
            throw new  UniDirectValidateException("마감정보가 없습니다. 확인해 주십시오.");
            
        }
        
        if(fnCheckCloseDate.get("CLOSE_MM").equals("Y") || fnCheckCloseDate.get("CLOSE_YYYY").equals("Y")){
            throw new  UniDirectValidateException("마감된 년월 입니다. 마감정보를 확인해 주십시오.");
        }
        
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
            if(deleteList != null) this.deleteDetail(deleteList, user,paramMaster);
            if(insertList != null) this.insertDetail(insertList, user,paramMaster);
            if(updateList != null) this.updateDetail(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void  insertDetail(List<Map> paramList, LoginVO user,Map paramMaster) throws Exception {      
//        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            
            for(Map param : paramList ) {
                
                Map<String, Object> tempParam1 = new HashMap<String, Object>();

                tempParam1.put("S_COMP_CODE", user.getCompCode());
                tempParam1.put("DEPT_CODE", dataMaster.get("DEPT_CODE"));
                tempParam1.put("TEMP_YYYY", ObjUtils.getSafeString(dataMaster.get("IWALL_YYYYMM")).substring(0, 4));
                tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
                tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
                tempParam1.put("AC_GUBUN", param.get("AC_GUBUN"));
                
                Map fnCheckBudgTotI = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnCheckBudgTotI", tempParam1);
                
                if(ObjUtils.isEmpty(fnCheckBudgTotI)){
                    throw new  UniDirectValidateException("예산편성 정보가 없습니다. 확인해 주십시오.");
                    
                }
                double checkBudgTotI = 0.0;
                double iwallAmtI = 0.0;
                
                checkBudgTotI = ObjUtils.parseDouble(fnCheckBudgTotI.get("BUDG_TOT_I"));
                
                iwallAmtI = ObjUtils.parseDouble(param.get("IWALL_AMT_I"));
                
                if(iwallAmtI > checkBudgTotI){

                    throw new  UniDirectValidateException(this.getMessage("54381", user));
                    
                }else{
                    
                    
                    Date tempD = new Date();
                    SimpleDateFormat today = new SimpleDateFormat("yyyyMMdd");
                    param.put("IWALL_DATE", today.format(tempD));
                    
                    
                    Map fnCheckAFB530T = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnCheckAFB530T", param);
                    
                    if(ObjUtils.isNotEmpty(fnCheckAFB530T)){
                        
                        param.put("DOC_NO", fnCheckAFB530T.get("DOC_NO"));
                        
                        Map<String, Object> refParam = new HashMap<String, Object>();
                        
                        refParam.put("S_COMP_CODE",user.getCompCode());
                        refParam.put("S_DEPT_CODE",user.getDeptCode());
                        refParam.put("DOC_NO",fnCheckAFB530T.get("DOC_NO"));
                        Map fnGetSeq = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnGetSeq", refParam);
                        
                        param.put("SEQ", fnGetSeq.get("SEQ"));
                        

                        super.commonDao.insert("s_afb530ukrkocisServiceImpl.insertDetail", param);

                        super.commonDao.update("s_afb530ukrkocisServiceImpl.updateAFB510T", param);
                        
//                        if(fnCheckAFB530T.get("STATUS").equals("0")){
                            
//                            super.commonDao.update("s_afb530ukrkocisServiceImpl.updateDetail", param);
                            
//                            super.commonDao.update("s_afb530ukrkocisServiceImpl.updateAFB510T", param);
                            
//                        }else{
//                            throw new  UniDirectValidateException("해당 예산과목이 이월/불용 작업이 진행되었습니다. 확인해주십시오.");
//                        }
                    }else{
                    
//                        Date tempD = new Date();
//                        SimpleDateFormat today = new SimpleDateFormat("yyyyMMdd");
//                        param.put("IWALL_DATE", today.format(tempD));
                        
                        
                        Map<String, Object> refParam = new HashMap<String, Object>();
                        refParam.put("S_COMP_CODE",user.getCompCode());
                        refParam.put("S_DEPT_CODE",user.getDeptCode());
                        refParam.put("BUDG_GUBUN",param.get("BUDG_GUBUN"));
                        refParam.put("AC_YYYY", ObjUtils.getSafeString(dataMaster.get("IWALL_YYYYMM")).substring(0, 4));
                        
                        Map createDocNo = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnGetDocNo", refParam);
                        param.put("DOC_NO", ObjUtils.getSafeString(createDocNo.get("DOC_NO")));
                        
                        Map<String, Object> refParam2 = new HashMap<String, Object>();
                        refParam2.put("S_COMP_CODE",user.getCompCode());
                        refParam2.put("S_DEPT_CODE",user.getDeptCode());
                        refParam2.put("DOC_NO",param.get("DOC_NO"));
                        Map fnGetSeq = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnGetSeq", refParam2);
                        
                        param.put("SEQ", fnGetSeq.get("SEQ"));
                        
                        
                        super.commonDao.insert("s_afb530ukrkocisServiceImpl.insertDetail", param);
                        
                        super.commonDao.update("s_afb530ukrkocisServiceImpl.updateAFB510T", param);
                        
                    }
                }
            }   
            
//        }catch(Exception e){
//            throw new  UniDirectValidateException(this.getMessage("2627", user));
//        }
        return ;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void deleteDetail(List<Map> paramList,  LoginVO user,Map paramMaster) throws Exception {
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
         for(Map param :paramList ) {
             
             Map fnCheckAFB530T2 = (Map) super.commonDao.select("s_afb530ukrkocisServiceImpl.fnCheckAFB530T2", param);
             
             if(ObjUtils.isNotEmpty(fnCheckAFB530T2)){
                 
                 if(fnCheckAFB530T2.get("STATUS").equals("0")){
                     try {
                         super.commonDao.delete("s_afb530ukrkocisServiceImpl.deleteDetail", param);
                         
                         param.put("IWALL_AMT_I", -1 * ObjUtils.parseDouble(param.get("IWALL_AMT_I")));
                         
                         super.commonDao.update("s_afb530ukrkocisServiceImpl.updateAFB510T", param);
                       
                     }catch(Exception e) {
                         throw new  UniDirectValidateException(this.getMessage("547",user));
                     }
                 }else{
                     throw new  UniDirectValidateException("해당 예산과목이 이월/불용 작업이 진행되었습니다. 확인해주십시오.");
                 }
             }
         }
         return ;
    }
    
}
	
	