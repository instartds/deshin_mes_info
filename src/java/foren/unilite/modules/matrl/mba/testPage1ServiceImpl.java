package foren.unilite.modules.matrl.mba;

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
import foren.unilite.modules.matrl.mba.Mba020ukrvModel;


@Service("testPage1Service")
public class testPage1ServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 구매자재기준설정 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
//	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
//	public List<Map<String, Object>> selectForm(Map param) throws Exception {
//		return super.commonDao.list("testPage1ServiceImpl.selectForm", param);
//	}
	
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("testPage1ServiceImpl.selectForm", param);
	}
	
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  A(Map param) throws Exception {	

		return  super.commonDao.select("testPage1ServiceImpl.A", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "matrl")
	public ExtDirectFormPostResult syncForm(Mba020ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("testPage1ServiceImpl.checkCompCode", compCodeMap);
	
		super.commonDao.update("testPage1ServiceImpl.updateForm", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
		
	}
	
	@ExtDirectMethod( group = "main")
	public Object searchMenu(Map param, LoginVO user) throws Exception {
//		String lang = user.getLanguage();
//		String targetField = "PGM_NAME";
//		if( "en".equals(lang)) {
//			targetField = "PGM_NAME_EN";
//		} else if( "zh".equals(lang)) {
//			targetField = "PGM_NAME_CN";
//		} else if( "ja".equals(lang)) {
//			targetField = "PGM_NAME_JP";
//		}
	//	param.put("TARGET_FIELD", targetField);
		List<Map<String,Object>> list = super.commonDao.list("testPage1ServiceImpl.searchMenu", param);
		Map<String, Object> rv = new HashMap<String, Object>();
//		int totalCount = 0;
//		if(list.size() > 0 ) {
//			Map<String,Object> rec =  list.get(0);
//			totalCount = (Integer)rec.get("TotalCount");
//		}
//		rv.put("total", totalCount);
		rv.put("records", list);
		
		return rv;
	}
	
	
	
	
	
	
	
	
	
}
