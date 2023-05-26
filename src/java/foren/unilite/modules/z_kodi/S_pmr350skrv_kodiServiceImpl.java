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

@Service("s_pmr350skrv_kodiService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_pmr350skrv_kodiServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 불량분석현황조회-거래처별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectList", param);
	}
	
	/**
	 * 불량분석현황조회-유형별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectListL(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectListL", param);
	}	
	
	/**
	 * 불량수량집계-거래처별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectList1", param);
	}
	

	
	/**
	 * 불량수량집계-분류별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectListL1(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectListL1", param);
	}	
	
	/**
	 * 불량현황차트-거래처별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectBadList(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectBadList", param);
	}	
	
	/**
	 * 불량현황차트-유형별
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kodi")
	public List<Map<String, Object>>  selectBadListL(Map param) throws Exception {
		return  super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectBadListL", param);
	}	
	
	
	/**
	 * 자재불량유형 코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectBadcodes(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr350skrv_kodiServiceImpl.selectBadcodes" ,comp_code);
	}	

	
}

