package foren.unilite.modules.z_kd;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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


@Service("s_bpr110rkrv_kdService")
public class S_bpr110rkrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	
	
	/**
     *  B/OUT 공급/폐기현황 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
    public Object selectMaster(Map param) throws Exception {     
        return super.commonDao.select("s_bpr110rkrv_kdService.selectMaster", param);
    }
}
