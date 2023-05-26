package foren.unilite.modules.sales.sgp;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("sgp100ukrvService")
public class Sgp100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	
	/**
     * 공통코드 S022 조회(탭활성화)
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> gsType(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.gsType", param);
    }
	
	
	/**
	 * 고객별 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
	public List<Map> customSelectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp100ukrvService.customSelectList", param);
	}
	
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet1", param);
    }  
	
    public void excelValidate1(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate1", param);		

	}		
	
	
	/**
	 * 영업담당별 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
	public List<Map> salePrsnSelectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp100ukrvService.salePrsnSelectList", param);
	}
	
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet2", param);
    }  
	
    public void excelValidate2(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate2", param);		

	}			
	
	
	/**
	 * 품목별 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
	public List<Map> itemSelectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("sgp100ukrvService.itemSelectList", param);
	}
	
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet3(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet3", param);
    }  
	
    public void excelValidate3(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate3", param);		

	}			
	
	/**
     * 품목분류별 정보 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> itemSortSelectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.itemSortSelectList", param);
    }
    
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet4(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet4", param);
    }  
	
    public void excelValidate4(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate4", param);		

	}		    
    
    /**
     * 대표모델별 정보 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> spokesItemSelectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.spokesItemSelectList", param);
    }
    
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet5(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet5", param);
    }  
	
    public void excelValidate5(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate5", param);		

	}		    
    
    /**
     * 고객품목별 정보 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> customerItemSelectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.customerItemSelectList", param);
    }
    
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet6(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet6", param);
    }  
	
    public void excelValidate6(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate6", param);		

	}		    
    
    /**
     * 판매유형별 정보 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> saleTypeSelectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.saleTypeSelectList", param);
    }
    
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet7(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet7", param);
    }  
	
    public void excelValidate7(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate7", param);		

	}		    
    
	/**
     * 고객품목불류별 정보 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "salse")
    public List<Map> customitemSortSelectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sgp100ukrvService.customitemSortSelectList", param);
    }  
    
//	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.FORM_LOAD)        // 저장전 데이터 체크
//	public Object checkDetail(Map param) throws Exception {
//		return super.commonDao.select("sgp100ukrvService.checkDetail", param);
//	}
	    
    
	@ExtDirectMethod(group = "salse", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet10(Map param) throws Exception {
        return super.commonDao.list("sgp100ukrvService.selectExcelUploadSheet10", param);
    }  
	
    public void excelValidate10(String jobID, Map param) {							// 엑셀 Validate
		super.commonDao.update("sgp100ukrvService.excelValidate10", param);		

	}		
    
    
    /**
     * 고객별 정보
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
	/**저장**/
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
                    } else if(dataListMap.get("method").equals("insertDetail")) {      
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
     
     @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "salse")     // INSERT
        public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
            try {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                for(Map param : paramList ) {            
                    for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("sgp100ukrvService.insertDetail", param);
                    }
                }   
            }catch(Exception e){
                throw new  UniDirectValidateException(this.getMessage("2627", user));
            }
            
            return 0;
        }   
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "salse")      // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
             for(Map param :paramList ) {   
                 for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     super.commonDao.update("sgp100ukrvService.updateDetail", param);
                 }
             }
             return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
            for(Map param :paramList ) {   
                 for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                     if(confirmYn.isEmpty()) {
                         throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                     } else {
                         if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                             throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                         } else {
                             super.commonDao.update("sgp100ukrvService.deleteDetail", param);
                         }
                     }
                 }
             }
             return 0;
        }  
        

        /**
         * 영업담당별 정보
         * @param param
         * @param user
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
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
                    List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                    for(Map param : paramList ) {            
                        for(Map checkCompCode : chkList) {
                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                             super.commonDao.update("sgp100ukrvService.insertDetail2", param);
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
                List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                 for(Map param :paramList ) {   
                     for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("sgp100ukrvService.updateDetail2", param);
                     }
                 }
                 return 0;
            } 
            
            
            @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
            public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                for(Map param :paramList ) {   
                     for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                         if(confirmYn.isEmpty()) {
                             throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                         } else {
                             if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                 throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                             } else {
                                 super.commonDao.update("sgp100ukrvService.deleteDetail2", param);
                             }
                         }
                     }
                 }
                 return 0;
            } 
            
            
            /**
             * 품목별 정보
             * @param param
             * @param user
             * @return
             * @throws Exception
             */
            @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
             @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
             public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                 
                 if(paramList != null)  {
                        List<Map> insertList = null;
                        List<Map> updateList = null;
                        List<Map> deleteList = null;
                        for(Map dataListMap: paramList) {
                            if(dataListMap.get("method").equals("deleteDetail3")) {
                                deleteList = (List<Map>)dataListMap.get("data");
                            }else if(dataListMap.get("method").equals("insertDetail3")) {       
                                insertList = (List<Map>)dataListMap.get("data");
                            } else if(dataListMap.get("method").equals("updateDetail3")) {
                                updateList = (List<Map>)dataListMap.get("data");    
                            } 
                        }           
                        if(deleteList != null) this.deleteDetail3(deleteList, user);
                        if(insertList != null) this.insertDetail3(insertList, user);
                        if(updateList != null) this.updateDetail3(updateList, user);                
                    }
                    paramList.add(0, paramMaster);
                        
                    return  paramList;
            }
             
             @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {     
                    try {
                        Map compCodeMap = new HashMap();
                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                        List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                        for(Map param : paramList ) {            
                            for(Map checkCompCode : chkList) {
                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                 super.commonDao.update("sgp100ukrvService.insertDetail3", param);
                            }
                        }   
                    }catch(Exception e){
                        throw new  UniDirectValidateException(this.getMessage("2627", user));
                    }
                    
                    return 0;
                }   
                
                @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                     for(Map param :paramList ) {   
                         for(Map checkCompCode : chkList) {
                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                             super.commonDao.update("sgp100ukrvService.updateDetail3", param);
                         }
                     }
                     return 0;
                } 
                
                
                @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                     for(Map param :paramList ) {   
                         for(Map checkCompCode : chkList) {
                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                             Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                             if(confirmYn.isEmpty()) {
                                 throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                             } else {
                                 if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                     throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                 } else {
                                     super.commonDao.update("sgp100ukrvService.deleteDetail3", param);
                                 }
                             }
                         }
                     }
                     return 0;
                } 
                
                
                /**
                 * 품목분류별 정보
                 * @param param
                 * @param user
                 * @return
                 * @throws Exception
                 */
                /**저장**/
                @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
                 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
                 public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                     
                     if(paramList != null)  {
                            List<Map> insertList = null;
                            List<Map> updateList = null;
                            List<Map> deleteList = null;
                            for(Map dataListMap: paramList) {
                                if(dataListMap.get("method").equals("deleteDetail4")) {
                                    deleteList = (List<Map>)dataListMap.get("data");
                                } else if(dataListMap.get("method").equals("insertDetail4")) {      
                                    insertList = (List<Map>)dataListMap.get("data");
                                } else if(dataListMap.get("method").equals("updateDetail4")) {
                                    updateList = (List<Map>)dataListMap.get("data");    
                                } 
                            }           
                            if(deleteList != null) this.deleteDetail4(deleteList, user);
                            if(insertList != null) this.insertDetail4(insertList, user);
                            if(updateList != null) this.updateDetail4(updateList, user);             
                        }
                        paramList.add(0, paramMaster);
                            
                        return  paramList;
                    }
                 
                 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                    public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {      
                        try {
                            Map compCodeMap = new HashMap();
                            compCodeMap.put("S_COMP_CODE", user.getCompCode());
                            List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                            for(Map param : paramList ) {            
                                for(Map checkCompCode : chkList) {
                                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                     super.commonDao.update("sgp100ukrvService.insertDetail4", param);
                                }
                            }   
                        }catch(Exception e){
                            throw new  UniDirectValidateException(this.getMessage("2627", user));
                        }
                        
                        return 0;
                    }   
                    
                    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                    public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
                        Map compCodeMap = new HashMap();
                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                        List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                         for(Map param :paramList ) {   
                             for(Map checkCompCode : chkList) {
                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                 super.commonDao.update("sgp100ukrvService.updateDetail4", param);
                             }
                         }
                         return 0;
                    } 
                    
                    @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                    public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
                        Map compCodeMap = new HashMap();
                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                        List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                        for(Map param :paramList ) {   
                             for(Map checkCompCode : chkList) {
                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                 Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                                 if(confirmYn.isEmpty()) {
                                     throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                                 } else {
                                     if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                         throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                     } else {
                                         super.commonDao.update("sgp100ukrvService.deleteDetail4", param);
                                     }
                                 }
                             }
                         }
                         return 0;
                    }                     
                    
                    
                    /**
                     * 대표모델별 정보
                     * @param param
                     * @param user
                     * @return
                     * @throws Exception
                     */
                    /**저장**/
                    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
                     @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
                     public List<Map> saveAll5(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                         
                         if(paramList != null)  {
                                List<Map> insertList = null;
                                List<Map> updateList = null;
                                List<Map> deleteList = null;
                                for(Map dataListMap: paramList) {
                                    if(dataListMap.get("method").equals("deleteDetail5")) {
                                        deleteList = (List<Map>)dataListMap.get("data");
                                    } else if(dataListMap.get("method").equals("insertDetail5")) {      
                                        insertList = (List<Map>)dataListMap.get("data");
                                    } else if(dataListMap.get("method").equals("updateDetail5")) {
                                        updateList = (List<Map>)dataListMap.get("data");    
                                    } 
                                }           
                                if(deleteList != null) this.deleteDetail5(deleteList, user);
                                if(insertList != null) this.insertDetail5(insertList, user);
                                if(updateList != null) this.updateDetail5(updateList, user);             
                            }
                            paramList.add(0, paramMaster);
                                
                            return  paramList;
                        }
                     
                     @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                        public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {      
                            try {
                                Map compCodeMap = new HashMap();
                                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                for(Map param : paramList ) {            
                                    for(Map checkCompCode : chkList) {
                                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                         super.commonDao.update("sgp100ukrvService.insertDetail5", param);
                                    }
                                }   
                            }catch(Exception e){
                                throw new  UniDirectValidateException(this.getMessage("2627", user));
                            }
                            
                            return 0;
                        }   
                        
                        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                        public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
                            Map compCodeMap = new HashMap();
                            compCodeMap.put("S_COMP_CODE", user.getCompCode());
                            List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                             for(Map param :paramList ) {   
                                 for(Map checkCompCode : chkList) {
                                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                     super.commonDao.update("sgp100ukrvService.updateDetail5", param);
                                 }
                             }
                             return 0;
                        } 
                        
                        @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                        public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
                            Map compCodeMap = new HashMap();
                            compCodeMap.put("S_COMP_CODE", user.getCompCode());
                            List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                            for(Map param :paramList ) {   
                                 for(Map checkCompCode : chkList) {
                                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                     Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                                     if(confirmYn.isEmpty()) {
                                         throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                                     } else {
                                         if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                             throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                         } else {
                                             super.commonDao.update("sgp100ukrvService.deleteDetail5", param);
                                         }
                                     }
                                 }
                             }
                             return 0;
                        } 
                        
                        
                        
                        
                        
                        
                        /**
                         * 고객품목별 정보 
                         * @param param
                         * @param user
                         * @return
                         * @throws Exception
                         */
                        /**저장**/
                        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
                         @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
                         public List<Map> saveAll6(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                             
                             if(paramList != null)  {
                                    List<Map> insertList = null;
                                    List<Map> updateList = null;
                                    List<Map> deleteList = null;
                                    for(Map dataListMap: paramList) {
                                        if(dataListMap.get("method").equals("deleteDetail6")) {
                                            deleteList = (List<Map>)dataListMap.get("data");
                                        } else if(dataListMap.get("method").equals("insertDetail6")) {      
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
                         
                         @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                            public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {      
                                try {
                                    Map compCodeMap = new HashMap();
                                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                    List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                    for(Map param : paramList ) {            
                                        for(Map checkCompCode : chkList) {
                                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                             super.commonDao.update("sgp100ukrvService.insertDetail6", param);
                                        }
                                    }   
                                }catch(Exception e){
                                    throw new  UniDirectValidateException(this.getMessage("2627", user));
                                }
                                
                                return 0;
                            }   
                            
                            @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                            public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
                                Map compCodeMap = new HashMap();
                                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                 for(Map param :paramList ) {   
                                     for(Map checkCompCode : chkList) {
                                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                         super.commonDao.update("sgp100ukrvService.updateDetail6", param);
                                     }
                                 }
                                 return 0;
                            } 
                            
                            @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                            public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
                                Map compCodeMap = new HashMap();
                                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                for(Map param :paramList ) {   
                                     for(Map checkCompCode : chkList) {
                                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                         Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                                         if(confirmYn.isEmpty()) {
                                             throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                                         } else {
                                             if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                                 throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                             } else {
                                                 super.commonDao.update("sgp100ukrvService.deleteDetail6", param);
                                             }
                                         }
                                     }
                                 }
                                 return 0;
                            } 
                
                            /**
                             * 판매유형별 정보
                             * @param param
                             * @param user
                             * @return
                             * @throws Exception
                             */
                            /**저장**/
                            @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
                             @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
                             public List<Map> saveAll7(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                                 
                                 if(paramList != null)  {
                                        List<Map> insertList = null;
                                        List<Map> updateList = null;
                                        List<Map> deleteList = null;
                                        for(Map dataListMap: paramList) {
                                            if(dataListMap.get("method").equals("deleteDetail7")) {
                                                deleteList = (List<Map>)dataListMap.get("data");
                                            } else if(dataListMap.get("method").equals("insertDetail7")) {      
                                                insertList = (List<Map>)dataListMap.get("data");
                                            } else if(dataListMap.get("method").equals("updateDetail7")) {
                                                updateList = (List<Map>)dataListMap.get("data");    
                                            } 
                                        }           
                                        if(deleteList != null) this.deleteDetail7(deleteList, user);
                                        if(insertList != null) this.insertDetail7(insertList, user, paramMaster);
                                        if(updateList != null) this.updateDetail7(updateList, user, paramMaster);             
                                    }
                                    paramList.add(0, paramMaster);
                                        
                                    return  paramList;
                                }
                             
                             @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                                public Integer  insertDetail7(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {      
                                    try {
                                        Map compCodeMap = new HashMap();
                                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                        List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                                        for(Map param : paramList ) {            
                                            for(Map checkCompCode : chkList) {
                                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                                 param.put("MONEY_UNIT_DIV", dataMaster.get("MONEY_UNIT_DIV"));
                                                 super.commonDao.update("sgp100ukrvService.insertDetail7", param);
                                            }
                                        }   
                                    }catch(Exception e){
                                        throw new  UniDirectValidateException(this.getMessage("2627", user));
                                    }
                                    
                                    return 0;
                                }   
                                
                                @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                                public Integer updateDetail7(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
                                    Map compCodeMap = new HashMap();
                                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                    List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                    Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
                                     for(Map param :paramList ) {   
                                         for(Map checkCompCode : chkList) {
                                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                             param.put("MONEY_UNIT_DIV", dataMaster.get("MONEY_UNIT_DIV"));
                                             super.commonDao.update("sgp100ukrvService.updateDetail7", param);
                                         }
                                     }
                                     return 0;
                                } 
                                
                                @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                                public Integer deleteDetail7(List<Map> paramList,  LoginVO user) throws Exception {
                                    Map compCodeMap = new HashMap();
                                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                    List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                    for(Map param :paramList ) {   
                                         for(Map checkCompCode : chkList) {
                                             param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                             Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                                             if(confirmYn.isEmpty()) {
                                                 throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                                             } else {
                                                 if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                                     throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                                 } else {
                                                     super.commonDao.update("sgp100ukrvService.deleteDetail7", param);
                                                 }
                                             }
                                         }
                                     }
                                     return 0;
                                }
                
                
                                
                                /**
                                 * 고객품목분류별 정보
                                 * @param param
                                 * @param user
                                 * @return
                                 * @throws Exception
                                 */
                                /**저장**/
                                @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")                
                                 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
                                 public List<Map> saveAll10(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
                                	Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");	
                                     
                                     if(paramList != null)  {
                                            List<Map> insertList = null;
                                            List<Map> updateList = null;
                                            List<Map> deleteList = null;
                                            
                                            for(Map dataListMap: paramList) {
                                                if(dataListMap.get("method").equals("deleteDetail10")) {
                                                    deleteList = (List<Map>)dataListMap.get("data");
                                                } else if(dataListMap.get("method").equals("insertDetail10")) {      
                                                    insertList = (List<Map>)dataListMap.get("data");
                                                } else if(dataListMap.get("method").equals("updateDetail10")) {
                                                    updateList = (List<Map>)dataListMap.get("data");    
                                                } 
                                            }           
                                            if(deleteList != null) this.deleteDetail10(deleteList, user);
                                            if(insertList != null) this.insertDetail10(insertList, user);
                                            if(updateList != null) this.updateDetail10(updateList, user);             
                                        }
                                        paramList.add(0, paramMaster);
                                            
                                        return  paramList;
                                    }
                                 
                                 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
                                    public Integer  insertDetail10(List<Map> paramList, LoginVO user) throws Exception {      
                                        try {
                                            Map compCodeMap = new HashMap();
                                            compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                            List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                            for(Map param : paramList ) {            
                                                for(Map checkCompCode : chkList) {
                                                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                                     super.commonDao.update("sgp100ukrvService.insertDetail10", param);
                                                }
                                            }   
                                        }catch(Exception e){
                                            throw new  UniDirectValidateException(this.getMessage("2627", user));
                                        }
                                        
                                        return 0;
                                    }   
                                    
                                    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
                                    public Integer updateDetail10(List<Map> paramList, LoginVO user) throws Exception {
                                        Map compCodeMap = new HashMap();
                                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                        List<Map> chkList = (List<Map>) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                         for(Map param :paramList ) {   
                                             for(Map checkCompCode : chkList) {
                                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                                 super.commonDao.update("sgp100ukrvService.updateDetail10", param);
                                             }
                                         }
                                         return 0;
                                    } 
                                    
                                    @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
                                    public Integer deleteDetail10(List<Map> paramList,  LoginVO user) throws Exception {
                                        Map compCodeMap = new HashMap();
                                        compCodeMap.put("S_COMP_CODE", user.getCompCode());
                                        List<Map> chkList = (List) super.commonDao.list("sgp100ukrvService.checkCompCode", compCodeMap);
                                        for(Map param :paramList ) {   
                                             for(Map checkCompCode : chkList) {
                                                 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                                                 Map confirmYn = (Map) super.commonDao.queryForObject("sgp100ukrvService.beforeDelete", param);
                                                 if(confirmYn.isEmpty()) {
                                                     throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                                                 } else {
                                                     if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                                                         throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                                                     } else {
                                                         super.commonDao.update("sgp100ukrvService.deleteDetail10", param);
                                                     }
                                                 }
                                             }
                                         }
                                         return 0;
                                    }                 
                
                
  
	
	
	/**
     * 기초데이터생성 - 고객별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatCustomDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatCustomDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 영업담당별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatPersonDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatPersonDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
	
    /**
     * 기초데이터생성 - 품목별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatItemDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatItemDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 품목분류별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatItemSortDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatItemSortDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 대표모델별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatSpokesItemDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatSpokesItemDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 고객품목별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatCustomerItemDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatCustomerItemDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 판매유형별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatSaleTypeDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatSaleTypeDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }
    
    /**
     * 기초데이터생성 - 고객품목분류별
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> creatCustomItemSortDataList(Map param, LoginVO user) throws Exception {
        if(super.commonDao.list("sgp100ukrvService.creatDataList", param).isEmpty()) {
            return super.commonDao.list("sgp100ukrvService.creatCustomItemSortDataList", param);
        } else {
            throw new  UniDirectValidateException(this.getMessage("54454", user)); 
        }
    }     
    
    
    /**
     * 년초계획확정
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt") 
    public void  confirmDataList(Map param, LoginVO user) throws Exception {
        List<Map> confirmYnSelect = (List<Map>) super.commonDao.list("sgp100ukrvService.confirmDataSelect", param);
        String confirmYn = "";
        confirmYn = (String) confirmYnSelect.get(0).get("CONFIRM_YN");
        if(!confirmYnSelect.isEmpty()) {
          if(confirmYn.equals("Y")) {
              throw new  UniDirectValidateException(this.getMessage("54455", user)); 
          } else if(confirmYn.equals("y")) {
              throw new  UniDirectValidateException(this.getMessage("54455", user));
          }
        }
        super.commonDao.update("sgp100ukrvService.confirmDataList", param);
    }

    
    /**
     * 년초계획확정 취소
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt") 
    public void  cancleDataList(Map param, LoginVO user) throws Exception {
        List<Map> confirmYnSelect = (List<Map>) super.commonDao.list("sgp100ukrvService.cancleDataSelect", param);
        String confirmYn = "";
        confirmYn = (String) confirmYnSelect.get(0).get("CONFIRM_YN");
        if(!confirmYnSelect.isEmpty()) {
          if(confirmYn.equals("N")) {
              throw new  UniDirectValidateException(this.getMessage("54458", user)); 
          } else if(confirmYn.equals("n")) {
              throw new  UniDirectValidateException(this.getMessage("54458", user));
          }
        }
        super.commonDao.update("sgp100ukrvService.cancleDataList", param);
    }


    public List<Map<String, Object>> gsType( Map<String, Object> param ) {
        // TODO Auto-generated method stub
        return null;
    }
}
