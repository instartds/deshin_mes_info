package foren.unilite.modules.z_hs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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



@Service("s_emp100skr_hsService")
public class S_emp100skr_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/*
	 * 생산현환
	*/
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_BUFFERED, group = "eis" )		//STORE_READ  일때  page, start, limit 값 못가져옴..
	public Map<String, Object> selectList( Map param) throws Exception {

		Map<String, Object> rMap = new HashMap();
	        
        Map<String, Object> rTotal = new HashMap();
        List<Map<String, Object>> rList = new ArrayList();

        rList = (List)super.commonDao.list("s_emp100skr_hsserviceimpl.selectList", param);

        int total = 0;
        if (rList.size() > 0) {
            Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
            total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
        }
        rMap.put("data", rList);
        rMap.put("total", total);

        return rMap;
		
	}
	
	/**
	 * 에이치 설퍼 출하내역 환율 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_hs", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectExchg(Map param) throws Exception {
		return super.commonDao.list("s_emp100skr_hsserviceimpl.selectExchg", param);
	}
}
