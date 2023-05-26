package foren.unilite.modules.human.hpa;

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

@Service("hpa940ukrService")
public class Hpa940ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	/**
	 * 인사자료목록조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectList");
		return (List) super.commonDao.list("Hpa940ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Hpa940ukrEmailModel selectEmailList(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectEmailList");
		return (Hpa940ukrEmailModel) super.commonDao.queryForObject("Hpa940ukrServiceImpl.selectEmailList", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Hpa940ukrSmtpModel selectSmtpInfo(String param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectSmtpInfo");
		return (Hpa940ukrSmtpModel) super.commonDao.queryForObject("Hpa940ukrServiceImpl.selectSmtpInfo", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Hpa940ukrYearModel selectYearInfo(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectYearInfo");
		return (Hpa940ukrYearModel) super.commonDao.queryForObject("Hpa940ukrServiceImpl.selectYearInfo", param);
	}
	
	@ExtDirectMethod(group = "human")
	//1. 근태코드
	public List selectCode1(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectCode1");
		return super.commonDao.list("Hpa940ukrServiceImpl.selectCode1", param);
	}
	
	@ExtDirectMethod(group = "human")
	//2. 지급코드
	public List selectCode2(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectCode2");
		return super.commonDao.list("Hpa940ukrServiceImpl.selectCode2", param);
	}
	
	@ExtDirectMethod(group = "human")
	//3. 공제코드
	public List selectCode3(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectCode3");
		return super.commonDao.list("Hpa940ukrServiceImpl.selectCode3", param);
	}
	
	
	
	@ExtDirectMethod(group = "human")
	public Hpa940ukrWorkModel selectWorkInfo(Hpa940ukrModel param) throws Exception {
		logger.debug("hpa940ukrServiceImpl.selectWorkInfo");
		return (Hpa940ukrWorkModel) super.commonDao.queryForObject("Hpa940ukrServiceImpl.selectWorkInfo", param);
	}
	
	@ExtDirectMethod(group = "human")
	public String selectsenduser(Map param) throws Exception {
				
		List<Map>qureyValue = (List<Map>) super.commonDao.list("Hpa940ukrServiceImpl.selectsenduser", param);
		String sendusername = (String) qureyValue.get(0).get("SEND_USER_NAME");
			
		return sendusername;
	}
	
	@ExtDirectMethod(group = "human")
	public void updateLog(Map param) throws Exception {
		super.commonDao.update("Hpa940ukrServiceImpl.updateLog", param);
	}
	
	@ExtDirectMethod(group = "human")
	public List selectResultList(Map param) throws Exception {
		return super.commonDao.list("Hpa940ukrServiceImpl.selectResultList", param);
	}
}
