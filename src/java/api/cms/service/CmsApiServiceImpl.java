package api.cms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import api.cms.dto.CAcnutDelngLiatsDTO;
import api.cms.dto.CCprCardCListsDTO;
import api.cms.dto.CCprCardRListsDTO;
import api.cms.dto.CTaxBillMListsDTO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@SuppressWarnings("unchecked")
@Service("cmsApiService")
public class CmsApiServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(CmsApiServiceImpl.class);

	/**
	 * 계좌거래내역
	 * @param dtoMap
	 * @param gubun
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveCAcnutDelngLiats(CAcnutDelngLiatsDTO dtoMap, String gubun) throws Exception {
		
		Map<String, String> params = new HashMap<String, String>();
		
		params.put("erp_comp_code", dtoMap.getErp_comp_code());
		
		params.put("company_no",dtoMap.getCompany_no());
		params.put("dealing_dt",dtoMap.getDealing_dt());
		params.put("dealing_tm",dtoMap.getDealing_tm());
		params.put("acnut_no",dtoMap.getAcnut_no());
//		params.put("dealing_seq",dtoMap.getDealing_seq());
		params.put("crncy_cd",dtoMap.getCrncy_cd());
		params.put("rcpmny_amt",dtoMap.getRcpmny_amt());
		params.put("defray_amt",dtoMap.getDefray_amt());
		params.put("blce_amt",dtoMap.getBlce_amt());
		params.put("state_matter_1",dtoMap.getState_matter_1());
		params.put("GUBUN",	gubun);
		super.commonDao.insert("cmsApiService.insertTemp", params);
	}

	
	/**
	 * 법인카드승인내역
	 * @param dtoMap
	 * @param gubun
	 * @throws Exception
	 */
        @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY )
	public void saveCCprCardCLists(CCprCardCListsDTO dtoMap, String gubun) throws Exception {
		
		Map<String, String> params = new HashMap<String, String>();
		
		params.put("erp_comp_code", dtoMap.getErp_comp_code());
		
		params.put("company_no",dtoMap.getCompany_no());
		params.put("cpr_card_no",dtoMap.getCpr_card_no());
		params.put("cpr_card_confm_no",dtoMap.getCpr_card_confm_no());
		params.put("cpr_card_confm_dt",dtoMap.getCpr_card_confm_dt());
		params.put("cpr_card_confm_tm",dtoMap.getCpr_card_confm_tm());
		params.put("cancel_yn",dtoMap.getCancel_yn());
		params.put("cpr_card_confm_amt",dtoMap.getCpr_card_confm_amt());
		params.put("cpr_card_confm_vat",dtoMap.getCpr_card_confm_vat());
		params.put("cpr_card_cancel_dt",dtoMap.getCpr_card_cancel_dt());
		params.put("mrhst_reg_no",dtoMap.getMrhst_reg_no());
		params.put("mrhst_cd",dtoMap.getMrhst_cd());
		params.put("mrhst_nm",dtoMap.getMrhst_nm());
		params.put("GUBUN",	gubun);
		super.commonDao.insert("cmsApiService.insertTemp", params);
	}

    	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY)
    	public void deleteTemp(String gubun) throws Exception {

    		Map<String, String> params = new HashMap<String, String>();
    		params.put("GUBUN",	gubun);
    		super.commonDao.delete("cmsApiService.deleteTemp", params);
    	}
	
	/**
	 * 법인카드청구내역
	 * @param dtoMap
	 * @param gubun
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveCCprCardRLists(CCprCardRListsDTO dtoMap, String gubun/*, LoginVO user*/) throws Exception {
		
		Map<String, String> params = new HashMap<String, String>();

		params.put("erp_comp_code", dtoMap.getErp_comp_code());
		
		params.put("company_no",dtoMap.getCompany_no());
		params.put("cpr_card_no",dtoMap.getCpr_card_no());
//		params.put("cpr_card_seq",dtoMap.getCpr_card_seq());
//		params.put("cpr_card_pre_dt",dtoMap.getCpr_card_pre_dt());
		params.put("cpr_card_sett_dt",dtoMap.getCpr_card_sett_dt());
		params.put("cpr_card_use_dt",dtoMap.getCpr_card_use_dt());
		params.put("mrhst_nm",dtoMap.getMrhst_nm());
		params.put("mrhst_reg_no",dtoMap.getMrhst_reg_no());
		params.put("cpr_card_use_amt",dtoMap.getCpr_card_use_amt());
		params.put("cpr_card_req_amt",dtoMap.getCpr_card_req_amt());
		params.put("cpr_card_use_fee",dtoMap.getCpr_card_use_fee());
		params.put("cpr_card_blce_amt",dtoMap.getCpr_card_blce_amt());
		params.put("cpr_card_instlmt_pd",dtoMap.getCpr_card_instlmt_pd());
		params.put("input_seq",dtoMap.getInput_seq());
		params.put("GUBUN",	gubun);
		super.commonDao.insert("cmsApiService.insertTemp", params);
	}
	
	/**
	 * 전자세금계산서정보
	 * @param dtoMap
	 * @param gubun
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveCTaxBillMLists(CTaxBillMListsDTO dtoMap, String gubun/*, LoginVO user*/) throws Exception {
		
		Map<String, String> params = new HashMap<String, String>();

		params.put("erp_comp_code", dtoMap.getErp_comp_code());
		
		params.put("company_no",dtoMap.getCompany_no());
		params.put("confirm_no",dtoMap.getConfirm_no());
		params.put("tax_kind",dtoMap.getTax_kind());
		params.put("bill_kind",dtoMap.getBill_kind());
		params.put("writing_dt",dtoMap.getWriting_dt());
		params.put("issue_dt",dtoMap.getIssue_dt());
		params.put("trnsmis_dt",dtoMap.getTrnsmis_dt());
		params.put("supler_reg_no",dtoMap.getSupler_reg_no());
		params.put("supler_site_no",dtoMap.getSupler_site_no());
		params.put("supler_company_nm",dtoMap.getSupler_company_nm());
		params.put("supler_ceo_nm",dtoMap.getSupler_ceo_nm());
		params.put("recipter_reg_no",dtoMap.getRecipter_reg_no());
		params.put("recipter_site_no",dtoMap.getRecipter_site_no());
		params.put("recipter_company_nm",dtoMap.getRecipter_company_nm());
		params.put("recipter_ceo_nm",dtoMap.getRecipter_ceo_nm());
		params.put("tot_amt",dtoMap.getTot_amt());
		params.put("supply_amt",dtoMap.getSupply_amt());
		params.put("tax_amt",dtoMap.getTax_amt());
		params.put("e_bill_no",dtoMap.getE_bill_no());
		params.put("e_tax_bill_kind",dtoMap.getE_tax_bill_kind());
		params.put("issue_tp",dtoMap.getIssue_tp());
		
		params.put("GUBUN",	gubun);
		super.commonDao.insert("cmsApiService.insertTemp", params);
	}
	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void callApiSp(String gubun) throws Exception {
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("GUBUN", gubun);
		super.commonDao.queryForObject("cmsApiService.uspAccntMakeCmsData", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
//		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		    throw new  UniDirectValidateException(messsage[0]);
		}
	}
	
	
}
