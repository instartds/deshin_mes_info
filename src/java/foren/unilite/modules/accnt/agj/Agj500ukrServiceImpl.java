package foren.unilite.modules.accnt.agj;

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



@Service("agj500ukrService")
public class Agj500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 전표엑셀업로드 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agj500ukrServiceImpl.selectList", param);
	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("agj500ukrServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("agj500ukrServiceImpl.updateDetail", param);
		}
		 return;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("agj500ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return;
	}
	
	 /**결의전표반영 취소버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllButton(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        String buttonFlag = (String) dataMaster.get("BUTTON_FLAG");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailButton")) {
                    param.put("data", insertLogDetails(dataList, keyValue, buttonFlag));  
                }
            }
        }
        
        if(buttonFlag.equals("BATCH")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("WORK_TYPE", dataMaster.get("WORK_TYPE"));
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            
            
            super.commonDao.queryForObject("spUspAccntAgj500ukr_fnAgj110tInsert", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
//                dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {

//                dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
//                for(Map param: paramList) {
//                    dataList = (List<Map>)param.get("data");    
//                    if(param.get("method").equals("insertDetail")) {
//                        List<Map> datas = (List<Map>)param.get("data");
//                        for(Map data: datas){
//                            data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
//                        }
//                    }
//                }   
            }
            
        }else if(buttonFlag.equals("CANCEL")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("WORK_TYPE", dataMaster.get("WORK_TYPE"));
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAgj500ukr_fnAgj110tDelete", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
//                dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {

//                dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
//                for(Map param: paramList) {
//                    dataList = (List<Map>)param.get("data");    
//                    if(param.get("method").equals("insertDetail")) {
//                        List<Map> datas = (List<Map>)param.get("data");
//                        for(Map data: datas){
//                            data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
//                        }
//                    }
//                }   
            }
            
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String buttonFlag) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            if(buttonFlag.equals("BATCH")){
                param.put("OPR_FLAG", "N");
            }else if(buttonFlag.equals("CANCEL")){
                param.put("OPR_FLAG", "D");
            }
            
            super.commonDao.insert("agj500ukrServiceImpl.insertLogDetail", param);
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailButton(List<Map> params, LoginVO user) throws Exception {
        return;
    }
	
	
	
	/**
	 * 엑셀업로드 관련 중
	 * @param jobID
	 * @param param
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
	    logger.debug("validate: {}", jobID);
//	    try {	 
	        super.commonDao.update("agj500ukrServiceImpl.excelValidate", param);
//		 }catch(Exception e)	{
// 			throw new  Exception();
//		 }	
		return;
	}
	
}
