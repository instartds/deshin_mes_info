package foren.unilite.modules.accnt.atx;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import api.rest.utils.HttpClientUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service( "atx110ukrService" )
public class Atx110ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger    = LoggerFactory.getLogger(this.getClass());
    HttpClientUtils      httpUtils = new HttpClientUtils();
    
    /**
     * 사업장 전체 콤보 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<ComboItemModel> getDivCode( Map param ) throws Exception {
        return (List<ComboItemModel>)super.commonDao.list("atx110ukrServiceImpl.getDivCode", param);
    }
    
    /**
     * 매출사업장 콤보 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<ComboItemModel> getSaleDivCode( Map param ) throws Exception {
        return (List<ComboItemModel>)super.commonDao.list("atx110ukrServiceImpl.getSaleDivCode", param);
    }
    
    /**
     * 사용자 EMAIL 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_LOAD )
    public Object getEmail( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.getEmail", param);
    }
    
    /**
     * 사업장별 신고사업장 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_LOAD )
    public Object selectBillDivList( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.selectBillDivList", param);
    }
    
    /**
     * 신고사업장 정보 조회 form set용
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_LOAD )
    public Object selectBillDivInfo( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.selectBillDivInfo", param);
    }
    
    /**
     * 영업담당 콤보 관련 : atx110t에 있는 컬럼으로 대체
     * 
     * @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ) public List<ComboItemModel> getSalePrsn(Map param) throws Exception { return (List<ComboItemModel>) super.commonDao .list("atx110ukrServiceImpl.getSalePrsn", param); }
     */
    
    /**
     * 발행된 계산서 중 가장 최근 계산서에서 담당자 정보 가져오기
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_LOAD )
    public Map getPersonInfo( Map param ) throws Exception {
        return (Map)super.commonDao.select("atx110ukrServiceImpl.getPersonInfo", param);
    }
    
    /**
     * 계산서번호 검색 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectBillNoMasterList( Map param ) throws Exception {
        return super.commonDao.list("atx110ukrServiceImpl.selectBillNoMasterList", param);
    }
    
    /**
     * 개별세금계산서 마스터 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object selectMasterList( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.selectMasterList", param);
    }
    
    /**
     * 개별세금계산서 디테일 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailList( Map param ) throws Exception {
        return super.commonDao.list("atx110ukrServiceImpl.selectDetailList", param);
    }
    
    /**
     * 거래유형에 따라 증빙유형 값 select
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.FORM_LOAD )
    public Object getProofKind( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.getProofKind", param);
    }
    
    /**
     * 국세청전송완료 여부 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getBillSendCloseChk( Map param ) throws Exception {
        return super.commonDao.select("atx110ukrServiceImpl.getBillSendCloseChk", param);
    }
    
    /**
     * 저장 버튼 이벤트
     * 
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        Map<String, Object> spParam = new HashMap<String, Object>(); // returnData
        
        // 1.로그테이블에서 사용할 Key 생성
        String keyValue = getLogKey();
        
        // 2.마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        dataMaster.put("KEY_VALUE", keyValue);
        dataMaster.put("S_USER_ID", user.getUserID());
        
        if (ObjUtils.isEmpty(dataMaster.get("PUB_NUM"))) {
            dataMaster.put("OPR_FLAG", "N");
            
        } else if (dataMaster.get("FLAG").equals("D")) {
            dataMaster.put("OPR_FLAG", "D");
            
        } else {
            dataMaster.put("OPR_FLAG", "U");
        }
        
        super.commonDao.insert("atx110ukrServiceImpl.insertLogMaster", dataMaster);
        
        // 3.디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        // List<List<Map>> resultList = new ArrayList<List<Map>>();
        
        for (Map param : paramList) {
            dataList = (List<Map>)param.get("data");
            
            if (param.get("method").equals("insertDetail")) {
                param.put("data", insertLogDetails(dataList, keyValue, "N", dataMaster));
                
            } else if (param.get("method").equals("updateDetail")) {
                param.put("data", insertLogDetails(dataList, keyValue, "U", dataMaster));
                
            } else if (param.get("method").equals("deleteDetail")) {
                param.put("data", insertLogDetails(dataList, keyValue, "D", dataMaster));
            }
        }
        
        // 4.저장 Stored Procedure 실행
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("LANG_TYPE", user.getLanguage());
        spParam.put("USER_ID", user.getUserID());
        spParam.put("PUB_NUM", "");
        spParam.put("ERROR_DESC", "");
        
        super.commonDao.queryForObject("atx110ukrServiceImpl.USP_ACCNT_ATX110UKR", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            dataMaster.put("PUB_NUM", "");
            String[] messsage = errorDesc.split(";");
            throw new UniDirectValidateException(this.getMessage(messsage[0], user));
            
        } else {
            dataMaster.put("PUB_NUM", ObjUtils.getSafeString(spParam.get("PUB_NUM")));
        }
        
        // 5.마스터 정보 + 디테일 정보 결과셋 리턴
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 로그디테일 정보 저장
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> insertLogDetails( List<Map> params, String keyValue, String oprFlag, Map dataMaster ) throws Exception {
        for (Map param : params) {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            
            if (dataMaster.get("OPR_FLAG").equals("U")) {
                param.put("PUB_NUM", dataMaster.get("PUB_NUM"));
            }
            
            super.commonDao.insert("atx110ukrServiceImpl.insertLogDetail", param);
        }
        return params;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetail( List<Map> params, LoginVO user ) throws Exception {
        
        return;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void updateDetail( List<Map> params, LoginVO user ) throws Exception {
        
        return;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void deleteDetail( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
    /**
     * 폼 저장시 SP호출
     * 
     * @param dataMaster
     * @param user
     * @param result
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "accnt" )
    public ExtDirectFormPostResult syncForm( Atx110ukrModel dataMaster, LoginVO user, BindingResult result ) throws Exception {
        Map<String, Object> spParam = new HashMap<String, Object>();
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        String keyValue = getLogKey();
        
        dataMaster.setKEY_VALUE(keyValue);
        dataMaster.setOPR_FLAG(dataMaster.getFLAG());
        dataMaster.setS_USER_ID(user.getUserID());
        dataMaster.setSALE_LOC_AMT_I(dataMaster.getSALE_AMT_O());
        
        super.commonDao.insert("atx110ukrServiceImpl.insertLogMaster", dataMaster);
        
        if (dataMaster.getMODE().equals("modifyUpdate")) { // 수정발행 (기제사항착오)
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("LANG_TYPE", user.getLanguage());
            spParam.put("USER_ID", user.getUserID());
            spParam.put("PUB_NUM", "");
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx110ukrServiceImpl.USP_ACCNT_ATX110UKR", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                // extResult.addResultProperty("PUB_NUM", "");
                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(messsage[0], user));
                
            } else {
                extResult.addResultProperty("PUB_NUM", ObjUtils.getSafeString(spParam.get("PUB_NUM")));
            }
            
        } else { // 정상, 수정발행 (마스터만 저장 시)
            // 2.로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
            dataMaster.setCOMP_CODE(user.getCompCode());
            dataMaster.setKEY_VALUE(keyValue);
            dataMaster.setS_USER_ID(user.getUserID());
            
            if (ObjUtils.isEmpty(dataMaster.getPUB_NUM())) {
                dataMaster.setOPR_FLAG("N");
                
            } else if (( "D" ).equals(dataMaster.getFLAG())) {
                dataMaster.setOPR_FLAG("D");
                
            } else {
                dataMaster.setOPR_FLAG("U");
            }
            
            super.commonDao.insert("atx110ukrServiceImpl.insertLogMaster", dataMaster);
            
            // 4.Stored Procedure 실행
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("LANG_TYPE", user.getLanguage());
            spParam.put("USER_ID", user.getUserID());
            spParam.put("PUB_NUM", "");
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx110ukrServiceImpl.USP_ACCNT_ATX110UKR", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            if (!ObjUtils.isEmpty(errorDesc)) {
                // extResult.addResultProperty("PUB_NUM", "");
                String[] messsage = errorDesc.split(";");
                throw new UniDirectValidateException(this.getMessage(messsage[0], user));
                
            } else {
                extResult.addResultProperty("PUB_NUM", ObjUtils.getSafeString(spParam.get("PUB_NUM")));
            }
        }
        
        return extResult;
    }
    
    /**
     * 매출자동기표 / 기표취소 SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
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
            if (insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    private List<Map> runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        // 1.로그테이블에서 사용할 Key 생성
        String keyValue = getLogKey();
        // SP에서 작성한 변수에 맞추기
        // SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        // 작업 구분 (N:매출자동기표, D:기표취소)
        String oprFlag = (String)dataMaster.get("OPR_FLAG");
        // 각 변수 처리
        String procDate = (String)dataMaster.get("PROC_DATE");
        String billPubNum = (String)dataMaster.get("PUB_NUM");
        // SUM_TYPE('':개별자동기표)
        String sumType = "";
        // 에러메세지 처리
        String errorDesc = "";
        
        // 2.로그테이블에 KEY_VALUE 업데이트
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            param.put("PROC_DATE", procDate);
            param.put("PUB_NUM", billPubNum);
            
            super.commonDao.insert("atx110ukrServiceImpl.insertLogTable", param);
        }
        // OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        // 기표취소이면..
        if (oprFlag.equals("D")) {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("BILL_PUB_NUM", billPubNum);
            spParam.put("CALL_PATH", "Each");
            spParam.put("PROC_DATE", procDate);
            spParam.put("LANG_TYPE", user.getLanguage());
            spParam.put("INPUT_USER_ID", user.getUserID());
            spParam.put("SUM_TYPE", sumType);
            spParam.put("EBYN_MESSAGE", "");
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx110ukrServiceImpl.cancelSlip", spParam);
            
        } else {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("BILL_PUB_NUM", billPubNum);
            spParam.put("CALL_PATH", "Each");
            spParam.put("PROC_DATE", procDate);
            spParam.put("LANG_TYPE", user.getLanguage());
            spParam.put("INPUT_USER_ID", user.getUserID());
            spParam.put("SUM_TYPE", sumType);
            spParam.put("EBYN_MESSAGE", "");
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx110ukrServiceImpl.runAutoSlip", spParam);
        }
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            
        }
        return paramList;
    }
    
    /**
     * 전자세금계산서 전송
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Object sendEtax( Map paramMaster, LoginVO user ) throws Exception {
        //주민등록번호 암호화
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        String returnStr = "";
        // Map<String, Object> dataMaster = (Map<String, Object>)
        // paramMaster//.get("data");
        // 1.로그테이블에서 사용할 Key 생성
        String keyValue = getLogKey();
        // SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        // 작업 구분 ("T")
        String oprFlag = (String)paramMaster.get("OPR_FLAG");
        // language type
        String langType = (String)paramMaster.get("LANG_TYPE");
        
        // 등록된 세금계산서 가져오기 (COMP_CODE, DIV_CODE, PUB_NUM으로 가져오기)
        // logger.info("paramMaster :: {}", paramMaster);
        List<Map> getList = (List<Map>)super.commonDao.list("atx110ukrServiceImpl.getFromAtx110T", paramMaster);
        
        // 2. 로그테이블에 INSERT
        for (Map param : getList) {
            //Map<String, Object> param = (Map<String, Object>)paramList;
            if (param.get("BUYR_GB").equals("02")) {
                String repreNum = (String)param.get("BUYR_CORP_NO");
                returnStr = decrypto.decryto(repreNum);
                param.put("BUYR_CORP_NO", returnStr);
            }
            
            //위수탁 정보가 있을 경우 주민번호 암호화 해제하여 로그테이블에 insert
            String BROK_TOP_NUM = (String)param.get("BROK_TOP_NUM");
            if (ObjUtils.isNotEmpty(BROK_TOP_NUM)) {
                BROK_TOP_NUM = decrypto.getDecrypto("1", (String)param.get("BROK_TOP_NUM")).replace("-", "");
                param.put("BROK_TOP_NUM", BROK_TOP_NUM);
            }
            
            param.put("S_COMP_CODE", user.getCompCode());
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            super.commonDao.insert("atx110ukrServiceImpl.insertEtaxLogTable", param);
        }
        
        // 3. SP 최초 실행
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("OPR_FLAG", oprFlag);
        spParam.put("OPR_FLAG2", "INIT");
        spParam.put("OPR_FLAG3", "INIT");
        spParam.put("LANG_TYPE", langType);
        spParam.put("LOGIN_ID", user.getUserID());
        spParam.put("ERROR_DESC", "");
        super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        
        /*
         * 개별 전송 시에는 같은 거래처/년월/금액 및 전월데이터 허용 안함 if (errorDesc.equals("56334")) { // 같은 거래처, 년월, 금액이 존재할 경우 : 메세지 후, 계속 // 진행 spParam.put("COMP_CODE", user.getCompCode()); spParam.put("KEY_VALUE", keyValue); spParam.put("OPR_FLAG", oprFlag); spParam.put("OPR_FLAG2", "GO"); spParam.put("OPR_FLAG3", "INIT"); spParam.put("LANG_TYPE", langType); spParam.put("LOGIN_ID", user.getUserID()); spParam.put("ERROR_DESC", ""); super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam); errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC")); } else if (errorDesc.equals("56335")) { // 전월데이터가 존재할 경우 : 메세지 후, 계속 진행 spParam.put("COMP_CODE", user.getCompCode()); spParam.put("KEY_VALUE", keyValue); spParam.put("OPR_FLAG", oprFlag); spParam.put("OPR_FLAG2", "GO"); spParam.put("OPR_FLAG3", "GO"); spParam.put("LANG_TYPE", langType); spParam.put("LOGIN_ID", user.getUserID()); spParam.put("ERROR_DESC", ""); super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam); errorDesc =
         * ObjUtils.getSafeString(spParam.get("ERROR_DESC")); }
         */
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            
        }
        
        /**
         * 전자세금계산서 interface
         */
        spParam.put("S_USER_ID", user.getUserID());
        sendEtaxData(spParam);
        
        //메세지 처리(성공)
        return true;
    }
    
    /**
     * 전자세금계산서 interface
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void sendEtaxData( Map spParam ) throws Exception {
        
        List rtnList = super.commonDao.list("atx170ukrServiceImpl.getItisIssuUrl", null);
        logger.info("rtnList :: {}", rtnList);
        String activeUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String accnt_atx170 = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        String standbyUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String accnt_atx1702 = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        
        CloseableHttpClient client = HttpClients.createDefault();
        
        try {
            if (rtnList.size() == 4) {
                //String accessToken = accWebService.getTocken(tokenUrl);
                
                //if (accessToken != null) {
                
                List<Map> trgList = super.commonDao.list("atx170ukrServiceImpl.getItisIssu", spParam);
                
                for (Map trget : trgList) {
                    
                    String ISSU_SEQNO = (String)trget.get("ISSU_SEQNO");
                    
                    spParam.put("PUSH_URL1", "");      // 토큰사용 안함.
                    spParam.put("PUSH_URL2", accnt_atx170);
                    spParam.put("ISSU_SEQNO", ISSU_SEQNO);
                    
                    List mstrList = super.commonDao.list("atx170ukrServiceImpl.getItisIssuMstr", spParam);
                    List detailList = super.commonDao.list("atx170ukrServiceImpl.getItisIssuDetail", spParam);
                    
                    String mstrStr = listToJson(mstrList);
                    String detailStr = listToJson(detailList);
                    
                    StringBuffer sb1 = new StringBuffer();
                    
                    sb1.append("{\"header_data\":");
                    sb1.append(mstrStr);
                    sb1.append(",");
                    
                    sb1.append("\"detail_data\":");
                    sb1.append(detailStr);
                    sb1.append("}");
                    /*
                     * logger.info("보낸 data :: {}", sb1.toString()); HttpPost httpPost = new HttpPost(activeUrl); // HttpPost(testUrl); httpPost.addHeader("content-type", "application/json"); StringEntity userEntity = new StringEntity(sb1.toString(), "UTF-8"); httpPost.setEntity(userEntity); logger.info("request line :: {}", httpPost.getRequestLine()); HttpResponse httpResponse = client.execute(httpPost); HttpEntity entity = httpResponse.getEntity(); if (entity != null) { String responseString = EntityUtils.toString(entity); if (responseString == null || ( responseString.trim() ).length() == 0) { throw new Exception("관리자에게 문의하여 주십시오. [" + activeUrl + "]"); } else { JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString)); logger.info("responseString :: {}", responseString); if (( (String)jsonObj.get("status") ).equals("1")) { throw new Exception((String)jsonObj.get("message")); } else if (( (String)jsonObj.get("status") ).equals("0")) {
                     * spParam.put("BILL_SEND_YN", "Y"); spParam.put("EB_NUM", ISSU_SEQNO); spParam.put("SEND_ERR_DESC", null); super.commonDao.update("atx170ukrServiceImpl.updtAtx170err", spParam); } } }
                     */
                    
                    String responseString = httpUtils.post(activeUrl, standbyUrl, sb1.toString(), "application/json", "UTF-8", 10000, 10000);
                    if (responseString == null || ( responseString.trim() ).length() == 0) {
                        throw new Exception("관리자에게 문의하여 주십시오. [" + activeUrl + "]");
                    } else {
                        JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                        logger.info("responseString :: {}", responseString);
                        if (( (String)jsonObj.get("status") ).equals("1")) {
                            throw new Exception((String)jsonObj.get("message"));
                        } else if (( (String)jsonObj.get("status") ).equals("0")) {
                            spParam.put("BILL_SEND_YN", "Y");
                            spParam.put("EB_NUM", ISSU_SEQNO);
                            spParam.put("SEND_ERR_DESC", null);
                            super.commonDao.update("atx170ukrServiceImpl.updtAtx170err", spParam);
                        }
                    }
                }
                //}
            } else {
                throw new Exception("전자세금계산서 전송에 필요한 정보가 셋팅되지 않았습니다.\n관리자에게 문의하여 주십시오.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            try {
                if (client != null) client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * List 타입 -> Json 타입으로 변환
     * 
     * @param list
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String listToJson( List list ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        try {
            sb.append(objMapper.writeValueAsString(list));
        } catch (JsonGenerationException e) {
            logger.error(e.getMessage());
            return "";
        } catch (JsonMappingException e) {
            logger.error(e.getMessage());
            return "";
        } catch (IOException e) {
            logger.error(e.getMessage());
            return "";
        }
        
        return sb.toString();
    }
    
    /**
     * Map 타입 -> Json 타입으로 변환
     * 
     * @param map
     * @param indent Json 문자열 정렬여부
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    public String mapToJson( Map map ) {
        StringBuffer sb = new StringBuffer();
        ObjectMapper objMapper = new ObjectMapper();
        
        try {
            sb.append(objMapper.writeValueAsString(map));
        } catch (JsonGenerationException e) {
            logger.error(e.getMessage());
            return "";
        } catch (JsonMappingException e) {
            logger.error(e.getMessage());
            return "";
        } catch (IOException e) {
            logger.error(e.getMessage());
            return "";
        }
        
        return sb.toString();
    }
    
}
