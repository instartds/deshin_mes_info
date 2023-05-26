package foren.unilite.modules.com.potal;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;

@Service("mainPortalFORENService")
public class MainPortalFORENServiceImpl extends TlabAbstractCommonServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(MainPortalFORENServiceImpl.class);
	
	/**
	 * 컨설팅팀
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectCounsulting(Map param) throws Exception {
		
		return  super.commonDao.list("mainPortalFORENServiceImpl.consulting", param);
	}
	
	/**
	 * IT 서비스팀
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectItService(Map param) throws Exception {
		
		return  super.commonDao.list("mainPortalFORENServiceImpl.itService", param);
	}
	
	/**
	 * 개발팀
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectDevelopment(Map param) throws Exception {
		
		return  super.commonDao.list("mainPortalFORENServiceImpl.development", param);
	}
	
	/**
	 * 연구소
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectLab(Map param) throws Exception {
		
		return  super.commonDao.list("mainPortalFORENServiceImpl.lab", param);
	}
	
}
