package foren.unilite.modules.z_kocis;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("s_hrt700skrService_KOCIS")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_Hrt700skrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		logger.debug("s_hrt700skrServiceImpl_KOCIS.selectList");
		return (List) super.commonDao.list("s_hrt700skrServiceImpl_KOCIS.selectList", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub1(Map param) throws Exception {
		logger.debug("s_hrt700skrServiceImpl_KOCIS.selectSub1");
		return (List) super.commonDao.list("s_hrt700skrServiceImpl_KOCIS.selectSub1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub2(Map param) throws Exception {
		logger.debug("s_hrt700skrServiceImpl_KOCIS.selectSub2");
		return (List) super.commonDao.list("s_hrt700skrServiceImpl_KOCIS.selectSub2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub3(Map param) throws Exception {
		logger.debug("s_hrt700skrServiceImpl_KOCIS.selectSub3");
		return (List) super.commonDao.list("s_hrt700skrServiceImpl_KOCIS.selectSub3", param);
	}

	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub4(Map param) throws Exception {
		logger.debug("s_hrt700skrServiceImpl_KOCIS.selectSub4");
		return (List) super.commonDao.list("s_hrt700skrServiceImpl_KOCIS.selectSub4", param);
	}

	
}