package foren.unilite.modules.base.bpl;

import java.util.ArrayList;
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
@Service("bpl120ukrvService")
public class Bpl120ukrvServiceImpl extends TlabAbstractServiceImpl{	
	
	private final Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		
		return super.commonDao.list("bpl120ukrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("bpl120ukrvServiceImpl.selectDetailList", param);
	}
	
	/**
	 * 
	 * 수주 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOrderList(Map param) throws Exception {
		return super.commonDao.list("bpl120ukrvServiceImpl.selectOrderList", param);
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		//bpl120ukrvServiceImpl.USP_CALC_BOMPL
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		
		super.commonDao.queryForObject("bpl120ukrvServiceImpl.USP_CALC_BOMPL", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc)){
            throw new Exception(errorDesc);
		}
		
		for(Map dataMap : dataList) {
			super.commonDao.update("bpl120ukrvServiceImpl.updateBpl120T", dataMap);
			super.commonDao.update("bpl120ukrvServiceImpl.updateBpl130T", dataMap);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int updateMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int deleteMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		for(Map param : dataList) {
			int res = super.commonDao.update("bpl120ukrvServiceImpl.deleteMaster", param);
			if(res > 0) {
				super.commonDao.update("bpl120ukrvServiceImpl.deleteDetail", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			String oprFlag = "N";
			if(paramData.get("method").equals("insertMaster"))	
				insertList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("updateMaster"))	
				updateList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("deleteMaster"))	
				deleteList = (List<Map>)paramData.get("data");

			if(insertList != null) {
				oprFlag = "N";
				this.insertLogMaster(keyValue, oprFlag, insertList, user);
				this.insertMaster(keyValue, insertList, user);
			}
			if(updateList != null) {
				oprFlag = "U";
				this.insertLogMaster(keyValue, oprFlag, updateList, user);
				this.updateMaster(keyValue, updateList, user);
			}
			if(deleteList != null) {
				oprFlag = "D";
				this.insertLogMaster(keyValue, oprFlag, deleteList, user);
				this.deleteMaster(keyValue, deleteList, user);
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	private void insertLogMaster(String keyValue, String oprFlag, List<Map> dataList, LoginVO user) {
		for(Map param:  dataList) {
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			param.put("COMP_CDOE", user.getCompCode());
			param.put("WORK_STEP", "T");  //'T':임시,'M':소요량
			if(ObjUtils.isEmpty(param.get("SER_NO"))){
				param.put("SER_NO", 0);
			}
			super.commonDao.insert("bpl120ukrvServiceImpl.insertLogMaster", param);
		}
	}


}
