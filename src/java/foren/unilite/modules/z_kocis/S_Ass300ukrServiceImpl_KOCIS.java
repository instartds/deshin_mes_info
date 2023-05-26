package foren.unilite.modules.z_kocis;

import java.util.HashMap;
import java.util.Map;

import javax.swing.Spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_ass300ukrService_KOCIS")
@SuppressWarnings("rawtypes")
public class S_Ass300ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  고정자산등록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.selectMaster", param);
	}
	
	
	/**
	 *  고정자산등록 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Ass300ukrModel_KOCIS dataMaster, LoginVO user,  BindingResult result) throws Exception {		
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("COMP_CODE"         , user.getCompCode()         );
		spParam.put("USER_ID"           , user.getUserID()           );
		spParam.put("ASST"              , dataMaster.getASST()              );
		spParam.put("ASST_NAME"         , dataMaster.getASST_NAME()         );
		spParam.put("SPEC"              , dataMaster.getSPEC()              );
		spParam.put("ACCNT"             , dataMaster.getACCNT()		        );
		spParam.put("DIV_CODE"          , dataMaster.getDIV_CODE()          );
		spParam.put("DEPT_CODE"         , dataMaster.getDEPT_CODE()         );
		spParam.put("DEPT_NAME"         , dataMaster.getDEPT_NAME()         );
		spParam.put("PJT_CODE"          , dataMaster.getPJT_CODE()          );
		spParam.put("DRB_YEAR"          , dataMaster.getDRB_YEAR()          );
		spParam.put("MONEY_UNIT"        , dataMaster.getMONEY_UNIT()        );
		spParam.put("EXCHG_RATE_O"      , dataMaster.getEXCHG_RATE_O()      );
		spParam.put("FOR_ACQ_AMT_I"     , dataMaster.getFOR_ACQ_AMT_I()     );
		spParam.put("ACQ_AMT_I"         , dataMaster.getACQ_AMT_I()         );
		spParam.put("ACQ_Q"             , dataMaster.getACQ_Q()             );
		spParam.put("STOCK_Q"           , dataMaster.getSTOCK_Q()           );
		spParam.put("QTY_UNIT"          , dataMaster.getQTY_UNIT()          );
		spParam.put("ACQ_DATE"          , dataMaster.getACQ_DATE()          );
		spParam.put("USE_DATE"          , dataMaster.getUSE_DATE()          );
		spParam.put("COST_POOL_CODE"    , dataMaster.getCOST_POOL_CODE()    );
		spParam.put("COST_DIRECT"       , dataMaster.getCOST_DIRECT()       );
		spParam.put("ITEM_LEVEL1"       , dataMaster.getITEM_LEVEL1()       );
		spParam.put("ITEM_LEVEL2"       , dataMaster.getITEM_LEVEL2()       );
		spParam.put("ITEM_LEVEL3"       , dataMaster.getITEM_LEVEL3()       );
		spParam.put("CUSTOM_CODE"       , dataMaster.getCUSTOM_CODE()       );
		spParam.put("CUSTOM_NAME"       , dataMaster.getCUSTOM_NAME()       );
		spParam.put("PERSON_NUMB"       , dataMaster.getPERSON_NUMB()       );
		spParam.put("PLACE_INFO"        , dataMaster.getPLACE_INFO()        );
		spParam.put("SERIAL_NO"         , dataMaster.getSERIAL_NO()         );
		spParam.put("BAR_CODE"          , dataMaster.getBAR_CODE()          );
		spParam.put("REMARK"            , dataMaster.getREMARK()            );
		spParam.put("DPR_STS"           , dataMaster.getDPR_STS()           );
		spParam.put("SALE_MANAGE_COST"  , dataMaster.getSALE_MANAGE_COST()  );
		spParam.put("PRODUCE_COST"      , dataMaster.getPRODUCE_COST()      );
		spParam.put("SALE_COST"         , dataMaster.getSALE_COST()         );
		spParam.put("FI_CAPI_TOT_I"     , dataMaster.getFI_CAPI_TOT_I()     );
		spParam.put("FI_SALE_TOT_I"     , dataMaster.getFI_SALE_TOT_I()     );
		spParam.put("FI_SALE_DPR_TOT_I" , dataMaster.getFI_SALE_DPR_TOT_I() );
		spParam.put("FI_DPR_TOT_I"      , dataMaster.getFI_DPR_TOT_I()      );
		spParam.put("FL_BALN_I"         , dataMaster.getFL_BALN_I()         );
		spParam.put("WASTE_YYYYMM"      , dataMaster.getWASTE_YYYYMM()      );
		spParam.put("WASTE_SW"          , dataMaster.getWASTE_SW()          );
		spParam.put("DPR_YYYYMM"        , dataMaster.getDPR_YYYYMM()        );
		spParam.put("DPR_STS2"          , dataMaster.getDPR_STS2()          );
		spParam.put("SET_TYPE"          , dataMaster.getSET_TYPE()          );
		spParam.put("PROOF_KIND"        , dataMaster.getPROOF_KIND()        );
		spParam.put("SUPPLY_AMT_I"      , dataMaster.getSUPPLY_AMT_I()      );
		spParam.put("TAX_AMT_I"         , dataMaster.getTAX_AMT_I()         );
		spParam.put("AC_CUSTOM_CODE"    , dataMaster.getAC_CUSTOM_CODE()    );
		spParam.put("SAVE_CODE"         , dataMaster.getSAVE_CODE()         );
		spParam.put("CRDT_NUM"          , dataMaster.getCRDT_NUM()          );
		spParam.put("REASON_CODE"       , dataMaster.getREASON_CODE()       );
		spParam.put("PAY_DATE"          , dataMaster.getPAY_DATE()          );
		spParam.put("EB_YN"             , dataMaster.getEB_YN()             );
		spParam.put("ASST_DIVI"         , dataMaster.getASST_DIVI()         );
		spParam.put("PURCHASE_DEPT_CODE", dataMaster.getPURCHASE_DEPT_CODE());
		spParam.put("PURCHASE_DEPT_NAME", dataMaster.getPURCHASE_DEPT_NAME());
		spParam.put("SAVE_FLAG"         , dataMaster.getSAVE_FLAG()         );
		spParam.put("AUTO_TYPE"         , dataMaster.getAUTO_TYPE()         );

		spParam.put("ITEM_NM"			, dataMaster.getITEM_NM()			);
		spParam.put("ITEM_CD"			, dataMaster.getITEM_CD()			);
		spParam.put("ASS_STATE"         , dataMaster.getASS_STATE()         );
		spParam.put("REASON_NM"         , dataMaster.getREASON_NM()         );
		spParam.put("ITEM_USE"          , dataMaster.getITEM_USE()          );
		spParam.put("INSERT_DB_USER"    , dataMaster.getINSERT_DB_USER()    );
		spParam.put("UPDATE_DB_USER"    , dataMaster.getUPDATE_DB_USER()    );
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
    	//자산코드 존재여부 확인
		Map checkData = (Map) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.beforeSaveCheck", spParam);

		//신규입력(insert)일 경우,
		if(dataMaster.getSAVE_FLAG().equals("N")){

			if(ObjUtils.parseInt(checkData.get("EXIST_YN")) != 0) {
				String error =  "2627;중복되는 자료가 입력 되었습니다.";
			    throw new  UniDirectValidateException(this.getMessage(error, user));		
			    
			} else {
				String autoNum = "";
				if(ObjUtils.getSafeString(checkData.get("AUTO_NO_YN")).equals("Y")) {
//					Map checkAutoNum = (Map) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.beforeSaveCheck2", spParam);
//				
//					if(ObjUtils.isEmpty(checkAutoNum.get("PREFIX"))) {
//						String error1 =  "55342;자산코드를 자동채번하기 위한 채번구분자 정보가 없습니다. 회계-Configuration 정보-기본정보등록-고정자산기본정보등록 메뉴에서 자산이 속한 계정의 채번구분자를 등록하십시오.";
//					    throw new  UniDirectValidateException(this.getMessage(error1, user));	
//					}
//					    
//					if(ObjUtils.parseInt(checkAutoNum.get("SEQ_NUM")) == 0) {
//						String error2 =  "55394;자산코드를 자동채번하기 위한 채번자리수 정보가 없습니다. 회계-Configuration 정보-기본정보등록-고정자산기본정보등록 메뉴에서 자산이 속한 계정의 채번자리수를 등록하십시오.";
//					    throw new  UniDirectValidateException(this.getMessage(error2, user));
//					}
					
					//자동채번
					Map getMaxNum = (Map) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.getMaxNum", spParam);
					//자동채번한 자산코드를 spParam에 추가하여 insert
					if(ObjUtils.isEmpty(getMaxNum)) {
						autoNum = (String) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.autoNum1", spParam);

					} else {
						autoNum = (String) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.autoNum2", spParam);
												
					}
					spParam.put("ASST", autoNum);
					
					super.commonDao.insert("s_ass300ukrServiceImpl_KOCIS.insertForm", spParam);
					extResult.addResultProperty("AUTO_ASST", ObjUtils.getSafeString(spParam.get("ASST")));
					
				} else {
					super.commonDao.insert("s_ass300ukrServiceImpl_KOCIS.insertForm", spParam);
				}
			}
			
		//신규입력(insert)이 아닐 경우(수정 또는 삭제일 때 데이터 체크),
		} else if(ObjUtils.parseInt(checkData.get("EXIST_YN")) == 0) {
			String error =  "55306;참조된 데이터가 삭제되었습니다. \n 확인 후 작업하십시요.";
		    throw new  UniDirectValidateException(this.getMessage(error, user));	

		//수정(update)일 경우,
		} else if(dataMaster.getSAVE_FLAG().equals("U")){
			super.commonDao.update("s_ass300ukrServiceImpl_KOCIS.updateForm", spParam);

		//삭제(delete)일 경우,
		} else if(dataMaster.getSAVE_FLAG().equals("D")){
			Map beforeDelCheck = (Map) super.commonDao.select("s_ass300ukrServiceImpl_KOCIS.beforeDelCheck", spParam);
			if(ObjUtils.parseInt(beforeDelCheck.get("EXIST_YN")) != 0) {
				String error =  "55348;자산의 변동내역이 존재합니다. 자산변동내역을 먼저 삭제한 후 자산을 삭제하십시오.";
			    throw new  UniDirectValidateException(this.getMessage(error, user));		
			    
			} else{
				super.commonDao.update("s_ass300ukrServiceImpl_KOCIS.deleteForm", spParam);				
			}
		}
		

		return extResult;
	}
	

}
