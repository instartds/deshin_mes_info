package foren.unilite.modules.prodt.pmp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("pmp284ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Pmp284ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

	/**Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList1(Map param,LoginVO user) throws Exception {
		param.put("MONEY_UNIT", user.getCurrency());
		return  super.commonDao.list("pmp284ukrvServiceImpl.selectList1", param);
	}

	/** Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param,LoginVO user) throws Exception {
		return  super.commonDao.list("pmp284ukrvServiceImpl.selectList2", param);
	}
	
	/** 공정정보 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		return  super.commonDao.list("pmp284ukrvServiceImpl.selectList", param);
	}	


	/**
	 * 출고등록->출고내역검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreleaseNoMasterList(Map param) throws Exception {
		return super.commonDao.list("mtr210ukrvServiceImpl.selectreleaseNoMasterList", param);
	}


}
