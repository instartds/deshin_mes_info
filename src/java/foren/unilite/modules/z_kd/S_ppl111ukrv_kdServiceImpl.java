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



@Service("s_ppl111ukrv_kdService")
public class S_ppl111ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
     * 
     * 시작계획주차 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectFromWeek(Map param) throws Exception {
        return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectFromWeek", param);
    }
    
    /**
     * 
     * 마지막계획주차 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectToWeek(Map param) throws Exception {
        return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectToWeek", param);
    }
    
    /**
     * 
     * 해당월 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectMonth(Map param) throws Exception {
        return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectMonth", param);
    }
	
	/**
	 * 
	 * 생산계획 등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectDetailList", param);
	}

	/**
	 * 
	 * 판매계획 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectRefList(Map param) throws Exception {
		return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectRefList", param);
	}

	/**
	 * 
	 * 수주정보 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_ppl111ukrv_kdServiceImpl.selectEstiList", param);
	}
	
	
	/**
	 * Main Grid saveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
				
		
		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				String keyValue = getLogKey();
				
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);

				
				param.put("data", super.commonDao.insert("s_ppl111ukrv_kdServiceImpl.insertLogMaster", param));
				
				
				//4.생산계획등록Stored Procedure 실행
				Map<String, Object> spParam = new HashMap<String, Object>();

				spParam.put("KeyValue", keyValue);
				spParam.put("LangCode", user.getLanguage());

				super.commonDao.queryForObject("s_ppl111ukrv_kdServiceImpl.spProdtPlanForepart", spParam);
				
				String rtnWkPlanNum = ObjUtils.getSafeString(spParam.get("RtnWkPlanNum"));
				String errorDesc 	= ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
				//생산계획번호 리턴
				Map<String, Object> dataMaster1 = (Map<String, Object>) paramMaster.get("data");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					logger.info("######  s_ppl111ukrv_kdServiceImpl.spProdtPlanForepart  #######");
					logger.info("######  RtnWkPlanNum : {}", ObjUtils.getSafeString(spParam.get("RtnWkPlanNum")));
					logger.info("######  errorDesc : {}", errorDesc);

					String[] messsage = errorDesc.split(";");
				    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				}
			}
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/* Main Grid directProxy */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
	
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		Map compCodeMap = new HashMap();
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_ppl111ukrv_kdServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 param.put("PRODT_PLAN_DATE_FR", dataMaster.get("PRODT_PLAN_DATE_FR"));
				 param.put("PRODT_PLAN_DATE_TO", dataMaster.get("PRODT_PLAN_DATE_TO"));
				 
				 super.commonDao.update("s_ppl111ukrv_kdServiceImpl.deleteDetail", param);
			 }
		 }
		 return 0;
	}
	
	/* -- END Main Grid directProxy */
	
	
	/**
	 * 수주정보 참조, 판매계획 참조 생산계획등록 LogTable + SP 작업
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveRefAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
    		//1.로그테이블에서 사용할 Key 생성		
    		String keyValue = getLogKey();			
    
    		//2.수주정보참조 로그테이블에 KEY_VALUE 업데이트
    		List<Map> dataList = new ArrayList<Map>();
    		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
    
    		dataMaster.put("COMP_CODE", user.getCompCode());
		    paramList.size();
    		for(Map paramData: paramList) {			
    			
    			dataList = (List<Map>) paramData.get("data");
    
    			for(Map param:  dataList) {
    				param.put("MRP_CONTROL_NUM", keyValue);
    				param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
    				
    				
    				if(param.get("CHECK_YN").equals("S")){
    					/* bParam(5) = "S" '영업수주참조  */
    					param.put("data", super.commonDao.insert("s_ppl111ukrv_kdServiceImpl.insertEstiListPlan", param));
    				}else if(param.get("CHECK_YN").equals("M")){
    				
    					/* bParam(5) = "M"	'판매계획참조 */
    					param.put("data", super.commonDao.insert("s_ppl111ukrv_kdServiceImpl.insertRefListPlan", param));
    				}
    			}
    		}
    		
    		Map<String, Object> spParam = new HashMap<String, Object>();
    		
    		spParam.put("KeyValue"  , keyValue);
    		spParam.put("PadStockYn", dataMaster.get("PAD_STOCK_YN"));
    		spParam.put("LangCode"  , user.getLanguage());
    		
    		super.commonDao.queryForObject("s_ppl111ukrv_kdServiceImpl.spProdtPlan", spParam);			
    		
    		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
    		
    		if(!ObjUtils.isEmpty(errorDesc)){
    			String[] messsage = errorDesc.split(";");
    		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
    		} else {
    			
    		}
    
    		paramList.add(0, paramMaster);
    				
    		return  paramList;
	}
	
	/* -- MainGrid directProxy */

	/* 수주정보참조  directProxy */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteEstiDetail(List<Map> params, LoginVO user) throws Exception {
		
	}
	/* -- END 수주정보참조  directProxy */
	
	
	/* 판매계획정보참조 directProxy */
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertRefDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateRefDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteRefDetail(List<Map> params, LoginVO user) throws Exception {
		
	}
	
	/* -- END 판매계획정보참조 directProxy */
	
}
