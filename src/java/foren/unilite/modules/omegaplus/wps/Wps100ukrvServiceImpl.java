package foren.unilite.modules.omegaplus.wps;

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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("wps100ukrvService")
public class Wps100ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	
	@Resource(name = "wps110skrvService")
	private Wps110skrvServiceImpl wps110skrvService;
	
	/**
	 *  조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("wps100ukrvServiceImpl.selectList", param);
		return rv;
	}

	/**
	 *  입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  insert(List<Map> paramList, LoginVO user) throws Exception {

		for(Map param :paramList )	{
			Map<String, Object> newIdMap = this.maxId(param);
			param.put("WORK_ID", newIdMap.get("WORK_ID"));
			if(param.get("ADD_FIDS") != null ||  param.get("DEL_FIDS") != null)	{
				param.put("DOC_NO", param.get("DOC_ID"));
				Map<String, Object> fileDoc = this.syncFileList(param, user);
				if(fileDoc != null)	{
					param.put("DOC_ID", fileDoc.get("DOC_NO"));
				}
			}
			super.commonDao.insert("wps100ukrvServiceImpl.insert", param);
			
		}
		return  paramList;
	}

	/**
	 *  MAS WORK_ID
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	private Map<String, Object>  maxId(Map param) throws Exception {
		Map<String, Object> rv = (Map<String, Object>) super.commonDao.select("wps100ukrvServiceImpl.maxId", param);
		return rv;
	}	
	
	/**
	 * 수정
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  update(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{
			if(param.get("ADD_FIDS") != null ||  param.get("DEL_FIDS") != null)	{
				param.put("DOC_NO", param.get("DOC_ID"));
				Map<String, Object> fileDoc = this.syncFileList(param, user);
				if(fileDoc != null)	{
					param.put("DOC_ID", fileDoc.get("DOC_NO"));
				}
			}
			super.commonDao.update("wps100ukrvServiceImpl.update", param);
		}
		return  paramList;
	}
	
	/**
	 * 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  delete(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{				
				super.commonDao.update("wps100ukrvServiceImpl.delete", param);
		}
		return  paramList;	
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "com")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList, user) );	
				} else if(param.get("method").equals("update")) {
					param.put("data", update(dataList, user ) );	
				} else if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList) );	
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	private Map syncFileList(Map param, LoginVO login) throws Exception {
        List<Map> rList = null;
        Map rtn = null;
        if(!ObjUtils.isEmpty(param.get("ADD_FIDS")) || !ObjUtils.isEmpty(param.get("DEL_FIDS")))  {
            
            List<Map> paramList = new ArrayList<Map>();
            Map fParam = new HashMap();
            fParam.put("DOC_NO", param.get("DOC_NO"));
            fParam.put("ADD_FIDS", param.get("ADD_FIDS"));
            fParam.put("DEL_FIDS", param.get("DEL_FIDS"));
            fParam.put("S_COMP_CODE", login.getCompCode());
            fParam.put("S_USER_ID", login.getUserID());
            fParam.put("S_DEPT_CODE", login.getDeptCode());
            fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
            paramList.add(fParam);
            if(ObjUtils.isEmpty(param.get("DOC_NO")))    {
                rList = bdc100ukrvService.insertMulti(paramList, login);
            }else {
                rList = bdc100ukrvService.updateMulti(paramList, login);
            }
        }
        if (!ObjUtils.isEmpty(rList))   rtn = rList.get(0);
        return rtn;
    }
	
	/**
	 *  팝업조회(row widget)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectReqDevList(Map param) throws Exception {
		List<Map<String, Object>> rv =   super.commonDao.list("wps100ukrvServiceImpl.selectList", param);
		List<Map<String, Object>> devList =   wps110skrvService.selectList(param);
		
		for(Map<String, Object> map1 : rv)	{
			List<Map<String, Object>> sub = new ArrayList<Map<String, Object>>();
			for(Map<String, Object> map2: devList)	{
				if(map2.get("WORK_ID").toString().equals(map1.get("WORK_ID").toString()))	{
					sub.add(map2);
				}
			}
			map1.put("DEV",sub);
		}
		return rv;
	}
}
