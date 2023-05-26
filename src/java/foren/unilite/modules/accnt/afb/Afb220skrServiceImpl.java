package foren.unilite.modules.accnt.afb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("afb220skrService")
public class Afb220skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 월차예산실적비교
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {	
		Map getAmtPoint	= (Map)super.commonDao.select("afb220skrServiceImpl.getAmtPoint", param);
		String sAmtPoint= (String) getAmtPoint.get("Amt_Point"); 
		param.put("AMT_POINT", sAmtPoint);
		return  super.commonDao.list("afb220skrServiceImpl.selectList1", param);
	}
}
