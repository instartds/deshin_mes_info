package foren.unilite.modules.accnt.abh;

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
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

@Service( "abh220ukrService" )
public class Abh220ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * CMS_ID 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getCmsId( Map param ) throws Exception {
        return super.commonDao.select("abh220ukrServiceImpl.getCmsId", param);
    }
    
    /**
     * 신규추가시 계정코드 셋팅 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getAccntCode( Map param ) throws Exception {
        return super.commonDao.select("abh220ukrServiceImpl.getAccntCode", param);
    }
    
    /**
     * 이체지급확정 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        String returnStr = "";
        
        //카드번호 param 암호화 
        if (!ObjUtils.isEmpty(param.get("CRDT_NUM"))) {
            String crdtFullNum = (String)param.get("CRDT_NUM");
            returnStr = encrypto.encryto(crdtFullNum);
            param.put("CRDT_NUM", returnStr);
        }
        if (param.get("DEC_FLAG").equals("Y")) {
            List<Map> decList = (List<Map>)super.commonDao.list("abh220ukrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            // 현업요구사항에 의해 전부 복호화함. - 2017.03.24
                            //decMap.put("BANK_ACCOUNT_EXPOS", seed.decryto(decMap.get("BANK_ACCOUNT").toString(), "RB"));
                            decMap.put("BANK_ACCOUNT_EXPOS", decrypto.getDecrypto("1", decMap.get("BANK_ACCOUNT").toString()));
                        } catch (Exception e) {
                            decMap.put("BANK_ACCOUNT_EXPOS", "데이타 오류(" + decMap.get("BANK_ACCOUNT").toString() + ")");
                        }
                    } else {
                        decMap.put("BANK_ACCOUNT_EXPOS", "");
                    }
                    
                    if (!ObjUtils.isEmpty(decMap.get("CRDT_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            // 현업요구사항에 의해 전부 복호화함. - 2017.03.24
                            //decMap.put("CRDT_NUM_EXPOS", seed.decryto(decMap.get("BANK_ACCOUNT").toString(), "RC"));
                            decMap.put("CRDT_NUM_EXPOS", decrypto.getDecrypto("1", decMap.get("CRDT_NUM").toString()));
                        } catch (Exception e) {
                            decMap.put("CRDT_NUM_EXPOS", "데이타 오류(" + decMap.get("CRDT_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("CRDT_NUM_EXPOS", "");
                    }
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("abh220ukrServiceImpl.selectList", param);
        }
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
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
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("abh220ukrServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("abh220ukrServiceImpl.updateDetail", param);
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    /**
     * 이체지급확정 sub조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectSubList( Map param ) throws Exception {
        return super.commonDao.list("abh220ukrServiceImpl.selectSubList", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> subSaveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteSubDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertSubDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateSubDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteSubDetail(deleteList, user);
            if (insertList != null) this.insertSubDetail(insertList, user);
            if (updateList != null) this.updateSubDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertSubDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("abh220ukrServiceImpl.insertSubDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateSubDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("abh220ukrServiceImpl.updateSubDetail", param);
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteSubDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("abh220ukrServiceImpl.deleteSubDetail", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return;
    }
    
    /**
     * 확정,미확정, 보류,보류해제, 버튼 관련
     **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetailButton")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetailButton")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetailButton")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetailButton(deleteList, user);
            if (insertList != null) this.insertDetailButton(insertList, user, paramMaster);
            if (updateList != null) this.updateDetailButton(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertDetailButton( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            
            String buttonFlag = (String)dataMaster.get("BUTTON_FLAG");
            for (Map param : paramList) {
                if (buttonFlag.equals("BC")) {//확정
                    if (param.get("CONFIRM_YN").equals("N") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                        param.put("OUT_BANK_CODE", dataMaster.get("OUT_BANK_CODE"));
                        param.put("OUT_SAVE_CODE", dataMaster.get("OUT_SAVE_CODE"));
                        
                        if (param.get("SET_METH").equals("10")) { //예금
                            param.put("TRANS_YN", "Y");
                        } else if (param.get("SET_METH").equals("13")) { //현금
                            param.put("TRANS_YN", "N");
                        } else if (param.get("SET_METH").equals("16")) { //대체
                            param.put("TRANS_YN", "N");
                        } else if (param.get("SET_METH").equals("25")) {//어음만기시
                            param.put("TRANS_YN", "N");
                        } else if (param.get("SET_METH").equals("30")) { //어음발행시
                            param.put("TRANS_YN", "Y");
                        } else {
                            param.put("TRANS_YN", "N");
                        }
                        
                        super.commonDao.insert("abh220ukrServiceImpl.btnConfirm", param);
                    }
                } else if (buttonFlag.equals("BCC")) {//미확정
                    if (param.get("CONFIRM_YN").equals("Y") && /* param.get("PAYMENT_STATUS_DETAIL").equals("10") && */ObjUtils.isEmpty(param.get("EX_DATE"))) {
                        super.commonDao.delete("abh220ukrServiceImpl.btnConfirmCancel", param);
                    }
                } else if (buttonFlag.equals("BH")) {//보류     
                    if (param.get("CONFIRM_YN").equals("Y") && param.get("PAYMENT_STATUS_DETAIL").equals("10") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                        param.put("CONFIRM_YN", "C");
                        super.commonDao.update("abh220ukrServiceImpl.updateHold", param);
                    }
                } else if (buttonFlag.equals("BHC")) {//보류해제 
                    if (param.get("CONFIRM_YN").equals("C") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                        param.put("CONFIRM_YN", "Y");
                        super.commonDao.update("abh220ukrServiceImpl.updateHold", param);
                    }
                }
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetailButton( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDetailButton( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    /** 결재요청 버튼 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllRequest( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        String keyValue = getLogKey();
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if (paramList != null) {
            for (Map param : paramList) {
                
                //                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("insertDetailRequest")) {
                    param.put("data", insertRequestLogDetails(dataList, keyValue, "N"));
                }
            }
        }
        
        Map<String, Object> spParam = new HashMap<String, Object>();
        
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("APRV_TYPE", "TP");
        spParam.put("SLIP_TYPE", "");
        spParam.put("USER_ID", user.getUserID());
        super.commonDao.queryForObject("uspJoinsAccntAprvCheckAbh220ukr", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            //            dataMaster.put("ELEC_SLIP_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            
            Map<String, Object> spParam2 = new HashMap<String, Object>();
            
            spParam2.put("COMP_CODE", user.getCompCode());
            spParam2.put("KEY_VALUE", keyValue);
            spParam2.put("APRV_TYPE", "TP");
            spParam2.put("USER_ID", user.getUserID());
            super.commonDao.queryForObject("uspJoinsAccntAprvBufAbh220ukr", spParam2);
            
            String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));
            
            if (!ObjUtils.isEmpty(errorDesc2)) {
                //                dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc2.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc2, user));
            } else {
                
                Map<String, Object> spParam3 = new HashMap<String, Object>();
                
                spParam3.put("COMP_CODE", user.getCompCode());
                spParam3.put("KEY_VALUE", keyValue);
                spParam3.put("APRV_TYPE", "TP");
                spParam3.put("USER_ID", user.getUserID());
                super.commonDao.queryForObject("uspJoinsAccntAprvMainAbh220ukr", spParam3);
                
                String errorDesc3 = ObjUtils.getSafeString(spParam3.get("ErrorDesc"));
                
                if (!ObjUtils.isEmpty(errorDesc3)) {
                    //                    dataMaster.put("ELEC_SLIP_NO", "");
                    String[] messsage = errorDesc3.split(";");
                    throw new UniDirectValidateException(this.getMessage(errorDesc3, user));
                } else {
                    
                }
                
            }
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertRequestLogDetails( List<Map> params, String keyValue, String oprFlag ) throws Exception {
        
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            
            if (!ObjUtils.isEmpty(param.get("EX_DATE"))) {
                super.commonDao.insert("abh220ukrServiceImpl.insertRequestLogDetail", param);
            }
            
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailRequest( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
    /** CMS 관련 버튼 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllCmsButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        String keyValue = getLogKey();
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        String buttonFlag = (String)dataMaster.get("CMS_BUTTON_FLAG");
        
        List<Map> dataList = new ArrayList<Map>();
        
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("insertDetailCmsButton")) {
                    param.put("data", insertLogDetailsCms(dataList, keyValue, buttonFlag));
                }
            }
        }
        
        if (buttonFlag.equals("SEND")) {
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAbh220ukrFnBanknameQuery", spParam);
            logger.info("spParam :: {}", spParam);
            String rtnValue = ObjUtils.getSafeString(spParam.get("RTN_VALUE"));
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            String FIELD_002 = null;
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
                // 1. 복호화 
                // 2. BRANCH.ERP_HEADER, branch.ERP_HEADER INSERT
                Map param = new HashMap();
                param.put("KEY_VALUE", rtnValue);
                
                List<Map<String, Object>> Hlist = (List<Map<String, Object>>)super.commonDao.list("abh220ukrServiceImpl.getTempHeader", param);
                List<Map<String, Object>> Dlist = (List<Map<String, Object>>)super.commonDao.list("abh220ukrServiceImpl.getTempBody", param);
                
                for (Map<String, Object> map : Hlist) {
                    logger.info("map :: {}", map);
                    
                    super.commonDao.insert("abh220ukrServiceImpl.insTempToHeader", map);
                }
                
                for (Map<String, Object> map : Dlist) {
                    FIELD_002 = map.get("FIELD_002") == null ? "" : (String)map.get("FIELD_002");
                    if (!FIELD_002.equals("") && FIELD_002.length() > 0) {
                        FIELD_002 = decrypto.getDecrypto("1", FIELD_002);
                    }
                    map.put("FIELD_002", FIELD_002);
                    map.put("RTN_VALUE", rtnValue);
                    
                    logger.info("map :: {}", map);
                    
                    super.commonDao.insert("abh220ukrServiceImpl.updtTempToBody", map);
                    
                    super.commonDao.insert("abh220ukrServiceImpl.insTempToBody", map);
                }
            }
        } else if (buttonFlag.equals("RECEIVE")) {
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_WORK_GB", "5");
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAbh220ukrFnBankNameresult", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {/*
                     * super.commonDao.queryForObject("spUspAccntAbh220ukrFnBankNameresult2", spParam); String errorDesc2 = ObjUtils.getSafeString(spParam.get("ERROR_DESC")); if(!ObjUtils.isEmpty(errorDesc2)){ throw new UniDirectValidateException(this.getMessage(errorDesc2, user)); }
                     */}
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetailsCms( List<Map> params, String keyValue, String buttonFlag ) throws Exception {
        
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            if (param.get("CONFIRM_YN").equals("Y") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                if (buttonFlag.equals("RECEIVE")) {
                    //                    String rcptId = (String) param.get("RCPT_ID");
                    //                    if(rcptId != null && !"".equals(rcptId)){
                    
                    if (param.get("CMS_TRANS_YN").equals("Y")) {
                        super.commonDao.insert("abh220ukrServiceImpl.insertLogDetailCms", param);
                    }
                } else {
                    super.commonDao.insert("abh220ukrServiceImpl.insertLogDetailCms", param);
                }
            }
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailCmsButton( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
    /** 자동기표or기표취소 버튼 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllAutoSlipButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        String keyValue = getLogKey();
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        String buttonFlag = (String)dataMaster.get("AUTO_SLIP_BUTTON_FLAG");
        String cmsId = (String)dataMaster.get("CMS_ID");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if (paramList != null) {
            for (Map param : paramList) {
                //                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
                param.put("data", insertLogDetailsAutoSlip(dataList, keyValue, buttonFlag, cmsId));
            }
        }
        if (buttonFlag.equals("BATCH")) {	//자동기표
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("IN_EX_DATE", dataMaster.get("IN_EX_DATE"));
            spParam.put("S_USER_ID", user.getUserID());
            spParam.put("S_LANG_CODE", user.getLanguage());
            super.commonDao.queryForObject("spUspAccntAutoSlip69", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                //            	String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            }
        } else if (buttonFlag.equals("CANCEL")) {	//기표취소
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_USER_ID", user.getUserID());
            spParam.put("S_LANG_CODE", user.getLanguage());
            super.commonDao.queryForObject("spUspAccntAutoSlip69Cancel", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                //            	String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            }
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetailsAutoSlip( List<Map> params, String keyValue, String buttonFlag, String cmsId ) throws Exception {
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            //            param.put("OPR_FLAG", oprFlag); 
            if (buttonFlag.equals("BATCH")) {
                if (!ObjUtils.isEmpty(cmsId)) {
                    if (param.get("CONFIRM_YN").equals("Y") && ObjUtils.isEmpty(param.get("EX_DATE")) && param.get("CMS_TRANS_YN").equals("Y")) {
                        super.commonDao.insert("abh220ukrServiceImpl.insertLogDetailAutoSlip", param);
                    }
                } else {
                    if (param.get("CONFIRM_YN").equals("Y") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                        super.commonDao.insert("abh220ukrServiceImpl.insertLogDetailAutoSlip", param);
                    }
                }
            } else if (buttonFlag.equals("CANCEL")) {
                if (param.get("CONFIRM_YN").equals("Y") && !ObjUtils.isEmpty(param.get("EX_DATE"))) {
                    super.commonDao.insert("abh220ukrServiceImpl.insertLogDetailAutoSlip", param);
                }
            }
            
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailAutoSlipButton( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
    /** 이체지급 버튼 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllAbh200SaveButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        //        String keyValue = getLogKey();  
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //        String buttonFlag = (String) dataMaster.get("AUTO_SLIP_BUTTON_FLAG");
        //        String cmsId= (String) dataMaster.get("CMS_ID");
        
        Map<String, Object> spParam = new HashMap<String, Object>();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        Date dateGet = new Date();
        String dateGetString = dateFormat.format(dateGet);
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("DIV_CODE", user.getDivCode());
        spParam.put("TABLE_ID", "ABH200T");
        spParam.put("PREFIX", "A");
        spParam.put("BASIS_DATE", dateGetString);
        spParam.put("AUTO_TYPE", "1");
        
        super.commonDao.queryForObject("abh220ukrServiceImpl.spAutoNum", spParam);
        
        dataMaster.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
        
        //        dataMaster.put("SEND_DATE", dataMaster.get("SEND_DATE"));       //확인필요 지급일 관련
        super.commonDao.insert("abh220ukrServiceImpl.insertMasterAbh200Save", dataMaster);
        
        //        String sendNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if (paramList != null) {
            for (Map param : paramList) {
                
                //                param.put("SEND_NUM", dataMaster.get("KEY_NUMBER"));
                //                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
                param.put("data", insertDetailsAbh210Save(dataList, dataMaster));
            }
        }
        /*
         * if(buttonFlag.equals("BATCH")){ //자동기표 Map<String, Object> spParam = new HashMap<String, Object>(); spParam.put("S_COMP_CODE", user.getCompCode()); spParam.put("KEY_VALUE", keyValue); spParam.put("S_USER_ID" , user.getUserID()); spParam.put("S_LANG_CODE", user.getLanguage()); super.commonDao.queryForObject("spUspAccntAutoSlip69", spParam); String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc")); if(!ObjUtils.isEmpty(errorDesc)){ // String[] messsage = errorDesc.split(";"); throw new UniDirectValidateException(this.getMessage(errorDesc, user)); } }else if(buttonFlag.equals("CANCEL")){ //기표취소 Map<String, Object> spParam = new HashMap<String, Object>(); spParam.put("S_COMP_CODE", user.getCompCode()); spParam.put("KEY_VALUE", keyValue); spParam.put("S_USER_ID" , user.getUserID()); spParam.put("S_LANG_CODE", user.getLanguage()); super.commonDao.queryForObject("spUspAccntAutoSlip69Cancel", spParam); String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
         * if(!ObjUtils.isEmpty(errorDesc)){ // String[] messsage = errorDesc.split(";"); throw new UniDirectValidateException(this.getMessage(errorDesc, user)); } }
         */
        
        paramList.add(0, paramMaster);
        
        //        paramList.addResultProperty("RECE_NO", ObjUtils.getSafeString(dataMaster.get("KEY_NUMBER")));
        return paramList;
    }
    
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertDetailsAbh210Save( List<Map> params, Map<String, Object> dataMaster ) throws Exception {
        for (Map param : params) {
            //            param.put("KEY_VALUE", keyValue);
            //            param.put("OPR_FLAG", oprFlag); 
            param.put("SEND_NUM", dataMaster.get("KEY_NUMBER"));
            super.commonDao.insert("abh220ukrServiceImpl.insertDetailsAbh210Save", param);
            
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailAbh200SaveButton( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
}
