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

@Service( "abh201ukrService" )
public class Abh201ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger        logger   = LoggerFactory.getLogger(this.getClass());
    private AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
    
    /**
     * 삭제 btn
     * 
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Object abh201Delete( Map spParam, LoginVO user ) throws Exception {
        
        super.commonDao.delete("abh201ukrServiceImpl.deleteABH210T", spParam);
        super.commonDao.delete("abh201ukrServiceImpl.deleteABH200T", spParam);
        return true;
    }
    
    /**
     * 예금의 주지급계좌/구매카드의 주브랜치지급카드정보
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt" )
    public Object fnGetMainAccount( Map param ) throws Exception {
        return super.commonDao.select("abh201ukrServiceImpl.fnGetMainAccount", param);
    }
    
    /**
     * 이체지급등록 마스터조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectMaster( Map param ) throws Exception {
        return super.commonDao.list("abh201ukrServiceImpl.selectMaster", param);
    }
    
    /**
     * 이체지급등록 디테일조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetail( Map param ) throws Exception {
        return super.commonDao.list("abh201ukrServiceImpl.selectDetail", param);
    }
    
    /**
     * 이체지급등록 검색조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectRef1( Map param ) throws Exception {
        return super.commonDao.list("abh201ukrServiceImpl.selectRef1", param);
    }
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllMaster( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteMaster")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertMaster")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateMaster")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteMaster(deleteList, user, paramMaster);
            if (insertList != null) this.insertMaster(insertList, user, paramMaster);
            if (updateList != null) this.updateMaster(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertMaster( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
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
            
            super.commonDao.queryForObject("abh201ukrServiceImpl.spAutoNum", spParam);
            
            dataMaster.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            for (Map param : paramList) {
                
                param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                param.put("SEND_DATE", dataMaster.get("SEND_DATE"));
                super.commonDao.update("abh201ukrServiceImpl.insertMaster", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateMaster( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        for (Map param : paramList) {
            param.put("SEND_DATE", dataMaster.get("SEND_DATE"));
            param.put("SEND_NUM", dataMaster.get("SEND_NUM"));
            super.commonDao.update("abh201ukrServiceImpl.updateMaster", param);
            
        }
        return;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteMaster( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            try {
                param.put("SEND_NUM", dataMaster.get("SEND_NUM"));
                super.commonDao.delete("abh201ukrServiceImpl.deleteMaster", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return;
    }
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllDetail( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
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
            if (deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
            if (insertList != null) this.insertDetail(insertList, user);
            if (updateList != null) this.updateDetail(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.update("abh201ukrServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        for (Map param : paramList) {
            if (param.get("CHECK_VALUE").equals("Y")) {
                param.put("SEND_NUM", dataMaster.get("SEND_NUM"));
                super.commonDao.update("abh201ukrServiceImpl.insertDetail", param);
                
            } else if (param.get("CHECK_VALUE2").equals("Y")) {
                param.put("SEND_NUM", dataMaster.get("SEND_NUM"));
                super.commonDao.delete("abh201ukrServiceImpl.deleteDetail", param);
            }
            
        }
        //		dataMaster.put("SEND_NUM", dataMaster.get("KEY_NUMBER"));
        if (super.commonDao.list("abh201ukrServiceImpl.masterDeleteCheck", dataMaster).size() < 1) {
            super.commonDao.delete("abh201ukrServiceImpl.deleteMaster", dataMaster);
            
            dataMaster.put("DELETE_ALL_FLAG", 'Y');
            
        }
        
        return;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            try {
                param.put("SEND_NUM", dataMaster.get("SEND_NUM"));
                super.commonDao.delete("abh201ukrServiceImpl.deleteDetail", param);
                
                if (super.commonDao.list("abh201ukrServiceImpl.masterDeleteCheck", param).size() < 1) {
                    super.commonDao.delete("abh201ukrServiceImpl.deleteMaster", param);
                    
                    dataMaster.put("DELETE_ALL_FLAG", 'Y');
                    
                }
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return;
    }
    
    /**
     * 예금주 조회하기 btn
     * 
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Object bankNameQuery( Map spParam, LoginVO user ) throws Exception {
        
        //        Map<String, Object> spParam2 = new HashMap<String, Object>();
        
        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_LOGIN_ID", user.getUserID());
        //        spParam2.put("S_SEND_NUM", spParam.get("S_SEND_NUM")); 
        
        super.commonDao.queryForObject("spUspAccntAbh201ukrFnBanknameQuery", spParam);
        //      super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);     
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            //          String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            
            //job_yn = 'n' 검색 후 복호화 (바디)
            List<Map<String, Object>> bodyList = null;
            Map prm = null;
            
            bodyList = super.commonDao.list("abh201ukrServiceImpl.selectBodyList", prm);
            
            if (bodyList.size() > 0) {
                try {
                    
                    //Body
                    for (Map map2 : bodyList) {
                        map2.put("FIELD_002", decrypto.getDecrypto("1", (String)map2.get("FIELD_002")));
                        map2.put("JOB_YN", "Y");
                        super.commonDao.update("abh201ukrServiceImpl.updateBody", map2);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new Exception(e.getMessage());
                }
            }
            return true;
        }
        //        return spParam;
    }
    
    /**
     * 지급파일생성 btn
     * 
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Object abh201create( Map spParam, LoginVO user ) throws Exception {
        
        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_LOGIN_ID", user.getUserID());
        
        super.commonDao.queryForObject("spUspAccntAbh201ukrFnabh201create", spParam);
        logger.info("spParam :: {}", spParam);
        String rtnValue = ObjUtils.getSafeString(spParam.get("RTN_VALUE"));
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else if (ObjUtils.isEmpty(rtnValue)) {
            throw new UniDirectValidateException("지급파일 생성키가 생성되지 않았습니다.\n관리자에게 문의하여 주십시오. [RTN_VALUE]");
        } else {
            //job_yn = 'n' 검색 후 복호화 (헤더, 바디)
            List<Map<String, Object>> headList = null;
            List<Map<String, Object>> bodyList = null;
            Map prm = new HashMap();
            prm.put("KEY_VALUE", rtnValue);
            headList = super.commonDao.list("abh201ukrServiceImpl.selectHeadList", prm);
            bodyList = super.commonDao.list("abh201ukrServiceImpl.selectBodyList", prm);
            
            if (headList.size() > 0 && bodyList.size() > 0) {
                try {
                    
                    //Head
                    for (Map map1 : headList) {
                        if (ObjUtils.isNotEmpty(map1.get("OUT_ACCTNO"))) {
                            map1.put("OUT_ACCTNO", decrypto.getDecrypto("1", (String)map1.get("OUT_ACCTNO")));
                            map1.put("JOB_YN", "Y");
                            map1.put("KEY_VALUE", rtnValue);
                            
                            super.commonDao.update("abh201ukrServiceImpl.updateHead", map1);
                            
                            super.commonDao.insert("abh201ukrServiceImpl.insTempToHeader", map1);
                        }
                    }
                    
                    //Body
                    for (Map map2 : bodyList) {
                        if (ObjUtils.isNotEmpty(map2.get("FIELD_002"))) {
                            map2.put("FIELD_002", decrypto.getDecrypto("1", (String)map2.get("FIELD_002")));
                        }
                        if (ObjUtils.isNotEmpty(map2.get("FIELD_014"))) {
                            map2.put("FIELD_014", decrypto.getDecrypto("1", (String)map2.get("FIELD_014")));
                        }
                        map2.put("JOB_YN", "Y");
                        map2.put("KEY_VALUE", rtnValue);
                        
                        super.commonDao.update("abh201ukrServiceImpl.updateBody", map2);
                        
                        super.commonDao.insert("abh201ukrServiceImpl.insTempToBody", map2);
                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new Exception(e.getMessage());
                }
            }
            
            return true;
        }
    }
    
    /**
     * 예금주/지급 결과받기 btn
     * 
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Object bankNameresult( Map spParam, LoginVO user ) throws Exception {
        
        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_LOGIN_ID", user.getUserID());
        
        super.commonDao.queryForObject("spUspAccntAbh201ukrFnBankNameresult", spParam);
        //      super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);     
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            //          String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            return true;
        }
    }
    
    /**
     * 자동기표 btn
     * 
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public Object spUspAccntAutoSlip70( Map spParam, LoginVO user ) throws Exception {
        
        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_LOGIN_ID", user.getUserID());
        
        super.commonDao.queryForObject("spUspAccntAutoSlip70", spParam);
        //      super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);     
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            //          String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            return true;
        }
    }
    
    /** 자동기표 버튼 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllAutoSign( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        String keyValue = getLogKey();
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        String buttonFlag = (String)dataMaster.get("BUTTON_FLAG");
        List<Map> dataList = new ArrayList<Map>();
        //List<List<Map>> resultList = new ArrayList<List<Map>>();
        if (paramList != null) {
            for (Map param : paramList) {
                
                //                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("insertDetailAutoSign")) {
                    param.put("data", insertLogDetails(dataList, keyValue, "N"));
                }
            }
        }
        if (buttonFlag.equals("1")) {
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_USER_ID", user.getUserID());
            spParam.put("S_LANG_CODE", user.getLanguage());
            super.commonDao.queryForObject("spUspAccntAutoSlip70", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                //            dataMaster.put("ELEC_SLIP_NO", "");
                //                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
                
                //            dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
                
                //            for(Map param: paramList) {
                //                dataList = (List<Map>)param.get("data");    
                //                if(param.get("method").equals("insertDetail")) {
                //                    List<Map> datas = (List<Map>)param.get("data");
                //                    for(Map data: datas){
                //                        data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
                //                    }
                //                }
                //            }   
            }
        } else if (buttonFlag.equals("2")) {
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_USER_ID", user.getUserID());
            spParam.put("S_LANG_CODE", user.getLanguage());
            super.commonDao.queryForObject("spUspAccntAutoSlip70Cancel", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                //            dataMaster.put("ELEC_SLIP_NO", "");
                //                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
                
                //            dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
                
                //            for(Map param: paramList) {
                //                dataList = (List<Map>)param.get("data");    
                //                if(param.get("method").equals("insertDetail")) {
                //                    List<Map> datas = (List<Map>)param.get("data");
                //                    for(Map data: datas){
                //                        data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
                //                    }
                //                }
                //            }   
            }
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public List<Map> insertLogDetails( List<Map> params, String keyValue, String oprFlag ) throws Exception {
        
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            
            super.commonDao.insert("abh201ukrServiceImpl.insertLogDetail", param);
        }
        return params;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailAutoSign( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
}
