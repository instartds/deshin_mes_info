package foren.unilite.modules.prodt.ppl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Service("ppl100ukrvService")
public class Ppl100ukrvServiceImpl  extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 작업장 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  fnWorkShopCode(Map param) throws Exception {	

		return  super.commonDao.select("ppl100ukrvServiceImpl.fnWorkShopCode", param);
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
		return super.commonDao.list("ppl100ukrvServiceImpl.selectDetailList", param);
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
			
			if(paramData.get("method").equals("insertDetail"))	
				this.insertDetail(dataList, dataMaster, user);
			if(paramData.get("method").equals("updateDetail"))	
				this.updateDetail(dataList, dataMaster, user);
			if(paramData.get("method").equals("deleteDetail"))
				this.deleteDetail(dataList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/* Main Grid directProxy */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// INSERT
	public Integer  insertDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
        
        for (Map param : paramList) {
        	if(param.get("WORK_SHOP_CODE") == null) {
        		param.put("WORK_SHOP_CODE", "*");
        	}
        	
        	for(int i = 1; i < 32; i++) {
        		if(ObjUtils.parseInt(param.get("DAY"+i+"_Q")) != 0) {
        			param.put("WK_PLAN_Q", param.get("DAY"+i+"_Q"));
        			if(i < 10) {
						param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
					}else {
						param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i );
					}
        			
        			Map cnt = (Map) super.commonDao.select("ppl100ukrvServiceImpl.checkBeforeInsert", param);
        			if(ObjUtils.parseInt(cnt.get("CNT")) > 0) {
        				throw new UniDirectValidateException(this.getMessage("2627", user));
        			}
        			
    				Map<String, Object> spParam = new HashMap<String, Object>();
                    
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
                    Date dateGet = new Date();
                    String dateGetString = dateFormat.format(dateGet);
                    
                    spParam.put("COMP_CODE", user.getCompCode());
                    spParam.put("DIV_CODE", user.getDivCode());
                    spParam.put("TABLE_ID", "PPL100T");
                    spParam.put("PREFIX", "P");
                    spParam.put("BASIS_DATE", dateGetString);
                    spParam.put("AUTO_TYPE", "1");
                    super.commonDao.queryForObject("ppl100ukrvServiceImpl.spAutoNum", spParam);
                    
                    param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                    super.commonDao.update("ppl100ukrvServiceImpl.insertDetail", param);
        		}
        	}
        }

		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
        
        for (Map param : paramList) {
        	if(param.get("WORK_SHOP_CODE") == null) {
        		param.put("WORK_SHOP_CODE", "*");
        	}
        	
        	for(int i = 1; i < 32; i++) {
    			param.put("WK_PLAN_Q", param.get("DAY"+i+"_Q"));
    			if(i < 10) {
					param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
				}else {
					param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i);
				}
    			
    			Map wkPlanNum = (Map) super.commonDao.select("ppl100ukrvServiceImpl.getWkPlanNum", param);
    			System.out.println(wkPlanNum);
    			if(wkPlanNum != null && wkPlanNum.get("WK_PLAN_NUM") != null) {
    				param.put("WK_PLAN_NUM", wkPlanNum.get("WK_PLAN_NUM"));
    				super.commonDao.update("ppl100ukrvServiceImpl.updateDetail", param);
    			}else {
    				if(ObjUtils.parseInt(param.get("DAY"+i+"_Q")) != 0) {
    					Map<String, Object> spParam = new HashMap<String, Object>();
                        
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
                        Date dateGet = new Date();
                        String dateGetString = dateFormat.format(dateGet);
                        
                        spParam.put("COMP_CODE", user.getCompCode());
                        spParam.put("DIV_CODE", user.getDivCode());
                        spParam.put("TABLE_ID", "PPL100T");
                        spParam.put("PREFIX", "P");
                        spParam.put("BASIS_DATE", dateGetString);
                        spParam.put("AUTO_TYPE", "1");
                        super.commonDao.queryForObject("ppl100ukrvServiceImpl.spAutoNum", spParam);
                        
                        param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                        super.commonDao.update("ppl100ukrvServiceImpl.insertDetail", param);
    				}
    			}

        	}
        }
        
		return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// DELETE
	public Integer deleteDetail(List<Map> paramList, Map dataMaster, LoginVO user) throws Exception {
		
		for(Map param : paramList )	{
			if(param.get("GUBUN").toString().equals("계획")) {
				for(int i = 1; i < 32; i++) {
					String s = "WK_PLAN_NUM" + i;
					if(param.get(s) != null) {
						param.put("WK_PLAN_NUM", param.get(s));
						
						if(i < 10) {
							param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + "0" + i + "");
						}else {
							param.put("PRODT_PLAN_DATE", dataMaster.get("FR_DATE").toString() + i);
						}
						logger.debug("param:" + param);
						System.out.println(param.toString());
						super.commonDao.update("ppl100ukrvServiceImpl.deleteDetail", param);
					}
				}
			}
		}
		
		return 0;
	}
	
}
