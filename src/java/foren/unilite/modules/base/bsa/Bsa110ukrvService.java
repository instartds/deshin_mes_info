package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import foren.framework.model.LoginVO;
import foren.unilite.com.tags.ComboItemModel;

public interface Bsa110ukrvService {
	
	public List<ComboItemModel>  getWorkTypeList(LoginVO login) throws Exception ;
}