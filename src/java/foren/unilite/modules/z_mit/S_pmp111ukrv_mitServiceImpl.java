package foren.unilite.modules.z_mit;

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

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Service("s_pmp111ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmp111ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 미등록 탭 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> tab1SelectList(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.tab1SelectList", param);
	}
	/**
	 * 등록 탭 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> tab2SelectList(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.tab2SelectList", param);
	}

	/**
	 * 미등록 탭 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> tab1SaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("tab1DeleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("tab1InsertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("tab1UpdateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.tab1DeleteDetail(deleteList, user);
			if(insertList != null) this.tab1InsertDetail(insertList, user);
			if(updateList != null) this.tab1UpdateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab1InsertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab1UpdateDetail(List<Map> paramList, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		int nm = 1;
		for(Map param :paramList )  {
			if(param.get("CHECK").equals("Y")){
				param.put("_EXCEL_JOBID", keyValue);
				param.put("_EXCEL_ROWNUM", nm);
				nm += 1;
				super.commonDao.insert("s_pmp111ukrv_mitServiceImpl.insertTab1", param);
			}
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", keyValue);
		super.commonDao.queryForObject("s_pmp111ukrv_mitServiceImpl.spCallTab1", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab1DeleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 return;
	}

	/**
	 * 등록 탭 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> tab2SaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("tab2DeleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("tab2InsertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("tab2UpdateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.tab2DeleteDetail(deleteList, user);
			if(insertList != null) this.tab2InsertDetail(insertList, user);
			if(updateList != null) this.tab2UpdateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab2InsertDetail(List<Map> paramList, LoginVO user) throws Exception {
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab2UpdateDetail(List<Map> paramList, LoginVO user) throws Exception {
		//20200225추가
		for(Map param :paramList ) {
			super.commonDao.update("s_pmp111ukrv_mitServiceImpl.tab2UpdateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public void tab2DeleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			String keyValue = getLogKey();
			String oprFlag = "D";
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			List<Map> progWorkList = null;
			progWorkList =  super.commonDao.list("s_pmp111ukrv_mitServiceImpl.progWorkCodeList", param);
			for(Map progWorkParam : progWorkList){
				param.put("PROG_WORK_CODE", progWorkParam.get("PROG_WORK_CODE"));
				param.put("PROG_UNIT_Q", 1);
				super.commonDao.insert("s_pmp111ukrv_mitServiceImpl.insertLogMaster", param);
			}
			Map<String, Object> spParam = new HashMap<String, Object>();
			spParam.put("KeyValue", keyValue);
			spParam.put("LangCode", user.getLanguage());
			super.commonDao.queryForObject("s_pmp111ukrv_mitServiceImpl.USP_PRODT_Pmp100ukr", spParam);
			String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		return;
	}


	public void excelValidate(String jobID, Map param) throws Exception {					// 엑셀 Validate
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KeyValue", jobID);
		Map checkExcelError = (Map) super.commonDao.select("s_pmp111ukrv_mitServiceImpl.checkExcelError", spParam);
		
		if(!checkExcelError.get("_EXCEL_ERROR_MSG").equals("")){
			throw new  UniDirectValidateException(ObjUtils.getSafeString(checkExcelError.get("_EXCEL_ERROR_MSG")));
		}
		
		super.commonDao.queryForObject("s_pmp111ukrv_mitServiceImpl.spCallTab1", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new UniDirectValidateException(messsage[0]);
		}
		return;
	}
	
	
	
	
	/**
	 * 레포트 타입 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public Map selectFormType(Map param) throws Exception{
		return (Map) super.commonDao.select("s_pmp111ukrv_mitServiceImpl.selectFormType", param);
	}
	
	/**
	 * SUB ASS'Y 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList1(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.selectList1", param);
	}	
	
	/**
	 * 소요자재 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList1_2(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.selectList1_2", param);
	}
	/**
	 * 중간검사성적서 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList2(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.selectList2", param);
	}
	

	
	/**
	 * 소요자재 조회 B
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList2_B(Map param) throws Exception{
		return super.commonDao.list("s_pmp111ukrv_mitServiceImpl.selectList2_B", param);
	}
	
	
	
	/**
	 * 작업지시내역 - 정규
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmp111ukrv_mitServiceImpl.mainReport", param);
	}
	
	/**
	 * 자재내역 - 정규
	 * @param param 검색항목
	 * @return	
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmp111ukrv_mitServiceImpl.subReport", param);
	}
}