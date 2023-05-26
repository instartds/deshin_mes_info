package foren.unilite.modules.z_jw;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;
import foren.unilite.utils.ExtFileUtils;

@Service("s_bpr910skrv_jwService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_bpr910skrv_jwServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
//	private  TlabCodeService tlabCodeService ;
//	
//	@Resource(name = "fileMnagerService")
//	private FileMnagerService fileMnagerService;
	public final static String FILE_TYPE_OF_PHOTO = "base";	
	
	/**
	 * 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {		

		return  super.commonDao.list("s_bpr910skrv_jwService.selectList", param);
	}


}
