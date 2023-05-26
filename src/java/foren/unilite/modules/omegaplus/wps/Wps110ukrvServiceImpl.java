package foren.unilite.modules.omegaplus.wps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringEscapeUtils;
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

@Service("wps110ukrvService")
public class Wps110ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;
	/**
	 *  조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		List<Map<String, Object>> rv =   super.commonDao.list("wps110ukrvServiceImpl.selectList", param);
		return rv;
	}

	/**
	 *  개발,프로그램 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectPgm(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("wps110ukrvServiceImpl.selectPgm", param);
		return rv;
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectPgmList(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("wps110ukrvServiceImpl.selectPgmList", param);
		return rv;
	}
	
	/**
	 *  프로그램 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public List<Map<String, Object>>  selectPgmSearch(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("wps110ukrvServiceImpl.selectPgmSearch", param);
		return rv;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	public Map<String, Object>  maxSEQ(Map param) throws Exception {
		Map<String, Object> rv = (Map<String, Object>) super.commonDao.select("wps110ukrvServiceImpl.maxSEQ", param);
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
			if(param.get("ADD_FIDS") != null ||  param.get("DEL_FIDS") != null)	{
				param.put("DOC_NO", param.get("SQL_DOC_ID"));
				Map<String, Object> fileDoc = this.syncFileList(param, user);
				if(fileDoc != null)	{
					param.put("SQL_DOC_ID", fileDoc.get("DOC_NO"));
				}
			}
			if(param.get("SEQ") == null || ObjUtils.parseInt(param.get("SEQ")) == 0 )	{
				Map maxSeq = (Map) super.commonDao.select("wps110ukrvServiceImpl.maxSEQ", param);
				if(maxSeq != null )	{
					param.put("SEQ", maxSeq.get("SEQ"));
				}
			}
			super.commonDao.insert("wps110ukrvServiceImpl.insert", param);
		}
		return  paramList;
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
				param.put("DOC_NO", param.get("SQL_DOC_ID"));
				Map<String, Object> fileDoc = this.syncFileList(param, user);
				if(fileDoc != null)	{
					param.put("SQL_DOC_ID", fileDoc.get("DOC_NO"));
				}
			}
			
			if(param.get("SEQ")!= null && ObjUtils.parseInt(param.get("SEQ")) != 0)	{
				super.commonDao.update("wps110ukrvServiceImpl.update", param);
			}else {
				Map maxSeq = (Map) super.commonDao.select("wps110ukrvServiceImpl.maxSEQ", param);
				if(maxSeq != null )	{
					param.put("SEQ", maxSeq.get("SEQ"));
				}
				super.commonDao.insert("wps110ukrvServiceImpl.insert", param);
			}
		}

		return  paramList;
	}
	
	/**
	 * 개발자 수정
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  updateDev(List<Map> paramList, LoginVO user) throws Exception {

		
		for(Map param :paramList )	{
			if(param.get("ADD_FIDS") != null ||  param.get("DEL_FIDS") != null)	{
				param.put("DOC_NO", param.get("SQL_DOC_ID"));
				Map<String, Object> fileDoc = this.syncFileList(param, user);
				if(fileDoc != null)	{
					param.put("SQL_DOC_ID", fileDoc.get("DOC_NO"));
				}
			}
			
			if(param.get("SEQ")!= null && ObjUtils.parseInt(param.get("SEQ")) != 0)	{
				super.commonDao.update("wps110ukrvServiceImpl.updateDev", param);
			}else {
				Map maxSeq = (Map) super.commonDao.select("wps110ukrvServiceImpl.maxSEQ", param);
				if(maxSeq != null )	{
					param.put("SEQ", maxSeq.get("SEQ"));
				}
				super.commonDao.insert("wps110ukrvServiceImpl.insert", param);
			}
			
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
	public List<Map>  delete(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{				
				super.commonDao.update("wps110ukrvServiceImpl.delete", param);
		}
		return  paramList;	
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "com")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList, user) );	
					if(dataList != null && dataList.size() > 0)	{
						paramMaster.put("SEQ", dataList.get(0).get("SEQ"));
						logger.debug(">>>>>>>>>>>>>>>>>>  SEQ :"+dataList.get(0).get("SEQ"));
					}
				} else if(param.get("method").equals("update")) {
					param.put("data", update(dataList, user) );	
				} else if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList, user) );	
				}
			}
		}
		logger.debug(">>>>>>>>>>>>>>>>>>  SEQ paramMaster :"+paramMaster.get("SEQ"));
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "com")
	public List<Map> saveAllDev(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insert")) {
					param.put("data", insert(dataList, user) );	
				} else if(param.get("method").equals("updateDev")) {
					param.put("data", updateDev(dataList, user) );	
				} else if(param.get("method").equals("delete")) {
					param.put("data", delete(dataList, user) );	
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "com")
	public List<Map> saveAllPgm(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertPgm")) {
					param.put("data", insertPgm(dataList) );	
				}  else if(param.get("method").equals("deletePgm")) {
					param.put("data", deletePgm(dataList) );	
				}else if(param.get("method").equals("updatePgm")) {
					param.put("data", updatePgm(dataList) );	
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "com")
	private Map<String, Object>  maxPgmId(Map param) throws Exception {
		Map<String, Object> rv = (Map<String, Object>) super.commonDao.select("wps110ukrvServiceImpl.maxPgmId", param);
		return rv;
	}
	/**
	 *  입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  insertPgm(List<Map> paramList) throws Exception {

		for(Map param :paramList )	{
			Map<String, Object> newIdMap = this.maxPgmId(param);
			param.put("FILE_SEQ", newIdMap.get("FILE_SEQ"));
			super.commonDao.insert("wps110ukrvServiceImpl.insert120", param);
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
	public List<Map>  deletePgm(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{				
				super.commonDao.update("wps110ukrvServiceImpl.delete120", param);
		}
		return  paramList;	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map>  updatePgm(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{				
				super.commonDao.update("wps110ukrvServiceImpl.update120", param);
		}
		return  paramList;	
	}
	
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> getSQLList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("wps110ukrvServiceImpl.getSQLList", param);
	}
}
