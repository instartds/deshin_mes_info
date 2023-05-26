package foren.unilite.modules.human.had;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("had810skrService")
public class Had810skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	

	
	/**
	 * 기타소득내역 그리드 검색
	 * @param 
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")			// 조회
	public List<Map<String, Object>>  gridSelectList1(Map param) throws Exception {
		String year = ObjUtils.getSafeString(param.get("YEAR_YYYY"));
		String strSql = "had810skrServiceImpl.gridSelectList1";
		if(ObjUtils.isNotEmpty(year))	{
			strSql = "had810skrServiceImpl.gridSelectList1_"+year;
		}
		return  super.commonDao.list(strSql, param);	
	}
 	
	/**
	 * 비과세 그리드 검색
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")			// 조회
	public List<Map<String, Object>>  gridSelectList2(Map param) throws Exception {
		String year = ObjUtils.getSafeString(param.get("YEAR_YYYY"));
		String strSql = "had810skrServiceImpl.gridSelectList2";
		if(ObjUtils.isNotEmpty(year))	{
			strSql = "had810skrServiceImpl.gridSelectList2_"+year;
		}
		return  super.commonDao.list(strSql, param);	
	}
	
	/**
	 * detailForm 검색
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {	
		String year = ObjUtils.getSafeString(param.get("YEAR_YYYY"));
		String strSql = "had810skrServiceImpl.selectForm";
		if(ObjUtils.isNotEmpty(year))	{
			strSql = "had810skrServiceImpl.selectForm_"+year;
		}
		return super.commonDao.select(strSql, param);		
		
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectPrev(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had810skrServiceImpl.selectPrevious", param);
		return rv;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectNext(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had810skrServiceImpl.selectNext", param);
		return rv;
	}
	
}
