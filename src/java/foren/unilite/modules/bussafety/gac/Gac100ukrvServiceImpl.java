package foren.unilite.modules.bussafety.gac;

import java.util.ArrayList;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;

@Service("gac100ukrvService")
public class Gac100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gac100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.FORM_LOAD)
	public Object  select(Map param) throws Exception {	
		return  super.commonDao.select("gac100ukrvServiceImpl.select", param);
	}
	
	
	@ExtDirectMethod(group = "bussafety" , value = ExtDirectMethodType.FORM_POST)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public ExtDirectFormPostResult  insert(Gac100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
			String accidentTime= param.getACCIDENT_TIME() ;
			String registTime= param.getREGIST_TIME();
			String claimTime= param.getCLAIM_TIME();
			
			if(param.getACCIDENT_TIME() != null) param.setACCIDENT_TIME( ObjUtils.getSafeString(param.getACCIDENT_TIME().replaceAll("\\:", "") ));
			if(param.getREGIST_TIME() != null) param.setREGIST_TIME( ObjUtils.getSafeString(param.getREGIST_TIME().replaceAll("\\:", "") ));
			if(param.getCLAIM_TIME() != null) param.setCLAIM_TIME( ObjUtils.getSafeString(param.getCLAIM_TIME().replaceAll("\\:", "") ));
			
			
			param.setS_COMP_CODE(user.getCompCode());
			param.setS_USER_ID(user.getUserID());
			Map<String, Object> rMap = (Map<String, Object>) super.commonDao.queryForObject("gac100ukrvServiceImpl.insert", param);	
			
			param.setACCIDENT_TIME(accidentTime);
			param.setREGIST_TIME(registTime);
			param.setCLAIM_TIME(claimTime);
			//super.commonDao.queryForObject("gac100ukrvServiceImpl.insert", param);
			ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			extResult.addResultProperty("ACCIDENT_NUM", ObjUtils.getSafeString(rMap.get("ACCIDENT_NUM")));
		return extResult;
	}
	
	@ExtDirectMethod(group = "bussafety" )
	public Integer  saveImageNo(Map param, LoginVO user,  BindingResult result) throws Exception {
		//param.put('S_COMPuser.getCompCode());
		super.commonDao.update("gac100ukrvServiceImpl.saveImageNo", param);		
		fileMnagerService.confirmFile(user, ObjUtils.getSafeString(param.get("DOC_NO")));		
		return 0;
	}

	
	@ExtDirectMethod(group = "bussafety")
	public Integer  delete(List<Map> paramList) throws Exception {
		for(Map param : paramList) 	{
			int r = super.commonDao.update("gac100ukrvServiceImpl.delete", param);	
		}
		return 0;
	}


}
