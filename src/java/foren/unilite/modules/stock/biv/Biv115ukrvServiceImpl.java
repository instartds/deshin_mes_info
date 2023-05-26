package foren.unilite.modules.stock.biv;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("biv115ukrvService")
public class Biv115ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  YyyymmSet(Map param) throws Exception {	
		return  super.commonDao.select("biv115ukrvService.YyyymmSet", param);	// 자동 날짜 지정
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  WhCodeSet(Map param) throws Exception {	
		return  super.commonDao.select("biv115ukrvService.WhCodeSet", param);	// 실행할때 창고 검사
	}
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  WhCodeCount(Map param) throws Exception {	
		return  super.commonDao.select("biv115ukrvService.WhCodeCount", param);	// 실행할때 창고 recordCount검사
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,  group = "stock")		// 실행
	public Object insertMaster(Map param, LoginVO user) throws Exception {
		//super.commonDao.select("biv115ukrvService.WhCodeSet", param);	// 실행할때 창고 검사
		Object r = super.commonDao.queryForObject("biv115ukrvService.insertDetail", param);
		Map<String, Object>	rMap = (Map<String, Object>) r;
		if(!"".equals(rMap.get("ERROR_CODE")))	{
			String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
			throw new UniDirectValidateException(this.getMessage(sErr[0], user));
		}
		return r;
	}
}
