package foren.unilite.modules.human.hpa;

import java.util.List;
import org.slf4j.Logger;

import java.util.Map;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hpa300ukrService")
public class Hpa300ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	// 건강보험에 노인장기요양보험 포함여부 조회
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public Map<String, Object> selectHealthInsurance(Map param) throws Exception {		
			
		return (Map)super.commonDao.select("hpa300ukrServiceImpl.selectHealthInsurance", param);	
	}
	
	// 건강보험, 노인요양보험 요율 조회
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectInsuranceRate(Map param) throws Exception {		
		
		return (List)super.commonDao.list("hpa300ukrServiceImpl.selectInsuranceRate", param);	
	}
	
	
	// 리스트 조회
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
			
		return (List) super.commonDao.list("hpa300ukrServiceImpl.selectList", param);	
	}	

	// 기준액, 보험금액 저장
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{			
			super.commonDao.update("hpa300ukrServiceImpl.update", param);							
		}
		return paramList;
	}

	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else 
				if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			
			if(updateList != null) this.update(updateList);
		}
		paramList.add(0, paramMaster);

		return paramList;
		
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
    	String arr[] = param.toString().split(",");
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
        return super.commonDao.list("hpa300ukrServiceImpl.selectExcelUploadSheet1", param);
    }
    
    
    public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("hpa300ukrServiceImpl.excelValidate", param);
	}
	
	
}
	
