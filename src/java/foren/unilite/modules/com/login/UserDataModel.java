package foren.unilite.modules.com.login;
import java.util.Map;

import foren.framework.model.BaseVO;

public class UserDataModel extends BaseVO{
	private static final long serialVersionUID = 1L;
	
	private Map<String, Object> userMap;

	public Map<String, Object> getUserMap() {
		return userMap;
	}

	public void setUserMap(Map<String, Object> userMap) {
		this.userMap = userMap;
	}
	
}
