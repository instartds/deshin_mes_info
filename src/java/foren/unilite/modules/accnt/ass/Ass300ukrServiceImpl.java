package foren.unilite.modules.accnt.ass;

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


@Service("ass300ukrService")
public class Ass300ukrServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.select("ass300ukrServiceImpl.selectMaster", param);
	}
	
	
	/**
	 *  고정자산등록 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Ass300ukrModel dataMaster, LoginVO user,  BindingResult result) throws Exception {		
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
		spParam.put("MAKER_NAME"        , dataMaster.getMAKER_NAME()        );
		spParam.put("PURCHASE_DEPT_CODE", dataMaster.getPURCHASE_DEPT_CODE());
		spParam.put("PURCHASE_DEPT_NAME", dataMaster.getPURCHASE_DEPT_NAME());
		spParam.put("SAVE_FLAG"         , dataMaster.getSAVE_FLAG()         );
		spParam.put("AUTO_TYPE"         , dataMaster.getAUTO_TYPE()         );
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		if(dataMaster.getSAVE_FLAG().equals("N")){
			Map err = (Map) super.commonDao.select("ass300ukrServiceImpl.beforeSaveCheck", spParam);
			if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));				
			}else{
				if(spParam.get("AUTO_TYPE").equals("Y")){	//자동 채번일시 채번 해 온다
					Map err2 = (Map) super.commonDao.select("ass300ukrServiceImpl.autoNumbering", spParam);
					if(!ObjUtils.isEmpty(err2.get("ERROR_CODE"))){
						String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
						String[] messsage = errorDesc.split(";");
					    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));				
					}else{
						spParam.put("ASST", err2.get("ASST"));
						super.commonDao.insert("ass300ukrServiceImpl.insertForm", spParam);
						extResult.addResultProperty("AUTO_ASST", ObjUtils.getSafeString(spParam.get("ASST")));
					}
				}else{
					super.commonDao.insert("ass300ukrServiceImpl.insertForm", spParam);
				}
												
			}			
			
		}else if(dataMaster.getSAVE_FLAG().equals("U")){
			super.commonDao.update("ass300ukrServiceImpl.updateForm", spParam);
		}else if(dataMaster.getSAVE_FLAG().equals("D")){
			Map err = (Map) super.commonDao.select("ass300ukrServiceImpl.beforeDelCheck", spParam);
			if(!ObjUtils.isEmpty(err.get("ERROR_CODE"))){
				String errorDesc = ObjUtils.getSafeString(err.get("ERROR_CODE"));
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
				
			}else{
				super.commonDao.update("ass300ukrServiceImpl.deleteForm", spParam);				
			}
		}
		

		return extResult;
	}
	

}
