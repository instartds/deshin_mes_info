package foren.unilite.modules.accnt.atx;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("atx500ukrService")
public class Atx500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 내국신용장.구매확인 전자발급명세서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	//데이터 조회
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.selectList", param);
	}
	//합계 조회
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.selectList1", param);
	}

	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user, dataMaster);
			if(insertList != null) this.insertDetail(insertList, user, dataMaster);
			if(updateList != null) this.updateDetail(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			for(Map param : paramList )	{	
				String companyNum = (String) param.get("COMPANY_NUM");
				param.put("COMPANY_NUM", companyNum.replaceAll("-", ""));
				//추가시에는 그리드에 PUB_DATE_FR, PUB_DATE_TO, BILL_DIV_CODE가 없으므로(hidden field), panelSearch에 있는 값을 넣어준다.
				param.put("BILL_DIV_CODE",	paramMaster.get("DIV_CODE"));
				param.put("PUB_DATE_FR",	paramMaster.get("PUB_DATE_FR"));
				param.put("PUB_DATE_TO",	paramMaster.get("PUB_DATE_TO"));
				super.commonDao.update("atx500ukrServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			String companyNum = (String) param.get("COMPANY_NUM");
			param.put("COMPANY_NUM", companyNum.replaceAll("-", ""));
			param.put("PUB_DATE_FR",	paramMaster.get("PUB_DATE_FR"));
			param.put("PUB_DATE_TO",	paramMaster.get("PUB_DATE_TO"));
			super.commonDao.insert("atx500ukrServiceImpl.updateDetail", param);
		 }
		 return 0;
	} 
	
	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{
			 try {
				String companyNum = (String) param.get("COMPANY_NUM");
				param.put("COMPANY_NUM", companyNum.replaceAll("-", ""));
				super.commonDao.delete("atx500ukrServiceImpl.deleteDetail", param);
				 
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	/**
     * 
     * 엑셀의 내용을 읽어옴
     * @param param
     * @return
     * @throws Exception
     */
	//UPLOAD 전 데이터 존재여부 체크
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnDocuChk(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.fnDocuChk", param);
	}

    @ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
//    	String arr[] = param.toString().split(",");
//		for(int i=0;i<arr.length;i++){
//			System.out.println(arr[i]);
//		}
        return super.commonDao.list("atx500ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("atx500ukrServiceImpl.excelValidate", param);
	}
	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)		// 엑셀데이터 저장
    public void saveExcelData(Map param) throws Exception {
        super.commonDao.update("atx500ukrServiceImpl.saveExcel", param);
    }
	
	@ExtDirectMethod(group = "accnt")
	public List<Map<String, Object>> selectReference(Map param) throws Exception {
		return super.commonDao.list("atx500ukrServiceImpl.selectReference", param);
	}
	
	@ExtDirectMethod(group = "accnt")
	public Map<String, Object> selectCount(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("atx500ukrServiceImpl.selectCount", param);
	}
	
	
}
