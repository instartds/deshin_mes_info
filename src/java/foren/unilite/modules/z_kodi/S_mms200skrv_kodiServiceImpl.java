package foren.unilite.modules.z_kodi;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_mms200skrv_kodiService")
public class S_mms200skrv_kodiServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 *
	 * 접수등록 ->접수번호검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mms200skrv_kodiServiceImpl.selectreceiptNumMasterList", param);
	}

	/**
	 *
	 * print
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printList(Map param) throws Exception {
		return super.commonDao.list("s_mms200skrv_kodiServiceImpl.printList", param);
	}

	/**
	 *
	 * printListItemLotGroup
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printListItemLotGroup(Map param) throws Exception {
		return super.commonDao.list("s_mms200skrv_kodiServiceImpl.printListItemLotGroup", param);
	}

	/**
	 *
	 * printListItemLotGroup2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printListItemLotGroup2(Map param) throws Exception {
		return super.commonDao.list("s_mms200skrv_kodiServiceImpl.printListItemLotGroup2", param);
	}

}
