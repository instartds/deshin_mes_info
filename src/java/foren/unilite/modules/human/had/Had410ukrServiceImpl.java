package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had410ukrService")
public class Had410ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had410ukrServiceImpl.selectList", param);		
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectCheckFamily(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("had410ukrServiceImpl.selectCheckFamily", param);		
	}
	
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectCheck200(Map param, LoginVO loginVo) throws Exception {
		 Map<String, Object> rMap = new HashMap();
		 Map<String, Object> checkFamily = (Map<String, Object>) super.commonDao.select("had410ukrServiceImpl.selectCheckFamily", param);		
		 if(ObjUtils.parseInt(checkFamily.get("CNT")) == 0)	{
				//throw new  UniDirectValidateException(this.getMessage("54250;", loginVo)); //연말정산기준자료를 등록하십시오.
		 }
 		 
		 Map<String, Object> check200 = (Map<String, Object>) super.commonDao.select("had410ukrServiceImpl.selectCheck200", param);	
		 Map<String, Object> pay = (Map<String, Object>) super.commonDao.select("had410ukrServiceImpl.selectPay", param);		
		 
		 if(ObjUtils.isEmpty(pay))	{
				//throw new  UniDirectValidateException(this.getMessage("54220;", loginVo));//'해당사원이 존재하지 않습니다.
			 rMap.put("TaxAmount", 0);
			 rMap.put("MedAmount", 0);
		 } else {
			 Double bonus_total 			= ObjUtils.parseDouble(pay.get("BONUS_TOTAL"));
			 Double e_supp_total 			= ObjUtils.parseDouble(pay.get("E_SUPP_TOTAL"));
			 Double old_bonus_total 		= ObjUtils.parseDouble(pay.get("OLD_BONUS_TOTAL"));
			 Double etc_income 				= ObjUtils.parseDouble(pay.get("ETC_INCOME"));
			 Double educ_supp 				= ObjUtils.parseDouble(pay.get("EDUC_SUPP"));
			 Double med_supp 				= ObjUtils.parseDouble(pay.get("MED_SUPP"));
			 Double nap_bonus_total 		= ObjUtils.parseDouble(pay.get("NAP_BONUS_TOTAL"));
			 Double old_add_bonus 			= ObjUtils.parseDouble(pay.get("OLD_ADD_BONUS"));
			 Double add_bonus 				= ObjUtils.parseDouble(pay.get("ADD_BONUS"));
			 Double tax_exemption1 			= ObjUtils.parseDouble(pay.get("TAX_EXEMPTION1"));
			 Double old_tax_exemption1 		= ObjUtils.parseDouble(pay.get("OLD_TAX_EXEMPTION1"));
			 Double tax_exemption_lmt = 0d;
			 if(ObjUtils.isNotEmpty(check200))	{
				 tax_exemption_lmt 		= ObjUtils.parseDouble(check200.get("TAX_EXEMPTION_LMT"));
			 } 
			 String fore_single_yn 			= ObjUtils.getSafeString(pay.get("FORE_SINGLE_YN"));
			 String foreign_num 			= ObjUtils.getSafeString(pay.get("FOREIGN_NUM"));
			 Double pay_total_i 			= ObjUtils.parseDouble(pay.get("PAY_TOTAL_I"));
			 Double old_pay_total 			= ObjUtils.parseDouble(pay.get("OLD_PAY_TOTAL"));
			 Double nap_pay_total 			= ObjUtils.parseDouble(pay.get("NAP_PAY_TOTAL"));
			 Double stock_tax_profit_i 		= ObjUtils.parseDouble(pay.get("STOCK_TAX_PROFIT_I"));
			 Double old_stock_buy_profit_i 	= ObjUtils.parseDouble(pay.get("OLD_STOCK_BUY_PROFIT_I"));
			 Double outside_income 			= ObjUtils.parseDouble(pay.get("OUTSIDE_INCOME"));
			 Double now_pay_tot 			= ObjUtils.parseDouble(pay.get("NOW_PAY_TOT"));
			
			 Double taxAmount = 0d;
			 Double bonusTot = bonus_total + e_supp_total + old_bonus_total +  etc_income + educ_supp + med_supp + nap_bonus_total + old_add_bonus;
	
		     Double nowBonusTot = bonusTot - old_bonus_total - old_add_bonus  - nap_bonus_total - add_bonus;
	
		    
		    Double nontax1 = tax_exemption1 + old_tax_exemption1;
		    
		    if(nontax1 > 0 && nontax1 > tax_exemption_lmt && !"Y".equals(fore_single_yn) )     {   // '비과세급여 240 만원이상 TAX_EXEMPTION_LMT
		    	taxAmount = taxAmount + (nontax1 -tax_exemption_lmt);
		    }
		    
		    Double payTot = 0d;
		    Double nowPayTot = 0d;
		    
		    if (!"".equals(foreign_num) && "Y".equals(fore_single_yn))	{
		    	payTot = pay_total_i + old_pay_total + nap_pay_total + stock_tax_profit_i + old_stock_buy_profit_i - outside_income;
		        nowPayTot = pay_total_i + stock_tax_profit_i - outside_income;
		    } else {
		        payTot = now_pay_tot + old_pay_total + nap_pay_total +  stock_tax_profit_i + old_stock_buy_profit_i +  taxAmount - outside_income;
		        nowPayTot = now_pay_tot + taxAmount + stock_tax_profit_i - outside_income;
		    }
	
		    taxAmount = payTot + bonusTot;
		    Double foreDedI = 0d;
		    if( !"".equals(foreign_num) && "N".equals(fore_single_yn) ) {
		    	if(ObjUtils.isNotEmpty(check200))	{
		    		foreDedI = Math.floor((nowPayTot + nowBonusTot) * (ObjUtils.parseDouble(check200.get("FOREIGN_LMT_RATE")) / 100));
		    	}
		        taxAmount = taxAmount - foreDedI;
		    }
		    rMap.put("TaxAmount", taxAmount);
		    if(ObjUtils.isNotEmpty(check200))	{
		    	rMap.put("MedAmount", Math.floor(taxAmount * ObjUtils.parseDouble(check200.get("MED_DED_STD")) / 100));
		    } else {
		    	rMap.put("MedAmount", 0);
		    }
		    
		 }
		return rMap;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			
			if(deleteList != null) this.delete(deleteList );
			if(insertList != null) this.insert(insertList );
			if(updateList != null) this.update(updateList );	
			
			if(deleteList != null || insertList != null || updateList != null) {
				Map<String, Object> param = null ;
				if(deleteList != null ) param = deleteList.get(0);
				else if( insertList != null ) param = insertList.get(0);
				else if( updateList != null ) param = updateList.get(0);
				
				if(param!= null)	{
					this.update400(param );
					this.update430(param );
				}
			}
			
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had410ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.insert("had410ukrServiceImpl.insert", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had410ukrServiceImpl.update", param);
		}
		return paramList;		
	}
	
	private void update400(Map<String, Object> param) throws Exception {
			super.commonDao.update("had410ukrServiceImpl.update400", param);
	}
	
	private void update430(Map<String, Object> param) throws Exception {
		super.commonDao.update("had410ukrServiceImpl.update430", param);
	}
}
