package foren.unilite.modules.base.grt;

import java.util.ArrayList;
import java.util.HashMap;
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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

import javax.annotation.Resource;

@Service("grt110ukrvService")
public class Grt110ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("grt110ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "base")
	public Object  checkDate(Map param) throws Exception {	
		return  super.commonDao.select("grt110ukrvServiceImpl.checkDate", param);
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insert(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			param.put("S_USER_ID", user.getUserID());
			String orgSTime = ObjUtils.getSafeString(param.get("RUN_START_TIME"));
			String orgETime = ObjUtils.getSafeString(param.get("RUN_LAST_TIME"));
			
			String sTime =  ObjUtils.getSafeString(param.get("RUN_START_TIME")).replaceAll("\\:", "");
			String eTime =  ObjUtils.getSafeString(param.get("RUN_LAST_TIME")).replaceAll("\\:", "");
			
			if(sTime.length() == 4) param.put("RUN_START_TIME",sTime+"00");
			else  param.put("RUN_START_TIME",sTime);
			 
			if(eTime.length() == 4) param.put("RUN_LAST_TIME", eTime+"00");
			else param.put("RUN_LAST_TIME", eTime);
			
			Map fMap = syncFileList(param, user);
			if(!ObjUtils.isEmpty(fMap))	{
				param.put("DOC_NO", fMap.get("DOC_NO"));
			}
			super.commonDao.queryForObject("grt110ukrvServiceImpl.insert", param);		
			param.put("RUN_START_TIME", orgSTime);
			param.put("RUN_LAST_TIME", orgETime);
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			
			param.put("S_USER_ID", user.getUserID());
			
			String sTime =  ObjUtils.getSafeString(param.get("RUN_START_TIME")).replaceAll("\\:", "");
			String eTime =  ObjUtils.getSafeString(param.get("RUN_LAST_TIME")).replaceAll("\\:", "");
			
			if(sTime.length() == 4) param.put("RUN_START_TIME",sTime+"00");
			else  param.put("RUN_START_TIME",sTime+"00");
			 
			if(eTime.length() == 4) param.put("RUN_LAST_TIME", eTime+"00");
			else param.put("RUN_LAST_TIME", eTime);
			
			Map fMap = syncFileList(param, user);
			if(!ObjUtils.isEmpty(fMap))	{
				param.put("DOC_NO", fMap.get("DOC_NO"));
			}
			super.commonDao.update("grt110ukrvServiceImpl.update", param);		
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  delete(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("grt110ukrvServiceImpl.delete", param);		
		}
		return  paramList;
	}
	
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList) );	
				}else if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList,user) );	
				}else if(param.get("method").equals("update")) {
					param.put("data", update(dataList,user) );	
				} 
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
	
	
	private Map syncFileList(Map param, LoginVO login) throws Exception {
		List<Map> rList = null;
		Map rtn = null;
		if(!ObjUtils.isEmpty(param.get("ADD_FIDS")) || !ObjUtils.isEmpty(param.get("DEL_FIDS")) )	{
			
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			fParam.put("DOC_NO", param.get("DOC_NO"));
			fParam.put("DOC_NAME", "[버스노선이력] "/*+param.getSUMMARY_STR()*/);
			fParam.put("ADD_FIDS", param.get("ADD_FIDS"));
			fParam.put("DEL_FIDS", param.get("DEL_FIDS"));
			fParam.put("S_COMP_CODE", login.getCompCode());
			fParam.put("S_USER_ID", login.getUserID());
			fParam.put("S_DEPT_CODE", login.getDeptCode());
			fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
			paramList.add(fParam);

			if(ObjUtils.isEmpty(param.get("DOC_NO")))	{
				rList = bdc100ukrvService.insertMulti(paramList, login);
			}else {
				rList = bdc100ukrvService.updateMulti(paramList, login);
			}

		}
		
		if (!ObjUtils.isEmpty(rList))	rtn = rList.get(0);
		
		return rtn;
	}

}
