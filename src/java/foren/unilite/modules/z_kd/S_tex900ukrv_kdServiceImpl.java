package foren.unilite.modules.z_kd;

import java.util.ArrayList;
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
import foren.unilite.modules.sales.spp.Spp100ukrvModel;



@Service("s_tex900ukrv_kdService")
public class S_tex900ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	
	/**
	 * 
	 * 환급채번검색 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_tex900ukrv_kdService.selectDetailList", param);
	}

	/**
	 * 
	 * 관세환급등록 Main
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_tex900ukrv_kdService.selectList", param);
	}
	
	/**
     * Form
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
    public Object selectMaster(Map param) throws Exception {    
        return super.commonDao.select("s_tex900ukrv_kdService.selectMaster", param);
    }
	
	
	/**
	 * 
	 * 선적참조 팝업
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectBlNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_tex900ukrv_kdService.selectBlNumMasterList", param);
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
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramMaster:" + paramMaster);
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
        dataMaster.put("COMP_CODE", user.getCompCode());
        
        String returnNo = (String) dataMaster.get("RETURN_NO");
        String divCode = (String) dataMaster.get("DIV_CODE");
        String returnDate = (String) dataMaster.get("RETURN_DATE");
        String hsNo = (String) dataMaster.get("HS_NO");
        String returnRate = (String) dataMaster.get("RETURN_RATE");
        String returnAmt = (String) dataMaster.get("RETURN_AMT");
        String remark = (String) dataMaster.get("REMARK");
        if (ObjUtils.isEmpty(dataMaster.get("RETURN_NO") )) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("COMP_CODE", user.getCompCode());            
            spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            spParam.put("TABLE_ID","s_tex900ukrv_kd");
            spParam.put("PREFIX", "A");
            spParam.put("BASIS_DATE", dataMaster.get("RETURN_DATE"));
            spParam.put("AUTO_TYPE", "1");

            super.commonDao.queryForObject("s_tex900ukrv_kdService.spAutoNum", spParam);
            dataMaster.put("RETURN_NO", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));   
            dataMaster.put("DIV_CODE", divCode);  
            dataMaster.put("RETURN_DATE", returnDate);  
            dataMaster.put("HS_NO", hsNo);  
            dataMaster.put("RETURN_RATE", returnRate);  
            dataMaster.put("RETURN_AMT", returnAmt);  
            dataMaster.put("REMARK", remark); 
            returnNo = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));     
            super.commonDao.insert("s_tex900ukrv_kdService.insert", dataMaster);        
            logger.debug("[saveAll] returnNo1111111111111111111111111:" + returnNo);
            
        } else {
//            dataMaster.put("RETURN_NO", returnNo);   
//            dataMaster.put("DIV_CODE_FORM", divCode);  
//            dataMaster.put("RETURN_DATE_FORM", returnDate);  
//            dataMaster.put("HS_NO_FORM", hsNo);  
//            dataMaster.put("RETURN_RATE_FORM", returnRate);  
//            dataMaster.put("RETURN_AMT_FORM", returnAmt);  
//            dataMaster.put("REMARK_FORM", remark); 
//            super.commonDao.insert("s_tex900ukrv_kdService.update", dataMaster);  
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
            if(deleteList != null) this.deleteDetail(deleteList, user, returnNo);
            if(updateList != null) this.updateDetail(updateList, user); 
            logger.debug("[saveAll] returnNo22222222222222222222222:" + returnNo);
            if(insertList != null) this.insertDetail(insertList, user, returnNo);             
        } else {
            
        }
        paramList.add(0, paramMaster);
            
        return  paramList;
   }
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
    public ExtDirectFormPostResult syncMaster(S_tex900ukrv_kdModel param, LoginVO user,  BindingResult result) throws Exception {
        param.setS_USER_ID(user.getUserID());
        param.setS_COMP_CODE(user.getCompCode());
        super.commonDao.update("s_tex900ukrv_kdService.update", param);
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
            
        return extResult;
    }
	
	/**
	 * 
	 * 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")        // UPDATE
	public Integer updateDetail(List<Map> paramList,  LoginVO user) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("s_tex900ukrv_kdService.updateDetail", param);
       }
       return 0;
	}
    
	/**
	 * 
	 * 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")         // INSERT
	public Integer insertDetail(List<Map> paramList,  LoginVO user, String returnNo) throws Exception {
       for(Map param :paramList ) {   
    	   param.put("RETURN_NO", returnNo);
           super.commonDao.update("s_tex900ukrv_kdService.insertDetail", param);
       }
       return 0;
	}
	
	
	/**
	 * 
	 * 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")         // DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, String returnNo) throws Exception {
       for(Map param :paramList ) {   
           super.commonDao.update("s_tex900ukrv_kdService.deleteDetail", param);
           //2 체크
           String returnNo2 = (String)super.commonDao.select("s_tex900ukrv_kdService.beforeDeleteCheck", param);
           if(ObjUtils.isEmpty(returnNo2)) {
               //3 디테일 없으면 마스터 삭제
               super.commonDao.delete("s_tex900ukrv_kdService.delete", param);
           } else {
               
           }
       }
       return 0;
	}	
	
	
}
