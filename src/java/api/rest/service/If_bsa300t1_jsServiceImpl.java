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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import api.rest.utils.RestUtils;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

/**
 * 그룹웨어 -> MIS 사원정보
 * 
 * @author 박종영
 */
@Service( "if_bsa300t1_jsServiceImpl" )
public class If_bsa300t1_jsServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private RestUtils    utils  = new RestUtils();
    
    /**
     * 그룹웨어 -> MIS 사원정보 조회
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "stdbase" )
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("if_bsa300t1_jsServiceImpl.selectList", param);
    }
    
    /**************************************************************/
    /*********************** Web Service 용 ***********************/
    /**************************************************************/
    
    /**
     * 그룹웨어 -> MIS 사원정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public int infGWtoMIS2() throws Exception {
        int inCnt = 0;
        /*
         * Job ID 생성
         */
        String jobId = utils.makeExcelJobID();
        
        /*
         * Temp 폴더에 데이터를 Insert 한다.
         */
        List<Map> list = getUserInfoList_WS(jobId);
        
        Map tmp = new HashMap();
        deleteMulti(tmp);
        
        for (Map param : list) {
            //logger.info("넘어온 목록 :: {}", param);
            inCnt = inCnt + insertMulti(param);
        }
        
        return inCnt;
    }
    
    /**
     * 그룹웨어 -> MIS 사원정보 저장 ( Web Service 용 )
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @SuppressWarnings( { "rawtypes" } )
    public String saveAll( List<Map> paramList ) throws Exception {
        int intCnt = 0;
        int uptCnt = 0;
        int delCnt = 0;
        int noCnt = 0;
        
        for (Map param : paramList) {
            if ("I".equals((String)param.get("STATUS"))) {
                intCnt = intCnt + insertMulti(param);
            } else if ("U".equals((String)param.get("STATUS"))) {
                uptCnt = intCnt + updateMulti(param);
            } else if ("D".equals((String)param.get("STATUS"))) {
                delCnt = intCnt + deleteMulti(param);
            } else {
                ++noCnt;
            }
        }
        return intCnt + "|" + uptCnt + "|" + delCnt + "|" + noCnt;
        
    }
    
    /**
     * 그룹웨어 -> MIS 사원정보 입력 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int insertMulti( Map paramMap ) throws Exception {
        return super.commonDao.insert("if_bsa300t1_jsServiceImpl.insertMulti", paramMap);
    }
    
    /**
     * 그룹웨어 -> MIS 사원정보 수정 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int updateMulti( Map paramMap ) throws Exception {
        return super.commonDao.update("if_bsa300t1_jsServiceImpl.updateMulti", paramMap);
    }
    
    /**
     * 그룹웨어 -> MIS 사원정보 삭제 ( Web Service 용 )
     * 
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    public int deleteMulti( Map paramMap ) throws Exception {
        return super.commonDao.delete("if_bsa300t1_jsServiceImpl.deleteMulti", paramMap);
    }
    
    /**
     * <pre>
     * INF001 데이터 조회
     * </pre>
     * 
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public List<Map> getUserInfoList_WS( String jobId ) throws Exception {
        Map parameterMap = new HashMap();
        
        List list = super.commonDao.list("if_bsa300t1_jsServiceImpl.getUserInfoUrl", parameterMap);
        //String infUrl = "http://ep.joinsdev.net/WebSite/Mobile/Controls/MobileWebServiceExternal.asmx/GetUserInfoList_WS";        
        logger.info("rtnList :: {}", list);
        String infUrl = (String)( (Map)list.get(0) ).get("CODE_NAME");
        String loginUser = (String)( (Map)list.get(1) ).get("CODE_NAME");
        
        List<Map> rtnList = new ArrayList();
        Map map = null;
        
        // XML Document 객체 생성
        InputSource is = null;
        Document document = null;
        String result = "";
        
        CloseableHttpClient client = HttpClients.createDefault();
        
        try {
            
            String accessToken = getTocken();
            logger.debug("accessToken :" + accessToken);
            
            if (accessToken != null) {
                
                HttpPost httpPost = new HttpPost(infUrl); // HttpPost(testUrl); Map parameterMap = new HashMap();
                boolean developer = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
                if (developer) {
                    parameterMap.put("pStrSearchText", "");
                    parameterMap.put("pStrUR_CODE", loginUser);
                    parameterMap.put("pStrAuthNum", accessToken);
                    UrlEncodedFormEntity postEntity = new UrlEncodedFormEntity(getParam(parameterMap), "UTF-8");
                    httpPost.setEntity(postEntity);
                } else {
                    httpPost.addHeader("content-type", "application/json");
                    StringBuffer sb = new StringBuffer();
                    sb.append("{");
                    sb.append("\"pStrSearchText\":\"\",");
                    sb.append("\"pStrUR_CODE\":\"" + loginUser + "\",");
                    sb.append("\"pStrAuthNum\":\"" + accessToken + "\"");
                    sb.append("}");
                    StringEntity userEntity = new StringEntity(sb.toString(), "UTF-8");
                    httpPost.setEntity(userEntity);
                }
                logger.debug("request line:" + httpPost.getRequestLine());
                HttpResponse httpResponse = client.execute(httpPost);
                HttpEntity entity = httpResponse.getEntity();
                logger.debug("request line:" + entity);
                if (entity != null) {
                    String responseString = null;
                    // String responseString = "<string xmlns=\"http://tempuri.org/\"><Return><Result><![CDATA[true]]></Result><Reason><Items><ItemInfo objectType=\"USER\"><Code><![CDATA[myidis000]]></Code><Name><![CDATA[홍길동]]></Name><JobLevelName><![CDATA[JobLevelName]]></JobLevelName><JobPositionName><![CDATA[JobPositionName]]></JobPositionName><JobTitleName><![CDATA[JobTitleName]]></JobTitleName><PrimaryMail><![CDATA[mymail@joinsdev.net]]></PrimaryMail><PhotoPath><![CDATA[PhotoPath.jpg]]></PhotoPath><Mobile><![CDATA[000-000-2224]]></Mobile><JobType><![CDATA[JobType]]></JobType></ItemInfo></Items></Reason></Return></string>";
                    if (developer) {
                        responseString = EntityUtils.toString(entity).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
                        logger.debug("dev responseString :: " + responseString);
                    } else {
                        responseString = EntityUtils.toString(entity);
                        logger.debug("real responseString :: " + responseString);
                        //Map jsonMap = utils.jsonToMap(StringEscapeUtils.unescapeJava(responseString).replaceAll("\"","\\\""));
                        Map jsonMap = utils.jsonToMap(responseString);
                        //System.out.println("jsonMap :: " + jsonMap);
                        responseString = (String)jsonMap.get("d");
                        //System.out.println("responseString :: " + responseString);
                    }
                    
                    // XML Document 객체 생성
                    is = new InputSource(new StringReader(responseString));
                    document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
                    
                    // xpath 생성
                    XPath xpath = XPathFactory.newInstance().newXPath();
                    
                    // NodeList 가져오기 : row 아래에 있는 모든 col1 을 선택
                    NodeList cols1 = (NodeList)xpath.evaluate("//Return/Result", document, XPathConstants.NODESET);
                    result = cols1.item(0).getTextContent();
                    logger.debug("result :: " + result);
                    
                    NodeList items = null;
                    NodeList itemInfo = null;
                    Element ele = null;
                    
                    if (result.equals("true")) {
                        items = document.getElementsByTagName("ItemInfo"); // 문서에서 region_id 노드를 전부 찾아 배열로 돌려줍니다.
                        
                        logger.debug("nodeLst.getLength() :: " + items.getLength());
                        for (int idx = 0; idx < items.getLength(); idx++) {
                            ele = (Element)items.item(idx); // //fstNmElmntList의 첫번째 노드를 추출 합니다.
                            itemInfo = ele.getChildNodes(); // fstNmElmnt의 하위 노드들 추출
                            //logger.debug("itemInfo.getLength() :: " + itemInfo.getLength());
                            
                            /**
                             * <pre>
                             * <ItemInfo objectType="USER">
                             *     <DN_CODE><![CDATA[CCC]]></DN_CODE>
                             *     <DN_NM><![CDATA[우리회사(본사)]]></DN_NM>
                             *     <GR_CODE><![CDATA[A000000000]]></GR_CODE>
                             *     <GR_NM><![CDATA[대표이사]]></GR_NM>
                             *     <UR_CODE><![CDATA[hong.jildong]]></UR_CODE>
                             *     <UR_NM><![CDATA[홍길동]]></UR_NM>
                             *     <TITLE><![CDATA[대표이사]]></TITLE>
                             *     <POSITION><![CDATA[사장]]></POSITION>
                             *     <EMAIL><![CDATA[hong.jildong@joinsdev.net]]></EMAIL>
                             *     <MOBILE><![CDATA[010-1111-2222]]></MOBILE>
                             * </ItemInfo>
                             * </pre>
                             */
                            
                            map = new HashMap();
                            map.put("JOB_ID", jobId);
                            map.put("DN_CODE", itemInfo.item(0).getTextContent());
                            map.put("DN_NM", itemInfo.item(1).getTextContent());
                            map.put("GR_CODE", itemInfo.item(2).getTextContent());
                            map.put("GR_NM", itemInfo.item(3).getTextContent());
                            map.put("UR_CODE", itemInfo.item(4).getTextContent());
                            map.put("UR_NM", itemInfo.item(5).getTextContent());
                            map.put("TITLE", itemInfo.item(6).getTextContent());
                            map.put("POSITION", itemInfo.item(7).getTextContent());
                            map.put("EMAIL", itemInfo.item(8).getTextContent());
                            map.put("MOBILE", itemInfo.item(9).getTextContent());
                            map.put("S_USER_ID", "WebService");
                            /*
                             * logger.debug("Code :: " + itemInfo.item(0).getTextContent()); logger.debug("Name :: " + itemInfo.item(1).getTextContent()); logger.debug("JobLevelName :: " + itemInfo.item(2).getTextContent()); logger.debug("JobPositionName :: " + itemInfo.item(3).getTextContent()); logger.debug("JobTitleName :: " + itemInfo.item(4).getTextContent()); logger.debug("PrimaryMail :: " + itemInfo.item(5).getTextContent()); //logger.debug("PhotoPath :: " + itemInfo.item(6).getTextContent()); logger.debug("Mobile :: " + itemInfo.item(7).getTextContent()); logger.debug("JobType :: " + itemInfo.item(8).getTextContent());
                             */
                            rtnList.add(map);
                        }
                    }
                    
                }
            }
            
        } catch (IOException e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            try {
                if (client != null) client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        return rtnList;
    }
    
    /**
     * <pre>
     * 그룹웨어 토큰 획득
     * </pre>
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    public String getTocken() throws Exception {
        Map parameterMap = new HashMap();
        
        List rtnList = super.commonDao.list("if_bsa300t1_jsServiceImpl.getTokenUrl", parameterMap);
        //String loginUrl = "http://ep.joinsdev.net/WebSite/Mobile/Controls/MobileWebServiceExternal.asmx/SetReAuthenticationNumber";
        logger.info("rtnList :: {}", rtnList);
        String loginUrl = (String)( (Map)rtnList.get(0) ).get("CODE_NAME");
        String loginUser = (String)( (Map)rtnList.get(1) ).get("CODE_NAME");
        
        CloseableHttpClient client = HttpClients.createDefault();
        
        HttpPost httpPost = new HttpPost(loginUrl);
        boolean developer = ConfigUtil.getBooleanValue("system.isDevelopServer", false);
        logger.info("developer :: {}", developer);
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
            throw new Exception(e.getMessage());
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
