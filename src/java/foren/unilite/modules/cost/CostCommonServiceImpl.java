package foren.unilite.modules.cost;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("costCommonService")
public class CostCommonServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> selectCostCenterCombo(Map param, LoginVO user) throws Exception {
		if(ObjUtils.isEmpty(param.get("DIV_CODE")))	{
			param.put("DIV_CODE", user.getDivCode());
		}
		return (List<ComboItemModel>) super.commonDao.list("costCommonServiceImpl.selectCostCenterCombo", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> selectManageCodeCombo(Map param, LoginVO user) throws Exception {
		
		return (List<ComboItemModel>) super.commonDao.list("costCommonServiceImpl.selectManageCodeCombo", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> selectCostPoolCombo(Map param, LoginVO user) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("costCommonServiceImpl.selectCostPoolCombo", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> selectCostPoolCombo700(Map param, LoginVO user) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("costCommonServiceImpl.selectCostPoolCombo700", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> selectDistrPoolCombo(Map param, LoginVO user) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("costCommonServiceImpl.selectDistrPoolCombo", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public Map selectDivYearEvaluation(Map param, LoginVO user) throws Exception {
		return (Map) super.commonDao.select("costCommonServiceImpl.selectDivYearEvaluation", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public Map selectWorkMonthFr(Map param, LoginVO user) throws Exception {
		return (Map) super.commonDao.select("costCommonServiceImpl.selectWorkMonthFr", param);
	}
	
}