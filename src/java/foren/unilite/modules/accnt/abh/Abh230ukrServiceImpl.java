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

@Service( "abh230ukrService" )
@SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
public class Abh230ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger        logger   = LoggerFactory.getLogger(this.getClass());
    private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
    private AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
    
    /**
     * CMS_ID 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt" )
    public Object getCmsId( Map param ) throws Exception {
        return super.commonDao.select("abh230ukrServiceImpl.getCmsId", param);
    }
    
    /**
     * 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        String returnStr = "";
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("abh230ukrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("ACCOUNT_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("ACCOUNT_NUM_EXPOS", decrypto.decryto(decMap.get("ACCOUNT_NUM").toString(), "RB"));
                        } catch (Exception e) {
                            decMap.put("ACCOUNT_NUM_EXPOS", "데이타 오류(" + decMap.get("ACCOUNT_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("ACCOUNT_NUM_EXPOS", "");
                    }
                }
            }
            return (List)decList;
        } else {
            return (List)super.commonDao.list("abh230ukrServiceImpl.selectList", param);
        }
    }
    
    /**
     * 저장
     * 
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> dataList = new ArrayList<Map>();
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                dataList = (List<Map>)dataListMap.get("data");
                
                if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            if (insertList != null) this.insertList(insertList, user, paramMaster);
            if (updateList != null) this.updateList(updateList, user, paramMaster);
            if (deleteList != null) this.deleteList(deleteList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 입력 (사용 안 함, 엑셀 업로드를 통한 insert만 가능)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        return 0;
    }
    
    /**
     * 수정
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        for (Map param : paramList) {
            try {
                /*
                 * //수정 시, 계좌번호 암호화 하여 테이블에 update (팝업을 통한 입력에는 아래 로직 필요 없음) String accountNum = (String) param.get("ACCOUNT_NUM"); if (ObjUtils.isNotEmpty(accountNum)) { param.put("ACCOUNT_NUM", seed.encryto(accountNum).trim()); } else { param.put("ACCOUNT_NUM", ""); }
                 */
                
                //update로직에서 암호화 필드가 있을시  decrypt후에 encrypt를 다시 해줘야 중복 암호화가 발생하지 않는다. 단 insert로직은 상관 없음  
                param.put("ACCOUNT_NUM", encrypto.encryto(decrypto.getDecrypto("1", (String)param.get("ACCOUNT_NUM"))));
                super.commonDao.update("abh230ukrServiceImpl.updateList", param);
                
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }
    
    /**
     * 삭제
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        
        for (Map param : paramList) {
            try {
                super.commonDao.update("abh230ukrServiceImpl.deleteList", param);
                
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return 0;
    }
    
    /**
     * 엑셀업로드 관련
     * 
     * @param jobID
     * @param param
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public void excelValidate( String jobID, Map param ) throws Exception {
        String ERR_FLAG = "";
        logger.debug("validate: {}", jobID);
        
        List<Map> excelCheck = (List<Map>)super.commonDao.list("abh230ukrServiceImpl.beforeExcelCheck", param);
        
        if (excelCheck.get(0).get("COUNT_DATA").equals(0)) {
            ERR_FLAG = "Y";
            param.put("MSG", "업로드 된 데이터가 없습니다. \n 엑셀파일을 확인하시기 바랍니다.");
            super.commonDao.delete("abh230ukrServiceImpl.insertErrorMsg", param);
            //        	throw new  UniDirectValidateException("업로드 된 데이터가 없습니다. \n 엑셀파일을 확인하시기 바랍니다.");
        }
        if (!excelCheck.get(0).get("COUNT_DATA").equals(excelCheck.get(0).get("COUNT_EXIST_ACCNT"))) {
            ERR_FLAG = "Y";
            param.put("MSG", "업로드 된 데이터 중, 전표가 존재하지 않는 데이터가 있습니다. \n 엑셀파일의 데이터를 다시 확인하시기 바랍니다.");
            super.commonDao.delete("abh230ukrServiceImpl.insertErrorMsg", param);
            //        	throw new  UniDirectValidateException("업로드 된 데이터 중, 전표가 존재하지 않는 데이터가 있습니다. \n 엑셀파일의 데이터를 다시 확인하시기 바랍니다.");
        }
        
        try {
            if (!ERR_FLAG.equals("Y")) {
                List<Map> getData = (List<Map>)super.commonDao.list("abh230ukrServiceImpl.getData", param);
                
                if (!getData.isEmpty()) {
                    for (Map data : getData) {
                        param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
                        
                        //엑셀에 있는 계좌번호 암호화
                        String accountNum = (String)data.get("ACCOUNT_NUM");
                        if (ObjUtils.isNotEmpty(accountNum)) {
                            param.put("ACCOUNT_NUM", encrypto.encryto(accountNum).trim());
                            
                        } else {
                            param.put("ACCOUNT_NUM", "");
                        }
                        super.commonDao.update("abh230ukrServiceImpl.excelValidate", param);
                    }
                }
            }
            
        } catch (Exception e) {
            throw new UniDirectValidateException("엑셀 업로드 중 오류가 발생하였습니다.\n 관리자에게 문의하시기 바랍니다.");
        }
        
        //본 테이블에 insert 후, 임시 테이블 삭제 (jsp에서 return 값에 따라 다르게 처리)
        //		super.commonDao.delete("abh230ukrServiceImpl.deleteLog", param);
        
        return;
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
        return super.commonDao.select("abh230ukrServiceImpl.getErrMsg", param);
    }
    
    /**
     * 로그테이블 삭제
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteLog( Map param, LoginVO user ) throws Exception {
        super.commonDao.update("abh230ukrServiceImpl.deleteLog", param);
        return 0;
    }
    
    /**
     * 예금주 조회하기, 예금주결과 받기
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllCmsButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //키, 변수 선언 및 값 입력
        String keyValue = getLogKey();
        List<Map> dataList = new ArrayList<Map>();
        String buttonFlag = (String)dataMaster.get("CMS_BUTTON_FLAG");
        
        //선택된 그리드 데이터를 로그테이블에 INSERT
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                if (param.get("method").equals("insertLogDetailsCms")) {
                    param.put("data", insertLogDetailsCmsRun(dataList, keyValue, buttonFlag));
                }
            }
        }
        
        //조건에 맞는 SP 호출
        //예금주 조회 버튼 클릭 시
        if (buttonFlag.equals("SEND")) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAbh230ukrFnBanknameQuery", spParam);
            
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
                
                List<Map<String, Object>> Hlist = (List<Map<String, Object>>)super.commonDao.list("abh230ukrServiceImpl.getTempHeader", param);
                List<Map<String, Object>> Dlist = (List<Map<String, Object>>)super.commonDao.list("abh230ukrServiceImpl.getTempBody", param);
                
                for (Map<String, Object> map : Hlist) {
                    logger.info("map :: {}", map);
                    
                    super.commonDao.insert("abh230ukrServiceImpl.insTempToHeader", map);
                }
                
                for (Map<String, Object> map : Dlist) {
                    FIELD_002 = map.get("FIELD_002") == null ? "" : (String)map.get("FIELD_002");
                    if (!FIELD_002.equals("") && FIELD_002.length() > 0) {
                        FIELD_002 = decrypto.getDecrypto("1", FIELD_002);
                    }
                    map.put("FIELD_002", FIELD_002);
                    map.put("RTN_VALUE", rtnValue);
                    
                    super.commonDao.insert("abh230ukrServiceImpl.updtTempToBody", map);
                    
                    super.commonDao.insert("abh230ukrServiceImpl.insTempToBody", map);
                }
            }
            
            //예금주 결과받기 버튼 클릭 시
        } else if (buttonFlag.equals("RECEIVE")) {
            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_WORK_GB", "6");
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID", user.getUserID());
            
            super.commonDao.queryForObject("spUspAccntAbh230ukrFnBankNameresult", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
                
            } else {/*
                     * super.commonDao.queryForObject("spUspAccntAbh230ukrFnBankNameresult2", spParam); String errorDesc2 = ObjUtils.getSafeString(spParam.get("ERROR_DESC")); if(!ObjUtils.isEmpty(errorDesc2)){ throw new UniDirectValidateException(this.getMessage(errorDesc2, user)); }
                     */}
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * method의 작업 구분을 위한 빈 메서드
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertLogDetailsCms( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
    /**
     * 선택된 그리드 데이터 로그테이블에 저장
     */
    public List<Map> insertLogDetailsCmsRun( List<Map> params, String keyValue, String buttonFlag ) throws Exception {
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            if (buttonFlag.equals("RECEIVE")) {
                if (param.get("CMS_TRANS_YN").equals("Y")) {
                    super.commonDao.insert("abh230ukrServiceImpl.insertLogDetailsCms", param);
                }
                
            } else {
                super.commonDao.insert("abh230ukrServiceImpl.insertLogDetailsCms", param);
            }
        }
        return params;
    }
    
    /**
     * 이체지급 버튼
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllAbh200SaveButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
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
        
        super.commonDao.queryForObject("abh230ukrServiceImpl.spAutoNum", spParam);
        
        dataMaster.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
        
        super.commonDao.insert("abh230ukrServiceImpl.insertMasterAbh200Save", dataMaster);
        
        List<Map> dataList = new ArrayList<Map>();
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                param.put("data", insertDetailsAbh210Save(dataList, dataMaster));
            }
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 이체지급 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertDetailsAbh210Save( List<Map> params, Map<String, Object> dataMaster ) throws Exception {
        for (Map param : params) {
            param.put("SEND_NUM", dataMaster.get("KEY_NUMBER"));
            param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            super.commonDao.insert("abh230ukrServiceImpl.insertDetailsAbh210Save", param);
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailAbh200SaveButton( List<Map> params, LoginVO user ) throws Exception {
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
        spParam.put("APRV_TYPE", "TX");
        spParam.put("SLIP_TYPE", "");
        spParam.put("USER_ID", user.getUserID());
        super.commonDao.queryForObject("uspJoinsAccntAprvCheckAbh230ukr", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            //            dataMaster.put("ELEC_SLIP_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            
            Map<String, Object> spParam2 = new HashMap<String, Object>();
            
            spParam2.put("COMP_CODE", user.getCompCode());
            spParam2.put("KEY_VALUE", keyValue);
            spParam2.put("APRV_TYPE", "TX");
            spParam2.put("USER_ID", user.getUserID());
            super.commonDao.queryForObject("uspJoinsAccntAprvBufAbh230ukr", spParam2);
            
            String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));
            
            if (!ObjUtils.isEmpty(errorDesc2)) {
                //                dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc2.split(";");
                throw new UniDirectValidateException(this.getMessage(errorDesc2, user));
            } else {
                
                Map<String, Object> spParam3 = new HashMap<String, Object>();
                
                spParam3.put("COMP_CODE", user.getCompCode());
                spParam3.put("KEY_VALUE", keyValue);
                spParam3.put("APRV_TYPE", "TX");
                spParam3.put("USER_ID", user.getUserID());
                super.commonDao.queryForObject("uspJoinsAccntAprvMainAbh230ukr", spParam3);
                
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
            
            if (param.get("CMS_TRANS_YN").equals("Y")) {
                super.commonDao.insert("abh230ukrServiceImpl.insertRequestLogDetail", param);
            }
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailRequest( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
}
