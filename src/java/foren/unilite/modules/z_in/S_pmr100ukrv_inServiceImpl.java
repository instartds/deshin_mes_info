package foren.unilite.modules.z_in;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.prodt.pmp.Pmp160ukrvModel;


@Service("s_pmr100ukrv_inService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class S_pmr100ukrv_inServiceImpl extends TlabAbstractServiceImpl {
    	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
    
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 작업지시조회
    	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList", param);
    	}
    	// END OF 작업실적등록
        
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 작업지시번호별등록 조회
    	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList2", param);
    	}
    	// END OF 작업지시번호별등록 조회    	
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
    	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList3", param);
    	}
    	// END OF 공정별등록 조회1
    		
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회2
    	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList4", param);
    	}
    	// END OF 공정별등록2
    	
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
    	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList5", param);
    	}
    	// END OF 불량내역등록
    	
    	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
    	public List<Map<String, Object>> selectDetailList6(Map param) throws Exception {
    		return super.commonDao.list("s_pmr100ukrv_inServiceImpl.selectDetailList6", param);
    	}
    	// END OF 특이사항등록
    	
    	/**
         *  detail2 저장(작지번호별)
         * 
         * @param param
         * @return
         * @throws Exception
         */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
        public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramDetail:" + paramList);
              
            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail2")) oprFlag="U";
                if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";
           
                for(Map param:  dataList) {

                    Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                    Map<String, Object> spParam = new HashMap<String, Object>();
                    SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
                    Date dateGet = new Date ();
                    String dateGetString = dateFormat.format(dateGet);
                    
                    String prodtNum = (String) dataMaster.get("PRODT_NUM");
                    spParam.put("COMP_CODE", user.getCompCode());            
                    spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                    spParam.put("TABLE_ID","PMR100T");
                    spParam.put("PREFIX", "P");
                    spParam.put("BASIS_DATE", dateGetString);
                    spParam.put("AUTO_TYPE", "1");

                    param.put("PRODT_TYPE",  "2");  // (1: 공정별, 2: 작지별, 3: ......)
                    param.put("STATUS",     oprFlag);
                    param.put("USER_ID",    user.getUserID());                                        
                    
                    if(param.get("STATUS").equals("N")) {
                        //자동채번
                        super.commonDao.queryForObject("s_pmr100ukrv_inServiceImpl.spAutoNum", spParam);
                        prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                        param.put("PRODT_NUM",  prodtNum);
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.insertDetail2", param);
                    } else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {                        
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateDetail2", param);
                    } 
                    if(param.get("STATUS").equals("D")) {
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.deleteDetail2", param);
                    }

                    param.put("COMP_CODE", user.getCompCode());
                    param.put("DIV_CODE", param.get("DIV_CODE"));
                    param.put("PRODT_NUM", param.get("PRODT_NUM"));
                    param.put("WKORD_NUM", param.get("WKORD_NUM"));
                    
                    param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
                    param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
                    param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
                    param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_PRODT_Q")));
                    
                    
                    param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
                    param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
                    param.put("BAD_PRSN", param.get("BAD_PRSN"));
                    param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_PRODT_Q")));
                    param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));   
                    
                    
                    super.commonDao.update("s_pmr100ukrv_inServiceImpl.spReceiving", param);
                    String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
                    if(!ObjUtils.isEmpty(errorDesc)) {
//                        String[] messsage = errorDesc.split(";");
                        throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                    } 
                    
                    dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
                }
            }
            
            paramList.add(0, paramMaster);
            return  paramList;
       }
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
       public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
       public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       
       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
           
           return 0;
       }
    	
    	
    	
    	/**
         *  detail3 저장(공정별)
         * 
         * @param param
         * @return
         * @throws Exception
         */
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
        public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramDetail:" + paramList);
              
            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail3")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail3")) oprFlag="N";
                if(paramData.get("method").equals("deleteDetail3")) oprFlag="D";
           
                for(Map param:  dataList) {

                    Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                    Map<String, Object> spParam = new HashMap<String, Object>();
                    SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
                    Date dateGet = new Date ();
                    String dateGetString = dateFormat.format(dateGet);
                    
                    String prodtNum = (String) dataMaster.get("PRODT_NUM");
                    spParam.put("COMP_CODE", user.getCompCode());            
                    spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                    spParam.put("TABLE_ID","PMR100T");
                    spParam.put("PREFIX", "P");
                    spParam.put("BASIS_DATE", dateGetString);
                    spParam.put("AUTO_TYPE", "1");

                    param.put("PRODT_TYPE",  "1");       // (1: 공정별, 2: 작지별, 3: ......)
                    param.put("STATUS",     oprFlag);
                    param.put("USER_ID",    user.getUserID());                    

                    if(param.get("STATUS").equals("N")) {
                        //자동채번
                        super.commonDao.queryForObject("s_pmr100ukrv_inServiceImpl.spAutoNum", spParam);
                        prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                        param.put("PRODT_NUM",  prodtNum);
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.insertDetail3", param);
                        
                        //금형테이블에 사용SHOT update관련
                        if(ObjUtils.isNotEmpty(param.get("MOLD_CODE")) && ObjUtils.parseInt(param.get("CAVIT_BASE_Q")) > 0 ){

                     	   param.put("PASS_Q",  ObjUtils.parseDouble(param.get("PASS_Q")));
                     	   param.put("CAVIT_BASE_Q",  ObjUtils.parseDouble(param.get("CAVIT_BASE_Q")));
                            super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateMoldPlus", param);
                        
                        }
                        
                        
                    } else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {                        
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateDetail3", param);
                    } 
                    
                    param.put("COMP_CODE", user.getCompCode());
                    param.put("DIV_CODE", param.get("DIV_CODE"));
                    param.put("PRODT_NUM", param.get("PRODT_NUM"));
                    param.put("WKORD_NUM", param.get("WKORD_NUM"));
                    param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
//                    param.put("STATUS", param.get("FLAG"));
                    param.put("USER_ID", user.getUserID());
            /*        if(param.get("LINE_END_YN").equals("Y")) {	
                        param.put("GOOD_Q", param.get("GOOD_WORK_Q"));
                        param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
                        param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
                        param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
                        param.put("BAD_Q", param.get("BAD_WORK_Q"));
                        param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
                        param.put("BAD_PRSN", param.get("BAD_PRSN"));
                        param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
                    } else {
                        param.put("GOOD_WH_CODE", "");
                        param.put("GOOD_WH_CELL_CODE", "");
                        param.put("GOOD_PRSN", "");
                        param.put("GOOD_Q", zero);
                        param.put("BAD_WH_CODE", "");
                        param.put("BAD_WH_CELL_CODE", "");
                        param.put("BAD_PRSN", "");
                        param.put("BAD_Q", zero);
                    }*/
                    param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
                    param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
                    
                    super.commonDao.update("s_pmr100ukrv_inServiceImpl.spReceiving", param);
                    String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
                    if(!ObjUtils.isEmpty(errorDesc)) {
//                        String[] messsage = errorDesc.split(";");
                        throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                    } 
/*                  //공정별 등록 그리드는 삭제로직 없음
                    if(param.get("STATUS").equals("D")) {
                        super.commonDao.update("s_pmr100ukrv_inServiceImpl.deleteDetail3", param);
                    }*/
                    dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
                }
            }
            
            paramList.add(0, paramMaster);
            return  paramList;
       }
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
       public Integer insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
       public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       
       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
           
           return 0;
       }
       

       @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
       @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
       public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
           logger.debug("[saveAll] paramDetail:" + paramList);
           Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
           
           
           List<Map> dataList = new ArrayList<Map>();
           for(Map paramData: paramList) {   
               dataList = (List<Map>) paramData.get("data");
               String oprFlag = "N";
               if(paramData.get("method").equals("insertDetail4")) oprFlag="N";
               if(paramData.get("method").equals("updateDetail4")) oprFlag="U";
               if(paramData.get("method").equals("deleteDetail4")) oprFlag="D";
          
               for(Map param:  dataList) {
            	 //금형테이블에 사용SHOT update관련
                   if(ObjUtils.isNotEmpty(dataMaster.get("MOLD_CODE")) && ObjUtils.parseInt(dataMaster.get("CAVIT_BASE_Q")) > 0 ){

                	   param.put("PASS_Q",  ObjUtils.parseDouble(param.get("PASS_Q")));
                	   param.put("CAVIT_BASE_Q",  ObjUtils.parseDouble(dataMaster.get("CAVIT_BASE_Q")));
                	   param.put("MOLD_CODE", dataMaster.get("MOLD_CODE"));
                       super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateMoldMinus", param);
                   
                   }
            	   
                   super.commonDao.update("s_pmr100ukrv_inServiceImpl.deleteDetail3", param);

                   param.put("COMP_CODE"		, user.getCompCode());
                   param.put("DIV_CODE"			, param.get("DIV_CODE"));
                   param.put("PRODT_NUM"		, param.get("PRODT_NUM"));
                   param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
                   param.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
                   param.put("PRODT_TYPE"		, "1");
                   param.put("STATUS"			, oprFlag);
                   param.put("USER_ID"			, user.getUserID());
                   param.put("GOOD_Q"			, ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
                   param.put("BAD_Q"			, ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
                   
                   super.commonDao.update("s_pmr100ukrv_inServiceImpl.spReceiving", param);
                   String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
                   if(!ObjUtils.isEmpty(errorDesc)) {
                       String[] messsage = errorDesc.split(";");
                       throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
                   } 
                   dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
               }
           }

           paramList.add(0, paramMaster);
           return  paramList;
      }
      
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
      public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
          
          return 0;
      } 
      
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
      public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
          
          return 0;
      } 
      
      
      @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
      public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
          
          return 0;
      }
      

      /**
       *  detail5 저장 (불량)
       * 
       * @param param
       * @return
       * @throws Exception
       */      
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")              
      @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
      public List<Map> saveAll5(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
          
          if(paramList != null)  {
                 List<Map> insertList = null;
                 List<Map> updateList = null;
                 List<Map> deleteList = null;
                 for(Map dataListMap: paramList) {
                     if(dataListMap.get("method").equals("deleteDetail5")) {
                         deleteList = (List<Map>)dataListMap.get("data");
                     }else if(dataListMap.get("method").equals("insertDetail5")) {       
                         insertList = (List<Map>)dataListMap.get("data");
                     } else if(dataListMap.get("method").equals("updateDetail5")) {
                         updateList = (List<Map>)dataListMap.get("data");    
                     } 
                 }           
                 if(deleteList != null) this.deleteDetail5(deleteList, user);
                 if(insertList != null) this.insertDetail5(insertList, user);
                 if(updateList != null) this.updateDetail5(updateList, user);                
             }
             
        	Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
         	Map errorMap = (Map) super.commonDao.select("s_pmr100ukrv_inServiceImpl.spBadResultMoving", dataMaster);

             if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
                 String errorDesc = (String) errorMap.get("errorDesc");
                 String[] messsage = errorDesc.split(";");
                 throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
             }
             
        	 paramList.add(0, paramMaster);
             return  paramList;
     }
      
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")     // INSERT
      public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {     
          for(Map param : paramList ) {            
              super.commonDao.update("s_pmr100ukrv_inServiceImpl.insertDetail5", param);
          } 
          return 0;
      }   
         
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")      // UPDATE
      public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
    	  Map checkParam = paramList.get(0); 
     		List<Map> beforeSaveCheck = (List<Map>) super.commonDao.list("s_pmr100ukrv_inServiceImpl.beforeSaveCheck", checkParam);

     		if(beforeSaveCheck != null && beforeSaveCheck.size() > 0){
     			for(Map param :paramList )	{	
    				 super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateDetail5", param);
     			}
  		}else{
  			try {			
  	       		for(Map param : paramList )	{
  	   				super.commonDao.update("s_pmr100ukrv_inServiceImpl.insertDetail5", param);
  	   			}    			
  	   		}catch(Exception e){
  	   			throw new  UniDirectValidateException(this.getMessage("2627", user));
  	   		} 
  		}
     		 return 0;
      } 
         
         
      @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
      public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
          for(Map param :paramList ) {   
              super.commonDao.update("s_pmr100ukrv_inServiceImpl.deleteDetail5", param);
          }
          return 0;
      } 
      
      /**
       *  detail6 저장 (특이)
       * 
       * @param param
       * @return
       * @throws Exception
       */  
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")              
      @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
      public List<Map> saveAll6(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
          
          if(paramList != null)  {
                 List<Map> insertList = null;
                 List<Map> updateList = null;
                 List<Map> deleteList = null;
                 for(Map dataListMap: paramList) {
                     if(dataListMap.get("method").equals("deleteDetail6")) {
                         deleteList = (List<Map>)dataListMap.get("data");
                     }else if(dataListMap.get("method").equals("insertDetail6")) {       
                         insertList = (List<Map>)dataListMap.get("data");
                     } else if(dataListMap.get("method").equals("updateDetail6")) {
                         updateList = (List<Map>)dataListMap.get("data");    
                     } 
                 }           
                 if(deleteList != null) this.deleteDetail6(deleteList, user);
                 if(insertList != null) this.insertDetail6(insertList, user);
                 if(updateList != null) this.updateDetail6(updateList, user);                
             }
             paramList.add(0, paramMaster);
                 
             return  paramList;
     }
      
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")     // INSERT
      public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {     
          for(Map param : paramList ) {            
              super.commonDao.update("s_pmr100ukrv_inServiceImpl.insertDetail6", param);
          } 
          return 0;
      }   
         
      @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")      // UPDATE
      public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
          for(Map param :paramList ) {   
              super.commonDao.update("s_pmr100ukrv_inServiceImpl.updateDetail6", param);
          }
          return 0;
      } 
         
         
      @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
      public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
          for(Map param :paramList ) {   
              super.commonDao.update("s_pmr100ukrv_inServiceImpl.deleteDetail6", param);
          }
          return 0;
      } 
}
