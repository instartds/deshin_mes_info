package foren.unilite.modules.busincome.gch;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("gch100ukrvService")
public class Gch100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gch100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			param.put("NOTINSERVICE_YN", (ObjUtils.parseBoolean(param.get("NOTINSERVICE_YN"),false) ? "Y":"N"));
			
			super.commonDao.update("gch100ukrvServiceImpl.update", param);	
			param.put("NOTINSERVICE_YN", (ObjUtils.getSafeString(param.get("NOTINSERVICE_YN")) == "Y" ? true:false));
			
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("update")) {
					param.put("data", update(dataList,user) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
}
