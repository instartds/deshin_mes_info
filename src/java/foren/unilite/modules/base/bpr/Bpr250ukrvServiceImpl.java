package foren.unilite.modules.base.bpr;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bpr250ukrvService")
public class Bpr250ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private  TlabCodeService tlabCodeService ;
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 사업장별 품목정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		
		String findType = ObjUtils.getSafeString(param.get("FIND_TYPE"));
		if(!"".equals(findType))	{
			Map searchType = (Map) super.commonDao.select("bpr250ukrvService.selectSearchType", param); 
			if(!ObjUtils.isEmpty(searchType)) param.put("FIND_TYPE", searchType.get("REF_CODE1"));
		}
		return  super.commonDao.list("bpr250ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map<String, Object> rMap;
//		
//		if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM")))	{
//			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", dataMaster);
//			dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
//		}else {
//			super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
//		}		
		if(paramList != null)	{
//			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}/*else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");}*/
				else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
//			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr250ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				//20210608 추가: 수정번, 전표등록여부 확인로직 추가
				 if(!param.get("ITEM_ACCOUNT_ORG").toString().equals(param.get("ITEM_ACCOUNT").toString())){
					 logger.debug(param.get("ITEM_ACCOUNT_ORG") + "===============ITEM_ACCOUNT different=========" + param.get("ITEM_ACCOUNT"));
					 List chkExnum = (List) super.commonDao.list("bpr250ukrvService.checkExnum", param);
					 if(chkExnum.size() > 0)	{
						 throw new UniDirectValidateException(this.getMessage("54736", user)); //  '해당품목의 결의전표정보가 존재합니다. 품목계정정보를 변경할 수 없습니다.
					 }
				 }

				 Map chkItemMap = (Map) super.commonDao.select("bpr250ukrvService.checkItemCode", param);
				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
					 super.commonDao.insert("bpr250ukrvService.update", param);
				 }else {
					 super.commonDao.update("bpr250ukrvService.insert", param);
				 }
					 				
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		try{
		 for(Map param :paramList )	{
			param.put("COMP_CODE", user.getCompCode());	
			//20210608 추가: 삭제전, BOM 등록여부 확인로직 추가
			List chkChildList = (List) super.commonDao.list("bpr250ukrvService.checkChildCode", param);
			
			if (chkChildList.size() > 0) {
				throw new UniDirectValidateException(this.getMessage("547",user)+ "[품목코드:"+ ObjUtils.getSafeString(param.get("ITEM_CODE"))+ "]");
			} else {
			
					super.commonDao.delete("bpr250ukrvService.delete", param);	
			}
			
		 }
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("547", user));
		}
		return 0;	
	}
	
	
	

	
	@ExtDirectMethod(group = "base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	

}
