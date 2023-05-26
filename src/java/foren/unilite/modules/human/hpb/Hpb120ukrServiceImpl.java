package foren.unilite.modules.human.hpb;

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
import foren.unilite.utils.AES256EncryptoUtils;

@SuppressWarnings( { "rawtypes", "unchecked" } )
@Service( "hpb120ukrService" )
public class Hpb120ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * "엑셀업로드"
     * 
     * @param param
     * @return
     * @throws Exception
     */
    public void excelValidate( String jobID, Map param ) {							// 엑셀 Validate
        //주민등록번호 암호화
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        String repreNum = "";
        String returnStr = "";
        //에러메세지 처리
        String errorDesc = "";
        
        List<Map> getData = (List<Map>)super.commonDao.list("hpb120ukrService.getData", param);
        if (!getData.isEmpty()) {
            for (Map data : getData) {
                repreNum = (String)data.get("REPRE_NUM");
                returnStr = encrypto.getEncrypto("1", repreNum);
                param.put("REPRE_NUM", data.get("REPRE_NUM"));
                param.put("REPRE_NUM_EXPOS", returnStr);
                //param.put("_EXCEL_ROWNUM", (Integer) data.get("_EXCEL_ROWNUM"));            
                super.commonDao.update("hpb120ukrService.encryTo", param);
                
            }
            //SP 호출시 넘길 MAP 정의
            Map<String, Object> spParam = new HashMap<String, Object>();
            String payYyyymm = ( (String)param.get("PAY_YYYYMM") ).substring(0, 6);
            
            logger.debug("validate: {}", jobID);
            spParam.put("COMP_CODE", param.get("S_COMP_CODE"));
            spParam.put("EXCEL_JOBID", param.get("_EXCEL_JOBID"));
            spParam.put("PAY_YYYYMM", payYyyymm);
            spParam.put("LANG_TYPE", param.get("S_LANG_CODE"));
            spParam.put("LOGIN_ID", param.get("S_USER_ID"));
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("hpb120ukrService.excelValidate", spParam);
            
            //SP에서 오류발생 했을 때, HPB120T_XLS에 해당 메세지 INSERT
            errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                param.put("MSG", errorDesc + " 오류 입니다. \n 데이터를 확인하세요.");
                super.commonDao.update("hpb120ukrService.insertErrorMsg", param);
            }
        }
    }
    
    /**
     * 에러 메세지 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getErrMsg( Map param, LoginVO user ) throws Exception {
        return super.commonDao.select("hpb120ukrService.getErrMsg", param);
    }
    
    /**
     * TEMP TABLE(HPB120T_XLS) 삭제
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object deleteTemp( Map param, LoginVO user ) throws Exception {
        return super.commonDao.update("hpb120ukrService.deleteTemp", param);
    }
    
    /**
     * "반영취소" SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> callProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("runProcedure")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                    //runProcedure 호출하여 결과값 dataListMap에 저장
                    dataListMap.put("data", runProcedure(insertList, paramMaster, user));
                }
            }
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public List<Map> runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        
        String langType = (String)dataMaster.get("LANG_TYPE");
        String payYyyymm = (String)dataMaster.get("PAY_YYYYMM");
        
        //2.로그테이블에 KEY_VALUE 업데이트 및 주민등록번호 암호화
        logger.info("paramList() :: {}", paramList.size());
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            
            //로그테이블에 데이터 insert
            logger.info("getSqlSession() :: {}", super.commonDao.getSqlSession());
            super.commonDao.update("hpb120ukrService.insertLogTable", param);
        }
        
        //2. SP 실행
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("PAY_YYYYMM", payYyyymm);
        spParam.put("LANG_TYPE", langType);
        spParam.put("LOGIN_ID", user.getUserID());
        spParam.put("ERROR_DESC", "");
        super.commonDao.update("hpb120ukrService.runProcedure", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        return paramList;
    }
    
    /**
     * 법인/개인 구분 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpb" )
    public List<Map<String, Object>> getGubun( Map param, LoginVO user ) throws Exception {
        return super.commonDao.list("hpb120ukrService.getGubun", param);
    }
    
    /**
     * 법인/개인 구분 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpb" )
    public List<Map> fnGetBusinessCode( Map param, LoginVO user ) throws Exception {
        return super.commonDao.list("hpb120ukrService.fnGetBusinessCode", param);
    }
    
    /**
     * 사업기타소득 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpb" )
    public List<Map> selectList( Map param, LoginVO user ) throws Exception {
        return super.commonDao.list("hpb120ukrService.selectList", param);
    }
    
    /**
     * 부서 조회 권한
     * 
     * @param param
     * @return
     * @throws Exception
     */
    public List userDept( LoginVO loginVO ) throws Exception {
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        return (List)super.commonDao.list("hpb120ukrService.userDept", param);
    }
    
    /**
     * 소득자코드 중복 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hpb" )
    public Map checkPersonNumb( Map param ) throws Exception {
        return (Map)super.commonDao.select("hpb120ukrService.checkPersonNumb", param);
    }
    
    /**
     * 결과폼 저장
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hpb" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (insertList != null) this.insertDetail(insertList, user);
            if (updateList != null) this.updateDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 추가를 위한 더미 메소드 실제 동작은 form post를 통해서 이루어짐
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    // INSERT
    public Integer insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("hpb120ukrService.insertList", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return 0;
    }
    
    /**
     * 수정을 위한 더미 메소드 실제 동작은 form post를 통해서 이루어짐
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    // UPDATE
    public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            
            super.commonDao.update("hpb120ukrService.updateList", param);
        }
        return 0;
    }
    
    /**
     * 선택된 행을 삭제함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod( group = "hpb", needsModificatinAuth = true )
    // DELETE
    public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("hpb120ukrService.deleteList", param);
        }
        
        return 0;
    }
}
