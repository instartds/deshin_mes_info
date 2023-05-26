package foren.unilite.modules.accnt.afc;

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



@Service("afc100ukrService")
public class Afc100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("afc100ukrServiceImpl.selectList", param);
	}	

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
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
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user, paramMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		return 0;
	}	
	
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		 for(Map param :paramList )	{
			 param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
			 
			 Object SM = dataMaster.get("START_MONTH");
			 String choiceYear = SM.toString().substring(0,4);
			 String choiceMonth = SM.toString().substring(4,6);	
			 String choice1 = (Long.parseLong(choiceYear)-4) + choiceMonth;
			 String choice2 = (Long.parseLong(choiceYear)-3) + choiceMonth;
			 String choice3 = (Long.parseLong(choiceYear)-2) + choiceMonth;
			 String choice4 = (Long.parseLong(choiceYear)-1) + choiceMonth;
			 
			 if(param.get("JAN_DIVI").equals("1")){
				 
				 param.put("DR_AMT_I", param.get("AMT_I1")); 
				 param.put("AC_YYYY", choice1);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("DR_AMT_I", param.get("AMT_I2")); 
				 param.put("AC_YYYY", choice2);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("DR_AMT_I", param.get("AMT_I3")); 
				 param.put("AC_YYYY", choice3);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("DR_AMT_I", param.get("AMT_I4")); 
				 param.put("AC_YYYY", choice4);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 
//				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
//				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 
			 }else{
				 
				 param.put("CR_AMT_I", param.get("AMT_I1")); 
				 param.put("AC_YYYY", choice1);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("CR_AMT_I", param.get("AMT_I2")); 
				 param.put("AC_YYYY", choice2);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("CR_AMT_I", param.get("AMT_I3"));
				 param.put("AC_YYYY", choice3);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 param.put("CR_AMT_I", param.get("AMT_I4"));
				 param.put("AC_YYYY", choice4);
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
				 super.commonDao.update("afc100ukrServiceImpl.insertDetail", param);
				 
				 
			 }
			 
			 
		 }		 
		 return 0;
	} 
	
	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("afc100ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
			 }
		 }
		 return 0;
	}
}
