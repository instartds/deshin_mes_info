package foren.unilite.modules.prodt.pmp;

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



@Service("pmp200ukrvService")
public class Pmp200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	

	
	
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectAgreePrsn(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.selectAgreePrsn", param);
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderNumMasterList(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.selectOrderNumMaster", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.selectEstiList", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.printList", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderApply(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.orderApply", param);		// 참조 팝업 적용버튼 클릭시
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> orderApply2(Map param) throws Exception {
		return super.commonDao.list("pmp200ukrvServiceImpl.orderApply2", param);		// 참조 팝업 적용버튼 클릭시2
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();						
				
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("WORK_SHOP_CODE",dataMaster.get("WORK_SHOP_CODE"));
				param.put("OUTSTOCK_REQ_DATE",dataMaster.get("OUTSTOCK_REQ_DATE"));
				param.put("data", super.commonDao.insert("pmp200ukrvServiceImpl.insertLogMaster", param));
			}
		}
		
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);

	    super.commonDao.queryForObject("pmp200ukrvServiceImpl.spPmp200ukr", spParam);
	    
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
	
//		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList )	{
		if(!ObjUtils.isEmpty(ErrorDesc)){
//			dataMaster.put("INOUT_NUM", "");
			String[] messsage = ErrorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			//마스터에 SET
			dataMaster.put("OUTSTOCK_NUM", ObjUtils.getSafeString(spParam.get("OutStockNum")));
			//그리드에 SET
			for(Map param: paramList)  {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("OUTSTOCK_NUM", ObjUtils.getSafeString(spParam.get("OutStockNum")));
					}
				}
			}		
			
		}
		paramList.add(0, paramMaster);
		
		
		return  paramList;
	}
	
	
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateDetail(List<Map> params, LoginVO user) throws Exception {
		return;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void insertDetail(List<Map> params, LoginVO user) throws Exception {
		return ;
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		return ;
	}
}
