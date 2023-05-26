package foren.unilite.modules.bussafety.gac;

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


@Service("gac200ukrvService")
public class Gac200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gac200ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insert(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			super.commonDao.update("gac200ukrvServiceImpl.insert", param);		
		}
		return  paramList;
	}

	
	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		
		List<Map> dataList = new ArrayList<Map>();
	
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList,user) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "bussafety", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("gac200ukrvServiceImpl.selectExcelUploadSheet1", param);
    }
    
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public void excelValidate(String jobID, Map param) {
		super.commonDao.update("gac200ukrvServiceImpl.excelValidate", param);
	}
		
}
