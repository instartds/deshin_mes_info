package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hpa950ukrService")
public class Hpa950ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private Map<String, Object> result;
	
	/* 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns1(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("hpa950ukrServiceImpl.selectColumns1" ,loginVO.getCompCode());
	}
	
	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	//@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List selectColumns2(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("hpa950ukrServiceImpl.selectColumns2" ,loginVO.getCompCode());
	}
	
	/* 개인 급여 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		
		List<Map> getColumn1 = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.selectColumns1", param);
		
		param.put("getColumn1", getColumn1);
		
		for(int i=0; i < getColumn1.size(); i++){
			param.put("sCol"+i, getColumn1.get(i).get("WAGES_CODES"));
		}
		
		return (List) super.commonDao.list("hpa950ukrServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		List<Map> getColumn2 = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.selectColumns2", param);
		
		param.put("getColumn2", getColumn2);
		
		for(int i=0; i < getColumn2.size(); i++){
			param.put("sCol"+i, getColumn2.get(i).get("WAGES_CODES"));
		}
		
		return (List) super.commonDao.list("hpa950ukrServiceImpl.selectList2", param);
	}
		
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("hpa950ukrServiceImpl.getCostPoolName" ,param);
		
	}
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate1(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.getData1", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}
	
	public void excelValidate2(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.getData2", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		List<Map> getColumn1 = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.selectColumns1", param);
		
		param.put("getColumn1", getColumn1);
		
		for(int i=0; i < getColumn1.size(); i++){
			param.put("sCol"+i, getColumn1.get(i).get("WAGES_CODES"));
		}
		
		return super.commonDao.list("hpa950ukrServiceImpl.selectExcelUploadSheet1", param);
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
		List<Map> getColumn2 = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.selectColumns2", param);
		
		param.put("getColumn2", getColumn2);
		
		for(int i=0; i < getColumn2.size(); i++){
			param.put("sCol"+i, getColumn2.get(i).get("WAGES_CODES"));
		}
		
		return super.commonDao.list("hpa950ukrServiceImpl.selectExcelUploadSheet2", param);
	}
	
	// SAVE All1
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll1(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				
				//List<Map> updateList = null;
				//List<Map> deleteList = null;
				
				for(Map dataListMap: paramList) {
					
					/*if(dataListMap.get("method").equals("deleteList1")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertList1")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList1")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} */
					
					if(dataListMap.get("method").equals("insertList1")) {
						insertList = (List<Map>)dataListMap.get("data");
					}
				}			
				if(insertList != null) this.insertList1(insertList, user);
				//if(updateList != null) this.updateList1(updateList, user);				
				//if(deleteList != null) this.deleteList1(deleteList, user);
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")		// UPDATE
	public Integer insertList1(List<Map> paramList, LoginVO user) throws Exception {
		
		Map compCodeMap = new HashMap();
		
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		//List<Map> chkList = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.checkCompCode", compCodeMap);
		
		List<Map> Columns1 = (List)super.commonDao.list("hpa950ukrServiceImpl.selectColumns1" ,user.getCompCode());
		
			for(Map param :paramList )	{	
		
				for(int i=0; i < Columns1.size(); i++){
					
					String WAGES_CODE = (String) Columns1.get(i).get("WAGES_CODE");
					String WAGES_CODES = (String) Columns1.get(i).get("WAGES_CODES");
					 
					//logger.debug("[[param]]" + param);
					param.put("WAGES_CODE", WAGES_CODE);
					Object amountI = param.get("WAGES_PAY" + WAGES_CODE);
					param.put("AMOUNT_I", amountI);
					super.commonDao.update("hpa950ukrServiceImpl.insertList1", param);
				};

			 }
				
		 return 0;
	} 
	
	
	// SAVE All2
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
		 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
		 public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
			 
			 if(paramList != null)	{
					List<Map> insertList = null;
					
					//List<Map> updateList = null;
					//List<Map> deleteList = null;
					
					for(Map dataListMap: paramList) {
						
						/*if(dataListMap.get("method").equals("deleteList1")) {
							deleteList = (List<Map>)dataListMap.get("data");
						}else if(dataListMap.get("method").equals("insertList1")) {		
							insertList = (List<Map>)dataListMap.get("data");
						} else if(dataListMap.get("method").equals("updateList1")) {
							updateList = (List<Map>)dataListMap.get("data");	
						} */
						
						if(dataListMap.get("method").equals("insertList2")) {
							insertList = (List<Map>)dataListMap.get("data");
						}
					}			
					if(insertList != null) this.insertList2(insertList, user);
					//if(updateList != null) this.updateList1(updateList, user);				
					//if(deleteList != null) this.deleteList1(deleteList, user);
				}
			 	paramList.add(0, paramMaster);
					
			 	return  paramList;
		}
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")		// UPDATE
		public Integer insertList2(List<Map> paramList, LoginVO user) throws Exception {
			
			Map compCodeMap = new HashMap();
			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			//List<Map> chkList = (List<Map>) super.commonDao.list("hpa950ukrServiceImpl.checkCompCode", compCodeMap);
			
			List<Map> Columns2 = (List)super.commonDao.list("hpa950ukrServiceImpl.selectColumns2" ,user.getCompCode());
			
				for(Map param :paramList )	{	
			
					for(int i=0; i < Columns2.size(); i++){
						
						String WAGES_CODE = (String) Columns2.get(i).get("WAGES_CODE");
						String WAGES_CODES = (String) Columns2.get(i).get("WAGES_CODES");
						 
						//logger.debug("[[param]]" + param);
						param.put("WAGES_CODE", WAGES_CODE);
						Object amountI = param.get("WAGES_DED" + WAGES_CODE);
						param.put("AMOUNT_I", amountI);
						super.commonDao.update("hpa950ukrServiceImpl.insertList2", param);
					};

				 }
					
			 return 0;
		} 
	
		/**
		 * 급여내역일괄조정 데이터 조회
		 * 
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@Transactional(readOnly = true)
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
		public String payroll(Map param, LoginVO user) throws Exception {
			Map ErrMap = (Map) super.commonDao.select("hpa950ukrServiceImpl.payroll", param);
			String errorDesc = ObjUtils.getSafeString(ErrMap.get("ErrorDesc"));
    		if(!"".equals(errorDesc))	{
    			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
    		} 		
    		return "succes";	  
		}
}
