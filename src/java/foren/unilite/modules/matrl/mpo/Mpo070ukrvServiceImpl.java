package foren.unilite.modules.matrl.mpo;

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


@Service("mpo070ukrvService")
public class Mpo070ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("mpo070ukrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		param.put("MRP_CONTROL_NUM", param.get("MRP_CONTROL_NUM"));
		return super.commonDao.list("mpo070ukrvServiceImpl.selectDetailList", param);
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
		return super.commonDao.list("mpo070ukrvServiceImpl.selectOrderList", param);
	}
	

	/**
	 * master 그리드 삭제
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//List<Map> dataList = new ArrayList<Map>();
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			if(paramData.get("method").equals("insertMaster"))	
				insertList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("updateMaster"))	
				updateList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("deleteMaster"))	
				deleteList = (List<Map>)paramData.get("data");

			if(deleteList != null) {
				this.deleteMaster(keyValue, deleteList, user);
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}

	/**
	 * datail 그리드 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//List<Map> dataList = new ArrayList<Map>();
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	
				insertList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("updateDetail"))	
				updateList = (List<Map>)paramData.get("data");
			if(paramData.get("method").equals("deleteDetail"))	
				deleteList = (List<Map>)paramData.get("data");

			if(insertList != null) {
				oprFlag = "N";
				this.insertLogDetail(keyValue, oprFlag, insertList, user);
				this.insertDetail(keyValue, insertList, user);
			}
			if(updateList != null) {
				oprFlag = "U";
				this.insertLogDetail(keyValue, oprFlag, updateList, user);
				this.updateDetail(keyValue, updateList, user);
			}
			if(deleteList != null) {
				oprFlag = "D";
				this.insertLogDetail(keyValue, oprFlag, deleteList, user);
				this.deleteDetail(keyValue, deleteList, user);
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	private void insertLogDetail(String keyValue, String oprFlag, List<Map> dataList, LoginVO user) {
		for(Map param:  dataList) {
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			param.put("COMP_CDOE", user.getCompCode());
			param.put("WORK_STEP", "M");  //'T':임시,'M':소요량
			if(ObjUtils.isEmpty(param.get("SER_NO"))){
				param.put("SER_NO", 0);
			}

			super.commonDao.insert("mpo070ukrvServiceImpl.insertLogDetail", param);
		}
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
        return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int updateDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		
		super.commonDao.queryForObject("mpo070ukrvServiceImpl.USP_MATRL_MPO070UKRV", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new Exception(errorDesc);
		}

		return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int deleteDetail(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		return 0;
	}
	
	
	/**
	 * 소요량계산 버튼 누를시 
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> buttonSave(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String remark = ObjUtils.getSafeString(dataMaster.get("REMARK"));
		
		//2. KEY_VALUE, OPR_FLAG 업데이트
		for(Map paramData: paramList) {
			List<Map> insertList = null;
			
			String oprFlag = "N";
			if(paramData.get("method").equals("buttonInsert"))	
				insertList = (List<Map>)paramData.get("data");
			
			if(insertList != null) {
				oprFlag = "N";
				this.insertLogButton(keyValue, oprFlag, remark, insertList, user);
				this.buttonInsert(keyValue, insertList, user);
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	private void insertLogButton(String keyValue, String oprFlag, String remark, List<Map> dataList, LoginVO user) {
		for(Map param:  dataList) {
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			param.put("REMARK", remark);
			param.put("COMP_CDOE", user.getCompCode());
			param.put("WORK_STEP", "M");  //'T':임시,'M':소요량
			if(ObjUtils.isEmpty(param.get("SER_NO"))){
				param.put("SER_NO", 0);
			}
			
			super.commonDao.insert("mpo070ukrvServiceImpl.insertLogMaster", param); 
		}
	}
	
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int buttonInsert(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		
		super.commonDao.queryForObject("mpo070ukrvServiceImpl.USP_CALC_BOMPL", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new Exception(errorDesc);
		}

		return 0;
	}
	
	
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int insertMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
        return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int updateMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		return 0;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int deleteMaster(String keyValue, List<Map> dataList, LoginVO user) throws Exception {
		for(Map param : dataList) {
			int res = super.commonDao.update("mpo070ukrvServiceImpl.deleteMaster", param);
			if(res > 0) {
				super.commonDao.update("mpo070ukrvServiceImpl.deleteDetail", param);
			}
		}
		return 0;
	}
}
