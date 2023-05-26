package foren.unilite.modules.omegaplus.settings;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Service("bsa030ukrvService")
public class Bsa030ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 *  조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bsa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("bsa030ukrvServiceImpl.selectList", param);
		return rv;
	}

	/**
	 *  입력
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bsa")
	public List<Map>  insert(List<Map> paramList, LoginVO user) throws Exception {

		for(Map param :paramList )	{
				super.commonDao.insert("bsa030ukrvServiceImpl.insert", param);
		}
		return  paramList;
	}
	
	
	
	/**
	 * 수정
	 * @param paramList
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa")
	public List<Map>  update(List<Map> paramList,  LoginVO user) throws Exception {

		
		for(Map param :paramList )	{
		
			
			super.commonDao.update("bsa030ukrvServiceImpl.update", param);
			
		}

		return  paramList;
	}
	
	/**
	 * 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bsa")
	public List<Map>  delete(List<Map> paramList,  LoginVO user) throws Exception {


		
		
		for(Map param :paramList )	{				
				super.commonDao.update("bsa030ukrvServiceImpl.delete", param);

				
		}

		return  paramList;	
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "bsa")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		boolean error = false;
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insert")) {
					if("UNILITE5".equals(user.getUserID().toUpperCase()) || "OMEGA+".equals(user.getUserID().toUpperCase()))	{
						param.put("data", insert(dataList, user) );	
					} else {
						error = true;
					}
				} else if(param.get("method").equals("update")) {
					param.put("data", update(dataList, user) );	
				} else if(param.get("method").equals("delete")) {
					if("UNILITE5".equals(user.getUserID().toUpperCase())  || "OMEGA+".equals(user.getUserID().toUpperCase()))	{
						param.put("data", delete(dataList, user) );	
					} else {
						error = true;
					}
				}
			}
		}
		if(error)	{
			throw new  UniDirectValidateException("Fail : Only administrators can insert and update data.");	
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	/**
	 *  파일생성
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "bsa")
	public List<Map<String, Object>>  selectFiles(Map param) throws Exception {

		List<Map<String, Object>> rv =   super.commonDao.list("bsa030ukrvServiceImpl.selectFile", param);
		return rv;
	}
	
}
