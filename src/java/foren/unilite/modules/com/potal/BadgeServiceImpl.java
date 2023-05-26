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
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.menu.MenuItemModel;
import foren.unilite.com.menu.MenuNode;
import foren.unilite.com.menu.MenuTree;
import foren.unilite.com.menu.ProgramAuthModel;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("badgeService")
public class BadgeServiceImpl extends TlabAbstractCommonServiceImpl {
    private static final Logger logger = LoggerFactory.getLogger(BadgeServiceImpl.class);

    @Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

    @ExtDirectMethod( group = "main")
	public Object selectMyCount(LoginVO user) throws Exception {
    	Object rObj = null;
    	try {
    		rObj = tlabBadgeService.getUserBadgeInfo(user);
    	} catch(Exception e){
    		logger.error(e.toString());
    	}
        return rObj;
	}

	@ExtDirectMethod( group = "main")
	public List<Map<String, Object>> selectCount( Map param, LoginVO user) throws Exception {
		return super.commonDao.list("badgeServiceImpl.selectCount", param);
	}

	@ExtDirectMethod( group = "main")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {

		param.put("S_COMP_CODE", user.getCompCode());
		param.put("S_USER_ID", user.getUserID());

		return super.commonDao.list("badgeServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "main")
	public void insert(String PgmId, String divCode, String alertType, String refNum, Map param, LoginVO user) throws Exception {

		StringBuffer jsonParams = JsonUtils.toJsonStr(param);
		Map<String, Object> dataParam = new HashMap();
		dataParam.put("S_COMP_CODE", user.getCompCode());
		dataParam.put("DIV_CODE", divCode);
		dataParam.put("ALERT_TYPE", alertType);
		dataParam.put("PROGRAM_ID", PgmId);
		dataParam.put("REF_NUM", refNum);
		dataParam.put("REMARK", param.get("REMARK"));
		dataParam.put("S_USER_ID", user.getUserID());

		if(param.get("REF_VAL_1") != null) dataParam.put("REF_VAL_1", param.get("REF_VAL_1"));
		if(param.get("REF_VAL_2") != null) dataParam.put("REF_VAL_2", param.get("REF_VAL_2"));
		if(param.get("REF_VAL_3") != null) dataParam.put("REF_VAL_3", param.get("REF_VAL_3"));
		if(param.get("REF_VAL_4") != null) dataParam.put("REF_VAL_4", param.get("REF_VAL_4"));
		if(param.get("REF_VAL_5") != null) dataParam.put("REF_VAL_5", param.get("REF_VAL_5"));
		if(param.get("REF_VAL_6") != null) dataParam.put("REF_VAL_6", param.get("REF_VAL_6"));
		if(param.get("REF_VAL_7") != null) dataParam.put("REF_VAL_7", param.get("REF_VAL_7"));
		if(param.get("REF_VAL_8") != null) dataParam.put("REF_VAL_8", param.get("REF_VAL_8"));

		if(param.get("ALERT_MESSAGE") != null) dataParam.put("ALERT_MESSAGE", param.get("ALERT_MESSAGE"));
		if(param.get("ALERT_MESSAGE_EN") != null) dataParam.put("ALERT_MESSAGE_EN", param.get("ALERT_MESSAGE_EN"));
		if(param.get("ALERT_MESSAGE_CN") != null) dataParam.put("ALERT_MESSAGE_CN", param.get("ALERT_MESSAGE_CN"));
		if(param.get("ALERT_MESSAGE_JP") != null) dataParam.put("ALERT_MESSAGE_JP", param.get("ALERT_MESSAGE_JP"));
		if(param.get("ALERT_MESSAGE_VI") != null) dataParam.put("ALERT_MESSAGE_VI", param.get("ALERT_MESSAGE_VI"));

		if(jsonParams != null)	{
			dataParam.put("JSON_PARAMETER", jsonParams.toString());
		}

		Map<String, Object> alertPgm = (Map<String, Object>) super.commonDao.select("badgeServiceImpl.selectAlertPGM", dataParam);
		if(alertPgm != null)	{
			dataParam.put("ALERT_PROGRAM_ID", alertPgm.get("ALERT_PROGRAM_ID"));

			List<Map<String, Object>> alertUser = (List<Map<String, Object>>) super.commonDao.list("badgeServiceImpl.selectAlertUSER", dataParam);
			if(alertUser != null)	{
				for(Map<String, Object> alertUserMap : alertUser)	{
					dataParam.put("ALERT_USER_ID", alertUserMap.get("ALERT_USER_ID"));
					super.commonDao.update("badgeServiceImpl.insert", dataParam);
				}
				tlabBadgeService.reload();
			}
		}
	}

	@ExtDirectMethod(group = "main")
	public void readMessage(Map param, LoginVO user) throws Exception {
		param.put("S_COPM_CODE", user.getCompCode());
		if(param.get("DIV_CODE") == null)	{
			param.put("DIV_CODE", user.getDivCode());
		}
		super.commonDao.update("badgeServiceImpl.readMessage", param);
		tlabBadgeService.reload();
	}
	@ExtDirectMethod(group = "main")
	public void unreadMessage(Map param, LoginVO user) throws Exception {
		param.put("S_COPM_CODE", user.getCompCode());
		if(param.get("DIV_CODE") == null)	{
			param.put("DIV_CODE", user.getDivCode());
		}
		super.commonDao.update("badgeServiceImpl.unreadMessage", param);
		tlabBadgeService.reload();
	}
	@ExtDirectMethod(group = "main")
	public void update(Map param) throws Exception {
		super.commonDao.update("badgeServiceImpl.update", param);
		tlabBadgeService.reload();
	}

	@ExtDirectMethod(group = "main")
	public void delete(Map param) throws Exception {
		super.commonDao.update("badgeServiceImpl.delete", param);
		tlabBadgeService.reload();
	}

	@ExtDirectMethod(group = "base")
	public void reload(Map param) throws Exception {
		tlabBadgeService.reload();
	}
}
