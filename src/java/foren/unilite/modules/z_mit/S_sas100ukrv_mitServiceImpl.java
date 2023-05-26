package foren.unilite.modules.z_mit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;



@Service("s_sas100ukrv_mitService")
public class S_sas100ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 마스터폼조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "z_mit")
	public Object selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.select("s_sas100ukrv_mitServiceImpl.selectMaster", param);
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectDetail(Map param, LoginVO loginVO) throws Exception {		
		return (List) super.commonDao.list("s_sas100ukrv_mitServiceImpl.selectDetail", param);
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult syncMaster(S_sas100ukrv_mitModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {
		
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		String receiptNum = dataMaster.getRECEIPT_NUM();
		if(ObjUtils.isEmpty(receiptNum))	{
			receiptNum = this.selectReceiptNum(dataMaster);
			dataMaster.setRECEIPT_NUM(receiptNum);
		} 
		super.commonDao.update("s_sas100ukrv_mitServiceImpl.updateMaster", dataMaster);
		
		/*
		 * if(ObjUtils.isNotEmpty(dataMaster.getOUT_DATE())) {
		 * dataMaster.setAS_STATUS("90");
		 * 
		 * Map param = new HashMap(); param.put("S_COMP_CODE",
		 * dataMaster.getS_COMP_CODE()); param.put("AS_STATUS", "90");
		 * param.put("S_USER_ID", dataMaster.getS_USER_ID()); param.put("RECEIPT_NUM",
		 * dataMaster.getRECEIPT_NUM()); param.put("DIV_CODE",
		 * dataMaster.getDIV_CODE());
		 * 
		 * this.updateASStatus(param); }
		 */
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
 		extResult.addResultProperty("RECEIPT_NUM", receiptNum);
 		extResult.addResultProperty("AS_STATUS", dataMaster.getAS_STATUS());
		return extResult;
	}
	
	@ExtDirectMethod(group = "z_mit")
	public Map<String, Object> deleteMaster(Map param, LoginVO user) throws Exception {
		Map<String, Object> receiptMaster = (Map<String, Object>) this.selectMaster(param, user);
		if(receiptMaster != null && ObjUtils.isNotEmpty(receiptMaster.get("RECEIPT_NUM")))	{
			if("10".equals(ObjUtils.getSafeString(receiptMaster.get("AS_STATUS"))) )	{
				super.commonDao.delete("s_sas100ukrv_mitServiceImpl.deleteMaster", param);
			} else {
				throw new  UniDirectValidateException("진행상태가 접수인 경우만 삭제할 수 있습니다.");
			}
		} else {
			throw new  UniDirectValidateException(this.getMessage("54400", user));
		}
		param.put("success", "true");
		return param;
	}
	
	@ExtDirectMethod(group = "z_mit")
	public String selectReceiptNum(S_sas100ukrv_mitModel param) throws Exception {
		String receiptNum = "";
		receiptNum =(String) super.commonDao.select("s_sas100ukrv_mitServiceImpl.selectReceiptNum", param);
		return 	receiptNum;
	}
	
	@ExtDirectMethod(group = "z_mit")
	public Map updateASStatus(Map param) throws Exception {
		super.commonDao.update("s_sas100ukrv_mitServiceImpl.updateStatus", param);
		return param;
	}
	
	
	@ExtDirectMethod(group = "z_mit")
	public Object selectSNStatus(Map param) throws Exception {
		return super.commonDao.select("s_sas100ukrv_mitServiceImpl.selectSNStatus", param);
	}
	
}
