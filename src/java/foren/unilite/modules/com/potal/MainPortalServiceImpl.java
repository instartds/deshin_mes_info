package foren.unilite.modules.com.potal;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;

@Service("mainPortalService")
public class MainPortalServiceImpl extends TlabAbstractCommonServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(MainPortalServiceImpl.class);
	
	/**
	 * 월별 매출
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectSales1(Map param) throws Exception {
		
		return  super.commonDao.list("mainPortalServiceImpl.selectSales1", param);
	}
	
	
}
