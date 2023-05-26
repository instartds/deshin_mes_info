package foren.unilite.modules.cost.cbm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("cbm010ukrvService")
public class Cbm010ukrvServiceImpl extends TlabAbstractServiceImpl {
	
    @Resource( name = "tlabCodeService" )
    protected TlabCodeService tlabCodeService;
    
    @Resource( name = "tlabMenuService" )
    protected TlabMenuService tlabMenuService;
    
    
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object> selectMaster(Map param, LoginVO loginVO) throws Exception {
		Map<String, Object> rParam =  new HashMap();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO applyType = codeInfo.getCodeInfo("CC05","ref_code1", "Y");
		rParam.put("APPLY_TYPE",applyType.getCodeNo());
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		rParam.put("APPLY_UNIT",applyUnit.getCodeNo());
		
		CodeDetailVO distKind = codeInfo.getCodeInfo("C101","ref_code1", "Y");
		rParam.put("DIST_KIND",distKind.getCodeNo());
		return rParam;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "cost")
	public ExtDirectFormPostResult syncMaster(Cbm001ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		Map<String, Object> basParam = new HashMap();
		basParam.put("S_COMP_CODE", user.getCompCode());
		basParam.put("S_USER_ID", user.getUserID());
		basParam.put("MAIN_CODE","CC05" );
		basParam.put("SUB_CODE",param.getAPPLY_TYPE());
		super.commonDao.update("cbm010ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","CC06" );
		basParam.put("SUB_CODE",param.getAPPLY_UNIT());
		super.commonDao.update("cbm010ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","C101" );
		basParam.put("SUB_CODE",param.getDIST_KIND());
		super.commonDao.update("cbm010ukrvServiceImpl.update001", basParam);
		
		tlabCodeService.reload(true);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectFormat(Map param) throws Exception {
		return super.commonDao.select("cbm010ukrvServiceImpl.selectFormat", param);
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "cost")
	public ExtDirectFormPostResult syncFormat(Cbm900ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("cbm010ukrvServiceImpl.updateFormat", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload();
		return extResult;
		
	}
}