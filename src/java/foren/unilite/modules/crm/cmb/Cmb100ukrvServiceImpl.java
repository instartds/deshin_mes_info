package foren.unilite.modules.crm.cmb;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("cmb100ukrvService")
public class Cmb100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 고객카드관리 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "crm")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		// FIXME 'SORT_STR'처리 CMS300T.SORT_STR
		param.put("SORT_STR", "1");
		return  super.commonDao.list("cmb100ukrvServiceImpl.getDataList", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public List<Map>  insertMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		
		for(Map param :paramList )	{
			String rs= String.valueOf(super.commonDao.insert("cmb100ukrvServiceImpl.insertMulti", param));			
			param.put("CLIENT_ID", rs);
			if(!ObjUtils.isEmpty(param.get("BUSINESSCARD_FID") ))	{
				fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("BUSINESSCARD_FID")));
			}
		}
		return  paramList;
	}
	

	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public List<Map>  updateMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
			logger.debug(ObjUtils.toJsonStr(param).toString());
			r += super.commonDao.update("cmb100ukrvServiceImpl.updateMulti", param);
			if(!ObjUtils.isEmpty(param.get("BUSINESSCARD_FID") ))	{
				fileMnagerService.confirmFile(login, ObjUtils.getSafeString(param.get("BUSINESSCARD_FID")));
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "crm")
	public List<Map>  deleteMulti(List<Map> paramList, LoginVO login) throws Exception {
		int r = 0;
		for(Map param :paramList )	{
			r += super.commonDao.delete("cmb100ukrvServiceImpl.deleteMulti", param);
			if(!ObjUtils.isEmpty(param.get("BUSINESSCARD_FID") ))	{
				fileMnagerService.deleteFile(login, ObjUtils.getSafeString(param.get("BUSINESSCARD_FID")));
			}
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "crm")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "crm")
	public List<Map<String, Object>>  getClientList(Map param) throws Exception {		
		return  super.commonDao.list("cmb100ukrvServiceImpl.getClientList", param);
	}
	
}
