package foren.unilite.modules.human.hpa;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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


@Service("hpa301ukrService")
public class Hpa301ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 마스터 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
		
		return (List) super.commonDao.list("hpa301ukrServiceImpl.selectList", param);		
	}	
	
	/**
	 * 저장 반영 or 취소
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
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
			if(deleteList != null) this.deleteDetail(deleteList);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
		
//		List<Map> dataList = new ArrayList<Map>();		
//		for(Map paramData: paramList) {
//			dataList = (List<Map>) paramData.get("data");
//			
//			Map submitList = null;
//			Map cancelList = null;
//			for(Map param:  dataList) {
//				if(param.get("FLAG").equals("U")){
//					submitList = param;
//					this.submitMaster(submitList);
//				}else{
//					cancelList = param;
//					this.cancelMaster(cancelList);
//				}								
//			}			
//		}	
//		paramList.add(0, paramMaster);		
//		return  paramList;
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> paramList, LoginVO loginVO) throws Exception {		
		try{
			for (Map param : paramList) {
				super.commonDao.insert("hpa301ukrServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}
			
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> paramList)
			throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("hpa301ukrServiceImpl.updateDetail", param);
			if(param.get("FLAG").equals("U")){
				super.commonDao.update("hpa301ukrServiceImpl.applyMaster", param);
			}else if(param.get("FLAG").equals("D")){
				super.commonDao.update("hpa301ukrServiceImpl.cancelMaster", param);
			}
		}
		return paramList;
	}
		
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
	public List<Map> deleteDetail(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hpa301ukrServiceImpl.deleteDetail", param);
		}
		return paramList;
	}
	
	/**
	 * 인사정보반영
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int applyMaster(Map param) throws Exception {
		return (int)super.commonDao.update("hpa301ukrServiceImpl.applyMaster", param);
		
	}
	
	/**
	 * 인사정보취소
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int cancelMaster(Map param) throws Exception {
		return (int)super.commonDao.update("hpa301ukrServiceImpl.cancelMaster", param);
		
	}
	
	/**
	 * excel validator 체크
	 */
	public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
	    logger.debug("param >> " + param);
		super.commonDao.update("hpa301ukrServiceImpl.excelValidate", param);
	}
	
	/**
     * 
     * 엑셀의 내용을 읽어옴
     */
    @ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
        return super.commonDao.list("hpa301ukrServiceImpl.selectExcelUploadSheet", param);
    }
    
    
    @ExtDirectMethod(group = "hum")
	public Object  getMonthInsurI(Map param) throws Exception {		
		return  super.commonDao.select("hpa301ukrServiceImpl.getMonthInsurI", param);
	}
	
}
