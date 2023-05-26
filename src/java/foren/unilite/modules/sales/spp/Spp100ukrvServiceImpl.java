package foren.unilite.modules.sales.spp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.owasp.esapi.Logger;
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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;

@Service("spp100ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Spp100ukrvServiceImpl  extends TlabAbstractServiceImpl {
    
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectEstiPrsn(Map param) throws Exception {
        return super.commonDao.list("spp100ukrvServiceImpl.selectEstiPrsn", param);
    }
	
    /**
     * 거래처코드
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "ssa")
    public Object selectCustomCode(Map param) throws Exception {    
        
        return super.commonDao.select("spp100ukrvServiceImpl.selectCustomCode", param);
    }
    
    /**
     * 견적현황 조회 : 마스터 조회 목록
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "ssa")
    public Object selectMaster(Map param) throws Exception {    
        
        return super.commonDao.select("spp100ukrvServiceImpl.selectMaster", param);
    }

	/**
	 * 견적현황 조회 : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("spp100ukrvServiceImpl.selectList", param);
	}
	
	/**
     * 검색POPUP
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
        
        return  super.commonDao.list("spp100ukrvServiceImpl.selectList2", param);
    }
    
    /**
     * 마스터 참조창
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectList3(Map param) throws Exception {
        
        return  super.commonDao.list("spp100ukrvServiceImpl.selectList3", param);
    }
    
    /**
     * 디테일 참조창
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectList4(Map param) throws Exception {
        
        return  super.commonDao.list("spp100ukrvServiceImpl.selectList4", param);
    }
    
    /**
     * 견적확정버튼
     * @param param
     * @param user
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt") 
    public void  confirmDataList(Map param, LoginVO user) throws Exception {
        List<Map> selectEstiNum = (List<Map>) super.commonDao.list("spp100ukrvServiceImpl.selectEstiNum", param);
        String estiNum = "";
        estiNum = (String) selectEstiNum.get(0).get("ESTI_NUM");
        
        if(estiNum.isEmpty()) {
            throw new  UniDirectValidateException(this.getMessage("54400", user));
        } else {
            super.commonDao.update("spp100ukrvServiceImpl.confirmDataList", param);
        }
    }

    /**
     * 견적진행버튼
     * @param param
     * @param user
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt") 
    public void  cancleDataList(Map param, LoginVO user) throws Exception {
        List<Map> selectEstiNum = (List<Map>) super.commonDao.list("spp100ukrvServiceImpl.selectEstiNum", param);
        String estiNum = "";
        estiNum = (String) selectEstiNum.get(0).get("ESTI_NUM");
        
        Map<String, Object> selectOrderQ = (Map<String, Object>)super.commonDao.select("spp100ukrvServiceImpl.selectOrderQ", param);
        
        if(estiNum.isEmpty()) {
            throw new  UniDirectValidateException(this.getMessage("54400", user));
        } else {
            if(ObjUtils.parseInt(selectOrderQ.get("ORDER_Q").toString()) > 0) {
                throw new  UniDirectValidateException(this.getMessage("54453", user));
            } else {
                super.commonDao.update("spp100ukrvServiceImpl.cancleDataList", param);
            }
        }
    }
    
    /**
     * 견적확정/진행 버튼 누른 후 CONFIRM_FLAG확인
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
    public List<Map<String, Object>>  selectConfirmFlag(Map param) throws Exception {
        
        return  super.commonDao.list("spp100ukrvServiceImpl.selectConfirmFlag", param);
    }
    
/*    /**
     *  견적마스터 수정
     * 
     * @param param
     * @return
     * @throws Exception
     *//*
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
    public ExtDirectFormPostResult syncMaster(Spp100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
//        if(!"".equals(ObjUtils.getSafeString(param.getZIP_CODE()))) {
//            param.setZIP_CODE(param.getZIP_CODE().replace("-", ""));
//        }
//        if(!"".equals(ObjUtils.getSafeString(param.getCOMPANY_NUM())))  {
//            param.setCOMPANY_NUM(param.getCOMPANY_NUM().replaceAll("\\-", ""));
//        }
//        if(!"".equals(ObjUtils.getSafeString(param.getREPRE_NO()))) {
//            param.setREPRE_NO(param.getREPRE_NO().replaceAll("\\-", ""));
//        }
//        if(!"".equals(ObjUtils.getSafeString(param.getCOMP_OWN_NO())))  {
//            param.setCOMP_OWN_NO(param.getCOMP_OWN_NO().replaceAll("\\-", ""));
//        }
        param.setS_USER_ID(user.getUserID());
        super.commonDao.update("spp100ukrvServiceImpl.update", param);
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
            
        return extResult;
        
    	Map<String, Object> paramMap = this.makeMapParam(param, user);

		if (ObjUtils.isEmpty(paramMap.get("ESTI_NUM") )) {
			Map<String, Object> autoNum = (Map<String, Object>)super.commonDao.select("spp100ukrvServiceImpl.autoNum", paramMap);
			String EstiNum = ObjUtils.getSafeString(autoNum.get("ESTI_NUM"));
			paramMap.put("ESTI_NUM", EstiNum);
			super.commonDao.insert("spp100ukrvServiceImpl.insertMaster", paramMap);
		}else {
			super.commonDao.update("spp100ukrvServiceImpl.updateMaster", paramMap);
		}

		//super.commonDao.update("spp100ukrvServiceImpl.updatePrice", paramMap);

		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("ESTI_NUM", ObjUtils.getSafeString(paramMap.get("ESTI_NUM")));
		return extResult;
        
        
    }*/
    
    //************************  NEW ADD  *****************************
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
    public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertMaster = null;
			List<Map> updateMaster = null;
     		List<Map> deleteMaster = null;
		
			for(Map dataListMap: paramList) {
				/* 전체삭제버튼 구현 시, 주석 해제*/
				if(dataListMap.get("method").equals("deleteMaster")) {
					deleteMaster = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertMaster")) {		
					insertMaster = (List<Map>)dataListMap.get("data");
				}
				else if(dataListMap.get("method").equals("updateMaster")) {
					updateMaster = (List<Map>)dataListMap.get("data");	
				} 
			}			
    		if(deleteMaster != null) this.deleteMaster(deleteMaster, user, dataMaster);
			if(insertMaster != null) this.insertMaster(insertMaster, user, dataMaster);
			if(updateMaster != null) this.updateMaster(updateMaster, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
    
	/**
	 * 견적 마스터 정보 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public List<Map> insertMaster(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		String errMsg = "";		
		try {
			for(Map param :paramList )	{

				if ("Y".equals(paramMaster.get("AUTO_NO_YN"))) {
					Map<String, Object> autoNum	= (Map<String, Object>)super.commonDao.select("spp100ukrvServiceImpl.autoNum", param);
					String EstiNum				= ObjUtils.getSafeString(autoNum.get("ESTI_NUM"));
					param.put("ESTI_NUM"		, EstiNum);
					paramMaster.put("ESTI_NUM"	, EstiNum);
				}
				super.commonDao.insert("spp100ukrvServiceImpl.insertMaster", param);
			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/**
	 * 견적 마스터 정보 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateMaster(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("spp100ukrvServiceImpl.updateMaster", param);
		 }
		 return 0;
	} 
	/**
	 * 견적 마스터 정보 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteMaster(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("spp100ukrvServiceImpl.deleteMaster", param);
		 }
		 return 0;
	} 

	
	/**
	 * 견적 디테일 정보 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				}
				else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 견적 디테일 정보 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public List<Map> insertList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		String errMsg = "";		
		try {
			for(Map param :paramList )	{
				param.put("COMP_CODE", user.getCompCode());
				param.put("DIV_CODE", user.getDivCode());
				param.put("ESTI_PRSN", paramMaster.get("ESTI_PRSN"));
				//param.put("CUST_PRSN",  paramMaster.get("COMP_CODE"));
				//param.put("ESTI_AMT",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_NUM",  paramMaster.get("ESTI_NUM"));
/*				param.put("ESTI_PAYCONDI", paramMaster.get("COMP_CODE"));
				param.put("ESTI_CFM_AMT",  paramMaster.get("COMP_CODE"));
				param.put("CONFIRM_DATE",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_VALIDTERM",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_TAX_AMT",  paramMaster.get("COMP_CODE"));
				param.put("CONFIRM_FLAG",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_DVRY_DATE",  paramMaster.get("COMP_CODE"));
				param.put("CUSTOM_CODE",  paramMaster.get("COMP_CODE"));
				param.put("CUSTOM_NAME",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_DVRY_PLCE",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_DATE",  paramMaster.get("COMP_CODE"));
				param.put("REMARK",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_TITLE", paramMaster.get("COMP_CODE"));
				param.put("MONEY_UNIT",  paramMaster.get("COMP_CODE"));
				param.put("EXCHANGE_RATE", paramMaster.get("COMP_CODE"));
				param.put("PROFIT_RATE", paramMaster.get("COMP_CODE"));
				param.put("ESTI_EX_AMT", paramMaster.get("COMP_CODE"));
				param.put("ESTI_CFM_TAX_AMT",  paramMaster.get("COMP_CODE"));
				param.put("ESTI_CFM_EX_AMT",  paramMaster.get("COMP_CODE")); */
				super.commonDao.insert("spp100ukrvServiceImpl.insertList", param);
			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return paramList;
	}

	
	/**
	 * 견적 디테일 정보 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("spp100ukrvServiceImpl.updateList", param);
		 }
		 return 0;
	} 

	
	/**
	 * 견적 디테일 정보 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {		
		for(Map param :paramList )	{
			try {
				super.commonDao.delete("spp100ukrvServiceImpl.deleteList", param);
				 
			}catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}

	/*
	 * 견적서출력
	 * Main Report
	 * */

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("spp100ukrvServiceImpl.mainReport", param);
	}
    
}