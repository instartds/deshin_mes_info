package foren.unilite.modules.z_yp;

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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_pmr110ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_pmr110ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  생산수율 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		String findType = ObjUtils.getSafeString(param.get("FIND_TYPE"));
		if(!"".equals(findType))	{
			Map searchType = (Map) super.commonDao.select("bpr250ukrvService.selectSearchType", param); 
			if(!ObjUtils.isEmpty(searchType)) param.put("FIND_TYPE", searchType.get("REF_CODE1"));
		}
		if(param.get("TERM_FLAG").equals("2")){   //연도별 조회
		    return super.commonDao.list("s_pmr110ukrv_ypServiceImpl.selectList", param);
		}else{//기간별 조회
		    return super.commonDao.list("s_pmr110ukrv_ypServiceImpl.selectList2", param);
		}
		
	}
	
	
	/**
	 *  생산수율 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateList")) {		
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		/* 데이터 insert */
//		try {
//			for(Map param : paramList )	{	
//				super.commonDao.insert("aiss310ukrvServiceImpl.insertList", param);
//			}	
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("8114", user));
//		}
//		
		return 0;
	}	

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{
			super.commonDao.update("s_pmr110ukrv_ypServiceImpl.updateList", param);
			super.commonDao.update("s_pmr110ukrv_ypServiceImpl.updateList2", param);
		 }
		 return 0;
	} 
	
	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
//		 try {
//			 for(Map param :paramList )	{
//					super.commonDao.delete("aiss310ukrvServiceImpl.deleteList", param);
//					 
//			 }
//		 } catch(Exception e)	{
// 			throw new  UniDirectValidateException(this.getMessage("547",user));
//		 }	
		 return 0;
	}
}
