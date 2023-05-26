package foren.unilite.modules.base.bpr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("bpr501ukrvService")
public class Bpr501ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 그리드1 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "accnt")
    public UniTreeNode selectList(Map param) throws Exception {     
        /**
        *1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)!
        *2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함.
        *3. id와 parentId는 필수 !
        *4. 최상의 node는 parentId가 root로 지정 되어야 함.
        */
        List<GenericTreeDataMap> menuList = super.commonDao.list("bpr501ukrvService.selectList", param);
        return UniTreeHelper.makeTreeAndGetRootNode( menuList);
    }
	
	/**
     * 그리드2 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList2(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bpr501ukrvService.selectList2", param);
    }
    
    /**
     * 그리드3 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList3(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bpr501ukrvService.selectList3", param);
    }
	
    /**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")                
     @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
     public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
         
         if(paramList != null)  {
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
     
     @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
        public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
            try {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List<Map>) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
                for(Map param : paramList ) {            
                    for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("bpr501ukrvService.insertDetail", param);
                    }
                }   
            }catch(Exception e){
                throw new  UniDirectValidateException(this.getMessage("2627", user));
            }
            
            return 0;
        }   
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List<Map>) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
             for(Map param :paramList ) {   
                 for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     super.commonDao.update("bpr501ukrvService.updateDetail", param);
                 }
             }
             return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
             for(Map param :paramList ) {   
                 for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     super.commonDao.update("bpr501ukrvService.deleteDetail", param);
                 }
             }
             return 0;
        }

     
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")                
         @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
         public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
             
             if(paramList != null)  {
                    List<Map> insertList = null;
                    List<Map> updateList = null;
                    List<Map> deleteList = null;
                    for(Map dataListMap: paramList) {
                        if(dataListMap.get("method").equals("deleteDetail2")) {
                            deleteList = (List<Map>)dataListMap.get("data");
                        }else if(dataListMap.get("method").equals("insertDetail2")) {       
                            insertList = (List<Map>)dataListMap.get("data");
                        } else if(dataListMap.get("method").equals("updateDetail2")) {
                            updateList = (List<Map>)dataListMap.get("data");    
                        } 
                    }           
                    if(deleteList != null) this.deleteDetail2(deleteList, user);
                    if(insertList != null) this.insertDetail2(insertList, user);
                    if(updateList != null) this.updateDetail2(updateList, user);                
                }
                paramList.add(0, paramMaster);
                    
                return  paramList;
        }
         
         @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
            public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {     
                try {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    List<Map> chkList = (List<Map>) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
                    for(Map param : paramList ) {            
                        for(Map checkCompCode : chkList) {
                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                             super.commonDao.update("bpr501ukrvService.insertDetail2", param);
                        }
                    }   
                }catch(Exception e){
                    throw new  UniDirectValidateException(this.getMessage("2627", user));
                }
                
                return 0;
            }   
            
            @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
            public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List<Map>) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
                 for(Map param :paramList ) {   
                     for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("bpr501ukrvService.updateDetail2", param);
                     }
                 }
                 return 0;
            } 
            
            
            @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
            public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List) super.commonDao.list("bpr501ukrvService.checkCompCode", compCodeMap);
                 for(Map param :paramList ) {   
                     for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("bpr501ukrvService.deleteDetail2", param);
                     }
                 }
                 return 0;
            } 

}
