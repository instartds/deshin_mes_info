package api.rest.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.rest.utils.HttpClientUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service( "abh300IFService" )
public class Abh300IFServiceImpl extends TlabAbstractServiceImpl {
    private final Logger    logger     = LoggerFactory.getLogger(this.getClass());
    
    private HttpClientUtils httpclient = new HttpClientUtils();
    
    /**
     * <pre>
     * 인터페이스 실행을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * 중요 :: 해당 로직이 수정되면 foren.unilite.modules.accnt.abh.Abh300ukrServiceImpl 파일도 수정되어야 함.
     *         같은 로직으로 수행됨.
     * </pre>
     * 
     * @param paramList
     * @param paramMaster
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public int runInterface( String jobId ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        //로그테이블에 insert
        Map<String, Object> param = new HashMap<String, Object>();
        
        jobId = jobId.replaceAll("\\.", "");
        if (jobId.length() > 20) {
            jobId = jobId.substring(0, 20);
        }
        
        param.put("KEY_VALUE", jobId);
        param.put("S_COMP_CODE", "MASTER");
        logger.info("++++++++++++++++++++++++++++++++++++ {} :: " + param);
        super.commonDao.update("Abh300IFServiceImpl.insertInterfaceLog", param);
        
        // 토큰 / Target URL 경로
        Map getInfoIF = (Map)super.commonDao.select("Abh300IFServiceImpl.getInfoIF", param);
        String action_url = (String)getInfoIF.get("action_url");
        
        List<Map<String, Object>> getInfoIF2 = null;
        
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
            getInfoIF2 = ( (List<Map<String, Object>>)super.commonDao.list("Abh300IFServiceImpl.getInfoIF2", jobId) );
            
            logger.debug("getInfoIF2 :: {}, size() :: {}", getInfoIF2, getInfoIF2.size());
            
            if (getInfoIF2.size() > 0) {
                
                for (int i = 0; i < getInfoIF2.size(); i++) {
                    param1 = (Map)getInfoIF2.get(i);
                    sb = new StringBuffer();
                    
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
                    
                    logger.debug("보낸 data :: {}", sb.toString());
                    
                    responseString = httpclient.post(action_url, action_url, sb.toString(), "application/json", "UTF-8", 1000, 1000);
                    logger.debug("responseString :: {}", responseString);
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
                        inMap.put("S_USER_ID", "ACCOUNT");
                        
                        super.commonDao.update("Abh300IFServiceImpl.updateFlag", inMap);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
        
        return ( getInfoIF2 == null ) ? 0 : getInfoIF2.size();
    }
    
    /**
     * TEMP 테이블 데이터 삭제
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public void deleteTemp() throws Exception {
        Map param = new HashMap();
        
        try {
            super.commonDao.delete("Abh300IFServiceImpl.deleteTemp", param);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }
}
