package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("bsa920skrvService")
public class Bsa920skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  이체건수 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bsa920skrvServiceImpl.selectList", param);
    }
	
	/**
     *  etax 건수 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList2(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bsa920skrvServiceImpl.selectList2", param);
    }
    
    /**
     *  법인카드 건수 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList3(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bsa920skrvServiceImpl.selectList3", param);
    }
    
    /**
     *  자동기표현황 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
    public List<Map> selectList4(Map param, LoginVO user) throws Exception {
        return  super.commonDao.list("bsa920skrvServiceImpl.selectList4", param);
    }

}
