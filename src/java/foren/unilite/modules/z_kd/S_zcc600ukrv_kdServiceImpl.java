package foren.unilite.modules.z_kd;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.afb.Afb600ukrModel;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zcc600ukrv_kdService")
public class S_zcc600ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map isirNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        
        /**
         * 조회팝업 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectSearchInfo(Map param) throws Exception {
            return super.commonDao.list("s_zcc600ukrv_kdService.selectSearchInfo", param);
        }
        
        /**
         *  메인그리드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectDetail(Map param) throws Exception {
            return super.commonDao.list("s_zcc600ukrv_kdService.selectDetail", param);
        }
        
    	/**마스터만 저장시**/
    	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_kd")
    	public ExtDirectFormPostResult syncMaster(S_zcc600ukrv_kdModel param, LoginVO user, BindingResult result) throws Exception {

    		param.setS_COMP_CODE(user.getCompCode());
    		param.setS_USER_ID(user.getUserID());
    		super.commonDao.update("s_zcc600ukrv_kdService.updateMaster", param);
    		
    		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

    		return extResult;
    	}
    	
        /**
         * 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
            
            String entryNum = (String) dataMaster.get("ENTRY_NUM");
            
            if (ObjUtils.isEmpty(dataMaster.get("ENTRY_NUM") )) {
            	
            	String checkValue = "";
            	int checkThird = 0;
            	
            	String firstNV = "";
            	String secondNV = "";
            	String thirdNV = "";
            	secondNV = (String) dataMaster.get("ENTRY_DATE");
            	
            	secondNV = secondNV.substring(0, 6);
            	String deptGubun = "";
            	
        		if(dataMaster.get("DEPT_TYPE").equals("H")){
        			deptGubun = "H";
        		}else if(dataMaster.get("DEPT_TYPE").equals("G")){
        			deptGubun = "G";
        		}else if(dataMaster.get("DEPT_TYPE").equals("O")){
        			deptGubun = "O";
        		}else{
        			deptGubun = "E";
        		}
            	
            	if(dataMaster.get("WORK_TYPE").equals("1")){ // 개발금형
            		firstNV = deptGubun+"T";
            	}else{	//시작샘플
            		firstNV = deptGubun+"S";
            	}
            	
            	checkValue = firstNV + secondNV ;
            	
            	Map<String, Object> checkMap = new HashMap<String, Object>();
                checkMap.put("S_COMP_CODE", user.getCompCode());
                checkMap.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                checkMap.put("CHECK_VALUE", checkValue);
            	
            	Object checkData = super.commonDao.select("s_zcc600ukrv_kdService.checkEntryNum", checkMap); 
            	
            	if(checkData.equals("EMPTY")){
            		entryNum = checkValue + "01";
            	}else{
//            		thirdNV = (String) checkData ;
            		
            		checkThird = ObjUtils.parseInt(ObjUtils.getSafeString(checkData).substring(10, 12));
            		thirdNV = String.format("%02d", checkThird + 1);
            		entryNum = checkValue + thirdNV;
            	}
            	
            	
            	dataMaster.put("ENTRY_NUM", entryNum); 
            	

//        		entryNum = "HT" + dataMaster.get("ENTRY_DATE") + "01";
//        		entryNum = "GD" + dataMaster.get("ENTRY_DATE") + "00";
//        		
//        		 String s = String.format("%02d", 3);
            	
            	
//                Map<String, Object> spParam = new HashMap<String, Object>();
//                SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
//                Date dateGet = new Date ();
//                String dateGetString = dateFormat.format(dateGet);
//                spParam.put("COMP_CODE", user.getCompCode());            
//                spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
//                spParam.put("TABLE_ID","s_zcc600ukrv_kd");
//                spParam.put("PREFIX", "A");
//                spParam.put("BASIS_DATE", dateGetString);
//                spParam.put("AUTO_TYPE", "1");

//                super.commonDao.queryForObject("s_zcc600ukrv_kdService.spAutoNum", spParam); 
////                List<Map>paramDetail = (List<Map>) paramList.get(0).get("data");
////                String gwFlag = (String) paramDetail.get(0).get("GW_FLAG");
////                dataMaster.put("GW_FLAG",   gwFlag);
//                dataMaster.put("ENTRY_NUM", ObjUtils.getSafeString(spParam.get("KEY_NUMBER"))); 
//                entryNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));   
                super.commonDao.insert("s_zcc600ukrv_kdService.insertMaster", dataMaster);   
                
            } else {
                Map<String, Object> checkMap = new HashMap<String, Object>();
                checkMap.put("S_COMP_CODE", user.getCompCode());
                checkMap.put("DIV_CODE", dataMaster.get("DIV_CODE"));
                checkMap.put("ENTRY_NUM", dataMaster.get("ENTRY_NUM"));
                
            	List<Map> masterCheck = super.commonDao.list("s_zcc600ukrv_kdService.selectSearchInfo", checkMap);
            
            	if(masterCheck.size()<1){
            		super.commonDao.insert("s_zcc600ukrv_kdService.insertMaster", dataMaster);
            	}
            }
            
            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteDetail")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateDetail")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertDetail")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } 
               }           
               if(deleteList != null) this.deleteDetail(deleteList, user, dataMaster);
               if(updateList != null) this.updateDetail(updateList, user, dataMaster); 
               if(insertList != null) this.insertDetail(insertList, user, entryNum);             
           }
           
           dataMaster.put("ENTRY_NUM", entryNum);
           
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")                                             // INSERT
        public void insertDetail(List<Map> paramList, LoginVO user, String entryNum) throws Exception { 
            for(Map param :paramList ) {
            	if(ObjUtils.isNotEmpty(entryNum)){
            		param.put("ENTRY_NUM", entryNum);
            	}
                super.commonDao.update("s_zcc600ukrv_kdService.insertList", param);
            }
            return ;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")                                             // UPDATE
        public void updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {  
                super.commonDao.update("s_zcc600ukrv_kdService.updateList", param);
            }
            
            if(dataMaster.get("masterSaveFlag").equals("U")){
            	super.commonDao.insert("s_zcc600ukrv_kdService.updateMaster", dataMaster);
            	
            }
            
            return ;
        } 
        
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_MODIFY)                                                   // DELETE
        public void deleteDetail(List<Map> paramList,  LoginVO user, Map<String, Object> dataMaster) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
               super.commonDao.update("s_zcc600ukrv_kdService.deleteList", param);
            }
            
            if(dataMaster.get("masterSaveFlag").equals("D")){
            	super.commonDao.insert("s_zcc600ukrv_kdService.deleteMaster", dataMaster);
            	
            }
            
            return ;
        } 
}
