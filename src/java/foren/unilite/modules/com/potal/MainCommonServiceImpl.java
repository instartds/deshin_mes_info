package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.menu.MenuItemModel;
import foren.unilite.com.menu.MenuNode;
import foren.unilite.com.menu.MenuTree;
import foren.unilite.com.menu.ProgramAuthModel;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("mainCommonService")
public class MainCommonServiceImpl extends TlabAbstractCommonServiceImpl {
    private static final Logger logger = LoggerFactory.getLogger(MainCommonServiceImpl.class);

	@ExtDirectMethod(group = "main")
	public void saveUserUI(Map param) throws Exception {

		super.commonDao.update("mainCommonServiceImpl.saveUserUI", param);

	}

	@ExtDirectMethod( group = "main")
	public Object getUserUI(LoginVO user) throws Exception {
		Map param = new HashMap();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());

		return super.commonDao.select("mainCommonServiceImpl.selectUserUI", param);
	}


	/**
	 * 법인목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "main")
	public List<Map<String, Object>>  compList(Map param) throws Exception {
		return  super.commonDao.list("mainCommonServiceImpl.selectCompList", param);
	}
	@ExtDirectMethod(group = "main")
	public List<Map<String, Object>>  getGroupDetailList(Map param)   throws Exception {

		return  super.commonDao.list("mainCommonServiceImpl.selectGroupList", param);
	}
	/**
	 * 사용자 권한 모듈 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "main")
	public List<UniModuleModel>  getUserModules(LoginVO user) throws Exception {
		Map param = new HashMap();
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());
		param.put("S_MAIN_COMP_CODE", user.getMainCompCode());

		List<String> licenseModules = LicenseManager.getInstance().getLicenseProcessor().getModuleLicense().getModuleList();
		List<UniModuleModel> list = super.commonDao.list("mainCommonServiceImpl.getUserModules", param);
		List<Map> tempModuleFormat1 = super.commonDao.list("TlabMenuService.moduleFormat1", param);
        List<Map> tempModuleFormat2 = super.commonDao.list("TlabMenuService.moduleFormat2", param);

		List<UniModuleModel> moduleList = new ArrayList();
		for(UniModuleModel module : list)	{
			if(licenseModules.contains(module.getId())) {
            	for(Map nformat :tempModuleFormat1)	{
            		if(module.getId().equals(nformat.get("JOB_CODE")))	{
            			module.setnFormat1(nformat);
            		}
            	}
            	for(Map nformat :tempModuleFormat2)	{
            		if(module.getId().equals(nformat.get("JOB_CODE")))	{
            			module.setnFormat2(nformat);
            		}
            	}
        		moduleList.add(module);
        	}
		}
		return  moduleList;
	}
}
