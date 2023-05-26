package foren.unilite.modules.sales.sat;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.z_mit.S_sas200ukrv_mitModel;

@Service("sat300ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "sat100ukrvService")
	private Sat100ukrvServiceImpl sat100ukrvService;
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
	public Object selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("sat300ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat300ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public Map<String, Object> checkDelete(Map param) throws Exception {
		
		List<Map<String, Object>> checkDelete = super.commonDao.list("sat300ukrvServiceImpl.checkDelete", param);
		
		if(ObjUtils.isNotEmpty(checkDelete) && checkDelete.size() > 0)	{
			String message = "";
			for(Map data: checkDelete)		{
				message = message + ObjUtils.getSafeString(data.get("ASST_NAME")) 
				            + "(" + ObjUtils.getSafeString(data.get("ASST_CODE"))+")\n";
			}
			throw new  UniDirectValidateException("예약을 삭제 할 수 없는 자산이 있어 삭제할 수 없습니다. 자산의 현재상태를 확인하세요.||"+message);
		}
		return param;
	}
	
	@ExtDirectMethod(group = "sales")
	public String selectReserveNo(Sat300ukrvModel dataMaster) throws Exception {
		String reserveNo = "";
		Map<String, Object> param = new HashMap();
		param.put("S_COMP_CODE",dataMaster.getS_COMP_CODE());
		param.put("DIV_CODE",dataMaster.getDIV_CODE());
		param.put("RESERVE_DATE",dataMaster.getRESERVE_DATE());
		reserveNo =(String) super.commonDao.select("sat300ukrvServiceImpl.selectReserveNo", param);
		return 	reserveNo;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult syncMaster(Sat300ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		String reserveNo = dataMaster.getRESERVE_NO();
		//수리견적번호 생성
		if(ObjUtils.isEmpty(reserveNo))	{
			reserveNo = this.selectReserveNo(dataMaster);
			dataMaster.setRESERVE_NO(reserveNo);
		}
		
		super.commonDao.update("sat300ukrvServiceImpl.updateMaster", dataMaster);
		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("RESERVE_NO", reserveNo);
		return extResult;
	}
	/**
	 *  저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> insert = null;
		List<Map> update = null;
		List<Map> delete = null;
		
		Sat300ukrvModel masterModel = new Sat300ukrvModel();

		
		masterModel.setS_COMP_CODE(user.getCompCode());
		masterModel.setDIV_CODE(ObjUtils.getSafeString(dataMaster.get("DIV_CODE")));
		masterModel.setRESERVE_NO(ObjUtils.getSafeString(dataMaster.get("RESERVE_NO")));
		masterModel.setRESERVE_DATE(ObjUtils.getSafeString(dataMaster.get("RESERVE_DATE")));
		masterModel.setCUSTOM_NAME(ObjUtils.getSafeString(dataMaster.get("CUSTOM_NAME")));
		masterModel.setAGENT_CUSTOM_CODE(ObjUtils.getSafeString(dataMaster.get("AGENT_CUSTOM_CODE")));
		masterModel.setREQ_OUT_DATE(ObjUtils.getSafeString(dataMaster.get("REQ_OUT_DATE")));
		masterModel.setUSE_GUBUN(ObjUtils.getSafeString(dataMaster.get("USE_GUBUN")));
		masterModel.setUSE_FR_DATE(ObjUtils.getSafeString(dataMaster.get("USE_FR_DATE")));
		masterModel.setUSE_TO_DATE(ObjUtils.getSafeString(dataMaster.get("USE_TO_DATE")));
		
		masterModel.setUSE_FR_TIME(ObjUtils.getSafeString(dataMaster.get("USE_FR_TIME")));
		masterModel.setUSE_TO_TIME(ObjUtils.getSafeString(dataMaster.get("USE_TO_TIME")));
		
		masterModel.setDELIVERY_ADDRESS(ObjUtils.getSafeString(dataMaster.get("DELIVERY_ADDRESS")));
		masterModel.setBUTTON_G7_YN(ObjUtils.getSafeString(dataMaster.get("BUTTON_G7_YN")));
		masterModel.setBUTTON_G7_SET(ObjUtils.getSafeString(dataMaster.get("BUTTON_G7_SET")));
		masterModel.setBUTTON_G5_YN(ObjUtils.getSafeString(dataMaster.get("BUTTON_G5_YN"))); 
		masterModel.setBUTTON_G5_SET(ObjUtils.getSafeString(dataMaster.get("BUTTON_G5_SET")));
		
		masterModel.setFS_YN(ObjUtils.getSafeString(dataMaster.get("FS_YN")));
		masterModel.setGATEWAY_CUST_NM(ObjUtils.getSafeString(dataMaster.get("GATEWAY_CUST_NM")));
		masterModel.setGATEWAT_YN(ObjUtils.getSafeString(dataMaster.get("GATEWAT_YN")));
		masterModel.setDELIVERY_METH(ObjUtils.getSafeString(dataMaster.get("DELIVERY_METH")));
		masterModel.setREQ_USER(ObjUtils.getSafeString(dataMaster.get("REQ_USER")));
		masterModel.setREMARK(ObjUtils.getSafeString(dataMaster.get("REMARK")));
		masterModel.setS_USER_ID(user.getUserID());
		
		if(ObjUtils.isEmpty(masterModel.getRESERVE_NO()))	{
			String reserveNo = this.selectReserveNo(masterModel);
			masterModel.setRESERVE_NO(reserveNo);
			dataMaster.put("RESERVE_NO", reserveNo);
		}
		
		super.commonDao.update("sat300ukrvServiceImpl.updateMaster", masterModel);
		
		for(Map param: paramList) {
			if(param.get("method").equals("insertDetail")) {
				insert = (List<Map>)param.get("data");
			} else if(param.get("method").equals("updateDetail")) {
				update = (List<Map>)param.get("data");
			} else if(param.get("method").equals("deleteDetail")) {
				delete = (List<Map>)param.get("data");
			}
		}
		
		if(delete != null) this.deleteDetail(delete, user, dataMaster, insert);
		if(insert != null) this.insertDetail(insert, user, dataMaster);
		if(update != null) this.updateDetail(update, user, dataMaster);

		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales")
	public int selectReserveSeq(Map<String,Object> param) throws Exception {
		Map<String, Object> r = (Map<String, Object>) super.commonDao.select("sat300ukrvServiceImpl.selectReserveSeq", param);
		int seq = ObjUtils.parseInt(r.get("RESERVE_SEQ"));
		return seq;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			if(ObjUtils.isEmpty(param.get("RESERVE_NO")))	{
				param.put("RESERVE_NO", paramMaster.get("RESERVE_NO"));
			}
			int seq = this.selectReserveSeq(param);
			param.put("RESERVE_SEQ", seq);
			super.commonDao.insert("sat300ukrvServiceImpl.insertDetail", param);
			//상태update
			Map statusParam = new HashMap();
			statusParam.put("S_COMP_CODE", param.get("S_COMP_CODE"));
			statusParam.put("DIV_CODE", param.get("DIV_CODE"));
			statusParam.put("ASST_CODE", param.get("ASST_CODE"));
			statusParam.put("RESERVE_YN", "Y");
			statusParam.put("S_USER_ID", user.getUserID());
			sat100ukrvService.updateStatus(statusParam, user);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("sat300ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> paramList, LoginVO user, Map paramMaster, List<Map> insertList) throws Exception {
		
		//삭제 가능 여부 확인
		String[] asstCode = new String[paramList.size()];
		int idx = 0;
		for(Map param: paramList)		{
			asstCode[idx++] = ObjUtils.getSafeString(param.get("ASST_CODE"));
		}
		Map checkParam = new HashMap();
		checkParam.put("S_COMP_CODE", user.getCompCode());
		checkParam.put("DIV_CODE", paramMaster.get("DIV_CODE"));
		checkParam.put("ASST_CODE", asstCode);
		checkParam.put("RESERVE_NO", paramMaster.get("RESERVE_NO"));
		this.checkDelete(checkParam);
		
		for(Map param: paramList)		{
			
			super.commonDao.update("sat300ukrvServiceImpl.deleteDetail", param);

			param.put("RESERVE_YN", "N");
			sat100ukrvService.updateStatus(param, user);
		}
		
		if(ObjUtils.isEmpty(insertList))	{
			List<Map> delList = (List<Map>) super.commonDao.list("sat300ukrvServiceImpl.selectList", paramMaster);
			if(ObjUtils.isEmpty(delList) ) {
				super.commonDao.update("sat300ukrvServiceImpl.deleteAll", paramMaster);
				paramMaster.put("DELETEALL", "Y");
			}
		}
	}
	
	@ExtDirectMethod(group = "sales")
	public Map deleteAll( Map param, LoginVO user) throws Exception {
		List<Map> delList = (List<Map>) super.commonDao.list("sat300ukrvServiceImpl.selectList", param);
		
		String[] asstCode = new String[delList.size()];
		int idx = 0;
		for(Map data: delList)		{
			asstCode[idx++] = ObjUtils.getSafeString(data.get("ASST_CODE"));
		}
		Map checkParam = new HashMap();
		checkParam.put("S_COMP_CODE", user.getCompCode());
		checkParam.put("DIV_CODE", param.get("DIV_CODE"));
		checkParam.put("ASST_CODE", asstCode);
		checkParam.put("RESERVE_NO", param.get("RESERVE_NO"));
		this.checkDelete(checkParam);
		
		for(Map dparam: delList)		{
			//상태update
			dparam.put("RESERVE_YN", "N");
			dparam.put("S_COMP_CODE", user.getCompCode());
			dparam.put("S_USER_ID", user.getUserID());
			sat100ukrvService.updateStatus(dparam, user);
		}
		super.commonDao.update("sat300ukrvServiceImpl.deleteAll", param);
		return param;
	}
	
	
	@ExtDirectMethod(group = "sales")
	public Integer updateReqYn(Map param, LoginVO user) throws Exception {
		super.commonDao.update("sat300ukrvServiceImpl.updateReqYn", param);
		return 0;
	}
	
}
