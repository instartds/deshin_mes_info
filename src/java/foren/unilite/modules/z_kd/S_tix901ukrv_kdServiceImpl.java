package foren.unilite.modules.z_kd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
@Service("s_tix901ukrv_kdService")
public class S_tix901ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "trade")
	public Object selectFormMaster(Map param) throws Exception {
		return  super.commonDao.select("s_tix901ukrv_kdServiceImpl.selectFormMaster", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "trade")
    public Object selectFormDetail(Map param) throws Exception {
        return  super.commonDao.select("s_tix901ukrv_kdServiceImpl.selectFormDetail", param);
    }
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  
    public List<Map<String, Object>> selectUnloadPlace(Map param) throws Exception {
        return super.commonDao.list("s_tix901ukrv_kdServiceImpl.selectUnloadPlace", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
    public ExtDirectFormPostResult syncMaster(S_tix901ukrv_kdModel param, LoginVO user,  BindingResult result) throws Exception {
	    String offerNo = (String)super.commonDao.select("s_tix901ukrv_kdServiceImpl.selectS_TIX901T_KD", param);
        if(ObjUtils.isEmpty(offerNo)) {
            super.commonDao.update("s_tix901ukrv_kdServiceImpl.insertForm", param);
            ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
            return extResult;
        } else {
            super.commonDao.update("s_tix901ukrv_kdServiceImpl.updateForm", param);
            ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
            return extResult;
        }   
    }
	
}
