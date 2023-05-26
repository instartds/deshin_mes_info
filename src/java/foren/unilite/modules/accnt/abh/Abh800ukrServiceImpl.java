package foren.unilite.modules.accnt.abh;

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

@Service( "abh800ukrService" )
public class Abh800ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 자금집금내역등록(abh800ukr) 조회
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "Accnt" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("abh800ukrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("OUT_ACCT_NO"))) {   //출금계좌번호
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("OUT_ACCT_NO_EXPOS", decrypto.decryto(decMap.get("OUT_ACCT_NO").toString(), "RB"));
                        } catch (Exception e) {
                            decMap.put("OUT_ACCT_NO_EXPOS", "데이타 오류(" + decMap.get("OUT_ACCT_NO").toString() + ")");
                        }
                    } else {
                        decMap.put("OUT_ACCT_NO_EXPOS", "");
                    }
                    
                    if (!ObjUtils.isEmpty(decMap.get("IN_ACCT_NO"))) {    //입금계좌번호
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("IN_ACCT_NO_EXPOS", decrypto.decryto(decMap.get("IN_ACCT_NO").toString(), "RB"));
                        } catch (Exception e) {
                            decMap.put("IN_ACCT_NO_EXPOS", "데이타 오류(" + decMap.get("IN_ACCT_NO").toString() + ")");
                        }
                    } else {
                        decMap.put("IN_ACCT_NO_EXPOS", "");
                    }
                    
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("abh800ukrServiceImpl.selectList", param);
        }
    }
    
    /**
     * 자금집금내역등록(abh800ukr) 저장
     **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> updateList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            
            if (updateList != null) {
                this.updateDetail(updateList, user, dataMaster);
            }
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 자금집금내역등록(abh800ukr) 수정
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            String companyNum = (String)param.get("COMPANY_NUM");
            param.put("COMPANY_NUM", companyNum.replaceAll("-", ""));
            super.commonDao.insert("abh800ukrServiceImpl.updateDetail", param);
        }
        return 0;
    }
    
    /**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
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
                }
            }
            if (insertList != null) this.runProcedure(insertList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    private void runProcedure( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        //        try {
        String keyValue = getLogKey();
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.insert("abh800ukrServiceImpl.insertLogTable", param);
        }
        
        Map<String, Object> paramMap = (Map<String, Object>)paramMaster.get("data");
        Map<String, Object> spParam = new HashMap<String, Object>();
        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("INPUT_DATE", paramMap.get("AC_DATE"));
        spParam.put("WORK_GUBUN", paramMap.get("WORK_DATE"));
        spParam.put("CALL_PATH", paramMap.get("BTN_FLAG"));
        spParam.put("S_USER_ID", user.getUserID());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("LANG_TYPE", user.getLanguage());
        
        if (!paramMap.get("BTN_FLAG").equals("IC")) {
            super.commonDao.queryForObject("abh800ukrServiceImpl.USP_ACCNT_AutoSlip75", spParam);
        } else {
            super.commonDao.queryForObject("abh800ukrServiceImpl.USP_ACCNT_AutoSlip75Cancel", spParam);
        }
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(messsage[0], user));
        }
        
        //        } catch(Exception e) {
        //            throw new  UniDirectValidateException(this.getMessage("2627", user));
        //        }
        
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //super.commonDao.insert("abh800ukrServiceImpl.runProcedure", param);
        
        return;
    }
    
    /**
     * 집금 데이터 가져오기
     * 
     * @param paramList
     * @param paramMaster
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Map getCollectionData( Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster;
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        List<Map<Object, String>> afs100List = null;
        String errorDesc = "";
        /*
         * try { afs100List = super.commonDao.list("abh800ukrServiceImpl.selectAfs100TList", null); if (afs100List.size() > 0) { for (Map map : afs100List) { // 암호화된 계좌번호를 복호화함. map.put("BANK_ACCOUNT_ORG", decryp.getDecrypto("1", (String)map.get("BANK_ACCOUNT"))); super.commonDao.update("abh800ukrServiceImpl.updateAfs100T", map); } } } catch (Exception e) { e.printStackTrace(); throw new Exception(e.getMessage()); }
         */
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("LANG_TYPE", langType);
        spParam.put("USER_ID", user.getUserID());
        spParam.put("ERROR_DESC", "");
        super.commonDao.queryForObject("abh800ukrServiceImpl.getCollectionData", spParam);
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else { //계좌번호 암호화 
            List<Map<String, Object>> acctList = null;
            Map prm = null;
            
            try {
                acctList = super.commonDao.list("abh800ukrServiceImpl.selectAcctList", prm);
                
                if (!ObjUtils.isEmpty(acctList)) {
                    if (acctList.size() > 0) {
                        for (Map map : acctList) {
                            //	                    map.put("OUT_ACCT_NO", seed.encryto((String)map.get("OUT_ACCT_NO")));
                            //	                    map.put("IN_ACCT_NO", seed.encryto((String)map.get("IN_ACCT_NO")));
                            
                            //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                            map.put("OUT_ACCT_NO", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("OUT_ACCT_NO"))));
                            map.put("IN_ACCT_NO", encrypto.encryto(decrypto.getDecrypto("1", (String)map.get("IN_ACCT_NO"))));
                            map.put("JOB_YN", "Y");
                            super.commonDao.update("abh800ukrServiceImpl.updateAcct", map);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new Exception(e.getMessage());
            }
        }
        /*
         * try { afs100List = super.commonDao.list("abh800ukrServiceImpl.selectAfs100TList", null); if (afs100List.size() > 0) { for (Map map : afs100List) { // 암호화된 계좌번호를 복호화함. map.put("BANK_ACCOUNT_ORG", seed.encryto(decryp.getDecrypto("1", (String)map.get("BANK_ACCOUNT")))); super.commonDao.update("abh800ukrServiceImpl.updateAfs100T", map); } } } catch (Exception e) { e.printStackTrace(); throw new Exception(e.getMessage()); }
         */
        return paramMaster;
    }
}
