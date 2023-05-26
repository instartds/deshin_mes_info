package foren.unilite.modules.human.ham;

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

@Service( "ham801ukrService" )
public class Ham801ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 마스터그리드 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {
            List<Map> decList = (List<Map>)super.commonDao.list("ham801ukrServiceImpl.selectList", param);
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
                    
                    if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT1"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("BANK_ACCOUNT1_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT1").toString(), "RB"));
                        } catch (Exception e) {
                            decMap.put("BANK_ACCOUNT1_EXPOS", "데이타 오류(" + decMap.get("BANK_ACCOUNT1").toString() + ")");
                        }
                    } else {
                        decMap.put("BANK_ACCOUNT1_EXPOS", "");
                    }
                    
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("ham801ukrServiceImpl.selectList", param);
        }
    }
    
    /**
     * 작업대상 사업장List조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public List<Map<String, Object>> getDivList( Map param ) throws Exception {
        return super.commonDao.list("ham801ukrServiceImpl.divList", param);
    }
    
    /**
     * 작업대상 사업장List조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public Object existsHam800t( Map param ) throws Exception {
        return super.commonDao.select("ham801ukrServiceImpl.existsHam800t", param);
    }
    
    /**
     * 마스터그리드 저장
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteList(deleteList, user);
            if (insertList != null) this.insertList(insertList, user);
            if (updateList != null) this.updateList(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 선택된 행을 추가함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> insertList( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                param.put("FLAG", "N");
                param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
                Map errorMap = (Map)super.commonDao.select("ham801ukrServiceImpl.USP_HUMAN_HAM801UKR", param);
                if (!ObjUtils.isEmpty(errorMap.get("ERROR_CODE"))) {
                    String errorDesc = (String)errorMap.get("ERROR_CODE");
                    String[] messsage = errorDesc.split(";");
                    throw new UniDirectValidateException(this.getMessage(messsage[0], user));
                }
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return paramList;
    }
    
    /**
     * 선택된 행을 수정함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> updateList( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            param.put("FLAG", "U");
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            Map errorMap = (Map)super.commonDao.select("ham801ukrServiceImpl.USP_HUMAN_HAM801UKR", param);
            if (!ObjUtils.isEmpty(errorMap.get("ERROR_CODE"))) {
                String errorDesc = (String)errorMap.get("ERROR_CODE");
                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(messsage[0], user));
            }
        }
        return paramList;
    }
    
    /**
     * 선택된 행을 삭제함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map> deleteList( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            param.put("FLAG", "D");
            param.put("PAY_YYYYMM", param.get("PAY_YYYYMM").toString().replace(".", ""));
            Map errorMap = (Map)super.commonDao.select("ham801ukrServiceImpl.USP_HUMAN_HAM801UKR", param);
            if (!ObjUtils.isEmpty(errorMap.get("ERROR_CODE"))) {
                String errorDesc = (String)errorMap.get("ERROR_CODE");
                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(messsage[0], user));
            }
        }
        return paramList;
    }
    
}
