package foren.unilite.modules.accnt.aiss;

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

@Service("aiss310ukrvService")
public class Aiss310ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 자산정보엑셀업로드
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	//데이터 조회
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("aiss310ukrvServiceImpl.selectList", param);
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
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateList")) {		
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{	
				super.commonDao.insert("aiss310ukrvServiceImpl.insertList", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}	

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			super.commonDao.update("aiss310ukrvServiceImpl.updateList", param);
		 }
		 return 0;
	} 
	
	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{
			 try {
				super.commonDao.delete("aiss310ukrvServiceImpl.deleteList", param);
				 
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
    public void excelValidate(String jobID, Map param) throws Exception {
	    logger.debug("validate: {}", jobID);
	    //UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("aiss310ukrvServiceImpl.getData", param);
		String ERR_FLAG = "";
		
        if(!getData.isEmpty()){
        	//excel 파일의 데이터 체크
            for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));

                //excel 파일에 ERROR가 있을 경우,
                if(ObjUtils.isNotEmpty(data.get("_EXCEL_ERROR_MSG"))) {
                	ERR_FLAG = "Y";
            	}
                //upload된 데이터에 대한 상각방법이 등록되지 않았을 경우
            	if (ObjUtils.isEmpty(data.get("DEP_CTL"))) {					
                	ERR_FLAG = "Y";
                	param.put("MSG", "계정코드 [" + data.get("ACCNT") +"]에 대한 상각방법이 등록되지 않았습니다.");
            		super.commonDao.update("aiss310ukrvServiceImpl.insertErrorMsg", param);
            	}
            	//원가누적정보 합이 100이 아닌 경우
            	if (!((ObjUtils.parseInt(data.get("SALE_MANAGE_COST")) + ObjUtils.parseInt(data.get("PRODUCE_COST")) + ObjUtils.parseInt(data.get("SALE_COST")) + ObjUtils.parseInt(data.get("SUBCONTRACT_COST")))==100)){
                	ERR_FLAG = "Y";
                	param.put("MSG", "자산코드 [" + data.get("ASST") + "]의 원가누적정보가 잘못 되었습니다.");
            		super.commonDao.update("aiss310ukrvServiceImpl.insertErrorMsg", param);
            	}
            }
            
            //excel파일 data에 오류가 없을 경우, 실제 테이블에 insert
        	if (!ERR_FLAG.equals("Y")) {
                for(Map data : getData )  { 
                    param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
            		super.commonDao.update("aiss310ukrvServiceImpl.excelValidate", param);
                }
        	}
            	
        } 
	}
	/** 에러 메세지 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object getErrMsg(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("aiss310ukrvServiceImpl.getErrMsg", param);
	}	
    
    
    
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> insertList = null;

            for(Map dataListMap: paramList) {
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey(); 
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for(Map param: paramList)      {
        	param.put("KEY_VALUE", keyValue);
        	super.commonDao.insert("aiss310ukrvServiceImpl.insertLogTable", param);
        }       
    
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (A:자동기표, D:기표취소)
        String oprFlag = (String)dataMaster.get("OPR_FLAG");
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        String errorDesc = "";

        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //기표취소이면..
        if (oprFlag.equals("D")) {
            spParam.put("COMP_CODE"	, user.getCompCode());
            spParam.put("KEY_VALUE"	, keyValue);
            spParam.put("OPR_FLAG"	, oprFlag);
            spParam.put("LANG_TYPE"	, langType);
            spParam.put("LOGIN_ID"	, user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("aiss310ukrvServiceImpl.cancelSlip", spParam);
            
        } else {
            spParam.put("COMP_CODE"	, user.getCompCode());
            spParam.put("KEY_VALUE"	, keyValue);
            spParam.put("OPR_FLAG"	, oprFlag);
            spParam.put("LANG_TYPE"	, langType);
            spParam.put("LOGIN_ID"	, user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("aiss310ukrvServiceImpl.runAutoSlip", spParam);
        }
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
        	 if (oprFlag.equals("D")) {
        		 for(Map param: paramList)      {
        			 param.put("APPLY_YN", "N");
        	        super.commonDao.update("aiss310ukrvServiceImpl.updateAssetApply", param);
        	     }    
        	 }else {
        		 for(Map param: paramList)      {
        			 param.put("APPLY_YN", "Y");
        	        super.commonDao.update("aiss310ukrvServiceImpl.updateAssetApply", param);
        	     }    
        	 
        	 }
        }
        return;
    }
}
