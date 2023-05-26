package foren.unilite.modules.z_in;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.exolab.castor.mapping.xml.Param;
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



@Service("s_biv320skrv_inService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Biv320skrv_inServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_biv320skrv_inServiceImpl.selectList", param);
	}


	/**
	 * 수불상세내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  detailDataList (Map param) throws Exception {
		return  super.commonDao.list("s_biv320skrv_inServiceImpl.detailDataList", param);
	}
}