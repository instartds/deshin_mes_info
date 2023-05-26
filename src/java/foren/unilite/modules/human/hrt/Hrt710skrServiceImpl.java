package foren.unilite.modules.human.hrt;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bcm.Bcm105ukrvModel;
import foren.unilite.modules.base.bpr.Bpr300ukrvModel;
import foren.unilite.utils.ExtFileUtils;

@Service("hrt710skrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hrt710skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "human";


	/** data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("hrt710skrServiceImpl.selectList", param);
	}
}