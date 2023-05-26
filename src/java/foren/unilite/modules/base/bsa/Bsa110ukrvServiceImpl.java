package foren.unilite.modules.base.bsa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.framework.model.LoginVO;

@Service("bsa110ukrvService")
public class Bsa110ukrvServiceImpl extends TlabAbstractServiceImpl implements Bsa110ukrvService{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 업무구분 콤보코드
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel>  getWorkTypeList(LoginVO login) throws Exception {
		Map param = new HashMap();
		param.put("COMP_CODE", login.getCompCode());
		return super.commonDao.list("bsa110ukrvService.workTypeCombo", param);
	}

}
