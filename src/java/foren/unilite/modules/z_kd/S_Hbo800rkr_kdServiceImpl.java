package foren.unilite.modules.z_kd;

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
import foren.unilite.modules.com.combo.ComboItemModel;


@Service("s_hbo800rkr_kdService")
public class S_Hbo800rkr_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbo")
	public String getCostPoolName(Map param, LoginVO loginVO) throws Exception {
	
		String aConfig0 = "Cost Pool";
		
		Map inParam = new HashMap();
		inParam.put("S_COMP_CODE", loginVO.getCompCode());
		
		Map<String, Object> dataMap = null;
		dataMap = (Map<String, Object>) super.commonDao.select("s_hbo800rkr_kdServiceImpl.fnstand100init", inParam);
		
		if(!ObjUtils.isEmpty(dataMap) && !ObjUtils.isEmpty(dataMap.get("REF_CODE2"))){   
			aConfig0 = dataMap.get("REF_CODE2")+"";
		}
		return aConfig0;
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbo")
	public List<ComboItemModel> getCostPoolValueList(Map param, LoginVO loginVO) throws Exception {
		Map inParam = new HashMap();
		inParam.put("S_COMP_CODE", loginVO.getCompCode());
		
		return (List<ComboItemModel>)super.commonDao.list("s_hbo800rkr_kdServiceImpl.getCostPoolList", inParam);
		
	}
	
	//@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbo")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	@ExtDirectMethod( group = "human")
	public void initPrintData(Map paramMaster, LoginVO loginVO) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		super.commonDao.update("s_hbo800rkr_kdServiceImpl.createTable",dataMaster);
		
		
		//HAT200PH
		List<Map<String,Object>> list = super.commonDao.list("s_hbo800rkr_kdServiceImpl.selectDutyCode",dataMaster);
		if(list != null && list.size()>0){
			for(int i = 0; i<list.size(); i++){
				 Map map = list.get(i);
				 Map<String,Object> tempMap = new HashMap<String,Object>();
				 tempMap.put("TEMP_I"   ,i+1);
				 tempMap.put("SUB_CODE" , map.get("SUB_CODE"));
				 tempMap.put("CODE_NAME", map.get("CODE_NAME") );
				 tempMap.put("S_COMP_CODE",dataMaster.get("S_COMP_CODE"));
				 super.commonDao.insert("s_hbo800rkr_kdServiceImpl.insertHAT200PH", tempMap);
			}
		}
		
		//HPA900
		List<Map<String,Object>> bonusCodeList = super.commonDao.list("s_hbo800rkr_kdServiceImpl.selectBonusCode",dataMaster);
		if(bonusCodeList == null || bonusCodeList.size()== 0){
			List<Map<String,Object>> h034List = super.commonDao.list("s_hbo800rkr_kdServiceImpl.selectH034",dataMaster);
			bonusCodeList = h034List;
		}
		
		if(bonusCodeList != null && bonusCodeList.size()>0){
			for(int i = 0; i<bonusCodeList.size(); i++){
				 Map map = bonusCodeList.get(i);
				 Map<String,Object> tempMap = new HashMap<String,Object>();
				 tempMap.put("TEMP_I"   ,i+1);
				 tempMap.put("SUB_CODE" , map.get("SUB_CODE"));
				 tempMap.put("CODE_NAME", map.get("CODE_NAME") );
				 tempMap.put("S_COMP_CODE",dataMaster.get("S_COMP_CODE"));
				 super.commonDao.insert("s_hbo800rkr_kdServiceImpl.insertHPA900", tempMap);
			}
		}
		
		//HBO800
		List<Map<String,Object>> wagesCodeList = super.commonDao.list("s_hbo800rkr_kdServiceImpl.selectWagesCode",dataMaster);
		if(wagesCodeList != null && wagesCodeList.size()>0){
			for(int i = 0; i<wagesCodeList.size(); i++){
				 Map map = wagesCodeList.get(i);
				 Map<String,Object> tempMap = new HashMap<String,Object>();
				 tempMap.put("TEMP_I"   ,i+1);
				 tempMap.put("WAGES_CODE" , map.get("WAGES_CODE"));
				 tempMap.put("WAGES_NAME", map.get("WAGES_NAME") );
				 tempMap.put("WAGES_SEQ", map.get("WAGES_SEQ") );
				 tempMap.put("S_COMP_CODE",dataMaster.get("S_COMP_CODE"));
				 super.commonDao.insert("s_hbo800rkr_kdServiceImpl.insertHBO800", tempMap);
			}
		}
	}

}
