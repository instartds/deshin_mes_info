package foren.unilite.modules.human.had;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("had890ukrService")
public class Had890ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")			// 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("had890ukrServiceImpl.selectList", param);
	}
	
	/**
	 * @param SMTP 전송정보 조회
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")
	public Map selectSmtpInfo(String param) throws Exception {
		return (Map)super.commonDao.queryForObject("had890ukrServiceImpl.selectSmtpInfo", param);
	}
	
	/**
	 * @param 메일 전송 결과 insert
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")
	public void updateLog(Map param) throws Exception {
		super.commonDao.update("had890ukrServiceImpl.updateLog", param);
	}
	
	/**
	 * @param 전송결과 조회
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")
	public List selectResultList(Map param) throws Exception {
		return super.commonDao.list("had890ukrServiceImpl.selectResultList", param);
	}
}
