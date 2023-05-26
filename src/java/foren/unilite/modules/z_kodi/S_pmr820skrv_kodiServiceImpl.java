package foren.unilite.modules.z_kodi;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.utils.ExtFileUtils;

@Service("s_pmr820skrv_kodiService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_pmr820skrv_kodiServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주번호별 생산투입공수합계
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pmr820skrv_kodiServiceImpl.selectList", param);
	}

	
}