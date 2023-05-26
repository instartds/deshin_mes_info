package foren.unilite.modules.cost.cbm;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bsa.Bsa100ukrvServiceImpl;

@Service("cbm100ukrvService")
public class Cbm100ukrvServiceImpl extends TlabAbstractServiceImpl {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Resource( name = "tlabCodeService" )
    protected TlabCodeService tlabCodeService;
    
    @Resource( name = "tlabMenuService" )
    protected TlabMenuService tlabMenuService;
    
    @Resource( name = "bsa100ukrvService" )
    protected Bsa100ukrvServiceImpl bsa100ukrvService;
    
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object> selectMaster(Map param, LoginVO loginVO) throws Exception {
		Map<String, Object> rParam =  new HashMap();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC05","ref_code1", "Y");
		if(applyUnit != null)	{
			rParam.put("APPLY_UNIT",applyUnit.getCodeNo());
		} else {
			rParam.put("APPLY_UNIT","");
		}
		CodeDetailVO distKind = codeInfo.getCodeInfo("C101","ref_code1", "Y");
		if(distKind != null)	{
			rParam.put("DIST_KIND",distKind.getCodeNo());
		} else {
			rParam.put("DIST_KIND","");
		}
		
		CodeDetailVO distKind2 = codeInfo.getCodeInfo("C102","ref_code1", "Y");
		if(distKind2 != null)	{
			rParam.put("DIST_KIND2",distKind2.getCodeNo());
		} else {
			rParam.put("DIST_KIND2","");
		}
		
		CodeDetailVO distKind3 = codeInfo.getCodeInfo("CA08","ref_code1", "Y");
		if(distKind3 != null)	{
			rParam.put("DIST_KIND3",distKind3.getCodeNo());
		} else {
			rParam.put("DIST_KIND3","");
		}
		
		CodeDetailVO m_cost = codeInfo.getCodeInfo("C007","01");
		if(m_cost != null)	{
			rParam.put("M_COST_CODE",m_cost.getRefCode1());
			rParam.put("M_COST_NAME",m_cost.getRefCode2());
		} else {
			rParam.put("M_COST_CODE","");
			rParam.put("M_COST_CODE","");
		}
		
		CodeDetailVO summaryData = codeInfo.getCodeInfo("CA06","ref_code1", "Y");
		rParam.put("SUMMARY_DATA", summaryData.getCodeNo());
		//return rParam;
		//SUMMARY_REF02_DATA
		
		CodeDetailVO ca_06 = codeInfo.getCodeInfo("CA06","02");
		rParam.put("SUMMARY_REF02_DATA", ca_06.getRefCode2());
		
		CodeDetailVO distKind4 = codeInfo.getCodeInfo("CA13","ref_code1", "Y");
		if(distKind3 != null)	{
			rParam.put("DIST_KIND4",distKind4.getCodeNo());
		} else {
			rParam.put("DIST_KIND4","");
		}
		
		return rParam;
		
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "cost")
	public ExtDirectFormPostResult syncMaster(Cbm001ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		Map<String, Object> basParam = new HashMap();
		basParam.put("S_COMP_CODE", user.getCompCode());
		basParam.put("S_USER_ID", user.getUserID());
		basParam.put("MAIN_CODE","CC05" );
		basParam.put("SUB_CODE",param.getAPPLY_UNIT());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		
		
		basParam.put("MAIN_CODE","C101" );
		basParam.put("SUB_CODE",param.getDIST_KIND());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","C102" );
		basParam.put("SUB_CODE",param.getDIST_KIND2());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","CA08" );
		basParam.put("SUB_CODE",param.getDIST_KIND3());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","CA06" );
		basParam.put("SUB_CODE", param.getSUMMARY_DATA());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","CA06" );
		basParam.put("REF_CODE2", param.getSUMMARY_REF02_DATA());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		basParam.put("MAIN_CODE","CA13" );
		basParam.put("SUB_CODE", param.getDIST_KIND4());
		super.commonDao.update("cbm100ukrvServiceImpl.update001", basParam);
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
		CodeDetailVO m_cost = codeInfo.getCodeInfo("C007","01");
		basParam.put("MAIN_CODE","C007" );
		basParam.put("SUB_CODE","01");
		basParam.put("CODE_NAME",m_cost.getCodeName());
		basParam.put("REF_CODE1",param.getM_COST_CODE());
		basParam.put("REF_CODE2",param.getM_COST_NAME());
		bsa100ukrvService.updateCode(basParam);
		
		tlabCodeService.reload(true);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectFormat(Map param) throws Exception {
		return super.commonDao.select("cbm100ukrvServiceImpl.selectFormat", param);
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "cost")
	public ExtDirectFormPostResult syncFormat(Cbm900ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("cbm100ukrvServiceImpl.updateFormat", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload(true);
		return extResult;
		
	}
}