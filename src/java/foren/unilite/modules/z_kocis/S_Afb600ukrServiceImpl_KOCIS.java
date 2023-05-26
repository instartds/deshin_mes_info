package foren.unilite.modules.z_kocis;

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



@Service("s_afb600ukrService_KOCIS")
public class S_Afb600ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 공통코드A171의 REFCODE관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectRefCode(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectRefCode", param);
	}
	/**
	 * 공공예산관련 옵션 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck1(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectCheck1", param);
	}
	/**
	 * 로그인사용자의 사번, 이름, 예산부서, 사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck2(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectCheck2", param);
	}
	/**
	 * 결재상신 경로정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck3(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectCheck3", param);
	}
	/**
	 * 예산기안_확정버튼 사용자ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck4(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectCheck4", param);
	}
	/**
	 * 지출결의_수정자ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck5(Map param) throws Exception {
		return super.commonDao.select("s_afb600ukrServiceImpl_KOCIS.selectCheck5", param);
	}
	
	/**
	 * 마스터 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 디테일조회
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectMaster", param);
		
	}
	/**
	 * 디테일 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 디테일조회
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectDetail", param);
		
	}
	/**
	 * afb600PossAmt 스토어
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// afb600PossAmt
	public List<Map<String, Object>>  posAmt(Map param, LoginVO user) throws Exception {
		String errorDesc ="";
		List<Map> errCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPosAmt", param);
			errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
			
			if(!ObjUtils.isEmpty(errorDesc)){
				throw new  Exception(errorDesc);
				/*String[] messsage = errorDesc.split(";");
				String A = messsage[0];
				int messLength = messsage.length;
				
				if(messLength > 1){
					String B = messsage[1];
						throw new  UniDirectValidateException(this.getMessage(A, user)+" : " + B);
				}else{
						throw new  UniDirectValidateException(this.getMessage(A, user));
					}*/
			}else{
				return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPosAmt", param);
			}
		
	}
	/**
	 * afb600pro1  스토어
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// afb600pro1
	public List<Map<String, Object>>  pro1(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.fnCheckPassword", param);
		if(passCheck.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("54220", user));
		}else{
			if(passCheck.get(0).get("CHECK_PASSWORD").equals("Y")){
				String passWord = "";
					passWord = (String) passCheck.get(0).get("REPRE_NUM");
				int passWordLength = passWord.length();
				String backPassWord ="";
					backPassWord = passWord.substring(passWordLength-7);
				String paramPassWord = "";
					paramPassWord = (String) param.get("PASSWORD");
				if(!backPassWord.equals(paramPassWord)){
					throw new  UniDirectValidateException(this.getMessage("55334", user));
					
				}else{
					String errorDesc ="";
					List<Map> errCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro1", param);
					errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  Exception(errorDesc);
					}else{
						return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro1", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro1", param);
				errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  Exception(errorDesc);
				}else{
					return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro1", param);
				}
			}
		}
	}
	/**
	 * afb600reCancel  스토어
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// afb600pro1
	public List<Map<String, Object>>  reCancel(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.fnCheckPassword", param);
		if(passCheck.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("54220", user));
		}else{
			if(passCheck.get(0).get("CHECK_PASSWORD").equals("Y")){
				String passWord = "";
					passWord = (String) passCheck.get(0).get("REPRE_NUM");
				int passWordLength = passWord.length();
				String backPassWord ="";
					backPassWord = passWord.substring(passWordLength-7);
				String paramPassWord = "";
					paramPassWord = (String) param.get("PASSWORD");
				if(!backPassWord.equals(paramPassWord)){
					throw new  UniDirectValidateException(this.getMessage("55334", user));
					
				}else{
					String errorDesc1 ="";
					List<Map> errCheck1 = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel1", param);
					errorDesc1 = (String) errCheck1.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc1)){
						throw new  Exception(errorDesc1);
					}else{
						super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel1", param);
						
						String errorDesc2 ="";
						List<Map> errCheck2 = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel2", param);
						errorDesc2 = (String) errCheck2.get(0).get("ERROR_DESC");
						
						if(!ObjUtils.isEmpty(errorDesc2)){
							throw new  Exception(errorDesc2);
						}else{
							return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel2", param);
						}
					}
				}
			}else{
				String errorDesc1 ="";
				List<Map> errCheck1 = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel1", param);
				errorDesc1 = (String) errCheck1.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc1)){
					throw new  Exception(errorDesc1);
				}else{
					super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel1", param);
					
					String errorDesc2 ="";
					List<Map> errCheck2 = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel2", param);
					errorDesc2 = (String) errCheck2.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc2)){
						throw new  Exception(errorDesc2);
					}else{
						return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectReCancel2", param);
					}
				}
			}
		}
	}
	/**
	 * afb600pro2  스토어
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// afb600pro1
	public List<Map<String, Object>>  pro2(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.fnCheckPassword", param);
		if(passCheck.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("54220", user));
		}else{
			if(passCheck.get(0).get("CHECK_PASSWORD").equals("Y")){
				String passWord = "";
					passWord = (String) passCheck.get(0).get("REPRE_NUM");
				int passWordLength = passWord.length();
				String backPassWord ="";
					backPassWord = passWord.substring(passWordLength-7);
				String paramPassWord = "";
				paramPassWord = (String) param.get("PASSWORD");
				if(!backPassWord.equals(paramPassWord)){
					throw new  UniDirectValidateException(this.getMessage("55334", user));
					
				}else{
					String errorDesc ="";
					List<Map> errCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro2", param);
					errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc)){
					    throw new UniDirectValidateException(this.getMessage(errorDesc, user));
					}else{
						return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro2", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro2", param);
				errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc)){
				    throw new UniDirectValidateException(this.getMessage(errorDesc, user));
				}else{
					return super.commonDao.list("s_afb600ukrServiceImpl_KOCIS.selectPro2", param);
				}
			}
		}
	}
	/**마스터만 저장시**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Afb600ukrModel_KOCIS param, LoginVO user, BindingResult result) throws Exception {


		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		param.setKEY_VALUE(keyValue);
		param.setCOMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setOPR_FLAG("U");
		

		super.commonDao.insert("s_afb600ukrServiceImpl_KOCIS.insertLogMaster", param);
		
		
		
		//4.예산기안(추산)등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());

		super.commonDao.queryForObject("spUspAccntAfb600ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
//		    throw new  Exception(errorDesc/*this.getMessage(messsage[0], user)*/);
		    throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} 
		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 예산기안(추산)등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.예산기안(추산)등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("DRAFT_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_afb600ukrServiceImpl_KOCIS.insertLogMaster", dataMaster);
		
		//3.예산기안(추산)등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		//4.예산기안(추산)등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		
		super.commonDao.queryForObject("spUspAccntAfb600ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String draftNo = ObjUtils.getSafeString(spParam.get("DraftNo"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("DRAFT_NO", "");
//			String[] messsage = errorDesc.split(";");
//		    throw new  Exception(errorDesc/*this.getMessage(messsage[0], user)*/);
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//마스터에 SET
			dataMaster.put("DRAFT_NO", draftNo);
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("DRAFT_NO", draftNo);
					}
				}
			}	
		}
		
		//5.예산기안(추산)마스터 정보 + 예산기안(추산)디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 예산기안(추산)등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("s_afb600ukrServiceImpl_KOCIS.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_afb600ukrServiceImpl_KOCIS.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("s_afb600ukrServiceImpl_KOCIS.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("s_afb600ukrServiceImpl_KOCIS.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Object afb600ukrDelA (Map spParam, LoginVO user) throws Exception {
		
		super.commonDao.queryForObject("spUspAccntAfb600ukrDelA", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  Exception(errorDesc);
		}else{
			return true;
		}
	}
	
}