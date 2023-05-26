package foren.unilite.modules.accnt.aiss;

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



@Service("aiss500ukrvService")
public class Aiss500ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	/**
	 * DetailGrid6 - 분할
	 * 분할실행
	 * @param param
	 * @return 
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnAiss500Proc(Map param, LoginVO user) throws Exception {

		 Map err = (Map) super.commonDao.select("aiss500ukrvService.fnAiss500Proc", param);
		 if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
			String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
			
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
		 }else{ 
			 return super.commonDao.list("aiss500ukrvService.selectDetailList6", param);
		 }
	}	
	
	/**
	 * DetailGrid6 - 분할
	 * 분할취소
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnAiss500Canc(Map param, LoginVO user) throws Exception {
		
		Map err = (Map) super.commonDao.select("aiss500ukrvService.fnAiss500Canc", param);
		 if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
			String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
			
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
		 }else{ 
			 return super.commonDao.list("aiss500ukrvService.selectDetailList6", param);
		 }
	}	
	
	/**
	 * 자산변동내역등록
	 * Master 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectMasterList", param);
	}	
	
	
	
	/**
	 * 자본적지출내역 조회
	 * detail1 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList1(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList1", param);
	}	
	
	/**
	 * 매각/폐기내역 조회
	 * detail2 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList2", param);
	}
	
	/**
	 * 내용년수변경내역 조회
	 * detail3 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList3", param);
	}
	
	
	/**
	 * 상각방법변경내역 조회
	 * detail4 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList4", param);
	}
	
	
	/**
	 * 이동내역 조회
	 * detail5 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList5", param);
	}
	
	/**
	 * 분할내역 조회
	 * detail6 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList6(Map param) throws Exception {
		return super.commonDao.list("aiss500ukrvService.selectDetailList6", param);
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
			List<Map> detailInsertList4 = null;
			List<Map> detailUpdateList4 = null;
			List<Map> detailDeleteList4 = null;
			List<Map> detailInsertList5 = null;
			List<Map> detailUpdateList5 = null;
			List<Map> detailDeleteList5 = null;
			List<Map> detailInsertList6 = null;
			List<Map> detailUpdateList6 = null;
			List<Map> detailDeleteList6 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail1")) {
					detailInsertList1 = (List<Map>)dataListMap.get("data");				
				}else if(dataListMap.get("method").equals("updateDetail1")) {
					detailUpdateList1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					detailInsertList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {		
					detailUpdateList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList2 = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("insertDetail3")) {
					detailInsertList3 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail3")) {		
					detailUpdateList3 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList3 = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("insertDetail4")) {
					detailInsertList4 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail4")) {		
					detailUpdateList4 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList4 = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("insertDetail5")) {
					detailInsertList5 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail5")) {		
					detailUpdateList5 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList5 = (List<Map>)dataListMap.get("data");	
				}else if(dataListMap.get("method").equals("insertDetail6")) {
					detailInsertList6 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail6")) {		
					detailUpdateList6 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail")) {
					detailDeleteList6 = (List<Map>)dataListMap.get("data");	
				}
			}		
			if(detailDeleteList1 != null) this.deleteDetail(detailDeleteList1, user);
			if(detailInsertList1 != null) this.insertDetail1(detailInsertList1, user);
			if(detailUpdateList1 != null) this.updateDetail1(detailUpdateList1, user);
			if(detailDeleteList2 != null) this.deleteDetail(detailDeleteList2, user);
			if(detailInsertList2 != null) this.insertDetail2(detailInsertList2, user);
			if(detailUpdateList2 != null) this.updateDetail2(detailUpdateList2, user);
			if(detailDeleteList3 != null) this.deleteDetail(detailDeleteList3, user);
			if(detailInsertList3 != null) this.insertDetail3(detailInsertList3, user);
			if(detailUpdateList3 != null) this.updateDetail3(detailUpdateList3, user);
			if(detailDeleteList4 != null) this.deleteDetail(detailDeleteList4, user);
			if(detailInsertList4 != null) this.insertDetail4(detailInsertList4, user);
			if(detailUpdateList4 != null) this.updateDetail4(detailUpdateList4, user);
			if(detailDeleteList5 != null) this.deleteDetail(detailDeleteList5, user);
			if(detailInsertList5 != null) this.insertDetail5(detailInsertList5, user);
			if(detailUpdateList5 != null) this.updateDetail5(detailUpdateList5, user);
			if(detailDeleteList6 != null) this.deleteDetail(detailDeleteList6, user);
			if(detailInsertList6 != null) this.insertDetail6(detailInsertList6, user);
			if(detailUpdateList6 != null) this.updateDetail6(detailUpdateList6, user);
			
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
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail1", param);				 
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
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail1", param);				 
			 }
		 } 
		 return 0;
	} 
	
	/**
	 * detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "D"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.delValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.deleteDetail", param);				 
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
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail2", param);				 
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
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail2", param);				 
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
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail3", param);				 
			 }
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
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail3", param);				 
			 }
		 }		 
		 return 0;
	} 

	/**
	 * detail4 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail4", param);				 
			 }
		 }		
		return 0;
	}	
	
	/**
	 * detail4 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail4", param);				 
			 }
		 }		 
		 return 0;
	} 

	/**
	 * detail5 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail5", param);				 
			 }
		 }		
		return 0;
	}	
	
	/**
	 * detail5 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail5", param);				 
			 }
		 }		 
		 return 0;
	} 

	
	/**
	 * detail6 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "N"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 param.put("SEQ", rtnData.get("SEQ"));
				 super.commonDao.update("aiss500ukrvService.insertDetail6", param);				 
			 }
		 }		
		return 0;
	}	
	
	/**
	 * detail6 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			 param.put("WORK_FLAG", "U"); 
			 Map rtnData = (Map) super.commonDao.select("aiss500ukrvService.checkValidator", param);
			 if(!ObjUtils.isEmpty(rtnData.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(rtnData.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));					
			 }else{
				 super.commonDao.update("aiss500ukrvService.updateDetail6", param);				 
			 }
		 }
		 return 0;
	} 

}
