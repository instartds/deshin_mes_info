package foren.unilite.modules.coop.dhl;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("dhl200ukrvService")
public class Dhl200ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 조합원 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("dhl200ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
								
				
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
						
			for(Map param:  dataList) {
				this.updateDetail(param, user);				
				Map<String, Object> spParam = new HashMap<String, Object>();
				String flag = (String) (param.get("PICKUP_YN_FLAG").equals("0") ? "N" : (ObjUtils.isEmpty(param.get("PICKUP_YN_FLAG")) ? "" : "Y"));
				spParam.put("Flag", flag);		
				spParam.put("RreceiptNo", param.get("RECEIPT_NO"));
				if(!flag.equals("") && param.get("RECEIPT_TYPE").equals("1")){	//flag 값이 있고, 접수구분이 dhl일때만 sp 실행
					super.commonDao.queryForObject("dhl200ukrvService.DHL_Pickingup", spParam);
				}				
				String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));			
				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");			
				if(!ObjUtils.isEmpty(errorDesc)){			
					String[] messsage = errorDesc.split(";");
				    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				}				
			}
			
		}	
		paramList.add(0, paramMaster);		
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			
			List<Map> chkList = (List<Map>) super.commonDao.list("dhl200ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("dhl200ukrvService.insertDetail", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")		// UPDATE
	public Integer updateDetail(Map param, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("dhl200ukrvService.checkCompCode", compCodeMap);		
		for(Map checkCompCode : chkList) {
			param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
			super.commonDao.update("dhl200ukrvService.updateDetail", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(group = "coop", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("dhl200ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("dhl200ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	} 
}
