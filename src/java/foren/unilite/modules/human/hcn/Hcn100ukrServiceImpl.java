package foren.unilite.modules.human.hcn;

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

@Service("hcn100ukrService")
public class Hcn100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
     * 부서장, 관리자 구분 관련
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hcn")
    public Object checkCnlnGrp(Map param) throws Exception {
        return super.commonDao.select("hcn100ukrServiceImpl.checkCnlnGrp", param);
    }
	/**
	 * 상담내역조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hcn", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hcn100ukrServiceImpl.selectList", param);
    }
	

	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hcn")
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
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hcn")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {
            
            Map fnGetCnlnSeq = (Map) super.commonDao.select("hcn100ukrServiceImpl.fnGetCnlnSeq", param);
            
            param.put("CNLN_SEQ", fnGetCnlnSeq.get("CNLN_SEQ"));
            super.commonDao.insert("hcn100ukrServiceImpl.insertDetail", param);
        }   
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hcn")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            super.commonDao.update("hcn100ukrServiceImpl.updateDetail", param);
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hcn")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {

             super.commonDao.delete("hcn100ukrServiceImpl.deleteDetail", param);
         }
         return;
    }
    
}
