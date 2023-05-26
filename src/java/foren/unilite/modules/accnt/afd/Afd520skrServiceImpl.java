package foren.unilite.modules.accnt.afd;

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



@Service("afd520skrService")
public class Afd520skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	@Resource(name="afd510skrService")
	private Afd510skrServiceImpl afd510skrService;
	
	/**
	 * 
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		Map<String, Object> amtPointMap = (Map<String, Object>) afd510skrService.selectForm(param);
		String roundAmtPoint = "";
		String amtPoint  = ObjUtils.getSafeString(amtPointMap.get("AMT_POINT"));
		if("1".equals(amtPoint))	{
			roundAmtPoint =  ", " + amtPoint+ ", 1";
		} else if("2".equals(amtPoint))	{
			roundAmtPoint = "+ 0.4 * " + ( 10 ^ ((-1) *  ObjUtils.parseInt(amtPointMap.get("AMT_PONT")))) + ", " + amtPointMap.get("AMT_PONT") + ", 1";
		} else {
			roundAmtPoint = ", " + amtPoint ;
		}
		param.put("ROUND_AMT_POINT",roundAmtPoint);
		return super.commonDao.list("afd520skrService.selectMasterList", param);
	}	
}
