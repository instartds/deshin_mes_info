package foren.unilite.modules.com.login;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("LoginExtUserService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class LoginExtUserServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public String passwordCheck(Map param) {
		return (String) super.commonDao.select("loginExtUserServiceImpl.passwordCheck", param);
	}

	public LoginVO getUserInfoByUserID(String userID) {
		return (LoginVO) super.commonDao.select("loginExtUserServiceImpl.getUserInfoByUserID", userID);
	}
	
	public List<Map<String, Object>> selectUserList(Map param) {
		return super.commonDao.list("loginExtUserServiceImpl.selectUserList", param);
	}

	/** 
	 * 20210426 추가: 외부사용자 암호화 사용으로 추가
	 * @param param
	 * @return
	 */
	public Object selectfailCount(Map param) {
		return super.commonDao.select("loginExtUserServiceImpl.selectfailCount", param);
	}

	/** 
	 * 20210426 추가: 외부사용자 암호화 사용으로 추가 - 실패한 로그인 횟수 UPDATE
	 * @param param
	 * @return
	 */
	public void updateFailLogin(Map param) {
		super.commonDao.list("loginExtUserServiceImpl.updateFailLogin", param);
	}
	
    public void updateFirstLogin(Map param) {
        super.commonDao.update("loginExtUserServiceImpl.updateFirstLogin", param);
    }
}