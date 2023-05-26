package api.rest.service;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import api.rest.utils.RestUtils;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 그룹웨어 결재정보 UPDATE
 * 
 * @author 박종영
 */
@Service( "appvConfServiceImpl" )
public class AppvConfServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * <pre>
     * 전자결재 상태 조회
     * pStrAuthURCode : 인증사용자ID
     * pStrAprovNo    : 전자결재 번호 (apprManageNo)
     * pStrAuthNum    : 인증코드값
     * </pre>
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String getApprovalStatus_WS() {
        /*
         * Job ID 생성
         */
        String jobId = utils.makeJobID();
        
        Map logParam = new HashMap();
        
        try {
            logParam.put("BATCH_SEQ", jobId);
            logParam.put("BATCH_ID", "IF_0002");           // 전자결재
            super.commonDao.insert("commonServiceImpl.insertLog", logParam);
            
            getApprovalStatus_WS02();
            
            logParam.put("STATUS", "0");
            logParam.put("RESULT_MSG", "SUCC");           // 사용자 정보 인터페이스
            super.commonDao.update("commonServiceImpl.updateLog", logParam);
        } catch (Exception e) {
            logParam.put("STATUS", "1");
            logParam.put("RESULT_MSG", utils.errorMsg(e.getMessage()));
            super.commonDao.update("commonServiceImpl.updateLog", logParam);
        }
        return "";
    }
    
    /**
     * <pre>
     * 전자결재 상태 조회
     * pStrAuthURCode : 인증사용자ID
     * pStrAprovNo    : 전자결재 번호 (apprManageNo)
     * pStrAuthNum    : 인증코드값
     * </pre>
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public int getApprovalStatus_WS02() throws Exception {
        
        Map parameterMap = new HashMap();
        Map map = null;
        int inCnt = 0;
        
        // XML Document 객체 생성
        InputSource is = null;
        Document document = null;
        String result = "";
        
        CloseableHttpClient client = null;
        HttpPost httpPost = null;
        UrlEncodedFormEntity postEntity = null;
        HttpResponse httpResponse = null;
        HttpEntity entity = null;
        XPath xpath = null;
        NodeList cols1 = null;
        
        String responseString = null;
        String accessToken = null;
        
        try {
            
            //--------------------------------------------------------------------------------------------
            
            List<Map<Object, String>> list = super.commonDao.list("appvConfServiceImpl.getApprStatusUrl", parameterMap);
            List<Map<Object, String>> esSlipList = super.commonDao.list("appvConfServiceImpl.getEsSlipHd", parameterMap);
            List<Map<Object, String>> arcList = super.commonDao.list("appvConfServiceImpl.getArc100T", parameterMap);
            
            //String infUrl = "http://ep.joinsdev.net/WebSite/Mobile/Controls/MobileWebServiceExternal.asmx/GetApprovalStatus_WS"; 
            logger.info("rtnList :: {}", list);
            String infUrl = (String)( (Map)list.get(0) ).get("CODE_NAME");
            String loginUser = (String)( (Map)list.get(1) ).get("CODE_NAME");
            
            /*
             * 그룹웨어연계항목 체크
             */
            if (esSlipList.size() > 0) {
                for (Map param : esSlipList) {
                    try {
                        accessToken = getTocken();
                        logger.debug("accessToken :" + accessToken);
                    } catch (Exception e) {
                        throw new Exception("토큰 생성 오류입니다.");
                    }
                    
                    if (accessToken != null) {
                        client = HttpClients.createDefault();
                        httpPost = new HttpPost(infUrl);
                        boolean developer = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
                        if (developer) {
                            parameterMap.put("pStrAprovNo", (String)param.get("GW_KEY_VALUE"));        // 
                            parameterMap.put("pStrAuthURCode", loginUser);
                            parameterMap.put("pStrAuthNum", accessToken);
                            
                            postEntity = new UrlEncodedFormEntity(getParam(parameterMap), "UTF-8");
                            httpPost.setEntity(postEntity);
                            logger.debug("request line:" + httpPost.getRequestLine());
                        } else {
                            httpPost.addHeader("content-type", "application/json");
                            StringBuffer sb = new StringBuffer();
                            sb.append("{");
                            sb.append("\"pStrAprovNo\":\"" + (String)param.get("GW_KEY_VALUE") + "\",");
                            sb.append("\"pStrAuthURCode\":\"" + loginUser + "\",");
                            sb.append("\"pStrAuthNum\":\"" + accessToken + "\"");
                            sb.append("}");
                            
                            logger.debug("sb :: {}", sb.toString());
                            
                            StringEntity userEntity = new StringEntity(sb.toString(), "UTF-8");
                            httpPost.setEntity(userEntity);
                        }
                        
                        httpResponse = client.execute(httpPost);
                        entity = httpResponse.getEntity();
                        if (entity != null) {
                            
                            if (developer) {
                                responseString = EntityUtils.toString(entity).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
                            } else {
                                responseString = EntityUtils.toString(entity);
                                logger.debug("responseString :: {}", responseString);
                                
                                //Map jsonMap = utils.jsonToMap(StringEscapeUtils.unescapeJava(responseString).replaceAll("\"","\\\""));
                                Map jsonMap = utils.jsonToMap(responseString);
                                logger.debug("jsonMap :: {}", jsonMap);
                                responseString = (String)jsonMap.get("d");
                                //System.out.println("responseString :: " + responseString);
                            }
                            
                            logger.debug("responseString :: {}", responseString);
                            if(responseString.indexOf("string") > 0) {
                                try {
                                    // XML Document 객체 생성
                                    is = new InputSource(new StringReader(responseString));
                                    logger.debug("is :: {}", is);
                                    document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
                                    logger.debug("document :: {}", document);
                                    // xpath 생성
                                    xpath = XPathFactory.newInstance().newXPath();
                                    logger.debug("xpath :: {}", xpath);
                                } catch (Exception ee) {
                                    logger.debug("처리할 데이터가 없습니다.");
                                }
                                
                                // NodeList 가져오기 : row 아래에 있는 모든 col1 을 선택
                                try {
                                    // 결과 없음.
                                    cols1 = (NodeList)xpath.evaluate("/string", document, XPathConstants.NODESET);
                                    result = cols1.item(0).getTextContent();
                                    logger.debug("result :: {}", result);
                                    
                                    String[] status = result.split("\\|");
                                    
                                    if (status.length > 1) {
                                        map = new HashMap();
                                        map.put("GW_KEY_VALUE", param.get("GW_KEY_VALUE"));
                                        map.put("GUBUN", "1");        // 그룹웨어연계항목 1:경비신청/2:채권이관신청/3:구매요청/4:정비일지
                                        map.put("STATUS", status[1]);
                                        super.commonDao.queryForObject("appvConfServiceImpl.USP_ACCNT_GWAPP_JS", map);
                                        String rtnCode = ObjUtils.getSafeString(map.get("RTN_CODE"));
                                        String rtnMsg = ObjUtils.getSafeString(map.get("RTN_MSG"));
                                        
                                        logger.debug("rtnCode :: {}, rtnMsg :: {}", rtnCode, rtnMsg);
                                    }
                                } catch (Exception e) {
                                    throw new Exception("경비신청 결재상태 변경 중 오류가 발생하였습니다.");
                                }
                            }
                        }
                    }
                }
            }
            
            /*
             * 채권이관 체크
             */
            if (arcList.size() > 0) {
                for (Map param : arcList) {
                    try {
                        accessToken = getTocken();
                        logger.debug("accessToken :" + accessToken);
                    } catch (Exception e) {
                        throw new Exception("토큰 오류입니다.");
                    }
                    
                    if (accessToken != null) {
                        client = HttpClients.createDefault();
                        httpPost = new HttpPost(infUrl);
                        
                        boolean developer = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
                        if (developer) {
                            parameterMap.put("pStrAprovNo", (String)param.get("GW_RECE_NO"));        // 
                            parameterMap.put("pStrAuthURCode", loginUser);
                            parameterMap.put("pStrAuthNum", accessToken);
                            
                            postEntity = new UrlEncodedFormEntity(getParam(parameterMap), "UTF-8");
                            httpPost.setEntity(postEntity);
                        } else {
                            httpPost.addHeader("content-type", "application/json");
                            StringBuffer sb = new StringBuffer();
                            sb.append("{");
                            sb.append("\"pStrAprovNo\":\"" + (String)param.get("GW_RECE_NO") + "\",");
                            sb.append("\"pStrAuthURCode\":\"" + loginUser + "\",");
                            sb.append("\"pStrAuthNum\":\"" + accessToken + "\"");
                            sb.append("}");
                            StringEntity userEntity = new StringEntity(sb.toString(), "UTF-8");
                            httpPost.setEntity(userEntity);
                        }
                        
                        logger.debug("request line:" + httpPost.getRequestLine());
                        
                        httpResponse = client.execute(httpPost);
                        entity = httpResponse.getEntity();
                        if (entity != null) {
                            if (developer) {
                                responseString = EntityUtils.toString(entity).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
                            } else {
                                responseString = EntityUtils.toString(entity);
                                logger.debug("responseString :: {}", responseString);
                                
                                //Map jsonMap = utils.jsonToMap(StringEscapeUtils.unescapeJava(responseString).replaceAll("\"","\\\""));
                                Map jsonMap = utils.jsonToMap(responseString);
                                //System.out.println("jsonMap :: " + jsonMap);
                                responseString = (String)jsonMap.get("d");
                                //System.out.println("responseString :: " + responseString);
                            }
                            logger.debug("responseString :: " + responseString);
                            if(responseString.indexOf("string") > 0) {
                                try {
                                    
                                    // XML Document 객체 생성
                                    is = new InputSource(new StringReader(responseString));
                                    document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
    
                                    // xpath 생성
                                    xpath = XPathFactory.newInstance().newXPath();
                                    
                                    // NodeList 가져오기 : row 아래에 있는 모든 col1 을 선택
                                    try {
                                        // 결과 없음.
                                        cols1 = (NodeList)xpath.evaluate("/string", document, XPathConstants.NODESET);
                                        result = cols1.item(0).getTextContent();
                                        logger.debug("result :: " + result);
                                        
                                        String[] status = result.split("\\|");
                                        
                                        if (status.length > 1) {
                                            map = new HashMap();
                                            map.put("GW_KEY_VALUE", param.get("GW_RECE_NO"));
                                            map.put("GUBUN", "2");        // 그룹웨어연계항목 1:경비신청/2:채권이관신청/3:구매요청/4:정비일지
                                            map.put("STATUS", status[1]);
                                            
                                            super.commonDao.queryForObject("appvConfServiceImpl.USP_ACCNT_GWAPP_JS", map);
                                            String rtnCode = ObjUtils.getSafeString(map.get("RTN_CODE"));
                                            String rtnMsg = ObjUtils.getSafeString(map.get("RTN_MSG"));
                                            
                                            logger.info("rtnCode :: {}, rtnMsg :: {}", rtnCode, rtnMsg);
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                        throw new Exception("채권이관 결재상태 변경 중 오류가 발생하였습니다.");
                                    }
                                } catch (Exception ee) {
                                    logger.debug("처리할 데이터가 없을 경우 XML 타입으로 데이터가 넘어오지 않음.");
                                }
                            }
                        }
                    }
                }
            }
            
            //--------------------------------------------------------------------------------------------
            
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
        
        return inCnt;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    public String procPnp060T( List list ) throws Exception {
        return "";
    }
    
    @SuppressWarnings( { "rawtypes" } )
    public String procPnp085T( List list ) throws Exception {
        return "";
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String getTocken() throws Exception {
        Map parameterMap = new HashMap();
        
        List rtnList = super.commonDao.list("appvConfServiceImpl.getTokenUrl", parameterMap);
        //String loginUrl = "http://ep.joinsdev.net/WebSite/Mobile/Controls/MobileWebServiceExternal.asmx/SetReAuthenticationNumber";
        logger.debug("rtnList :: {}", rtnList);
        String loginUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String loginUser = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        
        CloseableHttpClient client = HttpClients.createDefault();
        
        HttpPost httpPost = new HttpPost(loginUrl);
        boolean developer = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
        logger.debug("developer :: {}", developer);
        if (developer) {
            parameterMap.put("pStrLogonID", loginUser);
            UrlEncodedFormEntity postEntity = new UrlEncodedFormEntity(getParam(parameterMap), "UTF-8");
            httpPost.setEntity(postEntity);
        } else {
            httpPost.addHeader("content-type", "application/json");
            StringEntity userEntity = new StringEntity("{\"pStrLogonID\":\"" + loginUser + "\"}", "UTF-8");
            httpPost.setEntity(userEntity);
        }
        
        //logger.debug("request line:" + httpPost.getRequestLine());
        String accessToken = "";
        
        // XML Document 객체 생성
        InputSource is = null;
        Document document = null;
        String result = "";
        
        try {
            
            HttpResponse httpResponse = client.execute(httpPost);
            HttpEntity entity = httpResponse.getEntity();
            if (entity != null) {
                String responseString = null;
                
                if (developer) {
                    responseString = EntityUtils.toString(entity).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
                } else {
                    responseString = EntityUtils.toString(entity);
                    //System.out.println("responseString :: " + StringEscapeUtils.unescapeJava(responseString));
                    // XML Document 객체 생성
                    Map jsonMap = utils.jsonToMap(StringEscapeUtils.unescapeJava(responseString));
                    //System.out.println("jsonMap :: " + jsonMap);
                    responseString = (String)jsonMap.get("d");
                    //System.out.println("responseString :: " + responseString);
                }
                
                logger.debug("getTocken() > responseString :: {}", responseString);
                
                // XML Document 객체 생성
                is = new InputSource(new StringReader(responseString));
                document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
                
                // xpath 생성
                XPath xpath = XPathFactory.newInstance().newXPath();
                
                // NodeList 가져오기 : row 아래에 있는 모든 col1 을 선택
                NodeList cols1 = (NodeList)xpath.evaluate("//Return/Result", document, XPathConstants.NODESET);
                NodeList cols2 = (NodeList)xpath.evaluate("//Return/Reason", document, XPathConstants.NODESET);
                
                result = cols1.item(0).getTextContent();
                
                //logger.debug("result :: " + result);
                if (result.equals("true")) {
                    accessToken = cols2.item(0).getTextContent();
                }
                
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (client != null) client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        return accessToken;
    }
    
    @SuppressWarnings( "rawtypes" )
    public static List<NameValuePair> getParam( Map parameterMap ) {
        List<NameValuePair> param = new ArrayList<NameValuePair>();
        Iterator it = parameterMap.entrySet().iterator();
        while (it.hasNext()) {
            Entry parmEntry = (Entry)it.next();
            param.add(new BasicNameValuePair((String)parmEntry.getKey(), (String)parmEntry.getValue()));
        }
        return param;
    }
    
}
