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

@Service("s_afb570ukrkocisService")
public class S_Afb570ukrkocisServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 메인 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("s_afb570ukrkocisServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 예산참조 조회
	public List<Map<String, Object>>  selectRefPopup(Map param) throws Exception {	
		return  super.commonDao.list("s_afb570ukrkocisServiceImpl.selectRefPopup", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		// 저장전 마감여부 체크
	public List<Map<String, Object>>  selectBudgCloseFg(Map param) throws Exception {	
		return  super.commonDao.list("s_afb570ukrkocisServiceImpl.selectBudgCloseFg", param);
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
            if(deleteList != null) this.deleteDetail(deleteList, user,paramMaster);
            if(insertList != null) this.insertDetail(insertList, user,paramMaster);
            if(updateList != null) this.updateDetail(updateList, user);             
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void  insertDetail(List<Map> paramList, LoginVO user,Map paramMaster) throws Exception {      
        
        return ;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            Date tempD = new Date();
            SimpleDateFormat today = new SimpleDateFormat("yyyyMMdd");
            param.put("PROCESS_DATE", today.format(tempD));
            
            super.commonDao.update("s_afb570ukrkocisServiceImpl.updateDetail", param);
            
            if(param.get("PROCESS_YN").equals("N")){ // 승인이 처음 일시 
                
                Map<String, Object> tempParam1 = new HashMap<String, Object>();

                String tempYYYY = String.valueOf(param.get("BUDG_YYYY"));
                
                tempParam1.put("S_COMP_CODE", user.getCompCode());
                tempParam1.put("S_USER_ID", user.getUserID());
                tempParam1.put("DEPT_CODE", param.get("DEPT_CODE"));
                tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
                tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
                tempParam1.put("BUDG_YYYYMM", tempYYYY + "01");
                tempParam1.put("BUDG_GUBUN", '1');

                Map fnCheckBudgI = (Map) super.commonDao.select("s_afb570ukrkocisServiceImpl.fnCheckBudgI", tempParam1);
                
                if(ObjUtils.isEmpty(fnCheckBudgI)){
                    throw new  UniDirectValidateException("예산편성 정보가 없습니다. 확인해 주십시오.");
                }else{
                    tempParam1.put("BUDG_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_I")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I"))));
                    tempParam1.put("BUDG_CONF_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_CONF_I")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I"))));
                    tempParam1.put("BUDG_IWALL_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_IWALL_I")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I"))));
                }
                super.commonDao.update("s_afb570ukrkocisServiceImpl.updateAFB510T", tempParam1);
                
                Map<String, Object> tempParam2 = new HashMap<String, Object>();
                
                String tempYYYY1 = String.valueOf(ObjUtils.parseInt(param.get("BUDG_YYYY")) + 1);
                String tempYYYY2 = String.valueOf(param.get("BUDG_YYYY"));
                tempParam2.put("S_COMP_CODE", user.getCompCode());
                tempParam2.put("S_USER_ID", user.getUserID());
                tempParam2.put("BUDG_YYYYMM1", tempYYYY1 + "01");
                tempParam2.put("BUDG_YYYYMM2", tempYYYY2 + "01");
                tempParam2.put("DEPT_CODE", param.get("DEPT_CODE"));
                tempParam2.put("ACCT_NO", param.get("ACCT_NO"));
                tempParam2.put("BUDG_CODE", param.get("BUDG_CODE"));
                tempParam2.put("BUDG_GUBUN", '3');
                tempParam2.put("BUDG_I", param.get("CONF_AMT_I"));
                tempParam2.put("BUDG_CONF_I", param.get("CONF_AMT_I"));
                tempParam2.put("BUDG_IWALL_I", 0);
                
                super.commonDao.insert("s_afb570ukrkocisServiceImpl.insertAFB510T", tempParam2);
                
            }else{
                Map<String, Object> tempParam1 = new HashMap<String, Object>();
                
                String tempYYYY = String.valueOf(param.get("BUDG_YYYY"));
                
                tempParam1.put("S_COMP_CODE", user.getCompCode());
                tempParam1.put("S_USER_ID", user.getUserID());
                tempParam1.put("DEPT_CODE", param.get("DEPT_CODE"));
                tempParam1.put("ACCT_NO", param.get("ACCT_NO"));
                tempParam1.put("BUDG_CODE", param.get("BUDG_CODE"));
                tempParam1.put("BUDG_YYYYMM", tempYYYY + "01");
                tempParam1.put("BUDG_GUBUN", '1');
                
                Map fnCheckBudgI = (Map) super.commonDao.select("s_afb570ukrkocisServiceImpl.fnCheckBudgI", tempParam1);
                
                if(ObjUtils.isEmpty(fnCheckBudgI)){
                    throw new  UniDirectValidateException("예산편성 정보가 없습니다. 확인해 주십시오.");
                }else{
                    tempParam1.put("BUDG_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_I")) + (ObjUtils.parseDouble(param.get("CONF_AMT_I_DUMMY")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I")))));
                    tempParam1.put("BUDG_CONF_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_CONF_I")) + (ObjUtils.parseDouble(param.get("CONF_AMT_I_DUMMY")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I")))));
                    tempParam1.put("BUDG_IWALL_I", ObjUtils.parseDouble(fnCheckBudgI.get("BUDG_IWALL_I")) + (ObjUtils.parseDouble(param.get("CONF_AMT_I_DUMMY")) + (-1 * ObjUtils.parseDouble(param.get("CONF_AMT_I")))));
                }
                        
                super.commonDao.update("s_afb570ukrkocisServiceImpl.updateAFB510T", tempParam1);
                
                Map<String, Object> tempParam2 = new HashMap<String, Object>();
                
                String tempYYYY1 =  String.valueOf(ObjUtils.parseInt(param.get("BUDG_YYYY")) + 1);
                
                tempParam2.put("S_COMP_CODE", user.getCompCode());
                tempParam2.put("S_USER_ID", user.getUserID());
                tempParam2.put("DEPT_CODE", param.get("DEPT_CODE"));
                tempParam2.put("ACCT_NO", param.get("ACCT_NO"));
                tempParam2.put("BUDG_CODE", param.get("BUDG_CODE"));
                tempParam2.put("BUDG_YYYYMM", tempYYYY1 + "01");
                tempParam2.put("BUDG_I", param.get("CONF_AMT_I"));
                tempParam2.put("BUDG_CONF_I", param.get("CONF_AMT_I"));
                tempParam2.put("BUDG_IWALL_I", 0);
                tempParam2.put("BUDG_GUBUN", '3');
                
                super.commonDao.update("s_afb570ukrkocisServiceImpl.updateAFB510T", tempParam2);
            }
        }
        return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
    public void deleteDetail(List<Map> paramList,  LoginVO user,Map paramMaster) throws Exception {
       
         return ;
    }
    
}
	
	