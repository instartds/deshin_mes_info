package foren.unilite.modules.human.ham;

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
import foren.unilite.utils.AES256EncryptoUtils;

@Service( "ham805ukrService" )
public class Ham805ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 엑셀업로드
     * 
     * @param param
     * @return
     * @throws Exception
     */
    public void excelValidate( String jobID, Map param ) {							// 엑셀 Validate
        //주민등록번호 암호화
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        String returnStr = "";
        //에러메세지 처리
        String errorDesc = "";
        
        List<Map> getData = (List<Map>)super.commonDao.list("ham805ukrService.getData", param);
        if (!getData.isEmpty()) {
            for (Map data : getData) {
                String repreNum = (String)data.get("REPRE_NUM");
                returnStr = encrypto.getEncrypto("1", repreNum);
                param.put("REPRE_NUM_EXPOS", returnStr);
                param.put("_EXCEL_ROWNUM", (Integer)data.get("_EXCEL_ROWNUM"));
                super.commonDao.update("ham805ukrService.encryTo", param);
                
            }
            //SP 호출시 넘길 MAP 정의
            Map<String, Object> spParam = new HashMap<String, Object>();
            //            String payYyyymm = ((String) param.get("PAY_YYYYMM")).substring(0,6);
            
            logger.debug("validate: {}", jobID);
            spParam.put("COMP_CODE", param.get("S_COMP_CODE"));
            spParam.put("EXCEL_JOBID", param.get("_EXCEL_JOBID"));
            spParam.put("LANG_TYPE", param.get("S_LANG_CODE"));
            spParam.put("LOGIN_ID", param.get("S_USER_ID"));
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("ham805ukrService.excelValidate", spParam);
            
            //SP에서 오류발생 했을 때, HPB120T_XLS에 해당 메세지 INSERT
            errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                param.put("MSG", errorDesc + " 오류 입니다. \n 데이터를 확인하세요.");
                super.commonDao.update("ham805ukrService.insertErrorMsg", param);
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
        return super.commonDao.select("ham805ukrService.getErrMsg", param);
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
        return super.commonDao.update("ham805ukrService.deleteTemp", param);
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
        return super.commonDao.list("ham805ukrService.getGubun", param);
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
        return super.commonDao.list("ham805ukrService.fnGetBusinessCode", param);
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
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {
            List<Map> decList = (List<Map>)super.commonDao.list("ham805ukrService.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("REPRE_NUM_EXPOS", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
                        } catch (Exception e) {
                            decMap.put("REPRE_NUM_EXPOS", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("REPRE_NUM_EXPOS", "");
                    }
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("ham805ukrService.selectList", param);
        }
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
        return (List)super.commonDao.list("ham805ukrService.userDept", param);
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
        return (Map)super.commonDao.select("ham805ukrService.checkPersonNumb", param);
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
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )		// INSERT
    public Integer insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("ham805ukrService.insertList", param);
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
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )		// UPDATE
    public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            
            super.commonDao.update("ham805ukrService.updateList", param);
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
    
    @ExtDirectMethod( group = "hpb", needsModificatinAuth = true )		// DELETE
    public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("ham805ukrService.deleteList", param);
        }
        
        return 0;
    }
}
