package foren.unilite.modules.accnt.ass;

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
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("ass500ukrService")
public class Ass500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("ass500ukrService.selectMasterList", param);
	}	
	
	/**
	 * 
	  * detail1 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1(Map param) throws Exception {
		return super.commonDao.list("ass500ukrService.selectDetailList1", param);
	}	
	
	/**
	 * 
	  * detail2 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("ass500ukrService.selectDetailList2", param);
	}
	
	/**
	 * 
	  * detail3 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("ass500ukrService.selectDetailList3", param);
	}

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> detailInsertList1 = null;
			List<Map> detailUpdateList1 = null;
			List<Map> detailDeleteList1 = null;
			List<Map> detailInsertList2 = null;
			List<Map> detailUpdateList2 = null;
			List<Map> detailDeleteList2 = null;
			List<Map> detailInsertList3 = null;
			List<Map> detailUpdateList3 = null;
			List<Map> detailDeleteList3 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail1")) {
					detailInsertList1 = (List<Map>)dataListMap.get("data");				
				}else if(dataListMap.get("method").equals("updateDetail1")) {
					detailUpdateList1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail1")) {
					detailDeleteList1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					detailInsertList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {		
					detailUpdateList2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail2")) {
					detailDeleteList2 = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("insertDetail3")) {
					detailInsertList3 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail3")) {		
					detailUpdateList3 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail3")) {
					detailDeleteList3 = (List<Map>)dataListMap.get("data");	
				}
			}		
			if(detailDeleteList1 != null) this.deleteDetail1(detailDeleteList1, user);
			if(detailInsertList1 != null) this.insertDetail1(detailInsertList1, user);
			if(detailUpdateList1 != null) this.updateDetail1(detailUpdateList1, user);
			if(detailDeleteList2 != null) this.deleteDetail2(detailDeleteList2, user);
			if(detailInsertList2 != null) this.insertDetail2(detailInsertList2, user);
			if(detailUpdateList2 != null) this.updateDetail2(detailUpdateList2, user);
			if(detailDeleteList3 != null) this.deleteDetail3(detailDeleteList3, user);
			if(detailInsertList3 != null) this.insertDetail3(detailInsertList3, user);
			if(detailUpdateList3 != null) this.updateDetail3(detailUpdateList3, user);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * detail1 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("ass500ukrService.updateDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 }		
		return 0;
	}	
	
	/**
	 * detail1 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("SAVE_FLAG", "U");
			 Map err = (Map) super.commonDao.select("ass500ukrService.updateDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 } 
		 return 0;
	} 
	
	/**
	 * detail1 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("ass500ukrService.deleteDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 }
		 return 0;
	}
	
	/**
	 * detail2 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("ass500ukrService.updateDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 }		
		return 0;
	}	
	
	/**
	 * detail2 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("ass500ukrService.updateDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 }		 
		 return 0;
	} 
	
	/**
	 * detail2 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{
			 Map err = (Map) super.commonDao.select("ass500ukrService.deleteDetail1", param);
			 if(!ObjUtils.isEmpty(err.get("ERROR_DESC"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_DESC"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user) + "\n" + messsage[1]);					
			 }
		 }
		 return 0;
	}
	
	/**
	 * detail3 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("ass500ukrService.insertDetail3", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	/**
	 * detail3 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		 for(Map param :paramList )	{
			 super.commonDao.update("ass500ukrService.updateDetail3", param);
		 }		 
		 return 0;
	} 
	
	/**
	 * detail3 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("ass500ukrService.deleteDetail3", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
			 }
		 }
		 return 0;
	}
	
}
