package foren.unilite.modules.accnt.atx;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

import api.rest.utils.HttpClientUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service( "atx170ukrService" )
public class Atx170ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger           logger    = LoggerFactory.getLogger(this.getClass());
    HttpClientUtils                httpUtils = new HttpClientUtils();
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntUtil;
    
    /**
     * 세금계산서정보검색 조회(웹캐시)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        List<Map<String, Object>> selectList = super.commonDao.list("atx170ukrServiceImpl.selectList", param);
        for (Map selectListMap : selectList) {
            if (selectListMap.get("TRANSYN_NAME").equals("미전송")) {
                if (ObjUtils.isNotEmpty(selectListMap.get("ERR_MSG"))) {
                    selectListMap.put("TRANSYN_NAME", "Error");
                }
            }
        }
        
        return selectList;
    }
    
    /**
     * 전자세금계산서 전송 시 전자문서번호(ISSU_SEQNO) 자동채번하여 해당 컬럼에 입력하기 위한 로직
     * 
     * @param COMP_CODE
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    public List<Map<String, Object>> fnGetIssuSeqNo( Map param, LoginVO user ) throws Exception {
        return (List)super.commonDao.list("atx170ukrServiceImpl.fnGetIssuSeqNo", param);
    }
    
    /**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> callProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("runProcedure")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                    //buttonFlag에 따라 runProcedure 호출하여 결과값 dataListMap에 저장
                    //(buttonFlag - T:전송, CT: 전송취소, M:메일재전송, CM:확인메일 전송)
                    dataListMap.put("data", runProcedure(insertList, paramMaster, user));
                }
            }
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public List<Map> runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (N:자동기표, D:기표취소)
        String oprFlag = (String)dataMaster.get("OPR_FLAG");
        String oprFlag2 = (String)dataMaster.get("OPR_FLAG2");
        String oprFlag3 = (String)dataMaster.get("OPR_FLAG3");
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        String BUSINESS_TYPE = null;
        String BUYR_CORP_NO = null;
        String BROK_TOP_NUM = null;
        
        /** 이메일 재전송일 경우 */
        if (oprFlag.equals("M")) {
            //2.로그테이블에 KEY_VALUE 업데이트1
            logger.info("paramList() :: {}", paramList.size());
            for (Map param : paramList) {
                param.put("KEY_VALUE", keyValue);
                BUSINESS_TYPE = (String)param.get("BUSINESS_TYPE");
                if (BUSINESS_TYPE.equals("3")) {  // 개인
                    BUYR_CORP_NO = decrypto.getDecrypto("1", (String)param.get("BUYR_CORP_NO")).replace("-", "");
                } else {
                    BUYR_CORP_NO = param.get("BUYR_CORP_NO").toString().replace("-", "");
                }
                param.put("BUYR_CORP_NO", BUYR_CORP_NO);
                //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
                //1. 로그테이블에 데이터 insert
                logger.info("getSqlSession() :: {}", super.commonDao.getSqlSession());
                super.commonDao.update("atx170ukrServiceImpl.insertMailLogTable", param);
            }
            
            //2. SP 실행
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("LANG_TYPE", langType);
            spParam.put("LOGIN_ID", user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.update("atx170ukrServiceImpl.runMailProcedure", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            }
            
            /**
             * 전자세금계산서 메일재전송
             */
            spParam.put("S_USER_ID", user.getUserID());
            sendMailEtaxData(spParam);
            
            /** 전자세금계산서 전송일 경우 */
        } else if (oprFlag.equals("T")) {
            //2.로그테이블에 KEY_VALUE 업데이트1
            logger.info("paramList() :: {}", paramList.size());
            for (Map param : paramList) {
                param.put("S_COMP_CODE", user.getCompCode());
                param.put("KEY_VALUE", keyValue);
                BUSINESS_TYPE = (String)param.get("BUSINESS_TYPE");
                if (BUSINESS_TYPE.equals("3")) {  // 개인
                    BUYR_CORP_NO = decrypto.getDecrypto("1", (String)param.get("BUYR_CORP_NO")).replace("-", "");
                } else {
                    BUYR_CORP_NO = param.get("BUYR_CORP_NO").toString().replace("-", "");
                }
                param.put("BUYR_CORP_NO", BUYR_CORP_NO);
                
                //위수탁 정보가 있을 경우 주민번호 암호화 해제하여 로그테이블에 insert
                BROK_TOP_NUM = (String)param.get("BROK_TOP_NUM");
                if (ObjUtils.isNotEmpty(BROK_TOP_NUM)) {
                    BROK_TOP_NUM = decrypto.getDecrypto("1", (String)param.get("BROK_TOP_NUM")).replace("-", "");
                    param.put("BROK_TOP_NUM", BROK_TOP_NUM);
                }
                //1. 로그테이블에 데이터 insert
                logger.info("getSqlSession() :: {}", super.commonDao.getSqlSession());
                super.commonDao.update("atx170ukrServiceImpl.insertLogTable", param);
            }
            
            //2. SP 최초 실행
            if (oprFlag3.equals("GO")) {					//전월데이터가 존재할 경우 : 메세지 후, 계속 진행
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("KEY_VALUE", keyValue);
                spParam.put("OPR_FLAG", oprFlag);
                spParam.put("OPR_FLAG2", oprFlag2);
                spParam.put("OPR_FLAG3", oprFlag3);
                spParam.put("LANG_TYPE", langType);
                spParam.put("LOGIN_ID", user.getUserID());
                spParam.put("ERROR_DESC", "");
                super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam);
                
            } else if (oprFlag2.equals("GO")) {						//같은 거래처, 년월, 금액이 존재할 경우 : 메세지 후, 계속 진행
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("KEY_VALUE", keyValue);
                spParam.put("OPR_FLAG", oprFlag);
                spParam.put("OPR_FLAG2", oprFlag2);
                spParam.put("OPR_FLAG3", oprFlag3);
                spParam.put("LANG_TYPE", langType);
                spParam.put("LOGIN_ID", user.getUserID());
                spParam.put("ERROR_DESC", "");
                super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam);
                
            } else {
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("KEY_VALUE", keyValue);
                spParam.put("OPR_FLAG", oprFlag);
                spParam.put("OPR_FLAG2", oprFlag2);
                spParam.put("OPR_FLAG3", oprFlag3);
                spParam.put("LANG_TYPE", langType);
                spParam.put("LOGIN_ID", user.getUserID());
                spParam.put("ERROR_DESC", "");
                super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam);
            }
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            }
            
            /**
             * 전자세금계산서 전송
             */
            spParam.put("S_USER_ID", user.getUserID());
            sendEtaxData(spParam);
            
        } else if (oprFlag.equals("RT")) {		//다시 전송의 경우
            logger.info("paramList() :: {}", paramList.size());
            for (Map param : paramList) {
                param.put("S_COMP_CODE", user.getCompCode());
                //1.ATX110T UPDATE
                super.commonDao.update("atx170ukrServiceImpl.forReSendEtax", param);
                
                param.put("KEY_VALUE", keyValue);
                BUSINESS_TYPE = (String)param.get("BUSINESS_TYPE");
                if (BUSINESS_TYPE.equals("3")) {  // 개인
                    BUYR_CORP_NO = decrypto.getDecrypto("1", (String)param.get("BUYR_CORP_NO")).replace("-", "");
                } else {
                    BUYR_CORP_NO = param.get("BUYR_CORP_NO").toString().replace("-", "");
                }
                param.put("BUYR_CORP_NO", BUYR_CORP_NO);
                //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
                //1. 로그테이블에 데이터 insert
                logger.info("getSqlSession() :: {}", super.commonDao.getSqlSession());
                super.commonDao.update("atx170ukrServiceImpl.insertLogTable", param);
            }
            
            //2. SP 최초 실행
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("OPR_FLAG", oprFlag);
            spParam.put("OPR_FLAG2", "GO");
            spParam.put("OPR_FLAG3", "INIT");
            spParam.put("LANG_TYPE", langType);
            spParam.put("LOGIN_ID", user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.update("atx170ukrServiceImpl.runProcedure", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
            
            if (!ObjUtils.isEmpty(errorDesc)) {
                throw new UniDirectValidateException(this.getMessage(errorDesc, user));
            }
            
            /**
             * 전자세금계산서 전송
             */
            spParam.put("S_USER_ID", user.getUserID());
            sendEtaxData(spParam);
            
        }
        
        return paramList;
    }
    
    /**
     * 전자세금계산서 전송
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
                
                List<Map> trgList = super.commonDao.list("atx170ukrServiceImpl.getItisIssu", spParam);
                
                for (Map trget : trgList) {
                    
                    String ISSU_SEQNO = (String)trget.get("ISSU_SEQNO");
                    
                    spParam.put("PUSH_URL1", accnt_atx170);
                    spParam.put("PUSH_URL2", accnt_atx1702);
                    spParam.put("ISSU_SEQNO", ISSU_SEQNO);
                    
                    List mstrList = super.commonDao.list("atx170ukrServiceImpl.getItisIssuMstr", spParam);
                    List detailList = super.commonDao.list("atx170ukrServiceImpl.getItisIssuDetail", spParam);
                    
                    String mstrStr = listToJson(mstrList);
                    String detailStr = listToJson(detailList);
                    
                    StringBuffer sb1 = new StringBuffer();
                    
                    sb1.append("{'header_data':");
                    sb1.append(mstrStr);
                    sb1.append(",");
                    
                    sb1.append("'detail_data':");
                    sb1.append(detailStr);
                    sb1.append("}");
                    
                    logger.info("보낸 data :: {}", sb1.toString());
                    /*
                     * HttpPost httpPost = new HttpPost(activeUrl); // HttpPost(testUrl); httpPost.addHeader("content-type", "application/json"); StringEntity userEntity = new StringEntity(sb1.toString(), "UTF-8"); httpPost.setEntity(userEntity); logger.info("request line :: {}", httpPost.getRequestLine()); HttpResponse httpResponse = client.execute(httpPost); HttpEntity entity = httpResponse.getEntity(); if (entity != null) { String responseString = EntityUtils.toString(entity); if (responseString == null || ( responseString.trim() ).length() == 0) { throw new Exception("관리자에게 문의하여 주십시오. [" + activeUrl + "]"); } else { JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString)); if (( (String)jsonObj.get("status") ).equals("0")) { logger.info("responseString :: {}", responseString); spParam.put("BILL_SEND_YN", "Y"); spParam.put("EB_NUM", ISSU_SEQNO); spParam.put("SEND_ERR_DESC", null); } else { spParam.put("BILL_SEND_YN", "N"); spParam.put("EB_NUM", null);
                     * spParam.put("SEND_ERR_DESC", jsonObj.get("message")); } super.commonDao.update("atx170ukrServiceImpl.updtAtx170err", spParam); } }
                     */
                    String responseString = httpUtils.post(activeUrl, standbyUrl, sb1.toString(), "application/json", "UTF-8", 10000, 10000);
                    if (responseString == null || ( responseString.trim() ).length() == 0) {
                        throw new Exception("관리자에게 문의하여 주십시오. [" + activeUrl + "]");
                    } else {
                        JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                        if (( (String)jsonObj.get("status") ).equals("0")) {
                            logger.info("responseString :: {}", responseString);
                            spParam.put("BILL_SEND_YN", "Y");
                            spParam.put("EB_NUM", ISSU_SEQNO);
                            spParam.put("SEND_ERR_DESC", null);
                        } else {
                            spParam.put("BILL_SEND_YN", "N");
                            spParam.put("EB_NUM", null);
                            spParam.put("SEND_ERR_DESC", jsonObj.get("message"));
                        }
                        
                        super.commonDao.update("atx170ukrServiceImpl.updtAtx170err", spParam);
                    }
                }
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
     * 전자세금계산서 메일 재전송
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void sendMailEtaxData( Map spParam ) throws Exception {
        
        List rtnList = super.commonDao.list("atx170ukrServiceImpl.getItisMailUrl", null);
        logger.info("rtnList :: {}", rtnList);
        String activeUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String accnt_atx170 = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        String standbyUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String accnt_atx1702 = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        
        CloseableHttpClient client = HttpClients.createDefault();
        
        try {
            if (rtnList.size() == 4) {
                
                spParam.put("PUSH_URL1", accnt_atx170);
                spParam.put("PUSH_URL2", accnt_atx1702);
                
                List<Map> trgList = super.commonDao.list("atx170ukrServiceImpl.getItisBizMail", spParam);
                
                //                for (Map trget : trgList) {
                //                    String ISSU_SEQNO = (String)trget.get("ISSU_SEQNO");
                //                    spParam.put("ISSU_SEQNO", ISSU_SEQNO);
                //                    List mstrList = super.commonDao.list("atx170ukrServiceImpl.getItisBizMail", spParam);
                
                String mstrStr = listToJson(trgList);
                
                StringBuffer sb1 = new StringBuffer();
                
                sb1.append("{'data':");
                sb1.append(mstrStr);
                
                sb1.append("}");
                
                logger.info("보낸 data :: {}", sb1.toString());
                
                String responseString = httpUtils.post(activeUrl, standbyUrl, sb1.toString(), "application/json", "UTF-8", 10000, 10000);
                if (responseString == null || ( responseString.trim() ).length() == 0) {
                    throw new Exception("관리자에게 문의하여 주십시오. [" + activeUrl + "]");
                    
                } else {
                    JSONObject jsonObj = JSONObject.fromObject(JSONSerializer.toJSON(responseString));
                    if (( (String)jsonObj.get("status") ).equals("0")) {
                        logger.info("responseString :: {}", responseString);
                        
                    } else {
                        throw new Exception("관리자에게 문의하여 주십시오. [" + (String)jsonObj.get("message") + "]");
                        
                    }
                    
                    //                        super.commonDao.update("atx170ukrServiceImpl.updtAtx170err", spParam);
                }
                //                }
                
            } else {
                throw new Exception("메일 재전송에 필요한 정보가 셋팅되지 않았습니다.\n관리자에게 문의하여 주십시오.");
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
    
    /**
     * 연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> getGsBillYN( Map param ) throws Exception {
        return super.commonDao.list("atx170ukrServiceImpl.getGsBillYN", param);
    }
    
}
