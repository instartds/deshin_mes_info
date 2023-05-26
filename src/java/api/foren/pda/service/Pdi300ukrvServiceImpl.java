package api.foren.pda.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
/**
 * 재고조회 库存查询
 * @author Administrator
 *
 */
@Service("pdi300ukrvService")
public class Pdi300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 
	 */
	public List selectStockList(Map param)throws UniDirectException{
		return super.commonDao.list("pdi300ukrvServiceImpl.selectStockList", param);
	}
	
}
