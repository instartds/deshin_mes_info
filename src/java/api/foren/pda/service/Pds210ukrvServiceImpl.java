package api.foren.pda.service;

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
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
/**
 * 정상입고(제품) 正常入库（产品）
 * @author Administrator
 *
 */
@Service("pds210ukrvService")
public class Pds210ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)		// 작업실적등록 조회
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("pds210ukrvServiceImpl.selectDetailList", param);
	}
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveInNormalProd(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		String keyValue = getLogKey();						
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
	
		for(Map param: paramList) {			
			
			String oprFlag =  param.get("CRUD").toString();
			if("U".equals(oprFlag)){
				oprFlag ="N";
			}
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			Map<String, Object> dataMaster = paramMaster;
            Map<String, Object> spParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            
            String prodtNum = (String) dataMaster.get("PRODT_NUM");
            spParam.put("COMP_CODE", param.get("COMP_CODE"));            
            spParam.put("DIV_CODE", param.get("DIV_CODE"));
            spParam.put("TABLE_ID","pmr100ukrv");
            spParam.put("PREFIX", "P");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");


            param.put("STATUS",     oprFlag);		
//                param.put("USER_ID",    user.getUserID());                    
            param.put("PRODT_TYPE",  "1");       
            if(param.get("STATUS").equals("N")) {
                //자동채번
                super.commonDao.queryForObject("pmr100ukrvServiceImpl.spAutoNum", spParam);
                prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                param.put("PRODT_NUM",  prodtNum);
                param.put("PASS_Q", ObjUtils.parseDouble(param.get("GOOD_Q")));
                super.commonDao.update("pmr100ukrvServiceImpl.insertDetail3", param);
            } else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {                        
                super.commonDao.update("pmr100ukrvServiceImpl.updateDetail3", param);
            } else {
                super.commonDao.update("pmr100ukrvServiceImpl.deleteDetail3", param);
            }
            
            double zero = 0;
            
//                param.put("COMP_CODE", user.getCompCode());
            param.put("DIV_CODE", param.get("DIV_CODE"));
            param.put("PRODT_NUM", param.get("PRODT_NUM"));
            param.put("WKORD_NUM", param.get("WKORD_NUM"));
            param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
            param.put("PRODT_TYPE", "1");
            param.put("RESULT_YN", "2");
            param.put("STATUS", param.get("FLAG"));
//                param.put("USER_ID", user.getUserID());  
//            System.out.println("[[RESULT_YN]]" + param.get("RESULT_YN"));
            if(param.get("RESULT_YN").equals("2")) {
                param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_Q")));
                param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
                param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
                param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
                param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_Q")));
                param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
                param.put("BAD_PRSN", param.get("BAD_PRSN"));
                param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
            } else {
                param.put("GOOD_WH_CODE", "");
                param.put("GOOD_WH_CELL_CODE", "");
                param.put("GOOD_PRSN", "");
                param.put("GOOD_Q", zero);
                param.put("BAD_WH_CODE", "");
                param.put("BAD_WH_CELL_CODE", "");
                param.put("BAD_PRSN", "");
                param.put("BAD_Q", zero);
            }
                                  
            super.commonDao.update("pmr100ukrvServiceImpl.spReceiving", param);
            String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
            if(!ObjUtils.isEmpty(errorDesc)) {
//                    String[] messsage = errorDesc.split(";");
            	
    			paramMaster.put("ERROR", errorDesc);
    			paramList.add(0, paramMaster);	
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } 

		}

		
		return  paramList;
	}
	

	
}
