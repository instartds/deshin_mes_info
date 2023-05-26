package foren.unilite.modules.busincome.gcd;

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


@Service("gcd300ukrvService")
public class Gcd300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gcd300ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insertList(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			super.commonDao.update("gcd300ukrvServiceImpl.insert", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  updateList(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			super.commonDao.update("gcd300ukrvServiceImpl.update", param);		
		}
		return  paramList;
	}
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  deleteList(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			super.commonDao.update("gcd300ukrvServiceImpl.delete", param);		
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
				
				if(param.get("method").equals("deleteList")) {
					param.put("data", deleteList(dataList,user) );	
				} 
				if(param.get("method").equals("insertList")) {
					param.put("data", insertList(dataList,user) );	
				} 
				if(param.get("method").equals("updateList")) {
					param.put("data", updateList(dataList,user) );	
				}
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
	
		
}
