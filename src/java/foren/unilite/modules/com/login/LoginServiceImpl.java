package foren.unilite.modules.com.login;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("loginService")
public class LoginServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	public String passwordCheck(Map param) {
		return (String) super.commonDao.select("loginServiceImpl.passwordCheck", param);
	}

	public Object selectfailCount(Map param) {
		return super.commonDao.select("loginServiceImpl.selectfailCount", param);
	}

    public LoginVO getUserInfoByUserID(String userID) {
        return (LoginVO) super.commonDao.select("loginServiceImpl.getUserInfoByUserID", userID);
    }

    public Object changeCompCode(Map param) {
        return  super.commonDao.select("loginServiceImpl.changeCompCode", param);
    }

    public LoginVO getUserInfoByCompCode(Map param) {
        return (LoginVO) super.commonDao.select("loginServiceImpl.changeCompCodeUserInfo", param);
    }

    public List<Map<String, Object>> selectUserList(Map param) {
    	return super.commonDao.list("loginServiceImpl.selectUserList", param);
    }

    public String chkSSOUser(Map param) {
        return (String) super.commonDao.select("loginServiceImpl.chkSSOUser", param);
    }

    public List<String> selectLogoutUrl(Map param) {
        return (List<String>) super.commonDao.list("loginServiceImpl.getlogoutUrl", param);
    }

    public void updateFailLogin(Map param) {
        super.commonDao.list("loginServiceImpl.updateFailLogin", param);
    }

    public void updateLog(Map param) {
        super.commonDao.list("loginServiceImpl.updateLog", param);
    }

    public void setLastLoginTime(Map param) {
        super.commonDao.update("loginServiceImpl.setLastLoginTime", param);
    }

    public void updateFirstLogin(Map param) {
        super.commonDao.update("loginServiceImpl.updateFirstLogin", param);
    }

    public void updateFailCount(Map param) {
        super.commonDao.update("loginServiceImpl.updateFailCount", param);
    }
}
