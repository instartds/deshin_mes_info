package foren.unilite.modules.human.hum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum290ukrService")
public class Hum290ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 개별평정 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
			
		return (List) super.commonDao.list("hum290ukrServiceImpl.select1", param);
	}
	
	/**
	 * 종합평정 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
			
		return (List) super.commonDao.list("hum290ukrServiceImpl.select2", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(String comp_code) throws Exception {
		return (List)super.commonDao.list("hum290ukrServiceImpl.selectColumns" ,comp_code);
	}
}
