package foren.unilite.modules.matrl.biz;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("biz320skrvService")
public class Biz320skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)		// 조회
	public List<Map<String, Object>> selectList(Map param) throws Exception {
//		{ORDER_DATE_FR=201703, S_CUSTOM_NAME=null, S_LANG_CODE=ko, S_AUTHORITY_LEVEL=10, S_COMP_NAME=(주)고객, 
//		S_MAIN_COMP_CODE=MASTER, CUST_CODE=, ORDER_DATE_TO=201703, S_PERSON_NUMB=*,
//		ACCOUNT=, S_CUSTOM_CODE=null, S_USER_ID=UNILITE5, CUST_NAME=, S_USER_NAME=UNILITE5, DIV_CODE=01,
//		undefined=undefined, ITEM_NAME=, S_COMP_CODE=MASTER, ITEM_CODE=, S_DIV_CODE=01, S_REF_ITEM=0, S_DEPT_CODE=01}
		//param.put("TYPE", "1");
		Map refItemMap = (Map) super.commonDao.select("biz320skrvServiceImpl.selectRefItem",param);
		String refItem ; 
		if(refItemMap == null){
			refItem = "0";
		}else{
			refItem=refItemMap.get("REF_ITEM")+"";
		}
		param.put("REF_ITEM", refItem);
		Map refAmtFlagMap = (Map) super.commonDao.select("biz320skrvServiceImpl.selectRefAmtFlag",param);
		String refAmtFlag;
		if(refAmtFlagMap == null){
			refAmtFlag = "1";
		}else{
			refAmtFlag = refAmtFlagMap.get("REF_AMTFLAG")+"";
		}
		param.put("REF_AMTFLAG", refAmtFlag);
		return super.commonDao.list("biz320skrvServiceImpl.selectList", param);
	}
}
