package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_mrp110ukrv_kdService")
public class S_mrp110ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
    //에러메세지 처리
    String errorDesc = "";
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_MODIFY)		// 실행
	public Object procButton(Map param, LoginVO user) throws Exception {
		super.commonDao.queryForObject("s_mrp110ukrv_kdServiceImpl.releaseMRP", param);

		errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));

        if(!ObjUtils.isEmpty(errorDesc))	{
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}	
}
