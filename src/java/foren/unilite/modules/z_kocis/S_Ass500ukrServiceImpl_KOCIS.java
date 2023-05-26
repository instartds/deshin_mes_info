package foren.unilite.modules.z_kocis;

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



@Service("s_ass500ukrService_KOCIS")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Ass500ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
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
		return super.commonDao.list("s_ass500ukrServiceImpl_KOCIS.selectMasterList", param);
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
		return super.commonDao.list("s_ass500ukrServiceImpl_KOCIS.selectDetailList1", param);
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
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail1")) {
					detailInsertList1 = (List<Map>)dataListMap.get("data");	
					
				}else if(dataListMap.get("method").equals("updateDetail1")) {
					detailUpdateList1 = (List<Map>)dataListMap.get("data");
					
				}else if(dataListMap.get("method").equals("deleteDetail1")) {
					detailDeleteList1 = (List<Map>)dataListMap.get("data");
				}
			}		
			if(detailDeleteList1 != null) this.deleteDetail1(detailDeleteList1, user);
			if(detailInsertList1 != null) this.insertDetail1(detailInsertList1, user);
			if(detailUpdateList1 != null) this.updateDetail1(detailUpdateList1, user);
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
		for(Map param : paramList )	{	
			Map checkData = (Map) super.commonDao.select("s_ass500ukrServiceImpl_KOCIS.beforeInsertCheck", param);
			if(ObjUtils.parseInt(checkData.get("EXIST_YN")) != 0) {
				String error =  param.get("ASST_NAME") + "(" + param.get("ASST") + ")에 대한 처분내역이 이미 등록 되었습니다.";
			    throw new  UniDirectValidateException(this.getMessage(error, user));		
			    
			} else {
				super.commonDao.insert("s_ass500ukrServiceImpl_KOCIS.insertDetail1", param);
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
			 super.commonDao.select("s_ass500ukrServiceImpl_KOCIS.updateDetail1", param);
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
			 try {
				super.commonDao.delete("s_ass500ukrServiceImpl_KOCIS.deleteDetail1", param);
				 
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
}
