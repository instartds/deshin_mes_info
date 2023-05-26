package foren.unilite.modules.matrl.mrp;

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




@Service("mrp160ukrvService")
public class Mrp160ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // mrp 전개(실행)
    public List<Map<String, Object>>  spCall(Map param) throws Exception {  
        return  super.commonDao.list("mrp160ukrvServiceImpl.spCall", param);
    } 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	public ExtDirectFormPostResult syncForm(Mrp160ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("mrp160ukrvServiceImpl.checkCompCode", compCodeMap);
		
		//4. Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		 for(Map checkCompCode : chkList) {
			 spParam.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
		 }
		spParam.put("DIV_CODE", dataMaster.getDIV_CODE());
		spParam.put("PLAN_PRSN", dataMaster.getPLAN_PRSN());
		spParam.put("ROP_DATE", dataMaster.getROP_DATE());
		spParam.put("BASE_DATE", dataMaster.getBASE_DATE());
		spParam.put("EXC_STOCK_YN", dataMaster.getEXC_STOCK_YN());
		spParam.put("STOCK_YN", dataMaster.getSTOCK_YN());
		spParam.put("SAFE_STOCK_YN", dataMaster.getSAFE_STOCK_YN());
		spParam.put("INSTOCK_PLAN_YN", dataMaster.getINSTOCK_PLAN_YN());
		spParam.put("OUTSTOCK_PLAN_YN", dataMaster.getOUTSTOCK_PLAN_YN());
		spParam.put("CUSTOM_STOCK_YN", dataMaster.getCUSTOM_STOCK_YN());
		spParam.put("ITEM_CODE", dataMaster.getITEM_CODE());
		spParam.put("ITEM_NAME", dataMaster.getITEM_NAME());
		spParam.put("ITEM_LEVEL1", dataMaster.getITEM_LEVEL1());
		spParam.put("ITEM_LEVEL2", dataMaster.getITEM_LEVEL2());
		spParam.put("ITEM_LEVEL3", dataMaster.getITEM_LEVEL3());
		spParam.put("USER_ID", user.getUserID());

		super.commonDao.queryForObject("mrp160ukrvServiceImpl.spROPRequirementsExplosion", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		return extResult;	
	}

	
	
	
}
