package foren.unilite.modules.accnt.axt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.multipart.MultipartFile;



import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
//import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
//import foren.framework.utils.FileUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
//import foren.unilite.modules.com.fileman.FileMnagerService;
//import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("axt150ukrService")
public class Axt150ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		
		logger.debug("============================= 조회========================");
		param.put("COMP_CODE", user.getCompCode());
		
		String stRegDate = (String) param.get("REG_MONTH") + "01" ;
		String endRegDate = (String) param.get("REG_MONTH") + "31" ;

		logger.debug("stRegDate : " + stRegDate);
		logger.debug("endRegDate : " + endRegDate);
		
		param.put("ST_REG_DATE", stRegDate);
		param.put("END_REG_DATE", endRegDate);
		
		return (List<Map<String, Object>>) super.commonDao.list("axt150ukrServiceImpl.selectList", param);
	}

	
	/**
     * 
     * 마지막 행 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public Object  getOldData(Map param, LoginVO user) throws Exception {
    	
    	logger.debug("=============================마지막 행 조회========================");
    	
    	param.put("COMP_CODE", user.getCompCode());
		
        return  super.commonDao.select("axt150ukrServiceImpl.getOldData", param);
    }
	
    /**
     *  저장
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
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
               for(Map param : paramList ) {            
                   super.commonDao.update("axt150ukrServiceImpl.insertDetail", param);
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
           for(Map param :paramList ) {   
               super.commonDao.update("axt150ukrServiceImpl.updateDetail", param);
           }
           return 0;
       } 
       
       
       @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
       public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
           Map compCodeMap = new HashMap();
           compCodeMap.put("S_COMP_CODE", user.getCompCode());
           for(Map param :paramList ) {   
               super.commonDao.update("axt150ukrServiceImpl.deleteDetail", param);
           }
           return 0;
   } 
	
}
