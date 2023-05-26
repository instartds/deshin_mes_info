package foren.unilite.modules.sales.sbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.aba.Aba060ukrvModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("sbs030ukrsService")
public class Sbs030ukrsServiceImpl  extends TlabAbstractServiceImpl {
    //////////////////////////////////////////////////////////////////////////////////////////////// 판매단가/고객품목등록
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList0_1(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList0_1", param);
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////// 판매단가등록
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList0_2(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList0_2", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll0_2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        
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
               if(deleteList != null) this.deleteDetail0_2(deleteList, user);
               if(insertList != null) this.insertDetail0_2(insertList, user);
               if(updateList != null) this.updateDetail0_2(updateList, user);             
           }
           paramList.add(0, paramMaster);
               
           return  paramList;
   }
    
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail0_2(List<Map> paramList, LoginVO user) throws Exception {      
       for(Map param : paramList ) {            
           super.commonDao.update("sbs030ukrsService.insertDetail0_2", param);
       } 
       return 0;
   }   
       
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail0_2(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.updateDetail0_2", param);
       }
       return 0;
   } 
       
       
   @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
   public Integer deleteDetail0_2(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.deleteDetail0_2", param);
       }
       return 0;
   }
    
   //////////////////////////////////////////////////////////////////////////////////////////////// 고객품목등록
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
   public List<Map<String, Object>>  selectList0_3(Map param) throws Exception {
       return  super.commonDao.list("sbs030ukrsService.selectList0_3", param);
   }
   
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
   public List<Map> saveAll0_3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
       
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
              if(deleteList != null) this.deleteDetail0_3(deleteList, user);
              if(insertList != null) this.insertDetail0_3(insertList, user);
              if(updateList != null) this.updateDetail0_3(updateList, user);             
          }
          paramList.add(0, paramMaster);
              
          return  paramList;
   }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
    public Integer  insertDetail0_3(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {            
            super.commonDao.update("sbs030ukrsService.insertDetail0_3", param);
        } 
        return 0;
    }   
        
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
    public Integer updateDetail0_3(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            List<Map> updateCheck = (List) super.commonDao.list("sbs030ukrsService.updateCheck", param);
            if(ObjUtils.isEmpty(updateCheck)) {
                throw new  UniDirectValidateException(this.getMessage("54622", user));
            } else {
                super.commonDao.update("sbs030ukrsService.updateDetail0_3", param);
            }
        }
        return 0;
    } 
        
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
    public Integer deleteDetail0_3(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            List<Map> deleteCheck = (List) super.commonDao.list("sbs030ukrsService.deleteCheck", param);
            if(ObjUtils.isEmpty(deleteCheck)) {
                throw new  UniDirectValidateException(this.getMessage("54623", user));
            } else {
                super.commonDao.update("sbs030ukrsService.deleteDetail0_3", param);
            }
        }
        return 0;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////// 배송처등록
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList2", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList2_2(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList2_2", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll2_2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        
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
               if(deleteList != null) this.deleteDetail2_2(deleteList, user);
               if(insertList != null) this.insertDetail2_2(insertList, user);
               if(updateList != null) this.updateDetail2_2(updateList, user);             
           }
           paramList.add(0, paramMaster);
               
           return  paramList;
   }
    
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail2_2(List<Map> paramList, LoginVO user) throws Exception {      
       for(Map param : paramList ) {            
           super.commonDao.update("sbs030ukrsService.insertDetail2_2", param);
       } 
       return 0;
   }   
       
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail2_2(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.updateDetail2_2", param);
       }
       return 0;
   } 
       
       
   @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
   public Integer deleteDetail2_2(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.deleteDetail2_2", param);
       }
       return 0;
   }
   
    ////////////////////////////////////////////////////////////////////////////////////////////////적요등록
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList3(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList3", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        
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
               if(deleteList != null) this.deleteDetail3(deleteList, user);
               if(insertList != null) this.insertDetail3(insertList, user);
               if(updateList != null) this.updateDetail3(updateList, user);             
           }
           paramList.add(0, paramMaster);
               
           return  paramList;
   }
    
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {      
       for(Map param : paramList ) {            
           super.commonDao.update("sbs030ukrsService.insertDetail3", param);
       } 
       return 0;
   }   
       
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.updateDetail3", param);
       }
       return 0;
   } 
       
       
   @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
   public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.deleteDetail3", param);
       }
       return 0;
   }
   
   ////////////////////////////////////////////////////////////////////////////////////////////////고객기초잔액등록
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
   public List<Map<String, Object>>  selectBasisYyyymm(Map param) throws Exception {
       return  super.commonDao.list("sbs030ukrsService.selectBasisYyyymm", param);
   }
   
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public Object  selectList4(Map param, LoginVO user) throws Exception {
        List<Map> selectSubCode = (List) super.commonDao.list("sbs030ukrsService.selectSubCode", param);
        List<Map> selectBasisYyyymm = (List) super.commonDao.list("sbs030ukrsService.selectBasisYyyymm", param);
        List<Map> selectSubCode2 = (List) super.commonDao.list("sbs030ukrsService.selectSubCode2", param);
        Object rMap = null;
        if(ObjUtils.isEmpty(selectSubCode)) {
            throw new  UniDirectValidateException(this.getMessage("54103", user));
        } else if(selectBasisYyyymm.size() > 1) {
            throw new  UniDirectValidateException(this.getMessage("54500", user));
        } else if(ObjUtils.isEmpty(selectSubCode2)) {
            throw new  UniDirectValidateException(this.getMessage("54400", user));
        } else {
            rMap = super.commonDao.list("sbs030ukrsService.selectList4", param);
        }
        return  rMap;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        Map errorMap = (Map) super.commonDao.select("sbs030ukrsService.validate4", dataMaster);
//      String errorDesc = (String) errorMap.get("errorDesc");
        if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
            String errorDesc = (String) errorMap.get("ERROR_DESC");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        }else{
            if(paramList != null)  {
                List<Map> insertList = null;
                List<Map> updateList = null;
                List<Map> deleteList = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("deleteDetail4")) {
                        deleteList = (List<Map>)dataListMap.get("data");
                    }else if(dataListMap.get("method").equals("insertDetail4")) {        
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
        }      
       return  paramList;
   }
    
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {      
       for(Map param : paramList ) {            
           super.commonDao.update("sbs030ukrsService.insertDetail4", param);
       } 
       return 0;
   }   
       
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.updateDetail4", param);
       }
       return 0;
   } 
       
       
   @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
   public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("sbs030ukrsService.deleteDetail4", param);
       }
       return 0;
   }
   
    ////////////////////////////////////////////////////////////////////////////////////////////////SET품목등록
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList8_1(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList8_1", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll8_1(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
    
    if(paramList != null)  {
        List<Map> insertList = null;
        List<Map> updateList = null;
        List<Map> deleteList = null;
        for(Map dataListMap: paramList) {
            if(dataListMap.get("method").equals("deleteDetail")) {
                deleteList = (List<Map>)dataListMap.get("data");
            }else if(dataListMap.get("method").equals("insertDetail")) {        
                insertList = (List<Map>)dataListMap.get("data");
            } 
        }           
        if(deleteList != null) this.deleteDetail8_1(deleteList, user);
        if(insertList != null) this.insertDetail8_1(insertList, user);            
    }
    paramList.add(0, paramMaster);
    
    return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
    public Integer  insertDetail8_1(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {            
            super.commonDao.update("sbs030ukrsService.insertDetail8_1", param);
        } 
        return 0;
    }       
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
    public Integer deleteDetail8_1(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {
            List<Map> deleteCheck2 = (List) super.commonDao.list("sbs030ukrsService.selectdelteCheck2", param);
            if(!ObjUtils.isEmpty(deleteCheck2)) {
                throw new  UniDirectValidateException(this.getMessage("55450", user));
            } else {
                super.commonDao.update("sbs030ukrsService.deleteDetail8_1", param);
            }
        }
        return 0;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
    public List<Map<String, Object>>  selectList8_2(Map param) throws Exception {
        return  super.commonDao.list("sbs030ukrsService.selectList8_2", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll8_2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
    
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
        if(deleteList != null) this.deleteDetail8_2(deleteList, user);
        if(insertList != null) this.insertDetail8_2(insertList, user);
        if(updateList != null) this.updateDetail8_2(updateList, user);             
    }
    paramList.add(0, paramMaster);
    
    return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
    public Integer  insertDetail8_2(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {            
            super.commonDao.update("sbs030ukrsService.insertDetail8_2", param);
        } 
        return 0;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
    public Integer updateDetail8_2(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("sbs030ukrsService.updateDetail8_2", param);
        }
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
    public Integer deleteDetail8_2(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("sbs030ukrsService.deleteDetail8_2", param);
        }
        return 0;
    }
}
