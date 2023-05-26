package foren.unilite.modules.matrl.mpo;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("mpo090ukrvService")
public class Mpo090ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		param.put("MRP_CONTROL_NUM", param.get("MRP_CONTROL_NUM"));
		return super.commonDao.list("mpo090ukrvServiceImpl.selectDetailList", param);
	}
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1_Print(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectDetailList1_Print", param);
	}
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectDetailList2", param);
	}	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectDetailList3", param);
	}
	
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3_Print(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectDetailList3_Print", param);
	}
	
	/**
	 *  GETDATE 주차
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public Map getThisWeek(Map param) throws Exception{
		return (Map) super.commonDao.select("mpo090ukrvServiceImpl.getThisWeek", param);
	}
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getOrderWeek(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("mpo090ukrvServiceImpl.getOrderWeek", param);

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
		return super.commonDao.list("mpo090ukrvServiceImpl.selectOrderList", param);
	}
	/**
	 * 
	 * 생산계획 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectProdList(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectProdList", param);
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
			if(ObjUtils.parseDouble(ObjUtils.getSafeString(param.get("ORDER_REQ_Q"))) > 0){
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("COMP_CDOE", user.getCompCode());
				param.put("WORK_STEP", "S");  //'T':임시,'M':소요량, 'S': 수주정보 참조 쪽 소요량
				if(ObjUtils.isEmpty(param.get("SER_NO"))){
					param.put("SER_NO", 0);
				}
	
				super.commonDao.insert("mpo090ukrvServiceImpl.insertLogDetail", param);
			}
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
		
		super.commonDao.queryForObject("mpo090ukrvServiceImpl.USP_MATRL_MPO070UKRV", spParam);
		
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
				this.buttonInsert(keyValue, insertList, user, dataMaster);
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	private void insertLogButton(String keyValue, String oprFlag, String remark, List<Map> dataList, LoginVO user)throws Exception {
		for(Map param:  dataList) {
			Map checkOrder = (Map) super.commonDao.select("mpo090ukrvServiceImpl.checkOrder", param);

            if(ObjUtils.isNotEmpty(checkOrder) && ObjUtils.getSafeString(checkOrder.get("ORDER_YN")).equals("Y")){
                throw new  UniDirectValidateException("이미 발주확정된 데이터가 있습니다. 확인 후 다시 시도해 주십시오.");
            }else{
			
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				param.put("REMARK", remark);
				param.put("COMP_CDOE", user.getCompCode());
				param.put("WORK_STEP", "S");  //'T':임시,'M':소요량, 'S': 수주정보 참조 쪽 소요량
				if(ObjUtils.isEmpty(param.get("SER_NO"))){
					param.put("SER_NO", 0);
				}
				
				super.commonDao.insert("mpo090ukrvServiceImpl.insertLogMaster", param);
            }
		}
		
		return;
	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public int buttonInsert(String keyValue, List<Map> dataList, LoginVO user, Map dataMaster) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		
		super.commonDao.queryForObject("mpo090ukrvServiceImpl.USP_CALC_PL", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc)){
			throw new Exception(errorDesc);
		}else{
			dataMaster.put("RtnMrpNum", ObjUtils.getSafeString(spParam.get("RtnMrpNum")));
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
			int res = super.commonDao.update("mpo090ukrvServiceImpl.deleteMaster", param);
			if(res > 0) {
				super.commonDao.update("mpo090ukrvServiceImpl.updateProdtPlan", param);
				super.commonDao.update("mpo090ukrvServiceImpl.deleteDetail", param);
			}
		}
		return 0;
	}
	
	

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		return super.commonDao.list("mpo090ukrvServiceImpl.selectExcelUploadSheet", param);
	}
	
	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
		logger.debug("validate: {}", jobID);
		super.commonDao.update("mpo090ukrvServiceImpl.excelValidate", param);
	}
}
