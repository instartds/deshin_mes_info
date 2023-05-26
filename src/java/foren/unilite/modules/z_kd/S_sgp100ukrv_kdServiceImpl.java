package foren.unilite.modules.z_kd;

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

@Service("s_sgp100ukrv_kdService")
public class S_sgp100ukrv_kdServiceImpl extends TlabAbstractServiceImpl  {
    	private final Logger logger = LoggerFactory.getLogger(this.getClass());
    	@Resource(name = "fileMnagerService")
    	private FileMnagerService fileMnagerService;
    	
    	/**
         * 고객품목별 정보 조회
         * @param param
         * @param user
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
        public List<Map> selectList(Map param, LoginVO user) throws Exception {
            return  super.commonDao.list("s_sgp100ukrv_kdService.selectList", param);
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
     
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
        public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("s_sgp100ukrv_kdService.checkCompCode", compCodeMap);
			Map chk = new HashMap();
			for (Map param : paramList) {
				chk = (Map) super.commonDao.select("s_sgp100ukrv_kdService.selectSsgp100ukrvkdChk", param); // 데이터 존재 여부 체크
				if ("".equals(chk.get("ERROR_DESC"))) {
					for (Map checkCompCode : chkList) {
						param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						super.commonDao.update("s_sgp100ukrv_kdService.insertDetail", param);
					}
				} else {
					throw new UniDirectValidateException((String) chk.get("ERROR_DESC"));
				}
			}
			/*	
		     try {
                Map compCodeMap = new HashMap();
                compCodeMap.put("S_COMP_CODE", user.getCompCode());
                List<Map> chkList = (List<Map>) super.commonDao.list("s_sgp100ukrv_kdService.checkCompCode", compCodeMap);
                for(Map  param : paramList ) {            
                    for(Map checkCompCode : chkList) {
                         param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                         super.commonDao.update("s_sgp100ukrv_kdService.insertDetail", param);
                    }
                }   
            }catch(Exception e){
                throw new  UniDirectValidateException(this.getMessage("2627", user));
            }*/
            
            return 0;
        }   
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        	
        	Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List<Map>) super.commonDao.list("s_sgp100ukrv_kdService.checkCompCode", compCodeMap);
            //생산여부 체크 기능 추가
 			Map chk = new HashMap();
 			for (Map param : paramList) {
 				chk = (Map) super.commonDao.select("s_sgp100ukrv_kdService.selectSsgp100ukrvkdChk", param); // 데이터 존재 여부 체크
 				if ("".equals(chk.get("ERROR_DESC"))) {
 					for (Map checkCompCode : chkList) {
 	                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
 	                     super.commonDao.update("s_sgp100ukrv_kdService.updateDetail", param);
 					}
 				} else {
 					throw new UniDirectValidateException((String) chk.get("ERROR_DESC"));
 				}
 			} 
             return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            compCodeMap.put("S_COMP_CODE", user.getCompCode());
            List<Map> chkList = (List) super.commonDao.list("s_sgp100ukrv_kdService.checkCompCode", compCodeMap);
            for(Map param :paramList ) {   
                 for(Map checkCompCode : chkList) {
                     param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                     Map confirmYn = (Map) super.commonDao.queryForObject("s_sgp100ukrv_kdService.beforeDelete", param);
                     if(confirmYn.isEmpty()) {
                         throw new  UniDirectValidateException(this.getMessage("54400", user)); 
                     } else {
                         if(confirmYn.equals("Y") ||confirmYn.equals("y")) {
                             throw new  UniDirectValidateException(this.getMessage("54455", user)); 
                         } else {
                             super.commonDao.update("s_sgp100ukrv_kdService.deleteDetail", param);
                         }
                     }
                 }
             }
             return 0;
        } 
        

    	/**
         * 기초데이터생성
         * @param param
         * @param user
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
        public List<Map> creatCustomerItemDataList(Map param, LoginVO user) throws Exception {
            if(super.commonDao.list("s_sgp100ukrv_kdService.creatDataList", param).isEmpty()) {
                return super.commonDao.list("s_sgp100ukrv_kdService.creatCustomerItemDataList", param);
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
            List<Map> confirmYnSelect = (List<Map>) super.commonDao.list("s_sgp100ukrv_kdService.confirmDataSelect", param);
            String confirmYn = "";
            confirmYn = (String) confirmYnSelect.get(0).get("CONFIRM_YN");
            if(!confirmYnSelect.isEmpty()) {
              if(confirmYn.equals("Y")) {
                  throw new  UniDirectValidateException(this.getMessage("54455", user)); 
              } else if(confirmYn.equals("y")) {
                  throw new  UniDirectValidateException(this.getMessage("54455", user));
              }
            }
            super.commonDao.update("s_sgp100ukrv_kdService.confirmDataList", param);
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
            List<Map> confirmYnSelect = (List<Map>) super.commonDao.list("s_sgp100ukrv_kdService.cancleDataSelect", param);
            String confirmYn = "";
            confirmYn = (String) confirmYnSelect.get(0).get("CONFIRM_YN");
            if(!confirmYnSelect.isEmpty()) {
              if(confirmYn.equals("N")) {
                  throw new  UniDirectValidateException(this.getMessage("54458", user)); 
              } else if(confirmYn.equals("n")) {
                  throw new  UniDirectValidateException(this.getMessage("54458", user));
              }
            }
            super.commonDao.update("s_sgp100ukrv_kdService.cancleDataList", param);
        }
    
    
        public List<Map<String, Object>> gsType( Map<String, Object> param ) {
            // TODO Auto-generated method stub
            return null;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
        public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        
            return  super.commonDao.list("s_sgp100ukrv_kdService.selectList2", param);
        }        
}
