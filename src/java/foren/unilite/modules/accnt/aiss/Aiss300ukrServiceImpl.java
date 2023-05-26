package foren.unilite.modules.accnt.aiss;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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


@Service("aiss300ukrService")
public class Aiss300ukrServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.select("aiss300ukrServiceImpl.selectMaster", param);
	}
	
	/**
	 * 감가상각 계산여부 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Object selecChktDep(Map param) throws Exception {
		return super.commonDao.select("aiss300ukrServiceImpl.selecChktDep", param);
	}
	
	/**
	 *  고정자산등록 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Aiss300ukrModel dataMaster, LoginVO user,  BindingResult result) throws Exception {		
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("COMP_CODE"         , user.getCompCode()         );
		spParam.put("USER_ID"           , user.getUserID()           );
		spParam.put("ASST"              , dataMaster.getASST()              );
		spParam.put("ASST_NAME"         , dataMaster.getASST_NAME()         );
		spParam.put("SPEC"              , dataMaster.getSPEC()              );
		spParam.put("ACCNT"             , dataMaster.getACCNT()             );
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
		spParam.put("DEP_ACCNT"         , dataMaster.getDEP_ACCNT()         );
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
		spParam.put("SUBCONTRACT_COST"  , dataMaster.getSUBCONTRACT_COST()  );
		spParam.put("CRDT_NUM"          , dataMaster.getCRDT_NUM()          );
		spParam.put("REASON_CODE"       , dataMaster.getREASON_CODE()       );
		spParam.put("PAY_DATE"          , dataMaster.getPAY_DATE()          );
		spParam.put("EB_YN"             , dataMaster.getEB_YN()             );
		spParam.put("ASST_DIVI"         , dataMaster.getASST_DIVI()         );
		spParam.put("MAKER_NAME"        , dataMaster.getMAKER_NAME()        );
		spParam.put("PURCHASE_DEPT_CODE", dataMaster.getPURCHASE_DEPT_CODE());
		spParam.put("PURCHASE_DEPT_NAME", dataMaster.getPURCHASE_DEPT_NAME());
		spParam.put("SAVE_FLAG"         , dataMaster.getSAVE_FLAG()         );
		spParam.put("AUTO_TYPE"         , dataMaster.getAUTO_TYPE()         );
		
		spParam.put("DEP_CTL"         	, dataMaster.getDEP_CTL()         );
		spParam.put("ASST_STS"         	, dataMaster.getASST_STS()         );
		spParam.put("PAT_YN"         	, dataMaster.getPAT_YN()         );
		spParam.put("DMG_OJ_YN"         , dataMaster.getDMG_OJ_YN()         );
		spParam.put("FI_REVAL_TOT_I"    , dataMaster.getFI_REVAL_TOT_I()         );
		spParam.put("FI_REVAL_DPR_TOT_I", dataMaster.getFI_REVAL_DPR_TOT_I()         );
		spParam.put("FI_DMGLOS_TOT_I"   , dataMaster.getFI_DMGLOS_TOT_I()         );
		spParam.put("WDAMT_MTD"   , dataMaster.getWDAMT_MTD()         );
		
		spParam.put("SALE_MANAGE_DEPT_CODE" , dataMaster.getSALE_MANAGE_DEPT_CODE()  );
		spParam.put("SALE_MANAGE_DEPT_NAME" , dataMaster.getSALE_MANAGE_DEPT_NAME()  );
		spParam.put("PRODUCE_DEPT_CODE"   	, dataMaster.getPRODUCE_DEPT_CODE()      );
		spParam.put("PRODUCE_DEPT_NAME"   	, dataMaster.getPRODUCE_DEPT_NAME()      );
		spParam.put("SALE_DEPT_CODE"   		, dataMaster.getSALE_DEPT_CODE()         );
		spParam.put("SALE_DEPT_NAME"   		, dataMaster.getSALE_DEPT_NAME()         );
		spParam.put("SUBCONTRACT_DEPT_CODE" , dataMaster.getSUBCONTRACT_DEPT_CODE()  );
		spParam.put("SUBCONTRACT_DEPT_NAME" , dataMaster.getSUBCONTRACT_DEPT_NAME()  );

		spParam.put("GOV_GRANT_ACCNT" 		, dataMaster.getGOV_GRANT_ACCNT()  );
		spParam.put("GOV_GRANT_AMT_I" 		, dataMaster.getGOV_GRANT_AMT_I()  );
		spParam.put("GOV_GRANT_DPR_TOT_I" 	, dataMaster.getGOV_GRANT_DPR_TOT_I()  );
		spParam.put("GOV_GRANT_BALN_I" 		, dataMaster.getGOV_GRANT_BALN_I()  );
		
		if(dataMaster.getSAVE_FLAG().equals("N")){
			spParam.put("FL_ACQ_AMT_I"   , dataMaster.getACQ_AMT_I()         );		
		}else{
			spParam.put("FL_ACQ_AMT_I"   , dataMaster.getH_ACQ_AMT_I()         );			
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		if(dataMaster.getSAVE_FLAG().equals("N")){
			Map err = (Map) super.commonDao.select("aiss300ukrServiceImpl.beforeSaveCheck", spParam);
			if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				//String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));				
			}else{
				if(spParam.get("AUTO_TYPE").equals("Y")){	//자동 채번일시 채번 해 온다
					Map err2 = (Map) super.commonDao.select("aiss300ukrServiceImpl.autoNumbering", spParam);
					if(!ObjUtils.isEmpty(err2.get("ERROR_CODE"))){
						String errorDesc = ObjUtils.getSafeString(err2.get("ERROR_CODE"));
						//String[] messsage = errorDesc.split(";");
					    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));				
					}else{
						spParam.put("ASST", err2.get("ASST"));
						super.commonDao.insert("aiss300ukrServiceImpl.insertForm", spParam);
						extResult.addResultProperty("AUTO_ASST", ObjUtils.getSafeString(spParam.get("ASST")));
					}
				}else{
					super.commonDao.insert("aiss300ukrServiceImpl.insertForm", spParam);
				}
												
			}			
			
		}else if(dataMaster.getSAVE_FLAG().equals("U")){
			super.commonDao.update("aiss300ukrServiceImpl.updateForm", spParam);
		}else if(dataMaster.getSAVE_FLAG().equals("D")){
			Map err = (Map) super.commonDao.select("aiss300ukrServiceImpl.beforeDelCheck", spParam);
			if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				
			    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
				
			}else{
				super.commonDao.update("aiss300ukrServiceImpl.deleteForm", spParam);				
			}
		}
		

		return extResult;
	}
	
	@ExtDirectMethod(group = "accnt")
	public Map updateGovInfo(Map dataMaster, LoginVO user) throws Exception {	
	    if(ObjUtils.isNotEmpty(dataMaster.get("ASST"))){
			super.commonDao.update("aiss300ukrServiceImpl.updateGovInfo", dataMaster);
		}else {
			 throw new  UniDirectValidateException(this.getMessage("자산정보를 생성 후 저장하세요.", user));
		}
		return dataMaster;
	}
	
}
