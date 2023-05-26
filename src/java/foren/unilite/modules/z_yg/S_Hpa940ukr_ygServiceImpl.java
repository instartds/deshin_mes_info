package foren.unilite.modules.z_yg;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.utils.FileUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_hpa940ukr_ygService")
public class S_Hpa940ukr_ygServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	/**
	 * 인사자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectList");
		return (List) super.commonDao.list("s_hpa940ukr_ygServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	public S_Hpa940ukr_ygEmailModel selectEmailList(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectEmailList");
		return (S_Hpa940ukr_ygEmailModel) super.commonDao.queryForObject("s_hpa940ukr_ygServiceImpl.selectEmailList", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	public S_Hpa940ukr_ygSmtpModel selectSmtpInfo(String param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectSmtpInfo");
		return (S_Hpa940ukr_ygSmtpModel) super.commonDao.queryForObject("s_hpa940ukr_ygServiceImpl.selectSmtpInfo", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	public S_Hpa940ukr_ygYearModel selectYearInfo(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectYearInfo");
		return (S_Hpa940ukr_ygYearModel) super.commonDao.queryForObject("s_hpa940ukr_ygServiceImpl.selectYearInfo", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	//1. 근태코드
	public List selectCode1(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectCode1");
		return super.commonDao.list("s_hpa940ukr_ygServiceImpl.selectCode1", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	//2. 지급코드
	public List selectCode2(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectCode2");
		return super.commonDao.list("s_hpa940ukr_ygServiceImpl.selectCode2", param);
	}
	
	@ExtDirectMethod(group = "hpa")
	//3. 공제코드
	public List selectCode3(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectCode3");
		return super.commonDao.list("s_hpa940ukr_ygServiceImpl.selectCode3", param);
	}
	
	
	
	@ExtDirectMethod(group = "hpa")
	public S_Hpa940ukr_ygWorkModel selectWorkInfo(S_Hpa940ukr_ygModel param) throws Exception {
		logger.debug("s_hpa940ukr_ygServiceImpl.selectWorkInfo");
		return (S_Hpa940ukr_ygWorkModel) super.commonDao.queryForObject("s_hpa940ukr_ygServiceImpl.selectWorkInfo", param);
	}
	
	

}
