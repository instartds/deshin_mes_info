package foren.unilite.modules.com.login;
import java.util.Map;

import foren.framework.model.BaseVO;
import foren.framework.model.LoginVO;

public interface UserDataService{
	public UserDataModel findUserMap(String userId, LoginVO user) ;
}
