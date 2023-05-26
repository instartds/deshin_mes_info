package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("afb210skrService")
public class Afb210skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 월차예산실적비교(분기별)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {	
		//AMP_POINT구하기
		Map getAmtPoint	= (Map)super.commonDao.select("afb210skrServiceImpl.getAmtPoint", param);
		String sAmtPoint= (String) getAmtPoint.get("AMT_POINT"); 
		param.put("AMT_POINT", sAmtPoint);
		
		//strBound 구하기 (분기, 반기)
		//분기
		Map getQuarterly = new HashMap();
		List<Map<String, Object>> quarterly	= (List<Map<String, Object>>) super.commonDao.list("afb210skrServiceImpl.getStrBound1", param);
		param.put("quarterly", quarterly);
		
		//반기
		//Map getSemiAnnual = new HashMap();
		//List<Map<String, Object>> semiAnnual= (List<Map<String, Object>>) super.commonDao.list("afb210skrServiceImpl.getStrBound2", param);
		//param.put("semiAnnual", semiAnnual);
		
		return  super.commonDao.list("afb210skrServiceImpl.selectList1", param);
	}
	
	/**
	 * 월차예산실적비교(반기별)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {	
		//AMP_POINT구하기
		Map getAmtPoint	= (Map)super.commonDao.select("afb210skrServiceImpl.getAmtPoint", param);
		String sAmtPoint= (String) getAmtPoint.get("AMT_POINT"); 
		param.put("AMT_POINT", sAmtPoint);

		//strBound 구하기 (분기, 반기)
		//분기
		//Map getQuarterly = new HashMap();
		//List<Map<String, Object>> quarterly	= (List<Map<String, Object>>) super.commonDao.list("afb210skrServiceImpl.getStrBound1", param);
		//param.put("quarterly", quarterly);
		
		//반기
		Map getSemiAnnual = new HashMap();
		List<Map<String, Object>> semiAnnual= (List<Map<String, Object>>) super.commonDao.list("afb210skrServiceImpl.getStrBound2", param);
		param.put("semiAnnual", semiAnnual);
		
		return  super.commonDao.list("afb210skrServiceImpl.selectList2", param);
	}
}
