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

@Service("sat400ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat400ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "sat100ukrvService")
	private Sat100ukrvServiceImpl sat100ukrvService;
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
	public Object selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("sat400ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat400ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public Map<String, Object> checkDelete(Map param) throws Exception {
		
		List<Map<String, Object>> checkDelete = super.commonDao.list("sat400ukrvServiceImpl.checkDelete", param);
		
		if(ObjUtils.isNotEmpty(checkDelete) && checkDelete.size() > 0)	{
			String message = "";
			for(Map data: checkDelete)		{
				message = message + ObjUtils.getSafeString(data.get("ASST_NAME")) 
				            + "(" + ObjUtils.getSafeString(data.get("ASST_CODE"))+")\n";
			}
			throw new  UniDirectValidateException("연장/이동을 삭제 할 수 없는 자산이 있어 삭제할 수 없습니다. 자산의 현재상태를 확인하세요.||"+message);
		}
		return param;
	}
	
	@ExtDirectMethod(group = "sales")
	public String selectChangeNo(Sat400ukrvModel dataMaster) throws Exception {
		String reqNo = "";
		Map<String, Object> param = new HashMap();
		param.put("S_COMP_CODE",dataMaster.getS_COMP_CODE());
		param.put("DIV_CODE",dataMaster.getDIV_CODE());
		param.put("RESERVE_DATE",dataMaster.getRESERVE_DATE());
		reqNo =(String) super.commonDao.select("sat400ukrvServiceImpl.selectChangeNo", param);
		return 	reqNo;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult syncMaster(Sat400ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		String reqNo = dataMaster.getCHANGE_NO();
		//수리견적번호 생성
		if(ObjUtils.isEmpty(reqNo))	{
			reqNo = this.selectChangeNo(dataMaster);
			dataMaster.setCHANGE_NO(reqNo);
		} 
		
		super.commonDao.update("sat400ukrvServiceImpl.updateMaster", dataMaster);
		
		Map sParam = new HashMap();
		sParam.put("S_COMP_CODE", user.getCompCode());
		sParam.put("DIV_CODE", dataMaster.getDIV_CODE());
		sParam.put("CHANGE_NO", dataMaster.getCHANGE_NO());
		sParam.put("S_USER_ID", user.getUserID());
		
		List<Map<String, Object>> asstList = this.selectList(sParam);
		for(Map asstParam : asstList)	{
			Map statusParam = new HashMap();
			statusParam.put("S_COMP_CODE",user.getCompCode());
			statusParam.put("S_USER_ID",user.getUserID());
			statusParam.put("DIV_CODE",  dataMaster.getDIV_CODE());
			statusParam.put("ASST_CODE", asstParam.get("ASST_CODE"));
			if("2".equals(dataMaster.getGUBUN()))	{
				statusParam.put("NOW_LOC", dataMaster.getMOVE_CUST_NM());
			}
			sat100ukrvService.updateStatus(statusParam, user);
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("CHANGE_NO", reqNo);
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
		
		Sat400ukrvModel masterModel = new Sat400ukrvModel();

		
		masterModel.setS_COMP_CODE(user.getCompCode());
		masterModel.setDIV_CODE(ObjUtils.getSafeString(dataMaster.get("DIV_CODE")));
		masterModel.setCHANGE_NO(ObjUtils.getSafeString(dataMaster.get("CHANGE_NO")));
		masterModel.setGUBUN(ObjUtils.getSafeString(dataMaster.get("GUBUN")));
		masterModel.setRESERVE_DATE(ObjUtils.getSafeString(dataMaster.get("RESERVE_DATE")));
		masterModel.setCUSTOM_NAME(ObjUtils.getSafeString(dataMaster.get("CUSTOM_NAME")));
		masterModel.setMOVE_CUST_NM(ObjUtils.getSafeString(dataMaster.get("MOVE_CUST_NM")));

		masterModel.setRETURN_DATE(ObjUtils.getSafeString(dataMaster.get("RETURN_DATE")));
		masterModel.setUSE_GUBUN(ObjUtils.getSafeString(dataMaster.get("USE_GUBUN")));
		masterModel.setUSE_FR_DATE(ObjUtils.getSafeString(dataMaster.get("USE_FR_DATE")));
		masterModel.setUSE_TO_DATE(ObjUtils.getSafeString(dataMaster.get("USE_TO_DATE")));
		
		masterModel.setREQ_USER(ObjUtils.getSafeString(dataMaster.get("REQ_USER")));
		masterModel.setREMARK(ObjUtils.getSafeString(dataMaster.get("REMARK")));
		masterModel.setREQ_NO(ObjUtils.getSafeString(dataMaster.get("REQ_NO")));
		masterModel.setS_USER_ID(user.getUserID());
		
		if(ObjUtils.isEmpty(masterModel.getCHANGE_NO()))	{
			String reqNo = this.selectChangeNo(masterModel);
			masterModel.setCHANGE_NO(reqNo);
			dataMaster.put("CHANGE_NO", reqNo);
		} else {
			Map<String, Object> saveCheck = (Map<String, Object>) super.commonDao.select("sat400ukrvServiceImpl.selectMaster", dataMaster);
			if(ObjUtils.isNotEmpty(saveCheck.get("IN_NUM"))  ) {
				throw new  UniDirectValidateException("입고처리 되어 저장할 수 없습니다.");
			}
			if( ObjUtils.isNotEmpty(saveCheck.get("NEXT_CHANGE_NO")) ) {
				throw new  UniDirectValidateException("다음 이동/연장이 있어 저장할 수 없습니다.");
			}
		}
		
		super.commonDao.update("sat400ukrvServiceImpl.updateMaster", masterModel);
		
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
	public int selectChangeSeq(Map<String,Object> param) throws Exception {
		Map<String, Object> r = (Map<String, Object>) super.commonDao.select("sat400ukrvServiceImpl.selectChangeSeq", param);
		int seq = ObjUtils.parseInt(r.get("CHANGE_SEQ"));
		return seq;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			if(ObjUtils.isEmpty(param.get("CHANGE_NO")))	{
				param.put("CHANGE_NO", paramMaster.get("CHANGE_NO"));
			}
			int seq = this.selectChangeSeq(param);
			param.put("CHANGE_SEQ", seq);
			super.commonDao.insert("sat400ukrvServiceImpl.insertDetail", param);
			//상태update
			Map statusParam = new HashMap();
			statusParam.put("S_COMP_CODE",user.getCompCode());
			statusParam.put("S_USER_ID",user.getUserID());
			statusParam.put("EXT_REQ_YN", "Y");
			statusParam.put("DIV_CODE",  param.get("DIV_CODE"));
			statusParam.put("ASST_CODE", param.get("ASST_CODE"));
			if("2".equals(paramMaster.get("GUBUN")))	{
				statusParam.put("NOW_LOC", paramMaster.get("MOVE_CUST_NM"));
			}
			sat100ukrvService.updateStatus(statusParam, user);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("sat400ukrvServiceImpl.updateDetail", param);
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
		checkParam.put("CHANGE_NO", paramMaster.get("CHANGE_NO"));
		this.checkDelete(checkParam);
		
		for(Map param: paramList)		{
			
			super.commonDao.update("sat400ukrvServiceImpl.deleteDetail", param);

			//같은 요청번호중에 이동/연장이 남아 있지 않은 경우에  EXT_REQ_YN = 'Y' 로 변경
			Map remainReqData = (Map) super.commonDao.select("sat400ukrvServiceImpl.checkExtDataByReqNo", param);
			
			Map statusParam = new HashMap();
			statusParam.put("S_COMP_CODE",user.getCompCode());
			statusParam.put("S_USER_ID",user.getUserID());
			
			//같은 요청번호중에 이동/연장이 남아 있지 않은 경우에  EXT_REQ_YN = 'Y' 로 변경
			if(remainReqData != null && ObjUtils.parseInt(remainReqData.get("CNT")) == 0 )	{
				statusParam.put("EXT_REQ_YN", "N");
			}
			//이동인 경우만 이전 위치로 수정
			if("2".equals(paramMaster.get("GUBUN")))	{
				statusParam.put("NOW_LOC", paramMaster.get("CUSTOM_NAME"));
			}
			sat100ukrvService.updateStatus(statusParam, user);
		}
		if(ObjUtils.isEmpty(insertList))	{
			List<Map> delList = (List<Map>) super.commonDao.list("sat400ukrvServiceImpl.selectList", paramMaster);
			if(ObjUtils.isEmpty(delList) ) {
				super.commonDao.update("sat400ukrvServiceImpl.deleteAll", paramMaster);
				paramMaster.put("DELETEALL", "Y");
			}
		}
	}
	
	@ExtDirectMethod(group = "sales")
	public Map deleteAll( Map param, LoginVO user) throws Exception {
		List<Map> delList = (List<Map>) super.commonDao.list("sat400ukrvServiceImpl.selectList", param);
		
		String[] asstCode = new String[delList.size()];
		int idx = 0;
		for(Map data: delList)		{
			asstCode[idx++] = ObjUtils.getSafeString(data.get("ASST_CODE"));
		}
		Map checkParam = new HashMap();
		checkParam.put("S_COMP_CODE", user.getCompCode());
		checkParam.put("DIV_CODE", param.get("DIV_CODE"));
		checkParam.put("ASST_CODE", asstCode);
		checkParam.put("CHANGE_NO", param.get("CHANGE_NO"));
		
		this.checkDelete(checkParam);
		
		for(Map dparam: delList)		{
			
			dparam.put("S_COMP_CODE",user.getCompCode());
			dparam.put("S_USER_ID",user.getUserID());
			//같은 요청번호중에 이동/연장이 남아 있지 않은 경우에  EXT_REQ_YN = 'Y' 로 변경
			Map remainReqData = (Map) super.commonDao.select("sat400ukrvServiceImpl.checkExtDataByReqNo", dparam);
			
			//상태update
			Map statusParam = new HashMap();
			statusParam.put("S_COMP_CODE",user.getCompCode());
			statusParam.put("S_USER_ID",user.getUserID());
			//같은 요청번호중에 이동/연장이 남아 있지 않은 경우에  EXT_REQ_YN = 'Y' 로 변경
			if(remainReqData != null && ObjUtils.parseInt(remainReqData.get("CNT")) == 0 )	{
				statusParam.put("EXT_REQ_YN", "N");
			}
			statusParam.put("ASST_CODE", dparam.get("ASST_CODE"));
			statusParam.put("DIV_CODE", dparam.get("DIV_CODE"));
			//이동인 경우만 이전 위치로 수정
			if("2".equals(param.get("GUBUN")))	{
				statusParam.put("NOW_LOC", dparam.get("CUSTOM_NAME"));
			}
			sat100ukrvService.updateStatus(statusParam, user);
			
		}
		super.commonDao.update("sat400ukrvServiceImpl.deleteAll", param);
		return param;
	}
	
	
	@ExtDirectMethod(group = "sales")
	public Integer updateOutYn(Map param, LoginVO user) throws Exception {
		super.commonDao.update("sat400ukrvServiceImpl.updateOutYn", param);
		return 0;
	}
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectOutList(Map param) throws Exception {
		return super.commonDao.list("sat400ukrvServiceImpl.selectOutList", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public List<Map<String, Object>> selectOutDetailList(Map param) throws Exception {
		return super.commonDao.list("sat400ukrvServiceImpl.selectOutDetailList", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public Map<String, Object> selectCheckReserveDate(Map param) throws Exception {
		Map<String, Object> r = (Map<String, Object>) super.commonDao.select("sat400ukrvServiceImpl.selectCheckReserveDate", param);
		
		return r;
	}
}
