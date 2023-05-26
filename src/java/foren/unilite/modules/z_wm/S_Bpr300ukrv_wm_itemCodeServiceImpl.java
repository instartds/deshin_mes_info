package foren.unilite.modules.z_wm;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;
import foren.unilite.utils.ExtFileUtils;

@Service("S_Bpr300ukrv_wm_itemCodeService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Bpr300ukrv_wm_itemCodeServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 품목계정에 따른 품목코드 자동채번 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public Object selectAutoItemCode(Map param) throws Exception {
		return super.commonDao.select("S_Bpr300ukrv_wm_itemCodeService.selectAutoItemCode", param);
	}


	/**
	 * 채번 후 추가시 채번테이블에 insert 또는 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public String saveAutoItemCode(Map param) throws Exception {
		super.commonDao.update("S_Bpr300ukrv_wm_itemCodeService.saveAutoItemCode", param);
		return "Y";
	}
}