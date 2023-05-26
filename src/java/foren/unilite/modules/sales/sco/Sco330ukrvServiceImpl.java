package foren.unilite.modules.sales.sco;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
@Service("sco330ukrvService")
public class Sco330ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	/**
     * 조회
     * @param param
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("sco330ukrvServiceImpl.selectList", param);
    }
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")        // 부도처리
    public Object procButton(Map param, LoginVO user) throws Exception {
        Object r = super.commonDao.queryForObject("sco330ukrvServiceImpl.procButton", param);
        Map<String, Object> rMap = (Map<String, Object>) r;
        if(!"".equals(rMap.get("ERROR_CODE")))  {
            String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
            throw new UniDirectValidateException(this.getMessage(sErr[0], user));
        }
        return r;
    }   
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "accnt")        // 부도취소
    public Object cancButton(Map param, LoginVO user) throws Exception {
        Object r = super.commonDao.queryForObject("sco330ukrvServiceImpl.cancButton", param);
        Map<String, Object> rMap = (Map<String, Object>) r;
        if(!"".equals(rMap.get("ERROR_CODE")))  {
            String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
            throw new UniDirectValidateException(this.getMessage(sErr[0], user));
        }
        return r;
    }
    
}
