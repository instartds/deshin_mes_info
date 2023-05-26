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

@Service("sat600ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat600ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "sat100ukrvService")
	private Sat100ukrvServiceImpl sat100ukrvService;
	
	@Resource(name = "sat200ukrvService")
	private Sat200ukrvServiceImpl sat200ukrvService;
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
	public Object selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("sat600ukrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat600ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public Map<String, Object> checkDelete(Map param) throws Exception {
		
		List<Map<String, Object>> checkDelete = super.commonDao.list("sat600ukrvServiceImpl.checkDelete", param);
		
		if(ObjUtils.isNotEmpty(checkDelete) && checkDelete.size() > 0)	{
			String message = "";
			for(Map data: checkDelete)		{
				message = message + ObjUtils.getSafeString(data.get("ASST_NAME")) 
				            + "(" + ObjUtils.getSafeString(data.get("ASST_CODE"))+")\n";
			}
			throw new  UniDirectValidateException("출고요청 삭제를 할 수 없는 자산이 있어 삭제할 수 없습니다. 자산의 현재상태를 확인하세요.||"+message);
		}
		return param;
	}
	
	@ExtDirectMethod(group = "sales")
	public String selectInoutNum(Map<String, Object> dataMaster) throws Exception {
		String inoutNum = "";
		Map<String, Object> param = new HashMap();
		param.put("S_COMP_CODE",dataMaster.get("S_COMP_CODE"));
		param.put("DIV_CODE",dataMaster.get("DIV_CODE"));
		param.put("INOUT_DATE",dataMaster.get("INOUT_DATE"));
		inoutNum =(String) super.commonDao.select("sat600ukrvServiceImpl.selectInoutNum", param);
		return 	inoutNum;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult syncMaster(Sat600ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		String inoutNum = dataMaster.getINOUT_NUM();
		//수리견적번호 생성
		if(ObjUtils.isEmpty(inoutNum))	{
			throw new  UniDirectValidateException("출고번호가 없습니다. 조회 후 저장하세요.");
		} 
		
		super.commonDao.update("sat600ukrvServiceImpl.updateMaster", dataMaster);
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("INOUT_NUM", inoutNum);
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
		
		if(ObjUtils.isNotEmpty(dataMaster.get("INOUT_NUM")) )	{
			super.commonDao.update("sat600ukrvServiceImpl.updateMaster", dataMaster);
		}
		
		for(Map param: paramList) {
			if(param.get("method").equals("insertDetail")) {
				insert = (List<Map>)param.get("data");
			} else if(param.get("method").equals("deleteDetail")) {
				delete = (List<Map>)param.get("data");
			}
		}
		String  inoutNum = ObjUtils.getSafeString(dataMaster.get("INOUT_NUM"));
		if(delete != null) this.deleteDetail(delete, user, dataMaster, insert);
		if(insert != null) {
			if(ObjUtils.isEmpty(dataMaster.get("INOUT_NUM")))	{
				inoutNum = this.selectInoutNum(dataMaster);
			}
			this.insertDetail(insert, user, dataMaster, inoutNum);
		}
		
		dataMaster.put("INOUT_NUM", inoutNum);
		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales")
	public int selectInoutSeq(Map<String,Object> param) throws Exception {
		Map<String, Object> r = (Map<String, Object>) super.commonDao.select("sat600ukrvServiceImpl.selectInoutSeq", param);
		int seq = ObjUtils.parseInt(r.get("INOUT_SEQ"));
		return seq;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster, String inoutNum) throws Exception {

		for(Map param: paramList)		{
			param.putAll(paramMaster);
			param.put("INOUT_NUM", inoutNum);
			int seq = this.selectInoutSeq(param);
			param.put("INOUT_SEQ", seq);
			super.commonDao.insert("sat600ukrvServiceImpl.insertDetail", param);
			
			//상태update
			param.put("ASST_STATUS", "O");
			param.put("NOW_LOC", paramMaster.get("CUSTOM_NAME"));
			sat100ukrvService.updateStatus(param, user);
			
			param.put("OUT_YN", "Y");
			sat200ukrvService.updateOutYn(param, user);
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
		this.checkDelete(checkParam);
		
		for(Map param: paramList)		{
			
			super.commonDao.update("sat600ukrvServiceImpl.deleteDetail", param);
			//출고요청
			param.put("ASST_STATUS", "R");
			param.put("NOW_LOC", " ");
			sat100ukrvService.updateStatus(param, user);
			
			param.put("OUT_YN", "N");
			sat200ukrvService.updateOutYn(param, user);
			
		}
		if(ObjUtils.isEmpty(insertList)) {
			List<Map> delList = (List<Map>) super.commonDao.list("sat600ukrvServiceImpl.selectList", paramMaster);
			if(ObjUtils.isEmpty(delList) ) {
				paramMaster.put("DELETEALL", "Y");
			}
		}
	}
	
	@ExtDirectMethod(group = "sales")
	public Map deleteAll( Map param, LoginVO user) throws Exception {
		List<Map> delList = (List<Map>) super.commonDao.list("sat600ukrvServiceImpl.selectList", param);
		
		String[] asstCode = new String[delList.size()];
		int idx = 0;
		for(Map data: delList)		{
			asstCode[idx++] = ObjUtils.getSafeString(data.get("ASST_CODE"));
		}
		
		Map checkParam = new HashMap();
		checkParam.put("S_COMP_CODE", user.getCompCode());
		checkParam.put("DIV_CODE", param.get("DIV_CODE"));
		checkParam.put("ASST_CODE", asstCode);
		this.checkDelete(checkParam);
		
		for(Map dparam: delList)		{
			//상태update
			
			dparam.put("ASST_STATUS", "R");
			dparam.put("S_COMP_CODE", user.getCompCode());
			dparam.put("NOW_LOC", " ");
			dparam.put("S_USER_ID", user.getUserID());
			sat100ukrvService.updateStatus(dparam, user);
			
			dparam.put("OUT_YN", "N");
			sat200ukrvService.updateOutYn(dparam, user);
		}
		super.commonDao.update("sat600ukrvServiceImpl.deleteAll", param);
		return param;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectReqList(Map param) throws Exception {
		return super.commonDao.list("sat600ukrvServiceImpl.selectReqList", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectReqDetailList(Map param) throws Exception {
		return super.commonDao.list("sat600ukrvServiceImpl.selectReqDetailList", param);
	}
	
	
	// CLIP 출력물 : 인수증 Master
	public List<Map<String, Object>> selectPrintList2Master(Map param) throws Exception {
		return super.commonDao.list("sat600ukrvServiceImpl.selectPrintList2Master", param);
	}
	
	// CLIP 출력물 : 인수증 Detail
	public List<Map<String, Object>> selectPrintList2Detail(Map param) throws Exception {
		return super.commonDao.list("sat600ukrvServiceImpl.selectPrintList2Detail", param);
	}
}
