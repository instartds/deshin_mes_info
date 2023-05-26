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



@Service("had880skrService")
public class Had880skrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	

	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "coop")			// 조회
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		String year = ObjUtils.getSafeString(param.get("YEAR_YYYY"));
		int yyyy = ObjUtils.parseInt(param.get("YEAR_YYYY"));
		String strSql = "had880skrServiceImpl.selectList";
		if(ObjUtils.isNotEmpty(year))	{
			if(yyyy >= 2020){
				year = "2020";
			}
			strSql = "had880skrServiceImpl.selectList_"+year;
		}
		return  super.commonDao.list(strSql, param);	
	}	
 	
}