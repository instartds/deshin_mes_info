package foren.unilite.modules.human.hum;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum102rkrService")
public class Hum102rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 사원조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return (List) super.commonDao.list("hum102rkrService.selectList", param);
    }
	
}
