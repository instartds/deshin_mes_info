package foren.unilite.modules.human.hbo;
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
import foren.unilite.modules.human.hpa.Hpa330ukrModel;


@Service("hbo220ukrService")
public class Hbo220ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 지급내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList1", param);
		//월지급내역등록 테이블(HPA300)에 데이터가 없을 경우, HBS300T에서 보여준다.
		if(ObjUtils.isEmpty(rv)){
			rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList1_1", param);
		}
		return rv;
	}
	
	/**
	 * 공제내역  조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2", param);
		//월지급내역등록 테이블(HPA300)에 데이터가 없을 경우, HBS300T에서 보여준다.
		if (ObjUtils.isEmpty(rv)) {
			rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2_1", param);
		}
		return rv;
	}
	
	/**
	 * 폼 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hpa")
	public  Map<String, Object> selectList3(Map param) throws Exception {
		 
		Map<String, Object> rv = (Map<String, Object>)super.commonDao.select("hbo220ukrServiceImpl.selectList3", param);
		if (ObjUtils.isEmpty(rv)) {
			rv = (Map<String, Object>)super.commonDao.select("hbo220ukrServiceImpl.getHumanMaster", param);
			//최초 조회값이 없어서 getHumanMaster 호출했을 때는 BONUS_STD_I가 ''이 들어가야 하고 삭제버튼 비활성화, 해당 로직을 위한 flag
			rv.put("ENABLE_DELETE_YN", (Boolean) false);

		} else {
			rv.put("ENABLE_DELETE_YN", (Boolean) true);

		}
		return rv;
	}
	
	/**
	 * 업데이트가 가능한지 확인 마감, 전표
	 * @param param
	 * @return
	 */
	public String checkUpdateAvailable(Map param) {
		String result = super.commonDao.queryForObject("hbo220ukrServiceImpl.checkUpdateAvailable", param).toString();
		return result;
	}
	
	/**
	 * 결과폼1 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hbs")
	public ExtDirectFormPostResult form01Submit(Hpa330ukrModel param, LoginVO loginVO, BindingResult result) throws Exception {
		param.setS_COMP_CODE(loginVO.getCompCode());
		param.setS_USER_ID(loginVO.getUserID());
		super.commonDao.update("hbo220ukrServiceImpl.form01update", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}

	/**
	 * Navi button 사용가능 여부 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "human")
	public List<Map<String, Object>> checkAvailableNavi(Map param) throws Exception {
		return (List) super.commonDao.list("hbo220ukrServiceImpl.getPrNxPersonNumb", param);
	}
	
	/**saveAll
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
//			List<Map> insertList = null;
			List<Map> updateList = null;
//			List<Map> deleteList = null;
		
			//저장하는 버튼에 따라 다른 로직 구현
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

				String checkCloseYn =  (String) super.commonDao.select("hbo220ukrServiceImpl.checkCloseYn", dataMaster);				//마감 여부 확인
			
				if (ObjUtils.isEmpty(checkCloseYn)) {																						//마감정보가 없을 때,
					//작업 이 INSERT 또는 UPDATE일 때
					if (dataMaster.get("GSRETRIEVED").equals("N") || dataMaster.get("GSRETRIEVED").equals("U")){
						String checkExCloseYn = (String) super.commonDao.select("hbo220ukrServiceImpl.checkExCloseYn", dataMaster);	//전표마감 여부 확인
						
						if (ObjUtils.isEmpty(checkExCloseYn)) {																				//전표마감 정보가 없을 때,
							Map checkPayGubun = (Map) super.commonDao.select("hbo220ukrServiceImpl.checkPayGubun", dataMaster);				//HPA600T에 PAY_GUBUN 정보 확인
							
							if (ObjUtils.isEmpty(checkPayGubun)) {																			//HPA600T에 PAY_GUBUN 정보가 없을 때는 INSERT(HUM100T의 PAY_GUBUN, PAY_GUBUN2 사용)
								Map checkPayGubun2 = (Map) super.commonDao.select("hbo220ukrServiceImpl.checkPayGubun2", dataMaster);
								//checkPayGubun2의 PAY_GUBUN, PAY_GUBUN2의 값을 추가하여 INSERT 실행
								dataMaster.put("PAY_GUBUN",		checkPayGubun2.get("PAY_GUBUN"));
								dataMaster.put("PAY_GUBUN2",	checkPayGubun2.get("PAY_GUBUN2"));
								
								//this.insertList(updateList, dataMaster, user);
								for(Map dataListMap: paramList) {
									updateList =  (List<Map>) dataListMap.get("data");	
									this.insertList(updateList, dataMaster, user);
								}	

							} else {																										//HPA600T에 PAY_GUBUN 정보가 있을 때는 UPDATE(조회된 PAY_GUBUN, PAY_GUBUN2 사용)	
								//checkPayGubun의 PAY_GUBUN, PAY_GUBUN2의 값을 추가하여 UPDATE 실행
								dataMaster.put("PAY_GUBUN",		checkPayGubun.get("PAY_GUBUN"));
								dataMaster.put("PAY_GUBUN2",	checkPayGubun.get("PAY_GUBUN2"));
								
								//this.updateList(updateList, dataMaster, user);
								for(Map dataListMap: paramList) {
									updateList =  (List<Map>) dataListMap.get("data");	
									this.updateList(updateList, dataMaster, user);
								}	
							}
						} else {
//							paramList = checkExCloseYn;
//						 	return  paramList;
							throw new UniDirectValidateException(this.getMessage(checkExCloseYn, user));
						}
						
					//DELETE일 때							
					} else
						if (dataMaster.get("GSRETRIEVED").equals("D")){
							this.deleteList(updateList, dataMaster, user);
						} 
				} else {
					throw new UniDirectValidateException(this.getMessage(checkCloseYn, user));
				}

				
				//상여 호출
				if (dataMaster.get("rdoHireYn") == "Y") {
					//고용보험 재계산이 'Y'이면, UHpa03Krv.CHireInsur의 fnHireInsur 호출 - fnHireInsur(oDal, "", bParam(0), bParam(12), "", "", "00000000", bParam(11), "", "", "Y", bParam(15))
//					Map fnHireInsur = (Map) super.commonDao.select("hbo220ukrServiceImpl.fnHireInsur", dataMaster);				

				}
				//상여 호출
				if (dataMaster.get("rdoTaxYn") == "Y") {
					//세액 재계산이 'Y'이면, UHbo02Krv.CHbo210UKr의 fnGetBonusTax 호출 - fnGetBonusTax(oDal, "INC", GParam, KK)
//					Map fnGetBonusTax = (Map) super.commonDao.select("hbo220ukrServiceImpl.fnGetBonusTax", dataMaster);				

				}
				//UHpa03Krv.CLastCalcu의 fnLastCalcu 호출 - fnLastCalcu(oDal, "", bParam(0), bParam(12), "", "", "00000000", bParam(11), "", "", bParam(15))
//				Map fnLastCalcu = (Map) super.commonDao.select("hbo220ukrServiceImpl.fnLastCalcu", dataMaster);		


		}
			
	 	paramList.add(0, paramMaster);
	 	return  paramList;
	}
	
	
	/**
	 *수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public Integer updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//HPA600T에 데이터 UPDATE
		super.commonDao.update("hbo220ukrServiceImpl.updateList", paramMaster);
			
		//paramDetail 처리하는 로직 필요
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2", paramMaster);
		//월지급내역등록 테이블(HPA300)에 데이터가 없을 경우, HBS300T에서 보여준다.
		if (ObjUtils.isEmpty(rv)) {
			rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2_1", paramMaster);
		}
		for(Map dataListMap: paramList){
			for(Map param2 : rv){
				HashMap insertData2 = new HashMap<>();
				logger.debug("{TEAT}"+ dataListMap);
				logger.debug("{TEAT1}"+ param2);
				if(ObjUtils.isNotEmpty(dataListMap.get("DED_CODE"))){
					if (dataListMap.get("DED_CODE").equals(param2.get("DED_CODE")) ) {
						
						insertData2.put("PAY_YYYYMM",	paramMaster.get("PAY_YYYYMM"));
						insertData2.put("DED_AMOUNT_I",	dataListMap.get("DED_AMOUNT_I"));
						insertData2.put("SUPP_TYPE",	dataListMap.get("SUPP_TYPE"));
						insertData2.put("PERSON_NUMB",	dataListMap.get("PERSON_NUMB"));
						insertData2.put("DED_CODE",	dataListMap.get("DED_CODE"));
						insertData2.put("S_COMP_CODE",	dataListMap.get("S_COMP_CODE"));
						insertData2.put("UPDATE_DB_USER",	dataListMap.get("UPDATE_DB_USER"));
						
						super.commonDao.delete("hbo220ukrServiceImpl.deleteList2", insertData2);
						super.commonDao.insert("hbo220ukrServiceImpl.insertList3", insertData2);
					}
				}else{
					return 0;
				}
			}
		}
		return 0;
	}

	/**
	 *추가
	 */
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")		// INSERT
	public Integer insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
			try {
				//HPA600T에 데이터 입력
				super.commonDao.insert("hbo220ukrServiceImpl.insertList1", paramMaster);

				//paramDetail 처리하는 로직 필요
				List<Map<String, Object>> rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2", paramMaster);
				//월지급내역등록 테이블(HPA300)에 데이터가 없을 경우, HBS300T에서 보여준다.
				if (ObjUtils.isEmpty(rv)) {
					rv = (List)super.commonDao.list("hbo220ukrServiceImpl.selectList2_1", paramMaster);
				}
				for(Map param2 : rv){
					HashMap insertData2 = new HashMap<>(param2);
					super.commonDao.insert("hbo220ukrServiceImpl.insertList2", insertData2);
					super.commonDao.insert("hbo220ukrServiceImpl.insertList3", insertData2);
				}
				for(Map dataListMap: paramList){
					for(Map param2 : rv){
						HashMap insertData2 = new HashMap<>(param2);
						if (dataListMap.get("DED_CODE").equals(param2.get("DED_CODE")) ) {
//							insertData2.putAll(dataListMap);
							insertData2.put("PAY_YYYYMM",	paramMaster.get("PAY_YYYYMM"));
							insertData2.put("DED_AMOUNT_I",	dataListMap.get("DED_AMOUNT_I"));
							super.commonDao.insert("hbo220ukrServiceImpl.insertList2", insertData2);
							super.commonDao.insert("hbo220ukrServiceImpl.insertList3", insertData2);
						}
					}
				}

				
			} catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			return 0;
		}	
	 
	/**
	 *삭제
	 */
	//@ExtDirectMethod(group = "hbo", needsModificatinAuth = true)		// DELETE
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")		// DELETE
	public Integer deleteList(List<Map> paramList, Map paramMaster,  LoginVO user) throws Exception {
			super.commonDao.delete("hbo220ukrServiceImpl.deleteList", paramMaster);
		return 0;
	} 
//	List<Map<String, Object>> rv = super.commonDao.list("hbo220ukrServiceImpl.syncAll", param);
}
