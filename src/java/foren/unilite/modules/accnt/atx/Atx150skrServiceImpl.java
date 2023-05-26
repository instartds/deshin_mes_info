package foren.unilite.modules.accnt.atx;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("atx150skrService")
public class Atx150skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("atx150skrService.selectMasterList", param);
	}	
	
	
	
	/**
	 * 
	 * DIV_CODE 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getDivCode(Map param) throws Exception {
		return super.commonDao.list("atx150skrService.getDivCode", param);
	}	

}
