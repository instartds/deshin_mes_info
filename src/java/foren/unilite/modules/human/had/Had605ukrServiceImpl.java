package foren.unilite.modules.human.had;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had605ukrService")
public class Had605ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "had960ukrService" )
	private Had960ukrServiceImpl had960ukrService;
	
	@Resource( name = "had616ukrService" )
	private Had616ukrServiceImpl had616ukrService;
	
	@Resource( name = "had617ukrService" )
	private Had617ukrServiceImpl had617ukrService;
	
	@Resource( name = "had618ukrService" )
	private Had618ukrServiceImpl had618ukrService;

	@Resource( name = "had619ukrService" )
	private Had619ukrServiceImpl had619ukrService;

	@Resource( name = "had620ukrService" )
	private Had620ukrServiceImpl had620ukrService;
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List<Map<String, Object>>)super.commonDao.list("had605ukrServiceImpl.selectList", param);		
	}
	
	@ExtDirectMethod(group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public Map<String, Object> save(Map param, LoginVO user) throws Exception {
		param.put("RETIRE_DATE_TO", param.get("YEAR_YYYY")+"1231");
		param.put("JOIN_DATE", param.get("YEAR_YYYY")+"1231");
		
		List<Map<String, Object>> dataList =(List<Map<String, Object>>)super.commonDao.list("had605ukrServiceImpl.selectList", param);		
		int totalCount = 0; //연말정산 대상
		int closedCount = 0; //마감된 사원
		int batchCount = 0; //실제계산된 사원
		
		if(dataList == null || ObjUtils.isEmpty(dataList) || dataList.size() == 0)	{
			throw new  UniDirectValidateException(this.getMessage("54220", user)); 
		}
		for(Map dataParam : dataList) {
			
			dataParam.put("S_COMP_CODE", param.get("S_COMP_CODE"));
			dataParam.put("YEAR_YYYY", param.get("YEAR_YYYY"));
			dataParam.put("S_USER_ID", param.get("S_USER_ID"));
			dataParam.put("DIR_TYPE", "QU");
			//List<Map<String, Object>> familyList = new ArrayList<Map<String, Object>>();
			//중도퇴사자정산 부양가족명세 등록
			if("00000000".equals(ObjUtils.getSafeString(dataParam.get("RETR_DATE"))) || ObjUtils.isEmpty(dataParam.get("RETR_DATE")))	{
				super.commonDao.list("had960ukrServiceImpl.selectList", dataParam);
				//had960ukrService.selectList(dataParam);		
			}
			if("2016".equals(ObjUtils.getSafeString(param.get("YEAR_YYYY")))){
				had616ukrService.batchSummaryData((Map)dataParam);
				had616ukrService.batchCalculateTax(dataParam);
			}else if("2017".equals(ObjUtils.getSafeString(param.get("YEAR_YYYY"))))	{
				had617ukrService.batchSummaryData((Map)dataParam);	
				had617ukrService.batchCalculateTax(dataParam);
			}else if("2018".equals(ObjUtils.getSafeString(param.get("YEAR_YYYY"))))	{
				had618ukrService.batchSummaryData((Map)dataParam);	
				had618ukrService.batchCalculateTax(dataParam);
			}else if("2019".equals(ObjUtils.getSafeString(param.get("YEAR_YYYY"))))	{
				totalCount++; //연말정산 대상
				if("N".equals(ObjUtils.getSafeString(dataParam.get("CLOSE_YN"))))	{
					had619ukrService.batchSummaryData((Map)dataParam);	
					had619ukrService.batchCalculateTax(dataParam);
					batchCount++; //실제계산된 사원
				} else {
					closedCount++; //마감된 사원
				}
			}else if("2020".equals(ObjUtils.getSafeString(param.get("YEAR_YYYY"))))	{
				totalCount++; //연말정산 대상
				if("N".equals(ObjUtils.getSafeString(dataParam.get("CLOSE_YN"))))	{
					had620ukrService.batchSummaryData((Map)dataParam);	
					had620ukrService.batchCalculateTax(dataParam);
					batchCount++; //실제계산된 사원
				} else {
					closedCount++; //마감된 사원
				}
			}
			param.put("success", true);
			param.put("TOTAL_COUNT", totalCount);
			param.put("BATCH_COUNT", batchCount);
			param.put("CLOSED_COUNT", closedCount);
		}
		return param;		
	}
	
}
