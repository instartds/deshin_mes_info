package foren.unilite.modules.accnt.afb;

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



@Service("afb800ukrService")
public class Afb800ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 공통코드A171의 REFCODE관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectRefCode(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectRefCode", param);
	}
	/**
	 * 공공예산관련 옵션 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck1(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck1", param);
	}
	
	/**
	 * 수입결의 - 회계구분 기본값 설정 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck2(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck2", param);
	}
	
	/**
	 * 회계담당자
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck3(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck3", param);
	}
	
	/**
	 * 로그인사용자의 사번, 이름, 예산부서, 사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck4(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck4", param);
	}
	/**
	 * 수입결의_수정자ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck5(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck5", param);
	}
	/**
	 * 영수구분 기본값
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck6(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck6", param);
	}
	/**
	 * 계산서적요 기본값
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck7(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck7", param);
	}
	/**
	 * 결재상신 경로정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck8(Map param) throws Exception {
		return super.commonDao.select("afb800ukrServiceImpl.selectCheck8", param);
	}
	
	
	/**
	 * 마스터 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		
		return super.commonDao.list("afb800ukrServiceImpl.selectMaster", param);
		
	}
	/**
	 * 디테일 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		
		return super.commonDao.list("afb800ukrServiceImpl.selectDetail", param);
		
	}


	/**
	 * 입금내역 참조 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectDepositList(Map param) throws Exception {	
		
		return super.commonDao.list("afb800ukrServiceImpl.selectDepositList", param);
		
	}

	/**
	 * cancSlipStore(자동기표취소 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public List<Map<String, Object>>  cancSlip(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectCancSlip", param);
					errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  Exception(errorDesc);
					}else{
						return super.commonDao.list("afb800ukrServiceImpl.selectCancSlip", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectCancSlip", param);
				errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  Exception(errorDesc);
				}else{
					return super.commonDao.list("afb800ukrServiceImpl.selectCancSlip", param);
				}
			}
		}
	}
	/**
	 * autoSlipStore(수입결의자동기표 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public List<Map<String, Object>>  autoSlip(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectAutoSlip", param);
					errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  Exception(errorDesc);
					}else{
						return super.commonDao.list("afb800ukrServiceImpl.selectAutoSlip", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectAutoSlip", param);
				errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  Exception(errorDesc);
				}else{
					return super.commonDao.list("afb800ukrServiceImpl.selectAutoSlip", param);
				}
			}
		}
	}
	
	/**
	 * reAutoStore(재기표 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		
	public List<Map<String, Object>>  reAuto(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectReAuto1", param);
					errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  Exception(errorDesc);
					}else{
						String errorDesc2 ="";
						List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectReAuto2", param);
						errorDesc2 = (String) errCheck.get(0).get("ERROR_DESC");
						
						if(!ObjUtils.isEmpty(errorDesc2)){
							throw new  Exception(errorDesc2);
						}else{
							return super.commonDao.list("afb800ukrServiceImpl.selectReAuto2", param);
						}
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectReAuto1", param);
				errorDesc = (String) errCheck.get(0).get("ERROR_DESC");
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  Exception(errorDesc);
				}else{
					String errorDesc2 ="";
					List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb800ukrServiceImpl.selectReAuto2", param);
					errorDesc2 = (String) errCheck.get(0).get("ERROR_DESC");
					
					if(!ObjUtils.isEmpty(errorDesc2)){
						throw new  Exception(errorDesc2);
					}else{
						return super.commonDao.list("afb800ukrServiceImpl.selectReAuto2", param);
					}
				}
			}
		}
	}
	
	/**마스터만 저장시**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Afb800ukrModel param, LoginVO user, BindingResult result) throws Exception {


		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		param.setKEY_VALUE(keyValue);
		param.setCOMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setOPR_FLAG("U");
		

		super.commonDao.insert("afb800ukrServiceImpl.insertLogMaster", param);
		
		
	
		//4.수입결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());

		super.commonDao.queryForObject("spUspAccntAfb800ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		
		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
		    throw new  Exception(errorDesc/*this.getMessage(messsage[0], user)*/);
		} 
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 수입결의등록(SP)-> 저장
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

		//2.수입결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("IN_DRAFT_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("afb800ukrServiceImpl.insertLogMaster", dataMaster);
		
		//3.수입결의등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
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

		//4.수입결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		
		super.commonDao.queryForObject("spUspAccntAfb800ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String inDraftNo = ObjUtils.getSafeString(spParam.get("InDraftNo"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("IN_DRAFT_NO", "");
//			String[] messsage = errorDesc.split(";");
		    throw new  Exception(errorDesc/*this.getMessage(messsage[0], user)*/);
		} else {
			//마스터에 SET
			dataMaster.put("IN_DRAFT_NO", inDraftNo);
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("IN_DRAFT_NO", inDraftNo);
					}
				}
			}	
		}
		
		//5.수입결의마스터 정보 + 수입결의디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 수입결의등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("afb800ukrServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afb800ukrServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("afb800ukrServiceImpl.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("afb800ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Object afb800ukrDelA (Map spParam, LoginVO user) throws Exception {
		
		super.commonDao.queryForObject("spUspAccntAfb800ukrDelA", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  Exception(errorDesc);
		}else{
			return true;
		}
	}
}