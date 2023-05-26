package foren.unilite.modules.z_kd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("s_ppl190skrv_kdService")
public class S_ppl190skrv_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "tlabMenuService")
     TlabMenuService tlabMenuService;
    
    /**
     *  조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회(temp)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_ppl190skrv_kdService.selectList", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
    public List<Map<String, Object>> selectDetailList(Map param,LoginVO user) throws Exception {
        param.put("S_USER_ID", user.getUserID());
        param.put("S_COMP_CODE", user.getCompCode());
        return  super.commonDao.list("s_ppl190skrv_kdService.selectDetailList", param);
    }    
    
}