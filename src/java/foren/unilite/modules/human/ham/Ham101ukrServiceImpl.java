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

@Service( "ham101ukrService" )
public class Ham101ukrServiceImpl extends TlabAbstractServiceImpl {
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
            List<Map> decList = (List<Map>)super.commonDao.list("ham101ukrServiceImpl.selectList", param);
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
            return (List)super.commonDao.list("ham101ukrServiceImpl.selectList", param);
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
        return super.commonDao.list("ham101ukrServiceImpl.divList", param);
    }
    
    /**
     * HAM800T 데이터 유무 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hum" )
    public Object existsHam800t( Map param ) throws Exception {
        return super.commonDao.select("ham101ukrServiceImpl.existsHam800t", param);
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
            if (deleteList != null) this.deleteList(deleteList, user, paramMaster);
            if (insertList != null) this.insertList(insertList, user, paramMaster);
            if (updateList != null) this.updateList(updateList, user, paramMaster);
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
    public List<Map> insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            for (Map param : paramList) {
                //자동채번이 "Y"이면
                if (!ObjUtils.isEmpty(dataMaster.get("AUTO_CODE")) && dataMaster.get("AUTO_CODE").equals("Y")) {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    List<Map> customCode = (List<Map>)super.commonDao.list("ham101ukrServiceImpl.getAutoCustomCode", compCodeMap);
                    if (!customCode.isEmpty()) {
                        param.put("PERSON_NUMB", String.format("%06d", ObjUtils.parseInt(customCode.get(0).get("CUSTOM_CODE"))));
                    }
                    
                    String checkValue1 = "";
                    //bcm100t에 있는 주민등록번호과 비교
                    List<Map> checkTopNum = (List<Map>)super.commonDao.list("ham101ukrServiceImpl.checkTopNum", param);
                    if (!checkTopNum.isEmpty()) {
                        checkValue1 = ObjUtils.getSafeString(checkTopNum.get(0).get("CUSTOM_CODE"));
                        param.put("PERSON_NUMB", checkValue1);
                        
                        super.commonDao.insert("ham101ukrServiceImpl.insertList", param);
                        super.commonDao.update("ham101ukrServiceImpl.updateListAutoCustom", param);
                        
                    } else {
                        super.commonDao.insert("ham101ukrServiceImpl.insertList", param);
                        super.commonDao.update("ham101ukrServiceImpl.insertListAutoCustom", param);
                    }
                    //
                    if (ObjUtils.isNotEmpty(param.get("BANK_ACCOUNT1"))) {
                        //bcm130t에 있는 계좌번호와 비교
                        List<Map> checkBankBookNum = (List<Map>)super.commonDao.list("ham101ukrServiceImpl.checkBankBookNum", param);
                        
                        //UPDATE 시, BOOK_NAME 생성. 은행이름+계좌번호 뒤 5자리
                        String returnStr = "";
                        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
                        
                        String bankAccnt = (String)param.get("BANK_ACCOUNT1");
                        returnStr = decrypto.getDecrypto("1", bankAccnt);
                        param.put("BANK_ACCOUNT_DEC", returnStr);
                        
                        if (checkBankBookNum.isEmpty()) {
                            super.commonDao.insert("ham101ukrServiceImpl.insertListAutoBankAccount", param);
                        } else {
                            super.commonDao.insert("ham101ukrServiceImpl.updateListAutoBankAccount", param);
                            
                        }
                    }
                    
                } else {
                    super.commonDao.insert("ham101ukrServiceImpl.insertList", param);
                    
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
    public List<Map> updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            //            if (!ObjUtils.isEmpty(dataMaster.get("AUTO_CODE")) && dataMaster.get("AUTO_CODE").equals("Y")){
            //			    super.commonDao.update("ham101ukrServiceImpl.updateList", param);
            //                super.commonDao.update("ham101ukrServiceImpl.updateListAutoCustom", param);
            //            }
            
            if (!ObjUtils.isEmpty(param.get("BANK_ACCOUNT1"))) {
                //bcm130t에 있는 계좌번호와 비교
                List<Map> checkBankBookNum = (List<Map>)super.commonDao.list("ham101ukrServiceImpl.checkBankBookNum", param);
                
                //UPDATE 시, BOOK_NAME 생성. 은행이름+계좌번호 뒤 5자리
                String returnStr = "";
                AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
                
                String bankAccnt = (String)param.get("BANK_ACCOUNT1");
                returnStr = decrypto.getDecrypto("1", bankAccnt);
                param.put("BANK_ACCOUNT1_EXPOS", returnStr);
                
                if (checkBankBookNum.isEmpty()) {
                    super.commonDao.insert("ham101ukrServiceImpl.insertListAutoBankAccount", param);
                } else {
                    super.commonDao.insert("ham101ukrServiceImpl.updateListAutoBankAccount", param);
                }
            }
            super.commonDao.update("ham101ukrServiceImpl.updateList", param);
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
    public List<Map> deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("ham101ukrServiceImpl.deleteList", param);
            super.commonDao.delete("ham101ukrServiceImpl.deleteListAutoBankAccount", param);
        }
        return paramList;
    }
}
