package foren.unilite.modules.com.login;
import java.util.Map;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import foren.framework.model.LoginVO;

//@Repository("userDataService")
public class UserDataServiceImpl implements UserDataService {
	
	//@Cacheable(value="sampleMem", key="#userId")
	public UserDataModel findUserMap(String userId, LoginVO user) {
		UserDataModel userData = new UserDataModel();
		userData.setUserMap(user.getUserMap());
		return userData;
	}
	
}
