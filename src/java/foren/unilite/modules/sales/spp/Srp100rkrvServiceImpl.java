package foren.unilite.modules.sales.spp;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srp100rkrvService")
public class Srp100rkrvServiceImpl  extends TlabAbstractServiceImpl {
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("srp100rkrvServiceImpl.mainReport", param); 
	}
	
	/**
	 * 거래명세서 목록 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("srp100rkrvServiceImpl.subReport", param); 
	}
}
