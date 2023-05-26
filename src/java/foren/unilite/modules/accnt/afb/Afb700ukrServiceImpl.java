package foren.unilite.modules.accnt.afb;

import java.nio.charset.StandardCharsets;
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
import foren.unilite.modules.accnt.atx.Atx300ukrModel;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("afb700ukrService")
public class Afb700ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 공통코드A171의 REFCODE관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectRefCode(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectRefCode", param);
	}
	/**
	 * 공공예산관련 옵션 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck1(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck1", param);
	}
	
	/**
	 * 지출결의 - 회계구분 기본값 설정 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck2(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck2", param);
	}
	
	/**
	 * 회계담당자
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck3(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck3", param);
	}
	
	/**
	 * 로그인사용자의 사번, 이름, 예산부서, 사업장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck4(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck4", param);
	}
	/**
	 * 지출결의_수정자ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck5(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck5", param);
	}
	/**
	 * 세부업부적요 default값
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck6(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck6", param);
	}
	/**
	 * 지급명세서참조 Link PGM ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck7(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck7", param);
	}
	/**
	 * 결재상신 경로정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck8(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck8", param);
	}
	
	/**
	 * 세부구분항목 명칭 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck9(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck9", param);
	}
	
	/**
	 * 지출결의_승인버튼 사용자ID
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectCheck10(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectCheck10", param);
	}
	
	
	/**
	 * 지출결의 결제방법 BC일 때 통장정보 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectDeposit(Map param) throws Exception {
		return super.commonDao.select("afb700ukrServiceImpl.selectDeposit", param);
	}
	
	
	
	
	
	/**
	 * 마스터 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectMaster", param);
		
	}
	/**
	 * 디테일 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectDetail", param);
		
	}
	/**
	 * 예산코드 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectMainRef(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectMainRef", param);
		
	}
	
	/**
	 * 법인카드승인 참조 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectCorporationCardList(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectCorporationCardList", param);
		
	}
	/**
	 * 예산기안(추산) 참조 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectDraftNoList(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectDraftNoList", param);
		
	}
	/**
	 * 지급명세서 참조 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectPayDtlNoList(Map param) throws Exception {	
		
		return super.commonDao.list("afb700ukrServiceImpl.selectPayDtlNoList", param);
		
	}
	
	/**
	 * 급여공제 마스터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	
	public List<Map<String, Object>>  selectDedAmtMasterList(Map param) throws Exception {
		
		String sExistYN = "";
		String sQueryFlag = "";
		
		if(super.commonDao.list("afb700ukrServiceImpl.selectDedAmtCheckList", param).equals("")){
			sExistYN = "N";
		}else{
			sExistYN = "Y";
		}
	
//		sQueryFlag = (String) param.get("HDD_QUERY_FLAG");
		
		if(sExistYN.equals("Y")){
			param.put("sExistYN", sExistYN);
			return super.commonDao.list("afb700ukrServiceImpl.selectDedAmtMasterList", param);
		}else{
//		List<Map> dataCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectDedAmtCheckList", param);
			return null;//에러 뱉어 줘야하나 확인필요
		}
		
	}
	/**
	 * 급여공제 디테일 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	
	public List<Map<String, Object>>  selectDedAmtDetailList(Map param) throws Exception {	
		
		String sExistYN = "";
		String sQueryFlag = "";
		
		if(super.commonDao.list("afb700ukrServiceImpl.selectDedAmtCheckList", param).isEmpty()){
			sExistYN = "N";
		}else{
			sExistYN = "Y";
		}
		sQueryFlag = (String) param.get("HDD_QUERY_FLAG");
		
		if(sExistYN.equals("N") || sQueryFlag.equals("Y")){
			return super.commonDao.list("afb700ukrServiceImpl.selectDedAmtDetailList1", param);
		}else{
			return super.commonDao.list("afb700ukrServiceImpl.selectDedAmtDetailList2", param);
		}
		
	}
	
	
	/** 급여공제 저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveDedAmt(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDedAmtDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDedAmtDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDedAmtDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDedAmtDetail(deleteList, user, paramMaster);
			if(insertList != null) this.insertDedAmtDetail(insertList, user);
			if(updateList != null) this.updateDedAmtDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDedAmtDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afb700ukrServiceImpl.insertDedAmtDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDedAmtDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("afb700ukrServiceImpl.updateDedAmtDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDedAmtDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		String errorCode ="";
		List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.beforeDeleteCheckDedAmtDetail", dataMaster);
		errorCode = (String) errCheck.get(0).get("ERROR_CODE");
		
		if(!ObjUtils.isEmpty(errorCode)){
			throw new  UniDirectValidateException(this.getMessage(errorCode, user));
		}else{
			super.commonDao.list("afb700ukrServiceImpl.deleteDedAmtDetail", dataMaster);
		}
		
		return 0;
		
		
		
//		 for(Map param :paramList )	{
//			 try {
//				 super.commonDao.delete("afb700ukrServiceImpl.deleteDedAmtDetail", param);
//			 }catch(Exception e)	{
//	    			throw new  UniDirectValidateException(this.getMessage("547",user));
//	    	}	
//		 }
//		 return 0;
	}

	/**
	 * cancSlipStore(자동기표취소 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
	public List<Map<String, Object>>  cancSlip(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectCancSlip", param);
					errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
					}else{
						return super.commonDao.list("afb700ukrServiceImpl.selectCancSlip", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectCancSlip", param);
				errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				}else{
					return super.commonDao.list("afb700ukrServiceImpl.selectCancSlip", param);
				}
			}
		}
	}
	/**
	 * autoSlipStore(지출결의자동기표 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={UniDirectValidateException.class})
	public List<Map<String, Object>>  autoSlip(Map param, LoginVO user) throws Exception {
		
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAutoSlip", param);
					errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
					}else{
						return super.commonDao.list("afb700ukrServiceImpl.selectAutoSlip", param);
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAutoSlip", param);
				errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				}else{
					return super.commonDao.list("afb700ukrServiceImpl.selectAutoSlip", param);
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
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map<String, Object>>  reAuto(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReAuto1", param);
					errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
					}else{
						String errorDesc2 ="";
						List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReAuto2", param);
						errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
						
						if(!ObjUtils.isEmpty(errorDesc2)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
						}else{
							return super.commonDao.list("afb700ukrServiceImpl.selectReAuto2", param);
						}
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReAuto1", param);
				errorDesc = ObjUtils.getSafeString(errCheck.get(0).get("ERROR_DESC"));
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				}else{
					String errorDesc2 ="";
					List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReAuto2", param);
					errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc2)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
					}else{
						return super.commonDao.list("afb700ukrServiceImpl.selectReAuto2", param);
					}
				}
			}
		}
	}
	
	/**
	 * reCancelStore(임의반려 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map<String, Object>>  reCancel(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.fnCheckPassword", param);
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
//					String errorCode1 ="";
					String errorDesc1 ="";
					List<Map> errCheck1 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReCancel1", param);
//					errorCode1 = (String) errCheck1.get(0).get("ERROR_CODE");
					errorDesc1 = ObjUtils.getSafeString(errCheck1.get(0).get("ERROR_DESC"));
					if(!ObjUtils.isEmpty(errorDesc1)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
					}else{
						super.commonDao.list("afb700ukrServiceImpl.selectReCancel1", param);
						
//						String errorCode2 ="";
						String errorDesc2 ="";
						List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReCancel2", param);
//						errorCode2 = (String) errCheck2.get(0).get("ERROR_CODE");
						errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
						if(!ObjUtils.isEmpty(errorDesc2)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
						}else{
							return super.commonDao.list("afb700ukrServiceImpl.selectReCancel2", param);
						}
					}
				}
			}else{
//				String errorCode1 ="";
				String errorDesc1 ="";
				List<Map> errCheck1 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReCancel1", param);
//				errorCode1 = (String) errCheck1.get(0).get("ERROR_CODE");
				errorDesc1 = ObjUtils.getSafeString(errCheck1.get(0).get("ERROR_DESC"));
				
				if(!ObjUtils.isEmpty(errorDesc1)){
					throw new  UniDirectValidateException(this.getMessage(errorDesc1, user));
				}else{
					super.commonDao.list("afb700ukrServiceImpl.selectReCancel1", param);
					
//					String errorCode2 ="";
					String errorDesc2 ="";
					List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectReCancel2", param);
//					errorCode2 = (String) errCheck2.get(0).get("ERROR_CODE");
					errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc2)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
					}else{
						return super.commonDao.list("afb700ukrServiceImpl.selectReCancel2", param);
					}
				}
			}
		}
	}
	
	/**
	 * appProStore(지출승인 관련)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")	
//	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map<String, Object>>  appPro(Map param, LoginVO user) throws Exception {	
		List<Map> passCheck = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.fnCheckPassword", param);
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
					List<Map> errCheck1 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAppPro1", param);
					errorDesc = ObjUtils.getSafeString(errCheck1.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
					}else{
						super.commonDao.list("afb700ukrServiceImpl.selectAppPro1", param);
						
						String errorDesc2 ="";
						List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAppPro2", param);
						errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
						
						if(!ObjUtils.isEmpty(errorDesc2)){
							throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
						}else{
							return super.commonDao.list("afb700ukrServiceImpl.selectAppPro2", param);
						}
					}
				}
			}else{
				String errorDesc ="";
				List<Map> errCheck1 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAppPro1", param);
				errorDesc = ObjUtils.getSafeString(errCheck1.get(0).get("ERROR_DESC"));
				
				if(!ObjUtils.isEmpty(errorDesc)){
					throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				}else{
					super.commonDao.list("afb700ukrServiceImpl.selectAppPro1", param);
					
					String errorDesc2 ="";
					List<Map> errCheck2 = (List<Map>) super.commonDao.list("afb700ukrServiceImpl.selectAppPro2", param);
					errorDesc2 = ObjUtils.getSafeString(errCheck2.get(0).get("ERROR_DESC"));
					
					if(!ObjUtils.isEmpty(errorDesc2)){
						throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
					}else{
						return super.commonDao.list("afb700ukrServiceImpl.selectAppPro2", param);
					}
				}
			}
		}
	}
	
	
	
	
	
	
	/**마스터만 저장시**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Afb700ukrModel param, LoginVO user, BindingResult result) throws Exception {


		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.지출결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

//		param.put("KEY_VALUE", keyValue);
//		param.put("COMP_CODE", user.getCompCode());
//		param.put("OPR_FLAG", "U");
		param.setKEY_VALUE(keyValue);
		param.setCOMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setOPR_FLAG("U");
		

		super.commonDao.insert("afb700ukrServiceImpl.insertLogMaster", param);
		
		
		
		//4.지출결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());

		super.commonDao.queryForObject("spUspAccntAfb700ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		
		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} 
		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 지출결의등록(SP)-> 저장
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

		//2.지출결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("PAY_DRAFT_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("afb700ukrServiceImpl.insertLogMaster", dataMaster);
		
		//3.지출결의등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
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

		//4.지출결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		
		super.commonDao.queryForObject("spUspAccntAfb700ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String payDraftNo = ObjUtils.getSafeString(spParam.get("PayDraftNo"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("PAY_DRAFT_NO", "");
//			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//마스터에 SET
			dataMaster.put("PAY_DRAFT_NO", payDraftNo);
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("PAY_DRAFT_NO", payDraftNo);
					}
				}
			}	
		}
		
		//5.지출결의마스터 정보 + 지출결의디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 지출결의등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("afb700ukrServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("afb700ukrServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("afb700ukrServiceImpl.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("afb700ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object afb700ukrDelA (Map spParam, LoginVO user) throws Exception {
		
//		spParam.put("CompCode", user.getCompCode());  
//		spParam.put("LangCode", user.getLanguage());
		
		
		String encryptPass = "";
		String decryptPass = "";
		List temp1 = new ArrayList();
		List temp2 = new ArrayList();
		
		encryptPass = (String) spParam.get("PASSWORD");	// 암호화된 패스워드
		
		int textSize = encryptPass.length();
		
		for (int i = 0; i < textSize; i++){
			
			int encryptInt1 = 0;
			int encryptInt2 = 0;
			String encryptStr = encryptPass;
			encryptInt1 = encryptStr.charAt(i);
			temp1.add(i, Integer.toString(encryptInt1));
			
			if((i + 1) < textSize){
				encryptInt2 = encryptStr.charAt(i + 1);
				temp2.add(i, Integer.toString(encryptInt2));
			}
		}
		for (int i = 0; i < textSize; i = i+2) {
			int t1 = 0;
			int t2 = 0;
			int sumt3 = 0;
			t1 = Integer.parseInt((String) temp1.get(i));
			t2 = Integer.parseInt((String) temp2.get(i));
			
			sumt3 = t1 - t2;
			char tempC = (char) sumt3;
			decryptPass += tempC;

		}
		spParam.put("PASSWORD", decryptPass);	//복호화된 패스워드
		
		super.commonDao.queryForObject("spUspAccntAfb700ukrDelA", spParam);
//		super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return true;
		}
	}
	
}