package foren.unilite.modules.sales.set;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("set220ukrvService")
public class Set220ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {
		return  super.commonDao.list("set220ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "set")
	public List<Map<String, Object>>  selectMaster2(Map param) throws Exception {
		return  super.commonDao.list("set220ukrvServiceImpl.selectMaster2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		//1.로그테이블에서 사용할 KeyValue 생성
		  String keyValue = getLogKey();
		    
		  //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		  List<Map> dataList = new ArrayList<Map>();
		  List<List<Map>> resultList = new ArrayList<List<Map>>();
		  
		  for(Map paramData: paramList) {

			  dataList = (List<Map>) paramData.get("data");

			  for(Map param: dataList) {
				  param.put("KEY_VALUE", keyValue);
				  param.put("OPR_FLAG", "U");
				  
				  if(paramData.get("method").equals("updateDetail")){
					  
					  param.put("INOUT_NUM", param.get("P_INOUT_NUM"));
					  param.put("INOUT_SEQ", param.get("P_INOUT_SEQ"));
					  param.put("INOUT_TYPE", param.get("P_INOUT_TYPE"));
					  param.put("INOUT_Q", param.get("P_INOUT_Q"));
					  param.put("INOUT_P", param.get("P_INOUT_P"));
					  param.put("INOUT_I", param.get("P_INOUT_I"));
					  
				  }else if(paramData.get("method").equals("updateDetail2")){
					  
					  param.put("INOUT_NUM", param.get("C_INOUT_NUM"));
					  param.put("INOUT_SEQ", param.get("C_INOUT_SEQ"));
					  param.put("INOUT_TYPE", param.get("C_INOUT_TYPE"));
					  param.put("INOUT_Q", param.get("C_INOUT_Q"));
					  param.put("INOUT_P", param.get("C_INOUT_P"));
					  param.put("INOUT_I", param.get("C_INOUT_I"));
				  }
				  
				  param.put("data", super.commonDao.insert("set220ukrvServiceImpl.updateLogDetail", param));
			  }
		  }
		  
		  //4.접수등록 Stored Procedure 실행
		  Map<String, Object> spParam = new HashMap<String, Object>();
          
		  spParam.put("KEY_VALUE", keyValue);
		  spParam.put("LANG_CODE", user.getLanguage());
          
		  super.commonDao.queryForObject("spSet220ukrv", spParam);
		  
		  String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		  
		  //접수등록 마스터 출하지시 번호 update
		  Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		  		
		  if(!ObjUtils.isEmpty(errorDesc)){
		  	String[] messsage = errorDesc.split(";");
		      throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		  }
			
		  paramList.add(0, paramMaster);
		  return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		return 0;
	}
}