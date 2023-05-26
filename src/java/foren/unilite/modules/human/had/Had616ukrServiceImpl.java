package foren.unilite.modules.human.had;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.human.HumanCommonServiceImpl;


@Service("had616ukrService")
public class Had616ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
	
	/**
	 * 폼데이터  조회(정산항목)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFormHad600(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had616ukrServiceImpl.selectFormHad600", param);
		return rv;
	}
		
	/**
	 * 폼데이터  조회(입력항목)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFormHad400(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("had616ukrServiceImpl.selectFormHad400", param);
		return rv;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectPrev(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had616ukrServiceImpl.selectPrevious", param);
		return rv;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> selectNext(Map param) throws Exception {
		Map<String, Object> rv = (Map)super.commonDao.select("had616ukrServiceImpl.selectNext", param);
		return rv;
	}
	
	
	/**
	 * 수정권한 여부 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public Object selectAuth(Map param) throws Exception {
		return super.commonDao.select("had616ukrServiceImpl.selectAuth", param);
	}
	
	/**
	 * 기타수당내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList02(Map param) throws Exception {
		return (List) super.commonDao.list("had616ukrServiceImpl.selectList02", param);
	}
	
	/**
	 * 상여내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList03(Map param) throws Exception {
		return (List) super.commonDao.list("had616ukrServiceImpl.selectList03", param);
	}
	
	/**
	 * 년월차내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList04(Map param) throws Exception {
		return (List) super.commonDao.list("had616ukrServiceImpl.selectList04", param);
	}
	
	/**
	 * 년월차내역 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> insertList04(List<Map> paramList, LoginVO loginVO) throws Exception {

		for(Map param : paramList ) {
			param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
			super.commonDao.insert("had616ukrServiceImpl.insertList04", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함(년월차 내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList04(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("had616ukrServiceImpl.updateList04", param);
		}
		return paramList;
	}
	
	/**
	 * 산정내역(임원) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList05(Map param) throws Exception {
		return (List) super.commonDao.list("had616ukrServiceImpl.selectList05", param);
	}
	
	/**
	 * 중간정산 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map<String, Object>> selectList06(Map param) throws Exception {
		return (List) super.commonDao.list("had616ukrServiceImpl.selectList06", param);
	}
	
	/**
	 * 지급총액계산
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> fnSuppTotI(Map param) throws Exception {
		return (Map) super.commonDao.select("had616ukrServiceImpl.fnSuppTotI", param);
	}
	
	@ExtDirectMethod(group = "human")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	/**
	 * 집계자료 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> selectSummaryData(Map param, LoginVO user) throws Exception {
		boolean chk = humanCommonService.fnCloseYn("Y", ObjUtils.getSafeString(param.get("YEAR_YYYY")),  user);
		Map chkTaxRate  = (Map) super.commonDao.select("had616ukrServiceImpl.checkTaxRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54205;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		Map checkTaxDedRate  = (Map) super.commonDao.select("had616ukrServiceImpl.checkTaxDedRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54250;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		return	(List<Map>)super.commonDao.list("had616ukrServiceImpl.selectSummaryData", param);
		
	}
	
	/**
	 * 집계자료 일괄적용 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public void batchSummaryData(Map param) throws Exception {
		super.commonDao.update("had616ukrServiceImpl.batchSummaryData", param);
		
	}
	
	/**
	 * 정산 세액 계산 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public List<Map> selectCalculateTax(Map param, LoginVO user) throws Exception {
		boolean chk = humanCommonService.fnCloseYn("Y", ObjUtils.getSafeString(param.get("YEAR_YYYY")),  user);
		Map chkTaxRate  = (Map) super.commonDao.select("had616ukrServiceImpl.checkTaxRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54205;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		Map checkTaxDedRate  = (Map) super.commonDao.select("had616ukrServiceImpl.checkTaxDedRate", param);
		if(ObjUtils.isEmpty(chkTaxRate))	{
			String msg = "54250;";
			throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(msg), user));
		}
		return	(List<Map>)super.commonDao.list("had616ukrServiceImpl.selectCalculateTax", param);
		
	}
	
	/**
	 * 정산 세액  일괄적용 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public void batchCalculateTax(Map param) throws Exception {
		super.commonDao.update("had616ukrServiceImpl.batchCalculateTax", param);
		
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> save400All(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert400")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update400")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert400(insertList);
			if(updateList != null) this.update400(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> insert400(List<Map> paramList)	{
		for(Map param : paramList)	{			
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN")) );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN")) );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN")) );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE")) );
			super.commonDao.update("had616ukrServiceImpl.save400", param);
		}
		return paramList;
	}
	

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> update400(List<Map> paramList)	{
		for(Map param : paramList)	{
			param.put("FORE_SINGLE_YN"		, this.getCheckboxValueYN(param.get("FORE_SINGLE_YN")) );
			param.put("FOREIGN_DISPATCH_YN"	, this.getCheckboxValueYN(param.get("FOREIGN_DISPATCH_YN")) );
			param.put("HOUSEHOLDER_YN"		, this.getCheckboxValueYN(param.get("HOUSEHOLDER_YN")) );
			param.put("HALFWAY_TYPE"		, this.getCheckboxValueYN(param.get("HALFWAY_TYPE")) );
			super.commonDao.update("had616ukrServiceImpl.save400", param);
		}
		return paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> save600All(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert600")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update600")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insert600(insertList);
			if(updateList != null) this.update600(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> insert600(List<Map> paramList)	{
		for(Map param : paramList)	{
			if (param.get("RETR_DATE")==null) {
				param.put("RETR_DATE", "00000000");
			}
			super.commonDao.update("had616ukrServiceImpl.save600", param);
		}
		return paramList;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	List<Map> update600(List<Map> paramList)	{
		for(Map param : paramList)	{
			if (param.get("RETR_DATE")==null) {
				param.put("RETR_DATE", "00000000");
			}
			super.commonDao.update("had616ukrServiceImpl.save600", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectNap(Map param) throws Exception {
		return super.commonDao.select("had616ukrServiceImpl.selectNap", param);		
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "human")
	public ExtDirectFormPostResult napSyncMaster(Had616ukrNapModel param,  LoginVO user, BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
	
		super.commonDao.update("had616ukrServiceImpl.updateNap", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);		
		return extResult;
	}
	
	@ExtDirectMethod(group = "human")
	public Map<String, Object> napDeleteAll(Map<String, Object> param) throws Exception {
		super.commonDao.update("had616ukrServiceImpl.deleteNap", param);
		return param;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectFamliy(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had616ukrServiceImpl.selectFamliy", param);
		return rv;
	}
	
	/**
	 * 체크박스  
	 * @param obj
	 * @return Y or N 
	 */
	private String getCheckboxValueYN(Object obj)	{
		String rValue = "N";
		if("true".equals(ObjUtils.getSafeString(obj).toLowerCase()))	{
			rValue = "Y";
		}
		return rValue;
	}
}
	
