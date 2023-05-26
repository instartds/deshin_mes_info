package foren.unilite.modules.human.hrt;

import java.util.List;
import java.util.Map;

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

@Service( "hrt506ukrService" )
public class Hrt506ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 사번으로 임원/직원 여부를 판단함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public Map checkRetroOTKind( Map param ) throws Exception {
        return (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.checkRetroOTKind", param);
    }
    /**
     * 사번으로 퇴직금/중간정산 여부 판단
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
    public Map checkHrtCnt( Map param ) throws Exception {
        return (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.checkHrtCnt", param);
    }
    
    /**
     * 사번으로 중간정산자 퇴직일 여부 판단
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
    public Map checkRetrDate2( Map param ) throws Exception {
        return (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.checkRetrDate2", param);
    }
    
    /**
     * 폼데이터 삭제(정산내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer deleteList( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("COMP_CODE", param.get("COMP_CODE"));
            param.put("PERSON_NUMB", param.get("PERSON_NUMB"));
            param.put("RETR_TYPE", param.get("RETR_TYPE"));
            param.put("RETR_DATE", param.get("RETR_DATE").toString().replace(".", ""));
            cnt += super.commonDao.delete("hrt506ukrServiceImpl.deleteList", param);
        }
        return cnt;
    }
    /**
     * 폼데이터 조회(정산내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hrt" )
    public Map<String, Object> selectFormData01( Map param, LoginVO user ) throws Exception {
        Map rv = null;
        
//    	logger.debug("========================11=============================");
//    	logger.debug("========================22============================");
//    	logger.debug(" SUB_AF_MONTH :" + param.get("SUB_AF_MONTH"));
//    	logger.debug("SUB_AF_DAY :" + param.get("SUB_AF_DAY"));
//    	logger.debug("SUB_BE_MONTH :" + param.get("SUB_BE_MONTH"));
//    	logger.debug("SUB_BE_DAY :" + param.get("SUB_BE_DAY"));
        
        
    	if (param.get("SUB_AF_MONTH") == null || param.get("SUB_AF_MONTH").equals("")){
    		param.put("SUB_AF_MONTH", 0);
    	}
    	if (param.get("SUB_AF_DAY") == null || param.get("SUB_AF_DAY").equals("")){
    		param.put("SUB_AF_DAY", 0);
    	}
    	if (param.get("SUB_BE_MONTH") == null || param.get("SUB_BE_MONTH").equals("")){
    		param.put("SUB_BE_MONTH", 0);
    	}
    	if (param.get("SUB_BE_DAY") == null || param.get("SUB_BE_DAY").equals("")){
    		param.put("SUB_BE_DAY", 0);
    	}
    	

//    	logger.debug("========================33=============================");
//    	logger.debug("========================44============================");
//    	logger.debug(" SUB_AF_MONTH :" + param.get("SUB_AF_MONTH"));
//    	logger.debug("SUB_AF_DAY :" + param.get("SUB_AF_DAY"));
//    	logger.debug("SUB_BE_MONTH :" + param.get("SUB_BE_MONTH"));
//    	logger.debug("SUB_BE_DAY :" + param.get("SUB_BE_DAY"));
    	
    	
        
        rv = (Map)super.commonDao.select("hrt506ukrServiceImpl.selectFormData01", param);
        
        return rv;
    }
    
    /**
     * 퇴직금 재정산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod(group = "human" )
    public Map retireProcStChangedSuppTotal( Map param, LoginVO user ) throws Exception {
        logger.info("param :: {}", param);
        Map rtn = (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.retireProcStChangedSuppTotal", param);
        if(rtn != null && ObjUtils.isNotEmpty(rtn.get("errorDesc")))	{
        	throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(rtn.get("errorDesc")), user));
        }
        return rtn;
    }
    
    /**
     * 퇴직금 재계산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "human" )    
    public Map retireProcStChangedPayment( Map param ) throws Exception {
        logger.info("param :: {}", param);
        
        return (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.retireProcStChangedPayment", param);
    }
    @ExtDirectMethod( group = "hrt" )
    public String chckHrt500t( Map param ) throws Exception {
        return (String) super.commonDao.select("hrt506ukrServiceImpl.chckHrt500t", param);
    }
    

    /**
     * 퇴직금 계산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "hrt" )
    public Map ProcSt( Map param , LoginVO loginVO) throws Exception {
        logger.info("param :: {}", param);
        if("Y".equals(param.get("DELETE_FLAG"))) {
        	super.commonDao.delete("hrt506ukrServiceImpl.deleteList", param);
        }
        Map rtn = (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.ProcSt", param);
        if(rtn != null && ObjUtils.isNotEmpty(rtn.get("errorDesc")))	{
        	throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(rtn.get("errorDesc")), loginVO));
        }
        return rtn;
    }
    
    /**
     * (정산내역)폼 저장
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "hrt" )
    public ExtDirectFormPostResult submitFormData01( Hrt506ukrModel hrt506ukrModel, LoginVO loginVO, BindingResult result ) throws Exception {
    	hrt506ukrModel.setS_COMP_CODE(loginVO.getCompCode());
        hrt506ukrModel.setS_USER_ID(loginVO.getUserID());
        logger.info("getDEF_TAX_I :: {}",hrt506ukrModel.getDEF_TAX_I());
        super.commonDao.update("hrt506ukrServiceImpl.submitFormData01", hrt506ukrModel);
        
        if("OF".equals(hrt506ukrModel.getOT_KIND()))	{
        	super.commonDao.update("hrt506ukrServiceImpl.submitHRT510", hrt506ukrModel);
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
      
        return extResult;
    }
    
    /**
     * 폼데이터 조회(근속내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hrt" )
    public Object selectFormData02( Map param ) throws Exception {
        Object rv = super.commonDao.select("hrt506ukrServiceImpl.selectFormData02", param);
        return rv;
    }
    
    /**
     * 급여내역 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList01( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList01", param);
    }
    
    /**
     * 급여내역 추가
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public Integer insertList01( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.insert("hrt506ukrServiceImpl.insertList01", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 수정함(급여내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer updateList01( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.update("hrt506ukrServiceImpl.updateList01", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 삭제(급여내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer deleteList01( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.delete("hrt506ukrServiceImpl.deleteList01", param);
        }
        return cnt;
    }
    
    /**
     * 기타수당내역 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList02( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList02", param);
    }

    /**
     * 기타수당내역 추가
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public Integer insertList02( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.insert("hrt506ukrServiceImpl.insertList02", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 수정함(기타수당내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer updateList02( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.update("hrt506ukrServiceImpl.updateList02", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 삭제(기타수당내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer deleteList02( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.delete("hrt506ukrServiceImpl.deleteList02", param);
        }
        return cnt;
    }
    
    /**
     * 상여내역 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList03( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList03", param);
    }

    /**
     * 상여내역 추가
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public Integer insertList03( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.insert("hrt506ukrServiceImpl.insertList03", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 수정함(상여내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer updateList03( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.update("hrt506ukrServiceImpl.updateList03", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 삭제(상여내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer deleteList03( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
            cnt += super.commonDao.delete("hrt506ukrServiceImpl.deleteList03", param);
        }
        return cnt;
    }
    
    /**
     * 년월차내역 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList04( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList04", param);
    }

    /**
     * 년월차내역 추가
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map> insertList04( List<Map> paramList, LoginVO loginVO ) throws Exception {
        
        for (Map param : paramList) {
            param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            super.commonDao.insert("hrt506ukrServiceImpl.insertList04", param);
        }
        return paramList;
    }
    
    /**
     * 선택된 행을 수정함(년월차내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer updateList04( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
        	param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.update("hrt506ukrServiceImpl.updateList04", param);
        }
        return cnt;
    }
    
    /**
     * 선택된 행을 삭제(년월차내역)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hrt" )
    public Integer deleteList04( List<Map> paramList, LoginVO loginVO ) throws Exception {
        int cnt = 0;
        for (Map param : paramList) {
        	param.put("BONUS_YYYYMM", param.get("BONUS_YYYYMM").toString().replace(".", ""));
            cnt += super.commonDao.delete("hrt506ukrServiceImpl.deleteList04", param);
        }
        return cnt;
    }
    
    /**
     * 산정내역(임원) 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList05( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList05", param);
    }
    
    /**
     * 중간정산 내역 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "hrt" )
    public List<Map<String, Object>> selectList06( Map param ) throws Exception {
        return (List)super.commonDao.list("hrt506ukrServiceImpl.selectList06", param);
    }
    
    /**
     * 지급총액계산
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public Map<String, Object> fnSuppTotI( Map param ) throws Exception {
    	
    	logger.debug("======================================================");
    	logger.debug("======================================================");
    	logger.debug("SUB_AF_MONTH :" + param.get("SUB_AF_MONTH"));
    	logger.debug("SUB_AF_DAY :" + param.get("SUB_AF_DAY"));
    	logger.debug("SUB_BE_MONTH :" + param.get("SUB_BE_MONTH"));
    	logger.debug("SUB_BE_DAY :" + param.get("SUB_BE_DAY"));
    	
    	
    	
    	
        return (Map)super.commonDao.select("hrt506ukrServiceImpl.fnSuppTotI", param);
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> syncAll01(List<Map> paramList, Map paramMaster, LoginVO loginVO) throws Exception {
        logger.debug("syncAll01(paramList):" + paramList);
        logger.debug("syncAll01(paramMaster):" + paramMaster);
        
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteList01")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertList01")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateList01")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteList01(deleteList, loginVO);
            if(insertList != null) this.insertList01(insertList, loginVO);
            if(updateList != null) this.updateList01(updateList, loginVO);      
        }
        
        Map param = (Map)paramMaster.get("data");
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        param.put("S_LANG_CODE", loginVO.getLanguage());
        retireProcStChangedPayment(param);
        
        paramList.add(0, paramMaster);
        logger.debug("syncAll:" + paramList);
        return  paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> syncAll02(List<Map> paramList, Map paramMaster, LoginVO loginVO) throws Exception {    
        logger.debug("syncAll02(paramList):" + paramList);
        logger.debug("syncAll02(paramMaster):" + paramMaster);
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteList02")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertList02")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateList02")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteList02(deleteList, loginVO);
            if(insertList != null) this.insertList02(insertList, loginVO);
            if(updateList != null) this.updateList02(updateList, loginVO);      
        }
        paramList.add(0, paramMaster);
        logger.debug("syncAll:" + paramList);
        return  paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> syncAll03(List<Map> paramList, Map paramMaster, LoginVO loginVO) throws Exception {    
        logger.debug("syncAll03(paramList):" + paramList);
        logger.debug("syncAll03(paramMaster):" + paramMaster);
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteList03")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertList03")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateList03")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteList03(deleteList, loginVO);
            if(insertList != null) this.insertList03(insertList, loginVO);
            if(updateList != null) this.updateList03(updateList, loginVO);      
        }
        paramList.add(0, paramMaster);
        logger.debug("syncAll:" + paramList);
        return  paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> syncAll04(List<Map> paramList, Map paramMaster, LoginVO loginVO) throws Exception {    
        logger.debug("syncAll04(paramList):" + paramList);
        logger.debug("syncAll04(paramMaster):" + paramMaster);
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteList04")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertList04")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateList04")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteList04(deleteList, loginVO);
            if(insertList != null) this.insertList04(insertList, loginVO);
            if(updateList != null) this.updateList04(updateList, loginVO);      
        }
        paramList.add(0, paramMaster);
        logger.debug("syncAll:" + paramList);
        return  paramList;
    }
}
