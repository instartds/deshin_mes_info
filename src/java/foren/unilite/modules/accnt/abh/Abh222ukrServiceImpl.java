package foren.unilite.modules.accnt.abh;

import java.util.ArrayList;
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

@Service( "abh222ukrService" )
public class Abh222ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 이체지급대상등록 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        String returnStr = "";
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("abh222ukrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            // 현업요구사항에 의해 전부 복호화함. - 2017.03.24
                            // decMap.put("CRDT_NUM_EXPOS", seed.decryto(decMap.get("BANK_ACCOUNT").toString(), "RC"));
                            decMap.put("BANK_ACCOUNT_EXPOS", decrypto.getDecrypto("1", decMap.get("BANK_ACCOUNT").toString()));
                        } catch (Exception e) {
                            decMap.put("BANK_ACCOUNT_EXPOS", "데이타 오류(" + decMap.get("BANK_ACCOUNT").toString() + ")");
                        }
                    } else {
                        decMap.put("BANK_ACCOUNT_EXPOS", "");
                    }
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("abh222ukrServiceImpl.selectList", param);
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
                super.commonDao.insert("abh222ukrServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            //ABH222T 에 저장유무
            Map checkInUp = (Map)super.commonDao.select("abh222ukrServiceImpl.checkInUp", param);
            if (ObjUtils.parseInt(checkInUp.get("CNT")) == 0) {
                super.commonDao.insert("abh222ukrServiceImpl.insertDetail", param);
            } else {
                super.commonDao.update("abh222ukrServiceImpl.updateDetail", param);
            }
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
        return super.commonDao.list("abh222ukrServiceImpl.selectSubList", param);
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
                super.commonDao.insert("abh222ukrServiceImpl.insertSubDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateSubDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("abh222ukrServiceImpl.updateSubDetail", param);
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteSubDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("abh222ukrServiceImpl.deleteSubDetail", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
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
            
            super.commonDao.queryForObject("spUspAccntAbh222ukrFnBanknameQuery", spParam);
            
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
                
                List<Map<String, Object>> Hlist = (List<Map<String, Object>>)super.commonDao.list("abh222ukrServiceImpl.getTempHeader", param);
                List<Map<String, Object>> Dlist = (List<Map<String, Object>>)super.commonDao.list("abh222ukrServiceImpl.getTempBody", param);
                
                for (Map<String, Object> map : Hlist) {
                    logger.info("map :: {}", map);
                    
                    super.commonDao.insert("abh222ukrServiceImpl.insTempToHeader", map);
                }
                
                for (Map<String, Object> map : Dlist) {
                    FIELD_002 = map.get("FIELD_002") == null ? "" : (String)map.get("FIELD_002");
                    if (!FIELD_002.equals("") && FIELD_002.length() > 0) {
                        FIELD_002 = decrypto.getDecrypto("1", FIELD_002);
                        
                    }
                    map.put("FIELD_002", FIELD_002);
                    map.put("RTN_VALUE", rtnValue);
                    
                    logger.info("map :: {}", map);
                    
                    super.commonDao.insert("abh222ukrServiceImpl.updtTempToBody", map);
                    
                    super.commonDao.insert("abh222ukrServiceImpl.insTempToBody", map);
                }
            }
        } else if (buttonFlag.equals("RECEIVE")) {
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_WORK_GB", "7");
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAbh222ukrFnBankNameresult", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {/*
                     * super.commonDao.queryForObject("spUspAccntAbh222ukrFnBankNameresult2", spParam); String errorDesc2 = ObjUtils.getSafeString(spParam.get("ERROR_DESC")); if(!ObjUtils.isEmpty(errorDesc2)){ throw new UniDirectValidateException(this.getMessage(errorDesc2, user)); }
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
            if (param.get("CHK").equals("0") && ObjUtils.isEmpty(param.get("EX_DATE"))) {
                if (buttonFlag.equals("RECEIVE")) {
                    //                    String rcptId = (String) param.get("RCPT_ID");
                    //                    if(rcptId != null && !"".equals(rcptId)){
                    
                    if (param.get("CMS_TRANS_YN").equals("Y")) {
                        super.commonDao.insert("abh222ukrServiceImpl.insertLogDetailCms", param);
                    }
                } else {
                    super.commonDao.insert("abh222ukrServiceImpl.insertLogDetailCms", param);
                }
            }
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailCmsButton( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
}
