package foren.unilite.modules.accnt.abh;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

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

@Service( "abh900ukrService" )
public class Abh900ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 전자어음 자동기표방법등록 (abh900ukr)
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("abh900ukrServiceImpl.selectList", param);
    }
    
//    /** 저장 **/
//    @SuppressWarnings( { "rawtypes", "unchecked" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
//    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
//    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
//        if (paramList != null) {
//            List<Map> updateList = null;
//            List<Map> deleteList = null;
//            for (Map dataListMap : paramList) {
//                if (dataListMap.get("method").equals("deleteDetail")) {
//                    deleteList = (List<Map>)dataListMap.get("data");
//                } else if (dataListMap.get("method").equals("updateDetail")) {
//                    updateList = (List<Map>)dataListMap.get("data");
//                }
//            }
//            if (deleteList != null) this.deleteDetail(deleteList, user);
//            if (updateList != null) this.updateDetail(updateList, user);
//        }
//        paramList.add(0, paramMaster);
//        
//        return paramList;
//    }
    
//    @SuppressWarnings( { "rawtypes" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
//    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
//        for (Map param : paramList) {
//            super.commonDao.update("abh900ukrServiceImpl.updateDetail", param);
//        }
//        return;
//    }
//    
//    @SuppressWarnings( { "rawtypes" } )
//    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
//    public void deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
//        for (Map param : paramList) {
//            try {
//                super.commonDao.delete("abh900ukrServiceImpl.deleteDetail", param);
//            } catch (Exception e) {
//                throw new UniDirectValidateException(this.getMessage("547", user));
//            }
//        }
//        return;
//    }
    
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
            param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
            super.commonDao.insert("abh900ukrServiceImpl.insertLogTable", param);
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
            super.commonDao.queryForObject("abh900ukrServiceImpl.cancelSlip", spParam);
            
        } else {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("INPUT_USER_ID", user.getUserID());
            spParam.put("LANG_TYPE", langType);
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("abh900ukrServiceImpl.runAutoSlip", spParam);
        }
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        return;
    }
    
    
    
    /**
     * 인터페이스 실행을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public List<Map> runInterface( List<Map> paramList, LoginVO user ) throws Exception {
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        
        //로그테이블에 insert
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.update("abh900ukrServiceImpl.insertInterfaceLog", param);
        }
        
        // 토큰 / Target URL 경로
        Map getInfoIF = (Map)super.commonDao.select("abh900ukrServiceImpl.getInfoIF", "");
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
        String accessToken = null;
        StringBuffer sb = new StringBuffer();
        
        int i = 1;
        
        try {
            getInfoIF2 = ( (List<Map<String, Object>>)super.commonDao.list("abh900ukrServiceImpl.getInfoIF2", keyValue) );
            
            if (getInfoIF2.size() > 0) {
                sb.append("{\"header\":[{\"IF_ID\":\"IF_SRB001\"}],"); // 정기구독 :
                                                                       // IF_SRA001
                                                                       // /
                                                                       // 출판판매
                                                                       // :
                                                                       // IF_SRB001
                sb.append("\"data\":[");
                for (Map param1 : getInfoIF2) {
                    client = HttpClients.createDefault();
                    
                    String COMP_CODE = (String)param1.get("COMP_CODE");
                    String APP_ID = (String)param1.get("APP_ID"); // 정기구독:SRA /
                                                                  // 출판판매 :SRB
                    String INDEX_NUM = (String)param1.get("INDEX_NUM");
                    String AC_DATE = (String)param1.get("AC_DATE");
                    BigDecimal SLIP_NUM = (BigDecimal)param1.get("SLIP_NUM");
                    Integer SLIP_SEQ = (Integer)param1.get("SLIP_SEQ");
                    BigDecimal AMT_I = (BigDecimal)param1.get("AMT_I");
                    String BANK_CODE = (String)param1.get("BANK_CODE");
                    String ACCOUNT_NUM = (String)param1.get("ACCOUNT_NUM");
                    String REMARK = (String)param1.get("REMARK");
                    
                    sb.append("{");
                    sb.append("\"COMP_CODE\":\"").append(COMP_CODE).append("\",");
                    sb.append("\"APP_ID\":\"").append(APP_ID).append("\",");
                    sb.append("\"INDEX_NUM\":\"").append(INDEX_NUM).append("\",");
                    sb.append("\"AC_DATE\":\"").append(AC_DATE).append("\",");
                    sb.append("\"SLIP_NUM\":\"").append(SLIP_NUM.toString()).append("\",");
                    sb.append("\"SLIP_SEQ\":\"").append(SLIP_SEQ.toString()).append("\",");
                    sb.append("\"AMT_I\":\"").append(AMT_I.toString()).append("\",");
                    sb.append("\"BANK_CODE\":\"").append(BANK_CODE).append("\",");
                    sb.append("\"BANK_ACCOUNT\":\"").append(ACCOUNT_NUM).append("\",");
                    sb.append("\"REMARK\":\"").append(REMARK).append("\"");
                    if (i < getInfoIF2.size()) {
                        sb.append("},");
                        i++;
                    } else {
                        sb.append("}");
                    }
                }
                
                sb.append("]}");
                
                logger.debug("data :: {}", sb.toString());
                
                httpPost = new HttpPost(action_url + "?access_token=" + accessToken); // HttpPost(testUrl);
                httpPost.addHeader("content-type", "application/json");
                userEntity = new StringEntity(sb.toString(), "UTF-8");
                httpPost.setEntity(userEntity);
                
                logger.debug("request line : {}", httpPost.getRequestLine());
                httpResponse = client.execute(httpPost);
                
                entity = httpResponse.getEntity();
                
                if (entity != null) {
                    String responseString = EntityUtils.toString(entity);
                    logger.debug("response content:" + responseString.replace("\r\n", ""));
                    
                    jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    
                    if (jsonObj != null) {
                        if (( (String)jsonObj.get("status") ).equals("0")) {
                            // 콘솔 출력
                            System.out.println(" status : " + jsonObj.get("status"));
                            System.out.println(" message : " + jsonObj.get("message"));
                            System.out.println(" data : " + jsonObj.get("data"));
                            
                            if (jsonObj.get("data") instanceof JSONArray) {
                                jsonArray = (JSONArray)jsonObj.get("data");
                                
                                for (int j = 0; j < jsonArray.size(); j++) {
                                    System.out.println(j + " :: COMP_CODE : " + ( (JSONObject)jsonArray.get(j) ).get("COMP_CODE"));
                                    System.out.println(j + " :: APP_ID : " + ( (JSONObject)jsonArray.get(j) ).get("APP_ID"));
                                    System.out.println(j + " :: INDEX_NUM : " + ( (JSONObject)jsonArray.get(j) ).get("INDEX_NUM"));
                                    System.out.println(j + " :: RET_CODE : " + ( (JSONObject)jsonArray.get(j) ).get("RET_CODE"));
                                    System.out.println(j + " :: RET_MSG : " + ( (JSONObject)jsonArray.get(j) ).get("RET_MSG"));
                                }
                                
                            } else {
                                jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                            }
                            
                        } else {
                            System.out.println(" status : " + jsonObj.get("status"));
                            System.out.println(" message : " + jsonObj.get("message"));
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return rtnList;
    }
    
    /**
     * 어음데이터를 가져오기 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")     // 데이터 검증 / 저장
    public Object  getData(Map<String, String> spParam, LoginVO user) throws Exception {
        spParam.put("LangCode", user.getLanguage());
        super.commonDao.queryForObject("abh900ukrServiceImpl.getData", spParam);   
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));                
        if(!ObjUtils.isEmpty(errorDesc)){
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        }else{
            return true;
        }
    }
}
