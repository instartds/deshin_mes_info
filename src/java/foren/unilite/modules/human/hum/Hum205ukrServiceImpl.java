package foren.unilite.modules.human.hum;

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
import foren.unilite.utils.AES256DecryptoUtils;


@Service("hum205ukrService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class Hum205ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 발령등록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hum205ukrServiceImpl.selectList", param);
	}
	
	

	/**
	 * 발령등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
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
			if(deleteList != null) this.deleteList(deleteList);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		try{
			for(Map param :paramList ) {
				super.commonDao.insert("hum205ukrServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}	
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hum205ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hum205ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	

	
	
	
	
    /**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> callProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("runProcedure")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            if (insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.insert("hum205ukrServiceImpl.insertLogTable", param);
        }
        
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (1:일괄발령, 2:발령취소)
        String workGb = (String)dataMaster.get("WORK_GB");
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        String errorDesc = "";
        
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //발령취소이면..
        if (workGb.equals("2")) {
            
            logger.debug("구분 취소 : {}", spParam);
            for (Map param : paramList) {
            	param.put("WORK_GUBUN"	, workGb);
                param.put("KEY_VALUE", keyValue);
                param.put("LANG_TYPE"	, langType);
                param.put("LOGIN_ID"	, user.getUserID());
                param.put("ERROR_DESC", "");
                super.commonDao.queryForObject("hum205ukrServiceImpl.cancelSlip", param);
            }
            
        //일괄발령이면
        } else if (workGb.equals("1")) {
            logger.debug("구분 반영 : {}", spParam);
            for (Map param : paramList) {
            	param.put("WORK_GUBUN"	, workGb);
                param.put("KEY_VALUE", keyValue);
                param.put("LANG_TYPE"	, langType);
                param.put("LOGIN_ID"	, user.getUserID());
                param.put("ERROR_DESC", "");
                super.commonDao.queryForObject("hum205ukrServiceImpl.runAutoSlip", param);
            }
        }
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        return;
    }
    
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
				
		return super.commonDao.list("hum205ukrServiceImpl.selectExcelUploadSheet", param);
	}
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hum205ukrServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}
    
}
