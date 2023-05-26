package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hpa700ukrService_KOCIS")
public class S_Hpa700ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ,group = "hpa")
	public List<Map> selectList1(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map> result = new ArrayList();
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		if(param.get("PROV_GUBUN").equals("1")){
			result = (List) super.commonDao.list("s_hpa700ukrServiceImpl_KOCIS.selectList1_1", param);
		}else if(param.get("PROV_GUBUN").equals("2")){
			result = (List) super.commonDao.list("s_hpa700ukrServiceImpl_KOCIS.selectList1_2", param);
		}		
		return result;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		
		List<Map<String, Object>> result = new ArrayList();
		if(param.get("rdoSelect").equals("1")){
			result = (List) super.commonDao.list("s_hpa700ukrServiceImpl_KOCIS.selectList2_1", param);
		}else if(param.get("rdoSelect").equals("2")){
			result = (List) super.commonDao.list("s_hpa700ukrServiceImpl_KOCIS.selectList2_2", param);
		}		

		return result;		
	}
	
	/**
	 * 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        String retireYN   = "";
        String msgAlert   = "";
        String msgAlertYN = "";
	    
	    for(Map param :paramList ) {
            //인사기본자료등록의 퇴사일로 퇴사여부 확인 후 퇴사자인 경우, 등록되지 않게 메시지 호출
            retireYN = (String) super.commonDao.select("s_hpa700ukrServiceImpl_KOCIS.retireYN", param);
            
            param.put("EXIST_YN", retireYN);
            
            if(retireYN.equals("Y")){
                msgAlertYN = "Y";
                msgAlert = "퇴사자인 경우 등록할 수 없습니다."+ "\n직원: " + param.get("NAME");
                throw new  UniDirectValidateException("퇴사자인 경우 등록할 수 없습니다."+ "\n직원: " + param.get("NAME"));
            }	        
	    }
	    
		for(Map param :paramList )	{
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));
			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}
			super.commonDao.insert("s_hpa700ukrServiceImpl_KOCIS.insertList", param);					
		}
		return paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList )	{			
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));
			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}
			
			super.commonDao.update("s_hpa700ukrServiceImpl_KOCIS.updateList", param);							
		}
		return paramList;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		for(Map param :paramList )	{
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));

			super.commonDao.delete("s_hpa700ukrServiceImpl_KOCIS.deleteList", param);
		}	
		return paramList;
	}
	
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteList")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertList")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

				if(insertList != null) this.insertList(insertList, dataMaster, user);
				if(updateList != null) this.updateList(updateList, dataMaster, user);				
				if(deleteList != null) this.deleteList(deleteList, dataMaster, user);
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	
	
	/**
     * 
     * 엑셀의 내용을 읽어옴
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
//    	String arr[] = param.toString().split(",");
//		for(int i=0;i<arr.length;i++){
//			System.out.println(arr[i]);
//		}
        return super.commonDao.list("s_hpa700ukrServiceImpl_KOCIS.selectExcelUploadSheet1", param);
    }
    
    public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("s_hpa700ukrServiceImpl_KOCIS.excelValidate", param);
	}
	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)		// 엑셀데이터 저장
    public void saveExcelData(Map param) throws Exception {
        super.commonDao.update("s_hpa700ukrServiceImpl_KOCIS.saveExcel", param);
    }
	
}
	
