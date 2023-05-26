package foren.unilite.modules.accnt.abh;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
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
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service( "abh300ukrService" )
public class Abh300ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 이체지급자동기표방법등록 (abh300ukr)
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {//복호화버튼으로 조회시
            List<Map> decList = (List<Map>)super.commonDao.list("abh300ukrServiceImpl.selectList", param);
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("BANK_ACCOUNT"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("BANK_ACCOUNT_EXPOS", decrypto.decryto(decMap.get("BANK_ACCOUNT").toString(), "RB"));
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
            return (List)super.commonDao.list("abh300ukrServiceImpl.selectList", param);
        }
    }
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (updateList != null) this.updateDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /** 수정 **/
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("abh300ukrServiceImpl.updateDetail", param);
        }
        return;
    }
    
    /** 삭제 **/
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            try {
                super.commonDao.delete("abh300ukrServiceImpl.deleteDetail", param);
            } catch (Exception e) {
                throw new UniDirectValidateException(this.getMessage("547", user));
            }
        }
        return;
    }
    
    /**
     * 자동기표 및 기표취소 SP호출을 위한 로그테이블 생성 / SP 호출 로직
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
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.insert("abh300ukrServiceImpl.insertLogTable", param);
        }
        
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (N:자동기표, D:기표취소)
        String oprFlag = (String)dataMaster.get("OPR_FLAG");
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        String errorDesc = "";
        
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //기표취소이면..
        if (oprFlag.equals("D")) {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("USER_ID", user.getUserID());
            spParam.put("LANG_TYPE", langType);
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("abh300ukrServiceImpl.cancelSlip", spParam);
            
        } else {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("USER_ID", user.getUserID());
            spParam.put("LANG_TYPE", langType);
            spParam.put("EBYN_MESSAGE", "");
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("abh300ukrServiceImpl.runAutoSlip", spParam);
        }
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        return;
    }
    
    /**
     * <pre>
     * 인터페이스 실행을 위한 로그테이블 생성 / SP 호출 로직
     * 해당 로직이 수정되면 api.rest.service.Abh300IFServiceImpl 파일도 수정되어야 함.
     *         같은 로직으로 수행됨.
     * </pre>
     * 
     * @param paramList
     * @param paramMaster
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public List<Map> runInterface( List<Map> paramList, LoginVO user ) throws Exception {
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        //로그테이블에 insert
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.update("abh300ukrServiceImpl.insertInterfaceLog", param);
        }
        
        // 토큰 / Target URL 경로
        Map userInfo = new HashMap<String, Object>();
        userInfo.put("S_COMP_CODE", user.getCompCode());
        Map getInfoIF = (Map)super.commonDao.select("abh300ukrServiceImpl.getInfoIF", userInfo);
        String action_url = (String)getInfoIF.get("action_url");
        
        List<Map> rtnList = new ArrayList<Map>();
        
        List<Map<String, Object>> getInfoIF2 = null;
        
        CloseableHttpClient client = null;
        StringEntity userEntity = null;
        HttpResponse httpResponse = null;
        HttpEntity entity = null;
        HttpPost httpPost = null;
        
        JSONObject jsonObj = null;
        JSONArray jsonArray = null;
        StringBuffer sb = new StringBuffer();
        Map inMap = null;
        String COMP_CODE = null;
        String APP_ID = null;
        String INDEX_NUM = null;
        String AC_DATE = null;
        BigDecimal SLIP_NUM = null;
        BigDecimal SLIP_SEQ = null;
        BigDecimal AMT_I = null;
        String BANK_CODE = null;
        String ACCOUNT_NUM = null;
        String REMARK = null;
        String responseString = null;
        Map param1 = null;
        
        try {
            getInfoIF2 = ( (List<Map<String, Object>>)super.commonDao.list("abh300ukrServiceImpl.getInfoIF2", keyValue) );
            
            logger.debug("getInfoIF2 :: {}, size() :: {}", getInfoIF2, getInfoIF2.size());
            
            if (getInfoIF2.size() > 0) {
                
                for (int i = 0; i < getInfoIF2.size(); i++) {
                    param1 = (Map)getInfoIF2.get(i);
                    sb = new StringBuffer();
                    
                    client = HttpClients.createDefault();
                    
                    COMP_CODE = (String)param1.get("COMP_CODE");
                    APP_ID = (String)param1.get("APP_ID");         // 판매/광고 구분 필요. 판매 : S, 광고 : A, 정기구독 : P
                    INDEX_NUM = (String)param1.get("INDEX_NUM");
                    AC_DATE = (String)param1.get("AC_DATE");
                    SLIP_NUM = (BigDecimal)param1.get("SLIP_NUM");
                    SLIP_SEQ = (BigDecimal)param1.get("SLIP_SEQ");
                    AMT_I = (BigDecimal)param1.get("AMT_I");
                    BANK_CODE = (String)param1.get("BANK_CODE");
                    ACCOUNT_NUM = decrypto.getDecrypto("1", (String)param1.get("ACCOUNT_NUM"));
                    REMARK = (String)param1.get("REMARK");
                    
                    if (APP_ID.equals("S")) {
                        sb.append("{\"header\":[{\"IF_ID\":\"IF_SRB001\"}],"); // 정기구독 : IF_SRA001 / 출판판매 : IF_SRB001 / 광고 : IF_ARC001    
                    } else if (APP_ID.equals("A")) {
                        sb.append("{\"header\":[{\"IF_ID\":\"IF_ARC001\"}],"); // 정기구독 : IF_SRA001 / 출판판매 : IF_SRB001 / 광고 : IF_ARC001 
                    } else if (APP_ID.equals("P")) {
                        sb.append("{\"header\":[{\"IF_ID\":\"IF_SRA001\"}],"); // 정기구독 : IF_SRA001 / 출판판매 : IF_SRA001 / 광고 : IF_ARC001 
                    }
                    sb.append("\"data\":[");
                    sb.append("{");
                    sb.append("\"COMP_CODE\":\"").append(COMP_CODE).append("\",");
                    sb.append("\"APP_ID\":\"").append(APP_ID).append("\",");
                    sb.append("\"INDEX_NUM\":\"").append(INDEX_NUM).append("\",");
                    sb.append("\"AC_DATE\":\"").append(AC_DATE).append("\",");
                    sb.append("\"SLIP_NUM\":").append(SLIP_NUM.toString()).append(",");
                    sb.append("\"SLIP_SEQ\":").append(SLIP_SEQ.toString()).append(",");
                    sb.append("\"AMT_I\":").append(AMT_I.toString()).append(",");
                    sb.append("\"BANK_CODE\":\"").append(BANK_CODE).append("\",");
                    sb.append("\"BANK_ACCOUNT\":\"").append(ACCOUNT_NUM).append("\",");
                    sb.append("\"REMARK\":\"").append(REMARK).append("\"");
                    sb.append("}");
                    
                    sb.append("]}");
                    
                    logger.debug("data :: {}", sb.toString());
                    
                    httpPost = new HttpPost(action_url);            // HttpPost(testUrl);
                    httpPost.addHeader("content-type", "application/json");
                    userEntity = new StringEntity(sb.toString(), "UTF-8");
                    httpPost.setEntity(userEntity);
                    
                    logger.debug("request line : {}", httpPost.getRequestLine());
                    httpResponse = client.execute(httpPost);
                    
                    entity = httpResponse.getEntity();
                    
                    if (entity != null) {
                        responseString = EntityUtils.toString(entity);
                        logger.debug("response content:" + responseString.replace("\r\n", ""));
                        
                        jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                        
                        if (jsonObj != null) {
                            
                            logger.debug(" status : " + jsonObj.get("status"));
                            logger.debug(" message : " + jsonObj.get("message"));
                            
                            jsonArray = (JSONArray)jsonObj.get("data");
                            logger.debug(" COMP_CODE : " + ( (JSONObject)jsonArray.get(0) ).get("COMP_CODE"));
                            logger.debug(" APP_ID : " + ( (JSONObject)jsonArray.get(0) ).get("APP_ID"));
                            logger.debug(" INDEX_NUM : " + ( (JSONObject)jsonArray.get(0) ).get("INDEX_NUM"));
                            logger.debug(" RET_CODE : " + ( (JSONObject)jsonArray.get(0) ).get("RET_CODE"));
                            logger.debug(" RET_MSG : " + ( (JSONObject)jsonArray.get(0) ).get("RET_MSG"));
                            
                            inMap = new HashMap();
                            inMap.put("COMP_CODE", ( (JSONObject)jsonArray.get(0) ).get("COMP_CODE"));
                            inMap.put("AUTO_SLIP_NUM", ( (JSONObject)jsonArray.get(0) ).get("INDEX_NUM"));
                            inMap.put("SEND_YN", "Y");
                            inMap.put("RET_CODE", ( (JSONObject)jsonArray.get(0) ).get("RET_CODE"));
                            inMap.put("ERR_MSG", ( (JSONObject)jsonArray.get(0) ).get("RET_MSG"));
                            inMap.put("S_USER_ID", user.getUserID());
                            
                            super.commonDao.update("abh300ukrServiceImpl.updateFlag", inMap);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        
        return rtnList;
    }
    
    /** 입금액 분할 버튼 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllDivisionButton( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        String keyValue = getLogKey();
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        List<Map> dataList = new ArrayList<Map>();
        
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("insertDetailDivisionButton")) {
                    param.put("data", insertLogDetailsDivision(dataList, dataMaster));
                }
            }
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    public List<Map> insertLogDetailsDivision( List<Map> params, Map<String, Object> dataMaster ) throws Exception {
        
        for (Map param : params) {
            
            param.put("INOUT_AMT_I_ORIGINAL", dataMaster.get("INOUT_AMT_I_ORIGINAL"));
            param.put("REMARK_ORIGINAL", dataMaster.get("REMARK_ORIGINAL"));
            
            param.put("INOUT_DATE_DIVISION", dataMaster.get("INOUT_DATE_DIVISION"));
            param.put("INOUT_AMT_I_DIVISION", dataMaster.get("INOUT_AMT_I_DIVISION"));
            param.put("ACCNT_DIVISION", dataMaster.get("ACCNT_DIVISION"));
            param.put("DEPT_CODE_DIVISION", dataMaster.get("DEPT_CODE_DIVISION"));
            param.put("DEPT_NAME_DIVISION", dataMaster.get("DEPT_NAME_DIVISION"));
            param.put("REMARK_DIVISION", dataMaster.get("REMARK_DIVISION"));
            
            super.commonDao.update("abh300ukrServiceImpl.updateOriginal", param);
            super.commonDao.update("abh300ukrServiceImpl.insertDivision", param);
        }
        return params;
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public void insertDetailDivisionButton( List<Map> params, LoginVO user ) throws Exception {
        return;
    }
    
}
