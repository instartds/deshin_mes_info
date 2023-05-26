package foren.unilite.modules.z_wm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_biv360skrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Biv360skrv_wmServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map<String, Object>> selectList(Map param,LoginVO user) throws Exception {
		param.put("COMP_CODE"	, user.getCompCode());
		param.put("SUBCON_YN"	, param.get("SUBCON_YN")== null ? "" : param.get("SUBCON_YN"));
		param.put("QRY_TYPE"	, param.get("QRY_TYPE")	== null ? "" : param.get("QRY_TYPE"));
		return super.commonDao.list("s_biv360skrv_wmServiceImpl.selectList", param);
	}
}