package foren.unilite.modules.accnt.atx;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("atx460ukrService")
public class Atx460ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 사업자단위과세사업장별부가가치세과세표
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		if(param.get("RE_REFERENCE").equals("Y")){
			return super.commonDao.list("atx460ukrServiceImpl.selectListSecond", param);
		}else{
			if(super.commonDao.list("atx460ukrServiceImpl.selectListFirst", param).isEmpty()){
				return super.commonDao.list("atx460ukrServiceImpl.selectListSecond", param);
			}else{
				return super.commonDao.list("atx460ukrServiceImpl.selectListFirst", param);
			}
		}
	}
	/**
	 * 재참조버튼 관련 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {	
		return  super.commonDao.list("atx460ukrServiceImpl.selectListFirst", param);
	}
	
	/**
	 * 리포트 데이터
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListToPrint(Map param, LoginVO user) throws Exception {	
		return  super.commonDao.list("atx460ukrServiceImpl.selectListToPrint", param);
	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user, paramMaster);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx460ukrServiceImpl.checkCompCode", compCodeMap);
			
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			if(dataMaster.get("RE_REFERENCE_SAVE").equals("Y")){
				super.commonDao.delete("atx460ukrServiceImpl.deleteDetailAll", dataMaster);
			}
			for(Map param : paramList )	{			 
//				 for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
//					 if(ObjUtils.parseInt(param.get("ITEM_P")) <= 0){
//						 throw new UniDirectValidateException("단가가 0보다 작거나 0과 같을수 없습니다");
//					 }else{
						 super.commonDao.update("atx460ukrServiceImpl.insertDetail", param);
//					 }
//					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx460ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				
					 super.commonDao.insert("atx460ukrServiceImpl.updateDetail", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx460ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("atx460ukrServiceImpl.deleteDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
//				 }
			 }
		 return 0;
	}
	
	
	
}
